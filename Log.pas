{ ############################################################################ }
{ #                                                                          # }
{ #  MSpeech v1.4 - ������������� ���� ��������� Google Speech API           # }
{ #                                                                          # }
{ #  License: GPLv3                                                          # }
{ #                                                                          # }
{ #  Author: Mikhail Grigorev (icq: 161867489, email: sleuthhound@gmail.com) # }
{ #                                                                          # }
{ ############################################################################ }

unit Log;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Global, JvAppStorage, JvAppIniStorage, JvComponentBase,
  JvFormPlacement, JvThread, JvExControls, JvAnimatedImage, JvGIFCtrl, ExtCtrls,
  ComCtrls, CommCtrl, JvExStdCtrls, JclFileUtils, Menus, ClipBrd;

type
  TLogForm = class(TForm)
    LFileNameDesc: TLabel;
    CBFileName: TComboBox;
    DeleteLogButton: TButton;
    LogFormStorage: TJvFormStorage;
    ReloadLogButton: TButton;
    FileReadThread: TJvThread;
    GIFPanel: TPanel;
    JvGIFAnimator: TJvGIFAnimator;
    GIFStaticText: TStaticText;
    StatusBar: TStatusBar;
    TextListView: TListView;
    LogPopupMenu: TPopupMenu;
    LogCopy: TMenuItem;
    SelectAllRow: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
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
    procedure FormDestroy(Sender: TObject);
    procedure SelectAllRowClick(Sender: TObject);
  private
    { Private declarations }
    FTextReader: TJclAnsiMappedTextReader;
    IsUnicodeFile: Boolean;
    FTextList: TList;
    procedure OnLogUpdated(var Msg: TMessage); message WM_UPDATELOG;
    // ��� �������������� ���������
    procedure OnLanguageChanged(var Msg: TMessage); message WM_LANGUAGECHANGED;
    procedure LoadLanguageStrings;
  public
    { Public declarations }
  end;
  TMyLog = class
    private
      LogString: String;
    public
      property Log: String read LogString;
    constructor Create(const LogString: String);
  end;
var
  LogForm: TLogForm;

implementation

{$R *.dfm}

uses
  Main;

// ����������� TMyLog
constructor TMyLog.Create(const LogString: String);
begin
  // ���������� ���������� ����������
  Self.LogString := LogString;
end;

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
end;

procedure TLogForm.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FTextReader);
end;

procedure TLogForm.FormResize(Sender: TObject);
begin
  if GIFPanel.Visible then
  begin
    GIFPanel.Left := (TextListView.Width div 2) - (GIFPanel.Width div 2);
    GIFPanel.Top := (TextListView.Height div 2) + (GIFPanel.Height div 2);
  end;
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
  // ������������� ��������
  GIFPanel.BringToFront;
  GIFPanel.Left := (TextListView.Width div 2) - (GIFPanel.Width div 2);
  GIFPanel.Top := (TextListView.Height div 2) + (GIFPanel.Height div 2);
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
  FileReadThreadStop;
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
  if EnableLogs then
    EnableLogs := False;
  // ������ ������
  GIFPanel.Left := (TextListView.Width div 2) - (GIFPanel.Width div 2);
  GIFPanel.Top := (TextListView.Height div 2) + (GIFPanel.Height div 2);
  GIFPanel.Visible := True;
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
      FreeAndNil(FTextReader);
      FreeAndNil(FTextList);
      try
        TC := GetTickCount;
        FTextReader := TJclAnsiMappedTextReader.Create(FileName);
        FTextList := TList.Create;
        FTextList.Clear;
        LineCount := FTextReader.LineCount;
        LineCountTime := GetTickCount - TC;
        for I := 0 to LineCount-1 do
          FTextList.Add(TMyLog.Create(FTextReader.Lines[I]));
        TextListView.Items.Count := LineCount;
        //TextListView.Invalidate;
        StatusBar.Panels[0].Text := ExtractFileName(FileName);
        StatusBar.Panels[1].Text := Format(GetLangStr('TotalString'), [LineCount]);
        StatusBar.Panels[2].Text := Format(GetLangStr('LoadingTime'), [LineCountTime]);
        FreeAndNil(FTextReader);
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
var
  I: Integer;
begin
  GIFPanel.Visible := False;
  EnableLogs := ReadCustomINI(WorkPath, 'Main', 'EnableLogs', False);
  SendMessage(TextListView.Handle, WM_VSCROLL, SB_BOTTOM, 0);
end;

{ ��������� ����� }
procedure TLogForm.FileReadThreadStop;
begin
  if not FileReadThread.Terminated then
    FileReadThread.Terminate;
  while not (FileReadThread.Terminated) do
  begin
    Sleep(1);
    Application.ProcessMessages;
  end;
  TextListView.Clear;
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
  if Assigned(FTextList) then
  begin
    if IsUnicodeFile then
      Item.Caption := UTF8ToWideString(TMyLog(FTextList[Item.Index]).Log)
    else
      Item.Caption := TMyLog(FTextList[Item.Index]).Log;
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
      if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ' - ��������� DeleteLogButtonClick: ���� ' + CBFileName.Items[CBFileName.ItemIndex] + ' ������.');
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
  GIFStaticText.Caption := GetLangStr('PleaseWait');
  GIFPanel.Left := (TextListView.Width div 2) - (GIFPanel.Width div 2);
  GIFPanel.Top := (TextListView.Height div 2) + (GIFPanel.Height div 2);
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
