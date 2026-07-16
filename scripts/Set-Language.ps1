param(
    [Parameter(Mandatory=$true)]
    [ValidateSet('ru','en')]
    [string]$Language
)
. "$PSScriptRoot\Common.ps1"
Assert-Administrator
Stop-Configurator

$payload = Join-Path (Split-Path $PSScriptRoot -Parent) "payload\lang\$Language"
if (-not (Test-Path -LiteralPath $payload)) {
    throw "Языковой пакет не найден: $payload"
}
Copy-Item -LiteralPath (Join-Path $payload '*') -Destination (Join-Path $script:AppDir 'skins') -Recurse -Force
Write-Host "Выбран язык: $Language"
Start-Process -FilePath (Get-AppExePath)
