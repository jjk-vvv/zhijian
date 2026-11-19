"""asyncpg 连接池 —— 替代 Express 的 server/src/db/pool.js。

与 Express 版导出 `query / withTransaction` 的方式保持完全一致，
业务 service 里可以直接 ``from app.db.pool import query, with_transaction``。
"""

from __future__ import annotations

from typing import Any, Callable, Sequence

import asyncpg

from app.config import settings

_pool: asyncpg.Pool | None = None


async def create_pool() -> asyncpg.Pool:
    global _pool
    if _pool is not None:
        return _pool
    _pool = await asyncpg.create_pool(
        settings.database_url,
        min_size=2,
        max_size=10,
    )
    return _pool


async def close_pool() -> None:
    global _pool
    if _pool is not None:
        await _pool.close()
        _pool = None


async def query(text: str, params: Sequence[Any] | None = None) -> list[asyncpg.Record]:
    """执行只读或写查询，返回 ``list[asyncpg.Record]``（可 ``row['col']`` 或 ``row.col`` 访问）。"""
    pool = await create_pool()
    if params:
        return await pool.fetch(text, *params)
    return await pool.fetch(text)


async def with_transaction(handler: Callable[[asyncpg.Connection], Any]) -> Any:
    """在一个事务里执行 handler，handler 接收一个 asyncpg.Connection。

    用法：
    .. code-block:: python

       async def insert_twice():
           async def _inner(conn):
               await conn.execute(...)
               await conn.execute(...)
               return rows
           return await with_transaction(_inner)
    """
    pool = await create_pool()
    async with pool.acquire() as conn:
        async with conn.transaction():
            return await handler(conn)


async def execute(text: str, params: Sequence[Any] | None = None) -> None:
    """执行不需要返回值的语句（例如 ``INSERT ... ON CONFLICT DO NOTHING``）。"""
    pool = await create_pool()
    if params:
        await pool.execute(text, *params)
    else:
        await pool.execute(text)


async def fetch_one(text: str, params: Sequence[Any] | None = None) -> asyncpg.Record | None:
    """便捷方法：只取第一行。"""
    pool = await create_pool()
    if params:
        return await pool.fetchrow(text, *params)
    return await pool.fetchrow(text)
