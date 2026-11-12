# 发行构建：不依赖 HBuilderX 的「发行」菜单，直接调用 IDE 内置的 uni-app(vue3) 编译器。
#
# 背景：HBuilderX 的「发行」入口会先校验 AppID 是否已在 DCloud 账号下注册，
# 临时账号（*@tmp.dcloud.io）没有注册 AppID，会直接报「appid 不存在」而无法产出。
# 本脚本绕过该前置校验，只用编译器产出标准的发行目录。
#
# 用法：
#   pwsh scripts/build-release.ps1 -Platform h5
#   pwsh scripts/build-release.ps1 -Platform mp-weixin
#   pwsh scripts/build-release.ps1 -Platform both
param(
  [ValidateSet('h5', 'mp-weixin', 'both')]
  [string]$Platform = 'both'
)

$ErrorActionPreference = 'Stop'

$ProjectRoot = Resolve-Path (Join-Path $PSScriptRoot '..')
$HbxRoot = 'D:\HBuilderX.5.24.2026081301\HBuilderX'
$CliPlugin = Join-Path $HbxRoot 'plugins\uniapp-cli-vite'
$ViteBin = Join-Path $CliPlugin 'node_modules\vite\bin\vite.js'

if (-not (Test-Path $ViteBin)) {
  throw "未找到 HBuilderX 的 uni-app 编译器：$ViteBin（请确认 HBuilderX 安装路径）"
}

# 配置必须放在编译器插件目录内，否则 @dcloudio/vite-plugin-uni 无法被解析。
$ConfigPath = Join-Path $CliPlugin '.uni-release.config.mjs'
$config = @'
import { defineConfig } from 'vite'
import uniPkg from '@dcloudio/vite-plugin-uni'

const uni = uniPkg.default || uniPkg

export default defineConfig({
  root: process.env.UNI_INPUT_DIR,
  resolve: {
    extensions: ['.mjs', '.js', '.ts', '.jsx', '.tsx', '.json', '.vue'],
  },
  build: {
    outDir: process.env.UNI_OUTPUT_DIR,
    emptyOutDir: true,
  },
  plugins: [uni()],
})
'@
[System.IO.File]::WriteAllText($ConfigPath, $config, (New-Object System.Text.UTF8Encoding($false)))

$targets = if ($Platform -eq 'both') { @('h5', 'mp-weixin') } else { @($Platform) }

try {
  foreach ($target in $targets) {
    # H5 的发行目录沿用 HBuilderX 的约定 unpackage/dist/build/web
    $dirName = if ($target -eq 'h5') { 'web' } else { $target }
    $outDir = Join-Path $ProjectRoot "unpackage\dist\build\$dirName"
    Write-Output "=== 构建 $target → $outDir ==="

    $env:UNI_PLATFORM = $target
    $env:UNI_INPUT_DIR = $ProjectRoot.Path
    $env:UNI_OUTPUT_DIR = $outDir
    $env:UNI_CLI_CONTEXT = $CliPlugin
    $env:UNI_APP_X = 'false'
    $env:NODE_ENV = 'production'

    Push-Location $CliPlugin
    try {
      & node $ViteBin build --config $ConfigPath
      if ($LASTEXITCODE -ne 0) { throw "构建 $target 失败（exit=$LASTEXITCODE）" }
    } finally {
      Pop-Location
    }

    $files = Get-ChildItem $outDir -Recurse -File
    Write-Output ("    产物 {0} 个文件，{1} KB" -f $files.Count, [math]::Round(($files | Measure-Object Length -Sum).Sum / 1KB, 1))
  }
} finally {
  Remove-Item $ConfigPath -Force -ErrorAction SilentlyContinue
}

Write-Output '完成。'
