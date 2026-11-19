"""goals service —— 年度阅读目标。"""
from __future__ import annotations

import asyncio
import json
from datetime import datetime
from typing import Any

from app.db.pool import query


async def get_goal(user_id: str, year: int | None) -> dict[str, Any]:
    target_year = int(year) if year else datetime.now().year

    goal_rows, progress_rows = await asyncio.gather(
        query(
            "select * from goals where user_id = $1 and year = $2",
            [user_id, target_year],
        ),
        query(
            "select "
            "(select count(*)::int from user_books "
            " where user_id = $1 and status = 'finished' "
            "   and extract(year from coalesce(finished_at, updated_at)) = $2) as books_finished, "
            "(select coalesce(sum(minutes), 0)::int from reading_sessions "
            " where user_id = $1 and extract(year from session_date) = $2) as minutes, "
            "(select count(distinct session_date)::int from reading_sessions "
            " where user_id = $1 and extract(year from session_date) = $2) as active_days",
            [user_id, target_year],
        ),
    )

    goal = goal_rows[0] if goal_rows else None
    goal_out = None
    if goal:
        goal_out = {
            "targetBooks": int(goal["target_books"]),
            "targetMinutes": int(goal["target_minutes"]),
            "updatedAt": goal["updated_at"].isoformat().replace("+00:00", "Z")
                         if goal.get("updated_at") else None,
        }

    return {
        "year": target_year,
        "goal": goal_out,
        "progress": dict(progress_rows[0]) if progress_rows else {},
    }


async def set_goal(user_id: str, data: dict[str, Any]) -> dict[str, Any]:
    rows = await query(
        "insert into goals (user_id, year, target_books, target_minutes) "
        "values ($1, $2, $3, $4) "
        "on conflict (user_id, year) do update "
        "  set target_books = excluded.target_books, "
        "      target_minutes = excluded.target_minutes "
        "returning *",
        [user_id, int(data["year"]), int(data["targetBooks"]), int(data["targetMinutes"])],
    )
    row = rows[0]

    # 用 execute 插入 activities，避免返回行
    from app.db.pool import execute
    await execute(
        "insert into activities (user_id, type, payload) values ($1, 'goal', $2)",
        [user_id, json.dumps({"year": int(data["year"]), "targetBooks": int(data["targetBooks"])})],
    )

    return {
        "year": int(row["year"]),
        "goal": {
            "targetBooks": int(row["target_books"]),
            "targetMinutes": int(row["target_minutes"]),
            "updatedAt": row["updated_at"].isoformat().replace("+00:00", "Z")
                         if row.get("updated_at") else None,
        },
    }
