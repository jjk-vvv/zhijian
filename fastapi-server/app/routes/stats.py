"""stats 路由 —— 挂在 /me/stats 下，全部要求登录。"""
from __future__ import annotations

from datetime import datetime

from fastapi import APIRouter, Depends, Query

from app.deps import get_current_user
from app.services import stats as service

router = APIRouter(prefix="/me/stats", tags=["stats"],
                   dependencies=[Depends(get_current_user)])


@router.get("/overview")
async def overview(user: dict = Depends(get_current_user)):
    return await service.overview(str(user["id"]))


@router.get("/heatmap")
async def heatmap(year: int | None = None, user: dict = Depends(get_current_user)):
    return await service.heatmap(str(user["id"]), year)


@router.get("/annual")
async def annual(year: int | None = None, user: dict = Depends(get_current_user)):
    return await service.annual(str(user["id"]), year)


@router.get("/friends-weekly")
async def friends_weekly(user: dict = Depends(get_current_user)):
    return await service.friends_weekly(str(user["id"]))
