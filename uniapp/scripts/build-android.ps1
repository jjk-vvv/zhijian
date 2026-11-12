param(
  [string]$HBuilderXRoot = 'D:\HBuilderX.5.24.2026081301\HBuilderX',
  [string]$ProjectName = 'uniapp',
  [int]$WaitForProcessId = 0,
  [int]$TimeoutMinutes = 180,
  [switch]$Traditional
)

$ErrorActionPreference = 'Stop'
$ProjectRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$Manifest = Get-Content -LiteralPath (Join-Path $ProjectRoot 'manifest.json') -Raw -Encoding UTF8 | ConvertFrom-Json
# 当前 apktool / aapt2 在中文用户目录中会丢失路径编码；使用完整云打包避开本地合成。
$UseTraditional = $Traditional -or ([Environment]::GetFolderPath('LocalApplicationData') -match '[^\x00-\x7f]')
$Cli = Join-Path $HBuilderXRoot 'cli.exe'
$Java = Join-Path $HBuilderXRoot 'plugins\amazon-corretto\bin\java.exe'
$Signer = Join-Path $HBuilderXRoot 'plugins\app-safe-pack\apksigner.jar'
$ReleaseRoot = Join-Path $ProjectRoot 'unpackage\release'
$DeliveryDir = Join-Path $ReleaseRoot ("zhijian-android-{0}" -f $Manifest.versionName)
$StatusPath = Join-Path $DeliveryDir 'status.json'
$LogPath = Join-Path $DeliveryDir 'build.log'
$FinalApk = Join-Path $DeliveryDir ("zhijian-{0}-android.apk" -f $Manifest.versionName)
$Deadline = (Get-Date).AddMinutes($TimeoutMinutes)
New-Item -ItemType Directory -Path $DeliveryDir -Force | Out-Null

function Write-BuildStatus([string]$State, [string]$Message, [string]$Apk = '') {
  $Status = [ordered]@{
    state = $State
    message = $Message
    updatedAt = (Get-Date).ToString('o')
    appid = $Manifest.appid
    packageName = 'com.zhijian.reading'
    versionName = $Manifest.versionName
    versionCode = $Manifest.versionCode
    apk = $Apk
    log = $LogPath
  }
  $Status | ConvertTo-Json | Set-Content -LiteralPath "$StatusPath.tmp" -Encoding UTF8
  Move-Item -LiteralPath "$StatusPath.tmp" -Destination $StatusPath -Force
  Write-Output "$State : $Message"
}

function Get-RawApks {
  Get-ChildItem -LiteralPath $ReleaseRoot -Filter '*.apk' -Recurse -File -ErrorAction SilentlyContinue |
    Where-Object { -not $_.FullName.StartsWith($DeliveryDir, [System.StringComparison]::OrdinalIgnoreCase) } |
    Sort-Object LastWriteTimeUtc -Descending
}

try {
  foreach ($Required in @($Cli, $Java, $Signer)) {
    if (-not (Test-Path -LiteralPath $Required)) { throw "Required HBuilderX tool not found: $Required" }
  }

  if ($WaitForProcessId -gt 0) {
    # 保留已经提交任务的队列位置，完成后再编译当前业务代码。
    Write-BuildStatus 'waiting' 'Waiting for the existing free cloud build and native package cache.'
    while (Get-Process -Id $WaitForProcessId -ErrorAction SilentlyContinue) {
      if ((Get-Date) -gt $Deadline) { throw 'Timed out waiting for the existing build. Check HBuilderX cloud build status.' }
      Start-Sleep -Seconds 10
    }
    $NativeCache = Join-Path $ProjectRoot "unpackage\cache\apk\$($Manifest.appid)_cm.apk"
    if (-not (Get-RawApks | Select-Object -First 1) -and -not (Test-Path -LiteralPath $NativeCache)) {
      throw 'The initial cloud build ended without an APK or native cache. Check HBuilderX cloud build status.'
    }
  }

  Write-BuildStatus 'building' 'Packaging current source with the official HBuilderX cloud-pack pipeline.'
  $BuildStartedUtc = (Get-Date).ToUniversalTime()
  $SafeMode = if ($UseTraditional) { 'false' } else { 'true' }
  & $Cli pack --project $ProjectName --platform android --safemode $SafeMode --iscustom false `
    --sourceMap false --splashads false --rpads false --unimpads false `
    --android.packagename com.zhijian.reading --android.androidpacktype 3 2>&1 |
    ForEach-Object { "$_" -replace 'token=[a-zA-Z0-9]+', 'token=[redacted]' } |
    Tee-Object -FilePath $LogPath
  if ($LASTEXITCODE -ne 0) { throw "HBuilderX exited with code $LASTEXITCODE" }

  $BuiltApk = Get-RawApks | Where-Object { $_.LastWriteTimeUtc -ge $BuildStartedUtc.AddSeconds(-2) } | Select-Object -First 1
  if (-not $BuiltApk -and $UseTraditional) {
    $BuildLog = Get-Content -LiteralPath $LogPath -Raw -Encoding UTF8
    $DownloadMatches = [regex]::Matches($BuildLog, 'https://(?:app\.liuyingyong\.cn|service\.dcloud\.net\.cn)/build/download/[a-zA-Z0-9-]+')
    $DownloadMatch = $DownloadMatches | Select-Object -Last 1
    if ($DownloadMatch.Success -and $BuildLog -match '打包成功') {
      $DownloadDir = Join-Path $ReleaseRoot 'apk'
      New-Item -ItemType Directory -Path $DownloadDir -Force | Out-Null
      $DownloadedApk = Join-Path $DownloadDir ("{0}-cloud-{1}.apk" -f $Manifest.appid, (Get-Date -Format 'yyyyMMddHHmmss'))
      Invoke-WebRequest -Uri $DownloadMatch.Value -OutFile $DownloadedApk -TimeoutSec 120
      $BuiltApk = Get-Item -LiteralPath $DownloadedApk
    }
  }
  if (-not $BuiltApk) { throw 'HBuilderX did not produce a new APK. Inspect build.log; an older APK will not be delivered.' }
  $ServicePath = Join-Path $ProjectRoot 'unpackage\dist\build\app-plus\app-service.js'
  if (-not (Test-Path -LiteralPath $ServicePath)) { throw 'App service build output is missing.' }
  $ServiceSource = Get-Content -LiteralPath $ServicePath -Raw -Encoding UTF8
  if ($ServiceSource -match '\bdocument\.(activeElement|body|addEventListener|removeEventListener)') {
    throw 'Browser-only modal code is still present in the App service. Refusing to deliver this APK.'
  }

  Write-BuildStatus 'verifying' 'Verifying the packaged app identity, source payload and APK signature.'
  Add-Type -AssemblyName System.IO.Compression.FileSystem
  $ApkArchive = [System.IO.Compression.ZipFile]::OpenRead($BuiltApk.FullName)
  try {
    $AssetRoot = "assets/apps/$($Manifest.appid)/www/"
    $ServiceEntry = $ApkArchive.GetEntry("${AssetRoot}app-service.js")
    $ManifestEntry = $ApkArchive.GetEntry("${AssetRoot}manifest.json")
    if (-not $ServiceEntry -or -not $ManifestEntry) { throw 'The APK does not contain the expected uni-app payload.' }
    $ServiceStream = $ServiceEntry.Open()
    $Hasher = [System.Security.Cryptography.SHA256]::Create()
    try {
      $PackedServiceHash = [System.BitConverter]::ToString($Hasher.ComputeHash($ServiceStream)).Replace('-', '')
    } finally {
      $ServiceStream.Dispose()
      $Hasher.Dispose()
    }
    if ($PackedServiceHash -ne (Get-FileHash -LiteralPath $ServicePath -Algorithm SHA256).Hash) {
      throw 'APK payload differs from the latest compiled app service.'
    }
    $ManifestReader = [System.IO.StreamReader]::new($ManifestEntry.Open())
    try { $PackedManifest = $ManifestReader.ReadToEnd() | ConvertFrom-Json } finally { $ManifestReader.Dispose() }
    if ($PackedManifest.id -ne $Manifest.appid -or $PackedManifest.name -ne $Manifest.name -or
        $PackedManifest.version.name -ne $Manifest.versionName -or
        "$($PackedManifest.version.code)" -ne "$($Manifest.versionCode)") {
      throw 'Packaged app identity or version differs from manifest.json.'
    }
  } finally {
    $ApkArchive.Dispose()
  }
  $SignatureOutput = & $Java -jar $Signer verify --verbose --print-certs $BuiltApk.FullName 2>&1
  $SignatureOutput | Set-Content -LiteralPath (Join-Path $DeliveryDir 'signature.txt') -Encoding UTF8
  if ($LASTEXITCODE -ne 0) { throw 'APK signature verification failed. See signature.txt.' }
  Copy-Item -LiteralPath $BuiltApk.FullName -Destination $FinalApk -Force
  $ApkHash = (Get-FileHash -LiteralPath $FinalApk -Algorithm SHA256).Hash.ToLowerInvariant()
  "$ApkHash  $([System.IO.Path]::GetFileName($FinalApk))" |
    Set-Content -LiteralPath (Join-Path $DeliveryDir 'SHA256SUMS.txt') -Encoding UTF8
  Write-BuildStatus 'complete' 'APK generated and signature verified.' $FinalApk
} catch {
  Write-BuildStatus 'failed' $_.Exception.Message
  $_ | Out-String | Add-Content -LiteralPath $LogPath -Encoding UTF8
  exit 1
}
