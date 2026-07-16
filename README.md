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

This repository and its installer do not contain the original SVEN EXE, MSI package, archives, or proprietary resources.

## Install for end users

Download and run:

```text
SVEN-KB-G9400-Community-Patch-1.0.0-Setup.exe
```

Approve the Windows UAC prompt and complete the setup wizard. The installer checks the official configurator, applies the compatibility patch, and verifies the result automatically.

The first release is unsigned, so Windows SmartScreen may show an unknown-publisher warning. Verify the installer against the SHA-256 published with the GitHub Release.

## Uninstall

Open **Windows Settings → Apps → Installed apps**, find **SVEN KB-G9400 Community Patch**, and choose **Uninstall**.

The uninstaller restores and verifies the original SVEN EXE before removing the Community Patch tools.

## Manual developer workflow

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

Restore manually with:

```powershell
.\build\restore.ps1
.\build\test.ps1
```

## Build the installer

Install Inno Setup 6, then run:

```powershell
.\build\Build-Installer.ps1
```

The generated installer and `SHA256SUMS.txt` are written to `dist/`. See [`docs/INSTALLER.md`](docs/INSTALLER.md).

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

- [`docs/INSTALLER.md`](docs/INSTALLER.md) — graphical installer build and test guide;
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
