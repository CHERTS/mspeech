program GTTSDemoDelphi7;

uses
  Forms,
  GTTS in 'GTTS.pas' {MainForm},
  GlobalGTTS in 'GlobalGTTS.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
