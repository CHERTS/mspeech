program FormStorageDemo;

uses
  Forms,
  FormStorage in 'FormStorage.pas' {MainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
