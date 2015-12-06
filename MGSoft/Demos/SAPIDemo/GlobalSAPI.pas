{ ############################################################################### }
{ #                                                                             # }
{ #  MGSoft TTS Demo v1.0.0 - Демонстрация синтез голоса через Microsoft SAPI   # }
{ #                                                                             # }
{ #  License: GPLv3                                                             # }
{ #                                                                             # }
{ #  MGSoft TTS Demo                                                            # }
{ #                                                                             # }
{ #  Author: Mikhail Grigorev (icq: 161867489, email: sleuthhound@gmail.com)    # }
{ #                                                                             # }
{ ############################################################################### }

unit GlobalSAPI;

interface

uses
  Windows, SysUtils, IniFiles, SHFolder;

const
  ProgramsVer: WideString = '1.0.0.0';
  ProgramsName = 'MGSoft TTS Demo';
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
  SAPIVoiceNum: Integer = 0;
  SAPIVoiceVolume: Integer = 100;
  SAPIVoiceSpeed: Integer = 0;
  SAPIVoicePitch: Integer = 0;

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
      SAPIVoiceNum := INI.ReadInteger('TextToSpeech', 'SAPIVoiceNum', 0);
      SAPIVoiceVolume := INI.ReadInteger('TextToSpeech', 'SAPIVoiceVolume', 100);
      SAPIVoiceSpeed := INI.ReadInteger('TextToSpeech', 'SAPIVoiceSpeed', 0);
      SAPIVoicePitch := INI.ReadInteger('TextToSpeech', 'SAPIVoicePitch', 0);
    end
    else
    begin
      INI.WriteInteger('TextToSpeech', 'SAPIVoiceNum', SAPIVoiceNum);
      INI.WriteInteger('TextToSpeech', 'SAPIVoiceVolume', SAPIVoiceVolume);
      INI.WriteInteger('TextToSpeech', 'SAPIVoiceSpeed', SAPIVoiceSpeed);
      INI.WriteInteger('TextToSpeech', 'SAPIVoicePitch', SAPIVoicePitch);
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
    INI.WriteInteger('TextToSpeech', 'SAPIVoiceNum', SAPIVoiceNum);
    INI.WriteInteger('TextToSpeech', 'SAPIVoiceVolume', SAPIVoiceVolume);
    INI.WriteInteger('TextToSpeech', 'SAPIVoiceSpeed', SAPIVoiceSpeed);
    INI.WriteInteger('TextToSpeech', 'SAPIVoicePitch', SAPIVoicePitch);
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
