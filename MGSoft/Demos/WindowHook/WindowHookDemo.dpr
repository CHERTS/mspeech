program WindowHookDemo;

uses
  Forms,
  WindowsHook in 'WindowsHook.pas' {MainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
