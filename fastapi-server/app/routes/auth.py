"""auth 路由。"""
from __future__ import annotations

from fastapi import APIRouter, Depends, status
from pydantic import BaseModel, EmailStr, Field

from app.deps import get_current_user
from app.services import auth as service

router = APIRouter(prefix="/auth", tags=["auth"])


class RegisterBody(BaseModel):
    email: EmailStr = Field(max_length=120)
    password: str = Field(min_length=8, max_length=72)
    displayName: str = Field(min_length=1, max_length=24)
    handle: str | None = Field(default=None, min_length=3, max_length=24,
                               pattern=r"^[a-z0-9_]+$")


class LoginBody(BaseModel):
    email: EmailStr
    password: str = Field(min_length=1)


class PasswordBody(BaseModel):
    currentPassword: str = Field(min_length=1)
    nextPassword: str = Field(min_length=8, max_length=72)


@router.post("/register", status_code=status.HTTP_201_CREATED)
async def register(body: RegisterBody):
    return await service.register(body.model_dump())


@router.post("/login")
async def login(body: LoginBody):
    return await service.login(body.model_dump())


@router.get("/me")
async def me(user: dict = Depends(get_current_user)):
    return {"user": await service.get_me(str(user["id"]))}


@router.patch("/password")
async def change_password(body: PasswordBody, user: dict = Depends(get_current_user)):
    await service.change_password(str(user["id"]), body.currentPassword, body.nextPassword)
    return {"ok": True}
