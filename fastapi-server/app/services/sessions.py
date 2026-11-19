"""sessions service —— 阅读会话 CRUD。"""
from __future__ import annotations

import re
from datetime import datetime, timezone
from typing import Any

from app.db.pool import query, with_transaction
from app.errors import not_found


DATE_RE = re.compile(r"^\d{4}-\d{2}-\d{2}$")


SELECT = (
    "select s.*, to_char(s.session_date, 'YYYY-MM-DD') as session_date_text, "
    "b.slug as book_slug, b.title as book_title, b.author as book_author, "
    "b.color as book_color, b.ink as book_ink, b.art as book_art "
    "from reading_sessions s join books b on b.id = s.book_id"
)


def _now() -> datetime:
    return datetime.now(timezone.utc).replace(tzinfo=None)


def _row_mapper(row: dict[str, Any]) -> dict[str, Any]:
    return {
        "id": str(row["id"]),
        "minutes": int(row["minutes"]),
        "pages": int(row.get("pages") or 0),
        "date": row["session_date_text"],
        "note": row.get("note", ""),
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


async def list_sessions(user_id: str, filters: dict[str, Any]) -> dict[str, Any]:
    conditions = ["s.user_id = $1"]
    params: list[Any] = [user_id]

    from_val = filters.get("from")
    if from_val:
        params.append(from_val)
        conditions.append(f"s.session_date >= ${len(params)}")

    to_val = filters.get("to")
    if to_val:
        params.append(to_val)
        conditions.append(f"s.session_date <= ${len(params)}")

    limit = min(365, max(1, int(filters.get("limit") or 100)))
    params.append(limit)

    rows = await query(
        f"{SELECT} where {' and '.join(conditions)} "
        f"order by s.session_date desc, s.created_at desc limit ${len(params)}",
        params,
    )
    return {"items": [_row_mapper(dict(r)) for r in rows]}


async def create_session(user_id: str, data: dict[str, Any]) -> dict[str, Any]:
    book = await query("select id from books where slug = $1", [data["bookSlug"]])
    if not book:
        raise not_found("这本书不在书库中")
    book_id = book[0]["id"]

    async def _inner(conn):
        session_rows = await conn.fetch(
            "insert into reading_sessions (user_id, book_id, minutes, pages, session_date, note) "
            "values ($1, $2, $3, $4, coalesce($5::date, current_date), $6) returning *",
            user_id, book_id,
            int(data["minutes"]), int(data.get("pages") or 0),
            data.get("date"), data.get("note") or "",
        )

        if data.get("progress") is not None:
            progress = max(0, min(100, int(data["progress"] or 0)))
            status = "finished" if progress >= 100 else "reading"
            await conn.execute(
                "insert into user_books (user_id, book_id, status, progress, started_at, finished_at) "
                "values ($1, $2, $3, $4, now(), case when $3 = 'finished' then now() else null end) "
                "on conflict (user_id, book_id) do update "
                "  set status = $3, "
                "      progress = $4, "
                "      started_at = coalesce(user_books.started_at, now()), "
                "      finished_at = case when $3 = 'finished' then coalesce(user_books.finished_at, now()) else user_books.finished_at end",
                user_id, book_id, status, progress,
            )
        return session_rows[0]

    session = await with_transaction(_inner)

    created = await query(f"{SELECT} where s.id = $1", [session["id"]])
    return _row_mapper(dict(created[0]))


async def delete_session(user_id: str, session_id: str) -> None:
    deleted = await query(
        "delete from reading_sessions where id = $1 and user_id = $2 returning 1",
        [session_id, user_id],
    )
    if not deleted:
        raise not_found("该阅读记录不存在")
