"""clubs 路由。"""
from __future__ import annotations

import re

from fastapi import APIRouter, Depends, status
from pydantic import BaseModel, Field, field_validator

from app.deps import get_current_user, get_optional_user
from app.services import clubs as service

router = APIRouter(prefix="/clubs", tags=["clubs"])

SLUG_RE = re.compile(r"^[a-z0-9-]{3,48}$")


class ClubBody(BaseModel):
    name: str = Field(min_length=2, max_length=40)
    slug: str | None = Field(default=None, min_length=3, max_length=48)
    description: str | None = Field(default=None, max_length=500)
    bookSlug: str | None = None
    isPrivate: bool | None = None

    @field_validator("slug")
    @classmethod
    def check_slug(cls, v):
        if v is not None and not SLUG_RE.match(v):
            raise ValueError("标识只能包含小写字母、数字和连字符")
        return v


class PostBody(BaseModel):
    content: str = Field(min_length=1, max_length=1000)
    page: int | None = Field(default=None, ge=1, le=10000)


@router.get("/")
async def list_clubs(user: dict | None = Depends(get_optional_user)):
    return await service.list_clubs(str(user["id"]) if user else None)


@router.post("/", status_code=status.HTTP_201_CREATED)
async def create_club(body: ClubBody, user: dict = Depends(get_current_user)):
    return await service.create_club(str(user["id"]), body.model_dump())


@router.get("/{slug}")
async def get_club(slug: str, user: dict | None = Depends(get_optional_user)):
    return await service.get_club(slug, str(user["id"]) if user else None)


@router.post("/{slug}/join")
async def toggle_membership(slug: str, user: dict = Depends(get_current_user)):
    return await service.toggle_membership(str(user["id"]), slug)


@router.post("/{slug}/posts", status_code=status.HTTP_201_CREATED)
async def create_post(slug: str, body: PostBody, user: dict = Depends(get_current_user)):
    return await service.create_post(str(user["id"]), slug, body.model_dump())


@router.delete("/{slug}/posts/{id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_post(slug: str, id: str, user: dict = Depends(get_current_user)):
    await service.delete_post(str(user["id"]), slug, id)
    return None
