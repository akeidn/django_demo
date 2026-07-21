$ErrorActionPreference = 'Stop'

$projectRoot = Split-Path -Parent $PSScriptRoot
$publishDir = Join-Path $projectRoot 'publish\win-x64'

dotnet publish $projectRoot `
  -c Release `
  -r win-x64 `
  --self-contained true `
  -p:PublishSingleFile=false `
  -p:PublishReadyToRun=false `
  -o $publishDir

Write-Host "ACS Bridge published to: $publishDir"
