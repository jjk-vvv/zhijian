"""活动日志工具 —— 替代 Express 的 utils/activity.js。"""

from __future__ import annotations

import json
from typing import Any
from uuid import UUID

from app.db.pool import execute


async def log_activity(
    user_id: str | UUID,
    type_: str,
    book_id: int | None = None,
    payload: dict[str, Any] | None = None,
) -> None:
    """往 activities 表插一行，payload 存 jsonb。"""
    await execute(
        "insert into activities (user_id, type, book_id, payload, created_at) "
        "values ($1, $2, $3, $4::jsonb, now())",
        [str(user_id), type_, book_id, json.dumps(payload or {})],
    )
