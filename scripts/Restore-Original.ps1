. "$PSScriptRoot\Common.ps1"
Assert-Administrator
Stop-Configurator

$backupExe = Join-Path $script:BackupDir $script:ExeName
if (-not (Test-Path -LiteralPath $backupExe)) {
    throw 'Резервная копия не найдена.'
}
Copy-Item -LiteralPath $backupExe -Destination (Join-Path $script:AppDir $script:ExeName) -Force
Write-Host 'Оригинальный EXE восстановлен.'
