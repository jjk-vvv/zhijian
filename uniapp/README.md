# 纸间 · uni-app 版（HBuilderX 工程）

原始 Web 版（Vue 3 + Vite + vue-router）的完整迁移结果：**同一套页面、同一套视觉，改为 uni-app 工程结构**，可在 HBuilderX 中直接运行到浏览器、手机/模拟器和微信开发者工具，并可云打包 App。

- 原 Web 工程保持不动，仍在仓库根目录（`src/`、`vite.config.js`、`package.json` 等），可以继续用 `npm run dev` 开发。
- 本目录 `uniapp/` 就是 HBuilderX 工程根目录，**用 HBuilderX 打开这一层，不要打开仓库根目录**。

---

## 一、在 HBuilderX 中打开

1. 打开 HBuilderX（建议 4.x，已内置 Vue3 + uni-app 编译器）。
2. 菜单：**文件 → 导入 → 从本地目录导入**，选择 `D:\zhijian\uniapp`。
3. 项目树应出现 `pages/`、`components/`、`manifest.json`、`pages.json`、`App.vue`、`main.js`、`static/`。

> 不需要 `npm install`，HBuilderX 自带 uni-app 编译器；本目录也没有 `node_modules`。

## 二、运行

| 目标         | 操作                                                                 | 说明                                                             |
| ------------ | -------------------------------------------------------------------- | ---------------------------------------------------------------- |
| H5 网页      | 菜单 **运行 → 运行到浏览器 → Chrome**                                | 默认 5173 端口，地址形如 `http://localhost:5173/#/pages/discover/discover` |
| 微信小程序   | **运行 → 运行到小程序模拟器 → 微信开发者工具**                       | 先在 `manifest.json → 微信小程序配置` 填自己的 AppID；未填时用测试号 |
| App（安卓/iOS） | **运行 → 运行到手机或模拟器 → 运行到 Android App 基座 / iOS App 基座** | 首次运行需 HBuilderX 自动安装基座；真机需开启 USB 调试             |
| 发行 H5      | **发行 → 网站-PC Web 或手机 H5**                                     | 产物在 `unpackage/dist/build/web`，可直接放静态服务器            |
| 发行 App     | **发行 → 原生 App-云打包**                                           | 需要登录 DCloud 账号，`manifest.json` 的 AppID 用「重新获取」生成 |
| 发行小程序   | **发行 → 小程序-微信**                                               | 产物在 `unpackage/dist/build/mp-weixin`，用微信开发者工具上传    |

**必须先填的两处 AppID**（都在 `manifest.json`）：

- 顶部 `appid`：App 打包用，HBuilderX 里点「重新获取」即可生成。
- `mp-weixin.appid`：微信小程序用，填微信公众平台的小程序 AppID。

## 三、目录结构

```text
uniapp/
├── App.vue                    # 应用入口：全局样式 + H5 meta 注入
├── main.js                    # createSSRApp 入口（uni-app Vue3 规范）
├── manifest.json              # 应用配置（H5/App/小程序、AppID、权限）
├── pages.json                 # 页面路由、窗口样式、自定义导航
├── uni.scss                   # uni-app 全局 SCSS 变量（框架自动注入）
├── index.html                 # H5 模板（HBuilderX Vue3 工程必须有，勿删）
├── pages/
│   ├── discover/discover.vue  # 发现好书（原 DiscoverView）
│   ├── shelf/shelf.vue        # 我的书架（原 ShelfView）
│   └── notes/notes.vue        # 阅读手记（原 NotesView）
├── components/                # 25 个可复用组件，按 layout/books/discover/shelf/notes/ui 分组
├── composables/useLibrary.js  # 跨页面共享的书架与手记状态
├── data/books.js              # 8 本书的静态数据（与原版逐字一致）
├── utils/
│   ├── storage.js             # 数据校验 + uni.setStorageSync 适配层
│   ├── id.js                  # crypto.randomUUID 的小程序兜底
│   ├── format.js              # 日期格式化（替代 Intl.DateTimeFormat）
│   └── page-title.js          # H5 动态文档标题
├── styles/main.css            # 全站样式（由原 styles.css 逐条迁移）
├── static/                    # favicon、首页静物图、图标 PNG、封面噪点纹理
└── scripts/build-icons.ps1    # 图标资源再生成脚本（Windows 自带 WPF，无需装依赖）
```

## 四、迁移对照（Web → uni-app）

| 原实现                              | 迁移后                                                                 |
| ----------------------------------- | ---------------------------------------------------------------------- |
| `vue-router`（hash 路由，3 页面 + 404） | `pages.json` 三条路由；页头导航改为 `<navigator open-type="redirect">`；手记参数改为 `onLoad(options)` |
| `App.vue` 包住 `RouterView` + 页头页脚 | 每个页面用 `PageShell` 组合页头/页脚/Toast，等价于原全局布局            |
| `window.localStorage`               | `uni.setStorageSync/getStorageSync`，`readLibrary/sanitizeLibrary/saveLibrary` 校验逻辑逐字保留 |
| `document.title` 动态标题           | H5 用 `onShow` 设置；App/小程序用 `pages.json` 的 `navigationBarTitleText` |
| `scrollIntoView` + `matchMedia`     | `uni.createSelectorQuery()` + `uni.pageScrollTo()`                     |
| `<svg>` 内联图标（14 个）           | `AppIcon` 改为 `<image>` + 预生成的 PNG（7 个色调 × 14 个图形）        |
| `<input type="range">`              | `<slider>`（`active-color/block-color` 对齐原配色）                    |
| `<select>` / `<option>`             | `<picker>` + `.field-select` 展示块                                   |
| `<Teleport to="body">`              | 去掉 Teleport，弹窗改为页面内 `position: fixed` 覆盖层                  |
| `<Transition>` 提示动画             | 改为 CSS `@keyframes toast-in`                                        |
| `:hover`                            | 保留给 H5/App；小程序用 `hover-class` 提供按压反馈                     |
| `:style` 注入封面 CSS 变量          | 改为 `.cover-lake` 等静态 class（8 本书一一对应）                      |
| `Intl.DateTimeFormat`               | `utils/format.js` 固定 `YYYY/MM/DD` 输出                               |
| `toSorted` / `crypto.randomUUID`    | `slice().sort()` / `utils/id.js` 能力探测兜底                          |
| 焦点陷阱、Escape、`body` 滚动锁     | 仅在 `#ifdef H5` 保留；App / 小程序逻辑层没有 DOM，弹窗用触摸遮罩与 App 返回键处理 |
| `styles.css`（2694 行）             | `styles/main.css`：声明值逐字保留，只把标签选择器改成 class 选择器      |

## 五、样式为什么改选择器

原样式大量使用 `h1`、`p`、`span`、`button`、`a`、`svg` 等标签选择器。小程序只认 `view / text / image / button / input / textarea` 等内置组件，H5 端 uni-app 又会把 `view` 渲染成 `<uni-view>`，标签选择器在两端都不可靠，因此统一改成 **class 选择器**：

- 颜色、字号、间距、圆角、阴影、断点等**数值全部保持原样**，没有做 px→rpx 换算（原设计本身是响应式的，375～1500px 断点行为与 Web 一致）。
- 新增的基础层（页面变量、button 默认样式抹平、`image` 布局、安全区）统一放在 `styles/main.css` 顶部。

### H5 端必须知道的一件事：`<button>` 会变成 `<uni-button>`

uni-app 在 H5 端把 `<button>` 渲染成 `<uni-button>`，并内置了一套**微信风格默认外观**（见 `@dcloudio/uni-components/style/button.css`）：

```css
uni-button { background-color:#f8f8f8; line-height:2.5556; border-radius:5px;
             padding-left:14px; padding-right:14px; margin-left:auto; margin-right:auto; }
uni-button:after { border:1px solid rgba(0,0,0,.2); ... }
```

纸间的设计不用这套外观，如果不处理会出现：页签/筛选外面多一圈灰框、行高被撑到 33px、按钮被 `margin:auto` 推到中间、旋转的封面被 `overflow:hidden` 裁掉。处理方式放在 `App.vue` 的 `#ifdef H5` 代码块里：

- 全局去掉 `::after` 描边、放开裁剪；
- 对依赖透明背景的按钮（`.tab-btn`、`.filter-btn`、`.icon-button`、`.save-button`、`.book-title-btn`、`.text-link`）用 `uni-button.<class>` 提高一级优先级覆盖，同时保留各自 class 的字号与内边距；
- `.button` 显式 `margin: 0`，让 flex 布局（`space-between`/`flex-end`）重新生效。

> 这段是 H5 专用的，小程序/App 不参与编译。以后新增自定义按钮时，如果它不需要灰底，记得把 class 加进这个名单。

## 六、跨端差异（已知且有意为之）

1. **进度条**：原生 `<slider>` 的触摸热区比 4px 轨道高，书架卡片会比 Web 版高约 20px。
2. **排序/书目/类型下拉**：改用系统 `picker`，交互是底部弹层，样式由系统控制。
3. **图标**：PNG 是按「色调 + 图形」预渲染的，`currentColor` 的效果由 `tone` 属性显式指定；新增图形或色调后运行 `powershell -ExecutionPolicy Bypass -File scripts\build-icons.ps1` 重新生成。
4. **弹窗与原生输入框**：极少数安卓微信版本上，页面里的原生 `input` 可能盖在弹窗遮罩之上（小程序原生组件层级限制），遇到时可把该弹窗改为独立页面。
5. **焦点管理**：Esc 关闭、Tab 循环、打开后回焦仅在 H5 生效；App / 小程序逻辑层没有 DOM。App 使用页面 `onBackPress` 关闭弹窗。
6. **数据存储**：仍是「本机保存」，App 与小程序不会跨设备同步；卸载应用/清除小程序数据会丢失记录。
7. **404 页面**：小程序与 App 没有「任意路径」的概念，`NotFoundView` 不再需要；H5 端未匹配的 hash 由 `pages.json` 第一条页面兜底。

## 七、数据与内容

书目、简介、荐读语、示例藏书与示例手记全部原样迁移，未改动任何文案。首次打开仍是 3 本示例藏书 + 1 篇「示例手记」，存储键沿用 `zhijian-library-v1`。

## 八、自检结果

迁移工具放在仓库根目录 `migration-tools/`（不参与打包），共跑了 4 类检查：

**1. 结构与资源：`node ../migration-tools/verify.mjs`**

- 29 个 `.vue` 全部通过 `@vue/compiler-sfc` 的模板 / 脚本 / 样式编译；
- `pages.json` 三条路由与文件一一对应，`manifest.json` 为 Vue3、`transformPx: false`；
- 模板 class 与 CSS class 双向对账：222 个 CSS class，模板用到的全部有定义；
- 无 `select / option / svg / br / img / a / RouterLink / Teleport / Transition` 等小程序不支持的标签；
- 除条件编译块外，无 `document / window / matchMedia / scrollIntoView / Intl / toSorted` 依赖；
- 模板用到的 24 组图标资源全部存在。

**2. 样式语法：`node ../migration-tools/check-css.mjs`**

- 533 对花括号配对，lightningcss 解析通过（45.9 KB）。

**3. 视觉数值未漂移：`node ../migration-tools/diff-declarations.mjs`**

- 原样式 869 种声明，迁移后 902 种；**原样式里只消失了 21 种**，全部是计划内的跨端替换（`inset`、`object-fit`、`appearance`、`padding-inline`、`<input type=range>` 的滑块伪元素、SVG 噪点、`<Transition>` 的过渡类、被 `!important` 覆盖的图标宽度等），没有任何颜色 / 字号 / 间距被改动。

**4. 数据与业务逻辑**

- `node ../migration-tools/state.test.mjs`：原项目的 7 项单元测试**不改断言**直接跑迁移后的 `utils/storage.js`，7/7 通过；
- `node ../migration-tools/logic.test.mjs`：用最小 `uni` API stub 驱动 `useLibrary`，11 项业务检查（示例数据、加入/移出书架、进度派生状态、手记增删改、持久化、示例数据隔离）全部通过。

**5. H5 真实运行（HBuilderX 5.33 实测）**

在 HBuilderX 里用 `cli launch web` 跑起 H5 后，用 `cli screencap web` 对运行中的页面逐页截图核对：

- 首页：页头、导航角标、主视觉、编辑条、分类页签、搜索/排序、4 列书卡、阅读邀请、页脚全部与原设计一致；
- 书架：4 个统计卡、状态筛选、进度滑杆（36% / 100% / 0%）、操作按钮、脚注一致；
- 手记：引言区、类型页签、搜索框、手记卡片、日期格式一致；
- 编辑弹窗：850px 宽弹窗、两列表单、三个 picker、输入框/文本域、实时预览、字数统计、页脚按钮一致。

实测中发现并修掉的 3 个 H5 专属问题（静态校验查不出来，已写进第五节）：

1. 根目录缺 `index.html` → HBuilderX 直接报「请确认您的项目模板是否支持vue3」并停止运行；
2. 导航「我的书架」数字角标换行 → `.nav-count` 改 `inline-grid`；
3. `uni-button` 内置灰底/描边/2.5556 行高/auto 外边距 → 页签和筛选出现灰框、按钮被推到中间、行高被撑大。

**6. 微信小程序真机 / 模拟器实测**

- 首次运行报 `编译 .wxss 文件错误`：WXSS 不支持通配选择器 `*`，原样式 `prefers-reduced-motion` 段用了 `*, *::before, *::after`，已改成具体元素列表；
- 运行时控制台报 `本地资源图片 cover-noise.png 无法通过 WXSS 获取`：WXSS 的 `background-image` 不允许引用本地图片，已把纸张噪点改为内联 base64（三端通用，并删除了不再引用的 PNG）；
- 页面改造成原生 tabBar：发现 / 书架 / 手记，选中态 `#294b3c`，页头导航在小程序端隐藏并预留 100px 避开右上角胶囊；
- 微信 `<button>` 的默认灰底与 `::after` 描边会盖过标签级重置，改用 `button.<class>` 提升优先级后，书架卡片的「标记读完」「垃圾桶」恢复为纯图标/纯文字。

**7. Android App 真机实测（Redmi Note 14 Pro，无线调试）**

用 ADB 无线配对后 `cli launch app-android` 安装内置基座（`plugins/launcher/base/android_base.apk`）并热同步，逐页截图核对：

| 发现的问题 | 原因 | 修法 |
|---|---|---|
| 封面上 `THE BETWEEN PAGES COLLECTION` 换行并压住书名 | WebView 会放大极小字号，且未限制换行 | `page` 加 `-webkit-text-size-adjust: 100%`；封面各层 `white-space: nowrap` + 收紧行高 |
| 软键盘挡住「取消 / 保存手记」 | App 默认 `adjustPan`，键盘浮在页面上 | `pages.json → app-plus.softinputMode: adjustResize`；`.modal-header/.modal-footer` 改 `position: sticky` |
| 返回键直接触发「再按一次退出应用」 | 弹窗未接管 `onBackPress` | 三个页面加 `onBackPress`：打开弹窗时先关弹窗并 `return true` |
| 页头在 tabBar 模式下偏空 | 主导航移走后只剩品牌 | 非 H5 端恢复显示「写一篇手记」入口 |
| 页面滚动后正文滑到状态栏下面 | App 为沉浸式状态栏，页头未固定 | .site-header 在非 H5 端 position: sticky |
| 封面品牌小字被裁（"THE BETWEEN PAGES COL…"） | WebView 有约 6–8px 的最小字号，设计上的 3.5px 被抬高后超出封面宽度 | `.cover-top` 用 `transform: scale(0.62)` 等比缩回，`letter-spacing` 归零 |
| 「我的书架」数字角标与导航挤在一起 | 非 H5 端隐藏导航后布局变化 | 随 tabBar 改造一并对齐 |

App 端同样使用底部 tabBar（`#ifndef H5`），跳转统一走 `uni.switchTab`；「写手记」在 tabBar 模式下无法带 query，改为「写一次性标记 → 手记页 onShow 消费」，已停在手记页时改用 `uni.$emit` 直接打开编辑器。

> 提醒：以上 H5 已实际运行核对。App / 小程序的真机渲染仍建议在 HBuilderX 里各跑一次「运行 → 运行到手机」，重点看字体、滚动和弹窗层级。

## 十、发行（Release）

Android 1.0.0 安装包已于 2026-10-30 通过完整云打包生成并验证，产物与校验记录见 [Android 发行记录](RELEASE-ANDROID.md)。

### 用脚本出正式包

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\build-release.ps1 -Platform both
```

| 端 | 产物目录 | 文件数 | 体积 |
|---|---|---|---|
| H5 | `unpackage/dist/build/web` | 138 | 1.35 MB |
| 微信小程序 | `unpackage/dist/build/mp-weixin` | 225 | 0.82 MB |

脚本直接调用 HBuilderX 内置的 uni-app(vue3) 编译器（`plugins/uniapp-cli-vite`），产物与菜单发行一致。

### 为什么用脚本而不是「发行」菜单

HBuilderX 的发行入口会先校验 `manifest.json` 的 appid 是否已在 DCloud 账号下注册。若登录的是临时账号（`*@tmp.dcloud.io`），没有可用 AppID，菜单发行会直接报 `appid 不存在`，任何平台都发不出去。脚本跳过该前置校验，只做编译。

### H5 部署

- 产物是纯静态站点，资源引用为绝对路径 `/assets/...`；
- 部署在**域名根目录**可直接上传（Netlify / Vercel / uniCloud 托管 / Nginx 均可）；
- 若要部署到子路径（如 `/zhijian/`），先把 `manifest.json → h5.router.base` 改为该子路径再重新构建。

### 微信小程序上传

1. 微信开发者工具 → 导入 → 目录选 `unpackage/dist/build/mp-weixin`，AppID 填 `wx19f4624a6a070135`；
2. 工具内点「上传」，填版本号与备注，再到 mp 后台提交审核；
3. 或用 CLI 自动上传（需先在微信后台「开发管理 → 开发设置」下载代码上传密钥）：

```powershell
./cli publish mp-weixin --project <项目绝对路径> --appid wx19f4624a6a070135 `
  --upload true --version 1.0.0 --privatekey <private.wx...key 路径> --description "首个版本"
```

### App 发行

2026-10-29 已使用有效 AppID `__UNI__41EC232` 提交 Android 安心打包，包名 `com.zhijian.reading`，版本 `1.0.0`（100），使用 DCloud 云证书。首次打包需要等免费云队列返回原生包；后续相同原生配置可复用安心打包缓存。

Android 发行脚本（需 HBuilderX 已登录并导入当前工程）：

```powershell
pwsh -NoProfile -File scripts\build-android.ps1
```

脚本检测到本机的中文 Windows 用户目录时，会自动使用完整云打包，避免 HBuilderX 5.34 内置 apktool / aapt2 在 `AndroidPackWork` 中合成资源时出现乱码路径。其他环境默认使用安心打包；也可显式加 `-Traditional` 使用完整云打包。两种方式均使用当前 DCloud 云证书。

脚本会编译当前源码，校验 APK 内的 AppID / 应用名 / 版本与业务代码，验证签名，并输出到 `unpackage/release/zhijian-android-1.0.0/`：

- `zhijian-1.0.0-android.apk`：全部校验通过后才生成的交付包。
- `status.json`：`waiting / building / verifying / complete / failed` 状态；`complete` 才表示 APK 已完成。
- `SHA256SUMS.txt`、`signature.txt`：文件校验值和签名校验结果。
- `build.log`：发行过程日志；临时登录链接中的 token 会被遮盖。

弹窗跨端回归检查：`node --test ../migration-tools/modal-platform.test.mjs`（在本目录执行），验证 App / 微信小程序无需 DOM，H5 保留焦点与 Escape 处理。HBuilderX 路径可通过 `HBUILDERX_ROOT` 环境变量指定。

需要两样东西：插件市场里显示名为「**App云打包**」的 `app-safe-pack` 插件，以及已在 DCloud 账号下注册的有效 AppID（`manifest.json` 里点「重新获取」）。

```powershell
./cli pack --project <项目绝对路径> --platform android --android.packagename com.zhijian.reading `
  --safemode true --android.androidpacktype 3
```

图标（Android 5 档密度 + iOS 全套，`static/app-icons/`）与应用名「纸间」已接进 `app-plus.distribute.icons`，打包后即为最终外观。生成图标用 `scripts/build-app-icons.ps1`。
