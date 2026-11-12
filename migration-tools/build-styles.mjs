// 把 Web 版 styles.css 的选择器映射到 uni-app 的 class 选择器。
// 只改选择器文本，声明块逐字保留，确保视觉数值与 Web 版一致。
import { readFileSync, writeFileSync } from 'node:fs'

const source = readFileSync('D:/zhijian/src/styles.css', 'utf8')

const replacements = [
  [':root {', 'page {'],
  ['html {', 'page {'],
  ['body {\n  margin: 0;\n}', ''],
  ['#app {', '.page-shell {'],
  ['main {\n  flex: 1;\n}', '.site-main {\n  flex: 1;\n}'],
  ['main:focus {\n  outline: 0;\n}', ''],
  ['a {\n  color: inherit;\n  text-decoration: none;\n}', '.brand,\n.nav-link,\n.header-write,\n.text-link,\n.button {\n  color: inherit;\n  text-decoration: none;\n}'],
  [
    'a:focus-visible,\nbutton:focus-visible,\ninput:focus-visible,\nselect:focus-visible,\ntextarea:focus-visible {',
    'button:focus-visible,\ninput:focus-visible,\ntextarea:focus-visible,\n.nav-link:focus-visible,\n.text-link:focus-visible,\n.brand:focus-visible {\n  outline-offset: 4px;\n}\n\n.brand:focus-visible,\n.nav-link:focus-visible,\n.header-write:focus-visible,\n.text-link:focus-visible,\n.button:focus-visible,\ninput:focus-visible,\ntextarea:focus-visible {',
  ],
  ['button svg,\na svg {\n  flex-shrink: 0;\n}', ''],
  ['img {\n  max-width: 100%;\n  display: block;\n}', ''],
  ['.main-nav > a {', '.main-nav .nav-link {'],
  ['.main-nav > a:hover,\n.main-nav .is-active {', '.main-nav .nav-link:hover,\n.main-nav .nav-link.is-active {'],
  ['.main-nav .is-active::after {', '.main-nav .nav-link.is-active::after {'],
  ['.brand-name > span {', '.brand-sub {'],
  ['.hero-copy h1 {', '.hero-title {'],
  ['.hero-copy > p {', '.hero-desc {'],
  ['.hero-eyebrow > span {', '.eyebrow-dot {'],
  ['.hero-caption > span:first-child {', '.hero-caption-en {'],
  ['.hero-caption > span {', '.hero-caption-en,\n.hero-caption-zh {'],
  ['.round-stamp > span {', '.round-stamp-text {'],
  ['.editorial-strip > span:first-child {', '.strip-theme {'],
  ['.editorial-strip i {', '.strip-dot {'],
  ['.editorial-strip > span:nth-child(2) {', '.strip-slogan {'],
  ['.section-heading h2 {', '.section-title {'],
  ['.section-heading p {', '.section-desc {'],
  ['.category-tabs button {', '.category-tabs .tab-btn {'],
  ['.category-tabs button:hover {', '.tab-btn:hover {'],
  ['.category-tabs button.active {', '.tab-btn.active {'],
  ['.search-box input {', '.search-input {'],
  ['.search-box input::placeholder {', '.field-placeholder {'],
  ['.sort-label svg {', '.sort-icon {'],
  ['.book-meta h3 {', '.book-title {'],
  ['.book-meta h3 button {', '.book-title-btn {'],
  ['.book-meta h3 button:hover {', '.book-title-btn:hover {'],
  ['.shelf-cover-button .book-cover {', '.book-cover.is-shelf {'],
  ['.shelf-cover-button .cover-title {', '.book-cover.is-shelf .cover-title {'],
  ['.shelf-cover-button .cover-top {', '.book-cover.is-shelf .cover-top {'],
  ['.shelf-cover-button .cover-english {', '.book-cover.is-shelf .cover-english {'],
  ['.shelf-cover-button .cover-art {', '.book-cover.is-shelf .cover-art {'],
  ['.shelf-cover-button .cover-author {', '.book-cover.is-shelf .cover-author {'],
  ['.shelf-cover-button .cover-bottom {', '.book-cover.is-shelf .cover-bottom {'],
  ['.shelf-book h2 {', '.shelf-title {'],
  ['.reading-progress > div {', '.progress-head {'],
  ['.reading-progress output {', '.progress-value {'],
  ['.shelf-filters button {', '.shelf-filters .filter-btn {'],
  ['.shelf-filters button.active {', '.shelf-filters .filter-btn.active {'],
  ['.shelf-filters button.active:after {', '.shelf-filters .filter-btn.active:after {'],
  ['.shelf-filters button > span {', '.filter-count {'],
  ['.note-card > header {', '.note-card-head {'],
  ['.note-card time {', '.note-date {'],
  ['.note-card h2 {', '.note-title {'],
  ['.note-card > footer {', '.note-card-foot {'],
  ['.note-content + footer {', '.note-content + .note-card-foot {'],
  ['.note-card > footer > div {', '.note-actions {'],
  ['.note-form-fields > label,\n.form-row label {', '.field-label {'],
  ['.note-editor input,\n.note-editor textarea,\n.note-editor select {', '.field {'],
  ['.note-editor textarea {', '.field-textarea {'],
  ['.note-editor input::placeholder,\n.note-editor textarea::placeholder {', '.field-placeholder {'],
  [".note-editor [aria-invalid='true'] {", '.field.is-invalid {'],
  ['.note-preview h3 {', '.preview-title {'],
  ['.modal-header h2 {', '.modal-title {'],
  ['.modal-footer .button {', '.modal-btn {'],
  ['.detail-cover .book-cover {', '.book-cover.is-detail {'],
  ['.detail-copy h3 {', '.detail-title {'],
  ['.detail-copy > .muted {', '.detail-meta {'],
  ['.detail-copy > p:not(.muted) {', '.detail-desc {'],
  ['.editor-note strong {', '.editor-note-label {'],
  ['.editor-note p {', '.editor-note-text {'],
  ['.detail-copy > small {', '.detail-note {'],
  ['.empty-state h3 {', '.empty-title {'],
  ['.empty-state p {', '.empty-desc {'],
  ['.reading-invitation h2 {', '.invitation-title {'],
  ['.reading-invitation p {', '.invitation-desc {'],
  ['.reading-invitation > .text-link {', '.invitation-link {'],
  ['.footer-brand strong {', '.footer-name {'],
  ['.footer-brand > span {', '.footer-tagline {'],
  ['.footer-right > span:first-child {', '.footer-slogan {'],
  ['.notes-intro > p {', '.intro-line {'],
  ['.notes-intro strong {', '.intro-strong {'],
  ['.notes-total small {', '.notes-unit {'],
  ['.stat-label svg {', '.stat-icon {'],
  ['.stat-value small {', '.stat-unit {'],
  ['.brand-mark svg {', '.brand-icon {'],
  ['.invitation-art > svg {', '.invitation-icon {'],
  ['.small-leaf svg {', '.small-leaf-icon {'],
  ['.shelf-book-actions .text-link svg {', '.action-icon {'],
  ['.save-button svg {', '.save-icon {'],
  ['.book-card:nth-child(2n) .book-detail-trigger {', '.book-card.is-reverse .book-detail-trigger {'],
  [
    '.book-detail-trigger:hover,\n.book-card:nth-child(2n) .book-detail-trigger:hover {',
    '.book-detail-trigger:hover,\n.book-card.is-reverse .book-detail-trigger:hover {',
  ],
  ['.page-heading h1 {', '.page-title {'],
  ['.page-heading p {', '.page-desc {'],
]

const BASE = `/* ==========================================================================
   纸间 · uni-app 基础层
   1. 页面变量与重置（对应 Web 版 :root / body / * 重置）
   2. 小程序与 H5 的内置组件默认样式抹平
   3. 布局骨架
   ========================================================================== */
page {
  font-family: 'Microsoft YaHei', 'PingFang SC', sans-serif;
  color: #263c32;
  background: #faf9f5;
  font-synthesis: none;
  font-weight: 400;
  --green: #294b3c;
  --text: #263c32;
  --muted: #6b726a;
  --paper: #faf9f5;
  --line: #dedfd6;
  --serif: 'Noto Serif SC', 'Songti SC', 'STSong', 'SimSun', serif;
  --radius: 6px;
  scroll-behavior: smooth;
  scroll-padding-top: 30px;
}

view,
text,
image,
navigator,
picker,
slider,
button,
input,
textarea {
  box-sizing: border-box;
  -webkit-tap-highlight-color: transparent;
}

/* 小程序 button 自带内边距、边框、宽度与行高，这里统一抹平，尺寸全部交给 class。 */
button {
  margin: 0;
  padding: 0;
  border: 0;
  border-radius: 0;
  background: none;
  color: inherit;
  font-family: inherit;
  font-size: inherit;
  font-weight: inherit;
  line-height: inherit;
  text-align: center;
  overflow: visible;
  cursor: pointer;
}
button::after {
  border: 0;
}
button:disabled {
  cursor: default;
  opacity: 0.65;
}
input,
textarea {
  font-family: inherit;
  font-size: inherit;
  outline-offset: 4px;
}

.brand,
.nav-link,
.header-write,
.text-link,
.button {
  color: inherit;
  text-decoration: none;
}

.brand:focus-visible,
.nav-link:focus-visible,
.header-write:focus-visible,
.text-link:focus-visible,
.button:focus-visible,
button:focus-visible,
input:focus-visible,
textarea:focus-visible {
  outline: 2px solid #657a42;
  outline-offset: 4px;
}

view,
text {
  margin: 0;
}

::selection {
  background: #dce3ce;
}

/* 图标：AppIcon 统一渲染为 image，尺寸由组件内联 style 决定。 */
.app-icon {
  display: inline-block;
  vertical-align: middle;
  flex-shrink: 0;
}

.page-shell {
  min-height: 100vh;
  min-height: 100dvh;
  display: flex;
  flex-direction: column;
}
.site-main {
  flex: 1;
}

.container {
  width: min(1240px, calc(100% - 112px));
  margin-left: auto;
  margin-right: auto;
}
.muted {
  color: var(--muted);
}
.sr-only {
  position: absolute;
  width: 1px;
  height: 1px;
  padding: 0;
  margin: -1px;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  white-space: nowrap;
  border: 0;
}

`

const tailStart = source.indexOf('.site-header {')
if (tailStart === -1) throw new Error('找不到 .site-header 起点')

let output = source
const missed = []
for (const [from, to] of replacements) {
  if (!output.includes(from)) {
    missed.push(from)
    continue
  }
  output = output.split(from).join(to)
}

// 丢掉 Web 版的头部基础层（:root / body / #app / skip-link 等），换成 uni-app 基础层。
output = BASE + output.slice(output.indexOf('.site-header {'))

writeFileSync('D:/zhijian/uniapp/styles/main.css', output)
console.log('未命中的替换（需要人工确认）:', missed.length)
missed.forEach((item) => console.log('  -', JSON.stringify(item.slice(0, 80))))
