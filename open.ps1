# herdr link handler: open a clicked file:// URL with the Windows default app.
# Directories open in Explorer. Only local file:// URLs are accepted.
$ErrorActionPreference = 'Stop'
$url = $env:HERDR_PLUGIN_CLICKED_URL

$logDir = if ($env:HERDR_PLUGIN_STATE_DIR) { $env:HERDR_PLUGIN_STATE_DIR } else { $PSScriptRoot }
$log = Join-Path $logDir 'open.log'
function Write-Log([string]$msg) {
    try {
        New-Item -ItemType Directory -Force $logDir | Out-Null
        Add-Content -LiteralPath $log -Value ("{0:s} {1}" -f (Get-Date), $msg) -Encoding utf8
    } catch {}
}

try {
    if (-not $url) { throw 'HERDR_PLUGIN_CLICKED_URL is empty' }
    $uri = [Uri]$url
    if ($uri.Scheme -ne 'file') { throw "not a file URL: $url" }
    # LocalPath decodes %20 etc. and drops any #fragment; UNC hosts become \\host\share
    $path = $uri.LocalPath
    if (-not (Test-Path -LiteralPath $path)) { throw "path not found: $path" }
    Invoke-Item -LiteralPath $path
    Write-Log "opened $path"
} catch {
    Write-Log "error: $($_.Exception.Message) (url=$url)"
    exit 1
}
