{ ############################################################################ }
{ #                                                                          # }
{ #  SearchAppClassName                                                      # }
{ #                                                                          # }
{ #  License: GPLv3                                                          # }
{ #                                                                          # }
{ #  Author: Mikhail Grigorev (icq: 161867489, email: sleuthhound@gmail.com) # }
{ #                                                                          # }
{ ############################################################################ }

unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TMainForm = class(TForm)
    GBSearch: TGroupBox;
    StartStopSearchButton: TButton;
    SearchTimer: TTimer;
    LHandle: TLabel;
    EHandle: TEdit;
    LClassName: TLabel;
    EClassName: TEdit;
    LCaption: TLabel;
    ECaption: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure StartStopSearchButtonClick(Sender: TObject);
    procedure SearchTimerTimer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ShowHwndAndClassName(CrPos: TPoint);
  end;

var
  MainForm: TMainForm;

const
  MaxCaptionSize: Integer = 255;

implementation

{$R *.dfm}

procedure TMainForm.FormCreate(Sender: TObject);
begin
  MainForm.FormStyle := fsStayOnTop;
end;

procedure TMainForm.StartStopSearchButtonClick(Sender: TObject);
begin
  SearchTimer.Interval := 50;
  SearchTimer.Enabled := not SearchTimer.Enabled;
  if SearchTimer.Enabled then
    StartStopSearchButton.Caption := 'Stop search'
  else
    StartStopSearchButton.Caption := 'Start search'
end;

procedure TMainForm.SearchTimerTimer(Sender: TObject);
var
  rPos: TPoint;
begin
  if Boolean(GetCursorPos(rPos)) then
    ShowHwndAndClassName(rPos);
end;

procedure TMainForm.ShowHwndAndClassName(CrPos: TPoint);
var
  hWnd: THandle;
  aName: Array [0..255] of Char;
  MyCaption: String;
begin
  // Handle
  hWnd := WindowFromPoint(CrPos);
  EHandle.Text := IntToStr(hWnd);
  // «‡„ÓÎÓ‚ÓÍ
  SetLength(MyCaption, MaxCaptionSize);
  GetWindowText(hWnd, pChar(MyCaption), MaxCaptionSize);
  if MyCaption <> '' then
    ECaption.Text := MyCaption
  else
    ECaption.Text := '—aption not found';
  // ClassName
  if Boolean(GetClassName(hWnd, aName, 256)) then
    EClassName.Text := String(aName)
  else
    EClassName.Text := 'ClassName not found';
end;

end.
