{ #################################################################################### }
{ #                                                                                  # }
{ #  MGSoft ISpeech TTS Demo v1.0.0 - Демонстрация синтез голоса через ISpeech TTS   # }
{ #                                                                                  # }
{ #  License: GPLv3                                                                  # }
{ #                                                                                  # }
{ #  MGSoft ISpeechTTS Demo                                                          # }
{ #                                                                                  # }
{ #  Author: Mikhail Grigorev (icq: 161867489, email: sleuthhound@gmail.com)         # }
{ #                                                                                  # }
{ #################################################################################### }

unit ISpeechTTS;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, GlobalISpeechTTS, SHFolder, Vcl.StdCtrls,
  MGISpeechTTS, Vcl.ExtCtrls;

type
  TMainForm = class(TForm)
    ButtonSay: TButton;
    EditText: TEdit;
    MemoLog: TMemo;
    CBVoices: TComboBox;
    MGISpeechTTS1: TMGISpeechTTS;
    EditAPIKey: TEdit;
    ButtonGetAPIKey: TButton;
    CBAudioFormat: TComboBox;
    LabelLang: TLabel;
    LabelAudioFormat: TLabel;
    CBFrequencies: TComboBox;
    LabelFrequencies: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure ButtonSayClick(Sender: TObject);
    procedure CBVoicesChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure MGISpeechTTS1Event(Sender: TObject; pInfo: TISpeechTTSResultInfo);
    procedure ButtonGetAPIKeyClick(Sender: TObject);
    procedure CBAudioFormatChange(Sender: TObject);
    procedure CBFrequenciesChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
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
  if not MGISpeechTTS1.GetVoices(CBVoices.Items, True) then
  begin
    CBVoices.Items.Add(ISpeechTTSLanguageList[ISpeechTTS_USEnglishFemale].LangDisplayName);
    CBVoices.ItemIndex := 0;
  end
  else
  begin
    CBVoices.ItemIndex := MGISpeechTTS1.ISpeechTTSLanguageNum(CBVoices.Items, ISpeechTL);;
    CBVoicesChange(CBVoices);
  end;
  // Аудио-формат
  if not MGISpeechTTS1.GetAudioFormats(CBAudioFormat.Items, True) then
  begin
    CBAudioFormat.Items.Add(ISpeechTTSAudioFormatList[ISpeechTTS_MP3].AudioFormatDisplayName);
    CBAudioFormat.ItemIndex := 0;
  end
  else
  begin
    CBAudioFormat.ItemIndex := MGISpeechTTS1.ISpeechTTSAudioFormatNum(CBAudioFormat.Items, ISpeechAF);;
    CBAudioFormatChange(CBAudioFormat);
  end;
  // Частота файла
  if not MGISpeechTTS1.GetFrequencies(CBFrequencies.Items, True) then
  begin
    CBFrequencies.Items.Add(ISpeechTTSFrequenceList[ISpeechTTS_16000].FrequenceName);
    CBFrequencies.ItemIndex := 0;
  end
  else
  begin
    CBFrequencies.ItemIndex := MGISpeechTTS1.ISpeechTTSFrequenceNum(CBFrequencies.Items, ISpeechFreq);;
    CBFrequenciesChange(CBFrequencies);
  end;
  // API Key
  EditAPIKey.Text := '';
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  SaveINI(WorkPath);
end;

procedure TMainForm.CBAudioFormatChange(Sender: TObject);
begin
  ISpeechAF := MGISpeechTTS1.ISpeechTTSAudioFormatNameToCode((Sender as TComboBox).Items[(Sender as TComboBox).ItemIndex]);
  MGISpeechTTS1.TTSAudioFormatCode := ISpeechAF;
end;

procedure TMainForm.CBFrequenciesChange(Sender: TObject);
begin
  ISpeechFreq := MGISpeechTTS1.ISpeechTTSFrequenceNameToCode((Sender as TComboBox).Items[(Sender as TComboBox).ItemIndex]);
  MGISpeechTTS1.TTSFrequenceValue := ISpeechFreq;
end;

procedure TMainForm.CBVoicesChange(Sender: TObject);
begin
  ISpeechTL := MGISpeechTTS1.ISpeechTTSLanguageNameToCode((Sender as TComboBox).Items[(Sender as TComboBox).ItemIndex]);
  MGISpeechTTS1.TTSLangCode := ISpeechTL;
  EditText.Text := MGISpeechTTS1.ISpeechTTSGetTestPhrase;
end;

procedure TMainForm.MGISpeechTTS1Event(Sender: TObject; pInfo: TISpeechTTSResultInfo);
begin
  if pInfo.FStatus = ttsDone then
    MemoLog.Lines.Add(FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': The result of speech synthesis is saved in file: ' + pInfo.FResult)
  else if pInfo.FStatus = ttsError then
    MemoLog.Lines.Add(FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': Error: ' + pInfo.FResult)
  else if pInfo.FStatus = ttsWarning then
    MemoLog.Lines.Add(FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': iSpeech service has reported an error: ' + pInfo.FResult)
  else if pInfo.FStatus = ttsInfo then
    MemoLog.Lines.Add(FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': Info: ' + pInfo.FResult)
end;

procedure TMainForm.ButtonGetAPIKeyClick(Sender: TObject);
begin
  MGISpeechTTS1.GetAPIKey;
end;

procedure TMainForm.ButtonSayClick(Sender: TObject);
begin
  MGISpeechTTS1.TTSLangCode := ISpeechTL;
  MGISpeechTTS1.OutFileName := ProgramsPath+'ISpeechTTS-'+ISpeechTTSLanguageList[TISpeechTTSLanguage(CBVoices.ItemIndex)].LangCode+'.'+ISpeechTTSAudioFormatList[TISpeechTTSAudioFormat(CBAudioFormat.ItemIndex)].AudioFormatCode;
  MGISpeechTTS1.HTTPTimeout := 3000;
  if EditAPIKey.Text <> '' then
    MGISpeechTTS1.APIKey := EditAPIKey.Text;
  if EditText.Text <> '' then
    MGISpeechTTS1.TTSString := EditText.Text
  else
    MGISpeechTTS1.TTSString := MGISpeechTTS1.ISpeechTTSGetTestPhrase;
  MGISpeechTTS1.SpeakText;
end;

end.
