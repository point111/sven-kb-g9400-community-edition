. "$PSScriptRoot\Common.ps1"
Assert-Administrator
Stop-Configurator

$exe = Get-AppExePath
New-Item -ItemType Directory -Force -Path $script:BackupDir | Out-Null

$backupExe = Join-Path $script:BackupDir $script:ExeName
if (-not (Test-Path -LiteralPath $backupExe)) {
    Copy-Item -LiteralPath $exe -Destination $backupExe
}

$bytes = [IO.File]::ReadAllBytes($exe)
if ($bytes.Length -le $script:PatchOffset) {
    throw 'Неожиданный размер EXE: точка патча отсутствует.'
}
$current = $bytes[$script:PatchOffset]
if ($current -eq $script:PatchedByte) {
    Write-Host 'Патч совместимости уже установлен.'
} elseif ($current -eq $script:ExpectedOriginalByte) {
    $bytes[$script:PatchOffset] = $script:PatchedByte
    [IO.File]::WriteAllBytes($exe, $bytes)
    Write-Host 'Патч совместимости установлен.'
} else {
    throw ('Неизвестная версия EXE: в позиции 0x{0:X} найден байт 0x{1:X2}.' -f $script:PatchOffset, $current)
}

$state = [ordered]@{
    installedAt = (Get-Date).ToString('o')
    appDir = $script:AppDir
    patchOffset = ('0x{0:X}' -f $script:PatchOffset)
    originalByte = ('0x{0:X2}' -f $script:ExpectedOriginalByte)
    patchedByte = ('0x{0:X2}' -f $script:PatchedByte)
}
$state | ConvertTo-Json | Set-Content -LiteralPath (Join-Path $script:BackupDir 'state.json') -Encoding UTF8
Write-Host 'Готово. Запустите конфигуратор обычным способом.'
