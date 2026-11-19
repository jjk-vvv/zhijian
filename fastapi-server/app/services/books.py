"""books service —— 图书列表 / 详情 / 分类 / 评分分布。"""
from __future__ import annotations

import asyncio
import json
from typing import Any

from app.db.pool import query
from app.errors import not_found
from app.utils.serialize import serialize_book, serialize_shelf_entry, serialize_review, paginated

SORTS = {
    "curated": "b.id asc",
    "rating": "b.rating_avg desc, b.rating_count desc",
    "popular": "b.rating_count desc, b.id asc",
    "year": "b.published_year desc nulls last",
    "title": "b.title asc",
}


async def list_books(raw_query: dict[str, Any]) -> dict[str, Any]:
    page = max(1, int(raw_query.get("page") or 1))
    page_size = min(50, max(1, int(raw_query.get("pageSize") or 12)))
    offset = (page - 1) * page_size

    conditions: list[str] = []
    params: list[Any] = []

    q = (raw_query.get("q") or "").strip()
    if q:
        params.append(f"%{q}%")
        p = len(params)
        conditions.append(
            f"(b.title ilike ${p} or b.author ilike ${p} or b.english ilike ${p})"
        )

    category = raw_query.get("category")
    if category and category != "全部书籍":
        params.append(category)
        conditions.append(f"b.category = ${len(params)}")

    tag = (raw_query.get("tag") or "").strip()
    if tag:
        params.append(tag)
        conditions.append(
            f"exists (select 1 from book_tags t where t.book_id = b.id and t.name = ${len(params)})"
        )

    where = f"where {' and '.join(conditions)}" if conditions else ""
    order = SORTS.get(raw_query.get("sort"), SORTS["curated"])

    rows, count_rows = await asyncio.gather(
        query(
            "select b.*, "
            "coalesce((select json_agg(json_build_object('kind', t.kind, 'name', t.name)) "
            "from book_tags t where t.book_id = b.id), '[]') as tags "
            f"from books b {where} order by {order} "
            f"limit ${len(params) + 1} offset ${len(params) + 2}",
            params + [page_size, offset],
        ),
        query(
            f"select count(*)::int as total from books b {where}",
            params,
        ),
    )

    items = []
    for r in rows:
        d = dict(r)
        d["id"] = int(d["id"])
        items.append(serialize_book(d))
    total = count_rows[0]["total"] if count_rows else 0
    return paginated(items, page, page_size, total)


async def list_categories() -> dict[str, Any]:
    rows = await query(
        "select category, count(*)::int as count from books group by category order by min(id)"
    )
    return {"items": [{"name": r["category"], "count": r["count"]} for r in rows]}


async def get_book_detail(slug: str, user_id: str | None) -> dict[str, Any]:
    rows = await query(
        "select b.*, "
        "coalesce("
        "  json_agg(json_build_object('kind', t.kind, 'name', t.name))"
        "  filter (where t.id is not null), '[]'"
        ") as tags "
        "from books b "
        "left join book_tags t on t.book_id = b.id "
        "where b.slug = $1 "
        "group by b.id",
        [slug],
    )
    if not rows:
        raise not_found("这本书不在书库中")
    row = dict(rows[0])
    row["id"] = int(row["id"])
    row["tags"] = json.loads(row["tags"]) if isinstance(row["tags"], str) else row["tags"]

    related_rows = await query(
        "select b.* from books b "
        "where b.id <> $1 and (b.category = $2 or $3 = any(array(select name from book_tags where book_id = b.id))) "
        "order by abs(coalesce(b.published_year, 0) - coalesce($4, 0)) asc, b.rating_avg desc "
        "limit 6",
        [row["id"], row["category"], row.get("tag"), row.get("published_year")],
    )
    readers_rows = await query(
        "select count(*)::int as readers, "
        "count(*) filter (where status = 'finished')::int as finished "
        "from user_books where book_id = $1",
        [row["id"]],
    )

    my_shelf = None
    my_review = None
    if user_id:
        shelf_rows = await query(
            "select * from user_books where user_id = $1 and book_id = $2",
            [user_id, row["id"]],
        )
        if shelf_rows:
            my_shelf = serialize_shelf_entry(dict(shelf_rows[0]))
        review_rows = await query(
            "select r.*, u.handle as user_handle, u.display_name as user_display_name, "
            "u.avatar_color as user_avatar_color "
            "from reviews r join users u on u.id = r.user_id "
            "where r.user_id = $1 and r.book_id = $2",
            [user_id, row["id"]],
        )
        if review_rows:
            my_review = serialize_review(dict(review_rows[0]), include_user=False)
            # 补充必要字段
            if my_review:
                my_review["user"] = {
                    "id": str(user_id),
                    "handle": review_rows[0]["user_handle"],
                    "displayName": review_rows[0]["user_display_name"],
                    "avatarColor": review_rows[0]["user_avatar_color"],
                }

    return {
        "book": serialize_book(row),
        "related": [serialize_book(dict(r)) for r in related_rows],
        "readers": readers_rows[0]["readers"],
        "finished": readers_rows[0]["finished"],
        "myShelf": my_shelf,
        "myReview": my_review,
    }


async def rating_distribution(slug: str) -> dict[str, Any]:
    rows = await query(
        "select r.rating::float as rating, count(*)::int as count "
        "from reviews r join books b on b.id = r.book_id "
        "where b.slug = $1 "
        "group by r.rating "
        "order by r.rating desc",
        [slug],
    )
    return {"items": [{"rating": r["rating"], "count": r["count"]} for r in rows]}


async def find_by_slug(slug: str) -> dict[str, Any]:
    rows = await query("select * from books where slug = $1", [slug])
    if not rows:
        raise not_found("这本书不在书库中")
    row = dict(rows[0])
    row["id"] = int(row["id"])
    return row
