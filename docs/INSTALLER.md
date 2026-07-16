# Windows GUI installer

The release installer is built with Inno Setup 6 and does not contain any original or modified SVEN binary.

## User workflow

1. Install the official SVEN KB-G9400 configurator.
2. Run `SVEN-KB-G9400-Community-Patch-1.0.0-Setup.exe`.
3. Approve the Windows UAC prompt.
4. Complete the setup wizard.

The installer copies only the Community Patch scripts, applies the compatibility patch, and verifies the installed state. An unknown vendor EXE is rejected without modification.

To remove the patch, open **Installed apps** in Windows and uninstall **SVEN KB-G9400 Community Patch**. The uninstaller restores and verifies the original EXE before deleting the Community Patch tools.

## Build requirements

- Windows;
- Inno Setup 6;
- PowerShell 5.1 or newer.

## Build

From the repository root:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\build\Build-Installer.ps1
```

Artifacts are created in `dist/`:

```text
SVEN-KB-G9400-Community-Patch-1.0.0-Setup.exe
SHA256SUMS.txt
```

## Release test

Test on a machine with the official configurator installed:

1. start from the original EXE;
2. install through the setup wizard;
3. confirm the configurator launches and keyboard functions work;
4. run the installed **Verify installation** shortcut and confirm `RESULT: PASS`;
5. uninstall through Windows Installed apps;
6. confirm the original EXE is restored;
7. optionally run `build/test.ps1` from the repository and confirm the original state passes.

## Unsigned build

The installer is intentionally unsigned for the first release. Windows SmartScreen may display an unknown-publisher warning. Release notes must publish the SHA-256 from `dist/SHA256SUMS.txt` so users can verify the downloaded file.
