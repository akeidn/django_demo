$ErrorActionPreference = 'Stop'

$taskName = 'YiyaoAcsBridge'
$sourceDir = Resolve-Path (Join-Path $PSScriptRoot '..\publish\win-x64')
$installDir = Join-Path $env:LOCALAPPDATA 'YiyaoAcsBridge'
$exePath = Join-Path $installDir 'AcsBridge.exe'

if (-not (Test-Path $sourceDir)) {
  throw "Publish directory not found: $sourceDir. Run scripts\publish_windows.ps1 first."
}

New-Item -ItemType Directory -Force $installDir | Out-Null
Copy-Item (Join-Path $sourceDir '*') $installDir -Recurse -Force

$action = New-ScheduledTaskAction -Execute $exePath
$trigger = New-ScheduledTaskTrigger -AtLogOn
$principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -LogonType Interactive -RunLevel Highest
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -ExecutionTimeLimit ([TimeSpan]::Zero)

Register-ScheduledTask `
  -TaskName $taskName `
  -Action $action `
  -Trigger $trigger `
  -Principal $principal `
  -Settings $settings `
  -Force | Out-Null

Start-ScheduledTask -TaskName $taskName
Start-Sleep -Seconds 3

try {
  Invoke-WebRequest -Uri 'http://127.0.0.1:5055/api/acs/status' -UseBasicParsing -TimeoutSec 5 | Select-Object -ExpandProperty Content
  Write-Host "Local ACS Bridge installed and started."
} catch {
  Write-Warning "Task installed, but http://127.0.0.1:5055/api/acs/status is not reachable yet. Check ACS Bridge or security software."
}
