program TessOCRDemoDelphi7;

uses
  Forms,
  TessOCR in 'TessOCR.pas' {MainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
