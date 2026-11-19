"""环境配置 —— 替代 Express 的 server/src/config/env.js + Zod 校验。

环境变量直接从根目录 ``.env`` 读取（与 Express 共用同一个），
也可以通过当前目录的 ``.env`` 覆盖。字段名沿用 Express 版：
DATABASE_URL / JWT_SECRET / JWT_EXPIRES_IN / PORT / NODE_ENV / CORS_ORIGIN。
"""

from __future__ import annotations

from functools import cached_property
from pathlib import Path

from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    database_url: str = "postgres://postgres@127.0.0.1:5433/zhijian"
    jwt_secret: str = "zhijian-local-dev-secret-please-change-in-production-2026"
    jwt_expires_in: str = "14d"  # python-jose 不直接吃这个，下面自己解析
    port: int = 4000
    node_env: str = "development"
    cors_origins: str = "http://127.0.0.1:5173,http://localhost:5173"

    model_config = SettingsConfigDict(
        env_file=(Path(__file__).resolve().parent.parent.parent / ".env"),
        env_file_encoding="utf-8",
        extra="ignore",
    )

    @cached_property
    def cors_origins_list(self) -> list[str]:
        if self.node_env != "production":
            return ["*"]
        return [o.strip() for o in self.cors_origins.split(",") if o.strip()]

    @cached_property
    def jwt_expires_seconds(self) -> int:
        """把 Express 版的 ``'14d'`` 之类字符串解析成秒数。"""
        token = self.jwt_expires_in.strip().lower()
        multipliers = {
            "w": 7 * 24 * 3600,
            "d": 24 * 3600,
            "h": 3600,
            "m": 60,
            "s": 1,
        }
        for unit, factor in multipliers.items():
            if token.endswith(unit):
                return int(float(token[: -len(unit)]) * factor)
        try:
            return int(token)
        except ValueError:
            return 14 * 24 * 3600  # 兜底 14 天


settings = Settings()
