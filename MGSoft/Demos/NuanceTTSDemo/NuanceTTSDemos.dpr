program NuanceTTSDemos;

uses
  Vcl.Forms,
  NuanceTTS in 'NuanceTTS.pas' {MainForm},
  GlobalNuanceTTS in 'GlobalNuanceTTS.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
