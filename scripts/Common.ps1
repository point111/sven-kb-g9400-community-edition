Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$script:AppDir = Join-Path ${env:ProgramFiles(x86)} 'KB-G9400 Gaming Keyboard'
$script:ExeName = 'KB-G9400 Gaming Keyboard.exe'
$script:BackupDir = Join-Path $script:AppDir '.community-patch-backup'
$script:PatchOffset = 0x669B
$script:ExpectedOriginalByte = 0x74
$script:PatchedByte = 0xEB
$script:StatePath = Join-Path $script:BackupDir 'state.json'
$script:LogPath = Join-Path $script:BackupDir 'community-patch.log'

function Assert-Administrator {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = [Security.Principal.WindowsPrincipal]::new($identity)
    if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        throw 'Запустите PowerShell от имени администратора.'
    }
}

function Get-AppExePath {
    $path = Join-Path $script:AppDir $script:ExeName
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
        throw "Официальный конфигуратор не найден: $path"
    }
    return $path
}

function Stop-Configurator {
    Get-Process -ErrorAction SilentlyContinue |
        Where-Object {
            try { $_.Path -and $_.Path.StartsWith($script:AppDir, [StringComparison]::OrdinalIgnoreCase) }
            catch { $false }
        } |
        Stop-Process -Force
}

function Get-FileSha256([Parameter(Mandatory=$true)][string]$Path) {
    return (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash.ToLowerInvariant()
}

function Write-PatchLog([Parameter(Mandatory=$true)][string]$Message) {
    New-Item -ItemType Directory -Force -Path $script:BackupDir | Out-Null
    $line = '{0} {1}' -f (Get-Date).ToString('o'), $Message
    Add-Content -LiteralPath $script:LogPath -Value $line -Encoding UTF8
}

function Write-BytesAtomically {
    param(
        [Parameter(Mandatory=$true)][string]$Path,
        [Parameter(Mandatory=$true)][byte[]]$Bytes
    )

    $directory = Split-Path -Parent $Path
    $temporary = Join-Path $directory ('.{0}.{1}.tmp' -f ([IO.Path]::GetFileName($Path)), [Guid]::NewGuid().ToString('N'))
    try {
        [IO.File]::WriteAllBytes($temporary, $Bytes)
        Move-Item -LiteralPath $temporary -Destination $Path -Force
    } finally {
        if (Test-Path -LiteralPath $temporary) {
            Remove-Item -LiteralPath $temporary -Force -ErrorAction SilentlyContinue
        }
    }
}
