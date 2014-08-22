{ ############################################################################ }
{ #                                                                          # }
{ #  MSpeech v1.5.5 - Распознавание речи используя Google Speech API         # }
{ #                                                                          # }
{ #  License: GPLv3                                                          # }
{ #                                                                          # }
{ #  Author: Mikhail Grigorev (icq: 161867489, email: sleuthhound@gmail.com) # }
{ #                                                                          # }
{ ############################################################################ }

unit Recognizer;

interface

uses Windows, Classes, SysUtils, Global, HTTPSend, synautil;

type
  //JSONError = class(Exception);
  // Структура с информацией о распознанной фразе (передается в callback процедуру)
  PRecognizeInfo = ^TRecognizeInfo;
  TRecognizeInfo = record
    FStatus     : Integer;   // Статус распознавания: 5- запись не распознана, 0 - запись распознана
    FConfidence : Real;      // Достоверность распознавания в %
    FTranscript : String;    // Распознанная фраза
  end;
  TRecognizeStatus = (rsResolving, rsConnect, rsSendRequest, rsResponseReceived, rsRecognizeDone, rsRecordingNotRecognized, rsRecognizeAbort);
  TRecognizeError = (reErrorGoogleCommunication, reErrorGoogleResponse, reFileSizeNull, reErrorHostNotFound, reErrorConnectionTimedOut);

  // callback процедура, вызываемая после распознавания
  TRecognizeResultEvent = procedure (Sender: TObject; pStatus: TRecognizeStatus; pInfo: TRecognizeInfo) of object;
  // callback процедура, вызываемая при появлении ошибок
  TRecognizeErrorEvent = procedure(Sender: TObject; E: TRecognizeError; EStr: String) of object;

  // Запуск распознавания
  procedure StartRecognize(pGoogleAPIKey, pFileName, pRecognizeLang: String; pUseProxy: Boolean; pProxyAddress, pProxyPort: String; pProxyAuth: Boolean; pProxyAuthUserName, pProxyAuthPassword: String; pRecognizeInfoCallBack: TRecognizeResultEvent; pRecognizeErrorCallBack: TRecognizeErrorEvent);
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
    FRecognizeErrorCallBack: TRecognizeErrorEvent;
    FRecognizeErr: TRecognizeError;
    FRecognizeErrStr: String;
    FRecognizeInfo: TRecognizeInfo;
    FRecognizeStatus: TRecognizeStatus;
    FTerminated: Boolean;
    FGoogleAPIKey: String;
    FHTTP: THTTPSend;
    procedure StatusEvent;
    procedure ErrorEvent;
    function GetFileSize(FileName: String): Integer;
    function HTTPPostFile(Const URL, FieldName, FileName: String; Const Data: TStream; Const ResultData: TStrings): Boolean;
    function ErrorResult(E: Boolean; eType: TRecognizeError; eText: String): Boolean;
    procedure HTTPStatus(Sender: TObject; Reason: THookSocketReason; const Value: String);
    function SendRecognizeRequest(AudioFile: String): TRecognizeInfo;
    function ParseJSONv2(JStringList: TStringList): TRecognizeInfo;
  protected
    procedure Execute; override;
  public
    constructor Create(pGoogleAPIKey, pFileName, pRecognizeLang: String; pUseProxy: Boolean; pProxyAddress, pProxyPort: String; pProxyAuth: Boolean; pProxyAuthUserName, pProxyAuthPassword: String; pRecognizeInfoCallBack: TRecognizeResultEvent; pRecognizeErrorCallBack: TRecognizeErrorEvent);
    destructor Destroy; override;
    property Terminated;
    procedure Terminate(NewPriority: TThreadPriority = tpIdle); reintroduce;
    property OnRecognize: TRecognizeResultEvent read FRecognizeInfoCallBack;
    property OnError: TRecognizeErrorEvent read FRecognizeErrorCallBack;
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

procedure StartRecognize(pGoogleAPIKey, pFileName, pRecognizeLang: String; pUseProxy: Boolean; pProxyAddress, pProxyPort: String; pProxyAuth: Boolean; pProxyAuthUserName, pProxyAuthPassword: String; pRecognizeInfoCallBack: TRecognizeResultEvent; pRecognizeErrorCallBack: TRecognizeErrorEvent);
begin
  GoogleRecognize := TGoogleRecognizer.Create(pGoogleAPIKey, pFileName, pRecognizeLang, pUseProxy, pProxyAddress, pProxyPort, pProxyAuth, pProxyAuthUserName, pProxyAuthPassword, pRecognizeInfoCallBack, pRecognizeErrorCallBack);
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

constructor TGoogleRecognizer.Create(pGoogleAPIKey, pFileName, pRecognizeLang: String; pUseProxy: Boolean; pProxyAddress, pProxyPort: String; pProxyAuth: Boolean; pProxyAuthUserName, pProxyAuthPassword: String; pRecognizeInfoCallBack: TRecognizeResultEvent; pRecognizeErrorCallBack: TRecognizeErrorEvent);
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
  FRecognizeErrorCallBack := pRecognizeErrorCallBack;
  FRecognizeInfoCallBack := pRecognizeInfoCallBack;
  FResultList := TStringList.Create;
  FHTTP := THTTPSend.Create;
  FRecognizeInfo.FStatus := 5;
  FRecognizeInfo.FConfidence := 0;
  FRecognizeInfo.FTranscript := '';
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
    if FRecognizeInfo.FStatus = 1 then // Ошибка при парсинге ответа
    begin
      FRecognizeErr := reErrorGoogleResponse;
      FRecognizeErrStr := FResultList.Text;
      Synchronize(ErrorEvent);
    end
    else if FRecognizeInfo.FStatus = 5 then // Запись не распознана
    begin
      FRecognizeStatus := rsRecordingNotRecognized;
      Synchronize(StatusEvent);
    end
    else if FRecognizeInfo.FStatus = 0 then // Запись распознана
    begin
      FRecognizeStatus := rsRecognizeDone;
      Synchronize(StatusEvent);
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
  if ErrorResult(GetFileSize(AudioFile) <= 0, reFileSizeNull, 'File size ' + FInputFileName + ' ' + IntToStr(GetFileSize(AudioFile))) then
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
        Result.FStatus := 1;
        Result.FTranscript := 'Error in procedure HTTPPostFile';
        Exit;
      end;
    finally
      FInputStream.Free;
    end;
    if EnableLogs then
    begin
      WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': FResultList.Count = ' + IntToStr(FResultList.Count));
      WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': FResultList.Text = ' + UTF8ToString(FResultList.Text));
    end;
    Result := ParseJSONv2(FResultList);
  end;
end;

procedure TGoogleRecognizer.StatusEvent;
begin
  if Assigned(FRecognizeInfoCallBack) then
    FRecognizeInfoCallBack(Self, FRecognizeStatus, FRecognizeInfo);
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
begin
  {$IFDEF DEBUG}
  if EnableLogs then WriteInLog(WorkPath, FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': ' + GetEnumName(TypeInfo(THookSocketReason),ord(Reason))+': '+Value);
  {$ENDIF DEBUG}
  if (Terminated) and (not FTerminated) then
  begin
    FTerminated := True;
    if Sender is TTCPBlockSocket then
      TTCPBlockSocket(Sender).StopFlag := True;
    FRecognizeStatus := rsRecognizeAbort;
    Synchronize(StatusEvent);
  end;
  if not FTerminated then
  begin
    if Reason = HR_ResolvingBegin then
    begin
      FRecognizeStatus := rsResolving;
      Synchronize(StatusEvent);
    end;
    if Reason = HR_Connect then
    begin
      FRecognizeStatus := rsConnect;
      Synchronize(StatusEvent);
    end;
    if Reason = HR_WriteCount then
    begin
      FRecognizeStatus := rsSendRequest;
      Synchronize(StatusEvent);
    end;
    if Reason = HR_ReadCount then
    begin
      FRecognizeStatus := rsResponseReceived;
      Synchronize(StatusEvent);
    end;
    if Reason = HR_Error then
    begin
      if ErrorResult(Value = '11001,Host not found', reErrorHostNotFound, Value) then
        Exit
      else if ErrorResult(Value = '10060,Connection timed out', reErrorConnectionTimedOut, Value) then
        Exit
      else if Value = '10054,Connection reset by peer' then
        Exit
      else if ErrorResult(Value = '11002,Non authoritative - host not found', reErrorHostNotFound, Value) then
        Exit
      else
      begin
        FRecognizeErr := reErrorGoogleCommunication;
        FRecognizeErrStr := Value;
        Synchronize(ErrorEvent);
        Exit;
      end;
    end;
  end;
end;

function TGoogleRecognizer.ErrorResult(E: Boolean; eType: TRecognizeError; eText: String): Boolean;
begin
  Result := E;
  if E then
  begin
    FRecognizeErr := eType;
    FRecognizeErrStr := eText;
    ErrorEvent;
  end;
end;

procedure TGoogleRecognizer.ErrorEvent;
begin
  if Assigned(FRecognizeErrorCallBack) then
    OnError(Self, FRecognizeErr, FRecognizeErrStr);
end;

function TGoogleRecognizer.ParseJSONv2(JStringList: TStringList): TRecognizeInfo;
var
  JStringListCnt: Integer;
  FJSON, FJo, FJo2: TJSONobject;
  JArray, JArrayA: TJSONArray;
begin
  Result.FStatus := 5;
  Result.FConfidence := 0;
  Result.FTranscript := '';
  for JStringListCnt := 0 to JStringList.Count-1 do
  begin
    try
      if EnableLogs then WriteInLog(WorkPath, Format('%s: Cтрока для парсинга = %s', [FormatDateTime('dd.mm.yy hh:mm:ss', Now), UTF8ToString(JStringList[JStringListCnt])]));
      FJSON := TJSONObject.Create(UTF8ToString(JStringList[JStringListCnt]));
    except
      on e: Exception do
      begin
        //raise JSONError.Create(SysErrorMessage(GetLastError));
        FJSON.Free;
        Result.FStatus := 1;
        Result.FTranscript := e.Message;
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
            Result.FStatus := 1;
            Result.FTranscript := e.Message;
            JArray.Free;
            FJSON.Free;
            Exit;
          end;
        end;
        try
          if EnableLogs then WriteInLog(WorkPath, Format('%s: Размер массива result = %d', [FormatDateTime('dd.mm.yy hh:mm:ss', Now), JArray.length]));
          if FJSON.optInt('result_index') < JArray.length then
          begin
            if EnableLogs then WriteInLog(WorkPath, Format('%s: Массив result = %s', [FormatDateTime('dd.mm.yy hh:mm:ss', Now), JArray.get(FJSON.optInt('result_index')).toString]));
            try
              FJo := TJSONObject.Create(JArray.get(FJSON.optInt('result_index')).toString);
            except
              on e: Exception do
              begin
                //raise JSONError.Create(SysErrorMessage(GetLastError));
                Result.FStatus := 1;
                Result.FTranscript := e.Message;
                FJo.Free;
                JArray.Free;
                FJSON.Free;
                Exit;
              end;
            end;
            try
              if FJo.optString('final') = 'true' then
              begin
                if EnableLogs then WriteInLog(WorkPath, Format('%s: Cтрока alternative = %s', [FormatDateTime('dd.mm.yy hh:mm:ss', Now), FJo.optString('alternative')]));
                try
                  JArrayA := TJSONArray.create(FJo.optString('alternative'));
                except
                  on e: Exception do
                  begin
                    //raise JSONError.Create(SysErrorMessage(GetLastError));
                    Result.FStatus := 1;
                    Result.FTranscript := e.Message;
                    JArrayA.Free;
                    FJo.Free;
                    JArray.Free;
                    FJSON.Free;
                    Exit;
                  end;
                end;
                try
                  if EnableLogs then WriteInLog(WorkPath, Format('%s: Размер массива alternative = %d', [FormatDateTime('dd.mm.yy hh:mm:ss', Now), JArrayA.length]));
                  if JArrayA.length > 0 then
                  begin
                    if EnableLogs then WriteInLog(WorkPath, Format('%s: Массив alternative[%d] = %s', [FormatDateTime('dd.mm.yy hh:mm:ss', Now), 0, JArrayA.get(0).toString]));
                    try
                      FJo2 := TJSONObject.Create(JArrayA.get(0).toString);
                    except
                      on e: Exception do
                      begin
                        //raise JsonError.Create(SysErrorMessage(GetLastError));
                        Result.FStatus := 1;
                        Result.FTranscript := e.Message;
                        FJo2.Free;
                        JArrayA.Free;
                        FJo.Free;
                        JArray.Free;
                        FJSON.Free;
                        Exit;
                      end;
                    end;
                    try
                      Result.FStatus := 0;
                      if not FJo2.isNull('transcript') then
                      begin
                        Result.FTranscript := FJo2.optString('transcript');
                        if EnableLogs then WriteInLog(WorkPath, Format('%s: Массив alternative[%d] transcript = %s', [FormatDateTime('dd.mm.yy hh:mm:ss', Now), 0, FJo2.optString('transcript')]));
                      end;
                      if not FJo2.isNull('confidence') then
                      begin
                        FormatSettings.DecimalSeparator := '.';
                        Result.FConfidence := FJo2.optDouble('confidence')*100;
                        if EnableLogs then WriteInLog(WorkPath, Format('%s: Массив alternative[%d] confidence = %s', [FormatDateTime('dd.mm.yy hh:mm:ss', Now), 0, FJo2.optString('confidence')]));
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

end.
