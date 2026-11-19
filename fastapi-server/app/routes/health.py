"""健康检查端点。"""
from fastapi import APIRouter

router = APIRouter(tags=["health"])


@router.get("/health")
async def health():
    return {"ok": True, "service": "zhijian-api"}
