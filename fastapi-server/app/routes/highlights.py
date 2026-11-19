"""highlights 路由 —— 挂在 /me/highlights 下，全部要求登录。"""
from __future__ import annotations

from fastapi import APIRouter, Depends, Query, status
from pydantic import BaseModel, Field

from app.deps import get_current_user
from app.services import highlights as service

router = APIRouter(prefix="/me/highlights", tags=["highlights"],
                   dependencies=[Depends(get_current_user)])


class HighlightBody(BaseModel):
    bookSlug: str = Field(min_length=1)
    quote: str = Field(min_length=1, max_length=1000)
    page: int | None = Field(default=None, ge=1, le=10000)
    note: str | None = Field(default=None, max_length=1000)
    isPrivate: bool | None = None


@router.get("/daily")
async def daily_highlight(user: dict = Depends(get_current_user)):
    return await service.daily_highlight(str(user["id"]))


@router.get("/")
async def list_highlights(
    q: str | None = None,
    book: str | None = None,
    user: dict = Depends(get_current_user),
):
    return await service.list_highlights(str(user["id"]), {"q": q, "bookSlug": book})


@router.post("/", status_code=status.HTTP_201_CREATED)
async def create_highlight(body: HighlightBody, user: dict = Depends(get_current_user)):
    return await service.create_highlight(str(user["id"]), body.model_dump())


@router.delete("/{id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_highlight(id: str, user: dict = Depends(get_current_user)):
    await service.delete_highlight(str(user["id"]), id)
    return None
