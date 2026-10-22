# 纸间 · 阅读生活网站

一个完整的 Vue 3 纯前端项目，主题是发现好书、整理书架和记录阅读感想。无后端、无账号、无 API 密钥，下载后即可运行。

## 对照任务要求

| 要求                      | 实现                                                                     |
| ------------------------- | ------------------------------------------------------------------------ |
| 使用 Vue，仅前端          | Vue 3 Composition API + Vue Router + Vite                                |
| 至少 3 个页面             | 发现好书、我的书架、阅读手记；额外提供 404 页面                          |
| 至少 15 个 Vue 单文件组件 | 共 **29 个 `.vue` 文件**，其中 24 个可复用组件、4 个路由页面、1 个根组件 |
| 覆盖 Vue 官方互动教程     | 下文逐项对照第 1–14 步；第 15 步是教程结束语                             |
| 代码逻辑清晰              | 组件分组、页面组合、共享 composable、静态数据与存储工具分层              |
| 公网访问 / 可部署 Netlify | 项目配有 `netlify.toml`；最终发布结果见源码包旁的交付说明                |

## 本地运行

环境：Node.js 22.12+ 或 Node.js 24 LTS，npm。已提供 `package-lock.json`。

```bash
npm ci
npm run dev
```

打开终端打印的本地地址。生产构建与本地预览：

```bash
npm run build
npm run preview
```

构建输出是 `dist/`，不能直接双击源码的 `index.html` 来运行 Vue SFC。

## 三个页面与使用流程

1. **发现好书 `/#/`**：8 本精选经典书籍，5 个分类入口；按书名、作者或英文名搜索，按精选顺序、书名或原作出版时间排序。点击封面打开详情，可以加入书架或针对这本书写手记。
2. **我的书架 `/#/shelf`**：展示藏书、在读、读完与手记统计。拖动进度条，状态自动在“想读 / 正在读 / 已读完”之间变化；可以标记读完、重新阅读、按状态筛选、确认移出。
3. **阅读手记 `/#/notes`**：创建、预览、编辑、搜索、分类和确认删除。可以从书籍详情或书架带入关联书籍；标题与正文必填，分别最多 60 / 3000 字。

首次访问会放入 3 本示例藏书和 1 篇标记为“示例手记”的内容。浏览器 localStorage 保存书架与手记；刷新仍可保留，清除浏览器数据会移除记录，不提供跨设备同步。把示例全部删除后，系统不会再次自动填充。

## 目录和逻辑边界

```text
src/
├── App.vue                 # 全局布局、通知与页面焦点
├── main.js                 # 挂载应用、注册路由
├── router/index.js         # 路由、懒加载、页面标题
├── views/                  # 页面组合和当前筛选状态
├── components/
│   ├── layout/             # 页头、页脚
│   ├── books/              # 封面、书卡、网格、详情
│   ├── discover/           # 首页主视觉、搜索分类、阅读邀请
│   ├── shelf/              # 统计、状态、进度、书架卡片
│   ├── notes/              # 表单、预览、手记卡片和列表
│   └── ui/                 # 弹窗、确认、空状态、通知、图标
├── composables/useLibrary.js # 共享响应式数据与业务操作
├── data/books.js           # 固定书目，包含原创推荐语
├── utils/storage.js        # 本地数据校验、读取和保存
└── styles.css              # 统一颜色、字号、组件和响应式样式
tests/
├── state.test.js           # Node 内置测试：数据边界
└── browser/library.spec.js # Playwright：完整用户流程
public/                    # 本地图标与首页图像
docs/                      # 设计说明和素材说明
netlify.toml               # 静态部署配置
```

数据流只有一个方向：页面把数据作为 `props` 交给组件；组件通过 `emit` 报告操作；页面调用 `useLibrary()` 更新状态；`computed` 自动更新视图，`watch` 把数据写回 localStorage。

组件不直接读写存储。`useLibrary()` 暴露只读状态和语义明确的操作方法：`addBook`、`removeBook`、`updateProgress`、`saveNote`、`deleteNote`。阅读状态由进度派生，避免分别维护两份容易冲突的数据。

## Vue 官方教程知识点对照

参考：[Vue 中文官方互动教程](https://cn.vuejs.org/tutorial/)。项目使用组合式 API 和 `<script setup>`。

| 教程步骤 | 知识点                     | 项目中的具体实现                                                                                                           |
| -------- | -------------------------- | -------------------------------------------------------------------------------------------------------------------------- |
| 1        | SFC、模板与文本插值        | `App.vue` 组合应用；`AppFooter.vue` 中的年份、`BookCard.vue` 中的书名插值                                                  |
| 2        | 声明式渲染、响应式状态     | `useLibrary.js` 的 `reactive(library)`；`DiscoverView.vue` 的 `ref`；`NoteEditor.vue` 的响应式表单                         |
| 3        | 属性绑定 `v-bind` / `:`    | `BookCover.vue` 的 `:style`、`:class`、`:aria-label`；`BookCard.vue` 的 `:disabled`                                        |
| 4        | 事件监听 `v-on` / `@`      | `BookCard.vue` 的 `@click`；`NoteEditor.vue` 的 `@submit.prevent`；弹窗的 `@click.self`                                    |
| 5        | 表单绑定 `v-model`         | `NoteEditor.vue` 绑定输入框、选择框和文本域；`DiscoverView.vue` 的组件 `v-model` 与 `v-model:sort`                         |
| 6        | 条件渲染 `v-if` / `v-else` | `DiscoverView.vue` 在列表与空状态间切换；`NoteEditor.vue` 显示校验错误；按需挂载弹窗                                       |
| 7        | 列表渲染 `v-for` 和 `:key` | `BookGrid.vue`、`ShelfView.vue`、`NotesList.vue` 按稳定 ID 渲染；`CategoryTabs.vue` 渲染分类                               |
| 8        | 计算属性 `computed`        | `DiscoverView.vue` 计算筛选和排序结果；`useLibrary.js` 计算书架详情和统计；`NoteEditor.vue` 计算字数和错误                 |
| 9        | 生命周期与模板引用         | `NoteEditor.vue` 的 `ref="titleInput"` + `onMounted` 聚焦；`BaseModal.vue` 在挂载 / 卸载时注册清理键盘监听与滚动锁         |
| 10       | 侦听器 `watch`             | `useLibrary.js` 深度侦听共享状态并持久化；`NotesView.vue` 侦听查询参数打开写作界面；`App.vue` 在导航后管理焦点             |
| 11       | 组件拆分与注册             | 页面通过 `import` 使用组件；`DiscoverView.vue` 组合 Hero、分类、工具栏、列表等                                             |
| 12       | `defineProps`              | `BookCard.vue` 接收 `book` 和 `saved`；`ReadingProgress.vue` 接收进度；`NotePreview.vue` 接收草稿                          |
| 13       | `defineEmits`、子传父      | `BookCard.vue` 发出 `detail` / `save`；`NoteEditor.vue` 发出 `save` / `close`；`CategoryTabs.vue` 发出 `update:modelValue` |
| 14       | 默认与具名插槽             | `BaseModal.vue` 的默认内容与 `#footer`；`SectionHeading.vue` 的操作区；`EmptyState.vue` 的后续操作按钮                     |

额外使用：Vue Router 懒加载页面、`Teleport` 将弹窗挂到 body、`Transition` 展示通知、readonly 共享状态、`nextTick` 等待 DOM 更新。所有能力都服务于网站功能，没有单独堆砌无法使用的演示代码。

## 29 个单文件组件清单

| 分类   | 文件                    | 职责                               |
| ------ | ----------------------- | ---------------------------------- |
| 根组件 | `App.vue`               | 全局布局、页面焦点、通知与存储错误 |
| 页面   | `DiscoverView.vue`      | 书籍搜索、分类、排序和详情编排     |
| 页面   | `ShelfView.vue`         | 书架状态筛选和收藏操作             |
| 页面   | `NotesView.vue`         | 手记检索、路由参数和增删改         |
| 页面   | `NotFoundView.vue`      | 未知路由恢复入口                   |
| 布局   | `AppHeader.vue`         | 品牌、导航、藏书数量与写作入口     |
| 布局   | `AppFooter.vue`         | 品牌落款                           |
| 书籍   | `BookCover.vue`         | 数据驱动的概念封面                 |
| 书籍   | `BookCard.vue`          | 单本书的展示与收藏事件             |
| 书籍   | `BookGrid.vue`          | 可复用的书籍网格                   |
| 书籍   | `BookDetailModal.vue`   | 简介、荐读和相关操作               |
| 发现   | `DiscoverHero.vue`      | 首页主视觉和浏览书单入口           |
| 发现   | `CategoryTabs.vue`      | 可双向绑定的书籍分类               |
| 发现   | `SearchToolbar.vue`     | 搜索输入与排序选择                 |
| 发现   | `ReadingInvitation.vue` | 引导进入阅读手记                   |
| 书架   | `ShelfStats.vue`        | 响应式阅读数据概览                 |
| 书架   | `ShelfFilters.vue`      | 阅读状态筛选                       |
| 书架   | `ReadingProgress.vue`   | 带可访问标签的进度滑杆             |
| 书架   | `ShelfBookCard.vue`     | 单本藏书和阅读操作                 |
| 手记   | `NoteEditor.vue`        | 校验、编辑和保存事件               |
| 手记   | `NotePreview.vue`       | 草稿的实时预览                     |
| 手记   | `NoteCard.vue`          | 手记展示及编辑删除事件             |
| 手记   | `NotesList.vue`         | 手记列表                           |
| 通用   | `AppIcon.vue`           | 统一 SVG 图标                      |
| 通用   | `BaseModal.vue`         | 传送、滚动锁、焦点循环和 Escape    |
| 通用   | `ConfirmDialog.vue`     | 危险操作确认                       |
| 通用   | `EmptyState.vue`        | 空数据提示和自定义后续操作         |
| 通用   | `SectionHeading.vue`    | 区块标题和操作插槽                 |
| 通用   | `ToastNotice.vue`       | 带动画的可访问状态通知             |

所有文件均被实际导入使用；即使不计算根组件、路由页面和图标，也有 23 个复用 SFC，超过 15 个的要求。

## 测试

```bash
npm test
npm run test:e2e
```

当前环境已验证：**7 项单元测试、8 项浏览器测试通过**。浏览器测试对桌面和 iPhone 13 尺寸各运行 4 个完整流程，覆盖搜索无结果、分类、排序、详情、键盘焦点、收藏、拖动进度、刷新持久化、读完状态、移出确认、手记校验、实时预览、创建编辑删除、空数据和 404。

浏览器测试在 Windows 优先寻找已安装的 Chrome；其他环境先执行 `npx playwright install chromium`。`playwright.config.js` 自动启动并关闭测试用 Vite 服务。桌面 1440px 和手机 390px 下均检查无横向溢出，页面素材均可正常加载。

## 部署到 Netlify

配置参考：[Netlify 文件式构建配置](https://docs.netlify.com/build/configure-builds/file-based-configuration/)。

**方式一：上传构建结果**

1. 执行 `npm ci`、`npm run build`。
2. 登录 Netlify，进入手动部署入口。
3. 上传整个 `dist` 文件夹（或解压交付的静态站点包后上传其中的文件夹）。上传的是包含 `index.html` 与 `assets` 的构建结果。
4. Netlify 返回站点链接，三个页面都可以通过导航访问。

**方式二：连接 Git 仓库**

把项目上传到自己的 Git 仓库，Netlify 导入仓库时会读取 `netlify.toml`：构建命令 `npm run build`，发布目录 `dist`，Node 24。若把本项目放在仓库子目录，需在 Netlify 设置相应的 Base directory。

当前使用 Hash 路由，因此普通静态空间也能刷新页面。Netlify 的 SPA 回退规则已一并配置。

## 内容、素材和边界

书名和作者用于阅读展示；推荐语与简介为本站原创文字，不提供原书全文。卡片封面由 HTML/CSS 绘制，是本站概念设计；书目年份为原作首次出版或写作年代，不是具体中文译本信息。首页静物图由内置 imagegen 生成，详见 `docs/assets.md`。未使用依赖外部图片站的在线素材或远程字体。

本项目实现前端功能：不提供注册登录、真实社群数据、评分服务、购买、服务器数据库或云端同步。打开公网网站的不同访客拥有各自的浏览器数据。
