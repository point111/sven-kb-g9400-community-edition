Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

Write-Host 'SVEN KB-G9400 Community Edition — проверка установки'

$failures = [System.Collections.Generic.List[string]]::new()
$programFilesX86 = ${env:ProgramFiles(x86)}
$appDir = Join-Path $programFilesX86 'KB-G9400 Gaming Keyboard'
$exe = Join-Path $appDir 'KB-G9400 Gaming Keyboard.exe'
$backupDir = Join-Path $appDir '.community-patch-backup'
$backupExe = Join-Path $backupDir 'KB-G9400 Gaming Keyboard.exe'
$statePath = Join-Path $backupDir 'state.json'
$logPath = Join-Path $backupDir 'community-patch.log'
$patchOffset = 0x669B
$originalByte = 0x74
$patchedByte = 0xEB

function Test-RequiredPath {
    param([string]$Path, [string]$Label)
    if (Test-Path -LiteralPath $Path) {
        Write-Host "[PASS] $Label"
        return $true
    }
    Write-Host "[FAIL] $Label"
    $failures.Add("Отсутствует: $Path")
    return $false
}

$exeExists = Test-RequiredPath -Path $exe -Label 'Конфигуратор найден'
$backupExists = Test-RequiredPath -Path $backupExe -Label 'Резервная копия найдена'
$stateExists = Test-RequiredPath -Path $statePath -Label 'state.json найден'
$logExists = Test-RequiredPath -Path $logPath -Label 'Журнал найден'

if ($exeExists) {
    $bytes = [IO.File]::ReadAllBytes($exe)
    if ($bytes.Length -le $patchOffset) {
        Write-Host '[FAIL] EXE слишком мал для проверки точки патча'
        $failures.Add('Точка патча отсутствует в текущем EXE.')
    } else {
        $current = $bytes[$patchOffset]
        if ($current -eq $patchedByte) {
            Write-Host '[PASS] Патч установлен'
        } elseif ($current -eq $originalByte) {
            Write-Host '[INFO] Сейчас установлен оригинальный EXE'
        } else {
            Write-Host ('[FAIL] Неизвестный байт в точке патча: 0x{0:X2}' -f $current)
            $failures.Add('Текущий EXE не соответствует известному оригинальному или исправленному состоянию.')
        }
    }
}

if ($stateExists) {
    try {
        $state = Get-Content -LiteralPath $statePath -Raw | ConvertFrom-Json
        Write-Host '[PASS] state.json читается'
        if ($state.originalSha256) {
            Write-Host "[INFO] SHA-256 оригинала: $($state.originalSha256)"
        }
        if ($state.currentSha256) {
            Write-Host "[INFO] SHA-256 текущего EXE: $($state.currentSha256)"
        }
    } catch {
        Write-Host '[FAIL] state.json повреждён или имеет неизвестный формат'
        $failures.Add($_.Exception.Message)
    }
}

if ($backupExists -and $stateExists) {
    try {
        $state = Get-Content -LiteralPath $statePath -Raw | ConvertFrom-Json
        if ($state.originalSha256) {
            $actualBackupHash = (Get-FileHash -LiteralPath $backupExe -Algorithm SHA256).Hash
            if ($actualBackupHash -eq $state.originalSha256) {
                Write-Host '[PASS] SHA-256 резервной копии совпадает с state.json'
            } else {
                Write-Host '[FAIL] SHA-256 резервной копии не совпадает с state.json'
                $failures.Add('Контрольная сумма резервной копии не совпадает.')
            }
        }
    } catch {
        $failures.Add($_.Exception.Message)
    }
}

Write-Host ''
if ($failures.Count -eq 0) {
    Write-Host 'RESULT: PASS'
    exit 0
}

Write-Host 'RESULT: FAIL'
$failures | ForEach-Object { Write-Host "- $_" }
exit 1
