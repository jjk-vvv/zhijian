"""goals 路由 —— 挂在 /me/goals 下，全部要求登录。"""
from __future__ import annotations

from fastapi import APIRouter, Depends, status
from pydantic import BaseModel, Field

from app.deps import get_current_user
from app.services import goals as service

router = APIRouter(prefix="/me/goals", tags=["goals"],
                   dependencies=[Depends(get_current_user)])


class GoalBody(BaseModel):
    year: int = Field(ge=2000, le=2100)
    targetBooks: int = Field(ge=1, le=999)
    targetMinutes: int = Field(ge=60, le=1_000_000)


@router.get("/")
async def get_goal(year: int | None = None, user: dict = Depends(get_current_user)):
    return await service.get_goal(str(user["id"]), year)


@router.put("/")
async def set_goal(body: GoalBody, user: dict = Depends(get_current_user)):
    return await service.set_goal(str(user["id"]), body.model_dump())
