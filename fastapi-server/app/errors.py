"""统一异常体系 + FastAPI 异常处理器。

保证所有响应都长这样：

.. code-block:: json

   { "error": { "code": "BAD_REQUEST", "message": "请求参数不正确", "details": [...] } }

与 Express 版 server/src/middleware/error.js 完全对齐，前端
src/api/client.js 里的 ApiError 解析逻辑不用动。
"""

from __future__ import annotations

import asyncpg
from fastapi import FastAPI, Request, status
from fastapi.exceptions import RequestValidationError
from fastapi.responses import JSONResponse
from starlette.exceptions import HTTPException as StarletteHTTPException


class ApiError(Exception):
    """所有可控业务异常的基类。"""

    def __init__(
        self,
        status: int,
        code: str,
        message: str,
        details: str | list | None = None,
    ) -> None:
        self.status = status
        self.code = code
        self.message = message
        self.details = details
        super().__init__(message)


# --- 快捷构造器（对应 Express utils/http.js） ---


def bad_request(message: str, details=None) -> ApiError:
    return ApiError(status.HTTP_400_BAD_REQUEST, "BAD_REQUEST", message, details)


def unauthorized(message: str = "登录状态已失效，请重新登录") -> ApiError:
    return ApiError(status.HTTP_401_UNAUTHORIZED, "UNAUTHORIZED", message)


def forbidden(message: str = "没有执行该操作的权限") -> ApiError:
    return ApiError(status.HTTP_403_FORBIDDEN, "FORBIDDEN", message)


def not_found(message: str = "资源不存在") -> ApiError:
    return ApiError(status.HTTP_404_NOT_FOUND, "NOT_FOUND", message)


def conflict(message: str, details=None) -> ApiError:
    return ApiError(status.HTTP_409_CONFLICT, "CONFLICT", message, details)


def rate_limited(message: str = "操作太频繁，请稍后再试") -> ApiError:
    return ApiError(429, "RATE_LIMITED", message)


def internal(message: str = "服务器开小差了，请稍后再试") -> ApiError:
    return ApiError(500, "INTERNAL_ERROR", message)


# --- 注册到 FastAPI ---


def register_exception_handlers(app: FastAPI) -> None:
    """把所有异常都翻译成 Express 风格的 {error:{code,message,details}} JSON。"""

    @app.exception_handler(ApiError)
    async def handle_api_error(_req: Request, exc: ApiError) -> JSONResponse:
        return JSONResponse(
            status_code=exc.status,
            content={"error": {"code": exc.code, "message": exc.message, "details": exc.details}},
        )

    @app.exception_handler(RequestValidationError)
    async def handle_validation(_req: Request, exc: RequestValidationError) -> JSONResponse:
        details = []
        for err in exc.errors():
            path = ".".join(str(p) for p in err["loc"] if p != "body")
            details.append({"path": path, "message": err["msg"], "type": err["type"]})
        return JSONResponse(
            status_code=status.HTTP_400_BAD_REQUEST,
            content={
                "error": {
                    "code": "BAD_REQUEST",
                    "message": "请求参数不正确",
                    "details": details,
                }
            },
        )

    @app.exception_handler(StarletteHTTPException)
    async def handle_starlette(_req: Request, exc: StarletteHTTPException) -> JSONResponse:
        code_map = {
            404: "NOT_FOUND",
            401: "UNAUTHORIZED",
            403: "FORBIDDEN",
            422: "BAD_REQUEST",
        }
        return JSONResponse(
            status_code=exc.status_code,
            content={
                "error": {
                    "code": code_map.get(exc.status_code, "REQUEST_FAILED"),
                    "message": str(exc.detail),
                }
            },
        )

    @app.exception_handler(asyncpg.exceptions.DataError)
    async def handle_bad_uuid(_req: Request, _exc: Exception) -> JSONResponse:
        # 路径里的 id 不是合法 UUID 时，asyncpg 在绑定参数阶段就会报错。
        # 对客户端而言这与「资源不存在」等价，返 404 而不是 500。
        return JSONResponse(
            status_code=status.HTTP_404_NOT_FOUND,
            content={"error": {"code": "NOT_FOUND", "message": "资源不存在"}},
        )

    @app.exception_handler(asyncpg.exceptions.InvalidTextRepresentationError)
    async def handle_invalid_text(_req: Request, _exc: Exception) -> JSONResponse:
        return JSONResponse(
            status_code=status.HTTP_404_NOT_FOUND,
            content={"error": {"code": "NOT_FOUND", "message": "资源不存在"}},
        )

    @app.exception_handler(Exception)
    async def handle_any(_req: Request, exc: Exception) -> JSONResponse:
        # 兜底：数据库约束、asyncpg 异常等都收进来
        return JSONResponse(
            status_code=500,
            content={"error": {"code": "INTERNAL_ERROR", "message": str(exc) or "服务器内部错误"}},
        )
