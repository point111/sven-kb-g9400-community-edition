Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$script:AppDir = Join-Path ${env:ProgramFiles(x86)} 'KB-G9400 Gaming Keyboard'
$script:ExeName = 'KB-G9400 Gaming Keyboard.exe'
$script:BackupDir = Join-Path $script:AppDir '.community-patch-backup'
$script:PatchOffset = 0x669B
$script:ExpectedOriginalByte = 0x74
$script:PatchedByte = 0xEB

function Assert-Administrator {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = [Security.Principal.WindowsPrincipal]::new($identity)
    if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        throw 'Запустите PowerShell от имени администратора.'
    }
}

function Get-AppExePath {
    $path = Join-Path $script:AppDir $script:ExeName
    if (-not (Test-Path -LiteralPath $path)) {
        throw "Официальный конфигуратор не найден: $path"
    }
    return $path
}

function Stop-Configurator {
    Get-Process -ErrorAction SilentlyContinue |
        Where-Object { $_.Path -and $_.Path.StartsWith($script:AppDir, [StringComparison]::OrdinalIgnoreCase) } |
        Stop-Process -Force
}
