{ ############################################################################ }
{ #                                                                          # }
{ #  MSpeech v1.5.5 - Распознавание речи используя Google Speech API         # }
{ #                                                                          # }
{ #  License: GPLv3                                                          # }
{ #                                                                          # }
{ #  Author: Grigorev Michael (icq: 161867489, email: sleuthhound@gmail.com) # }
{ #                                                                          # }
{ ############################################################################ }

program MSpeech;

uses
  {$IFDEF DEBUG}
  {$ENDIF }
  Vcl.Forms,
  OnlyOneRun in 'OnlyOneRun.pas',
  Main in 'Main.pas' {MainForm},
  Global in 'Global.pas',
  Settings in 'Settings.pas' {SettingsForm},
  Log in 'Log.pas' {LogForm},
  Recognizer in 'Recognizer.pas';

{$R *.res}

begin
  if not Init_Mutex(ProgramsName) then
  begin
    if GetSysLang = 'Русский' then
      Application.MessageBox('Программа уже запущена.', 'Ошибка запуска', 0 or 48)
    else
      Application.MessageBox('The program is already running.', 'Error', 0 or 48);
    Exit;
  end;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'MSpeech - Распознавание голоса с помощью GoogleSpeech';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TSettingsForm, SettingsForm);
  Application.CreateForm(TLogForm, LogForm);
  Application.Run;
end.
