{ ################################################################################## }
{ #                                                                                # }
{ #  MGSoft Google TTS Demo v1.0.0 - Демонстрация синтез голоса через Google TTS   # }
{ #                                                                                # }
{ #  License: GPLv3                                                                # }
{ #                                                                                # }
{ #  MGSoft GTTS Demo                                                              # }
{ #                                                                                # }
{ #  Author: Mikhail Grigorev (icq: 161867489, email: sleuthhound@gmail.com)       # }
{ #                                                                                # }
{ ################################################################################## }

unit GlobalGTTS;

interface

uses
  Windows, SysUtils, IniFiles, SHFolder;

const
  ProgramsVer: WideString = '1.0.0.0';
  ProgramsName = 'MGSoft Google TTS Demo';
  ProgramsFolder = 'MGSoft';
  {$IFDEF WIN32}
  PlatformType = 'x86';
  {$ELSE}
  PlatformType = 'x64';
  {$ENDIF}
  ININame = 'MGSoft.ini';

var
  ProgramsPath: WideString;
  WorkPath: WideString;
  // РЎРёРЅС‚РµР· РіРѕР»РѕСЃР°
  GoogleTL: String = 'ru';

procedure LoadINI(INIPath: String);
procedure SaveINI(INIPath: String);
function GetSpecialFolderPath(FolderType: Integer) : WideString;

implementation

// Р—Р°РіСЂСѓР¶Р°РµРј РЅР°СЃС‚СЂРѕР№РєРё
procedure LoadINI(INIPath: String);
var
  Path: WideString;
  INI: TIniFile;
begin
  Path := INIPath + ININame;
  INI := TIniFile.Create(Path);
  try
    if FileExists(Path) then
    begin
      GoogleTL := INI.ReadString('TextToSpeech', 'GoogleTL', 'ru');
    end
    else
    begin
      INI.WriteString('TextToSpeech', 'GoogleTL', GoogleTL);
    end;
    INI.Free;
  except
    on e: Exception do
    begin
      INI.Free;
      Exit;
    end;
  end;
end;

procedure SaveINI(INIPath: String);
var
  Path: WideString;
  INI: TIniFile;
begin
  Path := INIPath + ININame;
  INI := TIniFile.Create(Path);
  try
    INI.WriteString('TextToSpeech', 'GoogleTL', GoogleTL);
  finally
    INI.Free;
  end;
end;

function GetSpecialFolderPath(FolderType: Integer) : WideString;
const
  SHGFP_TYPE_CURRENT = 0;
var
  Path: Array [0..MAX_PATH] of Char;
begin
  if SUCCEEDED(SHGetFolderPath(0, FolderType, 0, SHGFP_TYPE_CURRENT, @Path[0])) then
    Result := Path
  else
    Result := ProgramsPath;
end;

begin
end.
