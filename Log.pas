{ ############################################################################ }
{ #                                                                          # }
{ #  MSpeech v1.5.9                                                          # }
{ #                                                                          # }
{ #  Copyright (�) 2012-2016, Mikhail Grigorev. All rights reserved.         # }
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
    // ��� �������������� ���������
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
  // ��� �������������� ���������
  LogFormHandle := Handle;
  SetWindowLong(Handle, GWL_HWNDPARENT, 0);
  SetWindowLong(Handle, GWL_EXSTYLE, GetWindowLong(Handle, GWL_EXSTYLE) or WS_EX_APPWINDOW);
  // ��������� ���� ����������
  LoadLanguageStrings;
  // ��������� TextListView
  // ���� ��� http://zarezky.spb.ru/lectures/mfc/list-control.html
  ListView_SetExtendedListViewStyle(TextListView.Handle, LVS_EX_DOUBLEBUFFER or LVS_EX_FULLROWSELECT); // or LVS_EX_INFOTIP
  // ���������� ������� ����
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
  // ������������ ����
  AlphaBlend := AlphaBlendEnable;
  AlphaBlendValue := AlphaBlendEnableValue;
  // ������ ���������
  TextListView.Clear;
  CBFileName.ItemIndex := -1;
  ReloadLogButton.Enabled := False;
  DeleteLogButton.Enabled := False;
  IsUnicodeFile := False;
end;

procedure TLogForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // ��������� �����
  FileReadThreadStop;
end;

{ ��������� ������ CBFileName }
procedure TLogForm.CBFileNameDropDown(Sender: TObject);
begin
  // ��������� �����
  //FileReadThreadStop;
  // ���������� ������ ������
  CheckLogFile;
end;

{ ��������� ������ � CBFileName }
procedure TLogForm.CBFileNameChange(Sender: TObject);
begin
  // ��������� �����
  FileReadThreadStop;
  // ��������� ����
  CloseLogFile;
  // ��������...
  StatusBar.Panels[0].Text := GetLangStr('PleaseWait');
  StatusBar.Panels[1].Text := '';
  StatusBar.Panels[2].Text := '';
  StartWait;
  if EnableLogs then
    EnableLogs := False;
  FileReadThread.Execute(Self);
end;

{ ����� ������ ���-����� }
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

{ ����� �������� }
procedure TLogForm.FileReadThreadFinish(Sender: TObject);
begin
  EnableLogs := ReadCustomINI(WorkPath, 'Main', 'EnableLogs', False);
  SendMessage(TextListView.Handle, WM_VSCROLL, SB_BOTTOM, 0);
  // ��������� ��������
  StopWait;
end;

{ ��������� ����� }
procedure TLogForm.FileReadThreadStop;
begin
  // ��������� ��������
  StopWait;
  // ������������� �����
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
    // ��������� �����
    FileReadThreadStop;
    // �������� ������� ����
    Deleted := False;
    UserAnswer := 1;
    repeat
      Deleted := SysUtils.DeleteFile(CBFileName.Items[CBFileName.ItemIndex]);
      if not Deleted then
      begin
        case MessageBox(Handle,PWideChar(Format(GetLangStr('MsgErr9'), [CBFileName.Items[CBFileName.ItemIndex]]) + #13 +
            GetLangStr('MsgErr10')),PWideChar(MainForm.Caption + ' - ' + GetLangStr('MsgErr8')),36) of
          6: UserAnswer := 1; // ��
          7: UserAnswer := 0; // ���
        end;
      end;
    until (Deleted) or (UserAnswer = 0);
    if Deleted then
    begin
      if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ' - ��������� DeleteLogButtonClick: ���� ' + CBFileName.Items[CBFileName.ItemIndex] + ' ������.');
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

{ ��������� ������ ������ �� ����� � ������������ �� ������ }
procedure TLogForm.FindLogFile(Dir, Ext: String);
var
  SR: TSearchRec;
begin
  if FindFirst(Dir + '*.*', faAnyFile or faDirectory, SR) = 0 then
  begin
    repeat
      if (SR.Attr = faDirectory) and ((SR.Name = '.') or (SR.Name = '..')) then // ����� �� ���� ������ . � ..
      begin
        Continue; // ���������� ����
      end;
      if MatchStrings(SR.Name, Ext) then
      begin
        // ��������� ����
        CBFileName.Items.Add(Dir+SR.Name);
      end;
      if (SR.Attr = faDirectory) then // ���� ����� ����������, �� ���� ����� � ���
      begin
        FindLogFile(Dir + '\' + SR.Name, Ext); // P��������� �������� ���� ���������
        Continue; // ���������� ����
      end;
    until FindNext(SR) <> 0;
    FindClose(SR);
  end;
end;

procedure TLogForm.ReloadLogButtonClick(Sender: TObject);
begin
  CBFileNameChange(ReloadLogButton);
end;

{ ��������� ���� �� ������� WM_UPDATELOG }
procedure TLogForm.OnLogUpdated(var Msg: TMessage);
begin
  if CBFileName.ItemIndex <> -1 then
    ReloadLogButton.Click;
end;

{ ����� ����� ���������� �� ������� WM_LANGUAGECHANGED }
procedure TLogForm.OnLanguageChanged(var Msg: TMessage);
begin
  LoadLanguageStrings;
end;

{ ��� �������������� ��������� }
procedure TLogForm.LoadLanguageStrings;
begin
  Caption := ProgramsName + ' - ' + GetLangStr('LogFormCaption');
  LogPopupMenu.Items[0].Caption := GetLangStr('Copy');
  LogPopupMenu.Items[1].Caption := GetLangStr('SelectAll');
  LFileNameDesc.Caption := GetLangStr('LFileNameDesc');
  DeleteLogButton.Caption := GetLangStr('DeleteLogButton');
  ReloadLogButton.Caption := GetLangStr('ReloadLogButton');
  // ������������� ������
  CBFileName.Left := LFileNameDesc.Left + LFileNameDesc.Width + 5;
  CBFileName.Width := ReloadLogButton.Left - CBFileName.Left - 5;
end;

end.
