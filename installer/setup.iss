#define MyAppName "SVEN KB-G9400 Community Patch"
#define MyAppVersion "1.0.0"
#define MyAppPublisher "point111 community project"
#define MyAppURL "https://github.com/point111/sven-kb-g9400-community-edition"

[Setup]
AppId={{1C4B66A7-7C47-49C6-AF88-9400CE100001}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}/issues
AppUpdatesURL={#MyAppURL}/releases
DefaultDirName={autopf}\SVEN KB-G9400 Community Patch
DisableProgramGroupPage=yes
PrivilegesRequired=admin
ArchitecturesAllowed=x86compatible x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
OutputDir=..\dist
OutputBaseFilename=SVEN-KB-G9400-Community-Patch-1.0.0-Setup
Compression=lzma2/ultra64
SolidCompression=yes
WizardStyle=modern
UninstallDisplayName={#MyAppName}
Uninstallable=yes
CreateUninstallRegKey=yes
SetupLogging=yes
RestartIfNeededByRun=no
CloseApplications=no

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Files]
Source: "..\scripts\Common.ps1"; DestDir: "{app}\scripts"; Flags: ignoreversion
Source: "..\scripts\Install-CommunityPatch.ps1"; DestDir: "{app}\scripts"; Flags: ignoreversion
Source: "..\scripts\Restore-Original.ps1"; DestDir: "{app}\scripts"; Flags: ignoreversion
Source: "..\build\install.ps1"; DestDir: "{app}\build"; Flags: ignoreversion
Source: "..\build\restore.ps1"; DestDir: "{app}\build"; Flags: ignoreversion
Source: "..\build\test.ps1"; DestDir: "{app}\build"; Flags: ignoreversion
Source: "..\README.md"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\README.ru.md"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\LICENSE"; DestDir: "{app}"; Flags: ignoreversion skipifsourcedoesntexist

[Icons]
Name: "{autoprograms}\SVEN KB-G9400 Community Patch\Verify installation"; Filename: "powershell.exe"; Parameters: "-NoProfile -ExecutionPolicy Bypass -File ""{app}\build\test.ps1"""; WorkingDir: "{app}"; IconFilename: "powershell.exe"
Name: "{autoprograms}\SVEN KB-G9400 Community Patch\Restore original software"; Filename: "powershell.exe"; Parameters: "-NoProfile -ExecutionPolicy Bypass -File ""{app}\build\restore.ps1"""; WorkingDir: "{app}"; IconFilename: "powershell.exe"

[Code]
const
  VendorExe = 'C:\Program Files (x86)\KB-G9400 Gaming Keyboard\KB-G9400 Gaming Keyboard.exe';

function VendorConfiguratorExists: Boolean;
begin
  Result := FileExists(VendorExe);
end;

function RunPowerShellScript(const ScriptPath: String; var ResultCode: Integer): Boolean;
begin
  Result := Exec(
    'powershell.exe',
    '-NoProfile -ExecutionPolicy Bypass -File "' + ScriptPath + '"',
    ExpandConstant('{app}'),
    SW_HIDE,
    ewWaitUntilTerminated,
    ResultCode
  );
end;

function InitializeSetup(): Boolean;
begin
  Result := VendorConfiguratorExists;
  if not Result then
    MsgBox(
      'The official SVEN KB-G9400 configurator was not found.' + #13#10 + #13#10 +
      'Install the official SVEN software first, then run this setup again.' + #13#10 + #13#10 +
      'Expected file:' + #13#10 + VendorExe,
      mbError,
      MB_OK
    );
end;

procedure CurStepChanged(CurStep: TSetupStep);
var
  ResultCode: Integer;
begin
  if CurStep = ssPostInstall then
  begin
    WizardForm.StatusLabel.Caption := 'Applying the Windows 11 compatibility patch...';
    if not RunPowerShellScript(ExpandConstant('{app}\build\install.ps1'), ResultCode) or
       (ResultCode <> 0) then
    begin
      MsgBox(
        'The compatibility patch could not be installed.' + #13#10 +
        'No unknown EXE version was modified. Review the setup and patch logs for details.',
        mbError,
        MB_OK
      );
      RaiseException('Patch installation failed.');
    end;

    WizardForm.StatusLabel.Caption := 'Verifying the installed patch...';
    if not RunPowerShellScript(ExpandConstant('{app}\build\test.ps1'), ResultCode) or
       (ResultCode <> 0) then
    begin
      RunPowerShellScript(ExpandConstant('{app}\build\restore.ps1'), ResultCode);
      MsgBox(
        'Verification failed. The installer attempted to restore the original configurator.' + #13#10 +
        'Review the setup and patch logs before trying again.',
        mbError,
        MB_OK
      );
      RaiseException('Patch verification failed.');
    end;
  end;
end;

procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
var
  ResultCode: Integer;
begin
  if CurUninstallStep = usUninstall then
  begin
    if not RunPowerShellScript(ExpandConstant('{app}\build\restore.ps1'), ResultCode) or
       (ResultCode <> 0) then
    begin
      MsgBox(
        'The original configurator could not be restored automatically.' + #13#10 +
        'Uninstallation has been stopped so the recovery tools remain available.',
        mbError,
        MB_OK
      );
      Abort;
    end;
  end;
end;
