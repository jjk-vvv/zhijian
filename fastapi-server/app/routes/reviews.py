"""reviews 路由 —— 两个 router：默认 + bookReviewsRouter（mergeParams 挂在 /books/:slug/reviews 下）。"""
from __future__ import annotations

from fastapi import APIRouter, Depends, Query, status
from pydantic import BaseModel, Field, field_validator
from typing import Literal

from app.deps import get_current_user, get_optional_user
from app.services import reviews as service

router = APIRouter(prefix="/reviews", tags=["reviews"])
book_reviews_router = APIRouter(prefix="/books", tags=["reviews-books"])


def _half_star(v: float) -> float:
    if 0.5 <= v <= 5 and (v * 2).is_integer():
        return v
    raise ValueError("评分需以 0.5 星为单位，最低 0.5 最高 5")


class ReviewBody(BaseModel):
    rating: float = Field(ge=0.5, le=5)
    title: str | None = Field(default=None, max_length=80)
    content: str | None = Field(default=None, max_length=5000)
    containsSpoilers: bool | None = None

    @field_validator("rating")
    @classmethod
    def check_half(cls, v):
        if not (v * 2).is_integer():
            raise ValueError("评分需以 0.5 星为单位")
        return v


class CommentBody(BaseModel):
    content: str = Field(min_length=1, max_length=500)


# -------- 默认 /reviews --------

@router.get("/")
async def list_reviews(
    sort: str | None = None,
    book: str | None = None,
    handle: str | None = None,
    scope: str | None = None,
    minRating: float | None = None,
    page: int = Query(default=1, ge=1),
    pageSize: int = Query(default=12, ge=1, le=50),
    user: dict | None = Depends(get_optional_user),
):
    raw = {"sort": sort, "book": book, "handle": handle, "scope": scope,
           "minRating": minRating, "page": page, "pageSize": pageSize}
    return await service.list_reviews(
        str(user["id"]) if user else None, raw)


@router.post("/{id}/like")
async def toggle_like(id: str, user: dict = Depends(get_current_user)):
    return await service.toggle_like(str(user["id"]), id)


@router.get("/{id}/comments")
async def list_comments(id: str):
    return await service.list_comments(id)


@router.post("/{id}/comments", status_code=status.HTTP_201_CREATED)
async def add_comment(id: str, body: CommentBody, user: dict = Depends(get_current_user)):
    return await service.add_comment(str(user["id"]), id, body.content)


@router.delete("/{id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_review(id: str, user: dict = Depends(get_current_user)):
    await service.delete_review(str(user["id"]), id)
    return None


# -------- /books/:slug/reviews --------

@book_reviews_router.get("/{slug}/reviews")
async def book_reviews_list(
    slug: str,
    sort: str | None = None,
    handle: str | None = None,
    scope: str | None = None,
    minRating: float | None = None,
    page: int = Query(default=1, ge=1),
    pageSize: int = Query(default=12, ge=1, le=50),
    user: dict | None = Depends(get_optional_user),
):
    raw = {"sort": sort, "handle": handle, "scope": scope,
           "minRating": minRating, "page": page, "pageSize": pageSize, "book": slug}
    return await service.list_reviews(
        str(user["id"]) if user else None, raw)


@book_reviews_router.put("/{slug}/reviews")
async def book_reviews_upsert(slug: str, body: ReviewBody, user: dict = Depends(get_current_user)):
    return await service.upsert_review(str(user["id"]), slug, body.model_dump())
