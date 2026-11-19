"""notes service —— 手记 CRUD。"""
from __future__ import annotations

from typing import Any

from app.db.pool import query
from app.errors import not_found
from app.utils.activity import log_activity


SELECT = (
    "select n.*, b.slug as book_slug, b.title as book_title, b.author as book_author, "
    "b.color as book_color, b.ink as book_ink, b.art as book_art "
    "from notes n join books b on b.id = n.book_id"
)


def _note_row(row: dict[str, Any]) -> dict[str, Any]:
    return {
        "id": str(row["id"]),
        "title": row["title"],
        "content": row["content"],
        "type": row["type"],
        "page": row.get("page"),
        "isPrivate": bool(row.get("is_private", True)),
        "createdAt": row["created_at"].isoformat().replace("+00:00", "Z") if row.get("created_at") else None,
        "updatedAt": row["updated_at"].isoformat().replace("+00:00", "Z") if row.get("updated_at") else None,
        "book": {
            "slug": row["book_slug"],
            "title": row["book_title"],
            "author": row["book_author"],
            "color": row["book_color"],
            "ink": row["book_ink"],
            "art": row["book_art"],
        },
    }


async def list_notes(user_id: str, filters: dict[str, Any]) -> dict[str, Any]:
    conditions = ["n.user_id = $1"]
    params: list[Any] = [user_id]

    q = (filters.get("q") or "").strip()
    if q:
        params.append(f"%{q}%")
        p = len(params)
        conditions.append(
            f"(n.title ilike ${p} or n.content ilike ${p} or b.title ilike ${p})"
        )

    type_ = filters.get("type")
    if type_ and type_ != "all":
        params.append(type_)
        conditions.append(f"n.type = ${len(params)}")

    book_slug = filters.get("bookSlug")
    if book_slug:
        params.append(book_slug)
        conditions.append(f"b.slug = ${len(params)}")

    rows = await query(
        f"{SELECT} where {' and '.join(conditions)} order by n.created_at desc limit 200",
        params,
    )
    return {"items": [_note_row(dict(r)) for r in rows]}


async def _book_id_by_slug(slug: str):
    rows = await query("select id from books where slug = $1", [slug])
    if not rows:
        raise not_found("这本书不在书库中")
    return rows[0]["id"]


async def create_note(user_id: str, data: dict[str, Any]) -> dict[str, Any]:
    book_id = await _book_id_by_slug(data["bookSlug"])
    rows = await query(
        "insert into notes (user_id, book_id, title, content, type, page, is_private) "
        "values ($1, $2, $3, $4, $5, $6, $7) returning id",
        [user_id, book_id, data["title"], data["content"], data.get("type", "thought"),
         data.get("page"),
         True if data.get("isPrivate") is None else data["isPrivate"]],
    )
    note_id = rows[0]["id"]
    await log_activity(user_id, "note", book_id,
                       {"title": data["title"], "noteId": str(note_id)})
    created = await query(f"{SELECT} where n.id = $1", [note_id])
    return _note_row(dict(created[0]))


async def update_note(user_id: str, note_id: str, data: dict[str, Any]) -> dict[str, Any]:
    current = await query("select * from notes where id = $1 and user_id = $2", [note_id, user_id])
    if not current:
        raise not_found("手记不存在")
    cur = dict(current[0])

    if data.get("bookSlug"):
        book_id = await _book_id_by_slug(data["bookSlug"])
    else:
        book_id = cur["book_id"]

    title = data.get("title", cur["title"])
    content = data.get("content", cur["content"])
    type_ = data.get("type", cur["type"])
    page = data.get("page") if "page" in data else cur.get("page")
    is_private = data.get("isPrivate", cur["is_private"])

    await query(
        "update notes set book_id = $1, title = $2, content = $3, type = $4, page = $5, is_private = $6 "
        "where id = $7 and user_id = $8",
        [book_id, title, content, type_, page, is_private, note_id, user_id],
    )
    updated = await query(f"{SELECT} where n.id = $1", [note_id])
    return _note_row(dict(updated[0]))


async def delete_note(user_id: str, note_id: str) -> None:
    deleted = await query(
        "delete from notes where id = $1 and user_id = $2 returning 1",
        [note_id, user_id],
    )
    if not deleted:
        raise not_found("手记不存在")
