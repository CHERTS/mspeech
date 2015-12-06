{ ################################################################################## }
{ #                                                                                # }
{ #  MGSoft MGWindowHook Demo v1.0.0 - Демонстрация установки хука                 # }
{ #                                                                                # }
{ #  License: GPLv3                                                                # }
{ #                                                                                # }
{ #  MGSoft MGWindowHook Demo                                                      # }
{ #                                                                                # }
{ #  Author: Mikhail Grigorev (icq: 161867489, email: sleuthhound@gmail.com)       # }
{ #                                                                                # }
{ ################################################################################## }

unit WindowsHook;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, MGHook, StdCtrls;

type
  TMainForm = class(TForm)
    MGWindowHook1: TMGWindowHook;
    ButtonActivate: TButton;
    ButtonHook: TButton;
    procedure MGWindowHook1AfterMessage(Sender: TObject; var Msg: TMessage; var Handled: Boolean);
    procedure ButtonActivateClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.MGWindowHook1AfterMessage(Sender: TObject;
  var Msg: TMessage; var Handled: Boolean);
begin
  ButtonHook.Caption:='WindowHook';
end;

procedure TMainForm.ButtonActivateClick(Sender: TObject);
begin
  MainForm.ButtonHook.Caption := 'Active = True';
  MGWindowHook1.Active := True;
end;

end.
