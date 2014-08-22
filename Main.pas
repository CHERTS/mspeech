{ ############################################################################ }
{ #                                                                          # }
{ #  MSpeech v1.5.6 - ������������� ���� ��������� Google Speech API         # }
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
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ACS_Classes, NewACIndicators, ACS_FLAC, ACS_DXAudio,
  ShellApi, Global, Settings, Log, ACS_Misc, ACS_Filters, ACS_Wave,
  CoolTrayIcon, ImgList, Menus, JvAppStorage, JvAppIniStorage, JvComponentBase,
  JvFormPlacement, Grids, JvAppHotKey, Vcl.ExtCtrls, Vcl.Buttons, Clipbrd,
  XMLIntf, XMLDoc, JvExControls, ActiveX, SpeechLib_TLB,
  AudioDMO, ACS_Procs, ACS_WinMedia, ACS_smpeg, SHFolder, StrUtils, ASR;

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
    MSpeechExit: TMenuItem;
    JvFormStorage: TJvFormStorage;
    JvAppIniFileStorage: TJvAppIniFileStorage;
    GBMain: TGroupBox;
    LSignalLevel: TLabel;
    ProgressBar: TProgressBar;
    StartButton: TButton;
    StopButton: TButton;
    SettingsButton: TButton;
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
    procedure MSpeechTrayDblClick(Sender: TObject);
    procedure MSpeechShowLogClick(Sender: TObject);
    procedure MSpeechSettingsClick(Sender: TObject);
    procedure MSpeechExitClick(Sender: TObject);
    procedure Start;
    procedure StartRecognizer;
    procedure StartRecord;
    procedure StartNULLRecord;
    procedure StopNULLRecord;
    procedure SyncFilterOn;
    procedure SyncFilterOff;
    procedure VoiceFilterOn;
    procedure VoiceFilterOff;
    procedure DXAudioOutDone(Sender: TComponent);
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
    FLockedCount: Integer;
    // �������
    VoiceFilter: TVoiceFilter;
    SincFilter: TSincFilter;
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
    function OtherTTS(const Text, MP3FileName: String): Boolean;
    procedure Filters;
    procedure RecognizeErrorCallBack(Sender: TObject; E: TRecognizeError; EStr: String);
    procedure RecognizeResultCallBack(Sender: TObject; pStatus: TRecognizeStatus; pInfo: TRecognizeInfo);
    procedure WndProc(var Message: TMessage); override;
  end;

var
  MainForm: TMainForm;

// WTSRegisterSessionNotification
// http://msdn.microsoft.com/en-us/library/aa383828%28VS.85%29.aspx
// http://msdn.microsoft.com/en-us/library/aa383841%28VS.85%29.aspx
function WTSRegisterSessionNotification(hWnd: HWND; dwFlags: DWORD): BOOL; stdcall;
function WTSUnRegisterSessionNotification(hWND: HWND): BOOL; stdcall;

const
  // WTSRegisterSessionNotification
  NOTIFY_FOR_ALL_SESSIONS  = 1;
  NOTIFY_FOR_THIS_SESSIONS = 0;

implementation

// WTSRegisterSessionNotification
function WTSRegisterSessionNotification; external 'wtsapi32.dll' Name 'WTSRegisterSessionNotification';
function WTSUnRegisterSessionNotification; external 'wtsapi32.dll' Name 'WTSUnRegisterSessionNotification';

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
  // ���. ���������� ��
  FLockedCount := 0;
  WTSRegisterSessionNotification(Handle, NOTIFY_FOR_ALL_SESSIONS);
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
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
  WTSUnRegisterSessionNotification(Handle);
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

procedure TMainForm.WndProc(var Message: TMessage);
begin
  case Message.Msg of
    WM_WTSSESSION_CHANGE:
      begin
        if Message.wParam = WTS_SESSION_LOCK then // �� ������������
        begin
          Inc(FLockedCount);
          if EnableLogs then WriteInLog(WorkPath, Format('%s: ��������� ������������.', [FormatDateTime('dd.mm.yy hh:mm:ss', Now)]));
          if StopRecognitionAfterLockingComputer then
          begin
            if MaxLevelOnAutoControl then
              MaxLevelOnAutoControl := False;
            if EnableLogs then WriteInLog(WorkPath, Format('%s: ������������� ������ � �������������.', [FormatDateTime('dd.mm.yy hh:mm:ss', Now)]));
            StopButton.Click;
            StopNULLRecord;
          end;
        end;
        if Message.wParam = WTS_SESSION_UNLOCK then // �� �������������
        begin
          if EnableLogs then WriteInLog(WorkPath, Format('%s: ��������� ������������ %d ���.', [FormatDateTime('dd.mm.yy hh:mm:ss', Now), FLockedCount]));
          if StartRecognitionAfterUnlockingComputer then
          begin
            if EnableLogs then WriteInLog(WorkPath, Format('%s: ��������� ������.', [FormatDateTime('dd.mm.yy hh:mm:ss', Now)]));
            MaxLevelOnAutoControl := ReadCustomINI(WorkPath, 'Main', 'MaxLevelOnAutoControl', False);
            if MaxLevelOnAutoControl then
              StartNULLRecord
            else
              StartButton.Click;
          end;
        end;
      end;
  end;
  inherited;
end;

procedure TMainForm.SettingsButtonClick(Sender: TObject);
begin
  if not SettingsForm.Visible then
    SettingsForm.Show
  else
    SettingsForm.Position := poMainFormCenter;
end;

procedure TMainForm.MSpeechExitClick(Sender: TObject);
begin
  MSpeechMainFormHidden := True;
  Close;
end;

procedure TMainForm.MSpeechSettingsClick(Sender: TObject);
begin
  //MSpeechTray.ShowMainForm;
  //MSpeechMainFormHidden := False;
  //MSpeechPopupMenu.Items[0].Caption := GetLangStr('MSpeechPopupMenuHide');
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
    if MainForm.Showing then
      ProgressBar.Position := FastGainIndicator.GainValue;
    if not NULLOutStart then
    begin
      if FastGainIndicator.GainValue < MinLevelOnAutoRecognize then
        Inc(FLACDoneCnt);
      if SettingsForm.Showing then
      begin
        SettingsForm.StaticTextMinLevel.Caption := IntToStr(FastGainIndicator.GainValue);
        SettingsForm.StaticTextMinLevelInterrupt.Caption := IntToStr(FLACDoneCnt);
      end;
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
      if SettingsForm.Showing then
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
        StartRecognizer;
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
    VoiceFilter.OutSampleRate := 22050;
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
  StopNULLRecord;
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
    if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': InSampleRate = ' + IntToStr(DXAudioIn.InSampleRate));
    if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': InBitsPerSample = ' + IntToStr(DXAudioIn.InBitsPerSample));
    if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': InChannels = ' + IntToStr(DXAudioIn.InChannels));
  end
  else
    if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': �� ������� ���������� libFLAC.dll');
end;

{ ������ ������ �������� ������ � ���������� ������� }
procedure TMainForm.StartRecognizer;
begin
  if FileExists(OutFileName) then
  begin
    MSpeechTray.IconIndex := 4;
    StartRecognize(GoogleAPIKey, OutFileName, CurrentSpeechRecognizeLang , UseProxy, ProxyAddress, ProxyPort, ProxyAuth, ProxyUser, ProxyUserPasswd, RecognizeResultCallBack, RecognizeErrorCallBack)
  end
  else
  begin
    if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': StartRecognizer - ������ ������ ����� ' + OutFileName);
    StartButton.Enabled := True;
    StopButton.Enabled := False;
  end;
end;

{ ��������� ������ ������������� }
procedure TMainForm.RecognizeErrorCallBack(Sender: TObject; E: TRecognizeError; EStr: String);
var
  ErrStr: String;
begin
  case E of
    reErrorGoogleCommunication: ErrStr := '������ ����� � �������� Google: ' + EStr;
    reFileSizeNull: ErrStr := '������: ������� ������ ����� ��� �������������: ' + EStr;
    reErrorHostNotFound: ErrStr := '������: ' + EStr + '. ��������� ��������� Firewall''�.';
    reErrorConnectionTimedOut: ErrStr := '������: ' + EStr + '. ��������� ��������� Firewall''� ��� ������-�������.';
    reErrorGoogleResponse: ErrStr := '������ ������ ������� Google: ' + EStr;
    else ErrStr := '������: ' + EStr;
  end;
  if EnableLogs then WriteInLog(WorkPath, Format('%s: %s', [FormatDateTime('dd.mm.yy hh:mm:ss', Now), ErrStr]));
  // ����������� ������ � ������ �������������
  if E = reErrorGoogleResponse then
  begin
    MSpeechTray.IconIndex := 5;
    ShowBalloonHint(ProgramsName, GetLangStr('MsgErr3'),  bitError);
    StopNULLRecord;
    if MaxLevelOnAutoControl then
      StartNULLRecord;
  end;
  // ������ �������� ������ � Google
  if (E = reErrorConnectionTimedOut) or (E = reErrorHostNotFound) then
  begin
    MSpeechTray.IconIndex := 5;
    ShowBalloonHint(ProgramsName, Format(GetLangStr('MsgErr12'), [EStr]),  bitError);
    StopNULLRecord;
    if MaxLevelOnAutoControl then
      StartNULLRecord;
  end;
  StartButton.Enabled := True;
  StopButton.Enabled := False;
  CloseLogFile;
  if LogForm.Showing then
    SendMessage(LogFormHandle, WM_UPDATELOG, 0, 0);
  MSpeechTray.IconIndex := 0;
end;

{ ��������� ����������� ������������� }
procedure TMainForm.RecognizeResultCallBack(Sender: TObject; pStatus: TRecognizeStatus; pInfo: TRecognizeInfo);
var
  RecognizeStr: String;
  K: Integer;
  RowN: Integer;
  Grid: TArrayOfInteger;
begin
  if EnableLogs then
  begin
    if pStatus = rsResolving then
      WriteInLog(WorkPath, Format('%s: ���������� ����� �������.', [FormatDateTime('dd.mm.yy hh:mm:ss', Now)]));
    if pStatus = rsConnect then
      WriteInLog(WorkPath, Format('%s: ����������� � �������.', [FormatDateTime('dd.mm.yy hh:mm:ss', Now)]));
    if pStatus = rsSendRequest then
      WriteInLog(WorkPath, Format('%s: �������� ������� �� ������.', [FormatDateTime('dd.mm.yy hh:mm:ss', Now)]));
    if pStatus = rsResponseReceived then
      WriteInLog(WorkPath, Format('%s: ��������� ������ �� �������.', [FormatDateTime('dd.mm.yy hh:mm:ss', Now)]));
    if pStatus = rsRecognizeAbort then
      WriteInLog(WorkPath, Format('%s: ������ �������� ������.', [FormatDateTime('dd.mm.yy hh:mm:ss', Now)]));
  end;
  if pStatus = rsRecordingNotRecognized then // ������ �� ����������
  begin
    MSpeechTray.IconIndex := 2;
    TextToSpeech(mRecordingNotRecognized);
    ShowBalloonHint(ProgramsName, GetLangStr('MsgInf2'), bitWarning);
    CloseLogFile;
    if LogForm.Showing then
      SendMessage(LogFormHandle, WM_UPDATELOG, 0, 0);
    StopNULLRecord;
    if MaxLevelOnAutoControl then
      StartNULLRecord;
    MSpeechTray.IconIndex := 0;
  end;
  if pStatus = rsRecognizeDone then // ������ ����������
  begin
    if EnableLogs then
    begin
      WriteInLog(WorkPath, Format('%s: ������ ������������� = %d', [FormatDateTime('dd.mm.yy hh:mm:ss', Now), pInfo.FStatus]));
      WriteInLog(WorkPath, Format('%s: ������������ ������ = %s', [FormatDateTime('dd.mm.yy hh:mm:ss', Now), pInfo.FTranscript]));
      WriteInLog(WorkPath, Format('%s: ������������� ������������� = %s%%', [FormatDateTime('dd.mm.yy hh:mm:ss', Now), FloatToStr(pInfo.FConfidence)]));
    end;
    RecognizeStr := pInfo.FTranscript;
    // ������ ������
    if EnableText�orrection then
    begin
      if EnableTextReplace then
      begin
        for RowN := 0 to ReplaceSGrid.RowCount-1 do
          RecognizeStr := StringReplace(RecognizeStr, ReplaceSGrid.Cells[0,RowN], ReplaceSGrid.Cells[1,RowN], [rfReplaceAll]);
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
      Grid := HackTStringsIndexOf(CommandSGrid.Cols[0], RecognizeStr); // ����� ������
      if Length(Grid) > 0 then // ������� ������� � ������
      begin
        if EnableLogs then WriteInLog(WorkPath, Format('%s: � CommandSGrid ������� %d ������.', [FormatDateTime('dd.mm.yy hh:mm:ss', Now), Length(Grid)]));
        for K := Low(Grid) to High(Grid) do // ������� ��������� ������
        begin
          if DetectCommandTypeName(CommandSGrid.Cells[2,Grid[K]]) = mExecPrograms then
          begin
            if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': ' + '��������� ���������: ' + CommandSGrid.Cells[1,Grid[K]]);
            //Beep;
            if (ExtractFileExt(CommandSGrid.Cells[1,Grid[K]]) = '.cmd') or (ExtractFileExt(CommandSGrid.Cells[1,Grid[K]]) = '.bat') then
              ShellExecute(0, 'open', PWideChar(CommandSGrid.Cells[1,Grid[K]]), nil, nil, SW_HIDE)
            else
              ShellExecute(0, 'open', PWideChar(CommandSGrid.Cells[1,Grid[K]]), nil, nil, SW_SHOWNORMAL);
          end
          else if DetectCommandTypeName(CommandSGrid.Cells[2,Grid[K]]) = mClosePrograms then
          begin
            if IsProcessRun(ExtractFileName(CommandSGrid.Cells[1,Grid[K]])) then
            begin
              EndProcess(GetProcessID(ExtractFileName(CommandSGrid.Cells[1,Grid[K]])), WM_CLOSE);
              if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': ' + '��������� ���������: ' + CommandSGrid.Cells[1,Grid[K]]);
              //Beep;
            end;
          end
          else if DetectCommandTypeName(CommandSGrid.Cells[2,Grid[K]]) = mKillPrograms then
          begin
            if IsProcessRun(ExtractFileName(CommandSGrid.Cells[1,Grid[K]])) then
            begin
              KillTask(ExtractFileName(CommandSGrid.Cells[1,Grid[K]]));
              if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': ' + '������� ���������: ' + CommandSGrid.Cells[1,Grid[K]]);
              //Beep;
            end;
          end
          else if DetectCommandTypeName(CommandSGrid.Cells[2,Grid[K]]) = mTextToSpeech then
            TextToSpeech(CommandSGrid.Cells[1,Grid[K]])
          else
          begin
            if DefaultCommandExec  <> '' then // ��������� ������� �� ���������
            begin
              if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': ��������� ������� ��-��������� = ' + DefaultCommandExec);
              if (ExtractFileExt(DefaultCommandExec) = '.cmd') or (ExtractFileExt(DefaultCommandExec) = '.bat') then
                ShellExecute(0, 'open', PWideChar(DefaultCommandExec), nil, nil, SW_HIDE)
              else
                ShellExecute(0, 'open', PWideChar(DefaultCommandExec), nil, nil, SW_SHOWNORMAL);
            end;
          end;
        end;
      end
      else // ������� �� ������� � ������
      begin
          if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': ' + GetLangStr('MsgInf3'));
          TextToSpeech(mCommandNotFound);
          ShowBalloonHint(ProgramsName, GetLangStr('MsgInf3'));
      end;
      StopNULLRecord;
      if MaxLevelOnAutoControl then
        StartNULLRecord;
    end;
    StartButton.Enabled := True;
    StopButton.Enabled := False;
    MSpeechTray.IconIndex := 0;
    CloseLogFile;
    if LogForm.Showing then
      SendMessage(LogFormHandle, WM_UPDATELOG, 0, 0);
    StopNULLRecord;
    if MaxLevelOnAutoControl then
      StartNULLRecord;
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
  Grid: TArrayOfInteger;
begin
  if EnableTextToSpeech then
  begin
    if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': ������ SAPITextToSpeech.');
    Grid := HackTStringsIndexOf(TextToSpeechSGrid.Cols[1], DetectEventsTypeName(EType));
    if Length(Grid) > 0 then // ������� ������� � ������
    begin
      if EnableLogs then WriteInLog(WorkPath, Format('%s: � TextToSpeechSGrid ������� %d �������.', [FormatDateTime('dd.mm.yy hh:mm:ss', Now), Length(Grid)]));
      for K := Low(Grid) to High(Grid) do // ������� ��������� �������
      begin
        if DetectEventsTypeStatusName(TextToSpeechSGrid.Cells[2,Grid[K]]) = mEnable then
        begin
          if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': SAPITextToSpeech = ' + TextToSpeechSGrid.Cells[0,Grid[K]]);
          if TextToSpeechEngine = 0 then // ���� Microsoft SAPI
          begin
            CoInitialize(nil);
            try
              gpIVTxt.Speak(TextToSpeechSGrid.Cells[0,Grid[K]], SVSFlagsAsync);
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
            OtherTTS(TextToSpeechSGrid.Cells[0,Grid[K]], GetUserTempPath() + 'mspeech-tts.mp3');
        end;
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
    if TextToSpeechEngine = Integer(TTTSEngine(TTSMicrosoft)) then // ���� Microsoft SAPI
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
      OtherTTS(SayText, GetUserTempPath() + 'mspeech-tts.mp3');
  end;
end;

{ �������� ���������� ������� � ������� TTS, ����� ��������� ����� � ��� ��������������� }
function TMainForm.OtherTTS(const Text, MP3FileName: String): Boolean;
var
  TTSResult: Boolean;
begin
  TTSResult := False;
  if TextToSpeechEngine = Integer(TTTSEngine(TTSGoogle)) then // ���� Google TTS
  begin
    TTSResult := GoogleTextToSpeech(Text, MP3FileName);
    DXAudioOut.Latency := 100;
  end
  else if TextToSpeechEngine = Integer(TTTSEngine(TTSYandex)) then // ���� Yandex TTS
  begin
    TTSResult := YandexTextToSpeech(Text, MP3FileName);
    DXAudioOut.Latency := 79;
  end;
  if TTSResult then
  begin
    if FileExists(MP3FileName) then
    begin
      MP3In.FileName := MP3FileName;
      if MP3In.Valid then
        DXAudioOut.Run
      else
      begin
        if FileExists(MP3In.FileName) then
          DeleteFile(MP3In.FileName);
      end;
    end;
  end
  else
  begin
    if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': ' + 'TTS - ������ �������� ������ ��� ������� ����.');
    ShowBalloonHint(ProgramsName, GetLangStr('MsgErr13'),  bitError);
  end;
end;

procedure TMainForm.DXAudioOutDone(Sender: TComponent);
begin
  if FileExists(MP3In.FileName) then
    DeleteFile(MP3In.FileName);
end;

procedure TMainForm.InitSaveSettings(var Msg: TMessage);
begin
  if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': ����� InitSaveSettings.');
  StopButton.Click;
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
    StartNULLRecord;
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
  MSpeechPopupMenu.Items[3].Caption := GetLangStr('MSpeechPopupMenuExit');
  GBMain.Caption := Format(' %s ', [GetLangStr('GBMain')]);
  LSignalLevel.Caption := GetLangStr('LSignalLevel');
  StartButton.Caption := GetLangStr('StartButton');
  StopButton.Caption := GetLangStr('StopButton');
  SettingsButton.Caption := GetLangStr('SettingsButton');
end;

end.
