program HotKeyManagerDemo;

uses
  Forms,
  HotKeyManager in 'HotKeyManager.pas' {MainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'HotKeyManager Demo';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
