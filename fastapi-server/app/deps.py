"""FastAPI 依赖注入层 —— 替代 Express 的 middleware/auth.js。

提供两个依赖：

- ``get_current_user`` —— 必须登录，否则抛 401
- ``get_optional_user`` —— 有 token 就解析，没 token 或 token 无效都返回 None
"""

from __future__ import annotations

from typing import Any

from fastapi import Header

from app.config import settings
from app.db.pool import fetch_one
from app.errors import unauthorized

try:
    from jose import jwt, JWTError  # type: ignore
except ImportError:  # pragma: no cover
    jwt = None
    JWTError = Exception


async def _resolve_user(token: str) -> dict[str, Any]:
    """解析 JWT 并从数据库查用户，返回用户完整行（含 email）。

    与 Express 的 auth.js resolveUser 逻辑一致。
    """
    if jwt is None:
        raise unauthorized("JWT 库未安装")
    try:
        payload = jwt.decode(token, settings.jwt_secret, algorithms=["HS256"])
    except JWTError:
        raise unauthorized("登录状态已失效，请重新登录")

    sub = payload.get("sub")
    if not sub:
        raise unauthorized("登录状态已失效")

    row = await fetch_one(
        "select id, email, handle, display_name, bio, avatar_color, location, website, is_private, created_at "
        "from users where id = $1",
        [sub],
    )
    if row is None:
        raise unauthorized("账号不存在")

    # 转成 dict（asyncpg.Record → 普通 dict，方便 JSON 序列化）
    return dict(row)


async def get_current_user(
    authorization: str | None = Header(default=None),
) -> dict[str, Any]:
    """``Depends(get_current_user)`` —— 强制要求登录。"""
    if not authorization or not authorization.lower().startswith("bearer "):
        raise unauthorized()
    token = authorization[7:].strip()
    return await _resolve_user(token)


async def get_optional_user(
    authorization: str | None = Header(default=None),
) -> dict[str, Any] | None:
    """``Depends(get_optional_user)`` —— 有就解析，没有或无效都返回 None。"""
    if not authorization or not authorization.lower().startswith("bearer "):
        return None
    token = authorization[7:].strip()
    try:
        return await _resolve_user(token)
    except Exception:
        return None
