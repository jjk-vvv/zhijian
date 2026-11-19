"""me service —— 个人资料 / 数据导出 / 旧版导入 / 账号注销。"""
from __future__ import annotations

import asyncio
import json
import re
from datetime import datetime, timezone
from typing import Any

import bcrypt as _bcrypt

from app.db.pool import query
from app.errors import bad_request, unauthorized
from app.utils.serialize import serialize_user


def _verify_pw(password: str, hashed: str) -> bool:
    try:
        return _bcrypt.checkpw(password.encode("utf-8"), hashed.encode("utf-8"))
    except (ValueError, TypeError):
        return False

AVATAR_COLOR_RE = re.compile(r"^#[0-9a-fA-F]{6}$")


async def update_profile(user_id: str, data: dict[str, Any]) -> dict[str, Any]:
    rows = await query(
        "update users set "
        "display_name = coalesce($1, display_name), "
        "handle = coalesce($2, handle), "
        "bio = coalesce($3, bio), "
        "location = coalesce($4, location), "
        "website = coalesce($5, website), "
        "avatar_color = coalesce($6, avatar_color), "
        "is_private = coalesce($7, is_private) "
        "where id = $8 "
        "returning *",
        [
            data.get("displayName"),
            data.get("handle"),
            data.get("bio"),
            data.get("location"),
            data.get("website"),
            data.get("avatarColor"),
            data.get("isPrivate"),
            user_id,
        ],
    )
    return serialize_user(dict(rows[0]), include_email=True)


async def export_data(user_id: str) -> dict[str, Any]:
    profile, shelf, notes, highlights, reviews, sessions, goals, lists, following = await asyncio.gather(
        query("select * from users where id = $1", [user_id]),
        query(
            "select b.slug, ub.status, ub.progress, ub.started_at, ub.finished_at "
            "from user_books ub join books b on b.id = ub.book_id "
            "where ub.user_id = $1 order by ub.created_at",
            [user_id],
        ),
        query(
            "select b.slug as book_slug, n.title, n.content, n.type, n.page, n.is_private, n.created_at "
            "from notes n join books b on b.id = n.book_id "
            "where n.user_id = $1 order by n.created_at",
            [user_id],
        ),
        query(
            "select b.slug as book_slug, h.quote, h.page, h.note, h.is_private, h.created_at "
            "from highlights h join books b on b.id = h.book_id "
            "where h.user_id = $1 order by h.created_at",
            [user_id],
        ),
        query(
            "select b.slug as book_slug, r.rating, r.title, r.content, r.contains_spoilers, r.created_at "
            "from reviews r join books b on b.id = r.book_id "
            "where r.user_id = $1 order by r.created_at",
            [user_id],
        ),
        query(
            "select b.slug as book_slug, s.minutes, s.pages, "
            "to_char(s.session_date, 'YYYY-MM-DD') as date, s.note "
            "from reading_sessions s join books b on b.id = s.book_id "
            "where s.user_id = $1 order by s.session_date",
            [user_id],
        ),
        query("select year, target_books, target_minutes from goals where user_id = $1", [user_id]),
        query("select id, title, description, is_public from lists where user_id = $1", [user_id]),
        query(
            "select u.handle from follows f join users u on u.id = f.following_id "
            "where f.follower_id = $1",
            [user_id],
        ),
    )

    list_items_list = []
    for list_row in lists:
        li_rows = await query(
            "select b.slug, li.note, li.position "
            "from list_items li join books b on b.id = li.book_id "
            "where li.list_id = $1 order by li.position",
            [list_row["id"]],
        )
        list_items_list.append({
            "title": list_row["title"],
            "description": list_row["description"],
            "isPublic": list_row["is_public"],
            "items": [dict(r) for r in li_rows],
        })

    def _to_rows(rows):
        out = []
        for r in rows:
            d = dict(r)
            for k in ("created_at", "updated_at", "started_at", "finished_at"):
                if k in d and d[k] is not None:
                    d[k] = d[k].isoformat().replace("+00:00", "Z")
            if k in d and isinstance(d[k], datetime):
                pass
            out.append(d)
        return out

    now_iso = datetime.now(timezone.utc).replace(tzinfo=None).isoformat() + "Z"

    return {
        "exportedAt": now_iso,
        "profile": serialize_user(dict(profile[0]), include_email=True),
        "shelf": _to_rows(shelf),
        "notes": _to_rows(notes),
        "highlights": _to_rows(highlights),
        "reviews": _to_rows(reviews),
        "sessions": _to_rows(sessions),
        "goals": [dict(r) for r in goals],
        "lists": list_items_list,
        "following": [r["handle"] for r in following],
    }


async def import_legacy(user_id: str, payload: dict[str, Any]) -> dict[str, Any]:
    from app.services.shelf import import_legacy_library
    return await import_legacy_library(user_id, payload)


async def delete_account(user_id: str, password: str) -> None:
    rows = await query("select password_hash from users where id = $1", [user_id])
    if not rows:
        raise unauthorized()
    if not _verify_pw(password, rows[0]["password_hash"]):
        raise bad_request("密码不正确")
    await query("delete from users where id = $1 returning 1", [user_id])
