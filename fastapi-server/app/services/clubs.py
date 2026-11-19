"""clubs service —— 书友会。"""
from __future__ import annotations

import asyncio
import json
import random
import re
from typing import Any

from app.db.pool import query, with_transaction, execute
from app.errors import bad_request, forbidden, not_found
from app.utils.activity import log_activity


SLUG_RE = re.compile(r"^[a-z0-9-]{3,48}$")


SELECT = (
    "select c.*, "
    "u.handle as owner_handle, u.display_name as owner_display_name, "
    "b.slug as book_slug, b.title as book_title, b.author as book_author, "
    "b.color as book_color, b.ink as book_ink, b.art as book_art, "
    "(select count(*)::int from club_members cm where cm.club_id = c.id) as member_count, "
    "exists ("
    "  select 1 from club_members cm where cm.club_id = c.id and cm.user_id = $1"
    ") as joined "
    "from clubs c "
    "join users u on u.id = c.owner_id "
    "left join books b on b.id = c.book_id"
)


def _club_row(row: dict[str, Any]) -> dict[str, Any]:
    return {
        "id": str(row["id"]),
        "name": row["name"],
        "slug": row["slug"],
        "description": row["description"],
        "isPrivate": bool(row.get("is_private", False)),
        "memberCount": int(row.get("member_count") or 0),
        "joined": bool(row.get("joined", False)),
        "owner": {
            "id": str(row["owner_id"]),
            "handle": row["owner_handle"],
            "displayName": row["owner_display_name"],
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


async def list_clubs(viewer_id: str | None) -> dict[str, Any]:
    rows = await query(
        f"{SELECT} "
        f"where c.is_private = false "
        f"   or exists (select 1 from club_members cm where cm.club_id = c.id and cm.user_id = $1) "
        f"order by member_count desc, c.created_at desc",
        [viewer_id],
    )
    return {"items": [_club_row(dict(r)) for r in rows]}


async def get_club(slug: str, viewer_id: str | None) -> dict[str, Any]:
    rows = await query(f"{SELECT} where c.slug = $2", [viewer_id, slug])
    if not rows:
        raise not_found("书友会不存在")
    row = dict(rows[0])

    members, posts = await asyncio.gather(
        query(
            "select u.id, u.handle, u.display_name, u.avatar_color, cm.role, cm.joined_at "
            "from club_members cm join users u on u.id = cm.user_id "
            "where cm.club_id = $1 "
            "order by case cm.role when 'owner' then 0 else 1 end, cm.joined_at "
            "limit 12",
            [row["id"]],
        ),
        query(
            "select p.*, u.handle, u.display_name, u.avatar_color "
            "from club_posts p join users u on u.id = p.user_id "
            "where p.club_id = $1 "
            "order by p.created_at desc limit 30",
            [row["id"]],
        ),
    )

    members_out = []
    for r in members:
        d = dict(r)
        members_out.append({
            "id": str(d["id"]),
            "handle": d["handle"],
            "displayName": d["display_name"],
            "avatarColor": d["avatar_color"],
            "role": d["role"],
        })

    posts_out = []
    for r in posts:
        d = dict(r)
        posts_out.append({
            "id": str(d["id"]),
            "content": d["content"],
            "page": d.get("page"),
            "createdAt": d["created_at"].isoformat().replace("+00:00", "Z") if d.get("created_at") else None,
            "user": {
                "id": str(d["user_id"]),
                "handle": d["handle"],
                "displayName": d["display_name"],
                "avatarColor": d["avatar_color"],
            },
        })

    return {
        "club": _club_row(row),
        "members": members_out,
        "posts": posts_out,
    }


async def create_club(user_id: str, data: dict[str, Any]) -> dict[str, Any]:
    slug = (data.get("slug") or "").strip() or f"club-{''.join(random.choice('abcdefghijklmnopqrstuvwxyz0123456789') for _ in range(6))}"
    if data.get("slug") and not SLUG_RE.match(data["slug"].strip()):
        raise bad_request("标识只能包含小写字母、数字和连字符")

    book_id = None
    if data.get("bookSlug"):
        book = await query("select id from books where slug = $1", [data["bookSlug"]])
        if not book:
            raise not_found("共读书目不存在")
        book_id = book[0]["id"]

    async def _inner(conn):
        club_rows = await conn.fetch(
            "insert into clubs (name, slug, description, book_id, is_private, owner_id) "
            "values ($1, $2, $3, $4, $5, $6) returning *",
            data["name"], slug, data.get("description") or "",
            book_id, bool(data.get("isPrivate")), user_id,
        )
        club_id = club_rows[0]["id"]
        await conn.execute(
            "insert into club_members (club_id, user_id, role) values ($1, $2, 'owner')",
            club_id, user_id,
        )
        await conn.execute(
            "insert into activities (user_id, type, book_id, payload) values ($1, 'club_join', $2, $3)",
            user_id, book_id,
            json.dumps({"clubId": str(club_id), "title": club_rows[0]["name"]}),
        )
        return club_rows[0]

    created = await with_transaction(_inner)
    result = await query(f"{SELECT} where c.id = $2", [user_id, created["id"]])
    return _club_row(dict(result[0]))


async def toggle_membership(user_id: str, slug: str) -> dict[str, Any]:
    club = await query("select id, owner_id, is_private from clubs where slug = $1", [slug])
    if not club:
        raise not_found("书友会不存在")
    club_id = club[0]["id"]
    owner_id = club[0]["owner_id"]

    if str(owner_id) == str(user_id):
        raise bad_request("创建者不能退出自己的书友会")

    removed = await query(
        "delete from club_members where club_id = $1 and user_id = $2 returning 1",
        [club_id, user_id],
    )
    if removed:
        return {"joined": False}

    if club[0]["is_private"]:
        raise forbidden("这是私密书友会，暂不接受直接加入")

    await execute(
        "insert into club_members (club_id, user_id) values ($1, $2)",
        [club_id, user_id],
    )
    await log_activity(user_id, "club_join", None, {"clubId": str(club_id)})
    return {"joined": True}


async def create_post(user_id: str, slug: str, data: dict[str, Any]) -> dict[str, Any]:
    club = await query("select id, owner_id, is_private from clubs where slug = $1", [slug])
    if not club:
        raise not_found("书友会不存在")
    club_id = club[0]["id"]

    member = await query(
        "select 1 from club_members where club_id = $1 and user_id = $2",
        [club_id, user_id],
    )
    if not member:
        raise forbidden("加入书友会后才能参与讨论")

    rows = await query(
        "insert into club_posts (club_id, user_id, content, page) values ($1, $2, $3, $4) returning *",
        [club_id, user_id, data["content"], data.get("page")],
    )
    post = dict(rows[0])

    await execute(
        "insert into notifications (user_id, type, actor_id, payload) "
        "select cm.user_id, 'club_post', $1, $2 "
        "from club_members cm "
        "where cm.club_id = $3 and cm.user_id <> $1",
        [user_id, json.dumps({"clubId": str(club_id), "clubSlug": slug,
                              "excerpt": data["content"][:60]}), club_id],
    )

    user_row = await query("select handle, display_name, avatar_color from users where id = $1", [user_id])
    return {
        "id": str(post["id"]),
        "content": post["content"],
        "page": post.get("page"),
        "createdAt": post["created_at"].isoformat().replace("+00:00", "Z") if post.get("created_at") else None,
        "user": {
            "id": str(user_id),
            "handle": user_row[0]["handle"],
            "displayName": user_row[0]["display_name"],
            "avatarColor": user_row[0]["avatar_color"],
        },
    }


async def delete_post(user_id: str, slug: str, post_id: str) -> None:
    deleted = await query(
        "delete from club_posts p using clubs c "
        "where p.club_id = c.id and c.slug = $1 and p.id = $2 and p.user_id = $3 returning 1",
        [slug, post_id, user_id],
    )
    if not deleted:
        raise not_found("帖子不存在或无权删除")
