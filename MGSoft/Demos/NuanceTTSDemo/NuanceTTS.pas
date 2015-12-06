{ #################################################################################### }
{ #                                                                                  # }
{ #  MGSoft Nuance TTS Demo v1.0.0 - Демонстрация синтез голоса через Nuance TTS   # }
{ #                                                                                  # }
{ #  License: GPLv3                                                                  # }
{ #                                                                                  # }
{ #  MGSoft NuanceTTS Demo                                                          # }
{ #                                                                                  # }
{ #  Author: Mikhail Grigorev (icq: 161867489, email: sleuthhound@gmail.com)         # }
{ #                                                                                  # }
{ #################################################################################### }

unit NuanceTTS;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, GlobalNuanceTTS, SHFolder, Vcl.StdCtrls,
  Vcl.ExtCtrls, MGNuanceTTS;

type
  TMainForm = class(TForm)
    ButtonSay: TButton;
    EditText: TEdit;
    MemoLog: TMemo;
    CBVoices: TComboBox;
    EditAPIKey: TEdit;
    ButtonGetAPIKey: TButton;
    CBAudioFormat: TComboBox;
    LabelLang: TLabel;
    LabelAudioFormat: TLabel;
    CBFrequencies: TComboBox;
    LabelFrequencies: TLabel;
    MGNuanceTTS1: TMGNuanceTTS;
    EditAPPID: TEdit;
    EditID: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure ButtonSayClick(Sender: TObject);
    procedure CBVoicesChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure MGNuanceTTS1Event(Sender: TObject; pInfo: TNuanceTTSResultInfo);
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
  if not MGNuanceTTS1.GetVoices(CBVoices.Items, True) then
  begin
    CBVoices.Items.Add(NuanceTTSLanguageList[NuanceTTS_EnglishUSAvaFemale].LangDisplayName);
    CBVoices.ItemIndex := 0;
  end
  else
  begin
    CBVoices.ItemIndex := MGNuanceTTS1.NuanceTTSLanguageNum(CBVoices.Items, NuanceTL);;
    CBVoicesChange(CBVoices);
  end;
  // Аудио-формат
  if not MGNuanceTTS1.GetAudioFormats(CBAudioFormat.Items, True) then
  begin
    CBAudioFormat.Items.Add(NuanceTTSAudioFormatList[NuanceTTS_WAV].AudioFormatDisplayName);
    CBAudioFormat.ItemIndex := 0;
  end
  else
  begin
    CBAudioFormat.ItemIndex := MGNuanceTTS1.NuanceTTSAudioFormatNum(CBAudioFormat.Items, NuanceAF);;
    CBAudioFormatChange(CBAudioFormat);
  end;
  // Частота файла
  CBFrequencies.Items.Clear;
  if not MGNuanceTTS1.GetFrequencies(CBFrequencies.Items, True) then
  begin
    CBFrequencies.Items.Add(NuanceTTSFrequenceList[NuanceTTS_8000].FrequenceName);
    CBFrequencies.ItemIndex := 0;
  end
  else
  begin
    CBFrequencies.ItemIndex := MGNuanceTTS1.NuanceTTSFrequenceNum(CBFrequencies.Items, NuanceFreq);;
    CBFrequenciesChange(CBFrequencies);
  end;
  // API Key
  EditID.Text := '000';
  EditAPPID.Text := '';
  EditAPIKey.Text := '';
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  SaveINI(WorkPath);
end;

procedure TMainForm.CBAudioFormatChange(Sender: TObject);
begin
  NuanceAF := MGNuanceTTS1.NuanceTTSAudioFormatNameToCode((Sender as TComboBox).Items[(Sender as TComboBox).ItemIndex]);
  MGNuanceTTS1.TTSAudioFormatCode := NuanceAF;
  // Частота файла
  CBFrequencies.Items.Clear;
  if not MGNuanceTTS1.GetFrequencies(CBFrequencies.Items, True) then
  begin
    CBFrequencies.Items.Add(NuanceTTSFrequenceList[NuanceTTS_8000].FrequenceName);
    CBFrequencies.ItemIndex := 0;
  end
  else
  begin
    CBFrequencies.ItemIndex := MGNuanceTTS1.NuanceTTSFrequenceNum(CBFrequencies.Items, NuanceFreq);;
    CBFrequenciesChange(CBFrequencies);
  end;
end;

procedure TMainForm.CBFrequenciesChange(Sender: TObject);
begin
  NuanceFreq := MGNuanceTTS1.NuanceTTSFrequenceNameToCode((Sender as TComboBox).Items[(Sender as TComboBox).ItemIndex]);
  MGNuanceTTS1.TTSFrequenceValue := NuanceFreq;
end;

procedure TMainForm.CBVoicesChange(Sender: TObject);
begin
  NuanceTL := MGNuanceTTS1.NuanceTTSLanguageNameToCode((Sender as TComboBox).Items[(Sender as TComboBox).ItemIndex]);
  MGNuanceTTS1.TTSVoice := NuanceTL;
  EditText.Text := MGNuanceTTS1.NuanceTTSGetTestPhrase;
end;

procedure TMainForm.MGNuanceTTS1Event(Sender: TObject; pInfo: TNuanceTTSResultInfo);
begin
  if pInfo.FStatus = ttsDone then
    MemoLog.Lines.Add(FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': The result of speech synthesis is saved in file: ' + pInfo.FResult)
  else if pInfo.FStatus = ttsError then
    MemoLog.Lines.Add(FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': Error: ' + pInfo.FResult)
  else if pInfo.FStatus = ttsWarning then
    MemoLog.Lines.Add(FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': Nuance service has reported an error: ' + pInfo.FResult)
  else if pInfo.FStatus = ttsInfo then
    MemoLog.Lines.Add(FormatDateTime('dd.mm.yy hh:mm:ss', Now) + ': Info: ' + pInfo.FResult)
end;

procedure TMainForm.ButtonGetAPIKeyClick(Sender: TObject);
begin
  MGNuanceTTS1.GetAPIKey;
end;

procedure TMainForm.ButtonSayClick(Sender: TObject);
begin
  MGNuanceTTS1.ID := EditID.Text;
  MGNuanceTTS1.APPID := EditAPPID.Text;
  MGNuanceTTS1.TTSVoice := NuanceTL;
  MGNuanceTTS1.OutFileName := ProgramsPath+'NuanceTTS-'+NuanceTTSLanguageList[TNuanceTTSLanguage(CBVoices.ItemIndex)].LangCode+'-'+MGNuanceTTS1.TTSVoice+'.'+NuanceTTSAudioFormatList[TNuanceTTSAudioFormat(CBAudioFormat.ItemIndex)].AudioFormatCodeExt;
  MGNuanceTTS1.HTTPTimeout := 3000;
  if EditAPIKey.Text <> '' then
    MGNuanceTTS1.APIKey := EditAPIKey.Text;
  if EditText.Text <> '' then
    MGNuanceTTS1.TTSString := EditText.Text
  else
    MGNuanceTTS1.TTSString := MGNuanceTTS1.NuanceTTSGetTestPhrase;
  MGNuanceTTS1.SpeakText;
end;

end.
