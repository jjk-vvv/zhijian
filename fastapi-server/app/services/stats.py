"""stats service —— 阅读统计。"""
from __future__ import annotations

import asyncio
from datetime import datetime, date
from typing import Any

from app.db.pool import query
from app.utils.serialize import serialize_book


def _iso(date_obj: date) -> str:
    return date_obj.strftime("%Y-%m-%d")


def _compute_streaks(date_strings: list[str]) -> dict[str, int]:
    if not date_strings:
        return {"current": 0, "longest": 0}
    day_ms = 86_400_000
    set_ = set(date_strings)

    today = datetime.now().replace(hour=0, minute=0, second=0, microsecond=0)
    cursor = today
    if _iso(cursor.date()) not in set_:
        cursor = datetime.fromtimestamp(today.timestamp() - day_ms).replace(hour=0, minute=0, second=0, microsecond=0)
    current = 0
    while _iso(cursor.date()) in set_:
        current += 1
        cursor = datetime.fromtimestamp(cursor.timestamp() - day_ms).replace(hour=0, minute=0, second=0, microsecond=0)

    sorted_ = sorted(set_)
    longest = 1
    run = 1
    for i in range(1, len(sorted_)):
        prev = datetime.strptime(sorted_[i - 1], "%Y-%m-%d")
        val = datetime.strptime(sorted_[i], "%Y-%m-%d")
        diff = (val - prev).days
        if diff == 1:
            run += 1
        else:
            run = 1
        longest = max(longest, run)
    return {"current": current, "longest": longest}


async def _all_session_dates(user_id: str) -> list[str]:
    rows = await query(
        "select distinct to_char(session_date, 'YYYY-MM-DD') as d "
        "from reading_sessions where user_id = $1 "
        "order by d desc limit 500",
        [user_id],
    )
    return [r["d"] for r in rows]


async def overview(user_id: str) -> dict[str, Any]:
    books_rows, reading_rows, content_rows, category_rows, dates = await asyncio.gather(
        query(
            "select count(*)::int as total, "
            "count(*) filter (where status = 'wishlist')::int as wishlist, "
            "count(*) filter (where status = 'reading')::int as reading, "
            "count(*) filter (where status = 'finished')::int as finished, "
            "count(*) filter (where status = 'dnf')::int as dnf "
            "from user_books where user_id = $1",
            [user_id],
        ),
        query(
            "select count(*)::int as sessions, "
            "coalesce(sum(minutes), 0)::int as minutes, "
            "coalesce(sum(pages), 0)::int as pages, "
            "coalesce(sum(minutes) filter (where session_date = current_date), 0)::int as today_minutes, "
            "coalesce(sum(minutes) filter (where session_date >= date_trunc('week', current_date)::date), 0)::int as week_minutes, "
            "count(*) filter (where session_date = current_date)::int as today_sessions "
            "from reading_sessions where user_id = $1",
            [user_id],
        ),
        query(
            "select "
            "(select count(*)::int from notes where user_id = $1) as notes, "
            "(select count(*)::int from highlights where user_id = $1) as highlights, "
            "(select count(*)::int from reviews where user_id = $1) as reviews, "
            "(select coalesce(round(avg(rating)::numeric, 2), 0)::float from reviews where user_id = $1) as rating_avg, "
            "(select count(*)::int from lists where user_id = $1) as lists",
            [user_id],
        ),
        query(
            "select b.category as name, count(*)::int as count "
            "from user_books ub join books b on b.id = ub.book_id "
            "where ub.user_id = $1 and ub.status in ('reading', 'finished') "
            "group by b.category order by count desc limit 4",
            [user_id],
        ),
        _all_session_dates(user_id),
    )

    streaks = _compute_streaks(dates)
    reading_d = dict(reading_rows[0]) if reading_rows else {}
    return {
        "books": dict(books_rows[0]) if books_rows else {},
        "reading": {
            **reading_d,
            "currentStreak": streaks["current"],
            "longestStreak": streaks["longest"],
        },
        "content": dict(content_rows[0]) if content_rows else {},
        "topCategories": [dict(r) for r in category_rows],
    }


async def heatmap(user_id: str, year: int | None) -> dict[str, Any]:
    target_year = int(year) if year else datetime.now().year
    rows = await query(
        "select to_char(session_date, 'YYYY-MM-DD') as date, "
        "coalesce(sum(minutes), 0)::int as minutes, "
        "coalesce(sum(pages), 0)::int as pages, "
        "count(*)::int as sessions "
        "from reading_sessions "
        "where user_id = $1 and extract(year from session_date) = $2 "
        "group by session_date "
        "order by session_date",
        [user_id, target_year],
    )
    return {"year": target_year, "days": [dict(r) for r in rows]}


async def annual(user_id: str, year: int | None) -> dict[str, Any]:
    target_year = int(year) if year else datetime.now().year

    finished_books, monthly, categories, content_result, dates = await asyncio.gather(
        query(
            "select b.*, ub.finished_at "
            "from user_books ub join books b on b.id = ub.book_id "
            "where ub.user_id = $1 and ub.status = 'finished' "
            "and extract(year from coalesce(ub.finished_at, ub.updated_at)) = $2 "
            "order by coalesce(ub.finished_at, ub.updated_at) desc",
            [user_id, target_year],
        ),
        query(
            "select extract(month from session_date)::int as month, "
            "coalesce(sum(minutes), 0)::int as minutes, "
            "coalesce(sum(pages), 0)::int as pages, "
            "count(distinct session_date)::int as days "
            "from reading_sessions "
            "where user_id = $1 and extract(year from session_date) = $2 "
            "group by 1 order by 1",
            [user_id, target_year],
        ),
        query(
            "select b.category as name, count(*)::int as count "
            "from user_books ub join books b on b.id = ub.book_id "
            "where ub.user_id = $1 and ub.status = 'finished' "
            "and extract(year from coalesce(ub.finished_at, ub.updated_at)) = $2 "
            "group by b.category order by count desc",
            [user_id, target_year],
        ),
        query(
            "select "
            "(select count(*)::int from reviews r where r.user_id = $1 and extract(year from r.created_at) = $2) as reviews, "
            "(select count(*)::int from notes n where n.user_id = $1 and extract(year from n.created_at) = $2) as notes, "
            "(select count(*)::int from highlights h where h.user_id = $1 and extract(year from h.created_at) = $2) as highlights, "
            "(select coalesce(sum(minutes), 0)::int from reading_sessions s where s.user_id = $1 and extract(year from s.session_date) = $2) as minutes, "
            "(select coalesce(sum(pages), 0)::int from reading_sessions s where s.user_id = $1 and extract(year from s.session_date) = $2) as pages, "
            "(select count(distinct session_date)::int from reading_sessions s where s.user_id = $1 and extract(year from s.session_date) = $2) as active_days",
            [user_id, target_year],
        ),
        query(
            "select distinct to_char(session_date, 'YYYY-MM-DD') as d "
            "from reading_sessions "
            "where user_id = $1 and extract(year from session_date) = $2 "
            "order by d",
            [user_id, target_year],
        ),
    )

    streaks = _compute_streaks([r["d"] for r in dates])

    finished_items = []
    for r in finished_books:
        d = dict(r)
        d["id"] = int(d["id"])
        book = serialize_book(d) or {}
        book["finishedAt"] = d["finished_at"].isoformat().replace("+00:00", "Z") if d.get("finished_at") else None
        finished_items.append(book)

    content = dict(content_result[0]) if content_result else {}
    return {
        "year": target_year,
        "booksFinished": len(finished_books),
        "books": finished_items,
        "months": [dict(r) for r in monthly],
        "categories": [dict(r) for r in categories],
        **content,
        "longestStreak": streaks["longest"],
    }


async def friends_weekly(user_id: str) -> dict[str, Any]:
    rows = await query(
        "with circle as ("
        "  select $1::uuid as id "
        "  union "
        "  select following_id from follows where follower_id = $1 "
        ") "
        "select u.id, u.handle, u.display_name, u.avatar_color, "
        "coalesce(sum(s.minutes), 0)::int as minutes, "
        "count(s.id)::int as sessions, "
        "(select count(*)::int from user_books ub where ub.user_id = u.id and ub.status = 'finished') as books_count "
        "from circle c "
        "join users u on u.id = c.id "
        "left join reading_sessions s on s.user_id = c.id and s.session_date >= date_trunc('week', current_date)::date "
        "group by u.id "
        "order by minutes desc, u.display_name asc "
        "limit 10",
        [user_id],
    )
    items = []
    for r in rows:
        d = dict(r)
        items.append({
            "user": {
                "id": str(d["id"]),
                "handle": d["handle"],
                "displayName": d["display_name"],
                "avatarColor": d["avatar_color"],
            },
            "minutes": int(d["minutes"]),
            "sessions": int(d["sessions"]),
            "booksCount": int(d["books_count"]),
        })
    return {"items": items}
