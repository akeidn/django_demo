$ErrorActionPreference = 'Stop'

$taskName = 'YiyaoAcsBridge'
$installDir = Join-Path $env:LOCALAPPDATA 'YiyaoAcsBridge'

if (Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue) {
  Stop-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue
  Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
}

if (Test-Path $installDir) {
  Remove-Item $installDir -Recurse -Force
}

Write-Host "Local ACS Bridge uninstalled."
