{ ############################################################################ }
{ #                                                                          # }
{ #  MSpeech v1.5.10                                                         # }
{ #                                                                          # }
{ #  Copyright (с) 2012-2020, Mikhail Grigorev. All rights reserved.         # }
{ #                                                                          # }
{ #  License: http://opensource.org/licenses/GPL-3.0                         # }
{ #                                                                          # }
{ #  Contact: Mikhail Grigorev (email: sleuthhound@gmail.com)                # }
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
  ASR in 'ASR.pas';

{$R *.res}

begin
  if not Init_Mutex(ProgramsName) then
  begin
    if (GetSysLang = 'Русский') or (GetSysLang = 'Russian') or (MatchStrings(GetSysLang, 'Русский*')) then
      Application.MessageBox('Программа уже запущена.', 'Ошибка запуска', 0 or 48)
    else
      Application.MessageBox('The program is already running.', 'Error', 0 or 48);
    Exit;
  end;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'MSpeech';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TSettingsForm, SettingsForm);
  Application.CreateForm(TLogForm, LogForm);
  Application.Run;
end.
