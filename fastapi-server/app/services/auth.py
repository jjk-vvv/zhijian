"""auth service —— 注册 / 登录 / 获取自身 / 修改密码。"""
from __future__ import annotations

import random
import re
from datetime import timedelta
from typing import Any

import bcrypt as _bcrypt
from jose import jwt

from app.config import settings
from app.db.pool import query, fetch_one
from app.errors import bad_request, unauthorized, conflict
from app.utils.serialize import serialize_user


def _hash_pw(password: str) -> str:
    """与 Express 的 bcryptjs.hashSync(password, 10) 1:1 兼容。"""
    return _bcrypt.hashpw(
        password.encode("utf-8"), _bcrypt.gensalt(rounds=10)
    ).decode("utf-8")


def _verify_pw(password: str, hashed: str) -> bool:
    try:
        return _bcrypt.checkpw(password.encode("utf-8"), hashed.encode("utf-8"))
    except (ValueError, TypeError):
        return False

HANDLE_RE = re.compile(r"^[a-z0-9_]{3,24}$")
AVATAR_COLORS = ["#294b3c", "#7a5b3f", "#3d5366", "#8a5a4a", "#5f6b48", "#6d5a72"]


def sign_token(user: dict[str, Any]) -> str:
    return jwt.encode(
        {"sub": str(user["id"]), "handle": user["handle"]},
        settings.jwt_secret,
        algorithm="HS256",
    )


def build_handle(handle: str | None, email: str) -> str:
    if handle:
        return handle.lower()
    base = (email.split("@")[0].lower().replace(re.sub(r"[^a-z0-9_]", "", email), "")[:14]
            or email.split("@")[0].lower())[:14]
    base = re.sub(r"[^a-z0-9_]", "", base)[:14]
    prefix = base if len(base) >= 3 else "reader"
    suffix = "".join(random.choice("abcdefghijklmnopqrstuvwxyz0123456789") for _ in range(4))
    return f"{prefix}_{suffix}"


async def register(data: dict[str, Any]) -> dict[str, Any]:
    normalized_email = data["email"].strip().lower()
    final_handle = build_handle(data.get("handle"), normalized_email)
    if not HANDLE_RE.match(final_handle):
        raise bad_request("用户名只能包含小写字母、数字和下划线，长度 3–24 位")

    email_taken = await query("select 1 from users where lower(email) = $1", [normalized_email])
    if len(email_taken):
        raise conflict("该邮箱已注册，可直接登录")

    handle_taken = await query("select 1 from users where handle = $1", [final_handle])
    if len(handle_taken):
        raise conflict("该用户名已被使用，换一个试试")

    password_hash = _hash_pw(data["password"])
    avatar_color = random.choice(AVATAR_COLORS)

    rows = await query(
        "insert into users (email, password_hash, handle, display_name, avatar_color) "
        "values ($1, $2, $3, $4, $5) returning *",
        [normalized_email, password_hash, final_handle, data["displayName"].strip(), avatar_color],
    )
    user = dict(rows[0])

    await query(
        "insert into goals (user_id, year, target_books, target_minutes) "
        "values ($1, extract(year from now())::int, 24, 7200) "
        "on conflict (user_id, year) do nothing",
        [user["id"]],
    )

    return {"user": serialize_user(user, include_email=True), "token": sign_token(user)}


async def login(data: dict[str, Any]) -> dict[str, Any]:
    rows = await query(
        "select * from users where lower(email) = lower($1)",
        [data["email"].strip()],
    )
    if not rows:
        raise unauthorized("邮箱或密码不正确")
    row = dict(rows[0])
    if not _verify_pw(data["password"], row["password_hash"]):
        raise unauthorized("邮箱或密码不正确")
    return {"user": serialize_user(row, include_email=True), "token": sign_token(row)}


async def get_me(user_id: str) -> dict[str, Any]:
    rows = await query(
        "select u.*, "
        "(select count(*) from follows f where f.following_id = u.id) as followers_count, "
        "(select count(*) from follows f where f.follower_id = u.id) as following_count, "
        "(select count(*) from user_books ub where ub.user_id = u.id) as books_count "
        "from users u where u.id = $1",
        [user_id],
    )
    if not rows:
        raise unauthorized("账号不存在")
    return serialize_user(dict(rows[0]), include_email=True)


async def change_password(user_id: str, current_password: str, next_password: str) -> None:
    row = await fetch_one("select password_hash from users where id = $1", [user_id])
    if row is None:
        raise unauthorized()
    if not _verify_pw(current_password, row["password_hash"]):
        raise bad_request("当前密码不正确")
    new_hash = _hash_pw(next_password)
    await query("update users set password_hash = $1 where id = $2", [new_hash, user_id])
