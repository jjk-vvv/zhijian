<script>
export default {
  onLaunch() {
    // 页面级 meta（theme-color / description / favicon）已写在根目录 index.html 中，
    // H5 由该模板直接输出；App 与小程序不涉及这些标签。
  },
}
</script>

<style>
@import './styles/main.css';

/* #ifdef H5 */
/* uni-app 在 H5 端把 <button> 渲染成 <uni-button>，并内置一套微信风格默认外观
   （#f8f8f8 底、2.5556 行高、左右 14px 内边距、左右 auto 外边距、::after 1px 描边）。
   纸间的设计不使用这套外观，因此在这里覆盖：
   1. 全局去掉伪元素描边、放开裁剪，否则每个按钮都会多出一圈灰框、旋转的封面会被裁掉；
   2. 对依赖「透明背景」的按钮（页签、书架筛选、图标按钮、文字按钮），用「元素 + class」
      提升一级优先级压过内置样式，同时保留各自 class 里定义的字号与内边距。 */
uni-button {
  overflow: visible !important;
}
uni-button::after {
  border: 0 !important;
}
uni-button.tab-btn,
uni-button.filter-btn,
uni-button.icon-button,
uni-button.save-button,
uni-button.book-title-btn,
uni-button.text-link {
  background: transparent;
  line-height: normal;
  margin: 0;
  color: inherit;
}
uni-button.icon-button,
uni-button.save-button,
uni-button.book-title-btn,
uni-button.text-link {
  padding: 0;
}
/* #endif */

/* #ifndef H5 */
/* 小程序与 App 都用底部 tabBar 承载三个一级页面，页头只保留品牌与写作入口。 */
.main-nav {
  display: none;
}
/* 主导航交给 tabBar 后，页头右侧空了出来，把写作入口恢复显示 */
.header-write {
  display: flex;
}

/* 小程序 / App 的 WebView 对小字号有下限（约 6–8px）：封面那行 28 字符的品牌字
   按设计 3.5px 会被抬到下限、超出封面宽度被裁。用 transform 等比缩回设计尺寸。 */
.book-cover .cover-top {
  letter-spacing: 0;
  transform: scale(0.62);
  transform-origin: 50% 0;
}

/* 页头固定：否则页面滚动后正文会滑到状态栏下面（App 是沉浸式状态栏） */
.site-header {
  position: sticky;
  top: 0;
  z-index: 9;
}

/* 微信 <button> 自带灰底、5px 圆角和 ::after 描边，普通标签选择器压不过组件内置样式，
   这里用「button + class」提升优先级；App 端没有这套默认样式，覆盖同样无副作用。 */
button.text-link,
button.icon-button,
button.tab-btn,
button.filter-btn,
button.book-title-btn,
button.save-button {
  background: transparent;
  border: 0;
  line-height: normal;
  color: inherit;
}
button.text-link::after,
button.icon-button::after,
button.tab-btn::after,
button.filter-btn::after,
button.book-title-btn::after,
button.save-button::after {
  border: 0;
}
button.book-title-btn,
button.save-button {
  padding: 0;
}
/* 触控热区：图标按钮补到 44×44（图标本身不变，只是可点区域变大） */
button.icon-button {
  padding: 0;
  min-width: 44px;
  min-height: 44px;
}
button.text-link {
  padding: 0;
  min-height: 36px;
}

/* 字号：原设计是桌面稿，8–11px 的字在手机上过小，这里统一抬到 11–13px */
.stat-label {
  font-size: 12px;
}
.stat-unit {
  font-size: 11px;
}
.book-author {
  font-size: 12px;
}
.book-subtitle {
  font-size: 12px;
}
.category-label {
  font-size: 11px;
}
.progress-head {
  font-size: 12px;
}
.progress-hint {
  font-size: 11px;
}
.shelf-book-actions .text-link {
  font-size: 13px;
}
.status-badge {
  font-size: 11px;
}
.book-tag {
  font-size: 10px;
}
.filter-count {
  font-size: 11px;
}
.data-footnote {
  font-size: 11px;
}
.page-kicker {
  font-size: 10px;
}
.category-tabs .tab-btn {
  font-size: 13px;
}
.sort-label {
  font-size: 13px;
}
.search-input {
  font-size: 13px;
}
.notes-unit {
  font-size: 10px;
}
.preview-book {
  font-size: 12px;
}
.word-count {
  font-size: 12px;
}
.editor-save-hint {
  font-size: 12px;
}
.form-error {
  font-size: 12px;
}
.field-label {
  font-size: 13px;
}
.note-content {
  font-size: 13px;
}
/* #endif */

/* #ifdef MP */
/* 小程序右上角有胶囊按钮，自定义导航必须自己避让 */
.header-inner {
  padding-right: 100px;
}
/* #endif */
</style>
