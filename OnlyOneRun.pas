{ ############################################################################ }
{ #                                                                          # }
{ #  MSpeech v1.5.9                                                          # }
{ #                                                                          # }
{ #  Copyright (c) 2012-2016, Mikhail Grigorev. All rights reserved.         # }
{ #                                                                          # }
{ #  License: http://opensource.org/licenses/GPL-3.0                         # }
{ #                                                                          # }
{ #  Contact: Mikhail Grigorev (email: sleuthhound@gmail.com)                # }
{ #                                                                          # }
{ ############################################################################ }

unit OnlyOneRun;

interface

function Init_Mutex(MId: String): Boolean;

implementation

uses Windows;

var
  Mut: THandle;

function Mut_Id(s: String): String;
var
  f: integer;
begin
  Result := s;
  for f := 1 to Length(s) do
    if Result[f] = '\' then
      Result[f] := '_';
end;

function Init_Mutex(MId: String): Boolean;
begin
  Mut := CreateMutex(nil, False, pChar(Mut_Id(Mid)));
  Result := not ((Mut = 0) or (GetLastError = ERROR_ALREADY_EXISTS));
end;

initialization
  Mut := 0;
finalization
  if Mut <> 0 then
    CloseHandle(Mut);
end.
