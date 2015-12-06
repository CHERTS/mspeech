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

unit SAPI;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, GlobalSAPI, SHFolder, Vcl.StdCtrls, MGSAPI,
  Vcl.ComCtrls;

type
  TMainForm = class(TForm)
    ButtonStart: TButton;
    EditText: TEdit;
    MGSAPI1: TMGSAPI;
    MemoLog: TMemo;
    CBVoices: TComboBox;
    LBSAPIInfo: TListBox;
    ButtonPauseResume: TButton;
    ButtonStop: TButton;
    TBVol: TTrackBar;
    LVol: TLabel;
    TBSpeed: TTrackBar;
    LSpeed: TLabel;
    LPos: TLabel;
    LPosition: TLabel;
    TBPitch: TTrackBar;
    LPitch: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure ButtonStartClick(Sender: TObject);
    procedure MGSAPI1Event(Sender: TObject; pInfo: TTTSResultInfo);
    procedure CBVoicesChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ButtonStopClick(Sender: TObject);
    procedure ButtonPauseResumeClick(Sender: TObject);
    procedure TBVolChange(Sender: TObject);
    procedure TBSpeedChange(Sender: TObject);
    procedure MGSAPI1Position(Sender: TObject; Position: Cardinal);
    procedure TBPitchChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Paused: Boolean;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.FormCreate(Sender: TObject);
begin
  Caption := ProgramsName + ' v' + ProgramsVer + ' ' + PlatformType;
  ProgramsPath := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName));
  WorkPath := IncludeTrailingPathDelimiter(IncludeTrailingPathDelimiter(GetSpecialFolderPath(CSIDL_LOCAL_APPDATA))+ProgramsFolder);
  // Проверяем файл конфигурации
  if not DirectoryExists(WorkPath) then
    CreateDir(WorkPath);
  // Читаем настройки
  LoadINI(WorkPath);
  // Голоса
  if not MGSAPI1.GetVoices(CBVoices.Items) then
  begin
    CBVoices.Items.Add('Not voices');
    CBVoices.ItemIndex := 0;
  end
  else
  begin
    CBVoices.ItemIndex := SAPIVoiceNum;
    CBVoicesChange(CBVoices);
  end;
  Paused := False;
  ButtonPauseResume.Enabled := False;
  ButtonStop.Enabled := False;
  TBVol.Position := SAPIVoiceVolume;
  TBSpeed.Position := SAPIVoiceSpeed;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  SaveINI(WorkPath);
end;

procedure TMainForm.MGSAPI1Event(Sender: TObject; pInfo: TTTSResultInfo);
begin
  if pInfo.FStatus = ttsSpeak then
  begin
    ButtonPauseResume.Enabled := True;
    ButtonStop.Enabled := True;
  end
  else if pInfo.FStatus = ttsStop then
  begin
    ButtonPauseResume.Enabled := False;
    ButtonStop.Enabled := False;
  end;
  MemoLog.Lines.Add(FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': FStatus: ' + IntToStr(Integer(pInfo.FStatus)) + ', FResult: ' + pInfo.FResult);
end;

procedure TMainForm.MGSAPI1Position(Sender: TObject; Position: Cardinal);
begin
  LPosition.Caption := IntToStr(Position);
end;

procedure TMainForm.CBVoicesChange(Sender: TObject);
var
  VInfo: TVoiceInfo;
begin
  SAPIVoiceNum := (Sender as TComboBox).ItemIndex;
  MGSAPI1.TTSLang := SAPIVoiceNum;
  VInfo := MGSAPI1.GetVoiceInfo(SAPIVoiceNum);
  with LBSAPIInfo.Items do
  begin
    Clear;
    Add(Format('Ключь в реестре: %s', [VInfo.VoiceId]));
    Add(Format('Имя: %s', [VInfo.VoiceName]));
    Add(Format('Создатель: %s', [VInfo.VoiceVendor]));
    Add(Format('Возраст: %s', [VInfo.VoiceAge]));
    Add(Format('Пол: %s', [VInfo.VoiceGender]));
    Add(Format('Язык: %s', [VInfo.VoiceLanguage]));
  end;
  TBVol.Position := MGSAPI1.TTSVoiceVolume;
  TBSpeed.Position := MGSAPI1.TTSVoiceSpeed;
  TBPitch.Position := MGSAPI1.TTSVoicePitch;
end;

procedure TMainForm.TBPitchChange(Sender: TObject);
begin
  SAPIVoicePitch := (Sender as TTrackBar).Position;
  MGSAPI1.TTSVoicePitch := SAPIVoicePitch;
end;

procedure TMainForm.TBSpeedChange(Sender: TObject);
begin
  SAPIVoiceSpeed := (Sender as TTrackBar).Position;
  MGSAPI1.TTSVoiceSpeed := SAPIVoiceSpeed;
end;

procedure TMainForm.TBVolChange(Sender: TObject);
begin
  SAPIVoiceVolume := (Sender as TTrackBar).Position;
  MGSAPI1.TTSVoiceVolume := SAPIVoiceVolume;
end;

procedure TMainForm.ButtonPauseResumeClick(Sender: TObject);
begin
  if Paused then
  begin
    (Sender as TButton).Caption := 'Пауза';
    Paused := False;
    MGSAPI1.Resume;
  end
  else
  begin
    (Sender as TButton).Caption := 'Продолжить';
    Paused := True;
    MGSAPI1.Pause;
  end;
end;

procedure TMainForm.ButtonStartClick(Sender: TObject);
begin
  MGSAPI1.TTSLang := SAPIVoiceNum;
  MGSAPI1.TTSVoiceVolume := SAPIVoiceVolume;
  MGSAPI1.TTSVoiceSpeed := SAPIVoiceSpeed;
  MGSAPI1.TTSVoicePitch := SAPIVoicePitch;
  MGSAPI1.Speak(EditText.Text);
end;

procedure TMainForm.ButtonStopClick(Sender: TObject);
begin
  MGSAPI1.Stop
end;

end.
