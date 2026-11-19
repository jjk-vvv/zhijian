"""lists 路由。"""
from __future__ import annotations

from fastapi import APIRouter, Depends, Query, status
from pydantic import BaseModel, Field

from app.deps import get_current_user, get_optional_user
from app.services import lists as service

router = APIRouter(prefix="/lists", tags=["lists"])


class ListBody(BaseModel):
    title: str = Field(min_length=1, max_length=60)
    description: str | None = Field(default=None, max_length=500)
    isPublic: bool | None = None


class ListUpdateBody(BaseModel):
    title: str | None = Field(default=None, min_length=1, max_length=60)
    description: str | None = Field(default=None, max_length=500)
    isPublic: bool | None = None


class ItemBody(BaseModel):
    bookSlug: str = Field(min_length=1)
    note: str | None = Field(default=None, max_length=300)


@router.get("/")
async def list_lists(
    mine: bool | None = None,
    handle: str | None = None,
    limit: int | None = Query(default=None, ge=1, le=50),
    user: dict | None = Depends(get_optional_user),
):
    return await service.list_lists(
        str(user["id"]) if user else None,
        {"mine": mine, "handle": handle, "limit": limit},
    )


@router.post("/", status_code=status.HTTP_201_CREATED)
async def create_list(body: ListBody, user: dict = Depends(get_current_user)):
    return await service.create_list(str(user["id"]), body.model_dump())


@router.get("/{id}")
async def get_list(id: str, user: dict | None = Depends(get_optional_user)):
    return await service.get_list(id, str(user["id"]) if user else None)


@router.patch("/{id}")
async def update_list(id: str, body: ListUpdateBody, user: dict = Depends(get_current_user)):
    data = body.model_dump(exclude_none=True)
    return await service.update_list(str(user["id"]), id, data)


@router.delete("/{id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_list(id: str, user: dict = Depends(get_current_user)):
    await service.delete_list(str(user["id"]), id)
    return None


@router.post("/{id}/items", status_code=status.HTTP_201_CREATED)
async def add_item(id: str, body: ItemBody, user: dict = Depends(get_current_user)):
    return await service.add_item(str(user["id"]), id, body.model_dump())


@router.delete("/{id}/items/{slug}", status_code=status.HTTP_204_NO_CONTENT)
async def remove_item(id: str, slug: str, user: dict = Depends(get_current_user)):
    await service.remove_item(str(user["id"]), id, slug)
    return None
