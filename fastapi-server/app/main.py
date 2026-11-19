"""FastAPI 应用入口 —— 替代 Express 的 app.js + server.js。"""

from __future__ import annotations

from contextlib import asynccontextmanager
from pathlib import Path

from fastapi import APIRouter, FastAPI, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import FileResponse, JSONResponse
from fastapi.routing import APIRoute
from fastapi.staticfiles import StaticFiles
from slowapi import Limiter
from slowapi.errors import RateLimitExceeded
from slowapi.middleware import SlowAPIMiddleware
from slowapi.util import get_remote_address
import structlog

from app.config import settings
from app.db.pool import close_pool, create_pool
from app.errors import not_found, register_exception_handlers
from app.routes import (
    auth,
    books,
    clubs,
    goals,
    health,
    highlights,
    lists,
    me,
    notes,
    notifications,
    reviews,
    sessions,
    shelf,
    social,
    stats,
)

log = structlog.get_logger()


@asynccontextmanager
async def lifespan(app: FastAPI):
    # startup
    await create_pool()
    log.info("zhijian-api 已启动", port=settings.port, env=settings.node_env)
    try:
        yield
    finally:
        # shutdown
        await close_pool()
        log.info("zhijian-api 已关闭")


limiter = Limiter(
    key_func=get_remote_address,
    default_limits=["2000/minute"] if settings.node_env != "production" else ["120/minute"],
)


def _add_slashless_aliases(router: APIRouter) -> None:
    """为 router 内以 ``/`` 结尾的路由补一条无尾斜杠的等价路由。

    Express 挂载 ``router.get('/')`` 后，``/api/v1/me/shelf`` 与 ``/api/v1/me/shelf/``
    都会直接命中，不会重定向。FastAPI 默认对前者返回 307，而部分客户端
    （PowerShell、部分原生 HTTP 库）跟随重定向时会丢弃 Authorization 头，
    导致本应 200 的请求变成 401。

    这里直接注册两条路径，与 Express 行为完全一致，彻底避免重定向。
    """
    existing = {
        (r.path, m) for r in router.routes if isinstance(r, APIRoute) for m in r.methods
    }
    for route in list(router.routes):
        if not isinstance(route, APIRoute):
            continue
        path = route.path
        if path == "/" or not path.endswith("/"):
            continue
        alias_path = path.rstrip("/")
        if not alias_path or (alias_path, next(iter(route.methods))) in existing:
            continue
        for m in route.methods:
            existing.add((alias_path, m))
        router.routes.append(
            APIRoute(
                path=alias_path,
                endpoint=route.endpoint,
                response_model=route.response_model,
                status_code=route.status_code,
                tags=route.tags,
                dependencies=route.dependencies,
                summary=route.summary,
                description=route.description,
                response_description=route.response_description,
                responses=route.responses,
                deprecated=route.deprecated,
                methods=route.methods,
                name=route.name,
                include_in_schema=False,
            )
        )


def create_app() -> FastAPI:
    app = FastAPI(
        title="纸间 API",
        version="1.0.0",
        docs_url=None,   # 生产关掉；开发需要时打开
        redoc_url=None,
        openapi_url=None,
        lifespan=lifespan,
        # 注意：redirect_slashes=True 时 FastAPI 会把 /api/v1/books 307 重定向到 /api/v1/books/
        # 浏览器 fetch 会正确跟随 307 并保留 Authorization header（same-origin）
        # Vite dev server 代理链路下同样没问题
        # 只有 PowerShell Invoke-WebRequest 跟随重定向时会丢自定义 headers —— 这是测试工具问题
        redirect_slashes=True,
    )
    app.state.limiter = limiter

    # ---- 中间件 ----
    app.add_middleware(SlowAPIMiddleware)
    app.add_middleware(
        CORSMiddleware,
        allow_origins=settings.cors_origins_list,
        allow_methods=["*"],
        allow_headers=["*"],
        allow_credentials=False,
    )

    # ---- 异常处理 ----
    register_exception_handlers(app)

    @app.exception_handler(RateLimitExceeded)
    async def handle_rate_limit(_req: Request, _exc: RateLimitExceeded) -> JSONResponse:
        return JSONResponse(
            status_code=429,
            content={
                "error": {"code": "RATE_LIMITED", "message": "操作太频繁，请稍后再试"}
            },
        )

    # ---- 路由挂载（全部 /api/v1 前缀，与 Express 完全一致） ----
    # 注意：book_reviews_router 必须先于 books.router，保证 /books/{slug}/reviews 优先匹配
    for router in [
        health.router,
        auth.router,
        reviews.book_reviews_router,
        books.router,
        reviews.router,
        shelf.router,
        notes.router,
        highlights.router,
        sessions.router,
        stats.router,
        goals.router,
        lists.router,
        social.router,
        clubs.router,
        notifications.router,
        me.router,
    ]:
        _add_slashless_aliases(router)
        app.include_router(router, prefix="/api/v1")

    # ---- 生产环境：托管前端构建产物（等价于 Express 的 express.static('dist')） ----
    dist = Path(__file__).resolve().parent.parent.parent / "dist"
    if dist.is_dir():
        if (dist / "assets").is_dir():
            app.mount("/assets", StaticFiles(directory=dist / "assets"), name="assets")

        @app.get("/{full_path:path}", include_in_schema=False)
        async def spa_fallback(full_path: str):
            if full_path.startswith("api/"):
                raise not_found("接口不存在")
            candidate = dist / full_path
            if full_path and candidate.is_file():
                return FileResponse(candidate)
            return FileResponse(dist / "index.html")

    return app


app = create_app()
