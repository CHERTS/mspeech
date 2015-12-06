program TessOCRDemoFMX;

uses
  FMX.Forms,
  TessOCRFMX in 'TessOCRFMX.pas' {MainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
