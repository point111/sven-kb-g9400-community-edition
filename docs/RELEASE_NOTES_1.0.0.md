# SVEN KB-G9400 Community Patch v1.0.0

The first stable release of the Windows 11 compatibility patch for the official SVEN KB-G9400 configurator.

## Purpose

This release only restores the vendor software on Windows 11. It does not add features beyond the original configurator and does not localize its English interface.

## Verified on

- Windows 11 25H2;
- keyboard `VID_30FA&PID_2350`.

## Confirmed functionality

- configurator starts without `Product and driver are inconsistent`;
- lighting controls work;
- key reassignment works;
- INI profiles are saved;
- repeated installation is safe;
- the original EXE can be fully restored;
- automated integrity checks pass in patched and restored states.

## Installation

Install the official SVEN KB-G9400 software first. Then open PowerShell as Administrator in the extracted repository or release archive:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\build\install.ps1
.\build\test.ps1
```

A successful check ends with `RESULT: PASS`.

## Restore

```powershell
.\build\restore.ps1
.\build\test.ps1
```

## Safety

The patch verifies the expected original state, creates a backup, uses an atomic replacement, records SHA-256 values, and refuses unknown EXE versions.

## Limitations

- only the confirmed Windows and hardware configuration is officially verified;
- the original vendor package must be installed separately;
- no original or modified SVEN binary is included;
- localization and community-only extensions are planned for version 2.x.