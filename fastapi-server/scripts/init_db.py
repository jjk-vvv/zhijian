"""初始化「纸间」数据库：建表 + 可选写入种子数据。

用法（在 ``fastapi-server`` 目录下）::

    uv run python scripts/init_db.py            # 只建表
    uv run python scripts/init_db.py --seed     # 建表并写入示例数据

数据库连接串读取 ``.env`` 中的 ``DATABASE_URL``，与 API 服务完全一致。
"""

from __future__ import annotations

import argparse
import asyncio
import sys
from pathlib import Path

import asyncpg

# 允许直接以脚本方式运行（此时 sys.path[0] 是 scripts/ 而非项目根目录）
sys.path.insert(0, str(Path(__file__).resolve().parent.parent))

from app.config import settings  # noqa: E402

DB_DIR = Path(__file__).resolve().parent.parent / "app" / "db"


def _load_sql(path: Path) -> str:
    """读取 SQL 文件，剔除 psql 专属的元命令（``\\restrict`` 等）。"""
    kept: list[str] = []
    for line in path.read_text(encoding="utf-8").splitlines():
        stripped = line.lstrip()
        if stripped.startswith("\\"):
            continue
        # pg_dump 会清空 search_path，这里保留默认值以便直接执行后续语句
        if "set_config('search_path'" in stripped:
            continue
        kept.append(line)
    return "\n".join(kept)


async def _run(seed: bool) -> None:
    conn = await asyncpg.connect(settings.database_url)
    try:
        print(f"→ 已连接 {settings.database_url.rsplit('/', 1)[-1]}")
        await conn.execute(_load_sql(DB_DIR / "schema.sql"))
        print("→ 表结构已就绪（19 张表）")

        if seed:
            seed_file = DB_DIR / "seed.sql"
            if not seed_file.exists():
                raise SystemExit(f"未找到种子文件：{seed_file}")
            await conn.execute(_load_sql(seed_file))
            print("→ 种子数据已写入")

        rows = await conn.fetchval(
            "select count(*) from information_schema.tables "
            "where table_schema = 'public' and table_type = 'BASE TABLE'"
        )
        books = await conn.fetchval("select count(*) from books")
        users = await conn.fetchval("select count(*) from users")
        print(f"✓ 完成：{rows} 张表 / {books} 本书 / {users} 个用户")
    finally:
        await conn.close()


def main() -> None:
    parser = argparse.ArgumentParser(description="初始化纸间数据库")
    parser.add_argument("--seed", action="store_true", help="同时写入示例数据")
    args = parser.parse_args()
    asyncio.run(_run(args.seed))


if __name__ == "__main__":
    main()
