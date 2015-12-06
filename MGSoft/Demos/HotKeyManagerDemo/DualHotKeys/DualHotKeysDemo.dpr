program DualHotKeysDemo;

uses
  Forms,
  DualHotKeys in 'DualHotKeys.pas' {MainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Dual HotKeys Demo';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
