"""shelf 路由 —— 挂在 /me/shelf 下，全部要求登录。"""
from __future__ import annotations

from fastapi import APIRouter, Depends, Query, status
from pydantic import BaseModel, Field, root_validator
from typing import Literal

from app.deps import get_current_user
from app.services import shelf as service

router = APIRouter(prefix="/me/shelf", tags=["shelf"],
                   dependencies=[Depends(get_current_user)])


class AddBody(BaseModel):
    bookSlug: str = Field(min_length=1)
    status: Literal["wishlist", "reading", "finished", "dnf"] = "wishlist"


class UpdateBody(BaseModel):
    status: Literal["wishlist", "reading", "finished", "dnf"] | None = None
    progress: float | None = Field(default=None, ge=0, le=100)

    @root_validator(skip_on_failure=True)
    def check_at_least_one(cls, values):
        if values.get("status") is None and values.get("progress") is None:
            raise ValueError("至少提供状态或进度")
        return values


@router.get("/")
async def list_shelf(
    status: str | None = None,
    user: dict = Depends(get_current_user),
):
    return await service.list_shelf(str(user["id"]), status)


@router.post("/", status_code=status.HTTP_201_CREATED)
async def add_to_shelf(body: AddBody, user: dict = Depends(get_current_user)):
    return await service.add_to_shelf(str(user["id"]), body.bookSlug, body.status)


@router.patch("/{slug}")
async def update_shelf(slug: str, body: UpdateBody, user: dict = Depends(get_current_user)):
    data = body.model_dump(exclude_none=True)
    return await service.update_shelf(str(user["id"]), slug, data)


@router.delete("/{slug}", status_code=status.HTTP_204_NO_CONTENT)
async def remove_from_shelf(slug: str, user: dict = Depends(get_current_user)):
    await service.remove_from_shelf(str(user["id"]), slug)
    return None
