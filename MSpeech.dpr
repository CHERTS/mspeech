{ ############################################################################ }
{ #                                                                          # }
{ #  MSpeech v1.2 - Распознавание речи используя Google Speech API           # }
{ #                                                                          # }
{ #  License: GPLv3                                                          # }
{ #                                                                          # }
{ #  Author: Grigorev Michael (icq: 161867489, email: sleuthhound@gmail.com) # }
{ #                                                                          # }
{ ############################################################################ }

program MSpeech;

uses
  Forms,
  OnlyOneRun in 'OnlyOneRun.pas',
  Main in 'Main.pas' {MainForm},
  About in 'About.pas' {AboutForm},
  Global in 'Global.pas';

{$R *.res}

begin
  if not Init_Mutex(ProgramsName) then
  begin
    Application.MessageBox('Программа уже запущена.', 'Ошибка запуска', 0 or 48);
    Exit;
  end;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'MSpeech - Распознавание голоса с помощью GoogleSpeech';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TAboutForm, AboutForm);
  Application.Run;
end.
