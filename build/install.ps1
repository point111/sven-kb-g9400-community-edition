Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path $PSScriptRoot -Parent
$installer = Join-Path $repoRoot 'scripts\Install-CommunityPatch.ps1'
$programFilesX86 = ${env:ProgramFiles(x86)}
if ([string]::IsNullOrWhiteSpace($programFilesX86)) {
    $programFilesX86 = $env:ProgramFiles
}
if ([string]::IsNullOrWhiteSpace($programFilesX86)) {
    throw 'Не удалось определить каталог Program Files (x86).'
}
$appDir = Join-Path $programFilesX86 'KB-G9400 Gaming Keyboard'
$exePath = Join-Path $appDir 'KB-G9400 Gaming Keyboard.exe'
$backupDir = Join-Path $appDir '.community-patch-backup'
$statePath = Join-Path $backupDir 'state.json'
$logPath = Join-Path $backupDir 'community-patch.log'

function Test-Administrator {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = [Security.Principal.WindowsPrincipal]::new($identity)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

try {
    Write-Host 'SVEN KB-G9400 Community Edition — установка' -ForegroundColor Cyan

    if (-not (Test-Administrator)) {
        throw 'Запустите PowerShell от имени администратора.'
    }

    if (-not (Test-Path -LiteralPath $installer)) {
        throw "Скрипт установки не найден: $installer"
    }

    if (-not (Test-Path -LiteralPath $exePath)) {
        throw "Официальный конфигуратор не найден: $exePath"
    }

    & $installer

    if (-not (Test-Path -LiteralPath $backupDir)) {
        throw "Каталог резервной копии не создан: $backupDir"
    }

    if (-not (Test-Path -LiteralPath $statePath)) {
        throw "Файл состояния не создан: $statePath"
    }

    if (-not (Test-Path -LiteralPath $logPath)) {
        Write-Warning "Журнал пока не найден: $logPath"
    }

    Write-Host ''
    Write-Host 'Установка завершена.' -ForegroundColor Green
    Write-Host "Конфигуратор: $exePath"
    Write-Host "Резервная копия: $backupDir"
    Write-Host "Состояние: $statePath"
    Write-Host "Журнал: $logPath"
    exit 0
}
catch {
    Write-Host ''
    Write-Error $_.Exception.Message
    Write-Host 'Установка не завершена. Исходный EXE не следует изменять вручную.' -ForegroundColor Yellow
    exit 1
}
