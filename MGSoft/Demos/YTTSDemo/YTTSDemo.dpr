program YTTSDemo;

uses
  Vcl.Forms,
  YTTS in 'YTTS.pas' {MainForm},
  GlobalYTTS in 'GlobalYTTS.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
