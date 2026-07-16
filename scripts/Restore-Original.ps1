. "$PSScriptRoot\Common.ps1"
Assert-Administrator
Stop-Configurator

$exe = Get-AppExePath
$backupExe = Join-Path $script:BackupDir $script:ExeName
if (-not (Test-Path -LiteralPath $backupExe -PathType Leaf)) {
    throw 'Резервная копия не найдена.'
}

$backupBytes = [IO.File]::ReadAllBytes($backupExe)
if ($backupBytes.Length -le $script:PatchOffset -or $backupBytes[$script:PatchOffset] -ne $script:ExpectedOriginalByte) {
    throw 'Резервная копия не прошла проверку оригинального байта.'
}

$expectedHash = Get-FileSha256 $backupExe
Copy-Item -LiteralPath $backupExe -Destination $exe -Force
if ((Get-FileSha256 $exe) -ne $expectedHash) {
    throw 'Проверка восстановленного EXE по SHA-256 не пройдена.'
}

Write-PatchLog "Оригинальный EXE восстановлен; SHA-256: $expectedHash"
Write-Host 'Оригинальный EXE восстановлен и проверен.'
