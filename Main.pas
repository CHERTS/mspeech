{ ############################################################################ }
{ #                                                                          # }
{ #  MSpeech v1.5.8                                                          # }
{ #                                                                          # }
{ #  Copyright (с) 2012-2015, Mikhail Grigorev. All rights reserved.         # }
{ #                                                                          # }
{ #  License: http://opensource.org/licenses/GPL-3.0                         # }
{ #                                                                          # }
{ #  Contact: Mikhail Grigorev (email: sleuthhound@gmail.com)                # }
{ #                                                                          # }
{ ############################################################################ }

unit Main;

interface

{$I MSpeech.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ACS_Classes, NewACIndicators, ACS_FLAC, ACS_DXAudio,
  ShellApi, Global, Settings, Log, ACS_Misc, ACS_Filters, ACS_Wave,
  ImgList, Menus, Grids, Vcl.ExtCtrls, Vcl.Buttons, Clipbrd,
  XMLIntf, XMLDoc, AudioDMO, ACS_Procs, ACS_WinMedia, ACS_smpeg,
  SHFolder, StrUtils, ASR, MGTrayIcon, MGHotKeyManager, MGPlacement, MGSAPI,
  MGYandexTTS, MGGoogleTTS, MGOSInfo, MGiSpeechTTS, MGNuanceTTS;

type
  TMainForm = class(TForm)
    DXAudioIn: TDXAudioIn;
    FLACOut: TFLACOut;
    FastGainIndicator: TFastGainIndicator;
    NULLOut: TNULLOut;
    TrayImageList: TImageList;
    MSpeechPopupMenu: TPopupMenu;
    MSpeechShowHide: TMenuItem;
    MSpeechExit: TMenuItem;
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
    MSpeechHotKeyManager: TMGHotKeyManager;
    MGFormPlacement: TMGFormPlacement;
    MSpeechTray: TMGTrayIcon;
    MGSAPI: TMGSAPI;
    MGGoogleTTS: TMGGoogleTTS;
    MGYandexTTS: TMGYandexTTS;
    MGOSInfo: TMGOSInfo;
    MGISpeechTTS: TMGISpeechTTS;
    MGNuanceTTS: TMGNuanceTTS;
    WaveIn: TWaveIn;
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
    procedure MSpeechHotKeyManagerHotKeyPressed(HotKey: Cardinal; Index: Word);
    procedure MGGoogleTTSEvent(Sender: TObject; pInfo: TGTTSResultInfo);
    procedure MGYandexTTSEvent(Sender: TObject; pInfo: TYTTSResultInfo);
    procedure MGISpeechTTSEvent(Sender: TObject; pInfo: TISpeechTTSResultInfo);
    procedure MGNuanceTTSEvent(Sender: TObject; pInfo: TNuanceTTSResultInfo);
  private
    { Private declarations }
    SessionEnding: Boolean;
    FCount: Integer;
    StartRecordHotKeyIndex: Word;
    StartRecordWithoutSendTextHotKeyIndex: Word;
    StartRecordWithoutExecCommandHotKeyIndex: Word;
    SwitchesLanguageRecognizeHotKeyIndex: Word;
    procedure LoadLanguageStrings;
  public
    { Public declarations }
    MSpeechMainFormHidden: Boolean;
    // Список команд
    CommandSGrid: TStringGrid;
    // Список замены
    ReplaceSGrid: TStringGrid;
    // Список синтеза речи
    TextToSpeechSGrid: TStringGrid;
    FLockedCount: Integer;
    // Фильтры
    VoiceFilter: TVoiceFilter;
    SincFilter: TSincFilter;
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
    procedure TextToSpeech(EType: TEventsType); overload;
    procedure TextToSpeech(SayText: String); overload;
    procedure OtherTTS(const Text: String);
    procedure Filters;
    procedure RecognizeResultCallBack(Sender: TObject; pInfo: TRecognizeInfo);
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

procedure TMainForm.FormCreate(Sender: TObject);
begin
  DebugLogOpened := False;
  ProgramsPath := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)));
  OutFileName := GetUserTempPath() + 'out.flac';
  WorkPath := IncludeTrailingPathDelimiter(GetAppDataFolderPath()+ProgramsName);
  // Проверяем файл конфигурации
  if not DirectoryExists(WorkPath) then
    CreateDir(WorkPath);
  if DirectoryExists(WorkPath) then
  begin
    // Копируем дефолтный файл настроек
    if not FileExists(WorkPath + ININame) then
    begin
      if FileExists(ProgramsPath + ININame) then
        CopyFileEx(PChar(ProgramsPath + ININame), PChar(WorkPath + ININame), nil, nil, nil, COPY_FILE_FAIL_IF_EXISTS);
    end;
    // Копируем дефолтный файл команд
    if not FileExists(WorkPath + CommandGridFile) then
    begin
      if FileExists(ProgramsPath + CommandGridFile) then
        CopyFileEx(PChar(ProgramsPath + CommandGridFile), PChar(WorkPath + CommandGridFile), nil, nil, nil, COPY_FILE_FAIL_IF_EXISTS);
    end;
    // Копируем дефолтный файл для автозамены
    if not FileExists(WorkPath + ReplaceGridFile) then
    begin
      if FileExists(ProgramsPath + ReplaceGridFile) then
        CopyFileEx(PChar(ProgramsPath + ReplaceGridFile), PChar(WorkPath + ReplaceGridFile), nil, nil, nil, COPY_FILE_FAIL_IF_EXISTS);
    end;
    // Копируем дефолтный файл text-to-speech
    if not FileExists(WorkPath + TextToSpeechGridFile) then
    begin
      if FileExists(ProgramsPath + TextToSpeechGridFile) then
        CopyFileEx(PChar(ProgramsPath + TextToSpeechGridFile), PChar(WorkPath + TextToSpeechGridFile), nil, nil, nil, COPY_FILE_FAIL_IF_EXISTS);
    end;
  end
  else
    WorkPath := ProgramsPath;
  // Для мультиязыковой поддержки
  MainFormHandle := Handle;
  SetWindowLong(Handle, GWL_HWNDPARENT, 0);
  SetWindowLong(Handle, GWL_EXSTYLE, GetWindowLong(Handle, GWL_EXSTYLE) or WS_EX_APPWINDOW);
  // Читаем настройки
  LoadINI(WorkPath);
  // Проверка на автозапуск MSpeech
  if AutoRunMSpeech then
  begin
    if not CheckAutorun(mAutorunCurrentUser, mAutorunCheck, ProgramsName, ParamStr(0)) then
      CheckAutorun(mAutorunCurrentUser, mAutorunEnable, ProgramsName, ParamStr(0));
  end
  else
  begin
    if CheckAutorun(mAutorunCurrentUser, mAutorunCheck, ProgramsName, ParamStr(0)) then
      CheckAutorun(mAutorunCurrentUser, mAutorunDisable, ProgramsName, ParamStr(0));
  end;
  MSpeechTray.Hint := ProgramsName;
  // Загружаем настройки локализации
  if INIFileLoaded then
    CoreLanguage := DefaultLanguage
  else
  begin
    if (GetSysLang = 'Русский') or (GetSysLang = 'Russian') or (MatchStrings(GetSysLang, 'Русский*')) then
      CoreLanguage := 'Russian'
    else
      CoreLanguage := 'English';
  end;
  LangDoc := NewXMLDocument();
  if not DirectoryExists(ProgramsPath + dirLangs) then
    CreateDir(ProgramsPath + dirLangs);
  if not CoreLanguageChanged() then
  begin
    MSpeechMainFormHidden := True;
    Application.Terminate;
    Exit;
  end;
  // Заполняем список устройст записи
  if DXAudioIn.DeviceCount > 0 then
    StartButton.Enabled := True
  else
  begin
    MsgDie(ProgramsName, GetLangStr('MsgErr1'));
    Application.Terminate;
    Exit;
  end;
  // Отключаем кнопки
  StopButton.Enabled := False;
  // Фильтрация звука
  Filters();
  // Создаем горячие клавиши
  StartRecordHotKeyIndex := 0;
  StartRecordWithoutSendTextHotKeyIndex := 0;
  StartRecordWithoutExecCommandHotKeyIndex := 0;
  SwitchesLanguageRecognizeHotKeyIndex := 0;
  if StartRecordHotKey <> '' then
    StartRecordHotKeyIndex := MSpeechHotKeyManager.AddHotKey(TextToHotKey(StartRecordHotKey, True));
  if StartRecordWithoutSendTextHotKey <> '' then
    StartRecordWithoutSendTextHotKeyIndex := MSpeechHotKeyManager.AddHotKey(TextToHotKey(StartRecordWithoutSendTextHotKey, True));
  if StartRecordWithoutExecCommandHotKey <> '' then
    StartRecordWithoutExecCommandHotKeyIndex := MSpeechHotKeyManager.AddHotKey(TextToHotKey(StartRecordWithoutExecCommandHotKey, True));
  if SwitchesLanguageRecognizeHotKey <> '' then
    SwitchesLanguageRecognizeHotKeyIndex := MSpeechHotKeyManager.AddHotKey(TextToHotKey(SwitchesLanguageRecognizeHotKey, True));
  // Грузим список команд
  CommandSGrid := TStringGrid.Create(nil);
  // Если найден старый файл команд, то грузим список из него
  if FileExists(ProgramsPath + OLDCommandFileName) then
    DeleteFile(ProgramsPath + OLDCommandFileName)
  else
    LoadCommandDataStringGrid(WorkPath + CommandGridFile, CommandSGrid);
  // Грузим список замены
  ReplaceSGrid := TStringGrid.Create(nil);
  if EnableTextReplace then
    LoadReplaceDataStringGrid(WorkPath + ReplaceGridFile, ReplaceSGrid);
  // Грузим список для синтеза речи
  TextToSpeechSGrid := TStringGrid.Create(nil);
  if EnableTextToSpeech then
  begin
    LoadTextToSpeechDataStringGrid(WorkPath + TextToSpeechGridFile, TextToSpeechSGrid);
    if TextToSpeechEngine = 0 then // Если Microsoft SAPI
    begin
      MGSAPI.TTSLang := SAPIVoiceNum;
      MGSAPI.TTSVoiceVolume := SAPIVoiceVolume;
      MGSAPI.TTSVoiceSpeed := SAPIVoiceSpeed;
    end;
  end;
  // Авто-активация записи
  StartNULLRecord;
  // Язык распознавания
  CurrentSpeechRecognizeLang := DefaultSpeechRecognizeLang;
  // Кол. блокировок ПК
  FLockedCount := 0;
  WTSRegisterSessionNotification(Handle, NOTIFY_FOR_ALL_SESSIONS);
  // Удаляем старый файл состояния форм MSpeechForms.ini
  if FileExists(WorkPath + 'MSpeechForms.ini') then
    DeleteFile(WorkPath + 'MSpeechForms.ini');
  // Сохранение позиций окна
  MGFormPlacement.IniFileName := WorkPath + INIFormStorage;
  StopRecord := True;
  FCount := 0;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  if FileExists(OutFileName) then
    DeleteFile(OutFileName);
  // Очистка
  if Assigned(CommandSGrid) then
    CommandSGrid.Free;
  if Assigned(ReplaceSGrid) then
    ReplaceSGrid.Free;
  if Assigned(TextToSpeechSGrid) then
    TextToSpeechSGrid.Free;
  // Закрываем логи
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
  // Прозрачность окна
  AlphaBlend := AlphaBlendEnable;
  AlphaBlendValue := AlphaBlendEnableValue;
end;

procedure TMainForm.WndProc(var Message: TMessage);
var
  msgbHandle: HWND;
begin
  case Message.Msg of
    WM_SAVESETTINGSDONE: // Настройки сохранены
    begin
      if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': Вызов SaveSettingsDone.');
      // Список команд
      LoadCommandDataStringGrid(WorkPath + CommandGridFile, CommandSGrid);
      // Список замены
      if EnableTextReplace then
        LoadReplaceDataStringGrid(WorkPath + ReplaceGridFile, ReplaceSGrid);
      // Список синтеза событий
      if EnableTextToSpeech then
        LoadTextToSpeechDataStringGrid(WorkPath + TextToSpeechGridFile, TextToSpeechSGrid);
      // Меняем глобальные горячие клавиши
      if GlobalHotKeyEnable then
      begin
        // Гор.клавиша "Начать-остановить запись"
        if StartRecordHotKey <> '' then
        begin
          if StartRecordHotKeyIndex = 0 then
            StartRecordHotKeyIndex := MSpeechHotKeyManager.AddHotKey(TextToHotKey(StartRecordHotKey, True))
          else
            StartRecordHotKeyIndex := MSpeechHotKeyManager.ChangeHotKey(StartRecordHotKeyIndex, TextToHotKey(StartRecordHotKey, True));
        end
        else
        begin
          if StartRecordHotKeyIndex = 0 then
            StartRecordHotKeyIndex := MSpeechHotKeyManager.AddHotKey(TextToHotKey(StartRecordHotKey, True))
          else
            MSpeechHotKeyManager.RemoveHotKey(TextToHotKey(StartRecordHotKey, True));
        end;
        // Гор.клавиша "Начать-остановить запись без передачи текста"
        if StartRecordWithoutSendTextHotKey <> '' then
        begin
          if StartRecordWithoutSendTextHotKeyIndex = 0 then
            StartRecordWithoutSendTextHotKeyIndex := MSpeechHotKeyManager.AddHotKey(TextToHotKey(StartRecordWithoutSendTextHotKey, True))
          else
            StartRecordWithoutSendTextHotKeyIndex := MSpeechHotKeyManager.ChangeHotKey(StartRecordWithoutSendTextHotKeyIndex, TextToHotKey(StartRecordWithoutSendTextHotKey, True));
        end
        else
        begin
          if StartRecordWithoutSendTextHotKeyIndex = 0 then
            StartRecordWithoutSendTextHotKeyIndex := MSpeechHotKeyManager.AddHotKey(TextToHotKey(StartRecordWithoutSendTextHotKey, True))
          else
            MSpeechHotKeyManager.RemoveHotKey(TextToHotKey(StartRecordWithoutSendTextHotKey, True));
        end;
        // Гор.клавиша "Начать-остановить запись без выполнения команды"
        if StartRecordWithoutExecCommandHotKey <> '' then
        begin
          if StartRecordWithoutExecCommandHotKeyIndex = 0 then
            StartRecordWithoutExecCommandHotKeyIndex := MSpeechHotKeyManager.AddHotKey(TextToHotKey(StartRecordWithoutExecCommandHotKey, True))
          else
            StartRecordWithoutExecCommandHotKeyIndex := MSpeechHotKeyManager.ChangeHotKey(StartRecordWithoutExecCommandHotKeyIndex, TextToHotKey(StartRecordWithoutExecCommandHotKey, True));
        end
        else
        begin
          if StartRecordWithoutExecCommandHotKeyIndex = 0 then
            StartRecordWithoutExecCommandHotKeyIndex := MSpeechHotKeyManager.AddHotKey(TextToHotKey(StartRecordWithoutExecCommandHotKey, True))
          else
            MSpeechHotKeyManager.RemoveHotKey(TextToHotKey(StartRecordWithoutExecCommandHotKey, True));
        end;
        // Гор.клавиша "Переключение между основным и доп.языком распознавания"
        if SwitchesLanguageRecognizeHotKey <> '' then
        begin
          if SwitchesLanguageRecognizeHotKeyIndex = 0 then
            SwitchesLanguageRecognizeHotKeyIndex := MSpeechHotKeyManager.AddHotKey(TextToHotKey(SwitchesLanguageRecognizeHotKey, True))
          else
            SwitchesLanguageRecognizeHotKeyIndex := MSpeechHotKeyManager.ChangeHotKey(SwitchesLanguageRecognizeHotKeyIndex, TextToHotKey(SwitchesLanguageRecognizeHotKey, True));
        end
        else
        begin
          if SwitchesLanguageRecognizeHotKeyIndex = 0 then
            SwitchesLanguageRecognizeHotKeyIndex := MSpeechHotKeyManager.AddHotKey(TextToHotKey(SwitchesLanguageRecognizeHotKey, True))
          else
            MSpeechHotKeyManager.RemoveHotKey(TextToHotKey(SwitchesLanguageRecognizeHotKey, True));
        end;
      end
      else
        MSpeechHotKeyManager.ClearHotKeys;
      // Прозрачность окон
      AlphaBlendValue := AlphaBlendEnableValue;
      AlphaBlend := AlphaBlendEnable;
      LogForm.AlphaBlend := AlphaBlendEnable;
      LogForm.AlphaBlendValue := AlphaBlendEnableValue;
      // Настройки синтеза голоса
      if EnableTextToSpeech and (TextToSpeechEngine = 0) then
      begin
        MGSAPI.TTSLang := SAPIVoiceNum;
        MGSAPI.TTSVoiceVolume := SAPIVoiceVolume;
        MGSAPI.TTSVoiceSpeed := SAPIVoiceSpeed;
      end;
      // Фильтры
      Filters();
      // Авто-активация записи
      StartNULLRecord;
    end;
    WM_STARTSAVESETTINGS: // Открытие окна настроек
    begin
      if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': Вызов InitSaveSettings.');
      StopButton.Click;
      StopNULLRecord;
    end;
    WM_MSGBOX: // Отлавливаем событие WM_MSGBOX для изменения прозрачности окна
    begin
      msgbHandle := GetActiveWindow;
      if msgbHandle <> 0 then
        MakeTransp(msgbHandle);
    end;
    WM_LANGUAGECHANGED: // Смена языка программы
    begin
      LoadLanguageStrings;
    end;
    WM_QUERYENDSESSION: // Завершение работы Windows
    begin
        if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': WMQueryEndSession');
        SessionEnding := True;
        Message.Result := 1;
        Close;
    end;
    WM_WTSSESSION_CHANGE: // Смена статуса сеанса пользователя
    begin
      if Message.wParam = WTS_SESSION_LOCK then // ПК заблокирован
      begin
        Inc(FLockedCount);
        if EnableLogs then WriteInLog(WorkPath, Format('%s: Компьютер заблокирован.', [FormatDateTime('dd.mm.yy hh:mm:ss', Now)]));
        if StopRecognitionAfterLockingComputer then
        begin
          if MaxLevelOnAutoControl then
            MaxLevelOnAutoControl := False;
          if EnableLogs then WriteInLog(WorkPath, Format('%s: Останавливаем запись и распознавание.', [FormatDateTime('dd.mm.yy hh:mm:ss', Now)]));
          StopButton.Click;
          StopNULLRecord;
        end;
      end;
      if Message.wParam = WTS_SESSION_UNLOCK then // ПК разблокирован
      begin
        if EnableLogs then WriteInLog(WorkPath, Format('%s: Компьютер заблокирован %d раз.', [FormatDateTime('dd.mm.yy hh:mm:ss', Now), FLockedCount]));
        if StartRecognitionAfterUnlockingComputer then
        begin
          if EnableLogs then WriteInLog(WorkPath, Format('%s: Запускаем запись.', [FormatDateTime('dd.mm.yy hh:mm:ss', Now)]));
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
    SettingsForm.BringToFront;
end;

procedure TMainForm.MGGoogleTTSEvent(Sender: TObject; pInfo: TGTTSResultInfo);
begin
  if pInfo.FStatus = TGTTSStatus.ttsDone then
  begin
    if EnableLogs then WriteInLog(WorkPath, Format('%s: Google TTS: Результат синтеза сохранен в файл: %s', [FormatDateTime('dd.mm.yy hh:mm:ss', Now), pInfo.FResult]));
    if FileExists(pInfo.FResult) then
    begin
      MP3In.FileName := pInfo.FResult;
      if MP3In.Valid then
        DXAudioOut.Run
      else
      begin
        if EnableLogs then WriteInLog(WorkPath, Format('%s: Google TTS: Файл %s имеет некорректный формат.', [FormatDateTime('dd.mm.yy hh:mm:ss', Now), pInfo.FResult]));
        if FileExists(MP3In.FileName) then
          DeleteFile(MP3In.FileName);
      end;
    end;
  end
  else if pInfo.FStatus = TGTTSStatus.ttsError then
    if EnableLogs then WriteInLog(WorkPath, Format('%s: Google TTS: Ошибка: %s', [FormatDateTime('dd.mm.yy hh:mm:ss', Now), pInfo.FResult]))
  else if pInfo.FStatus = TGTTSStatus.ttsInfo then
    if EnableLogs then WriteInLog(WorkPath, Format('%s: Google TTS: Информация: %s', [FormatDateTime('dd.mm.yy hh:mm:ss', Now), pInfo.FResult]));
end;

procedure TMainForm.MGYandexTTSEvent(Sender: TObject; pInfo: TYTTSResultInfo);
begin
  if pInfo.FStatus = TYTTSStatus.ttsDone then
  begin
    if EnableLogs then WriteInLog(WorkPath, Format('%s: Yandex TTS: Результат синтеза сохранен в файл: %s', [FormatDateTime('dd.mm.yy hh:mm:ss', Now), pInfo.FResult]));
    if FileExists(pInfo.FResult) then
    begin
      MP3In.FileName := pInfo.FResult;
      if MP3In.Valid then
        DXAudioOut.Run
      else
      begin
        if EnableLogs then WriteInLog(WorkPath, Format('%s: Yandex TTS: Файл %s имеет некорректный формат.', [FormatDateTime('dd.mm.yy hh:mm:ss', Now), pInfo.FResult]));
        if FileExists(MP3In.FileName) then
          DeleteFile(MP3In.FileName);
      end;
    end;
  end
  else if pInfo.FStatus = TYTTSStatus.ttsError then
    if EnableLogs then WriteInLog(WorkPath, Format('%s: Yandex TTS: Ошибка: %s', [FormatDateTime('dd.mm.yy hh:mm:ss', Now), pInfo.FResult]))
  else if pInfo.FStatus = TYTTSStatus.ttsInfo then
    if EnableLogs then WriteInLog(WorkPath, Format('%s: Yandex TTS: Информация: %s', [FormatDateTime('dd.mm.yy hh:mm:ss', Now), pInfo.FResult]));
end;

procedure TMainForm.MGISpeechTTSEvent(Sender: TObject; pInfo: TISpeechTTSResultInfo);
begin
  if pInfo.FStatus = TISpeechTTSStatus.ttsDone then
  begin
    if EnableLogs then WriteInLog(WorkPath, Format('%s: iSpeech TTS: Результат синтеза сохранен в файл: %s', [FormatDateTime('dd.mm.yy hh:mm:ss', Now), pInfo.FResult]));
    if FileExists(pInfo.FResult) then
    begin
      MP3In.FileName := pInfo.FResult;
      if MP3In.Valid then
        DXAudioOut.Run
      else
      begin
        if EnableLogs then WriteInLog(WorkPath, Format('%s: iSpeech TTS: Файл %s имеет некорректный формат.', [FormatDateTime('dd.mm.yy hh:mm:ss', Now), pInfo.FResult]));
        if FileExists(MP3In.FileName) then
          DeleteFile(MP3In.FileName);
      end;
    end;
  end
  else if pInfo.FStatus = TISpeechTTSStatus.ttsError then
    if EnableLogs then WriteInLog(WorkPath, Format('%s: iSpeech TTS: Ошибка: %s', [FormatDateTime('dd.mm.yy hh:mm:ss', Now), pInfo.FResult]))
  else if pInfo.FStatus = TISpeechTTSStatus.ttsWarning then
    if EnableLogs then WriteInLog(WorkPath, Format('%s: iSpeech TTS: Сервис iSpeech сообщил об ошибке: %s', [FormatDateTime('dd.mm.yy hh:mm:ss', Now), pInfo.FResult]))
  else if pInfo.FStatus = TISpeechTTSStatus.ttsInfo then
    if EnableLogs then WriteInLog(WorkPath, Format('%s: iSpeech TTS: Информация: %s', [FormatDateTime('dd.mm.yy hh:mm:ss', Now), pInfo.FResult]));
end;

procedure TMainForm.MGNuanceTTSEvent(Sender: TObject; pInfo: TNuanceTTSResultInfo);
begin
  if pInfo.FStatus = TNuanceTTSStatus.ttsDone then
  begin
    if EnableLogs then WriteInLog(WorkPath, Format('%s: Nuance TTS: Результат синтеза сохранен в файл: %s', [FormatDateTime('dd.mm.yy hh:mm:ss', Now), pInfo.FResult]));
    if FileExists(pInfo.FResult) then
    begin
      WaveIn.FileName := pInfo.FResult;
      if WaveIn.Valid then
        DXAudioOut.Run
      else
      begin
        if EnableLogs then WriteInLog(WorkPath, Format('%s: Nuance TTS: Файл %s имеет некорректный формат.', [FormatDateTime('dd.mm.yy hh:mm:ss', Now), pInfo.FResult]));
        if FileExists(WaveIn.FileName) then
          DeleteFile(WaveIn.FileName);
      end;
    end;
  end
  else if pInfo.FStatus = TNuanceTTSStatus.ttsError then
    if EnableLogs then WriteInLog(WorkPath, Format('%s: Nuance TTS: Ошибка: %s', [FormatDateTime('dd.mm.yy hh:mm:ss', Now), pInfo.FResult]))
  else if pInfo.FStatus = TNuanceTTSStatus.ttsWarning then
    if EnableLogs then WriteInLog(WorkPath, Format('%s: Nuance TTS: Сервис Nuance сообщил об ошибке: %s', [FormatDateTime('dd.mm.yy hh:mm:ss', Now), pInfo.FResult]))
  else if pInfo.FStatus = TNuanceTTSStatus.ttsInfo then
    if EnableLogs then WriteInLog(WorkPath, Format('%s: Nuance TTS: Информация: %s', [FormatDateTime('dd.mm.yy hh:mm:ss', Now), pInfo.FResult]));
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
      if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': ' + 'Неизвестное исключение в процедуре FastGainIndicatorGainData - ' + e.Message);
      Exit;
    end;
  end;
end;

procedure TMainForm.FLACOutDone(Sender: TComponent);
begin
  FLACDoneCnt := 0;
  SaveFLACDone := True;
  if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': Файл ' + OutFileName + ' сохранен.');
  if not StartSaveSettings then
  begin
    if (StopRecordAction = 1) or (StopRecordAction = 3) then
    begin
      if StopRecord then
        StartRecognizer;
    end;
  end
  else
  begin
    ShowBalloonHint(ProgramsName, GetLangStr('MsgInf11'),  bitWarning);
    if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': Открыто окно Настройки. Распознавание речи отключено.');
  end;
end;

procedure TMainForm.FLACOutThreadException(Sender: TComponent);
begin
  if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': Ошибка записи в файл ' + OutFileName);
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
  if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': Получен запрос на остановку записи.');
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
  if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': Ошибка записи в пустоту');
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
    if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': Начата запись в файл ' + OutFileName);
    if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': InSampleRate = ' + IntToStr(DXAudioIn.InSampleRate));
    if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': InBitsPerSample = ' + IntToStr(DXAudioIn.InBitsPerSample));
    if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': InChannels = ' + IntToStr(DXAudioIn.InChannels));
  end
  else
    if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': Не найдена библиотека libFLAC.dll');
end;

{ Запуск потока отправки данных и выполнения команды }
procedure TMainForm.StartRecognizer;
begin
  if FileExists(OutFileName) then
  begin
    MSpeechTray.IconIndex := 4;
    StartRecognize(GoogleAPIKey, OutFileName, CurrentSpeechRecognizeLang , UseProxy, ProxyAddress, ProxyPort, ProxyAuth, ProxyUser, ProxyUserPasswd, RecognizeResultCallBack)
  end
  else
  begin
    if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': StartRecognizer - Ошибка чтения файла ' + OutFileName);
    StartButton.Enabled := True;
    StopButton.Enabled := False;
  end;
end;

{ Обработка результатов распознавания }
procedure TMainForm.RecognizeResultCallBack(Sender: TObject; pInfo: TRecognizeInfo);
var
  MsgStr: String;
  RecognizeStr: String;
  K: Integer;
  RowN: Integer;
  Grid: TArrayOfInteger;
begin
  case pInfo.FStatus of
    rsErrorGetAPIKey: MsgStr := 'Ошибка: Новый Google API Key не был получен с сервере MSpeech: ' + pInfo.FMessage;
    rsFileSizeNull: MsgStr := 'Ошибка: Нулевой размер файла для распознавания: ' + pInfo.FMessage;
    rsErrorHostNotFound: MsgStr := 'Ошибка: ' + pInfo.FMessage + '. Проверьте настройки Firewall''а.';
    rsErrorPermissionDenied: MsgStr := 'Ошибка: ' + pInfo.FMessage + '. Проверьте настройки Firewall''а.';
    rsErrorNoRouteToHost: MsgStr := 'Ошибка: ' + pInfo.FMessage + '. Проверьте подключение к Интернет и сетевые настройки.';
    rsErrorConnectionTimedOut: MsgStr := 'Ошибка: ' + pInfo.FMessage + '. Проверьте настройки Firewall''а или прокси-сервера.';
    rsInfo: MsgStr := 'Информация: ' + pInfo.FMessage;
    rsAbort: MsgStr := 'Отмена: ' + pInfo.FMessage;
  end;
  if pInfo.FStatus = rsRecordingNotRecognized then // Запись не распознана
  begin
    MSpeechTray.IconIndex := 2;
    TextToSpeech(mRecordingNotRecognized);
    ShowBalloonHint(ProgramsName, GetLangStr('MsgInf2'), bitWarning);
  end
  else if pInfo.FStatus = rsRecognizeDone then // Запись распознана
  begin
    if EnableLogs then WriteInLog(WorkPath, Format('%s: Распознанная строка = %s, Достоверность распознавания = %s%%', [FormatDateTime('dd.mm.yy hh:mm:ss', Now), pInfo.FTranscript, FloatToStr(pInfo.FConfidence)]));
    RecognizeStr := pInfo.FTranscript;
    // Замена текста
    if EnableTextСorrection then
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
    // Передача текста
    if EnableSendText then
    begin // Передача текста в неактивное окно программы
      if EnableSendTextInactiveWindow then
      begin
        if OnSendMessage(InactiveWindowCaption, RecognizeStr) then
          if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': Текст передан методом WM_COPYDATA.')
        else
          if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': Программа с заголовком ' + InactiveWindowCaption + ' не найдена.')
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
    // Выполнение команд
    if EnableExecCommand then
    begin
      Grid := HackTStringsIndexOf(CommandSGrid.Cols[0], RecognizeStr); // Поиск команд
      if Length(Grid) > 0 then // Команда найдена в списке
      begin
        if EnableLogs then WriteInLog(WorkPath, Format('%s: В CommandSGrid найдено %d команд.', [FormatDateTime('dd.mm.yy hh:mm:ss', Now), Length(Grid)]));
        // Перебор найденных команд
        for K := Low(Grid) to High(Grid) do
        begin
          // Запуск программы
          if IntToStr(CommandList[mExecPrograms].CommandCode) = CommandSGrid.Cells[2,Grid[K]] then
          begin
            if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': ' + 'Запускаем программу: ' + CommandSGrid.Cells[1,Grid[K]]);
            if (ExtractFileExt(CommandSGrid.Cells[1,Grid[K]]) = '.cmd') or (ExtractFileExt(CommandSGrid.Cells[1,Grid[K]]) = '.bat') then
              ShellExecute(0, 'open', PWideChar(CommandSGrid.Cells[1,Grid[K]]), nil, nil, SW_HIDE)
            else
              ShellExecute(0, 'open', PWideChar(CommandSGrid.Cells[1,Grid[K]]), nil, nil, SW_SHOWNORMAL);
          end
          // Запуск программы и передача ей распознанной строки
          else if IntToStr(CommandList[mExecProgramsParams].CommandCode) =  CommandSGrid.Cells[2,Grid[K]] then
          begin
            if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': ' + 'Запускаем программу с передачей ей распознанной строки: ' + CommandSGrid.Cells[1,Grid[K]] + ' "' + RecognizeStr + '"');
            if (ExtractFileExt(CommandSGrid.Cells[1,Grid[K]]) = '.cmd') or (ExtractFileExt(CommandSGrid.Cells[1,Grid[K]]) = '.bat') then
              ShellExecute(0, 'open', PWideChar(CommandSGrid.Cells[1,Grid[K]]), PWideChar('"'+RecognizeStr+'"'), nil, SW_HIDE)
            else
              ShellExecute(0, 'open', PWideChar(CommandSGrid.Cells[1,Grid[K]]), PWideChar('"'+RecognizeStr+'"'), nil, SW_SHOWNORMAL);
          end
          // Закрытие программы
          else if IntToStr(CommandList[mClosePrograms].CommandCode) = CommandSGrid.Cells[2,Grid[K]] then
          begin
            if IsProcessRun(ExtractFileName(CommandSGrid.Cells[1,Grid[K]])) then
            begin
              if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': ' + 'Закрываем программу: ' + CommandSGrid.Cells[1,Grid[K]]);
              EndProcess(GetProcessID(ExtractFileName(CommandSGrid.Cells[1,Grid[K]])), WM_CLOSE);
            end;
          end
          // Прибивание программы
          else if IntToStr(CommandList[mKillPrograms].CommandCode) = CommandSGrid.Cells[2,Grid[K]] then
          begin
            if IsProcessRun(ExtractFileName(CommandSGrid.Cells[1,Grid[K]])) then
            begin
              if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': ' + 'Убиваем программу: ' + CommandSGrid.Cells[1,Grid[K]]);
              KillTask(ExtractFileName(CommandSGrid.Cells[1,Grid[K]]));
            end;
          end
          // Синтез голоса
          else if IntToStr(CommandList[mTextToSpeech].CommandCode) = CommandSGrid.Cells[2,Grid[K]] then
            TextToSpeech(CommandSGrid.Cells[1,Grid[K]]);
        end;
      end
      else // Команда не найдена в списке
      begin
        // Выполнение команды по-умолчанию если она определена
        if DefaultCommandExec  <> '' then
        begin
          if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': Выполняем команду по-умолчанию = ' + DefaultCommandExec);
          if (ExtractFileExt(DefaultCommandExec) = '.cmd') or (ExtractFileExt(DefaultCommandExec) = '.bat') then
            ShellExecute(0, 'open', PWideChar(DefaultCommandExec), nil, nil, SW_HIDE)
          else
            ShellExecute(0, 'open', PWideChar(DefaultCommandExec), nil, nil, SW_SHOWNORMAL);
        end
        else
        begin
          if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': Команда не распознана или её нет в базе MSpeech.');
          TextToSpeech(mCommandNotFound);
          ShowBalloonHint(ProgramsName, GetLangStr('MsgInf3'));
        end;
      end;
    end;
    StartButton.Enabled := True;
    StopButton.Enabled := False;
    MSpeechTray.IconIndex := 0;
  end
  else
  begin
    if MsgStr <> '' then
    begin
      if pInfo.FStatus <> rsInfo then
      begin
        MSpeechTray.IconIndex := 5;
        ShowBalloonHint(ProgramsName, MsgStr, bitWarning);
      end;
      if EnableLogs then
        WriteInLog(WorkPath, Format('%s: %s', [FormatDateTime('dd.mm.yy hh:mm:ss', Now), MsgStr]))
    end;
  end;
  CloseLogFile;
  {if LogForm.Showing then
    SendMessage(LogFormHandle, WM_UPDATELOG, 0, 0);}
  StartNULLRecord;
end;

{ Нажата горячая клавиша }
procedure TMainForm.MSpeechHotKeyManagerHotKeyPressed(HotKey: Cardinal; Index: Word);
begin
  SetForegroundWindow(Application.Handle);
  // Старт записи с передачей текста
  if Index = StartRecordHotKeyIndex then
  begin
    if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': DoHotKey - Нажата клавиша '+HotKeyToText(HotKey, True));
    if StopRecord then
      StartButton.Click
    else
      StopButton.Click;
  end;
  // Старт записи без передачи текста
  if Index = StartRecordWithoutSendTextHotKeyIndex then
  begin
    if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': DoHotKey - Нажата клавиша '+HotKeyToText(HotKey, True));
    if StopRecord then // Начинаем запись
    begin
      EnableExecCommand := ReadCustomINI(WorkPath, 'Main', 'EnableExecCommand', True);
      if EnableSendText then
        EnableSendText := False;
      Start();
    end
    else
      StopButton.Click;
  end;
  // Старт записи без выполнения команд
  if Index = StartRecordWithoutExecCommandHotKeyIndex then
  begin
    if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': DoHotKey - Нажата клавиша '+HotKeyToText(HotKey, True));
    if StopRecord then // Начинаем запись
    begin
      if EnableExecCommand then
        EnableExecCommand := False;
      Start();
    end
    else
      StopButton.Click;
  end;
  // Смена языка распознавания
  if Index = SwitchesLanguageRecognizeHotKeyIndex then
  begin
    if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': DoHotKey - Нажата клавиша '+HotKeyToText(HotKey, True));
    if CurrentSpeechRecognizeLang = DefaultSpeechRecognizeLang then
      CurrentSpeechRecognizeLang := SecondSpeechRecognizeLang
    else
      CurrentSpeechRecognizeLang := DefaultSpeechRecognizeLang;
  end;
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
    if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': SetTextWnd (2) - Найден процесс.');
    if AttachThreadInput(GetCurrentThreadId, dwThreadID, True) then
    begin
      if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': SetTextWnd (2) - Подключение успешно.');
      hFocusedWnd := GetFocus;
      if hFocusedWnd <> 0 then
      begin
        if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': SetTextWnd (2) - Найден фокус.');
        if Boolean(GetClassName(hFocusedWnd, pszClassName, 256)) then
        begin
          if String(pszClassName) = MyClassName then
          begin
            if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': SetTextWnd (2) - Найден класс ' + MyClassName);
            if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': SetTextWnd (2) - Отправляем команду.');
            if SendMessage(hFocusedWnd, WM_SETTEXT, 0, lParam(PChar(MyText))) > 0 then
              if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': SetTextWnd (2) - Команда WM_SETTEXT успешно передана.');
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
    if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': SetTextWnd - Найден процесс.');
    if AttachThreadInput(GetCurrentThreadId, dwThreadID, True) then
    begin
      hFocusedWnd := GetFocus;
      if hFocusedWnd <> 0 then
      begin
        if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': SetTextWnd - Найден фокус.');
        if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': SetTextWnd - Отправляем команду.');
        if SendMessage(hFocusedWnd, WM_SETTEXT, 0, lParam(PChar(MyText))) > 0 then
          if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': SetTextWnd - Команда WM_SETTEXT успешно передана.');
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
    if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': InsTextWnd (2) - Найден процесс.');
    if AttachThreadInput(GetCurrentThreadId, dwThreadID, True) then
    begin
      if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': InsTextWnd (2) - Подключение успешно.');
      hFocusedWnd := GetFocus;
      if hFocusedWnd <> 0 then
      begin
        if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': InsTextWnd (2) - Найден фокус.');
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
                if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': InsTextWnd (2) - Найден класс ' + MyClassName);
                if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': InsTextWnd (2) - Отправляем команду.');
                if SendMessage(hFocusedWnd, EM_SETSEL, wParam(dwBytesNeeded), lParam(dwBytesNeeded)) > 0 then
                  if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': InsTextWnd (2) - Команда EM_SETSEL успешно передана.');
                if SendMessage(hFocusedWnd, EM_REPLACESEL, 0, lParam(PChar(MyText))) > 0 then
                  if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': InsTextWnd (2) - Команда EM_REPLACESEL успешно передана.');
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
    if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': InsTextWnd - Найден процесс.');
    if AttachThreadInput(GetCurrentThreadId, dwThreadID, True) then
    begin
      hFocusedWnd := GetFocus;
      if hFocusedWnd <> 0 then
      begin
        if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': InsTextWnd - Найден фокус.');
        dwBytesNeeded := SendMessage(hFocusedWnd, WM_GETTEXTLENGTH, 0, 0);
        if dwBytesNeeded > 0 then
        begin
          GetMem(pszWindowText, dwBytesNeeded + 1);
          try
            ZeroMemory(pszWindowText, dwBytesNeeded + 1);
            if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': InsTextWnd - Отправляем команду.');
            if SendMessage(hFocusedWnd, EM_SETSEL, wParam(dwBytesNeeded), lParam(dwBytesNeeded)) > 0 then
              if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': InsTextWnd - Команда EM_SETSEL успешно передана.');
            if SendMessage(hFocusedWnd, EM_REPLACESEL, 0, lParam(PChar(MyText))) > 0 then
              if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': InsTextWnd - Команда EM_REPLACESEL успешно передана.');
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
    if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': CopyPasteTextWnd (2) - Найден процесс.');
    if AttachThreadInput(GetCurrentThreadId, dwThreadID, True) then
    begin
      hFocusedWnd := GetFocus;
      if hFocusedWnd <> 0 then
      begin
        if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': CopyPasteTextWnd (2) - Найден фокус.');
        if Boolean(GetClassName(hFocusedWnd, pszClassName, 256)) then
        begin
          if String(pszClassName) = MyClassName then
          begin
            if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': CopyPasteTextWnd (2) - Найден класс ' + MyClassName);
            if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': CopyPasteTextWnd (2) - Отправляем команду.');
            Clipboard.Clear;
            Clipboard.AsText := MyText;
            if DetectMethodSendingText(MethodSendingText) = mWM_PASTE then
            begin
              // Метод WM_PASTE
              if SendMessage(hFocusedWnd, WM_PASTE, 0, 0) > 0 then
                if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': CopyPasteTextWnd (2) - Команда WM_PASTE успешно передана.');
            end
            else if DetectMethodSendingText(MethodSendingText) = mWM_PASTE_MOD then
            begin
              // Модифицированный метод WM_PASTE, через отправку сочетания Ctrl+V
              PostMessage(hFocusedWnd, WM_SETFOCUS,0,0);
              keybd_event(VK_CONTROL, MapVirtualKey(VK_CONTROL, 0), 0, 0);
              keybd_event(Ord('V'), MapVirtualKey(Ord('V'), 0), 0, 0);
              keybd_event(Ord('V'), 0, KEYEVENTF_KEYUP, 0);
              keybd_event(VK_CONTROL, MapVirtualKey(VK_CONTROL,0), KEYEVENTF_KEYUP, 0);
              if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': CopyPasteTextWnd - Команда Ctrl+V успешно передана.');
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
    if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': CopyPasteTextWnd - Найден процесс.');
    if AttachThreadInput(GetCurrentThreadId, dwThreadID, True) then
    begin
      hFocusedWnd := GetFocus;
      if hFocusedWnd <> 0 then
      begin
        if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': CopyPasteTextWnd - Найден фокус.');
        Clipboard.Clear;
        Clipboard.AsText := MyText;
        if DetectMethodSendingText(MethodSendingText) = mWM_PASTE then
        begin
          // Метод WM_PASTE
          if SendMessage(hFocusedWnd, WM_PASTE, 0, 0) > 0 then
            if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': CopyPasteTextWnd - Команда WM_PASTE успешно передана.');
        end
        else if DetectMethodSendingText(MethodSendingText) = mWM_PASTE_MOD then
        begin
          // Модифицированный метод WM_PASTE, через отправку сочетания Ctrl+V
          PostMessage(hFocusedWnd, WM_SETFOCUS,0,0);
          keybd_event(VK_CONTROL, MapVirtualKey(VK_CONTROL, 0), 0, 0);
          keybd_event(Ord('V'), MapVirtualKey(Ord('V'), 0), 0, 0);
          keybd_event(Ord('V'), 0, KEYEVENTF_KEYUP, 0);
          keybd_event(VK_CONTROL, MapVirtualKey(VK_CONTROL,0), KEYEVENTF_KEYUP, 0);
          if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': CopyPasteTextWnd - Команда Ctrl+V успешно передана.');
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
    if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': SetCharTextWnd - Найден процесс.');
    if AttachThreadInput(GetCurrentThreadId, dwThreadID, True) then
    begin
      hFocusedWnd := GetFocus;
      if hFocusedWnd <> 0 then
      begin
        if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': SetCharTextWnd - Найден фокус.');
        if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': SetCharTextWnd - Отправляем текст...');
        for Cnt := 1 to Length(MyText) do
          PostMessage(hFocusedWnd, WM_CHAR, Word(MyText[Cnt]), 0);
        //PostMessage(hFocusedWnd, WM_KEYDOWN, VK_RETURN, 0);
      end;
      AttachThreadInput(GetCurrentThreadId, dwThreadID, False);
    end;
  end;
end;

{ Текст в голос по событиям  }
procedure TMainForm.TextToSpeech(EType: TEventsType);
var
  K: Integer;
  Grid: TArrayOfInteger;
begin
  if EnableTextToSpeech then
  begin
    if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': Запуск SAPITextToSpeech.');
    Grid := HackTStringsIndexOf(TextToSpeechSGrid.Cols[1], DetectEventsTypeName(EType));
    if Length(Grid) > 0 then // Команда найдена в списке
    begin
      if EnableLogs then WriteInLog(WorkPath, Format('%s: В TextToSpeechSGrid найдено %d событий.', [FormatDateTime('dd.mm.yy hh:mm:ss', Now), Length(Grid)]));
      for K := Low(Grid) to High(Grid) do // Перебор найденных событий
      begin
        if DetectEventsTypeStatusName(TextToSpeechSGrid.Cells[2,Grid[K]]) = mEnable then
        begin
          if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': SAPITextToSpeech = ' + TextToSpeechSGrid.Cells[0,Grid[K]]);
          if TextToSpeechEngine = 0 then // Если Microsoft SAPI
            MGSAPI.Speak(TextToSpeechSGrid.Cells[0,Grid[K]])
          else
            OtherTTS(TextToSpeechSGrid.Cells[0,Grid[K]]);
        end;
      end;
    end;
  end;
end;

{ Текст в голос  }
procedure TMainForm.TextToSpeech(SayText: String);
begin
  if EnableTextToSpeech then
  begin
    if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': Запуск TextToSpeech. Говорим: ' + SayText);
    if TextToSpeechEngine = Integer(TTTSEngine(TTSMicrosoft)) then // Если Microsoft SAPI
      MGSAPI.Speak(SayText)
    else
      OtherTTS(SayText);
  end;
end;

{ Отправка текстового запроса в систему TTS, прием звукового файла и его воспроизведение }
procedure TMainForm.OtherTTS(const Text: String);
begin
  if Text = EmptyStr then
  begin
    if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': OtherTTS: Строка текста для синтеза пустая.');
    Exit;
  end;
  if TextToSpeechEngine = Integer(TTTSEngine(TTSGoogle)) then // Если Google TTS
  begin
    if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': Запускаем Google TTS (TTSLangCode = ' + GoogleTL + ', Говорим: ' + Text + ')');
    DXAudioOut.Input := MP3In;
    DXAudioOut.Latency := 100;
    MGGoogleTTS.TTSLangCode := GoogleTL;
    MGGoogleTTS.TTSString := Text;
    MGGoogleTTS.OutFileName := GetUserTempPath() + 'mspeech-tts-google.mp3';
    MGGoogleTTS.SpeakText;
  end
  else if TextToSpeechEngine = Integer(TTTSEngine(TTSYandex)) then // Если Yandex TTS
  begin
    if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': Запускаем Yandex TTS (TTSLangCode = ' + YandexTL + ', Говорим: ' + Text + ')');
    DXAudioOut.Input := MP3In;
    DXAudioOut.Latency := 79;
    MGYandexTTS.TTSLangCode := YandexTL;
    MGYandexTTS.TTSString := Text;
    MGYandexTTS.OutFileName := GetUserTempPath() + 'mspeech-tts-yandex.mp3';
    MGYandexTTS.SpeakText;
  end
  else if TextToSpeechEngine = Integer(TTTSEngine(TTSISpeech)) then // Если iSpeech TTS
  begin
    if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': Запускаем iSpeech TTS (TTSLangCode = ' + iSpeechTL + ', Говорим: ' + Text + ')');
    DXAudioOut.Input := MP3In;
    DXAudioOut.Latency := 100;
    MGISpeechTTS.TTSLangCode := iSpeechTL;
    MGISpeechTTS.TTSString := Text;
    MGISpeechTTS.APIKey := iSpeechAPIKey;
    MGISpeechTTS.OutFileName := GetUserTempPath() + 'mspeech-tts-ispeech.mp3';
    MGISpeechTTS.SpeakText;
  end
  else if TextToSpeechEngine = Integer(TTTSEngine(TTSNuance)) then // Если Nuance TTS
  begin
    if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': Запускаем Nuance TTS (TTSVoice = ' + NuanceTL + ', Говорим: ' + Text + ')');
    DXAudioOut.Input := WaveIn;
    DXAudioOut.Latency := 100;
    MGNuanceTTS.ID := '000';
    MGNuanceTTS.TTSVoice := NuanceTL;
    MGNuanceTTS.TTSString := Text;
    MGNuanceTTS.APIKey := NuanceAPIKey;
    MGNuanceTTS.APPID := NuanceAPPID;
    MGNuanceTTS.OutFileName := GetUserTempPath() + 'mspeech-tts-nuance.wav';
    MGNuanceTTS.SpeakText;
  end;
end;

procedure TMainForm.DXAudioOutDone(Sender: TComponent);
begin
  if (Sender as TDXAudioOut).Input is TMP3In then
  begin
    if FileExists(MP3In.FileName) then
      DeleteFile(MP3In.FileName);
  end;
  if (Sender as TDXAudioOut).Input is TWaveIn then
  begin
    if FileExists(WaveIn.FileName) then
      DeleteFile(WaveIn.FileName);
  end;
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
  MSpeechPopupMenu.Items[2].Caption := GetLangStr('MSpeechPopupMenuShowLog');
  MSpeechPopupMenu.Items[3].Caption := GetLangStr('MSpeechPopupMenuExit');
  GBMain.Caption := Format(' %s ', [GetLangStr('GBMain')]);
  LSignalLevel.Caption := GetLangStr('LSignalLevel');
  StartButton.Caption := GetLangStr('StartButton');
  StopButton.Caption := GetLangStr('StopButton');
  SettingsButton.Caption := GetLangStr('SettingsButton');
end;

end.
