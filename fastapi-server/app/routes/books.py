"""books 路由。"""
from __future__ import annotations

from fastapi import APIRouter, Depends, Query
from typing import Any

from app.deps import get_optional_user
from app.services import books as service

router = APIRouter(prefix="/books", tags=["books"])


@router.get("/categories")
async def list_categories():
    return await service.list_categories()


@router.get("/")
async def list_books(
    q: str | None = None,
    category: str | None = None,
    tag: str | None = None,
    sort: str | None = None,
    page: int = Query(default=1, ge=1),
    pageSize: int = Query(default=12, ge=1, le=50),
    user: dict | None = Depends(get_optional_user),
):
    raw = {"q": q, "category": category, "tag": tag, "sort": sort,
           "page": page, "pageSize": pageSize}
    return await service.list_books(raw)


@router.get("/{slug}/rating-distribution")
async def rating_distribution(slug: str):
    return await service.rating_distribution(slug)


@router.get("/{slug}")
async def get_book_detail(slug: str, user: dict | None = Depends(get_optional_user)):
    return await service.get_book_detail(slug, str(user["id"]) if user else None)
