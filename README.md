# 纸间 · 阅读生活网站

一个完整的阅读社区全栈项目：发现好书、管理书架、记录手记与划线、统计阅读、撰写书评、加入书友会。前端 Vue 3 + Vite，后端 FastAPI + PostgreSQL。

> `uniapp/` 目录是迁移后的 uni-app 工程（H5 / App / 微信小程序），通过同一套 REST API 与 Bearer Token 与 Web 端共享数据。运行步骤见 [`uniapp/README.md`](uniapp/README.md)。

## 技术栈

- 前端：Vue 3.5（`<script setup>`）、Vite 8、Vue Router 5、Hash 路由、纯 SVG/CSS 图表
- 后端：FastAPI（Python 3.12）、asyncpg、python-jose、bcrypt、slowapi、structlog
- 数据库：PostgreSQL 18，19 张表、触发器维护 `updated_at` 与书籍评分聚合

## 功能

| 模块 | 说明 |
| ---- | ---- |
| 发现 | 52 本书目，搜索 / 分类 / 标签 / 排序 / 分页，继续阅读、今日划线、评分榜 |
| 书籍详情 | 简介与荐读、标签、评分分布、书评（含剧透遮罩、点赞、评论）、相关推荐、阅读计时 |
| 书架 | 想读 / 在读 / 已读完 / 已弃读，进度拖动、读完标记、移出确认 |
| 手记 | 类型（感想 / 摘录 / 书评）、页码、私密开关、实时预览、搜索与增删改 |
| 划线 | 每日回顾、按书筛选、批注、删除 |
| 统计 | 概览指标、年度目标圆环、全年热力图、月度时长、分类分布、好友周榜、年度书单 |
| 目标 | 年度读书数量与阅读分钟目标，实时进度 |
| 书单 | 创建 / 编辑 / 删除主题书单，加入书目与推荐语，公开或私密 |
| 社区 | 全站与关注动态、推荐读者、关注、个人主页（书架 / 书评 / 书单） |
| 书友会 | 创建、加入、共读书目、发帖讨论与页码 |
| 通知 | 点赞、评论、关注、书友会发帖提醒，一键已读 |
| 账号 | 注册登录、资料与头像色、改密、旧版本地数据导入、JSON 导出、删除账号 |

## 目录结构

```text
fastapi-server/
├── app/
│   ├── main.py             # 应用装配（CORS、限流、异常处理、路由挂载、静态托管）
│   ├── config.py           # 环境变量
│   ├── deps.py             # JWT 鉴权依赖
│   ├── errors.py           # 统一错误形状
│   ├── db/                 # 连接池、schema.sql、seed.sql
│   ├── routes/             # auth/books/reviews/shelf/notes/highlights/
│   │                       # sessions/stats/goals/lists/social/clubs/notifications/me
│   ├── services/           # 对应模块的 SQL 业务逻辑
│   └── utils/              # 序列化、动态记录
└── scripts/init_db.py      # 建表 + 种子数据
src/
├── api/client.js           # 统一请求封装与各模块方法
├── composables/            # useAuth、useLibrary、useToast
├── components/             # layout / books / discover / shelf / notes / reviews / social / stats / ui
├── views/                  # 16 个路由页面
├── router/index.js         # 路由与登录守卫
└── styles.css, styles-app.css
```

## 本地运行

环境：Node.js 20+、Python 3.12+、[uv](https://docs.astral.sh/uv/)、PostgreSQL 18。

1. 启动数据库（示例使用项目内数据目录）：

```powershell
& 'D:\PostgreSQL\18\bin\postgres.exe' -D 'D:\zhijian\.pgdata' -p 5433
```

2. 配置后端环境变量，复制 `fastapi-server/.env.example` 为 `fastapi-server/.env`，默认：

```env
DATABASE_URL=postgres://postgres@127.0.0.1:5433/zhijian
JWT_SECRET=请替换为随机字符串
JWT_EXPIRES_IN=14d
PORT=4000
CORS_ORIGIN=http://127.0.0.1:5173,http://localhost:5173
```

3. 建表并写入种子数据，然后启动：

```powershell
cd fastapi-server
uv sync
uv run python scripts/init_db.py --seed
uv run uvicorn app.main:app --host 127.0.0.1 --port 4000
```

4. 启动前端（另开终端，项目根目录）：

```bash
npm install
npm run dev
```

打开 `http://127.0.0.1:5173`，Vite 会把 `/api` 代理到 `http://127.0.0.1:4000`。

演示账号：`demo@zhijian.app`、`mia@zhijian.app`、`chen@zhijian.app`，密码均为 `demo1234`。

## API 约定

- 前缀：`/api/v1`
- 鉴权：`Authorization: Bearer <token>`
- 成功：直接返回资源或分页对象 `{ items, page, pageSize, total }`
- 失败：`{ error: { code, message, details? } }`
- 主要资源：`/auth`、`/books`、`/books/:slug/reviews`、`/me/shelf`、`/me/notes`、`/me/highlights`、`/reviews`、`/me/sessions`、`/me/stats/*`、`/me/goals`、`/lists`、`/feed`、`/readers`、`/users/:handle`、`/clubs`、`/notifications`

## 构建与部署

```bash
npm run build
```

构建产物在 `dist/`。后端会自动托管该目录并对非 `/api` 路径回落到 `index.html`，生产环境只需运行 FastAPI（默认监听 127.0.0.1:4000），前后端同源部署即可。

## 数据与边界

- 书目简介与推荐语为本站原创文字，不提供原书全文；封面为 CSS 概念设计。
- 所有阅读记录、社区内容均保存在 PostgreSQL；不同账号数据相互隔离。
- 旧版纯前端版本（localStorage）的数据可在「设置 → 数据管理」中一键导入。
