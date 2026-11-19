"""social 路由。Express 把 socialRoutes 挂在 /api/v1/ 根下。"""
from __future__ import annotations

from fastapi import APIRouter, Depends, Query

from app.deps import get_current_user, get_optional_user
from app.services import social as service

router = APIRouter(tags=["social"])


@router.get("/feed")
async def get_feed(
    scope: str | None = None,
    limit: int | None = Query(default=None, ge=1, le=50),
    user: dict | None = Depends(get_optional_user),
):
    return await service.get_feed(
        str(user["id"]) if user else None,
        {"scope": scope, "limit": limit},
    )


@router.get("/readers")
async def search_readers(q: str | None = None):
    return await service.search_readers(q)


@router.get("/suggestions")
async def suggestions(user: dict = Depends(get_current_user)):
    return await service.suggestions(str(user["id"]))


@router.get("/users/{handle}")
async def get_profile(handle: str, user: dict | None = Depends(get_optional_user)):
    return await service.get_profile(handle, str(user["id"]) if user else None)


@router.get("/users/{handle}/shelf")
async def get_profile_shelf(handle: str, user: dict | None = Depends(get_optional_user)):
    return await service.get_profile_shelf(handle, str(user["id"]) if user else None)


@router.get("/users/{handle}/content/{type}")
async def get_profile_content(handle: str, type: str, user: dict | None = Depends(get_optional_user)):
    return await service.get_profile_content(handle, str(user["id"]) if user else None, type)


@router.post("/users/{handle}/follow")
async def toggle_follow(handle: str, user: dict = Depends(get_current_user)):
    return await service.toggle_follow(str(user["id"]), handle)
