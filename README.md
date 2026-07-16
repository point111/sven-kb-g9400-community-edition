# SVEN KB-G9400 Community Patch

[Русская версия](README.ru.md)

An unofficial Windows 11 compatibility patch for the official SVEN KB-G9400 keyboard configurator.

## Version 1.x scope

Version 1.x has one purpose: restore the original vendor software on Windows 11. It does not add new keyboard features and does not localize the English user interface.

The patch bypasses the incorrect `Product and driver are inconsistent` rejection while preserving the original HID protocol and configurator behavior.

## Verified configuration

- Windows 11 25H2;
- keyboard hardware ID `VID_30FA&PID_2350`;
- configurator launch without the compatibility error;
- lighting color changes;
- key reassignment;
- INI profile saving;
- safe repeated installation;
- complete restoration of the original EXE;
- automated integrity checks in both patched and restored states.

Other Windows versions and hardware revisions are not yet confirmed.

## Requirements

Install the official SVEN KB-G9400 configurator first. The expected default directory is:

```text
C:\Program Files (x86)\KB-G9400 Gaming Keyboard
```

This repository does not contain the original SVEN EXE, MSI package, archives, or proprietary resources.

## Install

Open PowerShell as Administrator in the repository directory:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\build\install.ps1
.\build\test.ps1
```

A successful check ends with:

```text
RESULT: PASS
```

## Restore the original software

```powershell
.\build\restore.ps1
.\build\test.ps1
```

The restore operation verifies the original file by SHA-256.

## Safety model

The patcher:

- checks the expected original byte before modification;
- creates and verifies a backup;
- writes through a temporary file;
- verifies the patched result;
- records SHA-256 values in `state.json`;
- writes a diagnostic log;
- refuses unknown EXE versions instead of patching them blindly.

## Documentation

- [`docs/USER_GUIDE_RU.md`](docs/USER_GUIDE_RU.md) — Russian user guide;
- [`docs/TESTING.md`](docs/TESTING.md) — release test checklist;
- [`docs/TECHNICAL.md`](docs/TECHNICAL.md) — technical explanation;
- [`docs/CHAT_HISTORY.md`](docs/CHAT_HISTORY.md) — accepted project decisions.

## Version 2.x direction

Features that are not present in the vendor software are reserved for version 2.x.

Localization cannot be implemented as a conventional plug-in because the original configurator has no language-extension interface. Version 2.x may therefore use one of two controlled approaches:

1. reproducible resource patching of a verified original EXE; or
2. a separate loader/component that checks the installed environment and activates only compatible extensions.

The project will not distribute modified SVEN binaries. It will distribute only its own patching tools, metadata, checks, and independently created resources.

## Credits

- Project initiation, requirements, and real-device testing: **point111**.
- Analysis, implementation, localization research, and documentation: **ChatGPT (OpenAI)** under point111's direction and verification.

ChatGPT was used as a development tool and is not the owner or official publisher of this project.

## Legal status

This is an independent community project and is not affiliated with or endorsed by SVEN. Product names and trademarks belong to their respective owners.