# 视觉素材

- 首页：`public/reading-still-life.jpg`，由内置 imagegen 生成，并导出为 JPEG 用于网站加载。原始生成结果保留在工具的生成目录，没有对照片内容进行修改。
- 图标：`AppIcon.vue` 中的 SVG 线性图形；品牌图标复用书本形状。
- 书籍：`BookCover.vue` 与 `styles.css` 的原生 HTML/CSS 概念设计，非出版社封面。
- 字体：系统中文黑体、宋体与 Georgia；不请求外部字体服务。

## 首页图像的生成提示词

工具：内置 `image_gen.imagegen`，新图生成，不透明背景。

> Create one premium editorial still-life photograph for a Chinese independent reading website named 纸间. Wide landscape crop about 3:2. On a warm light sage/off-white plaster table, an open cream-paged book lies at lower center with a linen-covered dark forest green hardback behind it, a second sand colored book, a small clear glass cup of tea on right and a branch of olive foliage entering from top left. Strong soft afternoon window sunlight from upper left, visible calm shadows, tactile linen and matte paper textures, refined Kinfolk bookshop photography, muted olive and cream monochromatic palette, natural photographic imperfection, no people, no readable text, no letters or logos, no UI, no border. Camera at 35 degree above table. Tight carefully balanced composition that fills entire image, books prominent. This is an actual website image asset, not a website screenshot.
