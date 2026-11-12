# 生成 App 图标（Android 各密度 + iOS 各尺寸 + 1024 源图）。
# 设计：深绿底 #294b3c + 米白线性书本图标，与站内的图标语言一致。
# 用法：powershell -ExecutionPolicy Bypass -File scripts\build-app-icons.ps1
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase

$Root = Split-Path -Parent $PSScriptRoot
$Out = Join-Path $Root 'static\app-icons'
New-Item -ItemType Directory -Force -Path $Out | Out-Null

$BG = '#294b3c'
$INK = '#eee8d5'
# 24×24 viewBox 的书本图标（与 AppIcon 的 book 图形一致）
$BookPath = 'M12 5c-3-2-6-2-10-1v15c4-1 7-1 10 1 3-2 6-2 10-1V4c-4-1-7-1-10 1Zm0 0v15'

$Sizes = @(20, 29, 40, 48, 58, 60, 72, 76, 80, 87, 96, 120, 144, 152, 167, 180, 192, 512, 1024)

$geo = [System.Windows.Media.Geometry]::Parse($BookPath)
$bgBrush = New-Object System.Windows.Media.SolidColorBrush ([System.Windows.Media.ColorConverter]::ConvertFromString($BG))
$inkBrush = New-Object System.Windows.Media.SolidColorBrush ([System.Windows.Media.ColorConverter]::ConvertFromString($INK))
$bgBrush.Freeze(); $inkBrush.Freeze()

foreach ($Size in $Sizes) {
  # 图标占画布 56%，居中；描边按比例缩放，保证各尺寸视觉一致
  $iconBox = $Size * 0.56
  $scale = $iconBox / 24.0
  $offset = ($Size - $iconBox) / 2

  $strokeWidth = 1.5
  $pen = New-Object System.Windows.Media.Pen $inkBrush, $strokeWidth
  $pen.StartLineCap = [System.Windows.Media.PenLineCap]::Round
  $pen.EndLineCap = [System.Windows.Media.PenLineCap]::Round
  $pen.LineJoin = [System.Windows.Media.PenLineJoin]::Round
  $pen.Freeze()

  $visual = New-Object System.Windows.Media.DrawingVisual
  $dc = $visual.RenderOpen()
  $dc.DrawRectangle($bgBrush, $null, (New-Object System.Windows.Rect 0, 0, $Size, $Size))
  $dc.PushTransform((New-Object System.Windows.Media.TranslateTransform $offset, $offset))
  $dc.PushTransform((New-Object System.Windows.Media.ScaleTransform $scale, $scale))
  $dc.DrawGeometry([System.Windows.Media.Brushes]::Transparent, $pen, $geo)
  $dc.Pop(); $dc.Pop()
  $dc.Close()

  $bmp = New-Object System.Windows.Media.Imaging.RenderTargetBitmap $Size, $Size, 96, 96, ([System.Windows.Media.PixelFormats]::Pbgra32)
  $bmp.Render($visual)
  $enc = New-Object System.Windows.Media.Imaging.PngBitmapEncoder
  $enc.Frames.Add([System.Windows.Media.Imaging.BitmapFrame]::Create($bmp))
  $stream = [System.IO.File]::Create((Join-Path $Out "icon-$Size.png"))
  $enc.Save($stream); $stream.Close()
}

Write-Output "App 图标已生成：$($Sizes.Count) 个尺寸 → static/app-icons"
