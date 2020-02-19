{ ############################################################################ }
{ #                                                                          # }
{ #  MSpeech v1.5.10                                                         # }
{ #                                                                          # }
{ #  Copyright (c) 2012-2020, Mikhail Grigorev. All rights reserved.         # }
{ #                                                                          # }
{ #  License: http://opensource.org/licenses/GPL-3.0                         # }
{ #                                                                          # }
{ #  Contact: Mikhail Grigorev (email: sleuthhound@gmail.com)                # }
{ #                                                                          # }
{ ############################################################################ }

unit Log;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Global, ExtCtrls, ComCtrls, CommCtrl, MGTextReader, MGThread,
  MGVCLUtils, Menus, ClipBrd, MGPlacement;

type
  TLogForm = class(TForm)
    LFileNameDesc: TLabel;
    CBFileName: TComboBox;
    DeleteLogButton: TButton;
    ReloadLogButton: TButton;
    FileReadThread: TMGThread;
    StatusBar: TStatusBar;
    TextListView: TListView;
    LogPopupMenu: TPopupMenu;
    LogCopy: TMenuItem;
    SelectAllRow: TMenuItem;
    MGFormPlacement: TMGFormPlacement;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure CBFileNameChange(Sender: TObject);
    procedure DeleteLogButtonClick(Sender: TObject);
    procedure ReloadLogButtonClick(Sender: TObject);
    procedure FileReadThreadExecute(Sender: TObject; Params: Pointer);
    procedure FileReadThreadFinish(Sender: TObject);
    procedure CBFileNameDropDown(Sender: TObject);
    procedure CheckLogFile;
    procedure FileReadThreadStop;
    procedure FindLogFile(Dir, Ext: String);
    procedure TextListViewData(Sender: TObject; Item: TListItem);
    procedure TextListViewCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure TextListViewContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
    procedure LogCopyClick(Sender: TObject);
    procedure SelectAllRowClick(Sender: TObject);
  private
    { Private declarations }
    FTextReader: TMGTextReaderA;
    IsUnicodeFile: Boolean;
    procedure OnLogUpdated(var Msg: TMessage); message WM_UPDATELOG;
    // Для мультиязыковой поддержки
    procedure OnLanguageChanged(var Msg: TMessage); message WM_LANGUAGECHANGED;
    procedure LoadLanguageStrings;
  public
    { Public declarations }
  end;

var
  LogForm: TLogForm;

implementation

{$R *.dfm}

uses
  Main;

procedure TLogForm.FormCreate(Sender: TObject);
begin
  // Для мультиязыковой поддержки
  LogFormHandle := Handle;
  SetWindowLong(Handle, GWL_HWNDPARENT, 0);
  SetWindowLong(Handle, GWL_EXSTYLE, GetWindowLong(Handle, GWL_EXSTYLE) or WS_EX_APPWINDOW);
  // Загружаем язык интерфейса
  LoadLanguageStrings;
  // Настройки TextListView
  // Инфо тут http://zarezky.spb.ru/lectures/mfc/list-control.html
  ListView_SetExtendedListViewStyle(TextListView.Handle, LVS_EX_DOUBLEBUFFER or LVS_EX_FULLROWSELECT); // or LVS_EX_INFOTIP
  // Сохранение позиций окна
  MGFormPlacement.IniFileName := WorkPath + INIFormStorage;
end;

procedure TLogForm.FormDestroy(Sender: TObject);
begin
  if Assigned(FTextReader) then
    FreeAndNil(FTextReader);
end;

procedure TLogForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    Close;
end;

procedure TLogForm.FormShow(Sender: TObject);
begin
  // Прозрачность окна
  AlphaBlend := AlphaBlendEnable;
  AlphaBlendValue := AlphaBlendEnableValue;
  // Другие настройки
  TextListView.Clear;
  CBFileName.ItemIndex := -1;
  ReloadLogButton.Enabled := False;
  DeleteLogButton.Enabled := False;
  IsUnicodeFile := False;
end;

procedure TLogForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // Завершаем поток
  FileReadThreadStop;
end;

{ Раскрытие списка CBFileName }
procedure TLogForm.CBFileNameDropDown(Sender: TObject);
begin
  // Завершаем поток
  //FileReadThreadStop;
  // Построение списка файлов
  CheckLogFile;
end;

{ Изменение текста в CBFileName }
procedure TLogForm.CBFileNameChange(Sender: TObject);
begin
  // Завершаем поток
  FileReadThreadStop;
  // Закрываем логи
  CloseLogFile;
  // Ожидание...
  StatusBar.Panels[0].Text := GetLangStr('PleaseWait');
  StatusBar.Panels[1].Text := '';
  StatusBar.Panels[2].Text := '';
  StartWait;
  if EnableLogs then
    EnableLogs := False;
  FileReadThread.Execute(Self);
end;

{ Поток чтения лог-файла }
procedure TLogForm.FileReadThreadExecute(Sender: TObject; Params: Pointer);
var
  FileName: String;
  TC: Cardinal;
  LineCount, TempLineCount: Integer;
  LineCountTime: Extended;
  I: Integer;
begin
  FileName := CBFileName.Items[CBFileName.ItemIndex];
  if FileExists(FileName) then
  begin
    TextListView.Clear;
    if GetMyFileSize(FileName) > 0 then
    begin
      DeleteLogButton.Enabled := False;
      ReloadLogButton.Enabled := False;
      if Assigned(FTextReader) then
        FreeAndNil(FTextReader);
      try
        TC := GetTickCount;
        FTextReader := TMGTextReaderA.Create(FileName);
        LineCount := FTextReader.LineCount;
        LineCountTime := GetTickCount - TC;
        TextListView.Items.Count := LineCount;
        StatusBar.Panels[0].Text := ExtractFileName(FileName);
        StatusBar.Panels[1].Text := Format(GetLangStr('TotalString'), [LineCount]);
        StatusBar.Panels[2].Text := Format(GetLangStr('LoadingTime'), [LineCountTime]);
      except
        on E: Exception do
        begin
          EnableLogs := ReadCustomINI(WorkPath, 'Main', 'EnableLogs', False);
          MsgDie(ProgramsName + ' - ' + GetLangStr('MsgErr5'), PWideChar(Format(GetLangStr('MsgErr6'), [FileName]) + #13 +
            GetLangStr('MsgErr7') + #13 + Trim(E.Message)));
        end;
      end;
    end
    else
    begin
      StatusBar.Panels[0].Text := ExtractFileName(FileName);
      StatusBar.Panels[1].Text := Format(GetLangStr('TotalString'), [0]);
      StatusBar.Panels[2].Text := Format(GetLangStr('LoadingTime'), [0.00]);
    end;
    ReloadLogButton.Enabled := True;
    DeleteLogButton.Enabled := True;
  end;
end;

{ Поток завершен }
procedure TLogForm.FileReadThreadFinish(Sender: TObject);
begin
  EnableLogs := ReadCustomINI(WorkPath, 'Main', 'EnableLogs', False);
  SendMessage(TextListView.Handle, WM_VSCROLL, SB_BOTTOM, 0);
  // Окончание ожидания
  StopWait;
end;

{ Завершаем поток }
procedure TLogForm.FileReadThreadStop;
begin
  // Окончание ожидания
  StopWait;
  // Останавливаем поток
  if not FileReadThread.Terminated then
    FileReadThread.Terminate;
  while not (FileReadThread.Terminated) do
  begin
    Sleep(1);
    Application.ProcessMessages;
  end;
  if Assigned(FTextReader) then
    FreeAndNil(FTextReader);
end;

procedure TLogForm.LogCopyClick(Sender: TObject);
var
  LVStr: String;
  I: Integer;
begin
  LVStr := '';
  if TextListView.SelCount = 1 then
    LVStr := TextListView.Items.Item[TextListView.ItemIndex].Caption
  else
  begin
    for I := TextListView.ItemIndex to TextListView.ItemIndex+TextListView.SelCount-1 do
      LVStr := LVStr + TextListView.Items.Item[I].Caption + #13#10;
  end;
  Clipboard.SetTextBuf(PChar(LVStr));
end;

procedure TLogForm.SelectAllRowClick(Sender: TObject);
begin
  TextListView.SelectAll;
end;

procedure TLogForm.TextListViewContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin
  if TextListView.Items.Count > 0 then
    TextListView.PopupMenu := LogPopupMenu
  else
    TextListView.PopupMenu := nil;
end;

procedure TLogForm.TextListViewCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
const
  cStripe = $CCFFCC;
begin
  if Odd(Item.Index) then
    Sender.Canvas.Brush.Color := cStripe
  else
    Sender.Canvas.Brush.Color := clWindow;
end;

procedure TLogForm.TextListViewData(Sender: TObject; Item: TListItem);
begin
  if Assigned(FTextReader) then
  begin
    if IsUnicodeFile then
      Item.Caption := UTF8ToWideString((FTextReader.Lines[Item.Index]))
    else
      Item.Caption := String((FTextReader.Lines[Item.Index]));
  end;
end;

procedure TLogForm.DeleteLogButtonClick(Sender: TObject);
var
  Deleted: Boolean;
  UserAnswer: Integer;
begin
  if FileExists(CBFileName.Items[CBFileName.ItemIndex]) then
  begin
    // Завершаем поток
    FileReadThreadStop;
    // Пытаемся удалить файл
    Deleted := False;
    UserAnswer := 1;
    repeat
      Deleted := SysUtils.DeleteFile(CBFileName.Items[CBFileName.ItemIndex]);
      if not Deleted then
      begin
        case MessageBox(Handle,PWideChar(Format(GetLangStr('MsgErr9'), [CBFileName.Items[CBFileName.ItemIndex]]) + #13 +
            GetLangStr('MsgErr10')),PWideChar(MainForm.Caption + ' - ' + GetLangStr('MsgErr8')),36) of
          6: UserAnswer := 1; // Да
          7: UserAnswer := 0; // Нет
        end;
      end;
    until (Deleted) or (UserAnswer = 0);
    if Deleted then
    begin
      if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ' - Процедура DeleteLogButtonClick: Файл ' + CBFileName.Items[CBFileName.ItemIndex] + ' удален.');
      if Assigned(FTextReader) then
        FreeAndNil(FTextReader);
      TextListView.Clear;
      StatusBar.Panels[0].Text := '';
      StatusBar.Panels[1].Text := '';
      StatusBar.Panels[2].Text := '';
    end;
    CheckLogFile;
  end;
end;

procedure TLogForm.CheckLogFile;
begin
  CBFileName.Clear;
  ReloadLogButton.Enabled := False;
  DeleteLogButton.Enabled := False;
  FindLogFile(WorkPath, '*.log');
end;

{ Процедура поиска файлов по маске и формирования их списка }
procedure TLogForm.FindLogFile(Dir, Ext: String);
var
  SR: TSearchRec;
begin
  if FindFirst(Dir + '*.*', faAnyFile or faDirectory, SR) = 0 then
  begin
    repeat
      if (SR.Attr = faDirectory) and ((SR.Name = '.') or (SR.Name = '..')) then // Чтобы не было файлов . и ..
      begin
        Continue; // Продолжаем цикл
      end;
      if MatchStrings(SR.Name, Ext) then
      begin
        // Заполняем лист
        CBFileName.Items.Add(Dir+SR.Name);
      end;
      if (SR.Attr = faDirectory) then // Если нашли директорию, то ищем файлы в ней
      begin
        FindLogFile(Dir + '\' + SR.Name, Ext); // Pекурсивно вызываем нашу процедуру
        Continue; // Продолжаем цикл
      end;
    until FindNext(SR) <> 0;
    FindClose(SR);
  end;
end;

procedure TLogForm.ReloadLogButtonClick(Sender: TObject);
begin
  CBFileNameChange(ReloadLogButton);
end;

{ Подгрузка лога по событию WM_UPDATELOG }
procedure TLogForm.OnLogUpdated(var Msg: TMessage);
begin
  if CBFileName.ItemIndex <> -1 then
    ReloadLogButton.Click;
end;

{ Смена языка интерфейса по событию WM_LANGUAGECHANGED }
procedure TLogForm.OnLanguageChanged(var Msg: TMessage);
begin
  LoadLanguageStrings;
end;

{ Для мультиязыковой поддержки }
procedure TLogForm.LoadLanguageStrings;
begin
  Caption := ProgramsName + ' - ' + GetLangStr('LogFormCaption');
  LogPopupMenu.Items[0].Caption := GetLangStr('Copy');
  LogPopupMenu.Items[1].Caption := GetLangStr('SelectAll');
  LFileNameDesc.Caption := GetLangStr('LFileNameDesc');
  DeleteLogButton.Caption := GetLangStr('DeleteLogButton');
  ReloadLogButton.Caption := GetLangStr('ReloadLogButton');
  // Позиционируем лейблы
  CBFileName.Left := LFileNameDesc.Left + LFileNameDesc.Width + 5;
  CBFileName.Width := ReloadLogButton.Left - CBFileName.Left - 5;
end;

end.
