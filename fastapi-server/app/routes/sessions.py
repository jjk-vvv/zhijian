"""sessions 路由 —— 挂在 /me/sessions 下，全部要求登录。"""
from __future__ import annotations

import re

from fastapi import APIRouter, Depends, Query, status
from pydantic import BaseModel, Field, field_validator

from app.deps import get_current_user
from app.services import sessions as service

router = APIRouter(prefix="/me/sessions", tags=["sessions"],
                   dependencies=[Depends(get_current_user)])

DATE_RE = re.compile(r"^\d{4}-\d{2}-\d{2}$")


class SessionBody(BaseModel):
    bookSlug: str = Field(min_length=1)
    minutes: int = Field(ge=1, le=1440)
    pages: int | None = Field(default=None, ge=0, le=5000)
    date: str | None = None
    note: str | None = Field(default=None, max_length=300)
    progress: float | None = Field(default=None, ge=0, le=100)

    @field_validator("date")
    @classmethod
    def check_date(cls, v):
        if v is not None and not DATE_RE.match(v):
            raise ValueError("日期格式应为 YYYY-MM-DD")
        return v


@router.get("/")
async def list_sessions(
    from_: str | None = Query(default=None, alias="from"),
    to: str | None = None,
    limit: int | None = Query(default=None, ge=1, le=365),
    user: dict = Depends(get_current_user),
):
    return await service.list_sessions(str(user["id"]),
                                       {"from": from_, "to": to, "limit": limit})


@router.post("/", status_code=status.HTTP_201_CREATED)
async def create_session(body: SessionBody, user: dict = Depends(get_current_user)):
    return await service.create_session(str(user["id"]), body.model_dump())


@router.delete("/{id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_session(id: str, user: dict = Depends(get_current_user)):
    await service.delete_session(str(user["id"]), id)
    return None
