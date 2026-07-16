# Changelog

All notable project changes are documented in this file.

The project follows Semantic Versioning.

## [Unreleased]

### Planned

- version 2.x extensions beyond the capabilities of the vendor software;
- reproducible localization resource workflow;
- support for additional hardware revisions after real-device verification.

## [1.0.0] - 2026-07-16

### Added

- Windows 11 compatibility patch for the official SVEN KB-G9400 configurator;
- automatic backup and complete restoration of the original EXE;
- SHA-256 verification of backup, patched, and restored states;
- atomic patched-EXE replacement through a temporary file;
- diagnostic log and `state.json`;
- convenient entry points: `build/install.ps1`, `build/restore.ps1`, and `build/test.ps1`;
- technical, testing, workflow, and user documentation;
- verified Russian terminology catalogue for future localization research.

### Changed

- the patcher refuses unknown EXE versions instead of applying an unchecked offset;
- repeated installation leaves an already patched EXE unchanged;
- the verification script distinguishes the actual installed EXE hash from hashes stored in `state.json`.

### Verified

- Windows 11 25H2;
- hardware ID `VID_30FA / PID_2350`;
- configurator launch without `Product and driver are inconsistent`;
- lighting color changes;
- key reassignment;
- INI profile saving;
- repeated installation;
- restoration of the original EXE;
- automated checks in patched and restored states with `RESULT: PASS`.

### Scope

Version 1.0.0 is only a Windows 11 compatibility patch. It does not add features absent from the official software and does not provide a localized user interface.

### Known limitations

- other Windows versions and hardware revisions are not confirmed;
- the official SVEN configurator must be installed separately;
- no original or modified SVEN binaries are distributed;
- localization work is reserved for version 2.x.