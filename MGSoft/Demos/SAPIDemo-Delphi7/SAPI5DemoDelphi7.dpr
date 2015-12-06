{ ############################################################################### }
{ #                                                                             # }
{ #  MGSoft TTS Demo v1.0.0 - Демонстрация синтез голоса через Microsoft SAPI   # }
{ #                                                                             # }
{ #  License: GPLv3                                                             # }
{ #                                                                             # }
{ #  MGSoft TTS Demo                                                            # }
{ #                                                                             # }
{ #  Author: Mikhail Grigorev (icq: 161867489, email: sleuthhound@gmail.com)    # }
{ #                                                                             # }
{ ############################################################################### }

program SAPI5DemoDelphi7;

uses
  Forms,
  SAPI in 'SAPI.pas' {MainForm},
  GlobalSAPI in 'GlobalSAPI.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
