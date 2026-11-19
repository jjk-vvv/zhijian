"""me 路由 —— 挂在 /me 下，全部要求登录。"""
from __future__ import annotations

import re

from fastapi import APIRouter, Depends, status
from pydantic import BaseModel, Field, field_validator

from app.deps import get_current_user
from app.services import me as service

router = APIRouter(prefix="/me", tags=["me"],
                   dependencies=[Depends(get_current_user)])

AVATAR_COLOR_RE = re.compile(r"^#[0-9a-fA-F]{6}$")
HANDLE_RE = re.compile(r"^[a-z0-9_]{3,24}$")


class ProfileBody(BaseModel):
    displayName: str | None = Field(default=None, min_length=1, max_length=24)
    handle: str | None = Field(default=None, min_length=3, max_length=24)
    bio: str | None = Field(default=None, max_length=200)
    location: str | None = Field(default=None, max_length=60)
    website: str | None = Field(default=None, max_length=200)
    avatarColor: str | None = None
    isPrivate: bool | None = None

    @field_validator("avatarColor")
    @classmethod
    def check_color(cls, v):
        if v is not None and not AVATAR_COLOR_RE.match(v):
            raise ValueError("请输入合法的颜色值")
        return v

    @field_validator("handle")
    @classmethod
    def check_handle(cls, v):
        if v is not None and not HANDLE_RE.match(v):
            raise ValueError("用户名需为 3–24 位小写字母、数字或下划线")
        return v


class DeleteBody(BaseModel):
    password: str = Field(min_length=1)


@router.patch("/")
async def update_profile(body: ProfileBody, user: dict = Depends(get_current_user)):
    data = body.model_dump(exclude_none=True)
    # handle 统一转小写
    if "handle" in data:
        data["handle"] = data["handle"].lower()
    profile = await service.update_profile(str(user["id"]), data)
    return {"user": profile}


@router.get("/export")
async def export_data(user: dict = Depends(get_current_user)):
    return await service.export_data(str(user["id"]))


@router.post("/import")
async def import_legacy(payload: dict, user: dict = Depends(get_current_user)):
    # pydantic 自动处理；这里直接拿 dict
    return await service.import_legacy(str(user["id"]), payload)


@router.delete("/", status_code=status.HTTP_204_NO_CONTENT)
async def delete_account(body: DeleteBody, user: dict = Depends(get_current_user)):
    await service.delete_account(str(user["id"]), body.password)
    return None
