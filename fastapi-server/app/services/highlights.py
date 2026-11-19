"""highlights service —— 划线 / 每日回顾。"""
from __future__ import annotations

from typing import Any

from app.db.pool import query
from app.errors import not_found
from app.utils.activity import log_activity


SELECT = (
    "select h.*, b.slug as book_slug, b.title as book_title, b.author as book_author, "
    "b.color as book_color, b.ink as book_ink, b.art as book_art "
    "from highlights h join books b on b.id = h.book_id"
)


def _row_mapper(row: dict[str, Any]) -> dict[str, Any]:
    return {
        "id": str(row["id"]),
        "quote": row["quote"],
        "page": row.get("page"),
        "note": row.get("note", ""),
        "isPrivate": bool(row.get("is_private", True)),
        "createdAt": row["created_at"].isoformat().replace("+00:00", "Z") if row.get("created_at") else None,
        "book": {
            "slug": row["book_slug"],
            "title": row["book_title"],
            "author": row["book_author"],
            "color": row["book_color"],
            "ink": row["book_ink"],
            "art": row["book_art"],
        },
    }


async def list_highlights(user_id: str, filters: dict[str, Any]) -> dict[str, Any]:
    conditions = ["h.user_id = $1"]
    params: list[Any] = [user_id]

    q = (filters.get("q") or "").strip()
    if q:
        params.append(f"%{q}%")
        p = len(params)
        conditions.append(
            f"(h.quote ilike ${p} or h.note ilike ${p} or b.title ilike ${p})"
        )

    book_slug = filters.get("bookSlug")
    if book_slug:
        params.append(book_slug)
        conditions.append(f"b.slug = ${len(params)}")

    rows = await query(
        f"{SELECT} where {' and '.join(conditions)} order by h.created_at desc limit 300",
        params,
    )
    return {"items": [_row_mapper(dict(r)) for r in rows]}


async def create_highlight(user_id: str, data: dict[str, Any]) -> dict[str, Any]:
    book = await query("select id from books where slug = $1", [data["bookSlug"]])
    if not book:
        raise not_found("这本书不在书库中")
    book_id = book[0]["id"]

    rows = await query(
        "insert into highlights (user_id, book_id, quote, page, note, is_private) "
        "values ($1, $2, $3, $4, $5, $6) returning id",
        [user_id, book_id, data["quote"], data.get("page"),
         data.get("note") or "",
         True if data.get("isPrivate") is None else data["isPrivate"]],
    )
    await log_activity(user_id, "highlight", book_id,
                       {"quote": data["quote"][:80]})
    created = await query(f"{SELECT} where h.id = $1", [rows[0]["id"]])
    return _row_mapper(dict(created[0]))


async def delete_highlight(user_id: str, highlight_id: str) -> None:
    deleted = await query(
        "delete from highlights where id = $1 and user_id = $2 returning 1",
        [highlight_id, user_id],
    )
    if not deleted:
        raise not_found("划线不存在")


async def daily_highlight(user_id: str) -> dict[str, Any]:
    rows = await query(
        f"{SELECT} where h.user_id = $1 "
        "order by md5(h.id::text || current_date::text) limit 1",
        [user_id],
    )
    return {"highlight": _row_mapper(dict(rows[0])) if rows else None}
