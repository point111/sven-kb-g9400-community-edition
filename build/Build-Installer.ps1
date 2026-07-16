Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot
$issPath = Join-Path $repoRoot 'installer\setup.iss'
$distDir = Join-Path $repoRoot 'dist'

$searchRoots = @(
    ${env:ProgramFiles(x86)},
    $env:ProgramFiles
) | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }

$compilerCandidates = @(
    $searchRoots |
        ForEach-Object { Join-Path $_ 'Inno Setup 6\ISCC.exe' } |
        Where-Object { Test-Path -LiteralPath $_ -PathType Leaf }
)

if ($compilerCandidates.Count -eq 0) {
    throw 'Inno Setup 6 compiler was not found. Install Inno Setup 6, then run this script again.'
}

$iscc = $compilerCandidates[0]
New-Item -ItemType Directory -Path $distDir -Force | Out-Null

Write-Host "Building installer with: $iscc"
& $iscc $issPath
if ($LASTEXITCODE -ne 0) {
    throw "Inno Setup compilation failed with exit code $LASTEXITCODE."
}

$setup = Join-Path $distDir 'SVEN-KB-G9400-Community-Patch-1.0.0-Setup.exe'
if (-not (Test-Path -LiteralPath $setup -PathType Leaf)) {
    throw "Expected installer was not created: $setup"
}

$hash = Get-FileHash -LiteralPath $setup -Algorithm SHA256
$hashLine = "$($hash.Hash.ToLowerInvariant())  $([IO.Path]::GetFileName($setup))"
$hashPath = Join-Path $distDir 'SHA256SUMS.txt'
Set-Content -LiteralPath $hashPath -Value $hashLine -Encoding ascii

Write-Host ''
Write-Host 'Installer built successfully.'
Write-Host "Installer: $setup"
Write-Host "SHA-256: $($hash.Hash)"
Write-Host "Checksums: $hashPath"
