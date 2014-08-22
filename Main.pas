{ ############################################################################ }
{ #                                                                          # }
{ #  MSpeech v1.4 - Распознавание речи используя Google Speech API           # }
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
  HTTPSend, SSL_OpenSSL, uJSON, ShellApi, Global, About, ACS_Misc, ACS_Filters, ACS_Wave,
  CoolTrayIcon, ImgList, Menus, JvAppStorage, JvAppIniStorage, JvComponentBase,
  JvFormPlacement, JvThread, Grids, JvAppHotKey, Vcl.ExtCtrls, Vcl.Buttons, Clipbrd,
  XMLIntf, XMLDoc, JvExControls, JvSpeedButton
  {$ifdef LICENSE}, License{$endif LICENSE};

type
  THackGrid = class(TStringGrid);
  TMainForm = class(TForm)
    DXAudioIn: TDXAudioIn;
    FLACOut: TFLACOut;
    FastGainIndicator: TFastGainIndicator;
    NULLOut: TNULLOut;
    SincFilter: TSincFilter;
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
    SettingsPanel: TPanel;
    SettingsPageControl: TPageControl;
    TabSheetSettings: TTabSheet;
    TabSheetConnectSettings: TTabSheet;
    GBConnectSettings: TGroupBox;
    LProxyAddress: TLabel;
    LProxyPort: TLabel;
    LProxyUser: TLabel;
    LProxyUserPasswd: TLabel;
    CBUseProxy: TCheckBox;
    EProxyAddress: TEdit;
    EProxyPort: TEdit;
    EProxyUser: TEdit;
    CBProxyAuth: TCheckBox;
    EProxyUserPasswd: TEdit;
    TabSheetHotKey: TTabSheet;
    CBHotKey: TCheckBox;
    GBHotKey: TGroupBox;
    HotKetStringGrid: TStringGrid;
    IMHotKey: THotKey;
    SetHotKeyButton: TButton;
    DeleteHotKeyButton: TButton;
    TabSheetLog: TTabSheet;
    LogMemo: TMemo;
    ClearLogButton: TButton;
    SaveSettingsButton: TButton;
    TabSheetSendText: TTabSheet;
    GBSendText: TGroupBox;
    LClassName: TLabel;
    EClassNameReciver: TEdit;
    ImageList_Main: TImageList;
    CBEnableSendText: TCheckBox;
    LNote: TLabel;
    LMethodSendingText: TLabel;
    CBMethodSendingText: TComboBox;
    TabSheetRecord: TTabSheet;
    GBRecordSettings: TGroupBox;
    LMaxLevel: TLabel;
    LMaxLevelInterrupt: TLabel;
    LMinLevel: TLabel;
    LEMinLevelInterrupt: TLabel;
    LDevice: TLabel;
    LStopRecordAction: TLabel;
    EMaxLevel: TEdit;
    UpDownMaxLevel: TUpDown;
    CBMaxLevelControl: TCheckBox;
    EMinLevelInterrupt: TEdit;
    UpDownMinLevelInterrupt: TUpDown;
    UpDownMaxLevelInterrupt: TUpDown;
    UpDownMinLevel: TUpDown;
    EMinLevel: TEdit;
    StaticTextMinLevel: TStaticText;
    StaticTextMaxLevelInterrupt: TStaticText;
    StaticTextMinLevelInterrupt: TStaticText;
    EMaxLevelInterrupt: TEdit;
    CBDevice: TComboBox;
    MicSettingsButton: TButton;
    CBStopRecordAction: TComboBox;
    GBInterfaceSettings: TGroupBox;
    CBShowTrayEvents: TCheckBox;
    CBAlphaBlend: TCheckBox;
    AlphaBlendTrackBar: TTrackBar;
    CBLang: TComboBox;
    LLang: TLabel;
    AlphaBlendVar: TLabel;
    CBEnableTextСorrection: TCheckBox;
    TabSheetTextCorrection: TTabSheet;
    GBReplaceList: TGroupBox;
    CBFirstLetterUpper: TCheckBox;
    CBEnableReplace: TCheckBox;
    CBEnableSendTextInactiveWindow: TCheckBox;
    EInactiveWindowCaption: TEdit;
    LInactiveWindowCaption: TLabel;
    LRegion: TLabel;
    CBRegion: TComboBox;
    LReplaceIN: TLabel;
    LReplaceOUT: TLabel;
    EReplaceIN: TEdit;
    EReplaceOUT: TEdit;
    ReplaceStringGrid: TStringGrid;
    AddReplaceButton: TButton;
    DeleteReplaceButton: TButton;
    TabSheetCommand: TTabSheet;
    GBCommand: TGroupBox;
    LCommandKey: TLabel;
    LCommandExec: TLabel;
    ECommandKey: TEdit;
    ECommandExec: TEdit;
    CommandStringGrid: TStringGrid;
    AddCommandButton: TButton;
    DeleteCommandButton: TButton;
    CBCommandType: TComboBox;
    LCommandType: TLabel;
    SBCommandSelect: TSpeedButton;
    CommandOpenDialog: TOpenDialog;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormDestroy(Sender: TObject);
    procedure CoreLanguageChanged;
    procedure StartButtonClick(Sender: TObject);
    procedure FastGainIndicatorGainData(Sender: TComponent);
    procedure FLACOutDone(Sender: TComponent);
    procedure CBDeviceChange(Sender: TObject);
    procedure AboutButtonClick(Sender: TObject);
    procedure FLACOutThreadException(Sender: TComponent);
    procedure StopButtonClick(Sender: TObject);
    procedure EMinLevelKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure UpDownMinLevelClick(Sender: TObject; Button: TUDBtnType);
    procedure EMinLevelInterruptKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure UpDownMinLevelInterruptClick(Sender: TObject; Button: TUDBtnType);
    procedure MicSettingsButtonClick(Sender: TObject);
    procedure UpDownMaxLevelClick(Sender: TObject; Button: TUDBtnType);
    procedure EMaxLevelKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EMaxLevelInterruptKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure UpDownMaxLevelInterruptClick(Sender: TObject; Button: TUDBtnType);
    procedure NULLOutDone(Sender: TComponent);
    procedure CBMaxLevelControlClick(Sender: TObject);
    procedure MSpeechTrayStartup(Sender: TObject; var ShowMainForm: Boolean);
    procedure MSpeechTrayDblClick(Sender: TObject);
    procedure MSpeechExitClick(Sender: TObject);
    procedure MSpeechAboutClick(Sender: TObject);
    procedure JvThreadRecognizeExecute(Sender: TObject; Params: Pointer);
    procedure JvThreadRecognizeFinish(Sender: TObject);
    procedure StartRecognize;
    procedure StartRecord;
    procedure StartNULLRecord;
    procedure StopNULLRecord;
    procedure SyncFilterOn;
    procedure SyncFilterOff;
    procedure SettingsButtonClick(Sender: TObject);
    procedure CBUseProxyClick(Sender: TObject);
    procedure CBProxyAuthClick(Sender: TObject);
    procedure SaveSettingsButtonClick(Sender: TObject);
    procedure CBHotKeyClick(Sender: TObject);
    procedure SetHotKeyButtonClick(Sender: TObject);
    procedure DeleteHotKeyButtonClick(Sender: TObject);
    procedure HotKetStringGridSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
    procedure MSpeechSettingsClick(Sender: TObject);
    procedure CBStopRecordActionChange(Sender: TObject);
    procedure ClearLogButtonClick(Sender: TObject);
    procedure CBEnableSendTextClick(Sender: TObject);
    procedure CBMethodSendingTextChange(Sender: TObject);
    procedure CBLangChange(Sender: TObject);
    procedure CBAlphaBlendClick(Sender: TObject);
    procedure AlphaBlendTrackBarChange(Sender: TObject);
    procedure NULLOutThreadException(Sender: TComponent);
    procedure CBEnableTextСorrectionClick(Sender: TObject);
    procedure CBEnableReplaceClick(Sender: TObject);
    procedure CBEnableSendTextInactiveWindowClick(Sender: TObject);
    procedure ReplaceStringGridSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
    procedure AddReplaceButtonClick(Sender: TObject);
    procedure DeleteReplaceButtonClick(Sender: TObject);
    procedure EReplaceINKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EReplaceOUTKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure CommandStringGridSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
    procedure AddCommandButtonClick(Sender: TObject);
    procedure DeleteCommandButtonClick(Sender: TObject);
    procedure ECommandKeyKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ECommandExecKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SBCommandSelectClick(Sender: TObject);
    procedure CBCommandTypeChange(Sender: TObject);
  private
    { Private declarations }
    SessionEnding: Boolean;
    HotKeySelectedCell: Integer;
    FCount: Integer;
    FLanguage: WideString;
    procedure WMQueryEndSession(var Message: TMessage); message WM_QUERYENDSESSION;
    procedure OnLanguageChanged(var Msg: TMessage); message WM_LANGUAGECHANGED;
    procedure msgBoxShow(var Msg: TMessage); message WM_MSGBOX;
    procedure DoHotKey(Sender:TObject);
    procedure LoadLanguageStrings;
  public
    { Public declarations }
    MSpeechMainFormHidden: Boolean;
    ReplaceStringSelectedCell: Integer;
    CommandStringSelectedCell: Integer;
    ActivateAddReplaceButton: Boolean;
    ActivateDeleteReplaceButton: Boolean;
    ActivateAddCommandButton: Boolean;
    ActivateDeleteCommandButton: Boolean;
    function HTTPPostFile(Const URL, FieldName, FileName: String; Const Data: TStream; Const ResultData: TStrings): Boolean;
    procedure LoadSettings;
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
    procedure FindLangFile;
    procedure AddCommmandsToList;
    property CoreLanguage: WideString read FLanguage;
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
  StartSaveSettings: Boolean = False;
  JvStartRecordHotKey: TJvApplicationHotKey;
  JvStartRecordWithoutSendTextHotKey: TJvApplicationHotKey;

procedure TMainForm.WMQueryEndSession(var Message: TMessage);
begin
  SessionEnding := True;
  Message.Result := 1;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  DevCnt: Integer;
begin
  ProgramsPath := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName));
  OutFileName := GetUserTempPath() + 'out.flac';
  // Для мультиязыковой поддержки
  MainFormHandle := Handle;
  SetWindowLong(Handle, GWL_HWNDPARENT, 0);
  SetWindowLong(Handle, GWL_EXSTYLE, GetWindowLong(Handle, GWL_EXSTYLE) or WS_EX_APPWINDOW);
  // Читаем настройки
  LoadINI(ProgramsPath);
  MSpeechTray.Hint := ProgramsName;
  // Загружаем настройки локализации
  if INIFileLoaded then
    FLanguage := DefaultLanguage
  else
  begin
    if (GetSysLang = 'Русский') or (GetSysLang = 'Russian') or (MatchStrings(GetSysLang, 'Русский*')) then
      FLanguage := 'Russian'
    else
      FLanguage := 'English';
  end;
  LangDoc := NewXMLDocument();
  if not DirectoryExists(ProgramsPath + dirLangs) then
    CreateDir(ProgramsPath + dirLangs);
  CoreLanguageChanged;
  // Заполняем список устройст записи
  CBDevice.Clear;
  if DXAudioIn.DeviceCount > 0 then
  begin
    for DevCnt := 0 to DXAudioIn.DeviceCount - 1 do
      CBDevice.Items.Add(DXAudioIn.DeviceName[DevCnt]);
    StartButton.Enabled := True;
  end
  else
  begin
    //CBDevice.Items.Add('Нет ни одного устройства записи');
    //StartButton.Enabled := False;
    MsgDie(ProgramsName, GetLangStr('MsgErr1'));
    Application.Terminate;
    Exit;
  end;
  if DXAudioIn.DeviceCount > DefaultAudioDeviceNumber then
    CBDevice.ItemIndex := DefaultAudioDeviceNumber
  else
    CBDevice.ItemIndex := 0;
  // Отключаем кнопки
  StopButton.Enabled := False;
  // Фильтрация звука
  if SyncFilterEnable then
    SyncFilterOn;
  // Создаем горячие клавиши
  HotKetStringGrid.RowCount := 2;
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
  // Активируем настройки
  LoadSettings;
  // Активируем горячие клавиши
  RegisterHotKeys;
  StopRecord := True;
  FCount := 0;
  // Авто-активация записи
  if MaxLevelOnAutoControl then
    StartNULLRecord;
  // Замена текста
  ReplaceStringGrid.ColWidths[0] := 170;
  ReplaceStringSelectedCell := 1;
  ActivateAddReplaceButton := False;
  ActivateDeleteReplaceButton := False;
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
  // Разрегистрация гор. клавиш
  UnRegisterHotKeys;
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
  SettingsPageControl.ActivePage := TabSheetLog;
  SettingsPanel.Visible := False;
  MainForm.Height := GBMain.Top + GBMain.Height + 40;
  MainForm.Width := 629;
end;

procedure TMainForm.SettingsButtonClick(Sender: TObject);
begin
  if not SettingsPanel.Visible then
  begin
    // Активируем настройки
    LoadSettings;
    // Показываем настройки
    SettingsPanel.Visible := True;
    MainForm.Height := GBMain.Top + GBMain.Height + SettingsPageControl.Height + 75
  end
  else
  begin
    SettingsPanel.Visible := False;
    MainForm.Height := GBMain.Top + GBMain.Height + 40;
  end;
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

{ Клик по пункту Скрыть/Показать контекстного меню в трее }
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
      StaticTextMinLevel.Caption := IntToStr(FastGainIndicator.GainValue);
      StaticTextMinLevelInterrupt.Caption := IntToStr(FLACDoneCnt);
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
      StaticTextMaxLevelInterrupt.Caption := IntToStr(NULLOutDoneCnt);
      if NULLOutDoneCnt >= MaxLevelOnAutoRecordInterrupt then
        StartButton.Click;
    end;
  except
    on e: Exception do
    begin
      //LogMemo.Lines.Add(FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': ' + 'Неизвестное исключение в процедуре FastGainIndicatorGainData - ' + e.Message);
      Exit;
    end;
  end;
end;

procedure TMainForm.FLACOutDone(Sender: TComponent);
begin
  FLACDoneCnt := 0;
  SaveFLACDone := True;
  LogMemo.Lines.Add(FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': Файл ' + OutFileName + ' сохранен.');
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
  LogMemo.Lines.Add(FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': Ошибка записи в файл ' + OutFileName);
  FLACOut.Stop;
  MSpeechTray.IconIndex := 5;
  StartButton.Enabled := True;
  StopButton.Enabled := False;
  StopRecord := True;
end;

procedure TMainForm.CBDeviceChange(Sender: TObject);
begin
  DXAudioIn.DeviceNumber := (Sender as TComboBox).ItemIndex;
end;

procedure TMainForm.CBHotKeyClick(Sender: TObject);
begin
  GBHotKey.Visible := (Sender as TCheckBox).Checked;
end;

procedure TMainForm.CBMaxLevelControlClick(Sender: TObject);
begin
  LMaxLevel.Enabled := (Sender as TCheckBox).Checked;
  EMaxLevel.Enabled := (Sender as TCheckBox).Checked;
  LMaxLevelInterrupt.Enabled := (Sender as TCheckBox).Checked;
  EMaxLevelInterrupt.Enabled := (Sender as TCheckBox).Checked;
  UpDownMaxLevel.Enabled := (Sender as TCheckBox).Checked;
  UpDownMaxLevelInterrupt.Enabled := (Sender as TCheckBox).Checked;
end;

procedure TMainForm.CBUseProxyClick(Sender: TObject);
begin
  LProxyAddress.Enabled := (Sender as TCheckBox).Checked;
  LProxyPort.Enabled := (Sender as TCheckBox).Checked;
  EProxyAddress.Enabled := (Sender as TCheckBox).Checked;
  EProxyPort.Enabled := (Sender as TCheckBox).Checked;
  CBProxyAuth.Enabled := (Sender as TCheckBox).Checked;
end;

procedure TMainForm.CBProxyAuthClick(Sender: TObject);
begin
  LProxyUser.Enabled := (Sender as TCheckBox).Checked;
  LProxyUserPasswd.Enabled := (Sender as TCheckBox).Checked;
  EProxyUser.Enabled := (Sender as TCheckBox).Checked;
  EProxyUserPasswd.Enabled := (Sender as TCheckBox).Checked;
end;

procedure TMainForm.CBStopRecordActionChange(Sender: TObject);
begin
  if CBStopRecordAction.ItemIndex >= 2 then
  begin
    LMinLevel.Enabled := False;
    LEMinLevelInterrupt.Enabled := False;
    EMinLevel.Enabled := False;
    UpDownMinLevel.Enabled := False;
    EMinLevelInterrupt.Enabled := False;
    UpDownMinLevelInterrupt.Enabled := False;
  end
  else
  begin
    LMinLevel.Enabled := True;
    LEMinLevelInterrupt.Enabled := True;
    EMinLevel.Enabled := True;
    UpDownMinLevel.Enabled := True;
    EMinLevelInterrupt.Enabled := True;
    UpDownMinLevelInterrupt.Enabled := True;
  end;
end;

procedure TMainForm.EMaxLevelInterruptKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if EMaxLevelInterrupt.Text = '' then
    EMaxLevelInterrupt.Text := '0';
  if StrToInt(EMaxLevelInterrupt.Text) > 100  then
    EMaxLevelInterrupt.Text := '100';
  if Key = VK_RETURN then
  begin
    UpDownMaxLevelInterrupt.Position := StrToInt(EMaxLevelInterrupt.Text);
    MaxLevelOnAutoRecordInterrupt := StrToInt(EMaxLevelInterrupt.Text);
  end;
end;

procedure TMainForm.EMinLevelInterruptKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if EMinLevelInterrupt.Text = '' then
    EMinLevelInterrupt.Text := '0';
  if StrToInt(EMinLevelInterrupt.Text) > 100  then
    EMinLevelInterrupt.Text := '100';
  if Key = VK_RETURN then
  begin
    UpDownMinLevelInterrupt.Position := StrToInt(EMinLevelInterrupt.Text);
    MinLevelOnAutoRecognizeInterrupt := StrToInt(EMinLevelInterrupt.Text);
  end;
end;

procedure TMainForm.EMaxLevelKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if EMaxLevel.Text = '' then
    EMaxLevel.Text := '0';
  if StrToInt(EMaxLevel.Text) > 100  then
    EMaxLevel.Text := '100';
  if Key = VK_RETURN then
  begin
    UpDownMaxLevel.Position := StrToInt(EMaxLevel.Text);
    MaxLevelOnAutoRecord := StrToInt(EMaxLevel.Text);
  end;
end;

procedure TMainForm.EMinLevelKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if EMinLevel.Text = '' then
    EMinLevel.Text := '0';
  if StrToInt(EMinLevel.Text) > 100  then
    EMinLevel.Text := '100';
  if Key = VK_RETURN then
  begin
    UpDownMinLevel.Position := StrToInt(EMinLevel.Text);
    MinLevelOnAutoRecognize := StrToInt(EMinLevel.Text);
  end;
end;

procedure TMainForm.UpDownMaxLevelClick(Sender: TObject; Button: TUDBtnType);
begin
  MaxLevelOnAutoRecord := StrToInt(EMaxLevel.Text);
end;

procedure TMainForm.UpDownMinLevelClick(Sender: TObject; Button: TUDBtnType);
begin
  MinLevelOnAutoRecognize := StrToInt(EMinLevel.Text);
end;

procedure TMainForm.UpDownMaxLevelInterruptClick(Sender: TObject; Button: TUDBtnType);
begin
  MaxLevelOnAutoRecordInterrupt := StrToInt(EMaxLevelInterrupt.Text);
end;

procedure TMainForm.UpDownMinLevelInterruptClick(Sender: TObject; Button: TUDBtnType);
begin
  MinLevelOnAutoRecognizeInterrupt := StrToInt(EMinLevelInterrupt.Text);
end;

procedure TMainForm.MicSettingsButtonClick(Sender: TObject);
begin
  if (DetectWinVersionStr = 'Windows 7') then
    WinExec('SndVol.exe /r', SW_SHOW)
  else if (DetectWinVersionStr = 'Windows 8') then
    WinExec('SndVol.exe /r', SW_SHOW)
  else  if (DetectWinVersionStr = 'Windows XP') or (DetectWinVersionStr = 'Windows 2000') then
    WinExec('SndVol32.exe /r', SW_SHOW)
  //else if (DetectWinVersionStr = 'Windows Vista') or (DetectWinVersionStr = 'Windows 2008') then
  //  MsgInf(ProgramName, 'Для настройки параметров микрофона зайдите в Панель управления.' + #13 + 'Ваша версия OS: ' + DetectWinVersionStr)
  else
    MsgInf(ProgramsName, Format(GetLangStr('MsgInf1'), [#13, DetectWinVersionStr]));
end;

procedure TMainForm.AboutButtonClick(Sender: TObject);
begin
  AboutForm.Show;
end;

procedure TMainForm.SyncFilterOff;
begin
  FastGainIndicator.Input := DXAudioIn;
end;

procedure TMainForm.SyncFilterOn;
begin
  FastGainIndicator.Input := SincFilter;
end;

procedure TMainForm.StartButtonClick(Sender: TObject);
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
  LogMemo.Lines.Add(FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': Получен запрос на остановку записи.');
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
  LogMemo.Lines.Add(FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': Ошибка записи в пустоту');
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
    LogMemo.Lines.Add(FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': Начата запись в файл ' + OutFileName);
  end
  else
    LogMemo.Lines.Add(FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': Не найдена библиотека libFLAC.dll');
end;

{ Запуск потока отправки данных и выполнения команды }
procedure TMainForm.StartRecognize;
begin
  if not JvThreadRecognize.Terminated then
      JvThreadRecognize.Terminate;
  if FileExists(OutFileName) then
    JvThreadRecognize.Execute(Self)
  else
  begin
    LogMemo.Lines.Add(FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': StartRecognize - Ошибка чтения файла ' + OutFileName);
    StartButton.Enabled := True;
    StopButton.Enabled := False;
  end;
end;

{ Поток отправки данных и выполнения команды }
procedure TMainForm.JvThreadRecognizeExecute(Sender: TObject; Params: Pointer);
var
  Stream: TFileStream;
  Str: String;
  JSON, Jo: TJSONobject;
  ReplStr: String;
  RecognizeConfidence: Real;
  StrList: TStringList;
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
    LogMemo.Lines.Add(FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': Ждите, идет отправка запроса в Google...');
    try
      Stream := TFileStream.Create(OutFileName, fmOpenRead or fmShareDenyWrite);
    except
      on e: Exception do
      begin
        MSpeechTray.IconIndex := 5;
        LogMemo.Lines.Add(FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': ' + 'Поток JvThreadRecognize не может получить доступ к файлу ' + OutFileName + ' Ошибка: ' + e.Message);
      end;
    end;
    try
      HTTPPostFile('https://www.google.com/speech-api/v1/recognize?xjerr=1&client=chromium&lang='+DefaultSpeechRecognizeLang, 'userfile', OutFileName, Stream, StrList);
    finally
      Stream.Free;
    end;
    if JvThreadRecognize.Terminated then
    begin
      StrList.Free;
      Exit;
    end;
    Str := UTF8ToString(StrList.Text);
    StrList.Free;
    if Length(Str) > 0  then
    begin
      MSpeechTray.IconIndex := 4;
      LogMemo.Lines.Add(FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': JSON ответ сервера Google = ' + Trim(Str));
      try
        JSON := TJSONObject.Create(Str);
      except
        on e: Exception do
        begin
          MSpeechTray.IconIndex := 5;
          LogMemo.Lines.Add(FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': ' + 'Неизвестное исключение в потоке JvThreadRecognize - ' + e.Message);
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
        // Запись не распознана
        if JSON.optString('status') = '5' then
        begin
          MSpeechTray.IconIndex := 2;
          LogMemo.Lines.Add(FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': ' + GetLangStr('MsgInf2'));
          ShowBalloonHint(ProgramsName, GetLangStr('MsgInf2'), bitWarning);
          StopNULLRecord;
          if MaxLevelOnAutoControl then
            StartNULLRecord;
        end
        // Запись успешно распознана
        else if JSON.optString('status') = '0' then
        begin
          MSpeechTray.IconIndex := 4;
          ReplStr := StringReplace(JSON.getString('hypotheses'),'[','',[RFReplaceall]);
          ReplStr := StringReplace(ReplStr,']','',[RFReplaceall]);
          Jo := TJSONObject.Create(ReplStr);
          try
            RecognizeStr := Jo.getString('utterance');
            LogMemo.Lines.Add(FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': Распознанная строка = ' + RecognizeStr);
            //LogMemo.Lines.Add(FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': Фраза: '+ Jo.getString('utterance'));
            FormatSettings.DecimalSeparator := '.';
            RecognizeConfidence := (StrToFloat(Jo.getString('confidence')))*100;
            LogMemo.Lines.Add(FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': Достоверность распознавания = ' + FloatToStr(RecognizeConfidence) + '%');
            // Замена текста
            if EnableTextСorrection then
            begin
              if EnableTextReplace then
              begin
                for RowN := 0 to ReplaceStringGrid.RowCount-1 do
                begin
                  RecognizeStr := StringReplace(RecognizeStr, ReplaceStringGrid.Cells[0,RowN], ReplaceStringGrid.Cells[1,RowN], [rfReplaceAll]);
                end;
              end;
              if FirstLetterUpper then
              begin
                if DefaultSpeechRecognizeLang = 'ru-RU' then
                  RecognizeStr := RusLowercaseToUppercase(RecognizeStr)
                else
                  RecognizeStr := EngLowercaseToUppercase(RecognizeStr);
              end;
            end;
            // Передача текста
            if EnableSendText then
            begin // Передача текста в неактивное окно программы
              if EnableSendTextInactiveWindow then
              begin
                if OnSendMessage(InactiveWindowCaption, RecognizeStr) then
                  LogMemo.Lines.Add(FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': Текст передан методом WM_COPYDATA.')
                else
                  LogMemo.Lines.Add(FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': Программа с заголовком ' + InactiveWindowCaption + ' не найдена.')
              end
              else
              begin // Передача текста в активное окно программы
                if ClassNameReciver <> '' then
                begin // Если указан класс поля ввода
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
                begin // Если класс поля ввода не указан
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
            // Поиск команд
            K := CommandStringGrid.Cols[0].IndexOf(RecognizeStr);
            if K <> -1 then
            begin
              if DetectCommandTypeName(CommandStringGrid.Cells[2,K]) = mExecPrograms then
              begin
                LogMemo.Lines.Add(FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': ' + 'Запускаем программу: ' + CommandStringGrid.Cells[1,K]);
                Beep;
                ShellExecute(0, 'open', PWideChar(CommandStringGrid.Cells[1,K]), nil, nil, SW_SHOWMINIMIZED);
              end
              else if DetectCommandTypeName(CommandStringGrid.Cells[2,K]) = mClosePrograms then
              begin
                if IsProcessRun(ExtractFileName(CommandStringGrid.Cells[1,K])) then
                begin
                  EndProcess(GetProcessID(ExtractFileName(CommandStringGrid.Cells[1,K])), WM_CLOSE);
                  LogMemo.Lines.Add(FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': ' + 'Закрываем программу: ' + CommandStringGrid.Cells[1,K]);
                  Beep;
                end;
              end
              else if DetectCommandTypeName(CommandStringGrid.Cells[2,K]) = mKillPrograms then
              begin
                if IsProcessRun(ExtractFileName(CommandStringGrid.Cells[1,K])) then
                begin
                  KillTask(ExtractFileName(CommandStringGrid.Cells[1,K]));
                  LogMemo.Lines.Add(FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': ' + 'Убиваем программу: ' + CommandStringGrid.Cells[1,K]);
                  Beep;
                end;
              end;
              if JvThreadRecognize.Terminated then
              begin
                if (Assigned(JSON)) then JSON.Free;
                if (Assigned(Jo)) then Jo.Free;
                Exit;
              end;
              StopNULLRecord;
              if MaxLevelOnAutoControl then
                StartNULLRecord;
            end
            else
            begin
              LogMemo.Lines.Add(FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': ' + GetLangStr('MsgInf3'));
              ShowBalloonHint(ProgramsName, GetLangStr('MsgInf3'));
              StopNULLRecord;
              if MaxLevelOnAutoControl then
                StartNULLRecord;
            end;
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
      LogMemo.Lines.Add(FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': ' + GetLangStr('MsgInf4'));
      ShowBalloonHint(ProgramsName, GetLangStr('MsgInf4'), bitError);
    end;
  end
  else
    LogMemo.Lines.Add(FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': JvThreadRecognizeExecute - Ошибка чтения файла ' + OutFileName);
end;

procedure TMainForm.JvThreadRecognizeFinish(Sender: TObject);
begin
  StartButton.Enabled := True;
  StopButton.Enabled := False;
  MSpeechTray.IconIndex := 0;
end;

{ Отправка flac-файлы }
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
      LogMemo.Lines.Add(Format('%s: Пробуем отправить данные через Proxy-сервер (Адрес: %s, Порт: %s, Логин: %s, Пароль: %s)',
                 [FormatDateTime('dd.mm.yy hh:mm:ss', Now), HTTP.ProxyHost, HTTP.ProxyPort, HTTP.ProxyUser, HTTP.ProxyPass]));
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
  finally
    HTTP.Free;
  end;
end;

procedure TMainForm.SaveSettingsButtonClick(Sender: TObject);
begin
  StartSaveSettings := True;
  // Останавливаем потоки распознавания и запись
  StopButton.Click;
  if not JvThreadRecognize.Terminated then
    JvThreadRecognize.Terminate;
  while not (JvThreadRecognize.Terminated) do
    Sleep(1);
  StopNULLRecord;
  // Устанавливаем новые настройки
  // Команды
  SaveCommandDataStringGrid(ProgramsPath + CommandGridFile, CommandStringGrid);
  // Прокси
  UseProxy := CBUseProxy.Checked;
  ProxyAddress := EProxyAddress.Text;
  ProxyPort := EProxyPort.Text;
  ProxyAuth := CBProxyAuth.Checked;
  ProxyUser := EProxyUser.Text;
  ProxyUserPasswd := EProxyUserPasswd.Text;
  // Всплывашки
  ShowTrayEvents := CBShowTrayEvents.Checked;
  // Передача текста в другие программы
  EnableSendText := CBEnableSendText.Checked;
  ClassNameReciver := EClassNameReciver.Text;
  MethodSendingText := CBMethodSendingText.ItemIndex;
  // Коррекция текста
  {$ifdef LICENSE}
  CBEnableTextСorrection.OnClick := nil;
  CBEnableSendTextInactiveWindow.OnClick := nil;
  if CheckLicense(ProgramsPath, True) then
  begin
    EnableTextСorrection := CBEnableTextСorrection.Checked;
    EnableTextReplace := CBEnableReplace.Checked;
    FirstLetterUpper := CBFirstLetterUpper.Checked;
    EnableSendTextInactiveWindow := CBEnableSendTextInactiveWindow.Checked;
    InactiveWindowCaption := EInactiveWindowCaption.Text;
  end
  else
  begin
    EnableTextСorrection := False;
    EnableTextReplace := False;
    FirstLetterUpper := False;
    EnableSendTextInactiveWindow := False;
    InactiveWindowCaption := '';
  end;
  CBEnableTextСorrection.OnClick := CBEnableTextСorrectionClick;
  CBEnableSendTextInactiveWindow.OnClick := CBEnableSendTextInactiveWindowClick;
  {$endif LICENSE}
  {$ifdef FREE_MSPEECH}
    EnableTextСorrection := CBEnableTextСorrection.Checked;
    EnableTextReplace := CBEnableReplace.Checked;
    FirstLetterUpper := CBFirstLetterUpper.Checked;
    EnableSendTextInactiveWindow := CBEnableSendTextInactiveWindow.Checked;
    InactiveWindowCaption := EInactiveWindowCaption.Text;
  {$endif FREE_MSPEECH}
  // Аудио-устройство по-умолчанию
  DefaultAudioDeviceNumber := CBDevice.ItemIndex;
  // Уровни Max
  MaxLevelOnAutoRecord := StrToInt(EMaxLevel.Text);
  MaxLevelOnAutoRecordInterrupt := StrToInt(EMaxLevelInterrupt.Text);
  // Уровни Min
  MinLevelOnAutoRecognize := StrToInt(EMinLevel.Text);
  MinLevelOnAutoRecognizeInterrupt := StrToInt(EMinLevelInterrupt.Text);
  // Действие кнопки "Остановить запись"
  StopRecordAction := CBStopRecordAction.ItemIndex;
  // Горячая клавиша
  GlobalHotKeyEnable := CBHotKey.Checked;
  StartRecordHotKey := HotKetStringGrid.Cells[1,0];
  StartRecordWithoutSendTextHotKey := HotKetStringGrid.Cells[1,1];
  // Язык распознавания
  DefaultSpeechRecognizeLang := DetectRegionStr(CBRegion.ItemIndex);
  // Замена текста
  if EnableTextReplace then
    SaveReplaceDataStringGrid(ProgramsPath + ReplaceGridFile, ReplaceStringGrid);
  // Авто-активация
  MaxLevelOnAutoControl := CBMaxLevelControl.Checked;
  // Сохраняем настройки
  SaveINI(ProgramsPath);
  // Активируем настройки
  LoadSettings;
  // Авто-активация записи
  if MaxLevelOnAutoControl then
    StartNULLRecord;
  StartSaveSettings := False;
end;

procedure TMainForm.SBCommandSelectClick(Sender: TObject);
begin
  if CommandOpenDialog.Execute then
  begin
    if ActivateAddCommandButton then
      AddCommandButton.Enabled := True;
    ActivateDeleteCommandButton := True;
    ECommandExec.Text := CommandOpenDialog.FileName;
  end;
end;

procedure TMainForm.LoadSettings;
begin
  // Прокси
  CBUseProxy.Checked := UseProxy;
  EProxyAddress.Text := ProxyAddress;
  EProxyPort.Text := ProxyPort;
  CBProxyAuth.Checked := ProxyAuth;
  EProxyUser.Text := ProxyUser;
  EProxyUserPasswd.Text := ProxyUserPasswd;
  CBUseProxyClick(CBUseProxy);
  CBProxyAuthClick(CBProxyAuth);
  // Авто-активация
  CBMaxLevelControl.Checked := MaxLevelOnAutoControl;
  CBMaxLevelControlClick(CBMaxLevelControl);
  // Всплывашки
  CBShowTrayEvents.Checked := ShowTrayEvents;
  // Передача текста в другие программы
  CBEnableSendText.Checked := EnableSendText;
  EClassNameReciver.Text := ClassNameReciver;
  CBMethodSendingText.ItemIndex := MethodSendingText;
  CBMethodSendingTextChange(CBMethodSendingText);
  // Передача в неактивное окно
  if EnableSendTextInactiveWindow then
  begin
    LMethodSendingText.Enabled := not EnableSendTextInactiveWindow;
    CBMethodSendingText.Enabled := not EnableSendTextInactiveWindow;
    LClassName.Enabled := not EnableSendTextInactiveWindow;
    EClassNameReciver.Enabled := not EnableSendTextInactiveWindow;
  end;
  LMethodSendingText.Enabled := not EnableSendTextInactiveWindow;
  CBMethodSendingText.Enabled := not EnableSendTextInactiveWindow;
  LInactiveWindowCaption.Enabled := EnableSendTextInactiveWindow;
  EInactiveWindowCaption.Enabled := EnableSendTextInactiveWindow;

  // Ставим уровни Max
  EMaxLevel.Text := IntToStr(MaxLevelOnAutoRecord);
  UpDownMaxLevel.Position := MaxLevelOnAutoRecord;
  EMaxLevelInterrupt.Text := IntToStr(MaxLevelOnAutoRecordInterrupt);
  UpDownMaxLevelInterrupt.Position := MaxLevelOnAutoRecordInterrupt;
  // Ставим уровни Min
  EMinLevel.Text := IntToStr(MinLevelOnAutoRecognize);
  UpDownMinLevel.Position := MinLevelOnAutoRecognize;
  EMinLevelInterrupt.Text := IntToStr(MinLevelOnAutoRecognizeInterrupt);
  UpDownMinLevelInterrupt.Position := MinLevelOnAutoRecognizeInterrupt;
  // Действие кнопки "Остановить запись"
  CBStopRecordAction.ItemIndex := StopRecordAction;
  CBStopRecordActionChange(CBStopRecordAction);
  // Гор. клавиши
  HotKeySelectedCell := 0;
  GBHotKey.Visible := GlobalHotKeyEnable;
  CBHotKey.Checked := GlobalHotKeyEnable;
  HotKetStringGrid.ColWidths[0] := 350;
  HotKetStringGrid.Cells[0,0] := GetLangStr('StartStopRecord');
  HotKetStringGrid.Cells[0,1] := GetLangStr('StartStopRecordWithoutSendText');
  HotKetStringGrid.Cells[1,0] := StartRecordHotKey;
  HotKetStringGrid.Cells[1,1] := StartRecordWithoutSendTextHotKey;
  IMHotKey.HotKey := TextToShortCut(HotKetStringGrid.Cells[1,0]);
  // Регистрируем глобальные горячие клавиши
  RegisterHotKeys;
  // Прозрачность окна
  AlphaBlend := AlphaBlendEnable;
  AlphaBlendValue := AlphaBlendEnableValue;
  if AlphaBlendEnable then
  begin
    CBAlphaBlend.Checked := True;
    AlphaBlendTrackBar.Visible := True;
    AlphaBlendVar.Visible := True;
    AlphaBlendTrackBar.Position := AlphaBlendEnableValue;
    AlphaBlendVar.Caption := IntToStr(AlphaBlendEnableValue);
  end
  else
  begin
    CBAlphaBlend.Checked := False;
    AlphaBlendTrackBar.Visible := False;
    AlphaBlendVar.Visible := False;
  end;
  // Заполняем список языков
  FindLangFile;
  // Список команд
  AddCommmandsToList;
  CommandStringGrid.ColWidths[0] := 170;
  CommandStringGrid.ColWidths[1] := 255;
  CommandStringGrid.ColWidths[2] := 120;
  // Если найден старый файл команд, то грузим список из него
  if FileExists(ProgramsPath + OLDCommandFileName) then
  begin
    LoadOLDCommandFileToGrid(ProgramsPath + OLDCommandFileName, CommandStringGrid);
    DeleteFile(ProgramsPath + OLDCommandFileName);
    SaveCommandDataStringGrid(ProgramsPath + CommandGridFile, CommandStringGrid);
  end
  else
    LoadCommandDataStringGrid(ProgramsPath + CommandGridFile, CommandStringGrid);
  // Коррекция текста
  {$ifdef LICENSE}
  CBEnableTextСorrection.OnClick := nil;
  CBEnableSendTextInactiveWindow.OnClick := nil;
  if not CheckLicense(ProgramsPath, True) then
  begin
    EnableTextСorrection := False;
    EnableTextReplace := False;
    FirstLetterUpper := False;
  end;
  CBEnableTextСorrection.Checked := EnableTextСorrection;
  CBEnableReplace.Checked := EnableTextReplace;
  CBFirstLetterUpper.Checked := FirstLetterUpper;
  CBEnableSendTextInactiveWindow.Checked := EnableSendTextInactiveWindow;
  EInactiveWindowCaption.Text := InactiveWindowCaption;
  CBEnableTextСorrection.OnClick := CBEnableTextСorrectionClick;
  CBEnableSendTextInactiveWindow.OnClick := CBEnableSendTextInactiveWindowClick;
  {$endif LICENSE}
  {$ifdef FREE_MSPEECH}
  CBEnableTextСorrection.Checked := EnableTextСorrection;
  CBEnableReplace.Checked := EnableTextReplace;
  CBFirstLetterUpper.Checked := FirstLetterUpper;
  CBEnableSendTextInactiveWindow.Checked := EnableSendTextInactiveWindow;
  EInactiveWindowCaption.Text := InactiveWindowCaption;
  {$endif FREE_MSPEECH}
  TabSheetTextCorrection.TabVisible := EnableTextСorrection;
  TabSheetTextCorrection.Visible := EnableTextСorrection;
  TabSheetTextCorrection.Enabled := EnableTextСorrection;
  // Язык распознавания
  CBRegion.ItemIndex := DetectRegionID(DefaultSpeechRecognizeLang);
  // Замена текста
  if EnableTextReplace then
    LoadReplaceDataStringGrid(ProgramsPath + ReplaceGridFile, ReplaceStringGrid);
end;

{ Регистрируем глобальные горячие клавиши }
procedure TMainForm.RegisterHotKeys;
begin
  // Старт записи с передачей текста
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
  // Старт записи без передачи текста
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
end;

{ Разрегистрируем глобальные горячие клавиши }
procedure TMainForm.UnRegisterHotKeys;
begin
  if Assigned(JvStartRecordHotKey) then
    JvStartRecordHotKey.Free;
  if Assigned(JvStartRecordWithoutSendTextHotKey) then
    JvStartRecordWithoutSendTextHotKey.Free;
end;

{ Нажата горячая клавиша }
procedure TMainForm.DoHotKey(Sender:TObject);
begin
  // Старт записи с передачей текста
  if ShortCutToText((Sender as TJvApplicationHotKey).HotKey) = StartRecordHotKey then
  begin
    LogMemo.Lines.Add(FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': DoHotKey - Нажата клавиша '+ShortCutToText((Sender as TJvApplicationHotKey).HotKey));
    if StopRecord then
    begin
      EnableSendText := ReadCustomINI(ProgramsPath, 'SendText', 'EnableSendText', False);
      StartButton.Click;
    end
    else
      StopButton.Click;
  end;
  // Старт записи без передачи текста
  if ShortCutToText((Sender as TJvApplicationHotKey).HotKey) = StartRecordWithoutSendTextHotKey then
  begin
    LogMemo.Lines.Add(FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': DoHotKey - Нажата клавиша '+ShortCutToText((Sender as TJvApplicationHotKey).HotKey));
    if StopRecord then // Начинаем запись
    begin
      if EnableSendText then
        EnableSendText := False;
      StartButton.Click;
    end
    else
      StopButton.Click;
  end;
end;

{ Добавить горячую клавишу }
procedure TMainForm.SetHotKeyButtonClick(Sender: TObject);
var
  S: String;
  I: Integer;
begin
  S := ShortCutToText(IMHotKey.HotKey);
  for I := 0 to HotKetStringGrid.RowCount - 1 do
  begin
    if HotKetStringGrid.Cells[1,I] = S then
    begin
      MsgInf(ProgramsName, GetLangStr('HotKeyAlredyUses'));
      Exit;
    end;
  end;
  HotKetStringGrid.Cells[1,HotKeySelectedCell] := S;
end;

{ Удалить горячую клавишу }
procedure TMainForm.DeleteHotKeyButtonClick(Sender: TObject);
begin
  HotKetStringGrid.Cells[1,HotKeySelectedCell] := '';
  IMHotKey.HotKey := TextToShortCut('');
end;

{ Клик по строке StringGrid с горячими клавишами }
procedure TMainForm.HotKetStringGridSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  HotKeySelectedCell := ARow;
  IMHotKey.HotKey := TextToShortCut(HotKetStringGrid.Cells[1,ARow]);
end;

{ Показываем всплывающе сообщение в трее }
procedure TMainForm.ShowBalloonHint(BalloonTitle, BalloonMsg: WideString);
begin
  if ShowTrayEvents then
    MSpeechTray.ShowBalloonHint(BalloonTitle, BalloonMsg, bitInfo, 10);
end;

{ Показываем всплывающе сообщение в трее с указанием его типа }
procedure TMainForm.ShowBalloonHint(BalloonTitle, BalloonMsg: WideString; BalloonIconType: TBalloonHintIcon);
begin
  if ShowTrayEvents then
    MSpeechTray.ShowBalloonHint(BalloonTitle, BalloonMsg, BalloonIconType, 10);
end;

procedure TMainForm.ClearLogButtonClick(Sender: TObject);
begin
  LogMemo.Clear;
end;

procedure TMainForm.CBEnableSendTextClick(Sender: TObject);
begin
  GBSendText.Visible := CBEnableSendText.Checked;
end;

procedure TMainForm.CBEnableSendTextInactiveWindowClick(Sender: TObject);
begin
{$ifdef LICENSE}
  if CheckLicense(ProgramsPath) then
    EnableSendTextInactiveWindow := (Sender as TCheckBox).Checked
  else
    EnableSendTextInactiveWindow := False;
{$endif LICENSE}
{$ifdef FREE_MSPEECH}
  EnableSendTextInactiveWindow := (Sender as TCheckBox).Checked;
{$endif FREE_MSPEECH}
  if not (Sender as TCheckBox).Checked then
    CBMethodSendingTextChange(CBMethodSendingText)
  else
  begin
    LClassName.Enabled := not EnableSendTextInactiveWindow;
    EClassNameReciver.Enabled := not EnableSendTextInactiveWindow;
  end;
  LMethodSendingText.Enabled := not EnableSendTextInactiveWindow;
  CBMethodSendingText.Enabled := not EnableSendTextInactiveWindow;
  LInactiveWindowCaption.Enabled := EnableSendTextInactiveWindow;
  EInactiveWindowCaption.Enabled := EnableSendTextInactiveWindow;
  if EnableSendTextInactiveWindow then
    LNote.Caption := GetLangStr('LNoteInactive')
  else
    LNote.Caption := GetLangStr('LNote');
end;

procedure TMainForm.CBEnableTextСorrectionClick(Sender: TObject);
begin
{$ifdef LICENSE}
  if CheckLicense(ProgramsPath) then
    EnableTextСorrection := (Sender as TCheckBox).Checked
  else
    EnableTextСorrection := False;
{$endif LICENSE}
{$ifdef FREE_MSPEECH}
  EnableTextСorrection := (Sender as TCheckBox).Checked;
{$endif FREE_MSPEECH}
end;

procedure TMainForm.CBEnableReplaceClick(Sender: TObject);
begin
{$ifdef LICENSE}
  if CheckLicense(ProgramsPath) then
    GBReplaceList.Visible := (Sender as TCheckBox).Checked
  else
    GBReplaceList.Visible := False;
{$endif LICENSE}
{$ifdef FREE_MSPEECH}
  GBReplaceList.Visible := (Sender as TCheckBox).Checked;
{$endif FREE_MSPEECH}
  if CBEnableReplace.Checked then
    LoadReplaceDataStringGrid(ProgramsPath + ReplaceGridFile, ReplaceStringGrid);
end;

{ Функция получения текста из поля активного окна, используя WM_GETTEXT }
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

{ Процедура замены текста в поле активного окна, используя WM_SETTEXT }
procedure TMainForm.SetTextWnd(MyClassName, MyText: String);
var
 hFocusedWnd : HWND;
 dwThreadID : DWORD;
 pszClassName: Array [0..255] of Char;
begin
  dwThreadID := GetWindowThreadProcessId(GetForegroundWindow, nil);
  if dwThreadID <> 0 then
  begin
    LogMemo.Lines.Add(FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': SetTextWnd (2) - Найден процесс.');
    if AttachThreadInput(GetCurrentThreadId, dwThreadID, True) then
    begin
      LogMemo.Lines.Add(FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': SetTextWnd (2) - Подключение успешно.');
      hFocusedWnd := GetFocus;
      if hFocusedWnd <> 0 then
      begin
        LogMemo.Lines.Add(FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': SetTextWnd (2) - Найден фокус.');
        if Boolean(GetClassName(hFocusedWnd, pszClassName, 256)) then
        begin
          if String(pszClassName) = MyClassName then
          begin
            LogMemo.Lines.Add(FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': SetTextWnd (2) - Найден класс ' + MyClassName);
            LogMemo.Lines.Add(FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': SetTextWnd (2) - Отправляем команду.');
            if SendMessage(hFocusedWnd, WM_SETTEXT, 0, lParam(PChar(MyText))) > 0 then
              LogMemo.Lines.Add(FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': SetTextWnd (2) - Команда WM_SETTEXT успешно передана.');
          end;
        end;
      end;
      AttachThreadInput(GetCurrentThreadId, dwThreadID, False);
    end;
  end;
end;

{ Процедура замены текста в поле активного окна, используя WM_SETTEXT }
procedure TMainForm.SetTextWnd(MyText: String);
var
 hFocusedWnd : HWND;
 dwThreadID : DWORD;
begin
  dwThreadID := GetWindowThreadProcessId(GetForegroundWindow, nil);
  if dwThreadID <> 0 then
  begin
    LogMemo.Lines.Add(FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': SetTextWnd - Найден процесс.');
    if AttachThreadInput(GetCurrentThreadId, dwThreadID, True) then
    begin
      hFocusedWnd := GetFocus;
      if hFocusedWnd <> 0 then
      begin
        LogMemo.Lines.Add(FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': SetTextWnd - Найден фокус.');
        LogMemo.Lines.Add(FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': SetTextWnd - Отправляем команду.');
        if SendMessage(hFocusedWnd, WM_SETTEXT, 0, lParam(PChar(MyText))) > 0 then
          LogMemo.Lines.Add(FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': SetTextWnd - Команда WM_SETTEXT успешно передана.');
      end;
      AttachThreadInput(GetCurrentThreadId, dwThreadID, False);
    end;
  end;
end;

{ Процедура добавления текста в поле активного окна, используя EM_SETSEL и EM_REPLACESEL }
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
    LogMemo.Lines.Add(FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': InsTextWnd (2) - Найден процесс.');
    if AttachThreadInput(GetCurrentThreadId, dwThreadID, True) then
    begin
      LogMemo.Lines.Add(FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': InsTextWnd (2) - Подключение успешно.');
      hFocusedWnd := GetFocus;
      if hFocusedWnd <> 0 then
      begin
        LogMemo.Lines.Add(FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': InsTextWnd (2) - Найден фокус.');
        dwBytesNeeded := SendMessage(hFocusedWnd, WM_GETTEXTLENGTH, 0, 0);
        if dwBytesNeeded > 0 then
        begin
          LogMemo.Lines.Add(FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': InsTextWnd (2) - dwBytesNeeded > 0');
          GetMem(pszWindowText, dwBytesNeeded + 1);
          try
            ZeroMemory(pszWindowText, dwBytesNeeded + 1);
            if Boolean(GetClassName(hFocusedWnd, pszClassName, 256)) then
            begin
              if String(pszClassName) = MyClassName then
              begin
                LogMemo.Lines.Add(FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': InsTextWnd (2) - Найден класс ' + MyClassName);
                LogMemo.Lines.Add(FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': InsTextWnd (2) - Отправляем команду.');
                if SendMessage(hFocusedWnd, EM_SETSEL, wParam(dwBytesNeeded), lParam(dwBytesNeeded)) > 0 then
                  LogMemo.Lines.Add(FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': InsTextWnd (2) - Команда EM_SETSEL успешно передана.');
                if SendMessage(hFocusedWnd, EM_REPLACESEL, 0, lParam(PChar(MyText))) > 0 then
                  LogMemo.Lines.Add(FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': InsTextWnd (2) - Команда EM_REPLACESEL успешно передана.');
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

{ Процедура добавления текста в поле активного окна, используя EM_SETSEL и EM_REPLACESEL }
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
    LogMemo.Lines.Add(FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': InsTextWnd - Найден процесс.');
    if AttachThreadInput(GetCurrentThreadId, dwThreadID, True) then
    begin
      hFocusedWnd := GetFocus;
      if hFocusedWnd <> 0 then
      begin
        LogMemo.Lines.Add(FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': InsTextWnd - Найден фокус.');
        dwBytesNeeded := SendMessage(hFocusedWnd, WM_GETTEXTLENGTH, 0, 0);
        if dwBytesNeeded > 0 then
        begin
          GetMem(pszWindowText, dwBytesNeeded + 1);
          try
            ZeroMemory(pszWindowText, dwBytesNeeded + 1);
            LogMemo.Lines.Add(FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': InsTextWnd - Отправляем команду.');
            if SendMessage(hFocusedWnd, EM_SETSEL, wParam(dwBytesNeeded), lParam(dwBytesNeeded)) > 0 then
              LogMemo.Lines.Add(FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': InsTextWnd - Команда EM_SETSEL успешно передана.');
            if SendMessage(hFocusedWnd, EM_REPLACESEL, 0, lParam(PChar(MyText))) > 0 then
              LogMemo.Lines.Add(FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': InsTextWnd - Команда EM_REPLACESEL успешно передана.');
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

{ Процедура добавления текста в поле активного окна, используя WM_PASTE }
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
    LogMemo.Lines.Add(FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': CopyPasteTextWnd (2) - Найден процесс.');
    if AttachThreadInput(GetCurrentThreadId, dwThreadID, True) then
    begin
      hFocusedWnd := GetFocus;
      if hFocusedWnd <> 0 then
      begin
        LogMemo.Lines.Add(FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': CopyPasteTextWnd (2) - Найден фокус.');
        if Boolean(GetClassName(hFocusedWnd, pszClassName, 256)) then
        begin
          if String(pszClassName) = MyClassName then
          begin
            LogMemo.Lines.Add(FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': CopyPasteTextWnd (2) - Найден класс ' + MyClassName);
            LogMemo.Lines.Add(FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': CopyPasteTextWnd (2) - Отправляем команду.');
            Clipboard.Clear;
            Clipboard.AsText := MyText;
            if DetectMethodSendingText(MethodSendingText) = mWM_PASTE then
            begin
              // Метод WM_PASTE
              if SendMessage(hFocusedWnd, WM_PASTE, 0, 0) > 0 then
                LogMemo.Lines.Add(FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': CopyPasteTextWnd (2) - Команда WM_PASTE успешно передана.');
            end
            else if DetectMethodSendingText(MethodSendingText) = mWM_PASTE_MOD then
            begin
              // Модифицированный метод WM_PASTE, через отправку сочетания Ctrl+V
              PostMessage(hFocusedWnd, WM_SETFOCUS,0,0);
              keybd_event(VK_CONTROL, MapVirtualKey(VK_CONTROL, 0), 0, 0);
              keybd_event(Ord('V'), MapVirtualKey(Ord('V'), 0), 0, 0);
              keybd_event(Ord('V'), 0, KEYEVENTF_KEYUP, 0);
              keybd_event(VK_CONTROL, MapVirtualKey(VK_CONTROL,0), KEYEVENTF_KEYUP, 0);
              LogMemo.Lines.Add(FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': CopyPasteTextWnd - Команда Ctrl+V успешно передана.');
            end;
          end;
        end;
      end;
      AttachThreadInput(GetCurrentThreadId, dwThreadID, False);
    end;
  end;
end;

procedure TMainForm.CommandStringGridSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  CommandStringSelectedCell := ARow;
  ECommandKey.Text := CommandStringGrid.Cells[0,ARow];
  ECommandExec.Text := CommandStringGrid.Cells[1,ARow];
  CBCommandType.ItemIndex := DetectCommandType(DetectCommandTypeName(CommandStringGrid.Cells[2,ARow]));
  CBCommandTypeChange(CBCommandType);
  DeleteCommandButton.Enabled := True;
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
    LogMemo.Lines.Add(FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': CopyPasteTextWnd - Найден процесс.');
    if AttachThreadInput(GetCurrentThreadId, dwThreadID, True) then
    begin
      hFocusedWnd := GetFocus;
      if hFocusedWnd <> 0 then
      begin
        LogMemo.Lines.Add(FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': CopyPasteTextWnd - Найден фокус.');
        Clipboard.Clear;
        Clipboard.AsText := MyText;
        //if SendMessage(hFocusedWnd, WM_PASTE, 0, 0) > 0 then
        //  LogMemo.Lines.Add(FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': CopyPasteTextWnd - Команда WM_PASTE успешно передана.');
        if DetectMethodSendingText(MethodSendingText) = mWM_PASTE then
        begin
          // Метод WM_PASTE
          if SendMessage(hFocusedWnd, WM_PASTE, 0, 0) > 0 then
            LogMemo.Lines.Add(FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': CopyPasteTextWnd - Команда WM_PASTE успешно передана.');
        end
        else if DetectMethodSendingText(MethodSendingText) = mWM_PASTE_MOD then
        begin
          // Модифицированный метод WM_PASTE, через отправку сочетания Ctrl+V
          PostMessage(hFocusedWnd, WM_SETFOCUS,0,0);
          keybd_event(VK_CONTROL, MapVirtualKey(VK_CONTROL, 0), 0, 0);
          keybd_event(Ord('V'), MapVirtualKey(Ord('V'), 0), 0, 0);
          keybd_event(Ord('V'), 0, KEYEVENTF_KEYUP, 0);
          keybd_event(VK_CONTROL, MapVirtualKey(VK_CONTROL,0), KEYEVENTF_KEYUP, 0);
          LogMemo.Lines.Add(FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': CopyPasteTextWnd - Команда Ctrl+V успешно передана.');
        end;
      end;
      AttachThreadInput(GetCurrentThreadId, dwThreadID, False);
    end;
  end;
end;

{ Процедура добавления текста в поле активного окна, используя WM_CHAR }
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
    LogMemo.Lines.Add(FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': SetCharTextWnd - Найден процесс.');
    if AttachThreadInput(GetCurrentThreadId, dwThreadID, True) then
    begin
      hFocusedWnd := GetFocus;
      if hFocusedWnd <> 0 then
      begin
        LogMemo.Lines.Add(FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': SetCharTextWnd - Найден фокус.');
        LogMemo.Lines.Add(FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': SetCharTextWnd - Отправляем текст...');
        for Cnt := 1 to Length(MyText) do
          PostMessage(hFocusedWnd, WM_CHAR, Word(MyText[Cnt]), 0);
        //PostMessage(hFocusedWnd, WM_KEYDOWN, VK_RETURN, 0);
      end;
      AttachThreadInput(GetCurrentThreadId, dwThreadID, False);
    end;
  end;
end;

procedure TMainForm.CBMethodSendingTextChange(Sender: TObject);
begin
  if DetectMethodSendingText((Sender as TComboBox).ItemIndex) = mWM_CHAR then
  begin
    LClassName.Enabled := False;
    EClassNameReciver.Enabled := False;
  end
  else
  begin
    LClassName.Enabled := True;
    EClassNameReciver.Enabled := True;
  end;
end;

{ Прозрачность окон }
procedure TMainForm.CBAlphaBlendClick(Sender: TObject);
begin
  AlphaBlendEnable := (Sender as TCheckBox).Checked;
  // Вкл. прозрачность окна настроек
  AlphaBlend := AlphaBlendEnable;
  if AlphaBlendEnable then
  begin
    AlphaBlendTrackBar.Visible := True;
    AlphaBlendVar.Visible := True;
    AlphaBlendTrackBar.Position := AlphaBlendEnableValue;
    AlphaBlendVar.Caption := IntToStr(AlphaBlendEnableValue);
  end
  else
  begin
    AlphaBlendTrackBar.Visible := False;
    AlphaBlendVar.Visible := False;
  end;
end;

procedure TMainForm.CBCommandTypeChange(Sender: TObject);
begin
  if DetectCommandTypeName((Sender as TComboBox).Items[(Sender as TComboBox).ItemIndex]) = mExecPrograms then
    LCommandExec.Caption := GetLangStr('LCommandExec')
  else if DetectCommandTypeName((Sender as TComboBox).Items[(Sender as TComboBox).ItemIndex]) = mClosePrograms then
    LCommandExec.Caption := GetLangStr('LCommandClose')
  else
    LCommandExec.Caption := GetLangStr('LCommandKill');
end;

procedure TMainForm.AlphaBlendTrackBarChange(Sender: TObject);
begin
  AlphaBlendEnableValue := AlphaBlendTrackBar.Position;
  // Прозрачность окна настроек
  AlphaBlendValue := AlphaBlendEnableValue;
  AlphaBlendVar.Caption := IntToStr(AlphaBlendEnableValue);
end;

{ Отлавливаем событие WM_MSGBOX для изменения прозрачности окна }
procedure TMainForm.msgBoxShow(var Msg: TMessage);
var
  msgbHandle: HWND;
begin
  msgbHandle := GetActiveWindow;
  if msgbHandle <> 0 then
    MakeTransp(msgbHandle);
end;

{ Процедура поиска языковых файлов и заполнения списка }
procedure TMainForm.FindLangFile;
var
  SR: TSearchRec;
  I: Integer;
begin
  CBLang.Items.Clear;
  if FindFirst(ProgramsPath + dirLangs + '\*.*', faAnyFile or faDirectory, SR) = 0 then
  begin
    repeat
      if (SR.Attr = faDirectory) and ((SR.Name = '.') or (SR.Name = '..')) then // Чтобы не было файлов . и ..
      begin
        Continue; // Продолжаем цикл
      end;
      if MatchStrings(SR.Name, '*.xml') then
      begin
        // Заполняем лист
        CBLang.Items.Add(ExtractFileNameEx(SR.Name, False));
      end;
    until FindNext(SR) <> 0;
    FindClose(SR);
  end;
  for I := 0 to CBLang.Items.Count-1 do
  begin
    if CBLang.Items[I] = CoreLanguage then
      CBLang.ItemIndex := I;
  end;
end;

procedure TMainForm.CBLangChange(Sender: TObject);
begin
  FLanguage := (Sender as TComboBox).Items[(Sender as TComboBox).ItemIndex];
  DefaultLanguage := (Sender as TComboBox).Items[(Sender as TComboBox).ItemIndex];
  CoreLanguageChanged;
  LoadSettings;
end;

procedure TMainForm.ReplaceStringGridSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  ReplaceStringSelectedCell := ARow;
  EReplaceIN.Text := ReplaceStringGrid.Cells[0,ARow];
  EReplaceOUT.Text := ReplaceStringGrid.Cells[1,ARow];
  DeleteReplaceButton.Enabled := True;
end;

procedure TMainForm.ECommandExecKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Sender as TEdit).Text <> '' then
    ActivateDeleteCommandButton := True
  else
    ActivateDeleteCommandButton := False;
  if ActivateAddCommandButton and ActivateDeleteCommandButton then
    AddCommandButton.Enabled := True
  else
    AddCommandButton.Enabled := False;
end;

procedure TMainForm.ECommandKeyKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Sender as TEdit).Text <> '' then
    ActivateAddCommandButton := True
  else
    ActivateAddCommandButton := False;
  if ActivateAddCommandButton and ActivateDeleteCommandButton then
    AddCommandButton.Enabled := True
  else
    AddCommandButton.Enabled := False;
end;

{ Добывить команду }
procedure TMainForm.AddCommandButtonClick(Sender: TObject);
begin
  if (ECommandKey.Text <> '') and (ECommandExec.Text <> '') then
  begin
    CommandStringGrid.RowCount := CommandStringGrid.RowCount + 1;
    CommandStringGrid.Cells[0,CommandStringGrid.RowCount-1] := ECommandKey.Text;
    CommandStringGrid.Cells[1,CommandStringGrid.RowCount-1] := ECommandExec.Text;
    CommandStringGrid.Cells[2,CommandStringGrid.RowCount-1] := DetectCommandType(CBCommandType.ItemIndex);
  end;
end;

{ Удалить команду }
procedure TMainForm.DeleteCommandButtonClick(Sender: TObject);
begin
  if (CommandStringSelectedCell = 0) and (CommandStringGrid.RowCount = 1) then
    MsgInf(ProgramsName, Format(GetLangStr('MsgInf5'), [#13]))
  else
    THackGrid(CommandStringGrid).DeleteRow(CommandStringSelectedCell);
end;

procedure TMainForm.AddReplaceButtonClick(Sender: TObject);
begin
  if (EReplaceIN.Text <> '') and (EReplaceOUT.Text <> '') then
  begin
    ReplaceStringGrid.RowCount := ReplaceStringGrid.RowCount + 1;
    ReplaceStringGrid.Cells[0,ReplaceStringGrid.RowCount-1] := EReplaceIN.Text;
    ReplaceStringGrid.Cells[1,ReplaceStringGrid.RowCount-1] := EReplaceOUT.Text;
  end;
end;

procedure TMainForm.DeleteReplaceButtonClick(Sender: TObject);
begin
  if (ReplaceStringSelectedCell = 0) and (ReplaceStringGrid.RowCount = 1) then
    MsgInf(ProgramsName, Format(GetLangStr('MsgInf6'), [#13]))
  else
    THackGrid(ReplaceStringGrid).DeleteRow(ReplaceStringSelectedCell);
end;

procedure TMainForm.EReplaceINKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Sender as TEdit).Text <> '' then
    ActivateAddReplaceButton := True
  else
    ActivateAddReplaceButton := False;
  if ActivateAddReplaceButton and ActivateDeleteReplaceButton then
    AddReplaceButton.Enabled := True
  else
    AddReplaceButton.Enabled := False;
end;

procedure TMainForm.EReplaceOUTKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Sender as TEdit).Text <> '' then
    ActivateDeleteReplaceButton := True
  else
    ActivateDeleteReplaceButton := False;
  if ActivateAddReplaceButton and ActivateDeleteReplaceButton then
    AddReplaceButton.Enabled := True
  else
    AddReplaceButton.Enabled := False;
end;

procedure TMainForm.AddCommmandsToList;
begin
  // Список команд
  CBCommandType.Clear;
  CBCommandType.Items.Add(DetectCommandTypeName(mExecPrograms));
  CBCommandType.Items.Add(DetectCommandTypeName(mClosePrograms));
  CBCommandType.Items.Add(DetectCommandTypeName(mKillPrograms));
  CBCommandType.ItemIndex := 0;
end;

{ Функция для мультиязыковой поддержки }
procedure TMainForm.CoreLanguageChanged;
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
    Global.CoreLanguage := CoreLanguage;
    SendMessage(MainFormHandle, WM_LANGUAGECHANGED, 0, 0);
    SendMessage(AboutFormHandle, WM_LANGUAGECHANGED, 0, 0);
  except
    on E: Exception do
      MsgDie(ProgramsName, 'Error on CoreLanguageChanged: ' + E.Message + sLineBreak +
        'CoreLanguage: ' + CoreLanguage);
  end;
end;

{ Смена языка интерфейса по событию WM_LANGUAGECHANGED }
procedure TMainForm.OnLanguageChanged(var Msg: TMessage);
begin
  LoadLanguageStrings;
end;

{ Для мультиязыковой поддержки }
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
  MSpeechPopupMenu.Items[2].Caption := GetLangStr('MSpeechPopupMenuAbout');
  MSpeechPopupMenu.Items[3].Caption := GetLangStr('MSpeechPopupMenuExit');
  GBMain.Caption := Format(' %s ', [GetLangStr('GBMain')]);
  LSignalLevel.Caption := GetLangStr('LSignalLevel');
  StartButton.Caption := GetLangStr('StartButton');
  StopButton.Caption := GetLangStr('StopButton');
  SettingsButton.Caption := GetLangStr('SettingsButton');
  SaveSettingsButton.Caption := GetLangStr('SaveSettingsButton');
  TabSheetSettings.Caption := GetLangStr('TabSheetSettings');
  TabSheetRecord.Caption := GetLangStr('TabSheetRecord');
  TabSheetConnectSettings.Caption  := GetLangStr('TabSheetConnectSettings');
  TabSheetCommand.Caption  := GetLangStr('TabSheetCommand');
  TabSheetHotKey.Caption := GetLangStr('TabSheetHotKey');
  TabSheetLog.Caption := GetLangStr('TabSheetLog');
  TabSheetSendText.Caption := GetLangStr('TabSheetSendText');
  TabSheetTextCorrection.Caption := GetLangStr('TabSheetTextCorrection');
  HotKetStringGrid.Cells[0,0] := GetLangStr('StartStopRecord');
  HotKetStringGrid.Cells[0,1] := GetLangStr('StartStopRecordWithoutSendText');
  GBInterfaceSettings.Caption := Format(' %s ', [GetLangStr('GBInterfaceSettings')]);
  CBAlphaBlend.Caption := GetLangStr('CBAlphaBlend');
  CBShowTrayEvents.Caption := GetLangStr('CBShowTrayEvents');
  LLang.Caption := GetLangStr('LLang');
  GBRecordSettings.Caption := Format(' %s ', [GetLangStr('GBRecordSettings')]);
  LDevice.Caption := GetLangStr('LDevice');
  MicSettingsButton.Caption := GetLangStr('MicSettingsButton');
  LMaxLevel.Caption := GetLangStr('LMaxLevel');
  LMaxLevelInterrupt.Caption := GetLangStr('LMaxLevelInterrupt');
  LMinLevel.Caption := GetLangStr('LMinLevel');
  LEMinLevelInterrupt.Caption := GetLangStr('LEMinLevelInterrupt');
  CBMaxLevelControl.Caption := GetLangStr('CBMaxLevelControl');
  LStopRecordAction.Caption := GetLangStr('LStopRecordAction');
  CBStopRecordAction.Clear;
  CBStopRecordAction.Items.Add(GetLangStr('CBStopRecordActionItems1'));
  CBStopRecordAction.Items.Add(GetLangStr('CBStopRecordActionItems2'));
  CBStopRecordAction.Items.Add(GetLangStr('CBStopRecordActionItems3'));
  CBStopRecordAction.Items.Add(GetLangStr('CBStopRecordActionItems4'));
  CBStopRecordAction.ItemIndex := 0;
  GBConnectSettings.Caption := Format(' %s ', [GetLangStr('GBConnectSettings')]);
  CBUseProxy.Caption := GetLangStr('CBUseProxy');
  LProxyAddress.Caption := GetLangStr('LProxyAddress');
  LProxyPort.Caption := GetLangStr('LProxyPort');
  CBProxyAuth.Caption := GetLangStr('CBProxyAuth');
  LProxyUser.Caption := GetLangStr('LProxyUser');
  LProxyUserPasswd.Caption := GetLangStr('LProxyUserPasswd');
  CBHotKey.Caption := GetLangStr('CBHotKey');
  GBHotKey.Caption := Format(' %s ', [GetLangStr('GBHotKey')]);
  SetHotKeyButton.Caption := GetLangStr('SetHotKeyButton');
  DeleteHotKeyButton.Caption := GetLangStr('DeleteHotKeyButton');
  ClearLogButton.Caption := GetLangStr('ClearLogButton');
  CBEnableSendText.Caption := GetLangStr('CBEnableSendText');
  GBSendText.Caption := Format(' %s ', [GetLangStr('GBSendText')]);
  LMethodSendingText.Caption := GetLangStr('LMethodSendingText');
  LClassName.Caption := GetLangStr('LClassName');
  if EnableSendTextInactiveWindow then
    LNote.Caption := GetLangStr('LNoteInactive')
  else
    LNote.Caption := GetLangStr('LNote');
  LRegion.Caption := GetLangStr('LRegion');
  GBCommand.Caption := Format(' %s ', [GetLangStr('GBCommand')]);
  LCommandKey.Caption := GetLangStr('LCommandKey');
  LCommandExec.Caption := GetLangStr('LCommandExec');
  LCommandType.Caption := GetLangStr('LCommandType');
  AddCommandButton.Caption := GetLangStr('AddCommandButton');
  DeleteCommandButton.Caption := GetLangStr('DeleteCommandButton');
  CBEnableReplace.Caption := GetLangStr('CBEnableReplace');
  CBFirstLetterUpper.Caption := GetLangStr('CBFirstLetterUpper');
  GBReplaceList.Caption := Format(' %s ', [GetLangStr('GBReplaceList')]);
  LReplaceIN.Caption := GetLangStr('LReplaceIN');
  LReplaceOUT.Caption := GetLangStr('LReplaceOUT');
  AddReplaceButton.Caption := GetLangStr('AddReplaceButton');
  DeleteReplaceButton.Caption := GetLangStr('DeleteReplaceButton');
  // Список команд
  AddCommmandsToList;
  LoadCommandDataStringGrid(ProgramsPath + CommandGridFile, CommandStringGrid);
  CBEnableSendTextInactiveWindow.Caption := GetLangStr('CBEnableSendTextInactiveWindow');
  CBEnableTextСorrection.Caption := GetLangStr('CBEnableTextСorrection');
  LInactiveWindowCaption.Caption := GetLangStr('LInactiveWindowCaption');
  // Позиционируем контролы
  CBLang.Left := LLang.Left + LLang.Width + 5;
  CBDevice.Left := LDevice.Left + LDevice.Width + 5;
  MicSettingsButton.Left := LDevice.Left + LDevice.Width + 5 + CBDevice.Width + 5;
  CBStopRecordAction.Left := LStopRecordAction.Left + LStopRecordAction.Width + 5;
  EProxyAddress.Left := LProxyAddress.Left + LProxyAddress.Width + 5;
  LProxyPort.Left := LProxyAddress.Left + LProxyAddress.Width + 5 + EProxyAddress.Width + 5;
  EProxyPort.Left := LProxyAddress.Left + LProxyAddress.Width + 5 + EProxyAddress.Width + 5 + LProxyPort.Width + 5;
  CBRegion.Left := LRegion.Left + LRegion.Width + 5;
end;

end.
