# 纸间 API（FastAPI）

「纸间」的后端服务，从 Express 5 完整迁移到 FastAPI，对外 API 契约（路径、方法、请求/响应结构、错误格式、分页）与旧版保持一致，前端 `src/` 与 `uniapp/` 无需改动。

## 技术栈

- FastAPI + Uvicorn（ASGI）
- asyncpg（PostgreSQL 原生异步驱动 + 连接池）
- python-jose（JWT，与旧版 HS256 / 14 天有效期一致）
- bcrypt（与旧版 bcryptjs 哈希互相兼容）
- slowapi（限流）、structlog（结构化日志）
- pydantic-settings（环境变量）

## 目录

```text
fastapi-server/
├── app/
│   ├── main.py            # 应用装配：中间件、异常处理、16 个 router 挂载
│   ├── config.py          # 环境变量（pydantic-settings）
│   ├── deps.py            # get_current_user / get_optional_user
│   ├── errors.py          # ApiError + {error:{code,message,details}} 统一形状
│   ├── db/
│   │   ├── pool.py        # asyncpg 连接池与事务辅助
│   │   ├── schema.sql     # 19 张表、触发器
│   │   └── seed.sql       # 示例数据（52 本书、3 个账号）
│   ├── routes/            # auth books reviews shelf notes highlights sessions
│   │                      # stats goals lists social clubs notifications me health
│   ├── services/          # 与 routes 一一对应的 SQL 业务逻辑
│   └── utils/             # camelCase 序列化、动态记录
└── scripts/init_db.py     # 建表 + 可选种子数据
```

## 运行

需要 Python 3.12+、[uv](https://docs.astral.sh/uv/)、PostgreSQL 18。

```powershell
cd fastapi-server

# 1. 配置环境变量
Copy-Item .env.example .env

# 2. 建表（加 --seed 写入示例数据）
uv sync
uv run python scripts/init_db.py --seed

# 3. 启动
uv run uvicorn app.main:app --host 127.0.0.1 --port 4000
# 或
uv run zhijian-api
```

## API 约定

- 前缀：`/api/v1`
- 鉴权：`Authorization: Bearer <token>`
- 成功：直接返回资源，或分页对象 `{ items, page, pageSize, total }`
- 失败：`{ error: { code, message, details? } }`，code 取值为
  `BAD_REQUEST | UNAUTHORIZED | FORBIDDEN | NOT_FOUND | CONFLICT | RATE_LIMITED | INTERNAL_ERROR | REQUEST_FAILED`
- 尾斜杠：`/api/v1/books` 与 `/api/v1/books/` 均可直接命中（与 Express 行为一致，不做 307 重定向）

## 生产部署

`npm run build` 生成 `dist/` 后，FastAPI 会自动托管静态资源并对非 `/api` 路径回落到 `index.html`，前后端同源部署即可。
