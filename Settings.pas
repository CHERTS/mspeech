{ ############################################################################ }
{ #                                                                          # }
{ #  MSpeech v1.4 - Распознавание речи используя Google Speech API           # }
{ #                                                                          # }
{ #  License: GPLv3                                                          # }
{ #                                                                          # }
{ #  Author: Mikhail Grigorev (icq: 161867489, email: sleuthhound@gmail.com) # }
{ #                                                                          # }
{ ############################################################################ }

unit Settings;

interface

{$I MSpeech.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, Types, StdCtrls, IniFiles, ComCtrls,  ExtCtrls, ButtonGroup, uIMButtonGroup,
  Buttons, Menus, ImgList, Vcl.Grids, Global, Vcl.Samples.Spin, ActiveX, SpeechLib_TLB,
  ACS_Classes, ACS_DXAudio, JvComponentBase, JvFormPlacement
  {$ifdef LICENSE}, License{$endif LICENSE};

type
  THackGrid = class(TStringGrid);
  TSettingsForm = class(TForm)
    SettingtButtonGroup: TIMButtonGroup;
    SaveSettingsButton: TButton;
    CloseButton: TButton;
    ImageList_Main: TImageList;
    SettingsPageControl: TPageControl;
    TabSheetSettings: TTabSheet;
    GBInterfaceSettings: TGroupBox;
    LLang: TLabel;
    AlphaBlendVar: TLabel;
    CBShowTrayEvents: TCheckBox;
    CBAlphaBlend: TCheckBox;
    AlphaBlendTrackBar: TTrackBar;
    CBLang: TComboBox;
    TabSheetRecord: TTabSheet;
    GBRecordSettings: TGroupBox;
    LMaxLevel: TLabel;
    LMaxLevelInterrupt: TLabel;
    LMinLevel: TLabel;
    LEMinLevelInterrupt: TLabel;
    LDevice: TLabel;
    LStopRecordAction: TLabel;
    LRegion: TLabel;
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
    CBRegion: TComboBox;
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
    TabSheetCommand: TTabSheet;
    GBCommand: TGroupBox;
    LCommandKey: TLabel;
    LCommandExec: TLabel;
    LCommandType: TLabel;
    SBCommandSelect: TSpeedButton;
    ECommandKey: TEdit;
    ECommandExec: TEdit;
    CommandStringGrid: TStringGrid;
    AddCommandButton: TButton;
    DeleteCommandButton: TButton;
    CBCommandType: TComboBox;
    TabSheetHotKey: TTabSheet;
    CBEnableHotKey: TCheckBox;
    GBHotKey: TGroupBox;
    HotKetStringGrid: TStringGrid;
    IMHotKey: THotKey;
    SetHotKeyButton: TButton;
    DeleteHotKeyButton: TButton;
    TabSheetSendText: TTabSheet;
    GBSendText: TGroupBox;
    LClassName: TLabel;
    LNote: TLabel;
    LMethodSendingText: TLabel;
    LInactiveWindowCaption: TLabel;
    EClassNameReciver: TEdit;
    CBMethodSendingText: TComboBox;
    CBEnableSendTextInactiveWindow: TCheckBox;
    EInactiveWindowCaption: TEdit;
    CBEnableSendText: TCheckBox;
    TabSheetTextCorrection: TTabSheet;
    GBTextCorrection: TGroupBox;
    TabSheetTextToSpeech: TTabSheet;
    CBEnableTextToSpeech: TCheckBox;
    GBTextToSpeech: TGroupBox;
    LTextToSpeechEngine: TLabel;
    CBTextToSpeechEngine: TComboBox;
    GBTextToSpeechEngine: TGroupBox;
    LVoiceVolumeDesc: TLabel;
    LVoiceSpeedDesc: TLabel;
    LVoice: TLabel;
    LVoiceVolume: TLabel;
    LVoiceSpeed: TLabel;
    TBVoiceVolume: TTrackBar;
    TBVoiceSpeed: TTrackBar;
    CBVoice: TComboBox;
    LBSAPIInfo: TListBox;
    CommandOpenDialog: TOpenDialog;
    GBLogs: TGroupBox;
    SEErrLogSize: TSpinEdit;
    LErrLogSize: TLabel;
    CBEnableLogs: TCheckBox;
    GBTextToSpeechList: TGroupBox;
    LTextToSpeechText: TLabel;
    LTextToSpeechEventsTypeStatus: TLabel;
    LTextToSpeechEventsType: TLabel;
    ETextToSpeech: TEdit;
    TextToSpeechStringGrid: TStringGrid;
    AddTextToSpeechButton: TButton;
    DeleteTextToSpeechButton: TButton;
    CBEventsType: TComboBox;
    CBTextToSpeechStatus: TComboBox;
    DXAudioIn: TDXAudioIn;
    СhangeTextToSpeechButton: TButton;
    ChangeCommandButton: TButton;
    CBEnableExecCommand: TCheckBox;
    CBEnableReplace: TCheckBox;
    CBFirstLetterUpper: TCheckBox;
    GBReplaceList: TGroupBox;
    LReplaceIN: TLabel;
    EReplaceIN: TEdit;
    LReplaceOUT: TLabel;
    EReplaceOUT: TEdit;
    ReplaceStringGrid: TStringGrid;
    AddReplaceButton: TButton;
    ChangeReplaceButton: TButton;
    DeleteReplaceButton: TButton;
    CBEnableTextСorrection: TCheckBox;
    SettingsFormStorage: TJvFormStorage;
    CBEnableFilters: TCheckBox;
    GBFilters: TGroupBox;
    RGFiltersType: TRadioGroup;
    GBWindowedSincFilter: TGroupBox;
    GBVoiceFilter: TGroupBox;
    CBVoiceFilterEnableAGC: TCheckBox;
    CBVoiceFilterEnableNoiseReduction: TCheckBox;
    CBVoiceFilterEnableVAD: TCheckBox;
    LSincFilterType: TLabel;
    CBSincFilterType: TComboBox;
    LLowFreq: TLabel;
    ELowFreq: TEdit;
    LHighFreq: TLabel;
    EHighFreq: TEdit;
    LKernelWidth: TLabel;
    EKernelWidth: TEdit;
    LWindowType: TLabel;
    CBWindowType: TComboBox;
    LDefaultCommandExec: TLabel;
    EDefaultCommandExec: TEdit;
    LDefaultCommandExecDesc: TLabel;
    SBDefaultCommandSelect: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SettingtButtonGroupClick(Sender: TObject);
    procedure SaveSettingsButtonClick(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
    procedure CBDeviceChange(Sender: TObject);
    procedure MicSettingsButtonClick(Sender: TObject);
    procedure EMinLevelKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure UpDownMinLevelClick(Sender: TObject; Button: TUDBtnType);
    procedure EMinLevelInterruptKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure UpDownMinLevelInterruptClick(Sender: TObject; Button: TUDBtnType);
    procedure UpDownMaxLevelClick(Sender: TObject; Button: TUDBtnType);
    procedure EMaxLevelKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EMaxLevelInterruptKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure UpDownMaxLevelInterruptClick(Sender: TObject; Button: TUDBtnType);
    procedure CBMaxLevelControlClick(Sender: TObject);
    procedure CBUseProxyClick(Sender: TObject);
    procedure CBProxyAuthClick(Sender: TObject);
    procedure CBEnableHotKeyClick(Sender: TObject);
    procedure SetHotKeyButtonClick(Sender: TObject);
    procedure DeleteHotKeyButtonClick(Sender: TObject);
    procedure HotKetStringGridSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
    procedure CBStopRecordActionChange(Sender: TObject);
    procedure CBEnableSendTextClick(Sender: TObject);
    procedure CBMethodSendingTextChange(Sender: TObject);
    procedure CBLangChange(Sender: TObject);
    procedure CBAlphaBlendClick(Sender: TObject);
    procedure AlphaBlendTrackBarChange(Sender: TObject);
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
    procedure ECommandKeyKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ECommandExecKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure SBCommandSelectClick(Sender: TObject);
    procedure CBCommandTypeChange(Sender: TObject);
    procedure CBEnableTextToSpeechClick(Sender: TObject);
    procedure CBTextToSpeechEngineChange(Sender: TObject);
    procedure CBVoiceChange(Sender: TObject);
    procedure TBVoiceVolumeChange(Sender: TObject);
    procedure TBVoiceSpeedChange(Sender: TObject);
    procedure SettingtButtonGroupKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure CBEnableLogsClick(Sender: TObject);
    procedure ETextToSpeechKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure AddTextToSpeechButtonClick(Sender: TObject);
    procedure DeleteTextToSpeechButtonClick(Sender: TObject);
    procedure TextToSpeechStringGridSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
    procedure СhangeTextToSpeechButtonClick(Sender: TObject);
    procedure ChangeCommandButtonClick(Sender: TObject);
    procedure ChangeReplaceButtonClick(Sender: TObject);
    procedure CBEnableExecCommandClick(Sender: TObject);
    procedure CBEnableFiltersClick(Sender: TObject);
    procedure RGFiltersTypeClick(Sender: TObject);
    procedure SBDefaultCommandSelectClick(Sender: TObject);
  private
    { Private declarations }
    HotKeySelectedCell: Integer;
    ReplaceStringSelectedCell: Integer;
    CommandStringSelectedCell: Integer;
    TextToSpeechStringSelectedCell: Integer;
    SgpIVTxt: TSpVoice;
    SVoices: ISpeechObjectTokens;
    procedure OnLanguageChanged(var Msg: TMessage); message WM_LANGUAGECHANGED;
    procedure msgBoxShow(var Msg: TMessage); message WM_MSGBOX;
    procedure LoadLanguageStrings;
    function SAPIActivate: Boolean;
    procedure SAPIDeactivate;
    procedure SAPITextToSpeech(MyText: String);
  public
    { Public declarations }
    ActivateAddReplaceButton: Boolean;
    ActivateDeleteReplaceButton: Boolean;
    ActivateAddCommandButton: Boolean;
    ActivateDeleteCommandButton: Boolean;
    ActivateAddTextToSpeechButton: Boolean;
    procedure LoadSettings;
    procedure FindLangFile;
    procedure AddCommmandsToList;
    procedure SetSAPISettings;
    procedure SetGoogleTextToSpeechSettings;
    procedure AddEventsTypeToList;
    procedure AddEventsTypeStatusToList;
  end;

var
  SettingsForm: TSettingsForm;

implementation

{$R *.dfm}

procedure TSettingsForm.CloseButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TSettingsForm.FormCreate(Sender: TObject);
var
  I: Integer;
begin
  // Для мультиязыковой поддержки
  SettingsFormHandle := Handle;
  SetWindowLong(Handle, GWL_HWNDPARENT, 0);
  SetWindowLong(Handle, GWL_EXSTYLE, GetWindowLong(Handle, GWL_EXSTYLE) or WS_EX_APPWINDOW);
  // Отключаем табы
  for I := 0 to SettingsPageControl.PageCount-1 do
    SettingsPageControl.Pages[I].TabVisible := False;
end;

procedure TSettingsForm.FormShow(Sender: TObject);
var
  DevCnt: Integer;
begin
  // Создаем горячие клавиши
  HotKetStringGrid.RowCount := 3;
  // Замена текста
  ReplaceStringGrid.ColWidths[0] := 170;
  ReplaceStringSelectedCell := 1;
  ActivateAddReplaceButton := False;
  ActivateDeleteReplaceButton := False;
  ActivateAddTextToSpeechButton := False;
  // Активируем настройки
  LoadSettings;
  // Загружаем язык интерфейса
  LoadLanguageStrings;
  // Первая вкладка настроек
  SettingtButtonGroup.ItemIndex := 0;
  SettingsPageControl.ActivePage := TabSheetSettings;
  // Заполняем список устройст записи
  CBDevice.Clear;
  for DevCnt := 0 to DXAudioIn.DeviceCount - 1 do
    CBDevice.Items.Add(DXAudioIn.DeviceName[DevCnt]);
  if DXAudioIn.DeviceCount > DefaultAudioDeviceNumber then
    CBDevice.ItemIndex := DefaultAudioDeviceNumber
  else
    CBDevice.ItemIndex := 0;
  // Прозрачность окна
  AlphaBlend := AlphaBlendEnable;
  AlphaBlendValue := AlphaBlendEnableValue;
end;

procedure TSettingsForm.SaveSettingsButtonClick(Sender: TObject);
begin
  StartSaveSettings := True;
  // Останавливаем потоки распознавания и запись
  SendMessage(MainFormHandle, WM_STARTSAVESETTINGS, 0, 0);
  // Устанавливаем новые настройки
  // Команды
  SaveCommandDataStringGrid(WorkPath + CommandGridFile, CommandStringGrid);
  // Прокси
  UseProxy := CBUseProxy.Checked;
  ProxyAddress := EProxyAddress.Text;
  ProxyPort := EProxyPort.Text;
  ProxyAuth := CBProxyAuth.Checked;
  ProxyUser := EProxyUser.Text;
  ProxyUserPasswd := EProxyUserPasswd.Text;
  // Всплывашки
  ShowTrayEvents := CBShowTrayEvents.Checked;
  // Логгирование
  MaxDebugLogSize := StrToInt(SEErrLogSize.Text);
  // Передача текста в другие программы
  EnableSendText := CBEnableSendText.Checked;
  ClassNameReciver := EClassNameReciver.Text;
  MethodSendingText := CBMethodSendingText.ItemIndex;
  // Коррекция текста
  {$ifdef LICENSE}
  CBEnableSendTextInactiveWindow.OnClick := nil;
  CBEnableTextСorrection.OnClick := nil;
  if CheckLicense(WorkPath, True) then
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
  CBEnableSendTextInactiveWindow.OnClick := CBEnableSendTextInactiveWindowClick;
  CBEnableTextСorrection.OnClick := CBEnableTextСorrectionClick;
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
  // Авто-активация
  MaxLevelOnAutoControl := CBMaxLevelControl.Checked;
  // Действие кнопки "Остановить запись"
  StopRecordAction := CBStopRecordAction.ItemIndex;
  EnableExecCommand := CBEnableExecCommand.Checked;
  // Горячая клавиша
  GlobalHotKeyEnable := CBEnableHotKey.Checked;
  StartRecordHotKey := HotKetStringGrid.Cells[1,0];
  StartRecordWithoutSendTextHotKey := HotKetStringGrid.Cells[1,1];
  StartRecordWithoutExecCommandHotKey := HotKetStringGrid.Cells[1,2];
  // Язык распознавания
  DefaultSpeechRecognizeLang := DetectRegionStr(CBRegion.ItemIndex);
  // Замена текста
  if EnableTextReplace then
    SaveReplaceDataStringGrid(WorkPath + ReplaceGridFile, ReplaceStringGrid);
  // Синтез голоса
  EnableTextToSpeech := CBEnableTextToSpeech.Checked;
  TextToSpeechEngine := CBTextToSpeechEngine.ItemIndex;
  if TextToSpeechEngine = 0 then // Если Microsoft SAPI
    SAPIVoiceNum := CBVoice.ItemIndex
  else
  begin
    GoogleTL := DetectTextToSpeechRegionStr(CBVoice.ItemIndex);
    SAPIVoiceNum := 0;
  end;
  SAPIVoiceVolume := TBVoiceVolume.Position;
  SAPIVoiceSpeed := TBVoiceSpeed.Position;
  if EnableTextToSpeech then
    SaveTextToSpeechDataStringGrid(WorkPath + TextToSpeechGridFile, TextToSpeechStringGrid);
  // Фильтры
  EnableFilters := CBEnableFilters.Checked;
  FilterType := RGFiltersType.ItemIndex;
  SincFilterType := CBSincFilterType.ItemIndex;
  SincFilterLowFreq := StrToInt(ELowFreq.Text);
  SincFilterHighFreq := StrToInt(EHighFreq.Text);
  SincFilterKernelWidth := StrToInt(EKernelWidth.Text);
  SincFilterWindowType := CBWindowType.ItemIndex;
  VoiceFilterEnableAGC := CBVoiceFilterEnableAGC.Checked;
  VoiceFilterEnableNoiseReduction := CBVoiceFilterEnableNoiseReduction.Checked;
  VoiceFilterEnableVAD := CBVoiceFilterEnableVAD.Checked;
  // Команда по-умолчанию
  DefaultCommandExec := EDefaultCommandExec.Text;
  // Сохраняем настройки
  SaveINI(WorkPath);
  SAPIDeactivate;
  // Для основной формы
  SendMessage(MainFormHandle, WM_SAVESETTINGSDONE, 0, 0);
  StartSaveSettings := False;
  Close;
end;

procedure TSettingsForm.SettingtButtonGroupClick(Sender: TObject);
begin
  SettingsPageControl.ActivePageIndex := SettingtButtonGroup.ItemIndex;
end;

procedure TSettingsForm.SettingtButtonGroupKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  SettingsPageControl.ActivePageIndex := SettingtButtonGroup.ItemIndex;
end;

procedure TSettingsForm.LoadSettings;
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
  // Выполнение команд
  CBEnableExecCommand.Checked := EnableExecCommand;
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
  // Команды
  GBCommand.Visible := EnableExecCommand;
  // Гор. клавиши
  HotKeySelectedCell := 0;
  GBHotKey.Visible := GlobalHotKeyEnable;
  CBEnableHotKey.Checked := GlobalHotKeyEnable;
  HotKetStringGrid.ColWidths[0] := 350;
  HotKetStringGrid.Cells[0,0] := GetLangStr('StartStopRecord');
  HotKetStringGrid.Cells[0,1] := GetLangStr('StartStopRecordWithoutSendText');
  HotKetStringGrid.Cells[0,2] := GetLangStr('StartRecordWithoutExecCommand');
  HotKetStringGrid.Cells[1,0] := StartRecordHotKey;
  HotKetStringGrid.Cells[1,1] := StartRecordWithoutSendTextHotKey;
  HotKetStringGrid.Cells[1,2] := StartRecordWithoutExecCommandHotKey;
  IMHotKey.HotKey := TextToShortCut(HotKetStringGrid.Cells[1,0]);
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
  CommandStringGrid.ColWidths[1] := 250;
  CommandStringGrid.ColWidths[2] := 120;
  LoadCommandDataStringGrid(WorkPath + CommandGridFile, CommandStringGrid);
  // Коррекция текста
  {$ifdef LICENSE}
  CBEnableSendTextInactiveWindow.OnClick := nil;
  CBEnableTextСorrection.OnClick := nil;
  if not CheckLicense(WorkPath, True) then
  begin
    EnableTextСorrection := False;
    EnableTextReplace := False;
    FirstLetterUpper := False;
  end;
  CBEnableTextСorrection.Checked := EnableTextСorrection;
  GBTextCorrection.Visible := EnableTextСorrection;
  CBEnableReplace.Checked := EnableTextReplace;
  CBFirstLetterUpper.Checked := FirstLetterUpper;
  CBEnableSendTextInactiveWindow.Checked := EnableSendTextInactiveWindow;
  EInactiveWindowCaption.Text := InactiveWindowCaption;
  CBEnableSendTextInactiveWindow.OnClick := CBEnableSendTextInactiveWindowClick;
  CBEnableTextСorrection.OnClick := CBEnableTextСorrectionClick;
  {$endif LICENSE}
  {$ifdef FREE_MSPEECH}
  CBEnableTextСorrection.Checked := EnableTextСorrection;
  CBEnableReplace.Visible := EnableTextСorrection;
  CBFirstLetterUpper.Visible := EnableTextСorrection;
  GBReplaceList.Visible := EnableTextСorrection;
  CBEnableReplace.Checked := EnableTextReplace;
  CBFirstLetterUpper.Checked := FirstLetterUpper;
  CBEnableSendTextInactiveWindow.Checked := EnableSendTextInactiveWindow;
  EInactiveWindowCaption.Text := InactiveWindowCaption;
  {$endif FREE_MSPEECH}
  // Язык распознавания
  CBRegion.ItemIndex := DetectRegionID(DefaultSpeechRecognizeLang);
  // Замена текста
  if EnableTextReplace then
    LoadReplaceDataStringGrid(WorkPath + ReplaceGridFile, ReplaceStringGrid);
  // Синтез голоса
  CBEnableTextToSpeech.Checked := EnableTextToSpeech;
  GBTextToSpeech.Visible := EnableTextToSpeech;
  CBTextToSpeechEngine.ItemIndex := TextToSpeechEngine;
  GBTextToSpeechEngine.Caption := ' ' + CBTextToSpeechEngine.Items[CBTextToSpeechEngine.ItemIndex] + ' ';
  if TextToSpeechEngine = 0 then // Если Microsoft SAPI
    SetSAPISettings
  else // Google
    SetGoogleTextToSpeechSettings;
  // Список типов событий и т.д.
  AddEventsTypeToList;
  AddEventsTypeStatusToList;
  TextToSpeechStringGrid.ColWidths[0] := 245;
  TextToSpeechStringGrid.ColWidths[1] := 150;
  TextToSpeechStringGrid.ColWidths[2] := 120;
  LoadTextToSpeechDataStringGrid(WorkPath + TextToSpeechGridFile, TextToSpeechStringGrid);
  // Логгирование
  CBEnableLogs.Checked := EnableLogs;
  SEErrLogSize.Enabled := EnableLogs;
  LErrLogSize.Enabled := EnableLogs;
  SEErrLogSize.Text := IntToStr(MaxDebugLogSize);
  // Фильтры
  CBEnableFilters.Checked := EnableFilters;
  GBFilters.Visible := EnableFilters;
  RGFiltersType.ItemIndex := FilterType;
  RGFiltersTypeClick(RGFiltersType);
  CBSincFilterType.ItemIndex := SincFilterType;
  ELowFreq.Text := IntToStr(SincFilterLowFreq);
  EHighFreq.Text := IntToStr(SincFilterHighFreq);
  EKernelWidth.Text := IntToStr(SincFilterKernelWidth);
  CBWindowType.ItemIndex := SincFilterWindowType;
  CBVoiceFilterEnableAGC.Checked := VoiceFilterEnableAGC;
  CBVoiceFilterEnableNoiseReduction .Checked := VoiceFilterEnableNoiseReduction;
  CBVoiceFilterEnableVAD.Checked := VoiceFilterEnableVAD;
  // Команда по-умолчанию
  EDefaultCommandExec.Text := DefaultCommandExec;
end;

procedure TSettingsForm.SetSAPISettings;
var
  VoiceCnt: Integer;
begin
  if not Assigned(SgpIVTxt) then
  begin
    CBVoice.Clear;
    if SAPIActivate then
    begin
      for VoiceCnt := 0 to SVoices.Count - 1 do
        CBVoice.Items.Add(SVoices.Item(VoiceCnt).GetDescription(0));
    end;
  end
  else
  begin
    CBVoice.Clear;
    for VoiceCnt := 0 to SVoices.Count - 1 do
      CBVoice.Items.Add(SVoices.Item(VoiceCnt).GetDescription(0));
  end;
  if CBVoice.Items.Count > 0 then
  begin
    if SAPIVoiceNum <= SVoices.Count then
      CBVoice.ItemIndex := SAPIVoiceNum
    else
      CBVoice.ItemIndex := 0;
    CBVoice.OnChange := CBVoiceChange;
    with LBSAPIInfo.Items do
    begin
      Clear;
      Add(Format('Имя: %s', [SVoices.Item(CBVoice.ItemIndex).GetAttribute('Name')]));
      Add(Format('Создатель: %s', [SVoices.Item(CBVoice.ItemIndex).GetAttribute('Vendor')]));
      Add(Format('Возраст: %s', [SVoices.Item(CBVoice.ItemIndex).GetAttribute('Age')]));
      Add(Format('Пол: %s', [SVoices.Item(CBVoice.ItemIndex).GetAttribute('Gender')]));
      Add(Format('Язык: %s', [SVoices.Item(CBVoice.ItemIndex).GetAttribute('Language')]));
      //Add(Format('Ключь в реестре: %s', [Voices.Item(CBVoice.ItemIndex).Id]));
    end;
    GBTextToSpeechList.Visible := True;
  end
  else
  begin
    CBVoice.ItemIndex := -1;
    LVoiceVolumeDesc.Enabled := False;
    TBVoiceVolume.Enabled := False;
    LVoiceVolume.Enabled := False;
    LVoiceSpeedDesc.Enabled := False;
    TBVoiceSpeed.Enabled := False;
    LVoiceSpeed.Enabled := False;
    LBSAPIInfo.Enabled := False;
    with LBSAPIInfo.Items do
    begin
      Clear;
      Add(GetLangStr('MsgErr11'));
    end;
    GBTextToSpeechList.Visible := False;
  end;
  LVoiceVolumeDesc.Visible := True;
  TBVoiceVolume.Visible := True;
  LVoiceVolume.Visible := True;
  LVoiceSpeedDesc.Visible := True;
  TBVoiceSpeed.Visible := True;
  LVoiceSpeed.Visible := True;
  LBSAPIInfo.Visible := True;
  CBVoice.Left := TBVoiceVolume.Left + 5;
  GBTextToSpeechEngine.Height := TBVoiceSpeed.Top + TBVoiceSpeed.Height + 10;
  TBVoiceVolume.Position := SgpIVTxt.Volume;
  LVoiceVolume.Caption := IntToStr(TBVoiceVolume.Position);
  TBVoiceSpeed.Position := SgpIVTxt.Rate;
  LVoiceSpeed.Caption := IntToStr(TBVoiceSpeed.Position);
  TBVoiceVolume.Position := SAPIVoiceVolume;
  TBVoiceSpeed.Position := SAPIVoiceSpeed;
  GBTextToSpeechList.Top := GBTextToSpeechEngine.Top + GBTextToSpeechEngine.Height + 5;
end;

procedure TSettingsForm.SetGoogleTextToSpeechSettings;
begin
  SAPIDeactivate;
  LVoiceVolumeDesc.Visible := False;
  TBVoiceVolume.Visible := False;
  LVoiceVolume.Visible := False;
  LVoiceSpeedDesc.Visible := False;
  TBVoiceSpeed.Visible := False;
  LVoiceSpeed.Visible := False;
  LBSAPIInfo.Visible := False;
  CBVoice.Left := LVoice.Left + LVoice.Width + 10;
  GBTextToSpeechEngine.Height := CBVoice.Top + CBVoice.Height + 10;
  CBVoice.Clear;
  CBVoice.Items.Add('Русский');
  CBVoice.Items.Add('English');
  CBVoice.ItemIndex := DetectTextToSpeechRegionID(GoogleTL);
  GBTextToSpeechList.Visible := True;
  GBTextToSpeechList.Top := GBTextToSpeechEngine.Top + GBTextToSpeechEngine.Height + 5;
end;

{ Процедура поиска языковых файлов и заполнения списка }
procedure TSettingsForm.FindLangFile;
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

procedure TSettingsForm.AddCommmandsToList;
begin
  // Список команд
  CBCommandType.Clear;
  CBCommandType.Items.Add(DetectCommandTypeName(mExecPrograms));
  CBCommandType.Items.Add(DetectCommandTypeName(mClosePrograms));
  CBCommandType.Items.Add(DetectCommandTypeName(mKillPrograms));
  if EnableTextToSpeech then
    CBCommandType.Items.Add(DetectCommandTypeName(mTextToSpeech));
  CBCommandType.ItemIndex := 0;
end;

procedure TSettingsForm.CBDeviceChange(Sender: TObject);
begin
  DXAudioIn.DeviceNumber := (Sender as TComboBox).ItemIndex;
end;

procedure TSettingsForm.CBEnableExecCommandClick(Sender: TObject);
begin
  GBCommand.Visible := (Sender as TCheckBox).Checked;
end;

procedure TSettingsForm.CBEnableHotKeyClick(Sender: TObject);
begin
  GBHotKey.Visible := (Sender as TCheckBox).Checked;
end;

procedure TSettingsForm.CBMaxLevelControlClick(Sender: TObject);
begin
  LMaxLevel.Enabled := (Sender as TCheckBox).Checked;
  EMaxLevel.Enabled := (Sender as TCheckBox).Checked;
  LMaxLevelInterrupt.Enabled := (Sender as TCheckBox).Checked;
  EMaxLevelInterrupt.Enabled := (Sender as TCheckBox).Checked;
  UpDownMaxLevel.Enabled := (Sender as TCheckBox).Checked;
  UpDownMaxLevelInterrupt.Enabled := (Sender as TCheckBox).Checked;
end;

procedure TSettingsForm.CBUseProxyClick(Sender: TObject);
begin
  LProxyAddress.Enabled := (Sender as TCheckBox).Checked;
  LProxyPort.Enabled := (Sender as TCheckBox).Checked;
  EProxyAddress.Enabled := (Sender as TCheckBox).Checked;
  EProxyPort.Enabled := (Sender as TCheckBox).Checked;
  CBProxyAuth.Enabled := (Sender as TCheckBox).Checked;
end;

procedure TSettingsForm.CBProxyAuthClick(Sender: TObject);
begin
  LProxyUser.Enabled := (Sender as TCheckBox).Checked;
  LProxyUserPasswd.Enabled := (Sender as TCheckBox).Checked;
  EProxyUser.Enabled := (Sender as TCheckBox).Checked;
  EProxyUserPasswd.Enabled := (Sender as TCheckBox).Checked;
end;

procedure TSettingsForm.CBStopRecordActionChange(Sender: TObject);
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

procedure TSettingsForm.EMaxLevelInterruptKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
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

procedure TSettingsForm.EMinLevelInterruptKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
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

procedure TSettingsForm.EMaxLevelKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
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

procedure TSettingsForm.EMinLevelKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
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

procedure TSettingsForm.UpDownMaxLevelClick(Sender: TObject; Button: TUDBtnType);
begin
  MaxLevelOnAutoRecord := StrToInt(EMaxLevel.Text);
end;

procedure TSettingsForm.UpDownMinLevelClick(Sender: TObject; Button: TUDBtnType);
begin
  MinLevelOnAutoRecognize := StrToInt(EMinLevel.Text);
end;

procedure TSettingsForm.UpDownMaxLevelInterruptClick(Sender: TObject; Button: TUDBtnType);
begin
  MaxLevelOnAutoRecordInterrupt := StrToInt(EMaxLevelInterrupt.Text);
end;

procedure TSettingsForm.UpDownMinLevelInterruptClick(Sender: TObject; Button: TUDBtnType);
begin
  MinLevelOnAutoRecognizeInterrupt := StrToInt(EMinLevelInterrupt.Text);
end;

procedure TSettingsForm.MicSettingsButtonClick(Sender: TObject);
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

procedure TSettingsForm.SBCommandSelectClick(Sender: TObject);
begin
  if CommandOpenDialog.Execute then
  begin
    if ActivateAddCommandButton then
      AddCommandButton.Enabled := True;
    ActivateDeleteCommandButton := True;
    ECommandExec.Text := CommandOpenDialog.FileName;
  end;
end;

procedure TSettingsForm.SBDefaultCommandSelectClick(Sender: TObject);
begin
  if CommandOpenDialog.Execute then
    EDefaultCommandExec.Text := CommandOpenDialog.FileName;
end;

{ Добавить горячую клавишу }
procedure TSettingsForm.SetHotKeyButtonClick(Sender: TObject);
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
procedure TSettingsForm.DeleteHotKeyButtonClick(Sender: TObject);
begin
  HotKetStringGrid.Cells[1,HotKeySelectedCell] := '';
  IMHotKey.HotKey := TextToShortCut('');
end;

{ Клик по строке StringGrid с горячими клавишами }
procedure TSettingsForm.HotKetStringGridSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  HotKeySelectedCell := ARow;
  IMHotKey.HotKey := TextToShortCut(HotKetStringGrid.Cells[1,ARow]);
end;

procedure TSettingsForm.CBEnableSendTextClick(Sender: TObject);
begin
  GBSendText.Visible := (Sender as TCheckBox).Checked;
  if not (Sender as TCheckBox).Checked then
  begin
    CBEnableTextСorrection.OnClick := nil;
    CBEnableTextСorrection.Checked := False;
    GBTextCorrection.Visible := False;
    CBEnableTextСorrection.OnClick := CBEnableTextСorrectionClick;
  end;
end;

procedure TSettingsForm.CBEnableSendTextInactiveWindowClick(Sender: TObject);
begin
{$ifdef LICENSE}
  if CheckLicense(WorkPath) then
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

procedure TSettingsForm.CBEnableTextToSpeechClick(Sender: TObject);
begin
  GBTextToSpeech.Visible := (Sender as TCheckBox).Checked;
  EnableTextToSpeech := (Sender as TCheckBox).Checked;
  AddCommmandsToList;
  LoadCommandDataStringGrid(WorkPath + CommandGridFile, CommandStringGrid);
end;

procedure TSettingsForm.CBEnableTextСorrectionClick(Sender: TObject);
begin
  if not CBEnableSendText.Checked then
  begin
    (Sender as TCheckBox).OnClick := nil;
    MsgInf(ProgramsName, GetLangStr('MsgInf10'));
    (Sender as TCheckBox).Checked := False;
    (Sender as TCheckBox).OnClick := CBEnableTextСorrectionClick;
    Exit;
  end;
{$ifdef LICENSE}
  if CheckLicense(WorkPath) then
    GBTextCorrection.Visible := (Sender as TCheckBox).Checked
  else
    GBTextCorrection.Visible := False;
{$endif LICENSE}
{$ifdef FREE_MSPEECH}
  GBTextCorrection.Visible := (Sender as TCheckBox).Checked;
  CBEnableReplace.Visible := (Sender as TCheckBox).Checked;
  CBFirstLetterUpper.Visible := (Sender as TCheckBox).Checked;
  GBReplaceList.Visible := (Sender as TCheckBox).Checked;
  CBEnableReplace.Checked := False;
  CBFirstLetterUpper.Checked := False;
{$endif FREE_MSPEECH}
  if not CBEnableReplace.Checked then
    GBReplaceList.Visible := False;
end;

procedure TSettingsForm.CBEnableLogsClick(Sender: TObject);
begin
  EnableLogs := (Sender as TCheckBox).Checked;
  SEErrLogSize.Enabled := EnableLogs;
  LErrLogSize.Enabled := EnableLogs;
end;

procedure TSettingsForm.CBEnableReplaceClick(Sender: TObject);
begin
{$ifdef LICENSE}
  if CheckLicense(WorkPath) then
    GBReplaceList.Visible := (Sender as TCheckBox).Checked
  else
    GBReplaceList.Visible := False;
{$endif LICENSE}
{$ifdef FREE_MSPEECH}
  GBReplaceList.Visible := (Sender as TCheckBox).Checked;
{$endif FREE_MSPEECH}
  if (Sender as TCheckBox).Checked then
    LoadReplaceDataStringGrid(WorkPath + ReplaceGridFile, ReplaceStringGrid);
end;

procedure TSettingsForm.CommandStringGridSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  CommandStringSelectedCell := ARow;
  ECommandKey.Text := CommandStringGrid.Cells[0,ARow];
  ECommandExec.Text := CommandStringGrid.Cells[1,ARow];
  CBCommandType.ItemIndex := DetectCommandType(DetectCommandTypeName(CommandStringGrid.Cells[2,ARow]));
  CBCommandTypeChange(CBCommandType);
  ChangeCommandButton.Enabled := True;
  DeleteCommandButton.Enabled := True;
end;

procedure TSettingsForm.CBMethodSendingTextChange(Sender: TObject);
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
procedure TSettingsForm.CBAlphaBlendClick(Sender: TObject);
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

procedure TSettingsForm.CBCommandTypeChange(Sender: TObject);
begin
  if DetectCommandTypeName((Sender as TComboBox).Items[(Sender as TComboBox).ItemIndex]) = mExecPrograms then
  begin
    LCommandExec.Caption := GetLangStr('LCommandExec');
    SBCommandSelect.Enabled := True;
  end
  else if DetectCommandTypeName((Sender as TComboBox).Items[(Sender as TComboBox).ItemIndex]) = mClosePrograms then
  begin
    LCommandExec.Caption := GetLangStr('LCommandClose');
    SBCommandSelect.Enabled := True;
  end
  else if DetectCommandTypeName((Sender as TComboBox).Items[(Sender as TComboBox).ItemIndex]) = mTextToSpeech then
  begin
    LCommandExec.Caption := GetLangStr('LCommandTextToSpeech');
    SBCommandSelect.Enabled := False;
  end
  else
  begin
    LCommandExec.Caption := GetLangStr('LCommandKill');
    SBCommandSelect.Enabled := True;
  end
end;

procedure TSettingsForm.AlphaBlendTrackBarChange(Sender: TObject);
begin
  AlphaBlendEnableValue := AlphaBlendTrackBar.Position;
  AlphaBlendVar.Caption := IntToStr(AlphaBlendEnableValue);
  // Прозрачность окна настроек
  AlphaBlendValue := AlphaBlendEnableValue;
end;

procedure TSettingsForm.CBLangChange(Sender: TObject);
begin
  CoreLanguage := (Sender as TComboBox).Items[(Sender as TComboBox).ItemIndex];
  DefaultLanguage := (Sender as TComboBox).Items[(Sender as TComboBox).ItemIndex];
  CoreLanguageChanged;
  //LoadSettings;
end;

procedure TSettingsForm.ReplaceStringGridSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  ReplaceStringSelectedCell := ARow;
  EReplaceIN.Text := ReplaceStringGrid.Cells[0,ARow];
  EReplaceOUT.Text := ReplaceStringGrid.Cells[1,ARow];
  ChangeReplaceButton.Enabled := True;
  DeleteReplaceButton.Enabled := True;
end;

procedure TSettingsForm.ECommandExecKeyUp(Sender: TObject; var Key: Word;
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

procedure TSettingsForm.ECommandKeyKeyUp(Sender: TObject; var Key: Word;
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
procedure TSettingsForm.AddCommandButtonClick(Sender: TObject);
begin
  if (ECommandKey.Text <> '') and (ECommandExec.Text <> '') then
  begin
    CommandStringGrid.RowCount := CommandStringGrid.RowCount + 1;
    CommandStringGrid.Cells[0,CommandStringGrid.RowCount-1] := ECommandKey.Text;
    CommandStringGrid.Cells[1,CommandStringGrid.RowCount-1] := ECommandExec.Text;
    CommandStringGrid.Cells[2,CommandStringGrid.RowCount-1] := DetectCommandType(CBCommandType.ItemIndex);
  end;
end;

procedure TSettingsForm.ChangeCommandButtonClick(Sender: TObject);
begin
  if (ECommandKey.Text <> '') and (ECommandExec.Text <> '') then
  begin
    CommandStringGrid.Cells[0,CommandStringSelectedCell] := ECommandKey.Text;
    CommandStringGrid.Cells[1,CommandStringSelectedCell] := ECommandExec.Text;
    CommandStringGrid.Cells[2,CommandStringSelectedCell] := DetectCommandType(CBCommandType.ItemIndex);
  end;
end;

{ Удалить команду }
procedure TSettingsForm.DeleteCommandButtonClick(Sender: TObject);
begin
  if (CommandStringSelectedCell = 0) and (CommandStringGrid.RowCount = 1) then
    MsgInf(ProgramsName, Format(GetLangStr('MsgInf5'), [#13]))
  else
    THackGrid(CommandStringGrid).DeleteRow(CommandStringSelectedCell);
end;

procedure TSettingsForm.AddReplaceButtonClick(Sender: TObject);
begin
  if (EReplaceIN.Text <> '') and (EReplaceOUT.Text <> '') then
  begin
    ReplaceStringGrid.RowCount := ReplaceStringGrid.RowCount + 1;
    ReplaceStringGrid.Cells[0,ReplaceStringGrid.RowCount-1] := EReplaceIN.Text;
    ReplaceStringGrid.Cells[1,ReplaceStringGrid.RowCount-1] := EReplaceOUT.Text;
  end;
end;

procedure TSettingsForm.ChangeReplaceButtonClick(Sender: TObject);
begin
  if (EReplaceIN.Text <> '') and (EReplaceOUT.Text <> '') then
  begin
    ReplaceStringGrid.Cells[0,ReplaceStringSelectedCell] := EReplaceIN.Text;
    ReplaceStringGrid.Cells[1,ReplaceStringSelectedCell] := EReplaceOUT.Text;
  end;
end;

procedure TSettingsForm.DeleteReplaceButtonClick(Sender: TObject);
begin
  if (ReplaceStringSelectedCell = 0) and (ReplaceStringGrid.RowCount = 1) then
    MsgInf(ProgramsName, Format(GetLangStr('MsgInf6'), [#13]))
  else
    THackGrid(ReplaceStringGrid).DeleteRow(ReplaceStringSelectedCell);
end;

procedure TSettingsForm.EReplaceINKeyUp(Sender: TObject; var Key: Word;
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

procedure TSettingsForm.EReplaceOUTKeyUp(Sender: TObject; var Key: Word;
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

procedure TSettingsForm.CBTextToSpeechEngineChange(Sender: TObject);
begin
  GBTextToSpeechEngine.Caption := ' ' + (Sender as TComboBox).Items[(Sender as TComboBox).ItemIndex] + ' ';
  if (Sender as TComboBox).ItemIndex = 0 then // Microsoft SAPI
    SetSAPISettings
  else // Google
    SetGoogleTextToSpeechSettings;
end;

procedure TSettingsForm.CBVoiceChange(Sender: TObject);
begin
  if TextToSpeechEngine = 0 then // Если Microsoft SAPI
  begin
    with LBSAPIInfo.Items do
    begin
      Clear;
      Add(Format('Имя: %s', [SVoices.Item((Sender as TComboBox).ItemIndex).GetAttribute('Name')]));
      Add(Format('Создатель: %s', [SVoices.Item((Sender as TComboBox).ItemIndex).GetAttribute('Vendor')]));
      Add(Format('Возраст: %s', [SVoices.Item((Sender as TComboBox).ItemIndex).GetAttribute('Age')]));
      Add(Format('Пол: %s', [SVoices.Item((Sender as TComboBox).ItemIndex).GetAttribute('Gender')]));
      Add(Format('Язык: %s', [SVoices.Item((Sender as TComboBox).ItemIndex).GetAttribute('Language')]));
      //Add(Format('Ключь в реестре: %s', [Voices.Item((Sender as TComboBox).ItemIndex).Id]));
    end
  end;
end;

procedure TSettingsForm.TBVoiceSpeedChange(Sender: TObject);
begin
  LVoiceSpeed.Caption := IntToStr((Sender as TTrackBar).Position);
  SgpIVTxt.Rate := (Sender as TTrackBar).Position;
end;

procedure TSettingsForm.TBVoiceVolumeChange(Sender: TObject);
begin
  LVoiceVolume.Caption := IntToStr((Sender as TTrackBar).Position);
  SgpIVTxt.Volume := (Sender as TTrackBar).Position;
end;

procedure TSettingsForm.ETextToSpeechKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Sender as TEdit).Text <> '' then
    ActivateAddTextToSpeechButton := True
  else
    ActivateAddTextToSpeechButton := False;
  if ActivateAddTextToSpeechButton then
    AddTextToSpeechButton.Enabled := True
  else
    AddTextToSpeechButton.Enabled := False;
end;

procedure TSettingsForm.AddTextToSpeechButtonClick(Sender: TObject);
begin
  if ETextToSpeech.Text <> '' then
  begin
    TextToSpeechStringGrid.RowCount := TextToSpeechStringGrid.RowCount + 1;
    TextToSpeechStringGrid.Cells[0,TextToSpeechStringGrid.RowCount-1] := ETextToSpeech.Text;
    TextToSpeechStringGrid.Cells[1,TextToSpeechStringGrid.RowCount-1] := DetectEventsType(CBEventsType.ItemIndex);
    TextToSpeechStringGrid.Cells[2,TextToSpeechStringGrid.RowCount-1] := DetectEventsTypeStatus(CBTextToSpeechStatus.ItemIndex);
  end;
end;

procedure TSettingsForm.СhangeTextToSpeechButtonClick(Sender: TObject);
begin
  if ETextToSpeech.Text <> '' then
  begin
    TextToSpeechStringGrid.Cells[0,TextToSpeechStringSelectedCell] := ETextToSpeech.Text;
    TextToSpeechStringGrid.Cells[1,TextToSpeechStringSelectedCell] := DetectEventsType(CBEventsType.ItemIndex);
    TextToSpeechStringGrid.Cells[2,TextToSpeechStringSelectedCell] := DetectEventsTypeStatus(CBTextToSpeechStatus.ItemIndex);
  end;
end;

procedure TSettingsForm.DeleteTextToSpeechButtonClick(Sender: TObject);
begin
  if (TextToSpeechStringSelectedCell = 0) and (TextToSpeechStringGrid.RowCount = 1) then
    MsgInf(ProgramsName, Format(GetLangStr('MsgInf8'), [#13]))
  else
    THackGrid(TextToSpeechStringGrid).DeleteRow(TextToSpeechStringSelectedCell);
end;

procedure TSettingsForm.TextToSpeechStringGridSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  TextToSpeechStringSelectedCell := ARow;
  ETextToSpeech.Text := TextToSpeechStringGrid.Cells[0,ARow];
  CBEventsType.ItemIndex := DetectEventsType(DetectEventsTypeName(TextToSpeechStringGrid.Cells[1,ARow]));
  CBTextToSpeechStatus.ItemIndex := DetectEventsTypeStatus(DetectEventsTypeStatusName(TextToSpeechStringGrid.Cells[2,ARow]));
  СhangeTextToSpeechButton.Enabled := True;
  DeleteTextToSpeechButton.Enabled := True;
end;

procedure TSettingsForm.AddEventsTypeToList;
begin
  // Список типов событий
  CBEventsType.Clear;
  CBEventsType.Items.Add(DetectEventsTypeName(mWarningRecognize));
  CBEventsType.Items.Add(DetectEventsTypeName(mRecordingNotRecognized));
  CBEventsType.Items.Add(DetectEventsTypeName(mCommandNotFound));
  CBEventsType.Items.Add(DetectEventsTypeName(mErrorGoogleCommunication));
  CBEventsType.ItemIndex := 0;
end;

procedure TSettingsForm.AddEventsTypeStatusToList;
begin
  // Список состояний типов событий
  CBTextToSpeechStatus.Clear;
  CBTextToSpeechStatus.Items.Add(DetectEventsTypeStatusName(mDisable));
  CBTextToSpeechStatus.Items.Add(DetectEventsTypeStatusName(mEnable));
  CBTextToSpeechStatus.ItemIndex := 0;
end;

{ Активация SAPI }
function TSettingsForm.SAPIActivate: Boolean;
begin
  Result := False;
  CoInitialize(nil);
  try
    SgpIVTxt := TSpVoice.Create(nil);
    SVoices := SgpIVTxt.GetVoices('','');
    CoUninitialize;
    Result := True;
  except
    on e: Exception do
    begin
      if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': ' + 'Исключение в процедуре TSettingsForm.SAPIActivate - ' + e.Message);
      Exit;
    end;
  end;
end;

{ Деактивация SAPI }
procedure TSettingsForm.SAPIDeactivate;
begin
  if Assigned(SgpIVTxt) then
  begin
    try
      SgpIVTxt.Free;
      SgpIVTxt := nil;
    except
      on e: Exception do
      begin
        if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': ' + 'Исключение в процедуре TSettingsForm.SAPIDeactivate - ' + e.Message);
        Exit;
      end;
    end;
  end;
end;

{ Текст в голос с использованием SAPI }
procedure TSettingsForm.SAPITextToSpeech(MyText: String);
begin
  if EnableTextToSpeech and (TextToSpeechEngine = 0) then // Если Microsoft SAPI
    SgpIVTxt.Speak(MyText, SVSFlagsAsync);
end;

procedure TSettingsForm.CBEnableFiltersClick(Sender: TObject);
begin
  GBFilters.Visible := (Sender as TCheckBox).Checked;
end;

procedure TSettingsForm.RGFiltersTypeClick(Sender: TObject);
begin
  if (Sender as TRadioGroup).ItemIndex = 0 then
  begin
    GBWindowedSincFilter.Visible := True;
    GBVoiceFilter.Visible := False;
    GBWindowedSincFilter.Top := RGFiltersType.Top;
    GBWindowedSincFilter.Left := RGFiltersType.Left + RGFiltersType.Width + 5;
  end
  else
  begin
    GBWindowedSincFilter.Visible := False;
    GBVoiceFilter.Visible := True;
    GBVoiceFilter.Top := RGFiltersType.Top;
    GBVoiceFilter.Left := RGFiltersType.Left + RGFiltersType.Width + 5;;
  end;
end;

{ Отлавливаем событие WM_MSGBOX для изменения прозрачности окна }
procedure TSettingsForm.msgBoxShow(var Msg: TMessage);
var
  msgbHandle: HWND;
begin
  msgbHandle := GetActiveWindow;
  if msgbHandle <> 0 then
    MakeTransp(msgbHandle);
end;

{ Смена языка интерфейса по событию WM_LANGUAGECHANGED }
procedure TSettingsForm.OnLanguageChanged(var Msg: TMessage);
begin
  LoadLanguageStrings;
end;

{ Для мультиязыковой поддержки }
procedure TSettingsForm.LoadLanguageStrings;
begin
  Caption := ProgramsName + ' - ' + GetLangStr('SettingsFormCaption');
  SettingtButtonGroup.Items[0].Caption := GetLangStr('TabSheetSettings');
  SettingtButtonGroup.Items[1].Caption := GetLangStr('TabSheetRecord');
  SettingtButtonGroup.Items[2].Caption := GetLangStr('TabSheetConnectSettings');
  SettingtButtonGroup.Items[3].Caption := GetLangStr('TabSheetCommand');
  SettingtButtonGroup.Items[4].Caption := GetLangStr('TabSheetHotKey');
  SettingtButtonGroup.Items[5].Caption := GetLangStr('TabSheetSendText');
  SettingtButtonGroup.Items[6].Caption := GetLangStr('TabSheetTextCorrection');
  SettingtButtonGroup.Items[7].Caption := GetLangStr('TabSheetTextToSpeech');
  SaveSettingsButton.Caption := GetLangStr('SaveSettingsButton');
  HotKetStringGrid.Cells[0,0] := GetLangStr('StartStopRecord');
  HotKetStringGrid.Cells[0,1] := GetLangStr('StartStopRecordWithoutSendText');
  HotKetStringGrid.Cells[0,2] := GetLangStr('StartRecordWithoutExecCommand');
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
  CBStopRecordAction.ItemIndex := StopRecordAction;
  GBConnectSettings.Caption := Format(' %s ', [GetLangStr('GBConnectSettings')]);
  CBUseProxy.Caption := GetLangStr('CBUseProxy');
  LProxyAddress.Caption := GetLangStr('LProxyAddress');
  LProxyPort.Caption := GetLangStr('LProxyPort');
  CBProxyAuth.Caption := GetLangStr('CBProxyAuth');
  LProxyUser.Caption := GetLangStr('LProxyUser');
  LProxyUserPasswd.Caption := GetLangStr('LProxyUserPasswd');
  CBEnableHotKey.Caption := GetLangStr('CBHotKey');
  GBHotKey.Caption := Format(' %s ', [GetLangStr('GBHotKey')]);
  SetHotKeyButton.Caption := GetLangStr('SetHotKeyButton');
  DeleteHotKeyButton.Caption := GetLangStr('DeleteHotKeyButton');
  CBEnableSendText.Caption := GetLangStr('CBEnableSendText');
  GBSendText.Caption := Format(' %s ', [GetLangStr('GBSendText')]);
  LMethodSendingText.Caption := GetLangStr('LMethodSendingText');
  LClassName.Caption := GetLangStr('LClassName');
  if EnableSendTextInactiveWindow then
    LNote.Caption := GetLangStr('LNoteInactive')
  else
    LNote.Caption := GetLangStr('LNote');
  LRegion.Caption := GetLangStr('LRegion');
  // Команды
  GBCommand.Caption := Format(' %s ', [GetLangStr('GBCommand')]);
  LCommandKey.Caption := GetLangStr('LCommandKey');
  LCommandExec.Caption := GetLangStr('LCommandExec');
  LCommandType.Caption := GetLangStr('LCommandType');
  AddCommandButton.Caption := GetLangStr('AddCommandButton');
  ChangeCommandButton.Caption := GetLangStr('ChangeCommandButton');
  DeleteCommandButton.Caption := GetLangStr('DeleteCommandButton');
  AddCommmandsToList;
  LoadCommandDataStringGrid(WorkPath + CommandGridFile, CommandStringGrid);
  // Замена текста
  CBEnableReplace.Caption := GetLangStr('CBEnableReplace');
  CBFirstLetterUpper.Caption := GetLangStr('CBFirstLetterUpper');
  GBReplaceList.Caption := Format(' %s ', [GetLangStr('GBReplaceList')]);
  LReplaceIN.Caption := GetLangStr('LReplaceIN');
  LReplaceOUT.Caption := GetLangStr('LReplaceOUT');
  AddReplaceButton.Caption := GetLangStr('AddReplaceButton');
  ChangeReplaceButton.Caption := GetLangStr('ChangeReplaceButton');
  DeleteReplaceButton.Caption := GetLangStr('DeleteReplaceButton');
  // Передача текста
  CBEnableSendTextInactiveWindow.Caption := GetLangStr('CBEnableSendTextInactiveWindow');
  CBEnableTextСorrection.Caption := GetLangStr('CBEnableTextСorrection');
  GBTextCorrection.Caption := Format(' %s ', [GetLangStr('GBTextCorrection')]);
  LInactiveWindowCaption.Caption := GetLangStr('LInactiveWindowCaption');
  // Логи
  GBLogs.Caption := Format(' %s ', [GetLangStr('GBLogs')]);
  CBEnableLogs.Caption := GetLangStr('CBEnableLogs');
  LErrLogSize.Caption := GetLangStr('LErrLogSize');
  // Синтез голоса
  CBEnableTextToSpeech.Caption := GetLangStr('CBEnableTextToSpeech');
  GBTextToSpeech.Caption := Format(' %s ', [GetLangStr('GBTextToSpeech')]);
  LTextToSpeechEngine.Caption := GetLangStr('LTextToSpeechEngine');
  LVoice.Caption := GetLangStr('LVoice');
  LVoiceVolumeDesc.Caption := GetLangStr('LVoiceVolumeDesc');
  LVoiceSpeedDesc.Caption := GetLangStr('LVoiceSpeedDesc');
  GBTextToSpeechList.Caption := Format(' %s ', [GetLangStr('GBTextToSpeechList')]);
  LTextToSpeechText.Caption := GetLangStr('LTextToSpeechText');
  LTextToSpeechEventsType.Caption := GetLangStr('LTextToSpeechEventsType');
  LTextToSpeechEventsTypeStatus.Caption := GetLangStr('LTextToSpeechEventsTypeStatus');
  AddTextToSpeechButton.Caption := GetLangStr('AddTextToSpeechButton');
  СhangeTextToSpeechButton.Caption := GetLangStr('СhangeTextToSpeechButton');
  DeleteTextToSpeechButton.Caption := GetLangStr('DeleteTextToSpeechButton');
  AddEventsTypeToList;
  AddEventsTypeStatusToList;
  LoadTextToSpeechDataStringGrid(WorkPath + TextToSpeechGridFile, TextToSpeechStringGrid);
  // Фильтры
  CBEnableFilters.Caption := GetLangStr('CBEnableFilters');
  GBFilters.Caption := Format(' %s ', [GetLangStr('GBFilters')]);
  RGFiltersType.Caption := Format(' %s ', [GetLangStr('RGFiltersType')]);
  GBWindowedSincFilter.Caption := Format(' %s ', [GetLangStr('GBWindowedSincFilter')]);
  GBVoiceFilter.Caption := Format(' %s ', [GetLangStr('GBVoiceFilter')]);
  LSincFilterType.Caption := GetLangStr('LSincFilterType');
  LLowFreq.Caption := GetLangStr('LLowFreq');
  LHighFreq.Caption := GetLangStr('LHighFreq');
  LKernelWidth.Caption := GetLangStr('LKernelWidth');
  LWindowType.Caption := GetLangStr('LWindowType');
  CBVoiceFilterEnableAGC.Caption := GetLangStr('CBVoiceFilterEnableAGC');
  CBVoiceFilterEnableNoiseReduction.Caption := GetLangStr('CBVoiceFilterEnableNoiseReduction');
  CBVoiceFilterEnableVAD.Caption := GetLangStr('CBVoiceFilterEnableVAD');
  // Команда по-умолчанию
  LDefaultCommandExec.Caption := GetLangStr('LDefaultCommandExec');
  LDefaultCommandExecDesc.Caption := GetLangStr('LDefaultCommandExecDesc');
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
