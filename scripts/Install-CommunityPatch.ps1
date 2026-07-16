. "$PSScriptRoot\Common.ps1"
Assert-Administrator
Stop-Configurator

$exe = Get-AppExePath
New-Item -ItemType Directory -Force -Path $script:BackupDir | Out-Null
$backupExe = Join-Path $script:BackupDir $script:ExeName

$bytes = [IO.File]::ReadAllBytes($exe)
if ($bytes.Length -le $script:PatchOffset) {
    throw 'Неожиданный размер EXE: точка патча отсутствует.'
}

$current = $bytes[$script:PatchOffset]
if ($current -ne $script:ExpectedOriginalByte -and $current -ne $script:PatchedByte) {
    throw ('Неизвестная версия EXE: в позиции 0x{0:X} найден байт 0x{1:X2}.' -f $script:PatchOffset, $current)
}

if (-not (Test-Path -LiteralPath $backupExe -PathType Leaf)) {
    Copy-Item -LiteralPath $exe -Destination $backupExe
    if ((Get-FileSha256 $exe) -ne (Get-FileSha256 $backupExe)) {
        Remove-Item -LiteralPath $backupExe -Force -ErrorAction SilentlyContinue
        throw 'Не удалось проверить резервную копию оригинального EXE.'
    }
    Write-PatchLog 'Создана и проверена резервная копия оригинального EXE.'
} elseif ([IO.File]::ReadAllBytes($backupExe)[$script:PatchOffset] -ne $script:ExpectedOriginalByte) {
    throw 'Существующая резервная копия не похожа на оригинальный EXE. Восстановление небезопасно.'
}

$originalSha256 = Get-FileSha256 $backupExe
if ($current -eq $script:PatchedByte) {
    Write-Host 'Патч совместимости уже установлен.'
    Write-PatchLog 'Повторный запуск: патч уже установлен.'
} else {
    $bytes[$script:PatchOffset] = $script:PatchedByte
    Write-BytesAtomically -Path $exe -Bytes $bytes

    $verified = [IO.File]::ReadAllBytes($exe)
    if ($verified.Length -le $script:PatchOffset -or $verified[$script:PatchOffset] -ne $script:PatchedByte) {
        Copy-Item -LiteralPath $backupExe -Destination $exe -Force
        throw 'Проверка записанного EXE не пройдена; оригинал восстановлен.'
    }
    Write-Host 'Патч совместимости установлен и проверен.'
    Write-PatchLog 'Патч совместимости установлен и проверен.'
}

$state = [ordered]@{
    schemaVersion = 1
    installedAt = (Get-Date).ToString('o')
    appDir = $script:AppDir
    exeName = $script:ExeName
    patchOffset = ('0x{0:X}' -f $script:PatchOffset)
    originalByte = ('0x{0:X2}' -f $script:ExpectedOriginalByte)
    patchedByte = ('0x{0:X2}' -f $script:PatchedByte)
    originalSha256 = $originalSha256
    currentSha256 = Get-FileSha256 $exe
}
$state | ConvertTo-Json | Set-Content -LiteralPath $script:StatePath -Encoding UTF8
Write-Host "Готово. Журнал: $script:LogPath"
