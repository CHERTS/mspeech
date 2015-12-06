{ #################################################################################### }
{ #                                                                                  # }
{ #  MGSoft Nuance TTS Demo v1.0.0 - Демонстрация синтез голоса через Nuance TTS     # }
{ #                                                                                  # }
{ #  License: GPLv3                                                                  # }
{ #                                                                                  # }
{ #  MGSoft NuanceTTS Demo                                                           # }
{ #                                                                                  # }
{ #  Author: Mikhail Grigorev (icq: 161867489, email: sleuthhound@gmail.com)         # }
{ #                                                                                  # }
{ #################################################################################### }

unit GlobalNuanceTTS;

interface

uses
  Windows, SysUtils, IniFiles, SHFolder;

const
  ProgramsVer: WideString = '1.0.0.0';
  ProgramsName = 'MGSoft Nuance TTS Demo';
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
  // Синтез голоса
  NuanceTL: String = 'Ava';
  NuanceAF: String = 'wav';
  NuanceFreq: Integer = 8000;

procedure LoadINI(INIPath: String);
procedure SaveINI(INIPath: String);
function GetSpecialFolderPath(FolderType: Integer) : WideString;

implementation

// Загружаем настройки
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
      NuanceTL := INI.ReadString('TextToSpeech', 'NuanceTL', 'Ava');
      NuanceAF := INI.ReadString('TextToSpeech', 'NuanceAF', 'wav');
      NuanceFreq := INI.ReadInteger('TextToSpeech', 'NuanceFreq', 8000);
    end
    else
    begin
      INI.WriteString('TextToSpeech', 'NuanceTL', NuanceTL);
      INI.WriteString('TextToSpeech', 'NuanceAF', NuanceAF);
      INI.WriteInteger('TextToSpeech', 'NuanceFreq', NuanceFreq);
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
    INI.WriteString('TextToSpeech', 'NuanceTL', NuanceTL);
    INI.WriteString('TextToSpeech', 'NuanceAF', NuanceAF);
    INI.WriteInteger('TextToSpeech', 'NuanceFreq', NuanceFreq);
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
