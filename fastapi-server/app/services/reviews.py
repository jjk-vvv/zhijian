"""reviews service —— 书评列表 / 增删改 / 点赞 / 评论。"""
from __future__ import annotations

import asyncio
import json
from typing import Any

from app.db.pool import query, with_transaction
from app.errors import not_found
from app.utils.serialize import serialize_review, paginated


SELECT = (
    "select r.*, "
    "u.handle as user_handle, u.display_name as user_display_name, u.avatar_color as user_avatar_color, "
    "b.slug as book_slug, b.title as book_title, b.author as book_author, "
    "b.color as book_color, b.ink as book_ink, b.art as book_art, "
    "exists (select 1 from review_likes rl "
    "         where rl.review_id = r.id and rl.user_id = $1) as liked "
    "from reviews r "
    "join users u on u.id = r.user_id "
    "join books b on b.id = r.book_id"
)


async def list_reviews(viewer_id: str | None, raw_query: dict[str, Any]) -> dict[str, Any]:
    page = max(1, int(raw_query.get("page") or 1))
    page_size = min(50, max(1, int(raw_query.get("pageSize") or 12)))
    offset = (page - 1) * page_size

    conditions: list[str] = []
    params: list[Any] = [viewer_id]  # $1 for EXISTS subquery
    effective_viewer = viewer_id

    if raw_query.get("book"):
        params.append(raw_query["book"])
        conditions.append(f"b.slug = ${len(params)}")
    if raw_query.get("handle"):
        params.append(raw_query["handle"])
        conditions.append(f"u.handle = ${len(params)}")
    if raw_query.get("scope") == "following" and effective_viewer:
        conditions.append(
            f"exists (select 1 from follows f where f.follower_id = $1 and f.following_id = r.user_id)"
        )
    if raw_query.get("minRating"):
        params.append(float(raw_query["minRating"]))
        conditions.append(f"r.rating >= ${len(params)}")

    where = f"where {' and '.join(conditions)}" if conditions else ""
    order = (
        "r.likes_count desc, r.created_at desc"
        if raw_query.get("sort") == "popular"
        else "r.created_at desc"
    )

    rows, count_rows = await asyncio.gather(
        query(
            f"{SELECT} {where} order by {order} "
            f"limit ${len(params) + 1} offset ${len(params) + 2}",
            params + [page_size, offset],
        ),
        query(
            "select count(*)::int as total from reviews r "
            "join users u on u.id = r.user_id "
            "join books b on b.id = r.book_id "
            f"where ($1::uuid is null or true) "
            f"{'and ' + ' and '.join(conditions) if conditions else ''}",
            params,
        ),
    )

    items = []
    for r in rows:
        d = dict(r)
        d["liked"] = bool(d.get("liked"))
        items.append(serialize_review(d))
    total = count_rows[0]["total"] if count_rows else 0
    return paginated(items, page, page_size, total)


async def upsert_review(user_id: str, slug: str, data: dict[str, Any]) -> dict[str, Any]:
    book = await query("select id from books where slug = $1", [slug])
    if not book:
        raise not_found("这本书不在书库中")
    book_id = book[0]["id"]

    async def _inner(conn):
        saved = await conn.fetch(
            "insert into reviews (user_id, book_id, rating, title, content, contains_spoilers) "
            "values ($1, $2, $3, $4, $5, $6) "
            "on conflict (user_id, book_id) do update "
            "  set rating = excluded.rating, "
            "      title = excluded.title, "
            "      content = excluded.content, "
            "      contains_spoilers = excluded.contains_spoilers "
            "returning *, (xmax = 0) as inserted",
            user_id, book_id,
            float(data["rating"]),
            data.get("title") or "",
            data.get("content") or "",
            bool(data.get("containsSpoilers")),
        )
        await conn.execute(
            "insert into user_books (user_id, book_id, status, progress, started_at, finished_at) "
            "values ($1, $2, 'finished', 100, now(), now()) "
            "on conflict (user_id, book_id) do nothing",
            user_id, book_id,
        )
        if bool(saved[0]["inserted"]):
            await conn.execute(
                "insert into activities (user_id, type, book_id, payload) values ($1, 'review', $2, $3)",
                user_id, book_id,
                json.dumps({"rating": float(data["rating"]), "title": data.get("title", "")}),
            )
        return saved[0]

    result = await with_transaction(_inner)
    review_rows = await query(f"{SELECT} where r.id = $2", [user_id, result["id"]])
    return serialize_review(dict(review_rows[0]))


async def delete_review(user_id: str, review_id: str) -> None:
    deleted = await query(
        "delete from reviews where id = $1 and user_id = $2 returning 1",
        [review_id, user_id],
    )
    if not deleted:
        raise not_found("书评不存在")


async def toggle_like(user_id: str, review_id: str) -> dict[str, Any]:
    async def _inner(conn):
        review = await conn.fetchrow(
            "select user_id, book_id from reviews where id = $1", review_id
        )
        if review is None:
            raise not_found("书评不存在")

        removed = await conn.fetch(
            "delete from review_likes where review_id = $1 and user_id = $2 returning 1",
            review_id, user_id,
        )
        liked = False
        if not removed:
            await conn.execute(
                "insert into review_likes (review_id, user_id) values ($1, $2)",
                review_id, user_id,
            )
            liked = True
            if str(review["user_id"]) != user_id:
                await conn.execute(
                    "insert into notifications (user_id, type, actor_id, payload) "
                    "values ($1, 'like', $2, $3)",
                    review["user_id"], user_id,
                    json.dumps({"reviewId": str(review_id)}),
                )

        count_rows = await conn.fetch(
            "select count(*)::int as total from review_likes where review_id = $1",
            review_id,
        )
        count = count_rows[0]["total"]
        await conn.execute(
            "update reviews set likes_count = $1 where id = $2",
            count, review_id,
        )
        return {"liked": liked, "likesCount": count}

    return await with_transaction(_inner)


async def list_comments(review_id: str) -> dict[str, Any]:
    rows = await query(
        "select c.*, u.handle, u.display_name, u.avatar_color "
        "from comments c join users u on u.id = c.user_id "
        "where c.review_id = $1 "
        "order by c.created_at asc limit 200",
        [review_id],
    )
    items = []
    for r in rows:
        d = dict(r)
        items.append({
            "id": str(d["id"]),
            "content": d["content"],
            "createdAt": d["created_at"].isoformat().replace("+00:00", "Z") if d.get("created_at") else None,
            "user": {
                "id": str(d["user_id"]),
                "handle": d["handle"],
                "displayName": d["display_name"],
                "avatarColor": d["avatar_color"],
            },
        })
    return {"items": items}


async def add_comment(user_id: str, review_id: str, content: str) -> dict[str, Any]:
    async def _inner(conn):
        review = await conn.fetchrow(
            "select user_id from reviews where id = $1", review_id
        )
        if review is None:
            raise not_found("书评不存在")

        comment_rows = await conn.fetch(
            "insert into comments (review_id, user_id, content) values ($1, $2, $3) returning *",
            review_id, user_id, content,
        )
        count_rows = await conn.fetch(
            "select count(*)::int as total from comments where review_id = $1",
            review_id,
        )
        await conn.execute(
            "update reviews set comments_count = $1 where id = $2",
            count_rows[0]["total"], review_id,
        )
        if str(review["user_id"]) != user_id:
            await conn.execute(
                "insert into notifications (user_id, type, actor_id, payload) values ($1, 'comment', $2, $3)",
                review["user_id"], user_id,
                json.dumps({"reviewId": str(review_id), "excerpt": content[:60]}),
            )
        user_row = await conn.fetchrow(
            "select handle, display_name, avatar_color from users where id = $1",
            user_id,
        )
        return {
            "id": str(comment_rows[0]["id"]),
            "content": comment_rows[0]["content"],
            "createdAt": comment_rows[0]["created_at"].isoformat().replace("+00:00", "Z")
                         if comment_rows[0].get("created_at") else None,
            "commentsCount": count_rows[0]["total"],
            "user": {
                "id": str(user_id),
                "handle": user_row["handle"],
                "displayName": user_row["display_name"],
                "avatarColor": user_row["avatar_color"],
            },
        }

    return await with_transaction(_inner)
