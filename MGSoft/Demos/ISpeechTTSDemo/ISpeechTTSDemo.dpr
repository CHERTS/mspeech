program ISpeechTTSDemo;

uses
  Vcl.Forms,
  ISpeechTTS in 'ISpeechTTS.pas' {MainForm},
  GlobalISpeechTTS in 'GlobalISpeechTTS.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
