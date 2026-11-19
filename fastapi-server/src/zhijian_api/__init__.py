"""命令行入口：``uv run zhijian-api`` 启动 HTTP 服务。

需在 ``fastapi-server`` 目录下执行，以便 ``app`` 包可被导入。
环境变量（``.env``）中的 ``PORT`` 决定监听端口，默认 4000。
"""


def main() -> None:
    import uvicorn

    from app.config import settings

    uvicorn.run(
        "app.main:app",
        host="127.0.0.1",
        port=settings.port,
        reload=settings.node_env != "production",
    )
