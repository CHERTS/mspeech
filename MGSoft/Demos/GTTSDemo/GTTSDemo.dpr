program GTTSDemo;

uses
  Vcl.Forms,
  GTTS in 'GTTS.pas' {MainForm},
  GlobalGTTS in 'GlobalGTTS.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
