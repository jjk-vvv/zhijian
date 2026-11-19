"""shelf service —— 书架列表 / 添加 / 更新 / 删除 / 旧版导入。"""
from __future__ import annotations

from datetime import datetime, timezone
from typing import Any

from app.db.pool import query
from app.errors import bad_request, not_found
from app.utils.activity import log_activity
from app.utils.serialize import serialize_book

STATUSES = {"wishlist", "reading", "finished", "dnf"}
TYPE_MAP = {"感想": "thought", "摘录": "excerpt", "书评": "review"}


def _now() -> datetime:
    return datetime.now(timezone.utc).replace(tzinfo=None)


def _iso(val) -> str | None:
    if val is None:
        return None
    return val.isoformat().replace("+00:00", "Z")


def _shelf_row(row: dict[str, Any]) -> dict[str, Any]:
    book = serialize_book(row)
    return {
        **(book or {}),
        "status": row.get("status"),
        "progress": row.get("progress"),
        "startedAt": _iso(row.get("started_at")),
        "finishedAt": _iso(row.get("finished_at")),
        "updatedAt": _iso(row.get("shelf_updated_at")),
    }


async def list_shelf(user_id: str, status: str | None) -> dict[str, Any]:
    params: list[Any] = [user_id]
    filter_clause = ""
    if status and status != "all":
        if status not in STATUSES:
            raise bad_request("未知的阅读状态")
        params.append(status)
        filter_clause = f"and ub.status = ${len(params)}"

    rows = await query(
        "select ub.status, ub.progress, ub.started_at, ub.finished_at, "
        "ub.updated_at as shelf_updated_at, b.* "
        "from user_books ub join books b on b.id = ub.book_id "
        f"where ub.user_id = $1 {filter_clause} "
        "order by ub.updated_at desc",
        params,
    )
    items = []
    for r in rows:
        d = dict(r)
        d["id"] = int(d["id"])
        items.append(_shelf_row(d))
    return {"items": items}


async def add_to_shelf(user_id: str, slug: str, status: str = "wishlist") -> dict[str, Any]:
    if status not in STATUSES:
        raise bad_request("未知的阅读状态")
    book_rows = await query("select id from books where slug = $1", [slug])
    if not book_rows:
        raise not_found("这本书不在书库中")
    book_id = book_rows[0]["id"]

    now = _now()
    rows = await query(
        "insert into user_books (user_id, book_id, status, progress, started_at, finished_at) "
        "values ($1, $2, $3, $4, $5, $6) "
        "on conflict (user_id, book_id) do update "
        "  set status = excluded.status, "
        "      progress = greatest(user_books.progress, excluded.progress), "
        "      started_at = coalesce(user_books.started_at, excluded.started_at), "
        "      finished_at = coalesce(user_books.finished_at, excluded.finished_at) "
        "returning *, (xmax = 0) as inserted",
        [
            user_id,
            book_id,
            status,
            100 if status == "finished" else 0,
            now if status in ("reading", "finished") else None,
            now if status == "finished" else None,
        ],
    )

    row = dict(rows[0])
    was_inserted = bool(row.get("inserted", False))
    if was_inserted:
        await log_activity(
            user_id,
            "finished" if status == "finished" else "shelf_add",
            book_id,
            {"status": status},
        )

    book_result = await query("select * from books where id = $1", [book_id])
    book_d = dict(book_result[0])
    book_d["id"] = int(book_d["id"])
    book = serialize_book(book_d)
    return {
        **(book or {}),
        "status": row["status"],
        "progress": row["progress"],
    }


async def update_shelf(user_id: str, slug: str, data: dict[str, Any]) -> dict[str, Any]:
    book_rows = await query("select id from books where slug = $1", [slug])
    if not book_rows:
        raise not_found("这本书不在书库中")
    book_id = book_rows[0]["id"]

    current_rows = await query(
        "select * from user_books where user_id = $1 and book_id = $2",
        [user_id, book_id],
    )
    if not current_rows:
        raise not_found("这本书不在你的书架上")
    previous = dict(current_rows[0])

    next_status = data.get("status") or previous["status"]
    if next_status not in STATUSES:
        raise bad_request("未知的阅读状态")

    if "progress" in data and data["progress"] is not None:
        next_progress = max(0, min(100, int(data["progress"] or 0)))
        if next_progress == 100:
            next_status = "finished"
        elif next_status == "finished" and next_progress < 100:
            next_status = "reading"
    else:
        next_progress = 100 if next_status == "finished" else previous.get("progress", 0) or 0

    now = _now()

    updated_rows = await query(
        "update user_books "
        "set status = $1, "
        "    progress = $2, "
        "    started_at = case when $1 in ('reading','finished') then coalesce(started_at, $3) else started_at end, "
        "    finished_at = case when $1 = 'finished' then coalesce(finished_at, $3) else null end "
        "where user_id = $4 and book_id = $5 "
        "returning *",
        [next_status, next_progress, now, user_id, book_id],
    )
    row = dict(updated_rows[0])

    if next_status == "finished" and previous["status"] != "finished":
        await log_activity(user_id, "finished", book_id, {})

    return {
        "status": row["status"],
        "progress": row["progress"],
        "startedAt": _iso(row.get("started_at")),
        "finishedAt": _iso(row.get("finished_at")),
    }


async def remove_from_shelf(user_id: str, slug: str) -> None:
    book_rows = await query("select id from books where slug = $1", [slug])
    if not book_rows:
        raise not_found("这本书不在书库中")
    deleted = await query(
        "delete from user_books where user_id = $1 and book_id = $2 returning 1",
        [user_id, book_rows[0]["id"]],
    )
    if not deleted:
        raise not_found("这本书不在你的书架上")


# --- 旧版 localStorage 数据导入 ---
async def import_legacy_library(user_id: str, payload: dict[str, Any]) -> dict[str, Any]:
    imported = {"shelf": 0, "notes": 0, "skipped": 0}
    shelf = payload.get("shelf") if isinstance(payload.get("shelf"), list) else []
    notes = payload.get("notes") if isinstance(payload.get("notes"), list) else []

    for entry in shelf:
        if not entry or not entry.get("bookId"):
            imported["skipped"] += 1
            continue
        book = await query("select id from books where slug = $1", [entry["bookId"]])
        if not book:
            imported["skipped"] += 1
            continue
        progress = max(0, min(100, int(entry.get("progress") or 0)))
        status = "finished" if progress >= 100 else "reading" if progress > 0 else "wishlist"
        now = _now()
        await query(
            "insert into user_books (user_id, book_id, status, progress, started_at, finished_at) "
            "values ($1, $2, $3, $4, $5, $6) "
            "on conflict (user_id, book_id) do nothing",
            [
                user_id, book[0]["id"], status, progress,
                None if status == "wishlist" else now,
                now if status == "finished" else None,
            ],
        )
        imported["shelf"] += 1

    for note in notes:
        if not note or not note.get("bookId") or not (note.get("title") or "").strip() \
                or not (note.get("content") or "").strip():
            imported["skipped"] += 1
            continue
        book = await query("select id from books where slug = $1", [note["bookId"]])
        if not book:
            imported["skipped"] += 1
            continue
        date_val = note.get("date")
        try:
            created = datetime.fromisoformat(date_val.replace("Z", "+00:00")) \
                if date_val else _now()
        except Exception:
            created = _now()
        if created.tzinfo:
            created = created.replace(tzinfo=None)
        await query(
            "insert into notes (user_id, book_id, title, content, type, created_at, updated_at) "
            "values ($1, $2, $3, $4, $5, $6, $6)",
            [
                user_id, book[0]["id"],
                str(note["title"])[:60],
                str(note["content"])[:3000],
                TYPE_MAP.get(note.get("type"), "thought"),
                created,
            ],
        )
        imported["notes"] += 1

    return imported
