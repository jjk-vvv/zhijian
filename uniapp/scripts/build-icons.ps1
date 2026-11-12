# 重新生成 static/icons 下的图标 PNG。
#
# AppIcon 在 Web 版里是内联 <svg>，小程序不支持 svg 标签，所以这里用
# WPF 的 Geometry.Parse（原生支持 SVG path 语法）把 24×24 的路径栅格化成
# 多色调 PNG，输出带透明通道，三端表现一致。
#
# 用法（Windows，无需安装任何依赖）：
#   powershell -ExecutionPolicy Bypass -File scripts\build-icons.ps1
#
# 修改图形或色调后重新运行即可；新增色调时记得同步 components/ui/AppIcon.vue 的 tone 取值。

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase

$Root = Split-Path -Parent $PSScriptRoot
$OutRoot = Join-Path $Root 'static\icons'
$Size = 144
$Scale = $Size / 24.0

$Icons = [ordered]@{
  book     = 'M12 5c-3-2-6-2-10-1v15c4-1 7-1 10 1 3-2 6-2 10-1V4c-4-1-7-1-10 1Zm0 0v15'
  arrow    = 'M4 12h15m-6-6 6 6-6 6'
  search   = 'm21 21-5-5M18 10a8 8 0 1 1-16 0 8 8 0 0 1 16 0'
  bookmark = 'M6 3h12v19l-6-4-6 4V3Z'
  check    = 'm5 12 4 4L19 6'
  plus     = 'M12 5v14M5 12h14'
  close    = 'm6 6 12 12M6 18 18 6'
  chevron  = 'm8 5 7 7-7 7'
  down     = 'm6 9 6 6 6-6'
  pen      = 'm16 3 5 5-12 12-6 1 1-6L16 3Zm-12 12 5 5M13 6l5 5'
  leaf     = 'M20 3C8 1 1 8 5 17c9 4 16-3 15-14ZM4 21 16 9'
  trash    = 'M3 6h18M9 6V3h6v3M5 6l1 15h12l1-15M10 10v7m4-7v7'
  grid     = 'M3 3h7v7H3V3Zm11 0h7v7h-7V3ZM3 14h7v7H3v-7Zm11 0h7v7h-7v-7Z'
  clock    = 'M12 8v5l3 2M22 12a10 10 0 1 1-20 0 10 10 0 0 1 20 0'
}

# 与 Web 版各处的 color / currentColor 对应，归并为 7 个色阶。
$Tones = [ordered]@{
  ink   = '#263c32'
  green = '#294b3c'
  pine  = '#52664b'
  olive = '#6b775f'
  sage  = '#7a8865'
  muted = '#747a71'
  white = '#fffef8'
}

$Geometries = @{}
foreach ($name in $Icons.Keys) {
  $Geometries[$name] = [System.Windows.Media.Geometry]::Parse($Icons[$name])
}

foreach ($tone in $Tones.Keys) {
  $dir = Join-Path $OutRoot $tone
  New-Item -ItemType Directory -Force -Path $dir | Out-Null
  $color = [System.Windows.Media.ColorConverter]::ConvertFromString($Tones[$tone])
  $brush = New-Object System.Windows.Media.SolidColorBrush $color
  $brush.Freeze()
  $pen = New-Object System.Windows.Media.Pen $brush, 1.5
  $pen.StartLineCap = [System.Windows.Media.PenLineCap]::Round
  $pen.EndLineCap = [System.Windows.Media.PenLineCap]::Round
  $pen.LineJoin = [System.Windows.Media.PenLineJoin]::Round
  $pen.Freeze()

  foreach ($name in $Icons.Keys) {
    $visual = New-Object System.Windows.Media.DrawingVisual
    $dc = $visual.RenderOpen()
    $dc.PushTransform((New-Object System.Windows.Media.ScaleTransform $Scale, $Scale))
    $dc.DrawGeometry($null, $pen, $Geometries[$name])
    $dc.Pop()
    $dc.Close()

    $bitmap = New-Object System.Windows.Media.Imaging.RenderTargetBitmap $Size, $Size, 96, 96, ([System.Windows.Media.PixelFormats]::Pbgra32)
    $bitmap.Render($visual)

    $encoder = New-Object System.Windows.Media.Imaging.PngBitmapEncoder
    $encoder.Frames.Add([System.Windows.Media.Imaging.BitmapFrame]::Create($bitmap))
    $stream = [System.IO.File]::Create((Join-Path $dir "$name.png"))
    $encoder.Save($stream)
    $stream.Close()
  }
}

# 封面纸张噪点已内联为 base64 写在 styles/main.css 里，这里不再生成图片文件。

Write-Output "图标已生成：$($Tones.Count) 个色调 × $($Icons.Count) 个图形（$Size px）"
