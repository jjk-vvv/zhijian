"""notes 路由 —— 挂在 /me/notes 下，全部要求登录。"""
from __future__ import annotations

from fastapi import APIRouter, Depends, Query, status
from pydantic import BaseModel, Field
from typing import Literal

from app.deps import get_current_user
from app.services import notes as service

router = APIRouter(prefix="/me/notes", tags=["notes"],
                   dependencies=[Depends(get_current_user)])


class NoteBody(BaseModel):
    bookSlug: str = Field(min_length=1)
    title: str = Field(min_length=1, max_length=60)
    content: str = Field(min_length=1, max_length=3000)
    type: Literal["thought", "excerpt", "review"] = "thought"
    page: int | None = Field(default=None, ge=1, le=10000)
    isPrivate: bool | None = None


class NoteUpdateBody(BaseModel):
    bookSlug: str | None = Field(default=None, min_length=1)
    title: str | None = Field(default=None, min_length=1, max_length=60)
    content: str | None = Field(default=None, min_length=1, max_length=3000)
    type: Literal["thought", "excerpt", "review"] | None = None
    page: int | None = Field(default=None, ge=1, le=10000)
    isPrivate: bool | None = None


@router.get("/")
async def list_notes(
    q: str | None = None,
    type: str | None = None,
    book: str | None = None,
    user: dict = Depends(get_current_user),
):
    return await service.list_notes(str(user["id"]), {"q": q, "type": type, "bookSlug": book})


@router.post("/", status_code=status.HTTP_201_CREATED)
async def create_note(body: NoteBody, user: dict = Depends(get_current_user)):
    return await service.create_note(str(user["id"]), body.model_dump())


@router.patch("/{id}")
async def update_note(id: str, body: NoteUpdateBody, user: dict = Depends(get_current_user)):
    data = body.model_dump(exclude_none=True)
    return await service.update_note(str(user["id"]), id, data)


@router.delete("/{id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_note(id: str, user: dict = Depends(get_current_user)):
    await service.delete_note(str(user["id"]), id)
    return None
