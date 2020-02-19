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

unit ASR;

interface

uses Windows, Classes, SysUtils, Global, HTTPSend, synautil;

type
  //JSONError = class(Exception);
  // Статусы
  TRecognizeStatus = (rsRecognizeDone, rsRecordingNotRecognized,
                  rsErrorJsonParse, rsErrorResponse,
                  rsInfo, rsAbort, rsErrorGetAPIKey,
                  rsFileSizeNull, rsErrorConnectionTimedOut,
                  rsErrorNoRouteToHost, rsErrorHostNotFound,
                  rsErrorCommunication, rsErrorPermissionDenied);
  // Структура с информацией о статусе распознавания (передается в callback процедуру)
  TRecognizeInfo = record
    FStatus     : TRecognizeStatus; // Статус
    FMessage    : String;           // Сообщение
    FConfidence : Real;             // Достоверность распознавания в %
    FTranscript : String;           // Распознанная фраза
  end;

  // callback процедура, вызываемая после распознавания
  TRecognizeResultEvent = procedure (Sender: TObject; pInfo: TRecognizeInfo) of object;

  // Запуск распознавания
  procedure StartRecognize(pGoogleAPIKey, pFileName, pRecognizeLang: String; pUseProxy: Boolean; pProxyAddress, pProxyPort: String; pProxyAuth: Boolean; pProxyAuthUserName, pProxyAuthPassword: String; pRecognizeInfoCallBack: TRecognizeResultEvent);
  // Остановка распознавания
  procedure StopRecognize;

implementation

uses
  SSL_OpenSSL, blcksock, uJSON, TypInfo;

type
  RecognizeError = class(Exception);

  TGoogleRecognizer = class(TThread)
  private
    FInputFileName: String;
    FResultList: TStringList;
    FInputStream: TFileStream;
    FRecognizeLang: String;
    FUseProxy: Boolean;
    FProxyAddress: String;
    FProxyPort: String;
    FProxyAuth: Boolean;
    FProxyAuthUserName: String;
    FProxyAuthPassword: String;
    FRecognizeInfoCallBack: TRecognizeResultEvent;
    FRecognizeInfo: TRecognizeInfo;
    FTerminated: Boolean;
    FGoogleAPIKey: String;
    FHTTP: THTTPSend;
    FReadCount: Integer;
    procedure RecognizeEvent;
    function RecognizeResult(E: Boolean; eType: TRecognizeStatus; eText: String): Boolean;
    function GetFileSize(FileName: String): Integer;
    function HTTPPostFile(Const URL, FieldName, FileName: String; Const Data: TStream; Const ResultData: TStrings): Boolean;
    procedure HTTPStatus(Sender: TObject; Reason: THookSocketReason; const Value: String);
    function SendRecognizeRequest(AudioFile: String): TRecognizeInfo;
    function ParseJSONv2(JStringList: TStringList): TRecognizeInfo;
    function HTTPGetSize(var HTTP: THTTPSend; URL: String): int64; overload;
    function HTTPGetSize(URL: String): int64; overload;
  protected
    procedure Execute; override;
  public
    constructor Create(pGoogleAPIKey, pFileName, pRecognizeLang: String; pUseProxy: Boolean; pProxyAddress, pProxyPort: String; pProxyAuth: Boolean; pProxyAuthUserName, pProxyAuthPassword: String; pRecognizeInfoCallBack: TRecognizeResultEvent);
    destructor Destroy; override;
    property Terminated;
    procedure Terminate(NewPriority: TThreadPriority = tpIdle); reintroduce;
    property OnRecognize: TRecognizeResultEvent read FRecognizeInfoCallBack;
  end;

var
  GoogleRecognize: TGoogleRecognizer;

const
  // Ваш ключ Google Speech API
  GoogleRecognizePublicAPIKey = 'Enter-Your-Google-Speech-API-Key';
  GoogleRecognizeURLv2Public = 'https://www.google.com/speech-api/v2/recognize?client=chrome-hotword&output=json&lang=%s&key=%s&app=web-hotword-0.1.1.5018_0';
  GoogleRecognizeURLv2MSpeech = 'https://www.google.com/speech-api/v2/recognize?output=json&lang=%s&key=%s&app=%s';
  PCMInSampleRate = '16000';
  FLACInSampleRate = '44100';
  HTTPTimeout = 4000;

procedure StartRecognize(pGoogleAPIKey, pFileName, pRecognizeLang: String; pUseProxy: Boolean; pProxyAddress, pProxyPort: String; pProxyAuth: Boolean; pProxyAuthUserName, pProxyAuthPassword: String; pRecognizeInfoCallBack: TRecognizeResultEvent);
begin
  GoogleRecognize := TGoogleRecognizer.Create(pGoogleAPIKey, pFileName, pRecognizeLang, pUseProxy, pProxyAddress, pProxyPort, pProxyAuth, pProxyAuthUserName, pProxyAuthPassword, pRecognizeInfoCallBack);
end;

procedure StopRecognize;
begin
  if Assigned(GoogleRecognize) then
  begin
    if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': StopRecognize');
    GoogleRecognize.Terminate;
  end;
end;


procedure DeallocRecognizerThread;
begin
  if Assigned(GoogleRecognize) then
  begin
    if EnableLogs then
    begin
      WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': DeallocRecognizerThread');
      CloseLogFile;
    end;
    GoogleRecognize.Terminate;
    GoogleRecognize.WaitFor;
    GoogleRecognize.Free;
    GoogleRecognize := nil;
  end;
end;

constructor TGoogleRecognizer.Create(pGoogleAPIKey, pFileName, pRecognizeLang: String; pUseProxy: Boolean; pProxyAddress, pProxyPort: String; pProxyAuth: Boolean; pProxyAuthUserName, pProxyAuthPassword: String; pRecognizeInfoCallBack: TRecognizeResultEvent);
begin
  inherited Create(True);
  FreeOnTerminate := True;
  FInputFileName := pFileName;
  FRecognizeLang := pRecognizeLang;
  FUseProxy := pUseProxy;
  FProxyAddress := pProxyAddress;
  FProxyPort := pProxyPort;
  FProxyAuth := pProxyAuth;
  FProxyAuthUserName := pProxyAuthUserName;
  FProxyAuthPassword := pProxyAuthPassword;
  FRecognizeInfoCallBack := pRecognizeInfoCallBack;
  FResultList := TStringList.Create;
  FHTTP := THTTPSend.Create;
  FRecognizeInfo.FStatus := rsRecordingNotRecognized;
  FRecognizeInfo.FConfidence := 0;
  FRecognizeInfo.FTranscript := '';
  FReadCount := 0;
  if pGoogleAPIKey = '' then
    FGoogleAPIKey := GoogleRecognizePublicAPIKey
  else
    FGoogleAPIKey := pGoogleAPIKey;
  FTerminated := False;
  if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': TGoogleRecognizer.Create');
  Resume;
end;

destructor TGoogleRecognizer.Destroy;
begin
  FreeAndNil(FHTTP);
  FreeAndNil(FResultList);
  if EnableLogs then
  begin
    WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': TGoogleRecognizer.Destroy');
    CloseLogFile;
  end;
  inherited Destroy;
end;

procedure TGoogleRecognizer.Terminate(NewPriority: TThreadPriority = tpIdle);
begin
  if (NewPriority <> tpIdle) and (NewPriority <> Priority) then
    Priority := NewPriority;
  inherited Terminate;
end;

procedure TGoogleRecognizer.RecognizeEvent;
begin
  if Assigned(FRecognizeInfoCallBack) then
    FRecognizeInfoCallBack(Self, FRecognizeInfo);
end;

function TGoogleRecognizer.RecognizeResult(E: Boolean; eType: TRecognizeStatus; eText: String): Boolean;
begin
  Result := E;
  if E then
  begin
    FRecognizeInfo.FStatus := eType;
    FRecognizeInfo.FMessage := eText;
    FRecognizeInfo.FConfidence := 0;
    FRecognizeInfo.FTranscript := '';
    RecognizeEvent;
  end;
end;

procedure TGoogleRecognizer.Execute;
begin
  if not FileExists(FInputFileName) then
  begin
    raise RecognizeError.Create(SysErrorMessage(GetLastError));
    Terminate;
  end
  else
  begin
    FRecognizeInfo := SendRecognizeRequest(FInputFileName);
    if FRecognizeInfo.FStatus = rsErrorJsonParse then // Ошибка при парсинге ответа
    begin
      FRecognizeInfo.FStatus := rsErrorGetAPIKey;
      FRecognizeInfo.FMessage := 'Validity of Key Speech API, obtained from the server MSpeech, already ended.';
      Synchronize(RecognizeEvent);
    end
    else if FRecognizeInfo.FStatus = rsRecordingNotRecognized then // Запись не распознана
    begin
      Synchronize(RecognizeEvent);
    end
    else if FRecognizeInfo.FStatus = rsRecognizeDone then // Запись распознана
    begin
      Synchronize(RecognizeEvent);
    end;
  end
end;

function TGoogleRecognizer.SendRecognizeRequest(AudioFile: String): TRecognizeInfo;
var
  FResultListCnt: Integer;
  FURL, FResultStr, FReplaceStr: String;
  FResultStrV2: String;
  FJSON, FJo, FJoV2: TJSONobject;
  JArray: TJSONArray;
begin
  if RecognizeResult(GetFileSize(AudioFile) <= 0, rsFileSizeNull, 'File size ' + FInputFileName + ' ' + IntToStr(GetFileSize(AudioFile))) then
    Exit
  else
  begin
    FResultList.Clear;
    try
      FInputStream := TFileStream.Create(AudioFile, fmOpenRead or fmShareDenyWrite);
    except
      on e: Exception do
      begin
        raise RecognizeError.Create(SysErrorMessage(GetLastError));
        Terminate;
      end;
    end;
    try
      if GoogleRecognizePublicAPIKey = FGoogleAPIKey then
        FURL := Format(GoogleRecognizeURLv2Public, [FRecognizeLang, FGoogleAPIKey])
      else
        FURL := Format(GoogleRecognizeURLv2MSpeech, [FRecognizeLang, FGoogleAPIKey, ProgramsName+'-'+ProgramsVer]);
      if not HTTPPostFile(FURL, 'userfile', FInputFileName, FInputStream, FResultList) then
      begin
        Result.FStatus := rsErrorCommunication;
        Result.FTranscript := 'Failed to get a response from the Google ASR';
        Exit;
      end;
    finally
      FInputStream.Free;
    end;
    {if EnableLogs then
    begin
      WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': FResultList.Count = ' + IntToStr(FResultList.Count));
      WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': FResultList.Text = ' + UTF8ToString(FResultList.Text));
    end;}
    Result := ParseJSONv2(FResultList);
  end;
end;

function TGoogleRecognizer.GetFileSize(FileName: String): Integer;
var
  FS: TFileStream;
begin
  Result := 0;
  try
    FS := TFileStream.Create(Filename, fmOpenRead);
    Result := FS.Size;
  except
    Result := -1;
    FS.Free;
    Exit;
  end;
  FS.Free;
end;

function TGoogleRecognizer.HTTPPostFile(const URL, FieldName, FileName: String; const Data: TStream; const ResultData: TStrings): Boolean;
const
  CRLF = #$0D + #$0A;
var
  Bound, Str: String;
begin
  Result := False;
  Bound := IntToHex(Random(MaxInt), 8) + '_Synapse_boundary';
  try
    if FUseProxy then
    begin
      FHTTP.ProxyHost := FProxyAddress;
      if FProxyPort <> '' then
        FHTTP.ProxyPort := FProxyPort
      else
        FHTTP.ProxyPort := '3128';
      if FProxyAuth then
      begin
        FHTTP.ProxyUser := FProxyAuthUserName;
        FHTTP.ProxyPass := FProxyAuthPassword;
      end;
    end;
    Str := '--' + Bound + CRLF;
    Str := Str + 'content-disposition: form-data; name="' + FieldName + '";';
    Str := Str + ' filename="' + FileName + '"' + CRLF;
    if ExtractFileExt(FileName) = '.wav' then
      Str := Str + 'Content-Type: audio/l16; rate='+PCMInSampleRate+'' + CRLF + CRLF
    else
      Str := Str + 'Content-Type: audio/x-flac; rate='+FLACInSampleRate+'' + CRLF + CRLF;
    FHTTP.Timeout := HTTPTimeout;
    FHTTP.Sock.OnStatus := HTTPStatus;
    FHTTP.Document.Clear;
    FHTTP.Headers.Clear;
    FHTTP.Document.Write(Pointer(Str)^, Length(Str));
    FHTTP.Document.CopyFrom(Data, 0);
    Str := CRLF + '--' + Bound + '--' + CRLF;
    FHTTP.Document.Write(Pointer(Str)^, Length(Str));
    if ExtractFileExt(FileName) = '.wav' then
      FHTTP.MimeType := 'audio/l16; rate='+PCMInSampleRate
    else
      FHTTP.MimeType := 'audio/x-flac; rate='+FLACInSampleRate;
    FHTTP.UserAgent := 'Mozilla/5.0 (Windows NT 6.2; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/30.0.1599.17 Safari/537.36';
    Result := FHTTP.HTTPMethod('POST', URL);
    ResultData.LoadFromStream(FHTTP.Document);
  except
    on e: Exception do
    begin
      raise RecognizeError.Create(SysErrorMessage(GetLastError));
      Terminate;
    end;
  end;
end;

procedure TGoogleRecognizer.HTTPStatus(Sender: TObject; Reason: THookSocketReason; const Value: String);
var
  Status: String;
begin
  {$IFDEF DEBUG}
  if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': ' + GetEnumName(TypeInfo(THookSocketReason),ord(Reason))+': '+Value);
  {$ENDIF DEBUG}
  if (Terminated) and (not FTerminated) then
  begin
    FTerminated := True;
    if Sender is TTCPBlockSocket then
      TTCPBlockSocket(Sender).StopFlag := True;
    FRecognizeInfo.FStatus := rsAbort;
    FRecognizeInfo.FMessage := 'Requested stop sending data';
    FRecognizeInfo.FConfidence := 0;
    FRecognizeInfo.FTranscript := '';
    Synchronize(RecognizeEvent);
  end;
  if not FTerminated then
  begin
    if Value <> '' then
    begin
      case Reason of
        HR_ResolvingBegin: Status := 'Start resolving: ' + Value;
        HR_ResolvingEnd: Status := 'End resolving: ' + Value;
        HR_SocketCreate: Status := 'Socket created: ' + Value;
        HR_SocketClose: Status := 'Socket closed: ' + Value;
        HR_Bind: Status := 'Socket binded: ' + Value;
        HR_Connect: Status := 'Socket connected: ' + Value;
        HR_CanRead: Status := 'Read: ' + Value;
        HR_CanWrite: Status := 'Write: ' + Value;
        HR_Listen: Status := 'Listen: ' + Value;
        HR_Accept: Status := 'Accept: ' + Value;
        HR_ReadCount:
        begin
          // Считаем количество принятых байт, потом их выведем суммарно и отдельно
          // В это количество не входит размер заголовка и т.п.
          FReadCount := FReadCount+StrToInt(Value);
          Status := '';
        end;
        HR_WriteCount: Status := 'WriteCount: ' + Value;
        HR_Wait: Status := 'Wait: ' + Value;
        HR_Error:
        begin
          if RecognizeResult(Value = '10065,No route to host', rsErrorNoRouteToHost, Value) then
            Exit
          else if RecognizeResult(Value = '11001,Host not found', rsErrorHostNotFound, Value) then
            Exit
          else if RecognizeResult(Value = '10060,Connection timed out', rsErrorConnectionTimedOut, Value) then
            Exit
          else if Value = '10054,Connection reset by peer' then
            Exit
          else if RecognizeResult(Value = '11002,Non authoritative - host not found', rsErrorHostNotFound, Value) then
            Exit
          else if RecognizeResult(Value = '10013,Permission denied', rsErrorPermissionDenied, Value) then
            Exit
          else
          begin
            Status := 'Error: ' + Value;
            FRecognizeInfo.FStatus := rsErrorCommunication;
            FRecognizeInfo.FMessage := Status;
            FRecognizeInfo.FConfidence := 0;
            FRecognizeInfo.FTranscript := '';
            Synchronize(RecognizeEvent);
            Exit;
          end;
        end;
      end;
      if Status <> '' then
      begin
        FRecognizeInfo.FStatus := rsInfo;
        FRecognizeInfo.FMessage := Status;
        FRecognizeInfo.FConfidence := 0;
        FRecognizeInfo.FTranscript := '';
        Synchronize(RecognizeEvent);
      end;
    end;
  end;
end;

function TGoogleRecognizer.ParseJSONv2(JStringList: TStringList): TRecognizeInfo;
var
  JStringListCnt: Integer;
  FJSON, FJo, FJo2: TJSONobject;
  JArray, JArrayA: TJSONArray;
begin
  Result.FStatus := rsRecordingNotRecognized;
  Result.FMessage := '';
  Result.FConfidence := 0;
  Result.FTranscript := '';
  for JStringListCnt := 0 to JStringList.Count-1 do
  begin
    try
      if EnableLogs then WriteInLog(WorkPath, Format('%s: Parsing string = %s', [FormatDateTime('dd.mm.yy hh:mm:ss', Now), UTF8ToString(JStringList[JStringListCnt])]));
      FJSON := TJSONObject.Create(UTF8ToString(JStringList[JStringListCnt]));
    except
      on e: Exception do
      begin
        //raise JSONError.Create(SysErrorMessage(GetLastError));
        FJSON.Free;
        Result.FStatus := rsErrorJsonParse;
        Result.FMessage := e.Message;
        Exit;
      end;
    end;
    try
      if not FJSON.isNull('result_index') then
      begin
        try
          JArray := TJSONArray.create(FJSON.optString('result'));
        except
          on e: Exception do
          begin
            //raise JSONError.Create(SysErrorMessage(GetLastError));
            Result.FStatus := rsErrorJsonParse;
            Result.FMessage := e.Message;
            JArray.Free;
            FJSON.Free;
            Exit;
          end;
        end;
        try
          if EnableLogs then WriteInLog(WorkPath, Format('%s: Lenght of array [result] = %d', [FormatDateTime('dd.mm.yy hh:mm:ss', Now), JArray.length]));
          if FJSON.optInt('result_index') < JArray.length then
          begin
            if EnableLogs then WriteInLog(WorkPath, Format('%s: Array [result] = %s', [FormatDateTime('dd.mm.yy hh:mm:ss', Now), JArray.get(FJSON.optInt('result_index')).toString]));
            try
              FJo := TJSONObject.Create(JArray.get(FJSON.optInt('result_index')).toString);
            except
              on e: Exception do
              begin
                //raise JSONError.Create(SysErrorMessage(GetLastError));
                Result.FStatus := rsErrorJsonParse;
                Result.FMessage := e.Message;
                FJo.Free;
                JArray.Free;
                FJSON.Free;
                Exit;
              end;
            end;
            try
              if FJo.optString('final') = 'true' then
              begin
                {$IFDEF DEBUG}
                if EnableLogs then WriteInLog(WorkPath, Format('%s: String alternative = %s', [FormatDateTime('dd.mm.yy hh:mm:ss', Now), FJo.optString('alternative')]));
                {$ENDIF}
                try
                  JArrayA := TJSONArray.create(FJo.optString('alternative'));
                except
                  on e: Exception do
                  begin
                    //raise JSONError.Create(SysErrorMessage(GetLastError));
                    Result.FStatus := rsErrorJsonParse;
                    Result.FMessage := e.Message;
                    JArrayA.Free;
                    FJo.Free;
                    JArray.Free;
                    FJSON.Free;
                    Exit;
                  end;
                end;
                try
                  {$IFDEF DEBUG}
                  if EnableLogs then WriteInLog(WorkPath, Format('%s: Lenght of array [alternative] = %d', [FormatDateTime('dd.mm.yy hh:mm:ss', Now), JArrayA.length]));
                  {$ENDIF}
                  if JArrayA.length > 0 then
                  begin
                    if EnableLogs then WriteInLog(WorkPath, Format('%s: Array alternative[%d] = %s', [FormatDateTime('dd.mm.yy hh:mm:ss', Now), 0, JArrayA.get(0).toString]));
                    try
                      FJo2 := TJSONObject.Create(JArrayA.get(0).toString);
                    except
                      on e: Exception do
                      begin
                        //raise JsonError.Create(SysErrorMessage(GetLastError));
                        Result.FStatus := rsErrorJsonParse;
                        Result.FMessage := e.Message;
                        FJo2.Free;
                        JArrayA.Free;
                        FJo.Free;
                        JArray.Free;
                        FJSON.Free;
                        Exit;
                      end;
                    end;
                    try
                      Result.FStatus := rsRecognizeDone;
                      Result.FMessage := '';
                      if not FJo2.isNull('transcript') then
                      begin
                        Result.FTranscript := FJo2.optString('transcript');
                        if EnableLogs then WriteInLog(WorkPath, Format('%s: Array alternative[%d] transcript = %s', [FormatDateTime('dd.mm.yy hh:mm:ss', Now), 0, FJo2.optString('transcript')]));
                      end;
                      if not FJo2.isNull('confidence') then
                      begin
                        FormatSettings.DecimalSeparator := '.';
                        Result.FConfidence := FJo2.optDouble('confidence')*100;
                        if EnableLogs then WriteInLog(WorkPath, Format('%s: Array alternative[%d] confidence = %s', [FormatDateTime('dd.mm.yy hh:mm:ss', Now), 0, FJo2.optString('confidence')]));
                      end;
                    finally
                      FJo2.Free;
                    end;
                  end;
                finally
                  JArrayA.Free;
                end;
              end;
            finally
              FJo.Free;
            end;
          end;
        finally
          JArray.Free;
        end;
      end;
    finally
      FJSON.Free;
    end;
  end;
end;

function TGoogleRecognizer.HTTPGetSize(var HTTP: THTTPSend; URL: String): int64;
var
  I: Integer;
  Size: String;
  Ch: Char;
begin
  Result := -1;
  HTTP.Document.Clear;
  HTTP.Headers.Clear;
  HTTP.UserAgent := 'Mozilla/5.0 (Windows NT 6.2; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/30.0.1599.17 Safari/537.36';
  if HTTP.HTTPMethod('HEAD',URL) then
  begin
    for I := 0 to HTTP.Headers.Count - 1 do
    begin
      if Pos('content-length', lowercase(HTTP.Headers[I])) > 0 then
      begin
        Size := '';
        for Ch in HTTP.Headers[i]do
          if Ch in ['0'..'9'] then
            Size := Size + Ch;
        Result := StrToInt(Size) + Length(HTTP.Headers.Text);
        Break;
      end;
    end;
  end;
end;

function TGoogleRecognizer.HTTPGetSize(URL: String): int64;
const
  CRLF = #$0D + #$0A;
var
  Size: String;
  HTTP: THTTPSend;
begin
  Result := -1;
  HTTP := THTTPSend.Create;
  try
    if FUseProxy then
    begin
      HTTP.ProxyHost := FProxyAddress;
      if FProxyPort <> '' then
        HTTP.ProxyPort := FProxyPort
      else
        HTTP.ProxyPort := '3128';
      if FProxyAuth then
      begin
        HTTP.ProxyUser := FProxyAuthUserName;
        HTTP.ProxyPass := FProxyAuthPassword;
      end;
    end;
    HTTP.Document.Clear;
    HTTP.Headers.Clear;
    HTTP.MimeType := 'application/x-www-form-urlencoded';
    HTTP.UserAgent := 'Mozilla/5.0 (Windows NT 6.2; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/30.0.1599.17 Safari/537.36';
    if HTTP.HTTPMethod('HEAD', URL) then
    begin
      HeadersToList(HTTP.Headers);
      Size := HTTP.Headers.Values['Content-Length'];
      Result := StrToIntDef(Size, -1);
      if Result > -1 then
        Result := Result + Length(HTTP.Headers.Text);
    end;
  finally
    HTTP.Free;
  end;
end;

end.
