# Roadmap

## Version 1.x — Windows 11 compatibility

Version 1.x is limited to compatibility and maintenance of the official SVEN KB-G9400 configurator.

### v1.0.0

- Windows 11 compatibility patch;
- safe installation and repeated installation;
- verified backup and restoration of the original EXE;
- diagnostic log and automated integrity test;
- English public README and Russian supplementary documentation;
- verified on Windows 11 25H2 and `VID_30FA&PID_2350`.

### Possible 1.x maintenance

- compatibility fixes for confirmed vendor-software revisions;
- clearer diagnostics and documentation;
- support for additional hardware revisions only after real-device verification.

Version 1.x will not add features absent from the vendor software.

## Version 2.x — Community extensions

Version 2.x is reserved for capabilities beyond the original configurator.

### Localization architecture research

The original EXE has no language plug-in interface. Localization therefore requires a controlled, version-aware mechanism:

- reproducible resource patching of a verified original EXE; or
- a separate loader/component that checks the environment and activates only compatible resources or extensions.

The repository must not distribute original or pre-modified SVEN binaries.

### Candidate features

- Russian and additional interface languages;
- language selection and safe resource rollback;
- lighting profile changes based on the active Windows input language;
- profile backup, import, and export;
- diagnostic HID logging;
- optional independent utilities or services.

### Safety requirements

- identify the exact installed software version before applying an extension;
- apply only extensions compatible with that version and environment;
- preserve backups and provide complete rollback;
- keep independent extensions separate where EXE modification is unnecessary;
- require real-device testing for HID-related changes.