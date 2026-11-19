"""notifications 路由 —— 要求登录。"""
from __future__ import annotations

from fastapi import APIRouter, Depends, status

from app.deps import get_current_user
from app.services import notifications as service

router = APIRouter(prefix="/notifications", tags=["notifications"],
                   dependencies=[Depends(get_current_user)])


@router.get("/")
async def list_notifications(unread: str | None = None, user: dict = Depends(get_current_user)):
    return await service.list_notifications(str(user["id"]), {"unreadOnly": unread == "1"})


@router.post("/read-all")
async def mark_all_read(user: dict = Depends(get_current_user)):
    return await service.mark_all_read(str(user["id"]))


@router.post("/{id}/read")
async def mark_read(id: str, user: dict = Depends(get_current_user)):
    await service.mark_read(str(user["id"]), id)
    return {"ok": True}
