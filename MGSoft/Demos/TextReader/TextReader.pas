unit TextReader;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, MGTextReader;

type
  TMainForm = class(TForm)
    TextListView: TListView;
    OpenDialog: TOpenDialog;
    ButtonOpenFile: TButton;
    StatusBar: TStatusBar;
    ButtonReadLn: TButton;
    LabelReadLn: TLabel;
    procedure FormDestroy(Sender: TObject);
    procedure TextListViewData(Sender: TObject; Item: TListItem);
    procedure ButtonOpenFileClick(Sender: TObject);
    procedure ButtonReadLnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FFileName: String;
    FTextReader: TMGTextReaderA;
  public
    procedure ClearLabels;
    procedure OpenFile(const FileName: string);
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses
  MGUtils;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  ClearLabels;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FTextReader);
end;

procedure TMainForm.ClearLabels;
begin
  LabelReadLn.Caption := '';
end;

procedure TMainForm.OpenFile(const FileName: string);
var
  TC: Cardinal;
  LineCount: Integer;
  LineCountTime: Extended;
begin
  FreeAndNil(FTextReader);
  FFileName := '';
  TextListView.Items.Count := 0;
  StatusBar.Panels[0].Text := '';
  StatusBar.Panels[1].Text := '';
  ClearLabels;
  FTextReader := TMGTextReaderA.Create(FileName);
  FFileName := FileName;
  TC := GetTickCount;
  LineCount := FTextReader.LineCount;
  LineCountTime := GetTickCount - TC;
  TextListView.Items.Count := LineCount;
  TextListView.Invalidate;
  StatusBar.Panels[0].Text := ExtractFileName(FileName);
  StatusBar.Panels[1].Text := Format('Lines: %d, Counting time: %.2f ms', [LineCount, LineCountTime]);
end;

procedure TMainForm.TextListViewData(Sender: TObject; Item: TListItem);
begin
  Item.Caption := string(FTextReader.Lines[Item.Index]);
end;

procedure TMainForm.ButtonOpenFileClick(Sender: TObject);
begin
  with OpenDialog do
  begin
    FileName := '';
    if Execute then
      OpenFile(FileName);
  end;
end;

procedure TMainForm.ButtonReadLnClick(Sender: TObject);
var
  TC: Cardinal;
  TotalTime, StringListTotalTime, AssignFileTotalTime: Extended;
  LineCount, I: Integer;
  S: String;
  Reader: TMGTextReaderA;
  SL: TStringList;
  T: TextFile;
begin
  if FFileName = '' then
    Exit;
  Screen.Cursor := crHourGlass;
  try
    ClearLabels;
    // TMGTextReaderA
    LineCount := 0;
    TC := GetTickCount;
    Reader := TMGTextReaderA.Create(FFileName);
    try
      Reader.GoBegin;
      while not Reader.Eof do
      begin
        S := string(Reader.ReadLn);
        Inc(LineCount);
      end;
      TotalTime := GetTickCount - TC;
    finally
      Reader.Free;
    end;
    // TStringList
    SL := TStringList.Create;
    try
      TC := GetTickCount;
      SL.LoadFromFile(FFileName);
      for I := 0 to SL.Count - 1 do
        S := SL[I];
      StringListTotalTime := GetTickCount - TC;
    finally
      SL.Free;
    end;
    // AssignFile
    TC := GetTickCount;
    AssignFile(T, FFileName);
    Reset(T);
    while not Eof(T) do
      ReadLn(T, S);
    AssignFileTotalTime := GetTickCount - TC;
    CloseFile(T);

    LabelReadLn.Caption := Format('Lines: %d, TMGTextReaderA: %.2f ms,  TStringList: %.2f ms,  AssignFile: %.2f ms',
      [LineCount, TotalTime, StringListTotalTime, AssignFileTotalTime]);
  finally
    Screen.Cursor := crDefault;
  end;      
end;



end.
