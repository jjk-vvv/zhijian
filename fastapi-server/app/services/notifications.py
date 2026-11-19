"""notifications service —— 通知列表 / 已读标记。"""
from __future__ import annotations

import asyncio
import json
from typing import Any

from app.db.pool import query, execute


async def list_notifications(user_id: str, opts: dict[str, Any]) -> dict[str, Any]:
    unread_only = opts.get("unreadOnly")
    rows, unread_rows = await asyncio.gather(
        query(
            "select n.*, u.handle as actor_handle, u.display_name as actor_display_name, "
            "u.avatar_color as actor_avatar_color "
            "from notifications n "
            "left join users u on u.id = n.actor_id "
            "where n.user_id = $1 "
            + ("and n.is_read = false " if unread_only else "")
            + "order by n.created_at desc "
            "limit 50",
            [user_id],
        ),
        query(
            "select count(*)::int as total from notifications where user_id = $1 and is_read = false",
            [user_id],
        ),
    )

    items = []
    for r in rows:
        d = dict(r)
        payload = d.get("payload")
        if isinstance(payload, str):
            try:
                payload = json.loads(payload)
            except Exception:
                payload = {}
        elif payload is None:
            payload = {}
        out = {
            "id": str(d["id"]),
            "type": d["type"],
            "payload": payload,
            "isRead": bool(d.get("is_read", False)),
            "createdAt": d["created_at"].isoformat().replace("+00:00", "Z")
                         if d.get("created_at") else None,
        }
        if d.get("actor_handle"):
            out["actor"] = {
                "id": str(d["actor_id"]),
                "handle": d["actor_handle"],
                "displayName": d["actor_display_name"],
                "avatarColor": d["actor_avatar_color"],
            }
        items.append(out)

    return {
        "items": items,
        "unreadCount": unread_rows[0]["total"] if unread_rows else 0,
    }


async def mark_read(user_id: str, notification_id: str) -> None:
    await execute(
        "update notifications set is_read = true where id = $1 and user_id = $2",
        [notification_id, user_id],
    )


async def mark_all_read(user_id: str) -> dict[str, int]:
    await execute(
        "update notifications set is_read = true where user_id = $1",
        [user_id],
    )
    return {"unreadCount": 0}
