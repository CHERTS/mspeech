{ ############################################################################ }
{ #                                                                          # }
{ #  MSpeech v1.4 - Распознавание речи используя Google Speech API           # }
{ #                                                                          # }
{ #  License: GPLv3                                                          # }
{ #                                                                          # }
{ #  Author: Mikhail Grigorev (icq: 161867489, email: sleuthhound@gmail.com) # }
{ #                                                                          # }
{ ############################################################################ }

unit Global;

interface

{$I MSpeech.inc}

uses
  Windows, SysUtils, IniFiles, Messages, XMLIntf, XMLDoc, Classes, Vcl.Grids,
  Types, TLHELP32, SHFolder;

type
  TWinVersion = (wvUnknown,wv95,wv98,wvME,wvNT3,wvNT4,wvW2K,wvXP,wv2003,wvVista,wv7,wv2008,wv8);
  TMethodSendingText = (mWM_SETTEXT, mWM_PASTE, mWM_CHAR, mWM_PASTE_MOD);
  TCommandType = (mExecPrograms, mClosePrograms, mKillPrograms, mTextToSpeech);
  TCopyDataType = (cdtString = 0, cdtImage = 1, cdtRecord = 2);
  TEventsType = (mWarningRecognize, mRecordingNotRecognized, mCommandNotFound, mErrorGoogleCommunication);
  TEventsTypeStatus = (mDisable, mEnable);

const
  ProgramsVer : WideString = '1.5.1.0';
  ProgramsName = 'MSpeech';
  {$IFDEF WIN32}
  PlatformType = 'x86';
  {$ELSE}
  PlatformType = 'x64';
  {$ENDIF}
  ININame = 'MSpeech.ini';
  INIFormsName = 'MSpeechForms.ini';
  // Отладка
  DebugLogName = 'mspeech.log';
  // Сообщения окнам
  WM_MSGBOX = WM_USER + 2;
  WM_UPDATELOG = WM_USER + 3;
  WM_STARTSAVESETTINGS = WM_USER + 4;
  WM_SAVESETTINGSDONE = WM_USER + 5;
  // Для мультиязыковой поддержки
  WM_LANGUAGECHANGED = WM_USER + 1;
  dirLangs = 'langs\';
  defaultLangFile = 'English.xml';
  MaxCaptionSize: Integer = 255;
  // Описание типов команд
  CommandStr: Array[TCommandType] of String = (
    'ExecProgramsCommandDesc',
    'CloseProgramsCommandDesc',
    'KillProgramsCommandDesc',
    'TextToSpeechCommandDesc');
  // Описание типов событий в программе
  EventsTypeStr: Array[TEventsType] of String = (
    'EventWarningRecognize',
    'EventRecordingNotRecognized',
    'EventCommandNotFound',
    'EventErrorGoogleCommunication');
  EventsTypeStatusStr: Array[TEventsTypeStatus] of String = (
    'EventDisable',
    'EventEnable');
  // Список регионов для распознавания голоса через Google
  RegionArray: Array[0..62] of String = (
    'af-ZA', 'id-ID', 'ms-MY', 'ca-ES', 'cs-CZ', 'de-DE', 'en-AU', 'en-CA', 'en-IN',
    'en-NZ', 'en-ZA', 'en-GB', 'en-US', 'es-AR', 'es-BO', 'es-CL', 'es-CO', 'es-CR',
    'es-EC', 'es-SV', 'es-ES', 'es-US', 'es-GT', 'es-HN', 'es-MX', 'es-NI', 'es-PA',
    'es-PY', 'es-PE', 'es-PR', 'es-DO', 'es-UY', 'es-VE', 'eu-ES', 'fr-FR', 'gl-ES',
    'he-HE', 'hr_HR', 'zu-ZA', 'is-IS', 'it-IT', 'it-CH', 'hu-HU', 'nl-NL', 'nb-NO',
    'pl-PL', 'pt-BR', 'pt-PT', 'ro-RO', 'sk-SK', 'fi-FI', 'sv-SE', 'tr-TR', 'bg-BG',
    'ru-RU', 'sr-RS', 'ko-KR', 'cmn-Hans-CN', 'cmn-Hans-HK', 'cmn-Hant-TW', 'yue-Hant-HK',
    'ja-JP', 'la');
  // Список регионов для синтеза голоса через Google
  TextToSpeechRegionArray: Array[0..1] of String = ('ru', 'en');

var
  ProgramsPath: WideString;
  OutFileName: String;
  WorkPath: WideString;
  OLDCommandFileName: String = 'MSpeechCommand.ini';
  ReplaceGridFile: String = 'MSpeech.rpl';
  CommandGridFile: String = 'MSpeech.cf';
  TextToSpeechGridFile: String = 'MSpeech.tts';
  // Отладка
  EnableLogs: Boolean = False;
  MaxDebugLogSize: Integer = 1000;
  TFDebugLog: TextFile;
  DebugLogOpened: Boolean = False;
  // Запись
  DefaultAudioDeviceNumber: Integer = 0;
  MaxLevelOnAutoRecord: Integer = 57;
  MaxLevelOnAutoRecordInterrupt: Integer = 4;
  MinLevelOnAutoRecognize: Integer = 71;
  MinLevelOnAutoRecognizeInterrupt: Integer = 15;
  MaxLevelOnAutoControl: Boolean = False;
  INIFileLoaded: Boolean = False;
  StartSaveSettings: Boolean = False;
  EnableExecCommand: Boolean = True;
  DefaultCommandExec: String = '';
  // Прокси
  UseProxy: Boolean = False;
  ProxyAuth: Boolean = False;
  ProxyAddress: String = '';
  ProxyPort: String = '';
  ProxyUser: String = '';
  ProxyUserPasswd: String = '';
  // Гор.клавиши
  GlobalHotKeyEnable: Boolean = False;
  StartRecordHotKey: String = 'Ctrl+Alt+F10';
  StartRecordWithoutSendTextHotKey: String = 'Ctrl+Alt+F11';
  StartRecordWithoutExecCommandHotKey: String = 'Ctrl+Alt+F12';
  SwitchesLanguageRecognizeHotKey: String = 'Ctrl+Alt+R';
  // Действие кнопки "Остановить запись"
  StopRecordAction: Integer = 0;
  // Всплывающие сообщения
  ShowTrayEvents: Boolean = False;
  // Передача текста в другие программы
  EnableSendText: Boolean = False;
  ClassNameReciver: String = 'Edit';
  MethodSendingText: Integer = 0;
  EnableSendTextInactiveWindow: Boolean = False;
  InactiveWindowCaption: String = 'MSpeech Reciver Demo';
  // Прозрачность окон
  AlphaBlendEnable: Boolean = False;
  AlphaBlendEnableValue: Integer = 255;
  // Для мультиязыковой поддержки
  CoreLanguage: String;
  MainFormHandle: HWND;
  AboutFormHandle: HWND;
  SettingsFormHandle: HWND;
  LogFormHandle: HWND;
  LangDoc: IXMLDocument;
  DefaultLanguage: String;
  // Коррекция текста при передаче
  EnableTextСorrection: Boolean = False;
  EnableTextReplace: Boolean = False;
  FirstLetterUpper: Boolean = False;
  // Язык распознавания по умолчанию
  CurrentSpeechRecognizeLang: String;
  DefaultSpeechRecognizeLang: String = 'ru-RU';
  SecondSpeechRecognizeLang: String = 'en-US';
  // PID процесса
  GlobalProcessPID: DWORD = 0;
  // Синтез голоса
  EnableTextToSpeech: Boolean = False;
  TextToSpeechEngine: Integer = 0;
  SAPIVoiceNum: Integer = 0;
  SAPIVoiceVolume: Integer = 100;
  SAPIVoiceSpeed: Integer = 0;
  GoogleTL: String = 'ru';
  // Фильтрация и VAD
  EnableFilters: Boolean = False;
  FilterType: Integer = 0; // 0 - WindowedSincFilter или 1 - VoiceFilter
  // 1 тип фильтра
  SincFilterType: Integer = 1;
  SincFilterLowFreq: Integer = 300;
  SincFilterHighFreq: Integer = 4000;
  SincFilterKernelWidth: Integer = 32;
  SincFilterWindowType: Integer = 0;
  // 2 Тип фильтра
  VoiceFilterEnableAGC: Boolean = False;
  VoiceFilterEnableNoiseReduction: Boolean = False;
  VoiceFilterEnableVAD: Boolean = True;

function BoolToStr(Bool: Boolean): String;
function BoolToInt(Bool: Boolean): Integer;
function IntToBool(Int: Integer): Boolean;
procedure LoadINI(INIPath: String);
procedure SaveINI(INIPath: String);
function DetectWinVersion : TWinVersion;
function DetectWinVersionStr : String;
function GetFileSize(FileName: String): Integer;
function MatchStrings(source, pattern: String): Boolean;
function ExtractFileNameEx(FileName: String; ShowExtension: Boolean): String;
procedure MakeTransp(winHWND: HWND);
procedure MsgDie(Caption, Msg: WideString);
procedure MsgInf(Caption, Msg: WideString);
function GetLangStr(StrID: String): WideString;
function GetSystemDefaultUILanguage: UINT; stdcall; external kernel32 name 'GetSystemDefaultUILanguage';
function GetSysLang: AnsiString;
procedure CoreLanguageChanged;
function Tok(Sep: String; var s: String): String;
function ReadCustomINI(INIPath, CustomSection, CustomParams, DefaultParamsStr: String): String; overload;
function ReadCustomINI(INIPath, CustomSection, CustomParams: String; DefaultParamsStr: Boolean): Boolean; overload;
function DetectMethodSendingText(Method: Integer): TMethodSendingText;
function DetectCommandType(CType: Integer): String; overload;
function DetectCommandType(CType: TCommandType): Integer; overload;
function DetectCommandTypeName(CType: TCommandType): String; overload;
function DetectCommandTypeName(CType: String): TCommandType; overload;
function DetectRegionStr(RegionID: Integer): String;
function DetectRegionID(RegionStr: String): Integer;
procedure SaveReplaceDataStringGrid(MyFile: String; FileGrid: TStringGrid);
procedure LoadReplaceDataStringGrid(MyFile: String; var FileGrid: TStringGrid);
procedure SaveCommandDataStringGrid(MyFile: String; FileGrid: TStringGrid);
procedure LoadCommandDataStringGrid(MyFile: String; var FileGrid: TStringGrid);
function IsNumber(const S: String): Boolean;
procedure LoadOLDCommandFileToGrid(MyFile: String; FileGrid: TStringGrid);
function RusLowercaseToUppercase(MyText: String): String;
function EngLowercaseToUppercase(MyText: String): String;
function GetMyExeVersion: String;
function OnSendMessage(WinName, Msg: String): Boolean;
function GetUserTempPath: WideString;
function EnumThreadWndProc(hwnd: HWND; lParam: LPARAM): BOOL; stdcall;
function GetThreadsOfProcess(APID: Cardinal): TIntegerDynArray;
function IsProcessRun(ProcessName: String): Boolean; overload;
function IsProcessRun(ProcessName, WinCaption: String): Boolean; overload;
function ProcCloseEnum(hwnd: THandle; data: Pointer):BOOL;stdcall;
function ProcQuitEnum(hwnd: THandle; data: Pointer):BOOL;stdcall;
procedure EndProcess(ProcessPID: DWord; EndType: Integer);
function GetProcessID(ExeFileName: String): Cardinal;
function KillTask(ExeFileName: String): Integer; overload;
function KillTask(ExeFileName, WinCaption: String): Integer; overload;
function GetMyFileSize(const Path: WideString): Integer;
function OpenLogFile(LogPath: WideString): Boolean;
procedure CloseLogFile;
procedure WriteInLog(LogPath: WideString; TextString: String);
function DetectTextToSpeechRegionStr(RegionID: Integer): String;
function DetectTextToSpeechRegionID(RegionStr: String): Integer;
function DetectEventsType(CType: Integer): String; overload;
function DetectEventsType(CType: TEventsType): Integer; overload;
function DetectEventsTypeName(CType: TEventsType): String; overload;
function DetectEventsTypeName(CType: String): TEventsType; overload;
function DetectEventsTypeStatus(CType: Integer): String; overload;
function DetectEventsTypeStatus(CType: TEventsTypeStatus): Integer; overload;
function DetectEventsTypeStatusName(CType: TEventsTypeStatus): String; overload;
function DetectEventsTypeStatusName(CType: String): TEventsTypeStatus; overload;
procedure LoadTextToSpeechDataStringGrid(MyFile: String; var FileGrid: TStringGrid);
procedure SaveTextToSpeechDataStringGrid(MyFile: String; FileGrid: TStringGrid);
function GetSpecialFolderPath(FolderType: Integer) : WideString;

implementation

function BoolToStr(Bool: Boolean): String;
begin
  if Bool then
    Result := '1'
  else
    Result := '0';
end;

function BoolToInt(Bool: Boolean): Integer;
begin
  if Bool then
    Result := 1
  else
    Result := 0;
end;

function IntToBool(Int: Integer): Boolean;
begin
  if Int = 0 then
    Result := False
  else
    Result := True;
end;

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
      EnableLogs := INI.ReadBool('Main', 'EnableLogs', False);
      MaxDebugLogSize := INI.ReadInteger('Main', 'MaxDebugLogSize', 1000);
      DefaultLanguage := INI.ReadString('Main', 'DefaultLanguage', 'Russian');
      DefaultSpeechRecognizeLang := INI.ReadString('Main', 'DefaultSpeechRecognizeLang', 'ru-RU');
      SecondSpeechRecognizeLang := INI.ReadString('Main', 'SecondSpeechRecognizeLang', 'en-US');
      AlphaBlendEnable := INI.ReadBool('Main', 'AlphaBlendEnable', False);
      AlphaBlendEnableValue := INI.ReadInteger('Main', 'AlphaBlendEnableValue', 255);
      DefaultAudioDeviceNumber := INI.ReadInteger('Main', 'DefaultAudioDeviceNumber', 0);
      MaxLevelOnAutoControl := INI.ReadBool('Main', 'MaxLevelOnAutoControl', False);
      MaxLevelOnAutoRecord := INI.ReadInteger('Main', 'MaxLevelOnAutoRecord', 50);
      MaxLevelOnAutoRecordInterrupt := INI.ReadInteger('Main', 'MaxLevelOnAutoRecordInterrupt', 10);
      MinLevelOnAutoRecognize := INI.ReadInteger('Main', 'MinLevelOnAutoRecognize', 70);
      MinLevelOnAutoRecognizeInterrupt := INI.ReadInteger('Main', 'MinLevelOnAutoRecognizeInterrupt', 30);
      EnableFilters := INI.ReadBool('Main', 'EnableFilters', False);
      FilterType := INI.ReadInteger('Main', 'FilterType', 0);
      SincFilterType := INI.ReadInteger('Main', 'SincFilterType', 1);
      SincFilterLowFreq := INI.ReadInteger('Main', 'SincFilterLowFreq', 300);
      SincFilterHighFreq := INI.ReadInteger('Main', 'SincFilterHighFreq', 4000);
      SincFilterKernelWidth := INI.ReadInteger('Main', 'SincFilterKernelWidth', 32);
      SincFilterWindowType := INI.ReadInteger('Main', 'SincFilterWindowType', 0);
      VoiceFilterEnableAGC := INI.ReadBool('Main', 'VoiceFilterEnableAGC', False);
      VoiceFilterEnableNoiseReduction := INI.ReadBool('Main', 'VoiceFilterEnableNoiseReduction', False);
      VoiceFilterEnableVAD := INI.ReadBool('Main', 'VoiceFilterEnableVAD', False);
      StopRecordAction := INI.ReadInteger('Main', 'StopRecordAction', 0);
      ShowTrayEvents := INI.ReadBool('Main', 'ShowTrayEvents', False);
      EnableExecCommand := INI.ReadBool('Main', 'EnableExecCommand', True);
      DefaultCommandExec := INI.ReadString('Main', 'DefaultCommandExec', '');
      EnableSendText := INI.ReadBool('SendText', 'EnableSendText', False);
      EnableSendTextInactiveWindow := INI.ReadBool('SendText', 'EnableSendTextInactiveWindow', False);
      ClassNameReciver := INI.ReadString('SendText', 'ClassNameReciver', 'Edit');
      MethodSendingText := INI.ReadInteger('SendText', 'MethodSendingText', 0);
      InactiveWindowCaption := INI.ReadString('SendText', 'InactiveWindowCaption', '*Блокнот');
      EnableTextСorrection := INI.ReadBool('SendText', 'EnableTextСorrection', False);
      EnableTextReplace := INI.ReadBool('SendText', 'EnableTextReplace', False);
      FirstLetterUpper := INI.ReadBool('SendText', 'FirstLetterUpper', False);
      UseProxy := INI.ReadBool('Proxy', 'UseProxy', False);
      ProxyAddress := INI.ReadString('Proxy', 'ProxyServer', '');
      ProxyPort := INI.ReadString('Proxy', 'ProxyPort', '');
      ProxyAuth := INI.ReadBool('Proxy', 'ProxyAuth', False);
      ProxyUser := INI.ReadString('Proxy', 'ProxyUser', '');
      ProxyUserPasswd := INI.ReadString('Proxy', 'ProxyPassword', '');
      GlobalHotKeyEnable := INI.ReadBool('HotKey', 'HotKeyEnable', False);
      StartRecordHotKey := INI.ReadString('HotKey', 'StartRecordHotKey', 'Ctrl+Alt+F10');
      StartRecordWithoutSendTextHotKey := INI.ReadString('HotKey', 'StartRecordWithoutSendText', 'Ctrl+Alt+F11');
      StartRecordWithoutExecCommandHotKey := INI.ReadString('HotKey', 'StartRecordWithoutExecCommand', 'Ctrl+Alt+F12');
      SwitchesLanguageRecognizeHotKey := INI.ReadString('HotKey', 'SwitchesLanguageRecognizeHotKey', 'Ctrl+Alt+R');
      EnableTextToSpeech := INI.ReadBool('TextToSpeech', 'EnableTextToSpeech', False);
      TextToSpeechEngine := INI.ReadInteger('TextToSpeech', 'TextToSpeechEngine', 0);
      SAPIVoiceNum := INI.ReadInteger('TextToSpeech', 'SAPIVoiceNum', 0);
      SAPIVoiceVolume := INI.ReadInteger('TextToSpeech', 'SAPIVoiceVolume', 100);
      SAPIVoiceSpeed := INI.ReadInteger('TextToSpeech', 'SAPIVoiceSpeed', 0);
      GoogleTL := INI.ReadString('TextToSpeech', 'GoogleTL', 'ru');
      INIFileLoaded := True;
    end
    else
    begin
      INI.WriteBool('Main', 'EnableLogs', EnableLogs);
      INI.WriteInteger('Main', 'MaxDebugLogSize', MaxDebugLogSize);
      INI.WriteString('Main', 'DefaultSpeechRecognizeLang', DefaultSpeechRecognizeLang);
      INI.WriteString('Main', 'SecondSpeechRecognizeLang', SecondSpeechRecognizeLang);
      INI.WriteBool('Main', 'AlphaBlendEnable', AlphaBlendEnable);
      INI.WriteInteger('Main', 'AlphaBlendEnableValue', AlphaBlendEnableValue);
      INI.WriteInteger('Main', 'DefaultAudioDeviceNumber', DefaultAudioDeviceNumber);
      INI.WriteBool('Main', 'MaxLevelOnAutoControl', MaxLevelOnAutoControl);
      INI.WriteInteger('Main', 'MaxLevelOnAutoRecord', MaxLevelOnAutoRecord);
      INI.WriteInteger('Main', 'MaxLevelOnAutoRecordInterrupt', MaxLevelOnAutoRecordInterrupt);
      INI.WriteInteger('Main', 'MinLevelOnAutoRecognize', MinLevelOnAutoRecognize);
      INI.WriteInteger('Main', 'MinLevelOnAutoRecognizeInterrupt', MinLevelOnAutoRecognizeInterrupt);
      INI.WriteInteger('Main', 'StopRecordAction', 0);
      INI.WriteBool('Main', 'ShowTrayEvents', False);
      INI.WriteBool('Main', 'EnableExecCommand', EnableExecCommand);
      INI.WriteString('Main', 'DefaultCommandExec', DefaultCommandExec);
      INI.WriteBool('Main', 'EnableFilters', EnableFilters);
      INI.WriteInteger('Main', 'FilterType', FilterType);
      INI.WriteInteger('Main', 'SincFilterType', SincFilterType);
      INI.WriteInteger('Main', 'SincFilterLowFreq', SincFilterLowFreq);
      INI.WriteInteger('Main', 'SincFilterHighFreq', SincFilterHighFreq);
      INI.WriteInteger('Main', 'SincFilterKernelWidth', SincFilterKernelWidth);
      INI.WriteInteger('Main', 'SincFilterWindowType', SincFilterWindowType);
      INI.WriteBool('Main', 'VoiceFilterEnableAGC', VoiceFilterEnableAGC);
      INI.WriteBool('Main', 'VoiceFilterEnableNoiseReduction', VoiceFilterEnableNoiseReduction);
      INI.WriteBool('Main', 'VoiceFilterEnableVAD', VoiceFilterEnableVAD);
      INI.WriteBool('SendText', 'EnableSendText', EnableSendText);
      INI.WriteBool('SendText', 'EnableSendTextInactiveWindow', EnableSendTextInactiveWindow);
      INI.WriteString('SendText', 'ClassNameReciver', ClassNameReciver);
      INI.WriteInteger('SendText', 'MethodSendingText', MethodSendingText);
      INI.WriteString('SendText', 'InactiveWindowCaption', InactiveWindowCaption);
      INI.WriteBool('SendText', 'EnableTextСorrection', EnableTextСorrection);
      INI.WriteBool('SendText', 'EnableTextReplace', EnableTextReplace);
      INI.WriteBool('SendText', 'FirstLetterUpper', FirstLetterUpper);
      INI.WriteBool('Proxy', 'UseProxy', False);
      INI.WriteString('Proxy', 'ProxyServer', '');
      INI.WriteString('Proxy', 'ProxyPort', '');
      INI.WriteBool('Proxy', 'ProxyAuth', False);
      INI.WriteString('Proxy', 'ProxyUser', '');
      INI.WriteString('Proxy', 'ProxyPassword', '');
      INI.WriteBool('HotKey', 'HotKeyEnable', False);
      INI.WriteString('HotKey', 'StartRecordHotKey', StartRecordHotKey);
      INI.WriteString('HotKey', 'StartRecordWithoutSendText', StartRecordWithoutSendTextHotKey);
      INI.WriteString('HotKey', 'StartRecordWithoutExecCommand', StartRecordWithoutExecCommandHotKey);
      INI.WriteString('HotKey', 'SwitchesLanguageRecognizeHotKey', SwitchesLanguageRecognizeHotKey);
      INI.WriteBool('TextToSpeech', 'EnableTextToSpeech', EnableTextToSpeech);
      INI.WriteInteger('TextToSpeech', 'TextToSpeechEngine', TextToSpeechEngine);
      INI.WriteInteger('TextToSpeech', 'SAPIVoiceNum', SAPIVoiceNum);
      INI.WriteInteger('TextToSpeech', 'SAPIVoiceVolume', SAPIVoiceVolume);
      INI.WriteInteger('TextToSpeech', 'SAPIVoiceSpeed', SAPIVoiceSpeed);
      INI.WriteString('TextToSpeech', 'GoogleTL', GoogleTL);
      INIFileLoaded := False;
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

procedure SaveINI;
var
  Path: WideString;
  INI: TIniFile;
begin
  Path := INIPath + ININame;
  INI := TIniFile.Create(Path);
  try
    INI.WriteBool('Main', 'EnableLogs', EnableLogs);
    INI.WriteInteger('Main', 'MaxDebugLogSize', MaxDebugLogSize);
    INI.WriteString('Main', 'DefaultSpeechRecognizeLang', DefaultSpeechRecognizeLang);
    INI.WriteString('Main', 'SecondSpeechRecognizeLang', SecondSpeechRecognizeLang);
    INI.WriteString('Main', 'DefaultLanguage', DefaultLanguage);
    INI.WriteBool('Main', 'AlphaBlendEnable', AlphaBlendEnable);
    INI.WriteInteger('Main', 'AlphaBlendEnableValue', AlphaBlendEnableValue);
    INI.WriteInteger('Main', 'DefaultAudioDeviceNumber', DefaultAudioDeviceNumber);
    INI.WriteBool('Main', 'MaxLevelOnAutoControl', MaxLevelOnAutoControl);
    INI.WriteInteger('Main', 'MaxLevelOnAutoRecord', MaxLevelOnAutoRecord);
    INI.WriteInteger('Main', 'MaxLevelOnAutoRecordInterrupt', MaxLevelOnAutoRecordInterrupt);
    INI.WriteInteger('Main', 'MinLevelOnAutoRecognize', MinLevelOnAutoRecognize);
    INI.WriteInteger('Main', 'MinLevelOnAutoRecognizeInterrupt', MinLevelOnAutoRecognizeInterrupt);
    INI.WriteInteger('Main', 'StopRecordAction', StopRecordAction);
    INI.WriteBool('Main', 'ShowTrayEvents', ShowTrayEvents);
    INI.WriteBool('Main', 'EnableExecCommand', EnableExecCommand);
    INI.WriteString('Main', 'DefaultCommandExec', DefaultCommandExec);
    INI.WriteBool('Main', 'EnableFilters', EnableFilters);
    INI.WriteInteger('Main', 'FilterType', FilterType);
    INI.WriteInteger('Main', 'SincFilterType', SincFilterType);
    INI.WriteInteger('Main', 'SincFilterLowFreq', SincFilterLowFreq);
    INI.WriteInteger('Main', 'SincFilterHighFreq', SincFilterHighFreq);
    INI.WriteInteger('Main', 'SincFilterKernelWidth', SincFilterKernelWidth);
    INI.WriteInteger('Main', 'SincFilterWindowType', SincFilterWindowType);
    INI.WriteBool('Main', 'VoiceFilterEnableAGC', VoiceFilterEnableAGC);
    INI.WriteBool('Main', 'VoiceFilterEnableNoiseReduction', VoiceFilterEnableNoiseReduction);
    INI.WriteBool('Main', 'VoiceFilterEnableVAD', VoiceFilterEnableVAD);
    INI.WriteBool('SendText', 'EnableSendText', EnableSendText);
    INI.WriteBool('SendText', 'EnableSendTextInactiveWindow', EnableSendTextInactiveWindow);
    INI.WriteString('SendText', 'ClassNameReciver', ClassNameReciver);
    INI.WriteInteger('SendText', 'MethodSendingText', MethodSendingText);
    INI.WriteString('SendText', 'InactiveWindowCaption', InactiveWindowCaption);
    INI.WriteBool('SendText', 'EnableTextСorrection', EnableTextСorrection);
    INI.WriteBool('SendText', 'EnableTextReplace', EnableTextReplace);
    INI.WriteBool('SendText', 'FirstLetterUpper', FirstLetterUpper);
    INI.WriteBool('Proxy', 'UseProxy', UseProxy);
    INI.WriteString('Proxy', 'ProxyServer', ProxyAddress);
    INI.WriteString('Proxy', 'ProxyPort', ProxyPort);
    INI.WriteBool('Proxy', 'ProxyAuth', ProxyAuth);
    INI.WriteString('Proxy', 'ProxyUser', ProxyUser);
    INI.WriteString('Proxy', 'ProxyUserPasswd', ProxyUserPasswd);
    INI.WriteBool('HotKey', 'HotKeyEnable', GlobalHotKeyEnable);
    INI.WriteString('HotKey', 'StartRecordHotKey', StartRecordHotKey);
    INI.WriteString('HotKey', 'StartRecordWithoutSendText', StartRecordWithoutSendTextHotKey);
    INI.WriteString('HotKey', 'StartRecordWithoutExecCommand', StartRecordWithoutExecCommandHotKey);
    INI.WriteString('HotKey', 'SwitchesLanguageRecognizeHotKey', SwitchesLanguageRecognizeHotKey);
    INI.WriteBool('TextToSpeech', 'EnableTextToSpeech', EnableTextToSpeech);
    INI.WriteInteger('TextToSpeech', 'TextToSpeechEngine', TextToSpeechEngine);
    INI.WriteInteger('TextToSpeech', 'SAPIVoiceNum', SAPIVoiceNum);
    INI.WriteInteger('TextToSpeech', 'SAPIVoiceVolume', SAPIVoiceVolume);
    INI.WriteInteger('TextToSpeech', 'SAPIVoiceSpeed', SAPIVoiceSpeed);
    INI.WriteString('TextToSpeech', 'GoogleTL', GoogleTL);
    MsgInf(ProgramsName, GetLangStr('MsgInf7'));
  finally
    INI.Free;
  end;
end;

{
DwMajorVersion:DWORD - старшая цифра версии Windows

   Windows 95      - 4
   Windows 98      - 4
   Windows Me      - 4
   Windows NT 3.51 - 3
   Windows NT 4.0  - 4
   Windows 2000    - 5
   Windows XP      - 5
   Windows 2008    - 6
   Windows 7       - 6
   Windows 8       - 7

DwMinorVersion: DWORD - младшая цифра версии

   Windows 95      - 0
   Windows 98      - 10
   Windows Me      - 90
   Windows NT 3.51 - 51
   Windows NT 4.0  - 0
   Windows 2000    - 0
   Windows XP      - 1
   Windows 2008    - 0
   Windows 7       - 1
   Windows 8       - 1

DwBuildNumber: DWORD
 Win NT 4 - номер билда
 Win 9x   - старший байт - старшая и младшая цифры версии / младший - номер
билда

dwPlatformId: DWORD

  VER_PLATFORM_WIN32s            Win32s on Windows 3.1.
  VER_PLATFORM_WIN32_WINDOWS     Win32 on Windows 9x
  VER_PLATFORM_WIN32_NT          Win32 on Windows NT, 2000 

SzCSDVersion:DWORD
  NT - содержит PСhar с инфо о установленном ServicePack
  9x - доп. инфо, может и не быть
}
function DetectWinVersion: TWinVersion;
var
  OSVersionInfo : TOSVersionInfo;
begin
  Result := wvUnknown;                      // Неизвестная версия ОС
  OSVersionInfo.dwOSVersionInfoSize := sizeof(TOSVersionInfo);
  if GetVersionEx(OSVersionInfo)
    then
      begin
        case OSVersionInfo.DwMajorVersion of
          3:  Result := wvNT3;              // Windows NT 3
          4:  case OSVersionInfo.DwMinorVersion of
                0: if OSVersionInfo.dwPlatformId = VER_PLATFORM_WIN32_NT
                   then Result := wvNT4     // Windows NT 4
                   else Result := wv95;     // Windows 95
                10: Result := wv98;         // Windows 98
                90: Result := wvME;         // Windows ME
              end;
          5:  case OSVersionInfo.DwMinorVersion of
                0: Result := wvW2K;         // Windows 2000
                1: Result := wvXP;          // Windows XP
                2: Result := wv2003;        // Windows 2003
                3: Result := wvVista;       // Windows Vista
              end;
          6:  case OSVersionInfo.DwMinorVersion of
                0: Result := wv2008;        // Windows 2008
                1: Result := wv7;           // Windows 7
              end;
          7:  case OSVersionInfo.DwMinorVersion of
                1: Result := wv8;           // Windows 8
              end;
        end;
      end;
end;

{ Определение версии Windows }
function DetectWinVersionStr: String;
const
  VersStr : Array[TWinVersion] of String = (
    'Unknown OS',
    'Windows 95',
    'Windows 98',
    'Windows ME',
    'Windows NT 3',
    'Windows NT 4',
    'Windows 2000',
    'Windows XP',
    'Windows Server 2003',
    'Windows Vista',
    'Windows 7',
    'Windows Server 2008',
    'Windows 8');
begin
  Result := VersStr[DetectWinVersion];
end;

{ Определяет размер файла, если файла нет возвращает -1 }
function GetFileSize(FileName: String): Integer;
var
  FS: TFileStream;
begin
  Result := 0;
  try
    FS := TFileStream.Create(Filename, fmOpenRead);
    Result := FS.Size;
  except
    Result := -1;
    FS.Free;
    Exit;
  end;
  FS.Free;
end;

{ Прозрачность окна MessageBox }
procedure MakeTransp(winHWND: HWND);
var
  exStyle: Longint;
begin
  exStyle := GetWindowLong(winHWND, GWL_EXSTYLE);
  if (exStyle and WS_EX_LAYERED = 0) then
  begin
    exStyle := exStyle or WS_EX_LAYERED;
    SetwindowLong(winHWND, GWL_EXSTYLE, exStyle);
  end;
  SetLayeredWindowAttributes(winHWND, 0, AlphaBlendEnableValue, LWA_ALPHA);
end;

// Для мультиязыковой поддержки
procedure MsgDie(Caption, Msg: WideString);
begin
  if AlphaBlendEnable then
    PostMessage(GetForegroundWindow, WM_MSGBOX, 0, 0);
  MessageBoxW(GetForegroundWindow, PWideChar(Msg), PWideChar(Caption), MB_ICONERROR);
end;

// Для мультиязыковой поддержки
procedure MsgInf(Caption, Msg: WideString);
begin
  if AlphaBlendEnable then
    PostMessage(GetForegroundWindow, WM_MSGBOX, 0, 0);
  MessageBoxW(GetForegroundWindow, PWideChar(Msg), PWideChar(Caption), MB_ICONINFORMATION);
end;

{ Функция для мультиязыковой поддержки }
procedure CoreLanguageChanged;
var
  LangFile: String;
begin
  if CoreLanguage = '' then
    Exit;
  try
    LangFile := ProgramsPath + dirLangs + CoreLanguage + '.xml';
    if FileExists(LangFile) then
      LangDoc.LoadFromFile(LangFile)
    else
    begin
      if FileExists(ProgramsPath + dirLangs + defaultLangFile) then
        LangDoc.LoadFromFile(ProgramsPath + dirLangs + defaultLangFile)
      else
      begin
        MsgDie(ProgramsName, 'Not found any language file!');
        Exit;
      end;
    end;
    //Global.CoreLanguage := CoreLanguage;
    SendMessage(MainFormHandle, WM_LANGUAGECHANGED, 0, 0);
    SendMessage(SettingsFormHandle, WM_LANGUAGECHANGED, 0, 0);
    SendMessage(AboutFormHandle, WM_LANGUAGECHANGED, 0, 0);
    SendMessage(LogFormHandle, WM_LANGUAGECHANGED, 0, 0);
  except
    on E: Exception do
      MsgDie(ProgramsName, 'Error on CoreLanguageChanged: ' + E.Message + sLineBreak +
        'CoreLanguage: ' + CoreLanguage);
  end;
end;

// Для мультиязыковой поддержки
function GetLangStr(StrID: String): WideString;
begin
  if (not Assigned(LangDoc)) or (not LangDoc.Active) then
  begin
    Result := '';
    Exit;
  end;
  if LangDoc.ChildNodes['strings'].ChildNodes.FindNode(StrID) <> nil then
    Result := LangDoc.ChildNodes['strings'].ChildNodes[StrID].Text
  else
    Result := 'String not found';
end;

function GetSysLang: AnsiString;
var
  WinLanguage: Array [0..50] of Char;
begin
  VerLanguageName(GetSystemDefaultLangID, WinLanguage, 50);
  Result := StrPas(WinLanguage);
end;

{Функция осуществляет сравнение двух строк. Первая строка
может быть любой, но она не должна содержать символов соответствия (* и ?).
Строка поиска (искомый образ) может содержать абсолютно любые символы.
Для примера: MatchStrings('David Stidolph','*St*') возвратит True.
Автор оригинального C-кода Sean Stanley
Автор портации на Delphi David Stidolph}
function MatchStrings(source, pattern: String): Boolean;
var
  pSource: array[0..255] of Char;
  pPattern: array[0..255] of Char;

  function MatchPattern(element, pattern: PChar): Boolean;

  function IsPatternWild(pattern: PChar): Boolean;
  begin
    Result := StrScan(pattern, '*') <> nil;
    if not Result then
      Result := StrScan(pattern, '?') <> nil;
  end;

  begin
    if 0 = StrComp(pattern, '*') then
      Result := True
    else if (element^ = Chr(0)) and (pattern^ <> Chr(0)) then
      Result := False
    else if element^ = Chr(0) then
      Result := True
    else
    begin
      case pattern^ of
        '*': if MatchPattern(element, @pattern[1]) then
            Result := True
          else
            Result := MatchPattern(@element[1], pattern);
        '?': Result := MatchPattern(@element[1], @pattern[1]);
      else
        if element^ = pattern^ then
          Result := MatchPattern(@element[1], @pattern[1])
        else
          Result := False;
      end;
    end;
  end;
begin
  StrPCopy(pSource, source);
  StrPCopy(pPattern, pattern);
  Result := MatchPattern(pSource, pPattern);
end;

{ Функция для получения имени файла из пути без или с его расширением.
  Возвращает имя файла, без или с его расширением.
  Входные параметры:
  FileName - имя файла, которое надо обработать
  ShowExtension - если TRUE, то функция возвратит короткое имя файла
  (без полного пути доступа к нему), с расширением этого файла, иначе, возвратит
  короткое имя файла, без расширения этого файла. }
function ExtractFileNameEx(FileName: String; ShowExtension: Boolean): String;
var
  I: Integer;
  S, S1: string;
begin
  I := Length(FileName);
  if I <> 0 then
  begin
    while (FileName[i] <> '\') and (i > 0) do
      i := i - 1;
    S := Copy(FileName, i + 1, Length(FileName) - i);
    i := Length(S);
    if i = 0 then
    begin
      Result := '';
      Exit;
    end;
    while (S[i] <> '.') and (i > 0) do
      i := i - 1;
    S1 := Copy(S, 1, i - 1);
    if s1 = '' then
      s1 := s;
    if ShowExtension = True then
      Result := s
    else
      Result := s1;
  end
  else
    Result := '';
end;

{ Функция разбивает строку S на слова, разделенные символами-разделителями,
указанными в строке Sep. Функция возвращает первое найденное слово, при
этом из строки S удаляется начальная часть до следующего слова }
function Tok(Sep: String; var S: String): String;

  function isoneof(c, s: string): Boolean;
  var
    iTmp: integer;
  begin
    Result := False;
    for iTmp := 1 to Length(s) do
    begin
      if c = Copy(s, iTmp, 1) then
      begin
        Result := True;
        Exit;
      end;
    end;
  end;

var
  c, t: String;
begin
  if s = '' then
  begin
    Result := s;
    Exit;
  end;
  c := Copy(s, 1, 1);
  while isoneof(c, sep) do
  begin
    s := Copy(s, 2, Length(s) - 1);
    c := Copy(s, 1, 1);
  end;
  t := '';
  while (not isoneof(c, sep)) and (s <> '') do
  begin
    t := t + c;
    s := Copy(s, 2, length(s) - 1);
    c := Copy(s, 1, 1);
  end;
  Result := t;
end;

{ Функция чтения значения параметра из файла настроек }
function ReadCustomINI(INIPath, CustomSection, CustomParams, DefaultParamsStr: String): String;
var
  Path: String;
  INI: TIniFile;
begin
  Result := DefaultParamsStr;
  Path := INIPath + ININame;
  INI := TIniFile.Create(Path);
  if FileExists(Path) then
  begin
    try
      Result := INI.ReadString(CustomSection, CustomParams, DefaultParamsStr);
    finally
      INI.Free;
    end;
  end
  else
    MsgDie(ProgramsName, Format(GetLangStr('MsgErr4'), [Path]));
end;

{ Функция чтения значения параметра из файла настроек }
function ReadCustomINI(INIPath, CustomSection, CustomParams: String; DefaultParamsStr: Boolean): Boolean;
var
  Path: String;
  INI: TIniFile;
begin
  Result := DefaultParamsStr;
  Path := INIPath + ININame;
  INI := TIniFile.Create(Path);
  if FileExists(Path) then
  begin
    try
      Result := INI.ReadBool(CustomSection, CustomParams, DefaultParamsStr);
    finally
      INI.Free;
    end;
  end
  else
    MsgDie(ProgramsName, Format(GetLangStr('MsgErr4'), [Path]));
end;

{ Определение метода передачи текста }
function DetectMethodSendingText(Method: Integer): TMethodSendingText;
begin
  case Method of
    0:  Result := mWM_SETTEXT;
    1:  Result := mWM_PASTE;
    2:  Result := mWM_CHAR;
    3:  Result := mWM_PASTE_MOD;
  end;
end;

{ Определения типа команды (строка) по номеру }
function DetectCommandType(CType: Integer): String;
begin
  Result := DetectCommandTypeName(mExecPrograms);
  case CType of
    0:
      Result := DetectCommandTypeName(mExecPrograms);
    1:
      Result := DetectCommandTypeName(mClosePrograms);
    2:
      Result := DetectCommandTypeName(mKillPrograms);
    3:
      Result := DetectCommandTypeName(mTextToSpeech);
    else
      Result := DetectCommandTypeName(mExecPrograms);
  end;
end;

{ Определения номера типа команды по TCommandType }
function DetectCommandType(CType: TCommandType): Integer;
begin
  Result := Integer(mExecPrograms);
  case CType of
    mExecPrograms:
      Result := Integer(mExecPrograms);
    mClosePrograms:
      Result := Integer(mClosePrograms);
    mKillPrograms:
      Result := Integer(mKillPrograms);
    mTextToSpeech:
      Result := Integer(mTextToSpeech);
    else
      Result := Integer(mExecPrograms);
  end;
end;

{ Определения имени команды по TCommandType }
function DetectCommandTypeName(CType: TCommandType): String;
begin
  Result := GetLangStr(CommandStr[CType]);
end;

{ Определения типа команды (TCommandType) по имени }
function DetectCommandTypeName(CType: String): TCommandType;
begin
  Result := mExecPrograms;
  if CType = DetectCommandTypeName(mExecPrograms) then
    Result := mExecPrograms
  else if CType = DetectCommandTypeName(mClosePrograms) then
    Result := mClosePrograms
  else if CType = DetectCommandTypeName(mKillPrograms) then
    Result := mKillPrograms
  else if CType = DetectCommandTypeName(mTextToSpeech) then
    Result := mTextToSpeech;
end;

{ Перевод внутренного ID региона из CBRegion в его код }
function DetectRegionStr(RegionID: Integer): String;
begin
  Result := RegionArray[RegionID];
end;

{ Перевод кода региона в его внутренний ID из CBRegion }
function DetectRegionID(RegionStr: String): Integer;
var
  Cnt: Integer;
begin
  Result := 0;
  for Cnt := 0 to High(RegionArray) do
    if RegionArray[Cnt] = RegionStr then
      Result := Cnt;
end;

{ Перевод внутренного ID региона из CBRegion в его код }
function DetectTextToSpeechRegionStr(RegionID: Integer): String;
begin
  Result := TextToSpeechRegionArray[RegionID];
end;

{ Перевод кода региона в его внутренний ID из CBRegion }
function DetectTextToSpeechRegionID(RegionStr: String): Integer;
var
  Cnt: Integer;
begin
  Result := 0;
  for Cnt := 0 to High(TextToSpeechRegionArray) do
    if TextToSpeechRegionArray[Cnt] = RegionStr then
      Result := Cnt;
end;

{ Загружка данных замены в TStringGrid из файла }
procedure LoadReplaceDataStringGrid(MyFile: String; var FileGrid: TStringGrid);
var
  k,l: Integer;
  ColN, RowN: Integer;
  RowC, ColC: Integer;
  INI: TIniFile;
begin
  k := 0;
  l := 0;
  if FileExists(MyFile) then
  begin
    INI := TIniFile.Create(MyFile);
    try
      RowC := INI.ReadInteger('MSpeechReplaceGrid', 'RowCount', 1);
      ColC := INI.ReadInteger('MSpeechReplaceGrid', 'ColCount', 2);
      FileGrid.FixedCols := 0;
      FileGrid.FixedRows := 0;
      FileGrid.RowCount := RowC;
      FileGrid.ColCount := ColC;
      for RowN := 0 to RowC-1 do
      begin
        for ColN := 0 to ColC-1 do
        begin
          FileGrid.Cells[k,l] := INI.ReadString('MSpeechReplaceGrid', 'Item'+IntToStr(RowN)+IntToStr(ColN), '');
          Inc(k);
        end;
        k := 0;
        Inc(l);
      end;
    except
      on e : Exception do
        MsgDie(ProgramsName, 'Exception in procedure LoadReplaceDataStringGrid: Unable to read data in file ' + MyFile);
    end;
    INI.Free;
  end
  else
  begin
    if CoreLanguage = 'Russian' then
    begin
      FileGrid.RowCount := 5;
      FileGrid.Cells[0,0] := 'точка';
      FileGrid.Cells[1,0] := '.';
      FileGrid.Cells[0,1] := 'запятая';
      FileGrid.Cells[1,1] := ',';
      FileGrid.Cells[0,2] := 'восклицательный знак';
      FileGrid.Cells[1,2] := '!';
      FileGrid.Cells[0,3] := 'вопросительный знак';
      FileGrid.Cells[1,3] := '?';
      FileGrid.Cells[0,4] := 'тире';
      FileGrid.Cells[1,4] := '-';
    end
    else
    begin
      FileGrid.RowCount := 5;
      FileGrid.Cells[0,0] := 'dot';
      FileGrid.Cells[1,0] := '.';
      FileGrid.Cells[0,1] := 'comma';
      FileGrid.Cells[1,1] := ',';
      FileGrid.Cells[0,2] := 'exclamation mark';
      FileGrid.Cells[1,2] := '!';
      FileGrid.Cells[0,3] := 'question mark';
      FileGrid.Cells[1,3] := '?';
      FileGrid.Cells[0,4] := 'dash';
      FileGrid.Cells[1,4] := '-';
    end;
  end;
end;

{ Сохранение данных замены из TStringGrid в файл }
procedure SaveReplaceDataStringGrid(MyFile: String; FileGrid: TStringGrid);
var
  ColN, RowN: Integer;
  INI: TIniFile;
begin
  if FileExists(MyFile) then
    DeleteFile(PChar(MyFile));
  INI := TIniFile.Create(MyFile);
  try
    INI.WriteInteger('MSpeechReplaceGrid', 'RowCount', FileGrid.RowCount);
    INI.WriteInteger('MSpeechReplaceGrid', 'ColCount', FileGrid.ColCount);
    for RowN := 0 to FileGrid.RowCount-1 do
    begin
      for ColN := 0 to FileGrid.ColCount-1 do
      begin
        INI.WriteString('MSpeechReplaceGrid', 'Item'+IntToStr(RowN)+IntToStr(ColN), FileGrid.Cells[ColN,RowN]);
      end;
    end;
  except
    on e : Exception do
      MsgDie(ProgramsName, 'Exception in procedure SaveReplaceDataStringGrid: Unable to write data in file ' + MyFile);
  end;
  INI.Free;
end;

{ Загружка данных команд в TStringGrid из файла }
procedure LoadCommandDataStringGrid(MyFile: String; var FileGrid: TStringGrid);
var
  k,l: Integer;
  ColN, RowN: Integer;
  RowC, ColC: Integer;
  INI: TIniFile;
begin
  k := 0;
  l := 0;
  if FileExists(MyFile) then
  begin
    INI := TIniFile.Create(MyFile);
    try
      RowC := INI.ReadInteger('MSpeechCommandGrid', 'RowCount', 1);
      ColC := INI.ReadInteger('MSpeechCommandGrid', 'ColCount', 2);
      FileGrid.FixedCols := 0;
      FileGrid.FixedRows := 0;
      FileGrid.RowCount := RowC;
      FileGrid.ColCount := ColC;
      for RowN := 0 to RowC-1 do
      begin
        for ColN := 0 to ColC-1 do
        begin
          if k = 2 then // 3-й столбец
          begin
            if IsNumber(INI.ReadString('MSpeechCommandGrid', 'Item'+IntToStr(RowN)+IntToStr(ColN), '0')) then
            begin
              {if DetectCommandTypeName(DetectCommandType(INI.ReadInteger('MSpeechCommandGrid', 'Item'+IntToStr(RowN)+IntToStr(ColN), 0))) = mTextToSpeech then
              begin
                if EnableTextToSpeech then
                  FileGrid.Cells[k,l] := DetectCommandType(INI.ReadInteger('MSpeechCommandGrid', 'Item'+IntToStr(RowN)+IntToStr(ColN), 0));
              end
              else}
                FileGrid.Cells[k,l] := DetectCommandType(INI.ReadInteger('MSpeechCommandGrid', 'Item'+IntToStr(RowN)+IntToStr(ColN), 0));
            end
            else
              FileGrid.Cells[k,l] := DetectCommandType(0);
          end
          else
          begin
            {if DetectCommandTypeName(DetectCommandType(INI.ReadInteger('MSpeechCommandGrid', 'Item'+IntToStr(RowN)+'2', 0))) = mTextToSpeech then
            begin
              if EnableTextToSpeech then
              begin
                FileGrid.Cells[k,l] := INI.ReadString('MSpeechCommandGrid', 'Item'+IntToStr(RowN)+IntToStr(ColN), '');
              end
              else
                FileGrid.RowCount := FileGrid.RowCount - 1;
            end
            else}
              FileGrid.Cells[k,l] := INI.ReadString('MSpeechCommandGrid', 'Item'+IntToStr(RowN)+IntToStr(ColN), '');
          end;
          Inc(k);
        end;
        k := 0;
        Inc(l);
      end;
    except
      on e : Exception do
        MsgDie(ProgramsName, 'Exception in procedure LoadCommandDataStringGrid: Unable to read data in file ' + MyFile);
    end;
    INI.Free;
  end
  else
  begin
    if CoreLanguage = 'Russian' then
    begin
      FileGrid.RowCount := 9;
      FileGrid.Cells[0,0] := 'блокнот';
      FileGrid.Cells[1,0] := 'notepad.exe';
      FileGrid.Cells[2,0] := DetectCommandType(0);
      FileGrid.Cells[0,1] := 'paint';
      FileGrid.Cells[1,1] := 'mspaint.exe';
      FileGrid.Cells[2,1] := DetectCommandType(0);
      FileGrid.Cells[0,2] := 'свернуть все программы';
      FileGrid.Cells[1,2] := 'script\Show_Desktop.scf';
      FileGrid.Cells[2,2] := DetectCommandType(0);
      FileGrid.Cells[0,3] := 'заблокировать компьютер';
      FileGrid.Cells[1,3] := 'script\Lock_Workstation.cmd';
      FileGrid.Cells[2,3] := DetectCommandType(0);
      FileGrid.Cells[0,4] := 'выключить компьютер';
      FileGrid.Cells[1,4] := 'script\Halt_Workstation.cmd';
      FileGrid.Cells[2,4] := DetectCommandType(0);
      FileGrid.Cells[0,5] := 'перезагрузить компьютер';
      FileGrid.Cells[1,5] := 'script\Reboot_Workstation.cmd';
      FileGrid.Cells[2,5] := DetectCommandType(0);
      FileGrid.Cells[0,6] := 'завершить сеанс';
      FileGrid.Cells[1,6] := 'script\Logoff_Workstation.cmd';
      FileGrid.Cells[2,6] := DetectCommandType(0);
      FileGrid.Cells[0,7] := 'интернет';
      FileGrid.Cells[1,7] := 'firefox.exe';
      FileGrid.Cells[2,7] := DetectCommandType(0);
      FileGrid.Cells[0,8] := 'привет';
      FileGrid.Cells[1,8] := 'добрый день';
      FileGrid.Cells[2,8] := DetectCommandType(3);
    end
    else
    begin
      FileGrid.RowCount := 9;
      FileGrid.Cells[0,0] := 'notepad';
      FileGrid.Cells[1,0] := 'notepad.exe';
      FileGrid.Cells[2,0] := DetectCommandType(0);
      FileGrid.Cells[0,1] := 'paint';
      FileGrid.Cells[1,1] := 'mspaint.exe';
      FileGrid.Cells[2,1] := DetectCommandType(0);
      FileGrid.Cells[0,2] := 'hide all programs';
      FileGrid.Cells[1,2] := 'script\Show_Desktop.scf';
      FileGrid.Cells[2,2] := DetectCommandType(0);
      FileGrid.Cells[0,3] := 'lock computer';
      FileGrid.Cells[1,3] := 'script\Lock_Workstation.cmd';
      FileGrid.Cells[2,3] := DetectCommandType(0);
      FileGrid.Cells[0,4] := 'turn off computer';
      FileGrid.Cells[1,4] := 'script\Halt_Workstation.cmd';
      FileGrid.Cells[2,4] := DetectCommandType(0);
      FileGrid.Cells[0,5] := 'restart computer';
      FileGrid.Cells[1,5] := 'script\Reboot_Workstation.cmd';
      FileGrid.Cells[2,5] := DetectCommandType(0);
      FileGrid.Cells[0,6] := 'quit user';
      FileGrid.Cells[1,6] := 'script\Logoff_Workstation.cmd';
      FileGrid.Cells[2,6] := DetectCommandType(0);
      FileGrid.Cells[0,7] := 'internet';
      FileGrid.Cells[1,7] := 'firefox.exe';
      FileGrid.Cells[2,7] := DetectCommandType(0);
      FileGrid.Cells[0,8] := 'hi';
      FileGrid.Cells[1,8] := 'hello';
      FileGrid.Cells[2,8] := DetectCommandType(3);
    end;
  end;
end;

{ Сохранение данных команд из TStringGrid в файл }
procedure SaveCommandDataStringGrid(MyFile: String; FileGrid: TStringGrid);
var
  ColN, RowN: Integer;
  INI: TIniFile;
  CTypeName: String;
begin
  if FileExists(MyFile) then
    DeleteFile(PChar(MyFile));
  INI := TIniFile.Create(MyFile);
  try
    INI.WriteInteger('MSpeechCommandGrid', 'RowCount', FileGrid.RowCount);
    INI.WriteInteger('MSpeechCommandGrid', 'ColCount', FileGrid.ColCount);
    for RowN := 0 to FileGrid.RowCount-1 do
    begin
      for ColN := 0 to FileGrid.ColCount-1 do
      begin
        if ColN = 2 then // 3-й столбец
        begin
          CTypeName := FileGrid.Cells[ColN,RowN];
          INI.WriteInteger('MSpeechCommandGrid', 'Item'+IntToStr(RowN)+IntToStr(ColN), Integer(DetectCommandTypeName(CTypeName)));
        end
        else
          INI.WriteString('MSpeechCommandGrid', 'Item'+IntToStr(RowN)+IntToStr(ColN), FileGrid.Cells[ColN,RowN]);
      end;
    end;
  except
    on e : Exception do
      MsgDie(ProgramsName, 'Exception in procedure SaveCommandDataStringGrid: Unable to write data in file ' + MyFile);
  end;
  INI.Free;
end;

function IsNumber(const S: string): Boolean;
begin
  Result := True;
  try
    StrToInt(S);
  except
    Result := False;
  end;
end;

procedure LoadOLDCommandFileToGrid(MyFile: String; FileGrid: TStringGrid);
var
  TF: TextFile;
  Str1, Str2: String;
  I, J, RowN, ColN: Integer;
begin
  // Грузим старый список команд в StringGrid
  // Делаем такой изврат лишь с одной целью - легко реализуемый поиск по колонкам
  I := 0;
  AssignFile(TF, MyFile);
  Reset(TF);
  while not eof(TF) do
  begin
    Readln(TF, Str1);
    Inc(I);
    J := 0;
    while Pos(';', Str1)<>0 do
    begin
      Str2 := Copy(Str1,1,Pos(';', Str1)-1);
      Inc(J);
      Delete(Str1, 1, Pos(';', Str1));
      FileGrid.Cells[J-1, I-1] := Str2;
    end;
    if Pos(';', Str1) = 0 then
    begin
      Inc(J);
      FileGrid.Cells[J-1, I-1] := Str1;
    end;
    FileGrid.ColCount := J;
    FileGrid.RowCount := I+1;
  end;
  CloseFile(TF);
  FileGrid.ColCount := FileGrid.ColCount+1;
  for RowN := 0 to FileGrid.RowCount-1 do
  begin
    for ColN := 0 to FileGrid.ColCount-1 do
    begin
      if ColN = 2 then // 3-й столбец
        FileGrid.Cells[ColN,RowN] := DetectCommandType(0)
    end;
  end;
  FileGrid.RowCount := FileGrid.RowCount-1;
end;

{ Перевод первых букв в русском тексте в верхний регистр }
function RusLowercaseToUppercase(MyText: String): String;
const
  rzd = ['.','!','?'];
var
  S: String;
  Cnt: Byte;
begin
  Result := '';
  S := MyText;
  for Cnt := 1 to Length(S) do
  begin
    if ((Ord(S[Cnt])-1000) in [72..105]) and
      ((Cnt=1) or (S[Cnt-1] in rzd) or (S[Cnt-2] in rzd)) then
      Result := Result + UpperCase(S[Cnt], loUserLocale)
    else
      Result := Result + S[Cnt];
  end;
end;

{ Перевод первых букв в английском тексте в верхний регистр }
function EngLowercaseToUppercase(MyText: String): String;
const
  rzd = ['.','!','?'];
var
  Cnt: Byte;
begin
  Result := '';
  for Cnt := 1 to Length(MyText) do
  begin
    if (MyText[Cnt] in ['a'..'z']) and
      ((Cnt=1) or (MyText[Cnt-1] in rzd) or (MyText[Cnt-2] in rzd)) then
    begin
      MyText[Cnt] := UpCase(MyText[Cnt]);
    end;
  end;
  Result := MyText;
end;

{ Узнаем номер версии из ресурсов }
function GetMyExeVersion: String;
type
  TVerInfo = packed record
    Info: Array[0..47] of Byte;       // Эти 48 байт нам не нужны
    Minor,Major,Build,Release: Word;  // Версия программы
  end;
var
  RS: TResourceStream;
  VI: TVerInfo;
begin
  Result := ProgramsVer;
  try
    RS := TResourceStream.Create(HInstance, '#1', RT_VERSION); // Достаём ресурс
    if RS.Size > 0 then
    begin
      RS.Read(VI, SizeOf(VI)); // Читаем нужные нам байты
      Result := IntToStr(VI.Major)+'.'+IntToStr(VI.Minor)+'.'+IntToStr(VI.Release)+'.'+IntToStr(VI.Build);
    end;
    RS.Free;
  except;
  end;
end;

{ Отправка текста через WM_COPYDATA }
function OnSendMessage(WinName, Msg: String): Boolean;
var
  HToDB: HWND;
  copyDataStruct : TCopyDataStruct;
  AppNameStr: String;
begin
  Result := False;
  // Ищем окно WinName и посылаем ему команду
  HToDB := FindWindow(nil, pWideChar(WinName));
  if HToDB <> 0 then
  begin
    copyDataStruct.dwData := {$IFDEF WIN32}Integer{$ELSE}LongInt{$ENDIF}(cdtString);
    copyDataStruct.cbData := Length(Msg) * SizeOf(Char);
    copyDataStruct.lpData := pChar(Msg);
    SendMessage(HToDB, WM_COPYDATA, 0, {$IFDEF WIN32}Integer{$ELSE}LongInt{$ENDIF}(@copyDataStruct));
    Result := True;
  end;
end;

{ Функция возвращает путь до пользовательской временной папки }
function GetUserTempPath: WideString;
var
  UserPath: WideString;
begin
  Result := '';
  SetLength(UserPath, MAX_PATH);
  GetTempPath(MAX_PATH, PChar(UserPath));
  GetLongPathName(PChar(UserPath), PChar(UserPath), MAX_PATH);
  SetLength(UserPath, StrLen(PChar(UserPath)));
  Result := IncludeTrailingPathDelimiter(UserPath);
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

function EnumThreadWndProc(hwnd: HWND; lParam: LPARAM): BOOL; stdcall;
var
  WindowClassName: String;
  WindowClassNameLength: Integer;
  WinCaption: Array [0 .. 255] of Char;
  ThreadProcessWinCaption: String;
  PID: DWORD;
begin
  Result := True;
  ThreadProcessWinCaption := String(LPARAM);
  GetWindowThreadProcessId(hwnd, pid);
  SetLength(WindowClassName, MAX_PATH);
  WindowClassNameLength := GetClassName(hwnd, PChar(WindowClassName), MAX_PATH);
  GetWindowText(hwnd, WinCaption, SizeOf(WinCaption));
  if WinCaption = ThreadProcessWinCaption then
    GlobalProcessPID := PID;
end;

{ Получение ID всех потоков указанного процесса }
function GetThreadsOfProcess(APID: Cardinal): TIntegerDynArray;
var
 lSnap: DWord;
 lThread: TThreadEntry32;
begin
  Result := nil;
  if APID <> INVALID_HANDLE_VALUE then
  begin
    lSnap := CreateToolhelp32Snapshot(TH32CS_SNAPTHREAD, 0);
    if (lSnap <> INVALID_HANDLE_VALUE) then
    begin
      lThread.dwSize := SizeOf(TThreadEntry32);
      if Thread32First(lSnap, lThread) then
      repeat
        if lThread.th32OwnerProcessID = APID then
        begin
          SetLength(Result, Length(Result) + 1);
          Result[High(Result)] := lThread.th32ThreadID;
        end;
      until not Thread32Next(lSnap, lThread);
      CloseHandle(lSnap);
    end;
  end;
end;

{ Проверка процесса на наличие в памяти по его имени }
function IsProcessRun(ProcessName: String): Boolean; overload;
var
  Snapshot: THandle;
  Proc: TProcessEntry32;
begin
  Result := False;
  Snapshot := CreateToolHelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  if Snapshot = INVALID_HANDLE_VALUE then
    Exit;
  Proc.dwSize := SizeOf(TProcessEntry32);
  if Process32First(Snapshot, Proc) then
  repeat
    if Proc.szExeFile = ProcessName then
    begin
      Result := True;
      Break;
    end;
  until not Process32Next(Snapshot, Proc);
  CloseHandle(Snapshot);
end;

function IsProcessRun(ProcessName, WinCaption: String): Boolean; overload;
var
  Snapshot: THandle;
  Proc: TProcessEntry32;
  lThreads: TIntegerDynArray;
  J: Integer;
begin
  Result := False;
  Snapshot := CreateToolHelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  if Snapshot = INVALID_HANDLE_VALUE then
    Exit;
  Proc.dwSize := SizeOf(TProcessEntry32);
  if Process32First(Snapshot, Proc) then
  repeat
    if ((UpperCase(ExtractFileName(Proc.szExeFile)) = UpperCase(ProcessName))
     or (UpperCase(Proc.szExeFile) = UpperCase(ProcessName))) then
     begin
      // Получение ClassName и Заголовков окон всех потоков процесса
      lThreads := GetThreadsOfProcess(Proc.th32ProcessID);
      for J := Low(lThreads) to High(lThreads) do
        EnumThreadWindows(lThreads[J], @EnumThreadWndProc, LPARAM(WinCaption));
      if GlobalProcessPID = Proc.th32ProcessID then
        Result := True;
      // Ends
     end;
  until not Process32Next(Snapshot, Proc);
  CloseHandle(Snapshot);
end;

{ Закрытие программы через WM_CLOSE по её PID }
function ProcCloseEnum(hwnd: THandle; data: Pointer):BOOL;stdcall;
var
  Pid: DWORD;
begin
  Result := True;
  GetWindowThreadProcessId(hwnd, pid);
  if Pid = DWORD(data) then
  begin
    PostMessage(hwnd, WM_CLOSE, 0, 0);
  end;
end;

{ Закрытие программы через WM_QUIT по её PID }
function ProcQuitEnum(hwnd: THandle; data: Pointer):BOOL;stdcall;
var
  Pid: DWORD;
begin
  Result := True;
  GetWindowThreadProcessId(hwnd, pid);
  if Pid = DWORD(data) then
  begin
    PostMessage(hwnd, WM_QUIT, 0, 0);
  end;
end;

{ Процедура отправляет WM_CLOSE или WM_QUIT процессу }
procedure EndProcess(ProcessPID: DWord; EndType: Integer);
begin
  if EndType = WM_CLOSE then //WM_CLOSE
    EnumWindows(@ProcCloseEnum, ProcessPID)
  else //WM_QUIT
    EnumWindows(@ProcQuitEnum, ProcessPID);
end;

{ Получение PID программы в памяти }
function GetProcessID(ExeFileName: String): Cardinal;
var
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
begin
  Result := 0;
  FSnapshotHandle := CreateToolHelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := Sizeof(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
  repeat
    if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) = UpperCase(ExeFileName))
       or (UpperCase(FProcessEntry32.szExeFile) = UpperCase(ExeFileName))) then
    begin
       Result := FProcessEntry32.th32ProcessID;
       Break;
    end;
    ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  until not ContinueLoop;
  CloseHandle(FSnapshotHandle);
end;

{ Завершение процесса по имени }
function KillTask(ExeFileName: String): Integer;
const
  PROCESS_TERMINATE=$0001;
var
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
begin
  Result := 0;
  FSnapshotHandle := CreateToolHelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := Sizeof(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
  while Integer(ContinueLoop) <> 0 do
  begin
    if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) = UpperCase(ExeFileName))
     or (UpperCase(FProcessEntry32.szExeFile) = UpperCase(ExeFileName))) then
      Result := Integer(TerminateProcess(OpenProcess(PROCESS_TERMINATE, BOOL(0),
                        FProcessEntry32.th32ProcessID), 0));
    ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
end;

{ Завершение процесса по имени и заголовку окна }
function KillTask(ExeFileName, WinCaption: String): Integer; overload;
const
  PROCESS_TERMINATE=$0001;
var
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
  lThreads: TIntegerDynArray;
  J: Integer;
begin
  Result := 0;
  FSnapshotHandle := CreateToolHelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := Sizeof(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
  while Integer(ContinueLoop) <> 0 do
  begin
    if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) = UpperCase(ExeFileName))
     or (UpperCase(FProcessEntry32.szExeFile) = UpperCase(ExeFileName))) then
     begin
      // Получение ClassName и Заголовков окон всех потоков процесса
      GlobalProcessPID := 0;
      lThreads := GetThreadsOfProcess(FProcessEntry32.th32ProcessID);
      for J := Low(lThreads) to High(lThreads) do
        EnumThreadWindows(lThreads[J], @EnumThreadWndProc, LPARAM(WinCaption));
      if GlobalProcessPID = FProcessEntry32.th32ProcessID then
        Result := Integer(TerminateProcess(OpenProcess(PROCESS_TERMINATE, BOOL(0), FProcessEntry32.th32ProcessID), 0));
      // Ends
     end;
    ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
end;

// LogType = 0 - сообщения добавляются в файл DebugLogName
procedure WriteInLog(LogPath: WideString; TextString: String);
var
  Path: WideString;
  TF: TextFile;
begin
  if not DebugLogOpened then
    DebugLogOpened := OpenLogFile(LogPath);
  Path := LogPath + DebugLogName;
  {$I-}
  try
    WriteLn(TFDebugLog, TextString);
  except
    on e :
      Exception do
      begin
        CloseLogFile;
        Exit;
      end;
  end;
  {$I+}
end;

// Открытие лог-файла
// LogType = 0 - сообщения добавляются в файл DebugLogName
function OpenLogFile(LogPath: WideString): Boolean;
var
  Path: WideString;
begin
  Path := LogPath + DebugLogName;
  if GetMyFileSize(Path) > MaxDebugLogSize*1024 then
    try
      DeleteFile(Path);
    except
      Result := False;
      Exit;
    end;
  {$I-}
  try
    Assign(TFDebugLog, Path);
    if FileExists(Path) then
      Append(TFDebugLog)
    else
      Rewrite(TFDebugLog);
    Result := True;
  except
    on e :
      Exception do
      begin
        CloseLogFile;
        Result := False;
        Exit;
      end;
  end;
  {$I+}
end;

// Закрытие лог-файла
procedure CloseLogFile;
begin
  {$I-}
  CloseFile(TFDebugLog);
  DebugLogOpened := False;
  {$I+}
end;

// Если файл не существует, то вместо размера файла функция вернёт -1
function GetMyFileSize(const Path: WideString): Integer;
var
  FD: TWin32FindData;
  FH: THandle;
begin
  Result := 0;
  FH := FindFirstFile(PChar(Path), FD);
  if FH = INVALID_HANDLE_VALUE then
    Exit;
  Result := FD.nFileSizeLow;
  if ((FD.nFileSizeLow and $80000000) <> 0) or
     (FD.nFileSizeHigh <> 0) then
    Result := -1;
  //FindClose(FH);
end;

{ Определения типа события (строка) по номеру }
function DetectEventsType(CType: Integer): String;
begin
  Result := DetectEventsTypeName(mWarningRecognize);
  case CType of
    0:
      Result := DetectEventsTypeName(mWarningRecognize);
    1:
      Result := DetectEventsTypeName(mRecordingNotRecognized);
    2:
      Result := DetectEventsTypeName(mCommandNotFound);
    else
      Result := DetectEventsTypeName(mErrorGoogleCommunication);
  end;
end;

{ Определения номера типа события по TEventsType }
function DetectEventsType(CType: TEventsType): Integer;
begin
  Result := Integer(CType);
  {case CType of
    mWarningRecognize:
      Result := Integer(mWarningRecognize);
    mRecordingNotRecognized:
      Result := Integer(mRecordingNotRecognized);
    mCommandNotFound:
      Result := Integer(mCommandNotFound);
    mErrorGoogleCommunication:
      Result := Integer(mErrorGoogleCommunication);
    else
      Result := Integer(mWarningRecognize);
  end;}
end;

{ Определения имени события по TEventsType }
function DetectEventsTypeName(CType: TEventsType): String;
begin
  Result := GetLangStr(EventsTypeStr[CType]);
end;

{ Определения типа события (TEventsType) по имени }
function DetectEventsTypeName(CType: String): TEventsType;
begin
  Result := mWarningRecognize;
  if CType = DetectEventsTypeName(mWarningRecognize) then
    Result := mWarningRecognize
  else if CType = DetectEventsTypeName(mRecordingNotRecognized) then
    Result := mRecordingNotRecognized
  else if CType = DetectEventsTypeName(mCommandNotFound) then
    Result := mCommandNotFound
  else if CType = DetectEventsTypeName(mErrorGoogleCommunication) then
    Result := mErrorGoogleCommunication;
end;

{ Определения типа статуса события (строка) по номеру }
function DetectEventsTypeStatus(CType: Integer): String;
begin
  Result := DetectEventsTypeStatusName(mEnable);
  case CType of
    0:
      Result := DetectEventsTypeStatusName(mDisable);
    1:
      Result := DetectEventsTypeStatusName(mEnable);
    else
      Result := DetectEventsTypeStatusName(mEnable);
  end;
end;

{ Определения номера типа статуса события по TEventsTypeStatus}
function DetectEventsTypeStatus(CType: TEventsTypeStatus): Integer;
begin
  Result := Integer(CType);
end;

{ Определения имени статуса события по TEventsTypeStatus }
function DetectEventsTypeStatusName(CType: TEventsTypeStatus): String;
begin
  Result := GetLangStr(EventsTypeStatusStr[CType]);
end;

{ Определения типа статуса события (TEventsTypeStatus) по имени }
function DetectEventsTypeStatusName(CType: String): TEventsTypeStatus;
begin
  Result := mEnable;
  if CType = DetectEventsTypeStatusName(mEnable) then
    Result := mEnable
  else
    Result := mDisable;
end;

{ Загружка данных для преобразования текста в речь в TStringGrid из файла }
procedure LoadTextToSpeechDataStringGrid(MyFile: String; var FileGrid: TStringGrid);
var
  k,l: Integer;
  ColN, RowN: Integer;
  RowC, ColC: Integer;
  INI: TIniFile;
begin
  k := 0;
  l := 0;
  if FileExists(MyFile) then
  begin
    INI := TIniFile.Create(MyFile);
    try
      RowC := INI.ReadInteger('MSpeechTextToSpeechGrid', 'RowCount', 1);
      ColC := INI.ReadInteger('MSpeechTextToSpeechGrid', 'ColCount', 2);
      FileGrid.FixedCols := 0;
      FileGrid.FixedRows := 0;
      FileGrid.RowCount := RowC;
      FileGrid.ColCount := ColC;
      for RowN := 0 to RowC-1 do
      begin
        for ColN := 0 to ColC-1 do
        begin
          if k = 1 then // 2-й столбец
          begin
            if IsNumber(INI.ReadString('MSpeechTextToSpeechGrid', 'Item'+IntToStr(RowN)+IntToStr(ColN), '0')) then
              FileGrid.Cells[k,l] := DetectEventsType(INI.ReadInteger('MSpeechTextToSpeechGrid', 'Item'+IntToStr(RowN)+IntToStr(ColN), 0))
            else
              FileGrid.Cells[k,l] := DetectEventsType(0);
          end
          else if k = 2 then // 3-й столбец
          begin
            if IsNumber(INI.ReadString('MSpeechTextToSpeechGrid', 'Item'+IntToStr(RowN)+IntToStr(ColN), '0')) then
              FileGrid.Cells[k,l] := DetectEventsTypeStatus(INI.ReadInteger('MSpeechTextToSpeechGrid', 'Item'+IntToStr(RowN)+IntToStr(ColN), 0))
            else
              FileGrid.Cells[k,l] := DetectEventsTypeStatus(0);
          end
          else
            FileGrid.Cells[k,l] := INI.ReadString('MSpeechTextToSpeechGrid', 'Item'+IntToStr(RowN)+IntToStr(ColN), '');
          Inc(k);
        end;
        k := 0;
        Inc(l);
      end;
    except
      on e : Exception do
        MsgDie(ProgramsName, 'Exception in procedure LoadTextToSpeechDataStringGrid: Unable to read data in file ' + MyFile);
    end;
    INI.Free;
  end
  else
  begin
    if CoreLanguage = 'Russian' then
    begin
      FileGrid.RowCount := 2;
      FileGrid.Cells[0,0] := 'Произошла ошибка при распознавании голоса';
      FileGrid.Cells[1,0] := DetectEventsType(0);
      FileGrid.Cells[2,0] := DetectEventsTypeStatus(1);
      FileGrid.Cells[0,1] := 'Ваш голос не распознан';
      FileGrid.Cells[1,1] := DetectEventsType(1);
      FileGrid.Cells[2,1] := DetectEventsTypeStatus(1);
    end
    else
    begin
      FileGrid.RowCount := 2;
      FileGrid.Cells[0,0] := 'An error occurred while the voice recognition';
      FileGrid.Cells[1,0] := DetectEventsType(0);
      FileGrid.Cells[2,0] := DetectEventsTypeStatus(1);
      FileGrid.Cells[0,1] := 'Your voice is not recognized';
      FileGrid.Cells[1,1] := DetectEventsType(1);
      FileGrid.Cells[2,1] := DetectEventsTypeStatus(1);
    end;
  end;
end;

{ Сохранение данных для преобразования текста в речь из TStringGrid в файл }
procedure SaveTextToSpeechDataStringGrid(MyFile: String; FileGrid: TStringGrid);
var
  ColN, RowN: Integer;
  INI: TIniFile;
  CTypeName: String;
begin
  if FileExists(MyFile) then
    DeleteFile(PChar(MyFile));
  INI := TIniFile.Create(MyFile);
  try
    INI.WriteInteger('MSpeechTextToSpeechGrid', 'RowCount', FileGrid.RowCount);
    INI.WriteInteger('MSpeechTextToSpeechGrid', 'ColCount', FileGrid.ColCount);
    for RowN := 0 to FileGrid.RowCount-1 do
    begin
      for ColN := 0 to FileGrid.ColCount-1 do
      begin
        if ColN = 1 then // 2-й столбец
        begin
          CTypeName := FileGrid.Cells[ColN,RowN];
          INI.WriteInteger('MSpeechTextToSpeechGrid', 'Item'+IntToStr(RowN)+IntToStr(ColN), Integer(DetectEventsTypeName(CTypeName)));
        end
        else if ColN = 2 then // 3-й столбец
        begin
          CTypeName := FileGrid.Cells[ColN,RowN];
          INI.WriteInteger('MSpeechTextToSpeechGrid', 'Item'+IntToStr(RowN)+IntToStr(ColN), Integer(DetectEventsTypeStatusName(CTypeName)));
        end
        else
          INI.WriteString('MSpeechTextToSpeechGrid', 'Item'+IntToStr(RowN)+IntToStr(ColN), FileGrid.Cells[ColN,RowN]);
      end;
    end;
  except
    on e : Exception do
      MsgDie(ProgramsName, 'Exception in procedure SaveTextToSpeechDataStringGrid: Unable to write data in file ' + MyFile);
  end;
  INI.Free;
end;

begin
end.
