"""social service —— 动态 / 搜索 / 关注 / 个人主页。"""
from __future__ import annotations

import json
from typing import Any

from app.db.pool import query, execute
from app.errors import bad_request, forbidden, not_found
from app.utils.activity import log_activity
from app.utils.serialize import serialize_user, serialize_book


BOOK_FIELDS_STR = (
    "b.slug as book_slug, b.title as book_title, b.author as book_author, "
    "b.color as book_color, b.ink as book_ink, b.art as book_art"
)


def _activity_row(row: dict[str, Any]) -> dict[str, Any]:
    payload = row.get("payload")
    if isinstance(payload, str):
        try:
            payload = json.loads(payload)
        except Exception:
            payload = {}
    return {
        "id": str(row["id"]),
        "type": row["type"],
        "payload": payload,
        "createdAt": row["created_at"].isoformat().replace("+00:00", "Z") if row.get("created_at") else None,
        "user": {
            "id": str(row["user_id"]),
            "handle": row["handle"],
            "displayName": row["display_name"],
            "avatarColor": row["avatar_color"],
        },
        "book": {
            "slug": row["book_slug"],
            "title": row["book_title"],
            "author": row["book_author"],
            "color": row["book_color"],
            "ink": row["book_ink"],
            "art": row["book_art"],
        } if row.get("book_slug") else None,
    }


async def get_feed(viewer_id: str | None, opts: dict[str, Any]) -> dict[str, Any]:
    scope = opts.get("scope", "global")
    limit = min(50, max(1, int(opts.get("limit") or 30)))

    params: list[Any] = [viewer_id]
    conditions = [
        "(u.is_private = false or u.id = $1 or exists ("
        "  select 1 from follows pf where pf.follower_id = $1 and pf.following_id = u.id"
        "))"
    ]

    if scope == "following":
        if not viewer_id:
            raise forbidden("登录后可查看关注动态")
        conditions.append(
            "(a.user_id = $1 or exists ("
            "  select 1 from follows f where f.follower_id = $1 and f.following_id = a.user_id"
            "))"
        )

    params.append(limit)
    rows = await query(
        f"select a.*, u.handle, u.display_name, u.avatar_color, {BOOK_FIELDS_STR} "
        f"from activities a "
        f"join users u on u.id = a.user_id "
        f"left join books b on b.id = a.book_id "
        f"where {' and '.join(conditions)} "
        f"order by a.created_at desc "
        f"limit ${len(params)}",
        params,
    )
    return {"items": [_activity_row(dict(r)) for r in rows]}


async def get_profile(handle: str, viewer_id: str | None) -> dict[str, Any]:
    rows = await query(
        "select u.*, "
        "(select count(*)::int from follows f where f.following_id = u.id) as followers_count, "
        "(select count(*)::int from follows f where f.follower_id = u.id) as following_count, "
        "(select count(*)::int from user_books ub where ub.user_id = u.id) as books_count, "
        "(select count(*)::int from user_books ub where ub.user_id = u.id and ub.status = 'finished') as finished_count, "
        "(select count(*)::int from reviews r where r.user_id = u.id) as reviews_count, "
        "(select coalesce(sum(minutes), 0)::int from reading_sessions s where s.user_id = u.id) as minutes, "
        "exists (select 1 from follows f where f.follower_id = $2 and f.following_id = u.id) as is_following "
        "from users u where u.handle = $1",
        [handle, viewer_id],
    )
    if not rows:
        raise not_found("这位读者不存在")
    row = dict(rows[0])

    user_dict = {
        "id": row["id"], "handle": row["handle"], "display_name": row["display_name"],
        "bio": row.get("bio", ""), "avatar_color": row.get("avatar_color", "#294b3c"),
        "location": row.get("location", ""), "website": row.get("website", ""),
        "is_private": row.get("is_private", False), "created_at": row.get("created_at"),
        "followers_count": row.get("followers_count", 0),
        "following_count": row.get("following_count", 0),
        "books_count": row.get("books_count", 0),
    }

    user_out = serialize_user(user_dict)
    if user_out:
        user_out["isFollowing"] = bool(row.get("is_following"))

    is_self = viewer_id and str(row["id"]) == viewer_id
    restricted = row.get("is_private") and not is_self and not bool(row.get("is_following"))

    return {
        "user": user_out,
        "stats": {
            "followers": int(row.get("followers_count") or 0),
            "following": int(row.get("following_count") or 0),
            "books": int(row.get("books_count") or 0),
            "finished": int(row.get("finished_count") or 0),
            "reviews": int(row.get("reviews_count") or 0),
            "minutes": int(row.get("minutes") or 0),
        },
        "isSelf": bool(is_self),
        "restricted": bool(restricted),
        "isFollowing": bool(row.get("is_following")),
    }


async def get_profile_shelf(handle: str, viewer_id: str | None) -> dict[str, Any]:
    profile = await get_profile(handle, viewer_id)
    if profile["restricted"]:
        return {"items": [], "restricted": True}

    rows = await query(
        "select ub.status, ub.progress, b.* "
        "from user_books ub "
        "join books b on b.id = ub.book_id "
        "join users u on u.id = ub.user_id "
        "where u.handle = $1 and ub.status <> 'dnf' "
        "order by ub.updated_at desc "
        "limit 40",
        [handle],
    )
    items = []
    for r in rows:
        d = dict(r)
        d["id"] = int(d["id"])
        book = serialize_book(d) or {}
        book["status"] = d["status"]
        book["progress"] = int(d["progress"]) if d.get("progress") is not None else 0
        items.append(book)
    return {"items": items, "restricted": False}


async def get_profile_content(handle: str, viewer_id: str | None, type_: str) -> dict[str, Any]:
    profile = await get_profile(handle, viewer_id)
    if profile["restricted"]:
        return {"items": [], "restricted": True}

    if type_ == "lists":
        from app.services.lists import list_lists
        result = await list_lists(viewer_id, {"handle": handle})
        return {**result, "restricted": False}
    if type_ == "reviews":
        from app.services.reviews import list_reviews
        result = await list_reviews(viewer_id, {"handle": handle, "pageSize": 10})
        return {**result, "restricted": False}
    return {"items": [], "restricted": False}


async def toggle_follow(follower_id: str, handle: str) -> dict[str, Any]:
    target = await query("select id from users where handle = $1", [handle])
    if not target:
        raise not_found("这位读者不存在")
    following_id = target[0]["id"]
    if str(following_id) == str(follower_id):
        raise bad_request("不能关注自己")

    removed = await query(
        "delete from follows where follower_id = $1 and following_id = $2 returning 1",
        [follower_id, following_id],
    )
    if removed:
        return {"following": False}

    await execute(
        "insert into follows (follower_id, following_id) values ($1, $2)",
        [follower_id, following_id],
    )
    await execute(
        "insert into notifications (user_id, type, actor_id, payload) values ($1, 'follow', $2, '{}'::jsonb)",
        [following_id, follower_id],
    )
    return {"following": True}


async def suggestions(viewer_id: str) -> dict[str, Any]:
    rows = await query(
        "select u.id, u.handle, u.display_name, u.avatar_color, u.bio, "
        "(select count(*)::int from user_books ub where ub.user_id = u.id) as books_count, "
        "(select count(*)::int from follows f where f.following_id = u.id) as followers_count, "
        "(select count(*)::int from activities a where a.user_id = u.id) as activity_count "
        "from users u "
        "where u.id <> $1 "
        "and not exists ("
        "  select 1 from follows f where f.follower_id = $1 and f.following_id = u.id"
        ") "
        "order by activity_count desc, followers_count desc "
        "limit 4",
        [viewer_id],
    )
    items = []
    for r in rows:
        d = dict(r)
        user = serialize_user({
            "id": d["id"], "handle": d["handle"], "display_name": d["display_name"],
            "bio": d.get("bio", ""), "avatar_color": d["avatar_color"],
            "created_at": None,
            "books_count": d.get("books_count"),
            "followers_count": d.get("followers_count"),
        })
        items.append(user)
    return {"items": items}


async def search_readers(q: str | None) -> dict[str, Any]:
    if not (q or "").strip():
        return {"items": []}
    rows = await query(
        "select u.id, u.handle, u.display_name, u.avatar_color, u.bio, "
        "(select count(*)::int from user_books ub where ub.user_id = u.id) as books_count, "
        "(select count(*)::int from follows f where f.following_id = u.id) as followers_count "
        "from users u "
        "where u.handle ilike $1 or u.display_name ilike $1 "
        "order by followers_count desc limit 10",
        [f"%{q.strip()}%"],
    )
    items = []
    for r in rows:
        d = dict(r)
        items.append(serialize_user({
            "id": d["id"], "handle": d["handle"], "display_name": d["display_name"],
            "bio": d.get("bio", ""), "avatar_color": d["avatar_color"],
            "created_at": None,
            "books_count": d.get("books_count"),
            "followers_count": d.get("followers_count"),
        }))
    return {"items": items}
