program TextReaderDemo;

uses
  Forms,
  TextReader in 'TextReader.pas' {MainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
