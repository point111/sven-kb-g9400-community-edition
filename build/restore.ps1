Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

Write-Host 'SVEN KB-G9400 Community Edition — восстановление'

try {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = [Security.Principal.WindowsPrincipal]::new($identity)
    if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        throw 'Запустите PowerShell от имени администратора.'
    }

    $repoRoot = Split-Path $PSScriptRoot -Parent
    $restoreScript = Join-Path $repoRoot 'scripts\Restore-Original.ps1'
    if (-not (Test-Path -LiteralPath $restoreScript)) {
        throw "Скрипт восстановления не найден: $restoreScript"
    }

    & $restoreScript
    if (-not $?) {
        throw 'Скрипт восстановления завершился с ошибкой.'
    }

    Write-Host ''
    Write-Host 'Восстановление завершено.'
    exit 0
} catch {
    Write-Error $_
    exit 1
}
