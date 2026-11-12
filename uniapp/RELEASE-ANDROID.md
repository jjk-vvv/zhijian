# 纸间 Android 1.0.0 发行记录

2026-10-30（北京时间）完成，交付目标是可安装的 Android APK。

| 项目 | 结果 |
| --- | --- |
| 应用名 | 纸间 |
| 包名 | `com.zhijian.reading` |
| DCloud AppID | `__UNI__41EC232` |
| 版本 | `1.0.0` / `100` |
| 构建工具 | HBuilderX 5.34，Vue 3 uni-app 编译器 |
| 打包方式 | 官方完整云打包，免费队列，DCloud 云证书 |
| APK 大小 | 15,488,464 字节，约 14.8 MiB |
| 签名 | APK v1 / v2 验证通过，RSA 2048 位 |
| 调试模式 | 关闭 |
| CPU 架构 | `arm64-v8a`（64 位 Android） |

安装包：`unpackage/release/zhijian-android-1.0.0/zhijian-1.0.0-android.apk`。

SHA-256：

```text
c1b3876f973309f31538b3b29bf046e9722ba9ff37042e831ba24a71ab899ae5
```

同目录的 `status.json` 状态为 `complete`，另有 `signature.txt`、`SHA256SUMS.txt` 和已遮盖临时登录 token 的 `build.log`。

## 本次检查与修正

- 检查 uni-app 工程入口、三页路由、26 个复用组件、共享状态、存储适配、导航、图标和跨端条件编译；30 个 Vue 文件的结构及资源检查通过。
- 7 项存储测试、11 项业务逻辑检查通过。
- 发现 `BaseModal.vue` 将浏览器 DOM 代码编译进 App 逻辑层，重现 `ReferenceError: document is not defined`；已将焦点与 body 滚动锁限制到 H5。App 的页面返回键处理保持可用。
- 新增 3 项平台回归检查：App / 微信小程序在无 DOM 环境下挂载与卸载弹窗；H5 保留滚动锁、Escape 关闭、监听清理与回焦。
- 正式 APK 中的 AppID、应用名、版本和业务 JS 与本次发行资源一致；签名验证通过，原生 Android 包名和非调试配置已核对。

## 打包环境处理

首次安心打包已在云端成功生成原生资源，但内置 apktool / aapt2 在本机中文用户目录的 `AndroidPackWork` 下合成资源时失败。最终改用官方完整云打包，由服务器完成合成与签名，生成上述 APK。未启用付费加速。

后续可在本目录执行：

```powershell
pwsh -NoProfile -File scripts\build-android.ps1
```

脚本检测到中文 Windows 用户目录会自动采用完整云打包，完成后下载并验证产物。需要 HBuilderX 已登录并已导入本工程。

本次未做新 APK 的真机安装验证：收包时 ADB 没有连接设备。原有基座真机运行记录不等同于本次安装包验收。
