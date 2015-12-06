{ ################################################################################## }
{ #                                                                                # }
{ #  MGSoft Google TTS Demo v1.0.0 - Демонстрация синтез голоса через Google TTS   # }
{ #                                                                                # }
{ #  License: GPLv3                                                                # }
{ #                                                                                # }
{ #  MGSoft Google TTS Demo                                                        # }
{ #                                                                                # }
{ #  Author: Mikhail Grigorev (icq: 161867489, email: sleuthhound@gmail.com)       # }
{ #                                                                                # }
{ ################################################################################## }

unit GTTS;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, GlobalGTTS, SHFolder, Vcl.StdCtrls,
  MGGoogleTTS;

type
  TMainForm = class(TForm)
    ButtonSay: TButton;
    EditText: TEdit;
    MemoLog: TMemo;
    CBVoices: TComboBox;
    MGGoogleTTS1: TMGGoogleTTS;
    procedure FormCreate(Sender: TObject);
    procedure ButtonSayClick(Sender: TObject);
    procedure CBVoicesChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure MGGoogleTTS1Event(Sender: TObject; pInfo: TGTTSResultInfo);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.CBVoicesChange(Sender: TObject);
begin
  GoogleTL := MGGoogleTTS1.GTTSLanguageNameToCode((Sender as TComboBox).Items[(Sender as TComboBox).ItemIndex]);
  MGGoogleTTS1.TTSLangCode := GoogleTL;
  EditText.Text := MGGoogleTTS1.GTTSGetTestPhrase();
end;

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
  if not MGGoogleTTS1.GetVoices(CBVoices.Items, True) then
  begin
    CBVoices.ItemIndex := -1;
    CBVoices.Enabled := False;
  end
  else
  begin
    CBVoices.ItemIndex := MGGoogleTTS1.GTTSLanguageNum(CBVoices.Items, GoogleTL);;
    CBVoicesChange(CBVoices);
  end;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  SaveINI(WorkPath);
end;

procedure TMainForm.MGGoogleTTS1Event(Sender: TObject; pInfo: TGTTSResultInfo);
begin
  if pInfo.FStatus = ttsDone then
    MemoLog.Lines.Add(FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': The result of speech synthesis is saved in file: ' + pInfo.FResult)
  else if pInfo.FStatus = ttsError then
    MemoLog.Lines.Add(FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': Error: ' + pInfo.FResult)
  else if pInfo.FStatus = ttsInfo then
    MemoLog.Lines.Add(FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': Info: ' + pInfo.FResult)
end;

procedure TMainForm.ButtonSayClick(Sender: TObject);
begin
  MGGoogleTTS1.TTSLangCode := GoogleTL;
  MGGoogleTTS1.OutFileName := ProgramsPath+'GoogleTTS-'+MGGoogleTTS1.TTSLangCode+'.mp3';
  MGGoogleTTS1.HTTPTimeout := 3000;
  if EditText.Text <> '' then
    MGGoogleTTS1.TTSString := EditText.Text
  else
    MGGoogleTTS1.TTSString := MGGoogleTTS1.GTTSGetTestPhrase();
  MGGoogleTTS1.SpeakText;
end;

end.
