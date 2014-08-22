{ ############################################################################ }
{ #                                                                          # }
{ #  MSpeech v1.4 - ������������� ���� ��������� Google Speech API           # }
{ #                                                                          # }
{ #  License: GPLv3                                                          # }
{ #                                                                          # }
{ #  Author: Mikhail Grigorev (icq: 161867489, email: sleuthhound@gmail.com) # }
{ #                                                                          # }
{ ############################################################################ }

unit Main;

interface

{$I MSpeech.inc}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ACS_Classes, NewACIndicators, ACS_FLAC, ACS_DXAudio,
  HTTPSend, SSL_OpenSSL, uJSON, ShellApi, Global, About, Settings, Log, ACS_Misc, ACS_Filters, ACS_Wave,
  CoolTrayIcon, ImgList, Menus, JvAppStorage, JvAppIniStorage, JvComponentBase,
  JvFormPlacement, JvThread, Grids, JvAppHotKey, Vcl.ExtCtrls, Vcl.Buttons, Clipbrd,
  XMLIntf, XMLDoc, JvExControls, JvSpeedButton, ActiveX, SpeechLib_TLB, JclStringConversions,
  AudioDMO, ACS_Procs, synautil, ACS_WinMedia, ACS_smpeg, SHFolder, StrUtils;

type
  TMainForm = class(TForm)
    DXAudioIn: TDXAudioIn;
    FLACOut: TFLACOut;
    FastGainIndicator: TFastGainIndicator;
    NULLOut: TNULLOut;
    MSpeechTray: TCoolTrayIcon;
    TrayImageList: TImageList;
    MSpeechPopupMenu: TPopupMenu;
    MSpeechShowHide: TMenuItem;
    MSpeechAbout: TMenuItem;
    MSpeechExit: TMenuItem;
    JvFormStorage: TJvFormStorage;
    JvAppIniFileStorage: TJvAppIniFileStorage;
    JvThreadRecognize: TJvThread;
    GBMain: TGroupBox;
    LSignalLevel: TLabel;
    ProgressBar: TProgressBar;
    StartButton: TButton;
    StopButton: TButton;
    SettingsButton: TButton;
    AboutButton: TButton;
    MSpeechSettings: TMenuItem;
    ImageList_Main: TImageList;
    MSpeechShowLog: TMenuItem;
    MP3In: TMP3In;
    DXAudioOut: TDXAudioOut;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure FastGainIndicatorGainData(Sender: TComponent);
    procedure MSpeechTrayStartup(Sender: TObject; var ShowMainForm: Boolean);
    procedure FLACOutDone(Sender: TComponent);
    procedure FLACOutThreadException(Sender: TComponent);
    procedure NULLOutThreadException(Sender: TComponent);
    procedure NULLOutDone(Sender: TComponent);
    procedure StartButtonClick(Sender: TObject);
    procedure StopButtonClick(Sender: TObject);
    procedure SettingsButtonClick(Sender: TObject);
    procedure AboutButtonClick(Sender: TObject);
    procedure MSpeechTrayDblClick(Sender: TObject);
    procedure MSpeechShowLogClick(Sender: TObject);
    procedure MSpeechSettingsClick(Sender: TObject);
    procedure MSpeechAboutClick(Sender: TObject);
    procedure MSpeechExitClick(Sender: TObject);
    procedure JvThreadRecognizeExecute(Sender: TObject; Params: Pointer);
    procedure JvThreadRecognizeFinish(Sender: TObject);
    procedure Start;
    procedure StartRecognize;
    procedure StartRecord;
    procedure StartNULLRecord;
    procedure StopNULLRecord;
    procedure SyncFilterOn;
    procedure SyncFilterOff;
    procedure VoiceFilterOn;
    procedure VoiceFilterOff;
  private
    { Private declarations }
    SessionEnding: Boolean;
    FCount: Integer;
    procedure WMQueryEndSession(var Message: TMessage); message WM_QUERYENDSESSION;
    procedure OnLanguageChanged(var Msg: TMessage); message WM_LANGUAGECHANGED;
    procedure msgBoxShow(var Msg: TMessage); message WM_MSGBOX;
    procedure InitSaveSettings(var Msg: TMessage); message WM_STARTSAVESETTINGS;
    procedure SaveSettingsDone(var Msg: TMessage); message WM_SAVESETTINGSDONE;
    procedure DoHotKey(Sender:TObject);
    procedure LoadLanguageStrings;
  public
    { Public declarations }
    MSpeechMainFormHidden: Boolean;
    // ������ ������
    CommandSGrid: TStringGrid;
    // ������ ������
    ReplaceSGrid: TStringGrid;
    // ������ ������ ����� SAPI
    gpIVTxt: TSpVoice;
    Voices: ISpeechObjectTokens;
    TextToSpeechSGrid: TStringGrid;
    // �������
    VoiceFilter: TVoiceFilter;
    SincFilter: TSincFilter;
    function HTTPGetSize(var HTTP: THTTPSend; URL: String): int64; overload;
    function HTTPGetSize(URL: String): int64; overload;
    function HTTPPostFile(Const URL, FieldName, FileName: String; Const Data: TStream; Const ResultData: TStrings): Boolean;
    function GoogleTextToSpeech(const Text, MP3FileName: String): Boolean;
    procedure RegisterHotKeys;
    procedure UnRegisterHotKeys;
    procedure ShowBalloonHint(BalloonTitle, BalloonMsg : WideString); overload;
    procedure ShowBalloonHint(BalloonTitle, BalloonMsg: WideString; BalloonIconType: TBalloonHintIcon); overload;
    function GetTextWnd(MyClassName: String): String;
    procedure SetTextWnd(MyClassName, MyText: String); overload;
    procedure SetTextWnd(MyText: String); overload;
    procedure InsTextWnd(MyClassName, MyText: String); overload;
    procedure InsTextWnd(MyText: String); overload;
    procedure CopyPasteTextWnd(MyClassName, MyText: String); overload;
    procedure CopyPasteTextWnd(MyText: String); overload;
    procedure SetCharTextWnd(MyText: String);
    function SAPIActivate: Boolean;
    procedure SAPIDeactivate;
    procedure TextToSpeech(EType: TEventsType); overload;
    procedure TextToSpeech(SayText: String); overload;
    procedure Filters;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

var
  SaveFLACDone: Boolean = False;
  StopRecord: Boolean = False;
  FLACDoneCnt: Integer = 0;
  NULLOutStart: Boolean = False;
  NULLOutDoneCnt: Integer = 0;
  JvStartRecordHotKey: TJvApplicationHotKey;
  JvStartRecordWithoutSendTextHotKey: TJvApplicationHotKey;
  JvStartRecordWithoutExecCommandHotKey: TJvApplicationHotKey;
  JvSwitchesLanguageRecognizeHotKey: TJvApplicationHotKey;

procedure TMainForm.WMQueryEndSession(var Message: TMessage);
begin
  SessionEnding := True;
  Message.Result := 1;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  DebugLogOpened := False;
  ProgramsPath := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName));
  OutFileName := GetUserTempPath() + 'out.flac';
  WorkPath := IncludeTrailingPathDelimiter(IncludeTrailingPathDelimiter(GetSpecialFolderPath(CSIDL_LOCAL_APPDATA))+ProgramsName);
  // ��������� ���� ������������
  if not DirectoryExists(WorkPath) then
    CreateDir(WorkPath);
  if DirectoryExists(WorkPath) then
  begin
    // �������� ��������� ���� ��������
    if not FileExists(WorkPath + ININame) then
    begin
      if FileExists(ProgramsPath + ININame) then
        CopyFileEx(PChar(ProgramsPath + ININame), PChar(WorkPath + ININame), nil, nil, nil, COPY_FILE_FAIL_IF_EXISTS);
    end;
    // �������� ��������� ���� ������
    if not FileExists(WorkPath + CommandGridFile) then
    begin
      if FileExists(ProgramsPath + CommandGridFile) then
        CopyFileEx(PChar(ProgramsPath + CommandGridFile), PChar(WorkPath + CommandGridFile), nil, nil, nil, COPY_FILE_FAIL_IF_EXISTS);
    end;
    // �������� ��������� ���� ��� ����������
    if not FileExists(WorkPath + ReplaceGridFile) then
    begin
      if FileExists(ProgramsPath + ReplaceGridFile) then
        CopyFileEx(PChar(ProgramsPath + ReplaceGridFile), PChar(WorkPath + ReplaceGridFile), nil, nil, nil, COPY_FILE_FAIL_IF_EXISTS);
    end;
    // �������� ��������� ���� text-to-speech
    if not FileExists(WorkPath + TextToSpeechGridFile) then
    begin
      if FileExists(ProgramsPath + TextToSpeechGridFile) then
        CopyFileEx(PChar(ProgramsPath + TextToSpeechGridFile), PChar(WorkPath + TextToSpeechGridFile), nil, nil, nil, COPY_FILE_FAIL_IF_EXISTS);
    end;
    // �������� ��������� ���� �������� ����
    if not FileExists(WorkPath + JvAppIniFileStorage.FileName) then
    begin
      if FileExists(ProgramsPath + JvAppIniFileStorage.FileName) then
        CopyFileEx(PChar(ProgramsPath + JvAppIniFileStorage.FileName), PChar(WorkPath + JvAppIniFileStorage.FileName), nil, nil, nil, COPY_FILE_FAIL_IF_EXISTS);
    end;
  end
  else
    WorkPath := ProgramsPath;
  // ��� �������������� ���������
  MainFormHandle := Handle;
  SetWindowLong(Handle, GWL_HWNDPARENT, 0);
  SetWindowLong(Handle, GWL_EXSTYLE, GetWindowLong(Handle, GWL_EXSTYLE) or WS_EX_APPWINDOW);
  // ������ ���������
  LoadINI(WorkPath);
  MSpeechTray.Hint := ProgramsName;
  // ��������� �����
  JvAppIniFileStorage.FileName := WorkPath + INIFormsName;
  // ��������� ��������� �����������
  if INIFileLoaded then
    CoreLanguage := DefaultLanguage
  else
  begin
    if (GetSysLang = '�������') or (GetSysLang = 'Russian') or (MatchStrings(GetSysLang, '�������*')) then
      CoreLanguage := 'Russian'
    else
      CoreLanguage := 'English';
  end;
  LangDoc := NewXMLDocument();
  if not DirectoryExists(ProgramsPath + dirLangs) then
    CreateDir(ProgramsPath + dirLangs);
  CoreLanguageChanged;
  // ��������� ������ �������� ������
  if DXAudioIn.DeviceCount > 0 then
    StartButton.Enabled := True
  else
  begin
    MsgDie(ProgramsName, GetLangStr('MsgErr1'));
    Application.Terminate;
    Exit;
  end;
  // ��������� ������
  StopButton.Enabled := False;
  // ���������� �����
  Filters();
  // ������� ������� �������
  JvStartRecordHotKey := TJvApplicationHotKey.Create(self);
  with JvStartRecordHotKey do
  begin
    HotKey := TextToShortCut(StartRecordHotKey);
    Active := False;
    OnHotKey := DoHotKey;
  end;
  JvStartRecordWithoutSendTextHotKey := TJvApplicationHotKey.Create(self);
  with JvStartRecordWithoutSendTextHotKey do
  begin
    HotKey := TextToShortCut(StartRecordWithoutSendTextHotKey);
    Active := False;
    OnHotKey := DoHotKey;
  end;
  JvStartRecordWithoutExecCommandHotKey := TJvApplicationHotKey.Create(self);
  with JvStartRecordWithoutExecCommandHotKey do
  begin
    HotKey := TextToShortCut(StartRecordWithoutExecCommandHotKey);
    Active := False;
    OnHotKey := DoHotKey;
  end;
  JvSwitchesLanguageRecognizeHotKey := TJvApplicationHotKey.Create(self);
  with JvSwitchesLanguageRecognizeHotKey do
  begin
    HotKey := TextToShortCut(SwitchesLanguageRecognizeHotKey);
    Active := False;
    OnHotKey := DoHotKey;
  end;
  // ���������� ������� �������
  RegisterHotKeys;
  StopRecord := True;
  FCount := 0;
  // ������ ������ ������
  CommandSGrid := TStringGrid.Create(nil);
  // ���� ������ ������ ���� ������, �� ������ ������ �� ����
  if FileExists(ProgramsPath + OLDCommandFileName) then
  begin
    LoadOLDCommandFileToGrid(ProgramsPath + OLDCommandFileName, CommandSGrid);
    DeleteFile(ProgramsPath + OLDCommandFileName);
    SaveCommandDataStringGrid(WorkPath + CommandGridFile, CommandSGrid);
  end
  else
    LoadCommandDataStringGrid(WorkPath + CommandGridFile, CommandSGrid);
  // ������ ������ ������
  ReplaceSGrid := TStringGrid.Create(nil);
  if EnableTextReplace then
    LoadReplaceDataStringGrid(WorkPath + ReplaceGridFile, ReplaceSGrid);
  // ������ ������ ��� ������� ����
  TextToSpeechSGrid := TStringGrid.Create(nil);
  if EnableTextToSpeech then
  begin
    LoadTextToSpeechDataStringGrid(WorkPath + TextToSpeechGridFile, TextToSpeechSGrid);
    if TextToSpeechEngine = 0 then // ���� Microsoft SAPI
      SAPIActivate;
  end;
  // ����-��������� ������
  if MaxLevelOnAutoControl then
    StartNULLRecord;
  // ���� �������������
  CurrentSpeechRecognizeLang := DefaultSpeechRecognizeLang;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  if not JvThreadRecognize.Terminated then
    JvThreadRecognize.Terminate;
  while not (JvThreadRecognize.Terminated) do
  begin
    Sleep(1);
    Forms.Application.ProcessMessages;
  end;
  if FileExists(OutFileName) then
    DeleteFile(OutFileName);
  // �������������� ���. ������
  UnRegisterHotKeys;
  // �����������������������
  CommandSGrid.Free;
  ReplaceSGrid.Free;
  SAPIDeactivate;
  TextToSpeechSGrid.Free;
  // ��������� ����
  CloseLogFile;
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := ((MSpeechMainFormHidden) or SessionEnding);
  if not CanClose then
  begin
    MSpeechTray.HideMainForm;
    MSpeechMainFormHidden := True;
    MSpeechPopupMenu.Items[0].Caption := GetLangStr('MSpeechPopupMenuShow');
  end;
end;

procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    MSpeechTray.HideMainForm;
    MSpeechMainFormHidden := True;
    MSpeechPopupMenu.Items[0].Caption := GetLangStr('MSpeechPopupMenuShow');
  end;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  // ������������ ����
  AlphaBlend := AlphaBlendEnable;
  AlphaBlendValue := AlphaBlendEnableValue;
end;

procedure TMainForm.SettingsButtonClick(Sender: TObject);
begin
  if not SettingsForm.Visible then
    SettingsForm.Show
  else
    SettingsForm.Position := poMainFormCenter;
end;

procedure TMainForm.MSpeechAboutClick(Sender: TObject);
begin
  AboutForm.Show;
end;

procedure TMainForm.MSpeechExitClick(Sender: TObject);
begin
  MSpeechMainFormHidden := True;
  Close;
end;

procedure TMainForm.MSpeechSettingsClick(Sender: TObject);
begin
  MSpeechTray.ShowMainForm;
  MSpeechMainFormHidden := False;
  MSpeechPopupMenu.Items[0].Caption := GetLangStr('MSpeechPopupMenuHide');
  SettingsButtonClick(SettingsButton);
end;

procedure TMainForm.MSpeechShowLogClick(Sender: TObject);
begin
  LogForm.Show;
end;

{ ���� �� ������ ������/�������� ������������ ���� � ���� }
procedure TMainForm.MSpeechTrayDblClick(Sender: TObject);
begin
  if MSpeechMainFormHidden then
  begin
    MSpeechTray.ShowMainForm;
    MSpeechMainFormHidden := False;
    MSpeechPopupMenu.Items[0].Caption := GetLangStr('MSpeechPopupMenuHide');
  end
  else
  begin
    Application.Minimize;
    MSpeechTray.HideMainForm;
    MSpeechMainFormHidden := True;
    MSpeechPopupMenu.Items[0].Caption := GetLangStr('MSpeechPopupMenuShow');
  end;
end;

procedure TMainForm.MSpeechTrayStartup(Sender: TObject; var ShowMainForm: Boolean);
begin
  ShowMainForm := False;
  MSpeechMainFormHidden := True;
end;

procedure TMainForm.FastGainIndicatorGainData(Sender: TComponent);
begin
  try
    ProgressBar.Position := FastGainIndicator.GainValue;
    if not NULLOutStart then
    begin
      if FastGainIndicator.GainValue < MinLevelOnAutoRecognize then
        Inc(FLACDoneCnt);
      SettingsForm.StaticTextMinLevel.Caption := IntToStr(FastGainIndicator.GainValue);
      SettingsForm.StaticTextMinLevelInterrupt.Caption := IntToStr(FLACDoneCnt);
      if (StopRecordAction >= 0) and (StopRecordAction < 2) then
      begin
        if FLACDoneCnt >= MinLevelOnAutoRecognizeInterrupt then
          StopButton.Click;
      end;
    end
    else
    begin
      if FastGainIndicator.GainValue > MaxLevelOnAutoRecord then
        Inc(NULLOutDoneCnt);
      SettingsForm.StaticTextMaxLevelInterrupt.Caption := IntToStr(NULLOutDoneCnt);
      if NULLOutDoneCnt >= MaxLevelOnAutoRecordInterrupt then
        StartButton.Click;
    end;
  except
    on e: Exception do
    begin
      if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': ' + '����������� ���������� � ��������� FastGainIndicatorGainData - ' + e.Message);
      Exit;
    end;
  end;
end;

procedure TMainForm.FLACOutDone(Sender: TComponent);
begin
  FLACDoneCnt := 0;
  SaveFLACDone := True;
  if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': ���� ' + OutFileName + ' ��������.');
  if not StartSaveSettings then
  begin
    if (StopRecordAction = 1) or (StopRecordAction = 3) then
    begin
      if StopRecord then
        StartRecognize;
    end;
  end;
end;

procedure TMainForm.FLACOutThreadException(Sender: TComponent);
begin
  if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': ������ ������ � ���� ' + OutFileName);
  FLACOut.Stop;
  MSpeechTray.IconIndex := 5;
  StartButton.Enabled := True;
  StopButton.Enabled := False;
  StopRecord := True;
end;

procedure TMainForm.AboutButtonClick(Sender: TObject);
begin
  AboutForm.Show;
end;

procedure TMainForm.Filters;
begin
  if EnableFilters then
  begin
    if FilterType = 0 then // Sinc Filter
    begin
      VoiceFilterOff;
      SyncFilterOff;
      SyncFilterOn;
    end
    else if FilterType = 1 then  // Voice Filter
    begin
      SyncFilterOff;
      VoiceFilterOff;
      VoiceFilterOn;
    end
    else
    begin
      SyncFilterOff;
      VoiceFilterOff;
    end;
  end
  else
  begin
    SyncFilterOff;
    VoiceFilterOff;
  end;
end;

procedure TMainForm.SyncFilterOn;
begin
  SincFilter := TSincFilter.Create(nil);
  SincFilter.Input := DXAudioIn;
  SincFilter.FilterType := TFilterType(SincFilterType);
  SincFilter.LowFreq := SincFilterLowFreq;
  SincFilter.HighFreq := SincFilterHighFreq;
  SincFilter.KernelWidth := SincFilterKernelWidth;
  SincFilter.WindowType := TFilterWindowType(SincFilterWindowType);
  FastGainIndicator.Input := SincFilter;
end;

procedure TMainForm.SyncFilterOff;
begin
  FastGainIndicator.Input := DXAudioIn;
  if Assigned(SincFilter) then
  begin
    SincFilter.Free;
    SincFilter := nil;
  end;
end;

procedure TMainForm.VoiceFilterOn;
begin
  try
    VoiceFilter := TVoiceFilter.Create(nil);
    VoiceFilter.Input := DXAudioIn;
    VoiceFilter.EnableAGC := VoiceFilterEnableAGC;
    VoiceFilter.EnableNoiseReduction := VoiceFilterEnableNoiseReduction;
    VoiceFilter.EnableVAD := VoiceFilterEnableVAD;
    FastGainIndicator.Input := VoiceFilter;
  except
    on e: Exception do
    begin
      if e.Message = 'TVoiceFilter component requires Windows Vista or later version' then
      begin
        VoiceFilterOff();
        MsgInf(ProgramsName, Format(GetLangStr('MsgInf9'), [#13]))
      end;
    end;
  end;
end;

procedure TMainForm.VoiceFilterOff;
begin
  FastGainIndicator.Input := DXAudioIn;
  if Assigned(VoiceFilter) then
  begin
    VoiceFilter.Free;
    VoiceFilter := nil;
  end;
end;

procedure TMainForm.StartButtonClick(Sender: TObject);
begin
  EnableSendText := ReadCustomINI(WorkPath, 'SendText', 'EnableSendText', False);
  EnableExecCommand := ReadCustomINI(WorkPath, 'Main', 'EnableExecCommand', True);
  Start();
end;

procedure TMainForm.Start;
begin
  SaveFLACDone := False;
  StopRecord := False;
  FLACDoneCnt := 0;
  StopNULLRecord;
  if not MaxLevelOnAutoControl then
    StartRecord;
end;

procedure TMainForm.StopButtonClick(Sender: TObject);
begin
  MSpeechTray.IconIndex := 0;
  StartButton.Enabled := True;
  StopButton.Enabled := False;
  StopRecord := True;
  FLACOut.Stop;
  if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': ������� ������ �� ��������� ������.');
end;

procedure TMainForm.StartNULLRecord;
begin
  if NULLOutStart then
    StopNULLRecord;
  if MaxLevelOnAutoControl then
  begin
    try
      NULLOut.Input := FastGainIndicator;
      NULLOut.Run;
    except
    end;
    NULLOutStart := True;
  end
end;

procedure TMainForm.StopNULLRecord;
begin
  if NULLOutStart then
  begin
    NULLOut.Stop(True);
    NULLOutStart := False;
  end;
end;

procedure TMainForm.NULLOutDone(Sender: TComponent);
begin
  NULLOutDoneCnt := 0;
  if MaxLevelOnAutoControl then
    StartRecord;
end;

procedure TMainForm.NULLOutThreadException(Sender: TComponent);
begin
  if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': ������ ������ � �������');
  StopNULLRecord;
  MSpeechTray.IconIndex := 5;
end;

procedure TMainForm.StartRecord;
begin
  if FileExists(ProgramsPath + 'libFLAC.dll') then
  begin
    MSpeechTray.IconIndex := 1;
    StartButton.Enabled := False;
    StopButton.Enabled := True;
    if FileExists(OutFileName) then
      DeleteFile(OutFileName);
    //FLACOut.Input := FastGainIndicator;
    FLACOut.FileName := OutFileName;
    FLACOut.Run;
    if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': ������ ������ � ���� ' + OutFileName);
  end
  else
    if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': �� ������� ���������� libFLAC.dll');
end;

{ ������ ������ �������� ������ � ���������� ������� }
procedure TMainForm.StartRecognize;
begin
  if not JvThreadRecognize.Terminated then
      JvThreadRecognize.Terminate;
  if FileExists(OutFileName) then
    JvThreadRecognize.Execute(Self)
  else
  begin
    if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': StartRecognize - ������ ������ ����� ' + OutFileName);
    StartButton.Enabled := True;
    StopButton.Enabled := False;
  end;
end;

{ ����� �������� ������ � ���������� ������� }
procedure TMainForm.JvThreadRecognizeExecute(Sender: TObject; Params: Pointer);
var
  Stream: TFileStream;
  Str: String;
  JSON, Jo: TJSONobject;
  ReplStr: String;
  RecognizeConfidence: Real;
  StrList: TStringList;
  StrListCnt: Integer;
  RecognizeStr: String;
  K: Integer;
  RowN: Integer;
begin
  if GetFileSize(OutFileName) > 0 then
  begin
    MSpeechTray.IconIndex := 4;
    StrList := TStringList.Create;
    StrList.Clear;
    StartButton.Enabled := False;
    StopButton.Enabled := False;
    if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': �����, ���� �������� ������� � Google...');
    try
      Stream := TFileStream.Create(OutFileName, fmOpenRead or fmShareDenyWrite);
    except
      on e: Exception do
      begin
        MSpeechTray.IconIndex := 5;
        if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': ' + '����� JvThreadRecognize �� ����� �������� ������ � ����� ' + OutFileName + ' ������: ' + e.Message);
      end;
    end;
    try
      HTTPPostFile('https://www.google.com/speech-api/v1/recognize?xjerr=1&client=chromium&lang='+CurrentSpeechRecognizeLang, 'userfile', OutFileName, Stream, StrList);
    finally
      Stream.Free;
    end;
    if JvThreadRecognize.Terminated then
    begin
      StrList.Free;
      Exit;
    end;
    {$IFDEF DEBUG}
    WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': DEBUG_MODE: ' + 'StrList.Count = ' + IntToStr(StrList.Count));
    for StrListCnt := 0 to StrList.Count-1 do
      WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': DEBUG_MODE: ' + 'StrList['+IntToStr(StrListCnt)+'] = ' + UTF8ToString(StrList[StrListCnt]));
    {$ENDIF}
    for StrListCnt := 0 to StrList.Count-1 do
    begin
      Str := UTF8ToString(StrList[StrListCnt]);
      if Length(Str) > 0  then
      begin
        MSpeechTray.IconIndex := 4;
        if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': JSON ����� ������� Google = ' + Trim(Str));
        try
          JSON := TJSONObject.Create(Str);
        except
          on e: Exception do
          begin
            MSpeechTray.IconIndex := 5;
            if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': ' + '����������� ���������� � ������ JvThreadRecognize - ' + e.Message);
            ShowBalloonHint(ProgramsName, GetLangStr('MsgErr3'),  bitError);
            JSON.Free;
            StopNULLRecord;
            if MaxLevelOnAutoControl then
              StartNULLRecord;
            Exit;
          end;
        end;
        try
          MSpeechTray.IconIndex := 4;
          // ������ �� ����������
          if JSON.optString('status') = '5' then
          begin
            MSpeechTray.IconIndex := 2;
            if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': ' + GetLangStr('MsgInf2'));
            TextToSpeech(mRecordingNotRecognized);
            ShowBalloonHint(ProgramsName, GetLangStr('MsgInf2'), bitWarning);
            StopNULLRecord;
            if MaxLevelOnAutoControl then
              StartNULLRecord;
          end
          // ������ ������� ����������
          else if JSON.optString('status') = '0' then
          begin
            MSpeechTray.IconIndex := 4;
            ReplStr := StringReplace(JSON.getString('hypotheses'),'[','',[RFReplaceall]);
            ReplStr := StringReplace(ReplStr,']','',[RFReplaceall]);
            Jo := TJSONObject.Create(ReplStr);
            try
              RecognizeStr := Jo.getString('utterance');
              if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': ������������ ������ = ' + RecognizeStr);
              if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': �����: '+ Jo.getString('utterance'));
              FormatSettings.DecimalSeparator := '.';
              RecognizeConfidence := (StrToFloat(Jo.getString('confidence')))*100;
              if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': ������������� ������������� = ' + FloatToStr(RecognizeConfidence) + '%');
              // ������ ������
              if EnableText�orrection then
              begin
                if EnableTextReplace then
                begin
                  for RowN := 0 to ReplaceSGrid.RowCount-1 do
                  begin
                    RecognizeStr := StringReplace(RecognizeStr, ReplaceSGrid.Cells[0,RowN], ReplaceSGrid.Cells[1,RowN], [rfReplaceAll]);
                  end;
                end;
                if FirstLetterUpper then
                begin
                  if CurrentSpeechRecognizeLang = 'ru-RU' then
                    RecognizeStr := RusLowercaseToUppercase(RecognizeStr)
                  else
                    RecognizeStr := EngLowercaseToUppercase(RecognizeStr);
                end;
              end;
              // �������� ������
              if EnableSendText then
              begin // �������� ������ � ���������� ���� ���������
                if EnableSendTextInactiveWindow then
                begin
                  if OnSendMessage(InactiveWindowCaption, RecognizeStr) then
                    if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': ����� ������� ������� WM_COPYDATA.')
                  else
                    if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': ��������� � ���������� ' + InactiveWindowCaption + ' �� �������.')
                end
                else
                begin // �������� ������ � �������� ���� ���������
                  if ClassNameReciver <> '' then
                  begin // ���� ������ ����� ���� �����
                    if DetectMethodSendingText(MethodSendingText) = mWM_SETTEXT then
                      InsTextWnd(ClassNameReciver, RecognizeStr)
                    else if DetectMethodSendingText(MethodSendingText) = mWM_PASTE then
                      CopyPasteTextWnd(ClassNameReciver, RecognizeStr)
                    else if DetectMethodSendingText(MethodSendingText) = mWM_CHAR then
                      SetCharTextWnd(RecognizeStr)
                    else if DetectMethodSendingText(MethodSendingText) = mWM_PASTE_MOD then
                      CopyPasteTextWnd(ClassNameReciver, RecognizeStr)
                  end
                  else
                  begin // ���� ����� ���� ����� �� ������
                    if DetectMethodSendingText(MethodSendingText) = mWM_SETTEXT then
                      InsTextWnd(RecognizeStr)
                    else if DetectMethodSendingText(MethodSendingText) = mWM_PASTE then
                      CopyPasteTextWnd(RecognizeStr)
                    else if DetectMethodSendingText(MethodSendingText) = mWM_CHAR then
                      SetCharTextWnd(RecognizeStr)
                    else if DetectMethodSendingText(MethodSendingText) = mWM_PASTE_MOD then
                      CopyPasteTextWnd(RecognizeStr)
                  end;
                end;
              end;
              // End
              // ���������� ������
              if EnableExecCommand then
              begin
                K := CommandSGrid.Cols[0].IndexOf(RecognizeStr);
                if K <> -1 then // ������� ������� � ������
                begin
                  if DetectCommandTypeName(CommandSGrid.Cells[2,K]) = mExecPrograms then
                  begin
                    if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': ' + '��������� ���������: ' + CommandSGrid.Cells[1,K]);
                    //Beep;
                    if (ExtractFileExt(CommandSGrid.Cells[1,K]) = '.cmd') or (ExtractFileExt(CommandSGrid.Cells[1,K]) = '.bat') then
                      ShellExecute(0, 'open', PWideChar(CommandSGrid.Cells[1,K]), nil, nil, SW_HIDE)
                    else
                      ShellExecute(0, 'open', PWideChar(CommandSGrid.Cells[1,K]), nil, nil, SW_SHOWNORMAL);
                  end
                  else if DetectCommandTypeName(CommandSGrid.Cells[2,K]) = mClosePrograms then
                  begin
                    if IsProcessRun(ExtractFileName(CommandSGrid.Cells[1,K])) then
                    begin
                      EndProcess(GetProcessID(ExtractFileName(CommandSGrid.Cells[1,K])), WM_CLOSE);
                      if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': ' + '��������� ���������: ' + CommandSGrid.Cells[1,K]);
                      Beep;
                    end;
                  end
                  else if DetectCommandTypeName(CommandSGrid.Cells[2,K]) = mKillPrograms then
                  begin
                    if IsProcessRun(ExtractFileName(CommandSGrid.Cells[1,K])) then
                    begin
                      KillTask(ExtractFileName(CommandSGrid.Cells[1,K]));
                      if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': ' + '������� ���������: ' + CommandSGrid.Cells[1,K]);
                      Beep;
                    end;
                  end
                  else if DetectCommandTypeName(CommandSGrid.Cells[2,K]) = mTextToSpeech then
                    TextToSpeech(CommandSGrid.Cells[1,K]);
                end
                else
                begin
                  if DefaultCommandExec  <> '' then // ��������� ������� �� ���������
                  begin
                    if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': ��������� ������� ��-��������� = ' + DefaultCommandExec);
                    if (ExtractFileExt(DefaultCommandExec) = '.cmd') or (ExtractFileExt(DefaultCommandExec) = '.bat') then
                      ShellExecute(0, 'open', PWideChar(DefaultCommandExec), nil, nil, SW_HIDE)
                    else
                      ShellExecute(0, 'open', PWideChar(DefaultCommandExec), nil, nil, SW_SHOWNORMAL);
                  end
                  else
                  begin
                    if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': ' + GetLangStr('MsgInf3'));
                    TextToSpeech(mCommandNotFound);
                    ShowBalloonHint(ProgramsName, GetLangStr('MsgInf3'));
                  end;
                  StopNULLRecord;
                  if MaxLevelOnAutoControl then
                    StartNULLRecord;
                end;
              end;
              // ��������� ������
              if JvThreadRecognize.Terminated then
              begin
                if (Assigned(JSON)) then JSON.Free;
                if (Assigned(Jo)) then Jo.Free;
                Exit;
              end;
              StopNULLRecord;
              if MaxLevelOnAutoControl then
                StartNULLRecord;
            finally
              Jo.Free;
            end;
          end;
        finally
          JSON.Free;
        end;
      end
      else
      begin
        if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': ' + GetLangStr('MsgInf4'));
        TextToSpeech(mErrorGoogleCommunication);
        ShowBalloonHint(ProgramsName, GetLangStr('MsgInf4'), bitError);
      end;
    end;
    StrList.Free;
  end
  else
    if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': JvThreadRecognizeExecute - ������ ������ ����� ' + OutFileName);
end;

procedure TMainForm.JvThreadRecognizeFinish(Sender: TObject);
begin
  StartButton.Enabled := True;
  StopButton.Enabled := False;
  MSpeechTray.IconIndex := 0;
  CloseLogFile;
  if LogForm.Showing then
    SendMessage(LogFormHandle, WM_UPDATELOG, 0, 0);
end;

{ �������� flac-����� }
function TMainForm.HTTPPostFile(Const URL, FieldName, FileName: String; Const Data: TStream; Const ResultData: TStrings): Boolean;
const
  CRLF = #$0D + #$0A;
var
  HTTP: THTTPSend;
  Bound, Str: String;
begin
  Bound := IntToHex(Random(MaxInt), 8) + '_Synapse_boundary';
  HTTP := THTTPSend.Create;
  try
    if UseProxy then
    begin
      HTTP.ProxyHost := ProxyAddress;
      if ProxyPort <> '' then
        HTTP.ProxyPort := ProxyPort
      else
        HTTP.ProxyPort := '3128';
      if ProxyAuth then
      begin
        HTTP.ProxyUser := ProxyUser;
        HTTP.ProxyPass := ProxyUserPasswd;
      end;
      if EnableLogs then WriteInLog(WorkPath, Format('%s: ������� ��������� ������ ����� Proxy-������ (�����: %s, ����: %s, �����: %s, ������: %s)',
                 [FormatDateTime('dd.mm.yy hh:mm:ss', Now), HTTP.ProxyHost, HTTP.ProxyPort, HTTP.ProxyUser, {$IFDEF DEBUG}HTTP.ProxyPass{$ELSE}IfThen(HTTP.ProxyPass='', '', '******'){$ENDIF}]));
    end;
    Str := '--' + Bound + CRLF;
    Str := Str + 'content-disposition: form-data; name="' + FieldName + '";';
    Str := Str + ' filename="' + FileName + '"' + CRLF;
    Str := Str + 'Content-Type: audio/x-flac; rate='+IntToStr(DXAudioIn.InSampleRate) + CRLF + CRLF;
    HTTP.Document.Write(Pointer(Str)^, Length(Str));
    HTTP.Document.CopyFrom(Data, 0);
    Str := CRLF + '--' + Bound + '--' + CRLF;
    HTTP.Document.Write(Pointer(Str)^, Length(Str));
    HTTP.MimeType := 'audio/x-flac; rate='+IntToStr(DXAudioIn.InSampleRate);
    HTTP.UserAgent := 'Mozilla/5.0 (Windows NT 6.2; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/30.0.1599.17 Safari/537.36';
    Result := HTTP.HTTPMethod('POST', URL);
    ResultData.LoadFromStream(HTTP.Document);
    {$IFDEF DEBUG}
    WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': DEBUG_MODE: ' + 'HTTP.ResultString = ' + HTTP.ResultString);
    WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': DEBUG_MODE: ' + 'ResultData.Count = ' + IntToStr(ResultData.Count));
    {$ENDIF}
  finally
    HTTP.Free;
  end;
end;

function TMainForm.HTTPGetSize(var HTTP: THTTPSend; URL: String): int64;
var
  I: Integer;
  Size: String;
  Ch: Char;
begin
  Result := -1;
  HTTP.UserAgent := 'Mozilla/5.0 (Windows NT 6.2; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/30.0.1599.17 Safari/537.36';
  if HTTP.HTTPMethod('HEAD',URL) then
  begin
    for I := 0 to HTTP.Headers.Count - 1 do
    begin
      if Pos('content-length', lowercase(HTTP.Headers[I])) > 0 then
      begin
        Size := '';
        for Ch in HTTP.Headers[i]do
          if Ch in ['0'..'9'] then
            Size := Size + Ch;
        Result := StrToInt(Size) + Length(HTTP.Headers.Text);
        Break;
      end;
    end;
  end;
end;

function TMainForm.HTTPGetSize(URL: String): int64;
const
  CRLF = #$0D + #$0A;
var
  Bound, Str, Size: String;
begin
  Result := -1;
  with THTTPSend.Create do
  begin
    Document.Clear;
    Headers.Clear;
    //MimeType := 'application/x-www-form-urlencoded';
    UserAgent := 'Mozilla/5.0 (Windows NT 6.2; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/30.0.1599.17 Safari/537.36';
    if HTTPMethod('HEAD', URL) then
    begin
      //if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': ' + 'HTTPGetSize - ��������� ������� Headers = ' + Headers.Text);
      HeadersToList(Headers);
      Size := Headers.Values['Content-Length'];
      Result := StrToIntDef(Size, -1);
      if Result > -1 then
        Result := Result + Length(Headers.Text);
      //if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': ' + 'HTTPGetSize - ��������� ������� ResultString = ' + ResultString);
    end;
  end;
end;

{ �������� ���������� ������� � ���� � ����� mp3-����� }
function TMainForm.GoogleTextToSpeech(const Text, MP3FileName: String): Boolean;
const
  CRLF = #$0D + #$0A;
var
  HTTP: THTTPSend;
  MaxSize: int64;
begin
  HTTP := THTTPSend.Create;
  try
    if UseProxy then
    begin
      HTTP.ProxyHost := ProxyAddress;
      if ProxyPort <> '' then
        HTTP.ProxyPort := ProxyPort
      else
        HTTP.ProxyPort := '3128';
      if ProxyAuth then
      begin
        HTTP.ProxyUser := ProxyUser;
        HTTP.ProxyPass := ProxyUserPasswd;
      end;
      if EnableLogs then WriteInLog(WorkPath, Format('%s: ������� ��������� ������ ����� Proxy-������ (�����: %s, ����: %s, �����: %s, ������: %s)',
                 [FormatDateTime('dd.mm.yy hh:mm:ss', Now), HTTP.ProxyHost, HTTP.ProxyPort, HTTP.ProxyUser, HTTP.ProxyPass]));
    end;
    //MaxSize := HTTPGetSize(HTTP, 'http://translate.google.com/translate_tts?tl=' + GoogleTL + '&q='+WideStringToUTF8(Text));
    MaxSize := HTTPGetSize('http://translate.google.com/translate_tts?ie=UTF-8&total=1&idx=100&textlen=100&prev=input&tl=' + GoogleTL + '&q='+WideStringToUTF8(StringReplace(Text, ' ', '%20', [rfReplaceAll])));
    if MaxSize > 0 then
    begin
      if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': ' + 'GoogleTextToSpeech - ������ ������ = ' + inttostr(MaxSize) + ' ����.');
      if FileExists(MP3FileName) then
        DeleteFile(MP3FileName);
      HTTP.Document.Clear;
      HTTP.Headers.Clear;
      HTTP.MimeType := 'application/x-www-form-urlencoded';
      HTTP.UserAgent := 'Mozilla/5.0 (Windows NT 6.2; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/30.0.1599.17 Safari/537.36';
      Result := HTTP.HTTPMethod('GET', 'http://translate.google.com/translate_tts?ie=UTF-8&total=1&idx=100&textlen=100&prev=input&tl=' + GoogleTL + '&q='+WideStringToUTF8(StringReplace(Text, ' ', '%20', [rfReplaceAll])));
      if LowerCase(HTTP.ResultString) = 'ok' then
      begin
        HTTP.Document.SaveToFile(MP3FileName);
        if FileExists(MP3FileName) then
        begin
          MP3In.FileName := MP3FileName;
          if MP3In.Valid then
          begin
            DXAudioOut.Run;
            DeleteFile(MP3FileName);
          end;
        end;
      end
      else
      begin
        if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': ' + 'GoogleTextToSpeech - ������ �������� ������ � Google (' + HTTP.ResultString + ')');
        ShowBalloonHint(ProgramsName, Format(GetLangStr('MsgErr12'), [HTTP.ResultString]),  bitError);
      end;
    end;
  finally
    HTTP.Free;
  end;
end;

{ ������������ ���������� ������� ������� }
procedure TMainForm.RegisterHotKeys;
begin
  // ����� ������ � ��������� ������
  if (StartRecordHotKey <> '') and GlobalHotKeyEnable then
  begin
    with JvStartRecordHotKey do
    begin
      HotKey := TextToShortCut(StartRecordHotKey);
      Active := True;
    end;
  end
  else
    JvStartRecordHotKey.Active := False;
  // ����� ������ ��� �������� ������
  if (StartRecordWithoutSendTextHotKey <> '') and GlobalHotKeyEnable then
  begin
    with JvStartRecordWithoutSendTextHotKey do
    begin
      HotKey := TextToShortCut(StartRecordWithoutSendTextHotKey);
      Active := True;
    end;
  end
  else
    JvStartRecordWithoutSendTextHotKey.Active := False;
  // ����� ������ ��� ���������� ������
  if (StartRecordWithoutExecCommandHotKey <> '') and GlobalHotKeyEnable then
  begin
    with JvStartRecordWithoutExecCommandHotKey do
    begin
      HotKey := TextToShortCut(StartRecordWithoutExecCommandHotKey);
      Active := True;
    end;
  end
  else
    JvStartRecordWithoutExecCommandHotKey.Active := False;
  // ������������ ������ �������������
  if (SwitchesLanguageRecognizeHotKey <> '') and GlobalHotKeyEnable then
  begin
    with JvSwitchesLanguageRecognizeHotKey do
    begin
      HotKey := TextToShortCut(SwitchesLanguageRecognizeHotKey);
      Active := True;
    end;
  end
  else
    JvSwitchesLanguageRecognizeHotKey.Active := False;
end;

{ ��������������� ���������� ������� ������� }
procedure TMainForm.UnRegisterHotKeys;
begin
  if Assigned(JvStartRecordHotKey) then
    JvStartRecordHotKey.Free;
  if Assigned(JvStartRecordWithoutSendTextHotKey) then
    JvStartRecordWithoutSendTextHotKey.Free;
  if Assigned(JvStartRecordWithoutExecCommandHotKey) then
    JvStartRecordWithoutExecCommandHotKey.Free;
  if Assigned(JvSwitchesLanguageRecognizeHotKey) then
    JvSwitchesLanguageRecognizeHotKey.Free;
end;

{ ������ ������� ������� }
procedure TMainForm.DoHotKey(Sender:TObject);
begin
  // ����� ������ � ��������� ������
  if ShortCutToText((Sender as TJvApplicationHotKey).HotKey) = StartRecordHotKey then
  begin
    if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': DoHotKey - ������ ������� '+ShortCutToText((Sender as TJvApplicationHotKey).HotKey));
    if StopRecord then
      StartButton.Click
    else
      StopButton.Click;
  end;
  // ����� ������ ��� �������� ������
  if ShortCutToText((Sender as TJvApplicationHotKey).HotKey) = StartRecordWithoutSendTextHotKey then
  begin
    if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': DoHotKey - ������ ������� '+ShortCutToText((Sender as TJvApplicationHotKey).HotKey));
    if StopRecord then // �������� ������
    begin
      EnableExecCommand := ReadCustomINI(WorkPath, 'Main', 'EnableExecCommand', True);
      if EnableSendText then
        EnableSendText := False;
      Start();
    end
    else
      StopButton.Click;
  end;
  // ����� ������ ��� ���������� ������
  if ShortCutToText((Sender as TJvApplicationHotKey).HotKey) = StartRecordWithoutExecCommandHotKey then
  begin
    if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': DoHotKey - ������ ������� '+ShortCutToText((Sender as TJvApplicationHotKey).HotKey));
    if StopRecord then // �������� ������
    begin
      if EnableExecCommand then
        EnableExecCommand := False;
      Start();
    end
    else
      StopButton.Click;
  end;
  // ����� ����� �������������
  if ShortCutToText((Sender as TJvApplicationHotKey).HotKey) = SwitchesLanguageRecognizeHotKey then
  begin
    if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': DoHotKey - ������ ������� '+ShortCutToText((Sender as TJvApplicationHotKey).HotKey));
    if CurrentSpeechRecognizeLang = DefaultSpeechRecognizeLang then
      CurrentSpeechRecognizeLang := SecondSpeechRecognizeLang
    else
      CurrentSpeechRecognizeLang := DefaultSpeechRecognizeLang;
  end;
end;

{ ���������� ���������� ��������� � ���� }
procedure TMainForm.ShowBalloonHint(BalloonTitle, BalloonMsg: WideString);
begin
  if ShowTrayEvents then
    MSpeechTray.ShowBalloonHint(BalloonTitle, BalloonMsg, bitInfo, 10);
end;

{ ���������� ���������� ��������� � ���� � ��������� ��� ���� }
procedure TMainForm.ShowBalloonHint(BalloonTitle, BalloonMsg: WideString; BalloonIconType: TBalloonHintIcon);
begin
  if ShowTrayEvents then
    MSpeechTray.ShowBalloonHint(BalloonTitle, BalloonMsg, BalloonIconType, 10);
end;

{ ������� ��������� ������ �� ���� ��������� ����, ��������� WM_GETTEXT }
function TMainForm.GetTextWnd(MyClassName: String): String;
var
  hFocusedWnd : HWND;
  dwThreadID : DWORD;
  dwBytesNeeded : DWord;
  pszWindowText : PChar;
  pszClassName: Array [0..255] of Char;
begin
  Result := '';
  dwThreadID := GetWindowThreadProcessId(GetForegroundWindow, nil);
  if dwThreadID <> 0 then
  begin
    if AttachThreadInput(GetCurrentThreadId, dwThreadID, True) then
    begin
      hFocusedWnd := GetFocus;
      if hFocusedWnd <> 0 then
      begin
        dwBytesNeeded := SendMessage(hFocusedWnd, WM_GETTEXTLENGTH, 0, 0);
        if dwBytesNeeded > 0 then
        begin
          GetMem(pszWindowText, dwBytesNeeded + 1);
          try
            ZeroMemory(pszWindowText, dwBytesNeeded + 1);
            if Boolean(GetClassName(hFocusedWnd, pszClassName, 256)) then
            begin
              if String(pszClassName) = MyClassName then
              begin
                if SendMessage(hFocusedWnd, WM_GETTEXT, dwBytesNeeded + 1, lParam(pszWindowText)) > 0 then
                  Result := pszWindowText;
              end;
            end;
          finally
            FreeMem(pszWindowText);
          end;
        end;
      end;
      AttachThreadInput(GetCurrentThreadId, dwThreadID, False);
    end;
  end;
end;

{ ��������� ������ ������ � ���� ��������� ����, ��������� WM_SETTEXT }
procedure TMainForm.SetTextWnd(MyClassName, MyText: String);
var
 hFocusedWnd : HWND;
 dwThreadID : DWORD;
 pszClassName: Array [0..255] of Char;
begin
  dwThreadID := GetWindowThreadProcessId(GetForegroundWindow, nil);
  if dwThreadID <> 0 then
  begin
    if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': SetTextWnd (2) - ������ �������.');
    if AttachThreadInput(GetCurrentThreadId, dwThreadID, True) then
    begin
      if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': SetTextWnd (2) - ����������� �������.');
      hFocusedWnd := GetFocus;
      if hFocusedWnd <> 0 then
      begin
        if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': SetTextWnd (2) - ������ �����.');
        if Boolean(GetClassName(hFocusedWnd, pszClassName, 256)) then
        begin
          if String(pszClassName) = MyClassName then
          begin
            if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': SetTextWnd (2) - ������ ����� ' + MyClassName);
            if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': SetTextWnd (2) - ���������� �������.');
            if SendMessage(hFocusedWnd, WM_SETTEXT, 0, lParam(PChar(MyText))) > 0 then
              if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': SetTextWnd (2) - ������� WM_SETTEXT ������� ��������.');
          end;
        end;
      end;
      AttachThreadInput(GetCurrentThreadId, dwThreadID, False);
    end;
  end;
end;

{ ��������� ������ ������ � ���� ��������� ����, ��������� WM_SETTEXT }
procedure TMainForm.SetTextWnd(MyText: String);
var
 hFocusedWnd : HWND;
 dwThreadID : DWORD;
begin
  dwThreadID := GetWindowThreadProcessId(GetForegroundWindow, nil);
  if dwThreadID <> 0 then
  begin
    if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': SetTextWnd - ������ �������.');
    if AttachThreadInput(GetCurrentThreadId, dwThreadID, True) then
    begin
      hFocusedWnd := GetFocus;
      if hFocusedWnd <> 0 then
      begin
        if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': SetTextWnd - ������ �����.');
        if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': SetTextWnd - ���������� �������.');
        if SendMessage(hFocusedWnd, WM_SETTEXT, 0, lParam(PChar(MyText))) > 0 then
          if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': SetTextWnd - ������� WM_SETTEXT ������� ��������.');
      end;
      AttachThreadInput(GetCurrentThreadId, dwThreadID, False);
    end;
  end;
end;

{ ��������� ���������� ������ � ���� ��������� ����, ��������� EM_SETSEL � EM_REPLACESEL }
procedure TMainForm.InsTextWnd(MyClassName, MyText: String);
var
  hFocusedWnd : HWND;
  dwThreadID : DWORD;
  dwBytesNeeded : DWord;
  pszWindowText : PChar;
  pszClassName: Array [0..255] of Char;
begin
  dwThreadID := GetWindowThreadProcessId(GetForegroundWindow, nil);
  if dwThreadID <> 0 then
  begin
    if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': InsTextWnd (2) - ������ �������.');
    if AttachThreadInput(GetCurrentThreadId, dwThreadID, True) then
    begin
      if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': InsTextWnd (2) - ����������� �������.');
      hFocusedWnd := GetFocus;
      if hFocusedWnd <> 0 then
      begin
        if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': InsTextWnd (2) - ������ �����.');
        dwBytesNeeded := SendMessage(hFocusedWnd, WM_GETTEXTLENGTH, 0, 0);
        if dwBytesNeeded > 0 then
        begin
          if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': InsTextWnd (2) - dwBytesNeeded > 0');
          GetMem(pszWindowText, dwBytesNeeded + 1);
          try
            ZeroMemory(pszWindowText, dwBytesNeeded + 1);
            if Boolean(GetClassName(hFocusedWnd, pszClassName, 256)) then
            begin
              if String(pszClassName) = MyClassName then
              begin
                if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': InsTextWnd (2) - ������ ����� ' + MyClassName);
                if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': InsTextWnd (2) - ���������� �������.');
                if SendMessage(hFocusedWnd, EM_SETSEL, wParam(dwBytesNeeded), lParam(dwBytesNeeded)) > 0 then
                  if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': InsTextWnd (2) - ������� EM_SETSEL ������� ��������.');
                if SendMessage(hFocusedWnd, EM_REPLACESEL, 0, lParam(PChar(MyText))) > 0 then
                  if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': InsTextWnd (2) - ������� EM_REPLACESEL ������� ��������.');
              end;
            end;
          finally
            FreeMem(pszWindowText);
          end;
        end
        else
          SetTextWnd(MyClassName, MyText);
      end;
      AttachThreadInput(GetCurrentThreadId, dwThreadID, False);
    end;
  end;
end;

{ ��������� ���������� ������ � ���� ��������� ����, ��������� EM_SETSEL � EM_REPLACESEL }
procedure TMainForm.InsTextWnd(MyText: String);
var
  hFocusedWnd : HWND;
  dwThreadID : DWORD;
  dwBytesNeeded : DWord;
  pszWindowText : PChar;
begin
  dwThreadID := GetWindowThreadProcessId(GetForegroundWindow, nil);
  if dwThreadID <> 0 then
  begin
    if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': InsTextWnd - ������ �������.');
    if AttachThreadInput(GetCurrentThreadId, dwThreadID, True) then
    begin
      hFocusedWnd := GetFocus;
      if hFocusedWnd <> 0 then
      begin
        if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': InsTextWnd - ������ �����.');
        dwBytesNeeded := SendMessage(hFocusedWnd, WM_GETTEXTLENGTH, 0, 0);
        if dwBytesNeeded > 0 then
        begin
          GetMem(pszWindowText, dwBytesNeeded + 1);
          try
            ZeroMemory(pszWindowText, dwBytesNeeded + 1);
            if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': InsTextWnd - ���������� �������.');
            if SendMessage(hFocusedWnd, EM_SETSEL, wParam(dwBytesNeeded), lParam(dwBytesNeeded)) > 0 then
              if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': InsTextWnd - ������� EM_SETSEL ������� ��������.');
            if SendMessage(hFocusedWnd, EM_REPLACESEL, 0, lParam(PChar(MyText))) > 0 then
              if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': InsTextWnd - ������� EM_REPLACESEL ������� ��������.');
          finally
            FreeMem(pszWindowText);
          end;
        end
        else
          SetTextWnd(MyText);
      end;
      AttachThreadInput(GetCurrentThreadId, dwThreadID, False);
    end;
  end;
end;

{ ��������� ���������� ������ � ���� ��������� ����, ��������� WM_PASTE }
procedure TMainForm.CopyPasteTextWnd(MyClassName, MyText: String);
var
  hFocusedWnd : HWND;
  dwThreadID : DWORD;
  dwBytesNeeded : DWord;
  //pszWindowText : PChar;
  pszClassName: Array [0..255] of Char;
begin
  dwThreadID := GetWindowThreadProcessId(GetForegroundWindow, nil);
  if dwThreadID <> 0 then
  begin
    if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': CopyPasteTextWnd (2) - ������ �������.');
    if AttachThreadInput(GetCurrentThreadId, dwThreadID, True) then
    begin
      hFocusedWnd := GetFocus;
      if hFocusedWnd <> 0 then
      begin
        if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': CopyPasteTextWnd (2) - ������ �����.');
        if Boolean(GetClassName(hFocusedWnd, pszClassName, 256)) then
        begin
          if String(pszClassName) = MyClassName then
          begin
            if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': CopyPasteTextWnd (2) - ������ ����� ' + MyClassName);
            if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': CopyPasteTextWnd (2) - ���������� �������.');
            Clipboard.Clear;
            Clipboard.AsText := MyText;
            if DetectMethodSendingText(MethodSendingText) = mWM_PASTE then
            begin
              // ����� WM_PASTE
              if SendMessage(hFocusedWnd, WM_PASTE, 0, 0) > 0 then
                if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': CopyPasteTextWnd (2) - ������� WM_PASTE ������� ��������.');
            end
            else if DetectMethodSendingText(MethodSendingText) = mWM_PASTE_MOD then
            begin
              // ���������������� ����� WM_PASTE, ����� �������� ��������� Ctrl+V
              PostMessage(hFocusedWnd, WM_SETFOCUS,0,0);
              keybd_event(VK_CONTROL, MapVirtualKey(VK_CONTROL, 0), 0, 0);
              keybd_event(Ord('V'), MapVirtualKey(Ord('V'), 0), 0, 0);
              keybd_event(Ord('V'), 0, KEYEVENTF_KEYUP, 0);
              keybd_event(VK_CONTROL, MapVirtualKey(VK_CONTROL,0), KEYEVENTF_KEYUP, 0);
              if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': CopyPasteTextWnd - ������� Ctrl+V ������� ��������.');
            end;
          end;
        end;
      end;
      AttachThreadInput(GetCurrentThreadId, dwThreadID, False);
    end;
  end;
end;

procedure TMainForm.CopyPasteTextWnd(MyText: String);
var
  hFocusedWnd : HWND;
  dwThreadID : DWORD;
  dwBytesNeeded : DWord;
  pszWindowText : PChar;
begin
  dwThreadID := GetWindowThreadProcessId(GetForegroundWindow, nil);
  if dwThreadID <> 0 then
  begin
    if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': CopyPasteTextWnd - ������ �������.');
    if AttachThreadInput(GetCurrentThreadId, dwThreadID, True) then
    begin
      hFocusedWnd := GetFocus;
      if hFocusedWnd <> 0 then
      begin
        if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': CopyPasteTextWnd - ������ �����.');
        Clipboard.Clear;
        Clipboard.AsText := MyText;
        if DetectMethodSendingText(MethodSendingText) = mWM_PASTE then
        begin
          // ����� WM_PASTE
          if SendMessage(hFocusedWnd, WM_PASTE, 0, 0) > 0 then
            if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': CopyPasteTextWnd - ������� WM_PASTE ������� ��������.');
        end
        else if DetectMethodSendingText(MethodSendingText) = mWM_PASTE_MOD then
        begin
          // ���������������� ����� WM_PASTE, ����� �������� ��������� Ctrl+V
          PostMessage(hFocusedWnd, WM_SETFOCUS,0,0);
          keybd_event(VK_CONTROL, MapVirtualKey(VK_CONTROL, 0), 0, 0);
          keybd_event(Ord('V'), MapVirtualKey(Ord('V'), 0), 0, 0);
          keybd_event(Ord('V'), 0, KEYEVENTF_KEYUP, 0);
          keybd_event(VK_CONTROL, MapVirtualKey(VK_CONTROL,0), KEYEVENTF_KEYUP, 0);
          if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': CopyPasteTextWnd - ������� Ctrl+V ������� ��������.');
        end;
      end;
      AttachThreadInput(GetCurrentThreadId, dwThreadID, False);
    end;
  end;
end;

{ ��������� ���������� ������ � ���� ��������� ����, ��������� WM_CHAR }
procedure TMainForm.SetCharTextWnd(MyText: String);
var
  hFocusedWnd : HWND;
  dwThreadID : DWORD;
  dwBytesNeeded : DWord;
  pszWindowText : PChar;
  Cnt: Integer;
begin
  dwThreadID := GetWindowThreadProcessId(GetForegroundWindow, nil);
  if dwThreadID <> 0 then
  begin
    if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': SetCharTextWnd - ������ �������.');
    if AttachThreadInput(GetCurrentThreadId, dwThreadID, True) then
    begin
      hFocusedWnd := GetFocus;
      if hFocusedWnd <> 0 then
      begin
        if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': SetCharTextWnd - ������ �����.');
        if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': SetCharTextWnd - ���������� �����...');
        for Cnt := 1 to Length(MyText) do
          PostMessage(hFocusedWnd, WM_CHAR, Word(MyText[Cnt]), 0);
        //PostMessage(hFocusedWnd, WM_KEYDOWN, VK_RETURN, 0);
      end;
      AttachThreadInput(GetCurrentThreadId, dwThreadID, False);
    end;
  end;
end;

{ ����������� ������� WM_MSGBOX ��� ��������� ������������ ���� }
procedure TMainForm.msgBoxShow(var Msg: TMessage);
var
  msgbHandle: HWND;
begin
  msgbHandle := GetActiveWindow;
  if msgbHandle <> 0 then
    MakeTransp(msgbHandle);
end;

{ ��������� SAPI }
function TMainForm.SAPIActivate: Boolean;
begin
  Result := False;
  CoInitialize(nil);
  try
    gpIVTxt := TSpVoice.Create(nil);
    Voices := gpIVTxt.GetVoices('','');
    gpIVTxt.Voice := Voices.Item(SAPIVoiceNum);
    gpIVTxt.Volume := SAPIVoiceVolume;
    gpIVTxt.Rate := SAPIVoiceSpeed;
    CoUninitialize;
    Result := True;
  except
    on e: Exception do
    begin
      if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': ' + '���������� � ��������� SAPIActivate - ' + e.Message);
      Exit;
    end;
  end;
end;

{ ����������� SAPI }
procedure TMainForm.SAPIDeactivate;
begin
  if Assigned(gpIVTxt) then
  begin
    try
      gpIVTxt.Free;
      gpIVTxt := nil;
    except
      on e: Exception do
      begin
        if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': ' + '���������� � ��������� SAPIDeactivate - ' + e.Message);
        Exit;
      end;
    end;
  end;
end;

{ ����� � ����� �� ��������  }
procedure TMainForm.TextToSpeech(EType: TEventsType);
var
  K: Integer;
begin
  if EnableTextToSpeech then
  begin
    if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': ������ SAPITextToSpeech.');
    K := TextToSpeechSGrid.Cols[1].IndexOf(DetectEventsTypeName(EType));
    if K <> -1 then
    begin
      if DetectEventsTypeStatusName(TextToSpeechSGrid.Cells[2,K]) = mEnable then
      begin
        if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': SAPITextToSpeech = ' + TextToSpeechSGrid.Cells[0,K]);
        if TextToSpeechEngine = 0 then // ���� Microsoft SAPI
        begin
          CoInitialize(nil);
          try
            gpIVTxt.Speak(TextToSpeechSGrid.Cells[0,K], SVSFlagsAsync);
            CoUninitialize;
          except
            on e: Exception do
            begin
              if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': ' + '���������� � ��������� TextToSpeech - ' + e.Message);
              CoUninitialize;
              Exit;
            end;
          end;
        end
        else
          GoogleTextToSpeech(TextToSpeechSGrid.Cells[0,K], GetUserTempPath() + 'mspeech-tts.mp3');
      end;
    end;
  end;
end;

{ ����� � �����  }
procedure TMainForm.TextToSpeech(SayText: String);
begin
  if EnableTextToSpeech then
  begin
    if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': ������ TextToSpeech. �������: ' + SayText);
    if TextToSpeechEngine = 0 then // ���� Microsoft SAPI
    begin
      CoInitialize(nil);
      try
        gpIVTxt.Speak(SayText, SVSFlagsAsync);
        CoUninitialize;
      except
        on e: Exception do
        begin
          if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': ' + '���������� � ��������� TextToSpeech - ' + e.Message);
          CoUninitialize;
          Exit;
        end;
      end;
    end
    else
      GoogleTextToSpeech(SayText, GetUserTempPath() + 'mspeech-tts.mp3');
  end;
end;

procedure TMainForm.InitSaveSettings(var Msg: TMessage);
begin
  if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': ����� InitSaveSettings.');
  StopButton.Click;
  if not JvThreadRecognize.Terminated then
    JvThreadRecognize.Terminate;
  while not (JvThreadRecognize.Terminated) do
    Sleep(1);
  StopNULLRecord;
end;

procedure TMainForm.SaveSettingsDone(var Msg: TMessage);
begin
  if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': ����� SaveSettingsDone.');
  // ������ ������
  LoadCommandDataStringGrid(WorkPath + CommandGridFile, CommandSGrid);
  // ������ ������
  if EnableTextReplace then
    LoadReplaceDataStringGrid(WorkPath + ReplaceGridFile, ReplaceSGrid);
  // ������ ������� �������
  if EnableTextToSpeech then
    LoadTextToSpeechDataStringGrid(WorkPath + TextToSpeechGridFile, TextToSpeechSGrid);
  // ������������ ���������� ������� �������
  RegisterHotKeys;
  // ������������ ����
  AlphaBlendValue := AlphaBlendEnableValue;
  AlphaBlend := AlphaBlendEnable;
  LogForm.AlphaBlend := AlphaBlendEnable;
  LogForm.AlphaBlendValue := AlphaBlendEnableValue;
  AboutForm.AlphaBlend := AlphaBlendEnable;
  AboutForm.AlphaBlendValue := AlphaBlendEnableValue;
  // ��������� ������� ������
  if EnableTextToSpeech and Assigned(gpIVTxt) and (TextToSpeechEngine = 0) then
  begin
    gpIVTxt.Voice := Voices.Item(SAPIVoiceNum);
    gpIVTxt.Volume := SAPIVoiceVolume;
    gpIVTxt.Rate := SAPIVoiceSpeed;
  end
  else if EnableTextToSpeech and (TextToSpeechEngine = 0) and not Assigned(gpIVTxt) then
    SAPIActivate;
  if not EnableTextToSpeech then
    SAPIDeactivate;
  // �������
  Filters();
  // ����-��������� ������
  if MaxLevelOnAutoControl then
    MainForm.StartNULLRecord;
end;

{ ����� ����� ���������� �� ������� WM_LANGUAGECHANGED }
procedure TMainForm.OnLanguageChanged(var Msg: TMessage);
begin
  LoadLanguageStrings;
end;

{ ��� �������������� ��������� }
procedure TMainForm.LoadLanguageStrings;
begin
  Caption := GetLangStr('MSpeechCaption');
  if MSpeechPopupMenu.Items[0].Hint = 'MSpeechPopupMenuShow' then
  begin
    MSpeechPopupMenu.Items[0].Caption := GetLangStr('MSpeechPopupMenuShow');
    MSpeechPopupMenu.Items[0].Hint := 'MSpeechPopupMenuShow';
  end
  else
  begin
    MSpeechPopupMenu.Items[0].Caption := GetLangStr('MSpeechPopupMenuHide');
    MSpeechPopupMenu.Items[0].Hint := 'MSpeechPopupMenuHide';
  end;
  MSpeechPopupMenu.Items[1].Caption := GetLangStr('MSpeechPopupMenuSettings');
  MSpeechPopupMenu.Items[2].Caption := GetLangStr('MSpeechPopupMenuShowLog');
  MSpeechPopupMenu.Items[3].Caption := GetLangStr('MSpeechPopupMenuAbout');
  MSpeechPopupMenu.Items[4].Caption := GetLangStr('MSpeechPopupMenuExit');
  GBMain.Caption := Format(' %s ', [GetLangStr('GBMain')]);
  LSignalLevel.Caption := GetLangStr('LSignalLevel');
  StartButton.Caption := GetLangStr('StartButton');
  StopButton.Caption := GetLangStr('StopButton');
  SettingsButton.Caption := GetLangStr('SettingsButton');
end;

end.
