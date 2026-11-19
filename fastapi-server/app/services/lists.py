"""lists service —— 书单。"""
from __future__ import annotations

from typing import Any

from app.db.pool import query
from app.errors import forbidden, not_found
from app.utils.activity import log_activity
from app.utils.serialize import serialize_book


BOOK_FIELDS = "b.id, b.slug, b.title, b.author, b.color, b.ink, b.art"


def _list_row(row: dict[str, Any]) -> dict[str, Any]:
    preview = row.get("preview") or []
    if isinstance(preview, str):
        import json
        preview = json.loads(preview)
    return {
        "id": str(row["id"]),
        "title": row["title"],
        "description": row["description"],
        "isPublic": bool(row.get("is_public", True)),
        "createdAt": row["created_at"].isoformat().replace("+00:00", "Z") if row.get("created_at") else None,
        "updatedAt": row["updated_at"].isoformat().replace("+00:00", "Z") if row.get("updated_at") else None,
        "user": {
            "id": str(row["user_id"]),
            "handle": row["handle"],
            "displayName": row["display_name"],
            "avatarColor": row["avatar_color"],
        },
        "bookCount": int(row.get("book_count") or 0),
        "preview": preview,
    }


async def list_lists(viewer_id: str | None, opts: dict[str, Any]) -> dict[str, Any]:
    mine = opts.get("mine")
    handle = opts.get("handle")
    limit = min(50, max(1, int(opts.get("limit") or 24)))

    conditions: list[str] = []
    params: list[Any] = []

    if mine and viewer_id:
        params.append(viewer_id)
        conditions.append(f"l.user_id = ${len(params)}")
    else:
        conditions.append("l.is_public = true")
        if handle:
            params.append(handle)
            conditions.append(f"u.handle = ${len(params)}")

    params.append(limit)
    rows = await query(
        "select l.*, u.handle, u.display_name, u.avatar_color, "
        "(select count(*)::int from list_items li where li.list_id = l.id) as book_count, "
        "p.preview "
        "from lists l "
        "join users u on u.id = l.user_id "
        "left join lateral ( "
        "  select json_agg(x) as preview from ( "
        "    select " + BOOK_FIELDS + " "
        "    from list_items li join books b on b.id = li.book_id "
        "    where li.list_id = l.id "
        "    order by li.position, li.added_at "
        "    limit 4 "
        "  ) x "
        ") p on true "
        f"where {' and '.join(conditions)} "
        "order by l.updated_at desc "
        f"limit ${len(params)}",
        params,
    )
    return {"items": [_list_row(dict(r)) for r in rows]}


async def get_list(list_id: str, viewer_id: str | None) -> dict[str, Any]:
    rows = await query(
        "select l.*, u.handle, u.display_name, u.avatar_color, "
        "(select count(*)::int from list_items li where li.list_id = l.id) as book_count "
        "from lists l join users u on u.id = l.user_id "
        "where l.id = $1",
        [list_id],
    )
    if not rows:
        raise not_found("书单不存在")
    row = dict(rows[0])

    if not row.get("is_public") and str(row["user_id"]) != viewer_id:
        raise forbidden("这是一份私密书单")

    items = await query(
        "select b.*, li.id as item_id, li.note as item_note, li.position, li.added_at "
        "from list_items li join books b on b.id = li.book_id "
        "where li.list_id = $1 "
        "order by li.position, li.added_at",
        [list_id],
    )

    items_out = []
    for r in items:
        d = dict(r)
        d["id"] = int(d["id"])
        book = serialize_book(d) or {}
        book["itemId"] = str(d["item_id"])
        book["itemNote"] = d["item_note"]
        book["addedAt"] = d["added_at"].isoformat().replace("+00:00", "Z") if d.get("added_at") else None
        items_out.append(book)

    return {"list": _list_row(row), "items": items_out}


async def create_list(user_id: str, data: dict[str, Any]) -> dict[str, Any]:
    rows = await query(
        "insert into lists (user_id, title, description, is_public) "
        "values ($1, $2, $3, $4) returning *",
        [user_id, data["title"], data.get("description") or "",
         True if data.get("isPublic") is None else data["isPublic"]],
    )
    row = dict(rows[0])
    await log_activity(user_id, "list_create", None,
                       {"listId": str(row["id"]), "title": row["title"]})
    created = await query(
        "select l.*, u.handle, u.display_name, u.avatar_color, 0 as book_count "
        "from lists l join users u on u.id = l.user_id where l.id = $1",
        [row["id"]],
    )
    return _list_row(dict(created[0]))


async def update_list(user_id: str, list_id: str, data: dict[str, Any]) -> dict[str, Any]:
    current = await query("select * from lists where id = $1", [list_id])
    if not current:
        raise not_found("书单不存在")
    if str(current[0]["user_id"]) != user_id:
        raise forbidden("只能编辑自己的书单")

    cur = dict(current[0])
    title = data.get("title", cur["title"])
    description = data.get("description", cur["description"])
    is_public = data.get("isPublic", cur["is_public"])

    rows = await query(
        "update lists set title = $1, description = $2, is_public = $3 where id = $4 returning *",
        [title, description, is_public, list_id],
    )
    row = dict(rows[0])
    return {
        "id": str(row["id"]),
        "title": row["title"],
        "description": row["description"],
        "isPublic": bool(row["is_public"]),
    }


async def delete_list(user_id: str, list_id: str) -> None:
    deleted = await query(
        "delete from lists where id = $1 and user_id = $2 returning 1",
        [list_id, user_id],
    )
    if not deleted:
        raise not_found("书单不存在或无权删除")


async def add_item(user_id: str, list_id: str, data: dict[str, Any]) -> dict[str, Any]:
    list_rows = await query("select user_id from lists where id = $1", [list_id])
    if not list_rows:
        raise not_found("书单不存在")
    if str(list_rows[0]["user_id"]) != user_id:
        raise forbidden("只能编辑自己的书单")

    book = await query("select id from books where slug = $1", [data["bookSlug"]])
    if not book:
        raise not_found("这本书不在书库中")

    rows = await query(
        "insert into list_items (list_id, book_id, note, position) "
        "values ($1, $2, $3, coalesce((select max(position) + 1 from list_items where list_id = $1), 0)) "
        "returning *",
        [list_id, book[0]["id"], data.get("note", "")],
    )
    await query("update lists set updated_at = now() where id = $1", [list_id])
    row = dict(rows[0])
    return {
        "id": str(row["id"]),
        "bookSlug": data["bookSlug"],
        "note": row["note"],
        "position": int(row["position"]),
    }


async def remove_item(user_id: str, list_id: str, book_slug: str) -> None:
    list_rows = await query("select user_id from lists where id = $1", [list_id])
    if not list_rows:
        raise not_found("书单不存在")
    if str(list_rows[0]["user_id"]) != user_id:
        raise forbidden("只能编辑自己的书单")

    deleted = await query(
        "delete from list_items li using books b "
        "where li.book_id = b.id and li.list_id = $1 and b.slug = $2 returning 1",
        [list_id, book_slug],
    )
    if not deleted:
        raise not_found("这本书不在这份书单中")
    await query("update lists set updated_at = now() where id = $1", [list_id])
