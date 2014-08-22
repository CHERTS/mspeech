{ ############################################################################ }
{ #                                                                          # }
{ #  MSpeech_Reciver_Demo                                                    # }
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
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TCopyDataType = (cdtString = 0, cdtImage = 1, cdtRecord = 2);
  TMainForm = class(TForm)
    ReciverMemo: TMemo;
  private
    { Private declarations }
    procedure OnControlReq(var Msg : TWMCopyData); message WM_COPYDATA;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

{ Прием текста по событию WM_COPYDATA }
procedure TMainForm.OnControlReq(var Msg : TWMCopyData);
var
  TextStr: String;
  copyDataType : TCopyDataType;
  GotChars: Integer;
begin
  copyDataType := TCopyDataType(Msg.CopyDataStruct.dwData);
  if copyDataType = cdtString then
  begin
    GotChars := Msg.CopyDataStruct.cbData div SizeOf(Char);
    SetLength(TextStr, GotChars);
    Move(Msg.CopyDataStruct.lpData^, pChar(TextStr)^, GotChars * SizeOf(Char));
    ReciverMemo.Lines.Add(FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': ' + TextStr);
    Msg.Result := 2006;
  end;
end;

end.
