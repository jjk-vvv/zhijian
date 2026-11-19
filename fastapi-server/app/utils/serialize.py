"""把数据库行（asyncpg.Record，snake_case）转成前端需要的 camelCase 字典。

替代 Express 的 ``server/src/utils/serialize.js``。所有 service 返回的数据
最终都要走这里一遍，保证响应形状和 Express 版完全一致。

时间字段统一输出 ISO 字符串（UTC），和 Express 版 JSON.stringify(Date) 的
输出格式 ``2026-11-19T08:00:00.000Z`` 一致。
"""

from __future__ import annotations

import json
from datetime import datetime, date
from uuid import UUID

from asyncpg import Record


# ----------------- 通用工具 -----------------


def _camel(name: str) -> str:
    parts = name.split("_")
    return parts[0] + "".join(p.capitalize() for p in parts[1:])


def _iso(value) -> str | None:
    if value is None:
        return None
    if isinstance(value, datetime):
        return value.isoformat().replace("+00:00", "Z")
    if isinstance(value, date):
        return value.isoformat()
    return str(value)


def _str(value) -> str | None:
    """把 UUID / bytes 等转成前端能看懂的字符串。"""
    if value is None:
        return None
    if isinstance(value, UUID):
        return str(value)
    return value


def record_to_dict(row: Record | None) -> dict | None:
    if row is None:
        return None
    return {key: row[key] for key in row.keys()}


def rows_to_dicts(rows: list[Record]) -> list[dict]:
    return [record_to_dict(r) for r in rows]


# ----------------- 公共实体序列化 -----------------


def serialize_user(row: Record | dict | None, *, include_email: bool = False) -> dict | None:
    """对应用户资料（可公开版），是否包含 email 由 include_email 控制。

    Express 版：serialize.js 里的 serializeUser。
    """
    if row is None:
        return None
    out = {
        "id": _str(row.get("id")),
        "handle": row.get("handle"),
        "displayName": row.get("display_name"),
        "bio": row.get("bio", ""),
        "avatarColor": row.get("avatar_color", "#294b3c"),
        "location": row.get("location", ""),
        "website": row.get("website", ""),
        "isPrivate": bool(row.get("is_private", False)),
        "createdAt": _iso(row.get("created_at")),
    }
    if include_email:
        out["email"] = row.get("email")
    for opt in ("followers_count", "following_count", "is_following", "books_count"):
        if opt in row:
            out[_camel(opt)] = int(row[opt]) if row[opt] is not None else 0
    # is_following 可能是 NULL / bool
    if "is_following" in row and row.get("is_following") is not None:
        out["isFollowing"] = bool(row["is_following"])
    return out


def serialize_book(row: Record | dict | None) -> dict | None:
    if row is None:
        return None
    out = {
        "id": row.get("id"),  # serial → 数字
        "slug": row.get("slug"),
        "title": row.get("title"),
        "english": row.get("english", ""),
        "author": row.get("author"),
        "category": row.get("category"),
        "pages": row.get("pages", 0),
        "publishedYear": row.get("published_year"),
        "color": row.get("color", "#3e5b48"),
        "ink": row.get("ink", "#eee8d5"),
        "art": row.get("art", "lake"),
        "subtitle": row.get("subtitle", ""),
        "tag": row.get("tag", ""),
        "description": row.get("description", ""),
        "recommendation": row.get("recommendation", ""),
        "ratingAvg": float(row.get("rating_avg") or 0),
        "ratingCount": int(row.get("rating_count") or 0),
        "createdAt": _iso(row.get("created_at")),
    }
    # 运行时可能附加 saved / progress / status 等字段（书架相关）
    for extra in ("saved", "progress", "status", "started_at", "finished_at"):
        if extra in row:
            out[_camel(extra)] = row[extra]
    # is_saved / shelf_status 可能从 join 来
    for opt in ("is_saved", "shelf_status"):
        if opt in row:
            out[_camel(opt)] = row[opt]
    # tags 可能以 JSON list 附加
    if "tags" in row and row["tags"] is not None:
        out["tags"] = json.loads(row["tags"]) if isinstance(row["tags"], str) else row["tags"]
    return out


def serialize_shelf_entry(row: Record | dict | None) -> dict | None:
    if row is None:
        return None
    book_fields = ["id", "slug", "title", "english", "author", "category",
                   "pages", "published_year", "color", "ink", "art",
                   "subtitle", "tag", "rating_avg", "rating_count"]
    book = {_camel(f): row.get(f) for f in book_fields if f in row}
    if "book_tags" in row and row["book_tags"] is not None:
        tags = json.loads(row["book_tags"]) if isinstance(row["book_tags"], str) else row["book_tags"]
        book["tags"] = tags
    # serial id 转数字，避免前端拿到字符串
    if "id" in book and book["id"] is not None:
        book["id"] = int(book["id"])
    return {
        "status": row.get("status"),
        "progress": int(row.get("progress") or 0),
        "startedAt": _iso(row.get("started_at")),
        "finishedAt": _iso(row.get("finished_at")),
        "createdAt": _iso(row.get("created_at")),
        "updatedAt": _iso(row.get("updated_at")),
        "book": book,
    }


def serialize_review(row: Record | dict | None, *, include_user: bool = True) -> dict | None:
    if row is None:
        return None
    out = {
        "id": _str(row.get("id")),
        "rating": float(row.get("rating") or 0),
        "title": row.get("title", ""),
        "content": row.get("content", ""),
        "containsSpoilers": bool(row.get("contains_spoilers", False)),
        "likesCount": int(row.get("likes_count") or 0),
        "commentsCount": int(row.get("comments_count") or 0),
        "createdAt": _iso(row.get("created_at")),
        "updatedAt": _iso(row.get("updated_at")),
        "bookSlug": row.get("book_slug") or row.get("slug"),
        "bookTitle": row.get("book_title") or row.get("title"),
    }
    for opt in ("liked", "is_liked", "user_handle", "user_display_name"):
        if opt in row and row[opt] is not None:
            out[_camel(opt)] = row[opt]
    if "liked" not in out and "is_liked" in row:
        out["liked"] = bool(row["is_liked"])
    if include_user and ("user_id" in row or "handle" in row):
        out["user"] = serialize_user({
            "id": row.get("user_id"),
            "handle": row.get("handle"),
            "display_name": row.get("display_name"),
            "bio": row.get("bio", ""),
            "avatar_color": row.get("avatar_color", "#294b3c"),
        })
    return out


def serialize_note(row: Record | dict | None, *, include_book: bool = True) -> dict | None:
    if row is None:
        return None
    out = {
        "id": _str(row.get("id")),
        "title": row.get("title"),
        "content": row.get("content"),
        "type": row.get("type", "thought"),
        "page": row.get("page"),
        "isPrivate": bool(row.get("is_private", True)),
        "createdAt": _iso(row.get("created_at")),
        "updatedAt": _iso(row.get("updated_at")),
    }
    if include_book:
        out["book"] = {
            "id": row.get("book_id"),
            "slug": row.get("book_slug"),
            "title": row.get("book_title"),
            "author": row.get("book_author"),
            "color": row.get("book_color", "#3e5b48"),
            "ink": row.get("book_ink", "#eee8d5"),
            "art": row.get("book_art", "lake"),
        }
    return out


def serialize_highlight(row: Record | dict | None, *, include_book: bool = True) -> dict | None:
    if row is None:
        return None
    out = {
        "id": _str(row.get("id")),
        "quote": row.get("quote"),
        "page": row.get("page"),
        "note": row.get("note", ""),
        "isPrivate": bool(row.get("is_private", True)),
        "createdAt": _iso(row.get("created_at")),
    }
    if include_book:
        out["book"] = {
            "id": row.get("book_id"),
            "slug": row.get("book_slug"),
            "title": row.get("book_title"),
            "author": row.get("book_author"),
            "color": row.get("book_color", "#3e5b48"),
            "ink": row.get("book_ink", "#eee8d5"),
            "art": row.get("book_art", "lake"),
        }
    return out


def serialize_session(row: Record | dict | None) -> dict | None:
    if row is None:
        return None
    return {
        "id": _str(row.get("id")),
        "minutes": int(row.get("minutes") or 0),
        "pages": int(row.get("pages") or 0),
        "sessionDate": _iso(row.get("session_date")),
        "note": row.get("note", ""),
        "createdAt": _iso(row.get("created_at")),
        "book": {
            "id": row.get("book_id"),
            "slug": row.get("book_slug"),
            "title": row.get("book_title"),
            "author": row.get("book_author"),
            "color": row.get("book_color", "#3e5b48"),
        },
    }


def serialize_goal(row: Record | dict | None) -> dict | None:
    if row is None:
        return None
    out = {
        "year": int(row.get("year")),
        "targetBooks": int(row.get("target_books") or 0),
        "targetMinutes": int(row.get("target_minutes") or 0),
        "createdAt": _iso(row.get("created_at")),
        "updatedAt": _iso(row.get("updated_at")),
    }
    for opt in ("read_books", "read_minutes"):
        if opt in row:
            out[_camel(opt)] = int(row[opt] or 0)
    return out


def serialize_list(row: Record | dict | None, *, include_items: bool = False) -> dict | None:
    if row is None:
        return None
    out = {
        "id": _str(row.get("id")),
        "title": row.get("title"),
        "description": row.get("description", ""),
        "isPublic": bool(row.get("is_public", True)),
        "createdAt": _iso(row.get("created_at")),
        "updatedAt": _iso(row.get("updated_at")),
        "user": serialize_user({
            "id": row.get("user_id"),
            "handle": row.get("handle"),
            "display_name": row.get("display_name"),
            "avatar_color": row.get("avatar_color", "#294b3c"),
        }),
        "itemsCount": int(row.get("items_count") or 0),
    }
    if include_items and "items" in row:
        out["items"] = row["items"]  # 已经是 list of dict
    return out


def serialize_club(row: Record | dict | None) -> dict | None:
    if row is None:
        return None
    out = {
        "id": _str(row.get("id")),
        "name": row.get("name"),
        "slug": row.get("slug"),
        "description": row.get("description", ""),
        "isPrivate": bool(row.get("is_private", False)),
        "createdAt": _iso(row.get("created_at")),
        "membersCount": int(row.get("members_count") or 0),
        "postsCount": int(row.get("posts_count") or 0),
        "isMember": bool(row.get("is_member", False)),
        "isOwner": bool(row.get("is_owner", False)),
        "owner": serialize_user({
            "id": row.get("owner_id"),
            "handle": row.get("owner_handle"),
            "display_name": row.get("owner_display_name"),
            "avatar_color": row.get("owner_avatar_color", "#294b3c"),
        }),
    }
    if row.get("book_id") is not None:
        out["book"] = {
            "id": row.get("book_id"),
            "slug": row.get("book_slug"),
            "title": row.get("book_title"),
            "author": row.get("book_author"),
            "color": row.get("book_color", "#3e5b48"),
        }
    return out


def serialize_club_post(row: Record | dict | None) -> dict | None:
    if row is None:
        return None
    return {
        "id": _str(row.get("id")),
        "content": row.get("content"),
        "page": row.get("page"),
        "createdAt": _iso(row.get("created_at")),
        "user": serialize_user({
            "id": row.get("user_id"),
            "handle": row.get("handle"),
            "display_name": row.get("display_name"),
            "avatar_color": row.get("avatar_color", "#294b3c"),
        }),
    }


def serialize_comment(row: Record | dict | None) -> dict | None:
    if row is None:
        return None
    return {
        "id": _str(row.get("id")),
        "content": row.get("content"),
        "createdAt": _iso(row.get("created_at")),
        "user": serialize_user({
            "id": row.get("user_id"),
            "handle": row.get("handle"),
            "display_name": row.get("display_name"),
            "avatar_color": row.get("avatar_color", "#294b3c"),
        }),
    }


def serialize_activity(row: Record | dict | None) -> dict | None:
    if row is None:
        return None
    payload = row.get("payload")
    if isinstance(payload, str):
        try:
            payload = json.loads(payload)
        except Exception:
            payload = {}
    elif payload is None:
        payload = {}
    return {
        "id": _str(row.get("id")),
        "type": row.get("type"),
        "payload": payload,
        "createdAt": _iso(row.get("created_at")),
        "user": serialize_user({
            "id": row.get("user_id"),
            "handle": row.get("handle"),
            "display_name": row.get("display_name"),
            "avatar_color": row.get("avatar_color", "#294b3c"),
        }),
        "book": {
            "id": row.get("book_id"),
            "slug": row.get("book_slug"),
            "title": row.get("book_title"),
            "author": row.get("book_author"),
            "color": row.get("book_color", "#3e5b48"),
        } if row.get("book_id") is not None else None,
    }


def serialize_notification(row: Record | dict | None) -> dict | None:
    if row is None:
        return None
    payload = row.get("payload")
    if isinstance(payload, str):
        try:
            payload = json.loads(payload)
        except Exception:
            payload = {}
    elif payload is None:
        payload = {}
    out = {
        "id": _str(row.get("id")),
        "type": row.get("type"),
        "payload": payload,
        "isRead": bool(row.get("is_read", False)),
        "createdAt": _iso(row.get("created_at")),
    }
    if row.get("actor_id") is not None:
        out["actor"] = serialize_user({
            "id": row.get("actor_id"),
            "handle": row.get("actor_handle"),
            "display_name": row.get("actor_display_name"),
            "avatar_color": row.get("actor_avatar_color", "#294b3c"),
        })
    return out


# ----------------- 分页辅助 -----------------


def paginated(items: list, page: int, page_size: int, total: int) -> dict:
    """构造 Express 风格的 ``{items, page, pageSize, total}`` 分页响应。"""
    return {"items": items, "page": page, "pageSize": page_size, "total": total}
