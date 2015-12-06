program SAPI5Demo;

uses
  Vcl.Forms,
  SAPI in 'SAPI.pas' {MainForm},
  GlobalSAPI in 'GlobalSAPI.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
