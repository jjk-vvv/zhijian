# 生成小程序底部 tabBar 图标（81×81，普通/选中两态）。
# 用法：powershell -ExecutionPolicy Bypass -File scripts\build-tabbar.ps1
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase

$Root = Split-Path -Parent $PSScriptRoot
$Out = Join-Path $Root 'static\tabbar'
New-Item -ItemType Directory -Force -Path $Out | Out-Null

$Size = 81
$Scale = $Size / 24.0

# 与 AppIcon 一致的 24×24 线性图标
$Icons = [ordered]@{
  discover = 'M12 5c-3-2-6-2-10-1v15c4-1 7-1 10 1 3-2 6-2 10-1V4c-4-1-7-1-10 1Zm0 0v15'
  shelf    = 'M6 3h12v19l-6-4-6 4V3Z'
  notes    = 'm16 3 5 5-12 12-6 1 1-6L16 3Zm-12 12 5 5M13 6l5 5'
}

$States = [ordered]@{
  ''  = '#7a816d' # 普通态
  '-on' = '#294b3c' # 选中态
}

foreach ($state in $States.Keys) {
  $color = [System.Windows.Media.ColorConverter]::ConvertFromString($States[$state])
  $brush = New-Object System.Windows.Media.SolidColorBrush $color
  $brush.Freeze()
  $pen = New-Object System.Windows.Media.Pen $brush, 1.6
  $pen.StartLineCap = [System.Windows.Media.PenLineCap]::Round
  $pen.EndLineCap = [System.Windows.Media.PenLineCap]::Round
  $pen.LineJoin = [System.Windows.Media.PenLineJoin]::Round
  $pen.Freeze()

  foreach ($name in $Icons.Keys) {
    $geo = [System.Windows.Media.Geometry]::Parse($Icons[$name])
    $visual = New-Object System.Windows.Media.DrawingVisual
    $dc = $visual.RenderOpen()
    $dc.PushTransform((New-Object System.Windows.Media.ScaleTransform $Scale, $Scale))
    $dc.DrawGeometry($null, $pen, $geo)
    $dc.Pop(); $dc.Close()

    $bmp = New-Object System.Windows.Media.Imaging.RenderTargetBitmap $Size, $Size, 96, 96, ([System.Windows.Media.PixelFormats]::Pbgra32)
    $bmp.Render($visual)
    $enc = New-Object System.Windows.Media.Imaging.PngBitmapEncoder
    $enc.Frames.Add([System.Windows.Media.Imaging.BitmapFrame]::Create($bmp))
    $stream = [System.IO.File]::Create((Join-Path $Out "$name$state.png"))
    $enc.Save($stream); $stream.Close()
  }
}

Write-Output "tabBar 图标已生成：$($Icons.Count) 个页面 × 2 态 → static/tabbar"
