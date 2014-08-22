{ ############################################################################ }
{ #                                                                          # }
{ #  MSpeech v1.4 - Распознавание речи используя Google Speech API           # }
{ #                                                                          # }
{ #  License: GPLv3                                                          # }
{ #                                                                          # }
{ #  Author: Mikhail Grigorev (icq: 161867489, email: sleuthhound@gmail.com) # }
{ #                                                                          # }
{ ############################################################################ }

unit About;

interface

{$I MSpeech.inc}

uses Windows, Messages, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, ShellAPI, Global
  {$ifdef LICENSE}, License{$endif LICENSE};

type
  TAboutForm = class(TForm)
    Image1: TImage;
    Bevel1: TBevel;
    LProgramName: TLabel;
    Label2: TLabel;
    LabelAuthor: TLabel;
    LVersion: TLabel;
    LLicense: TLabel;
    Label6: TLabel;
    LabelWebSite: TLabel;
    LVersionNum: TLabel;
    LLicenseType: TLabel;
    CloseButton: TButton;
    procedure FormCreate(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
    procedure LabelAuthorClick(Sender: TObject);
    procedure LabelWebSiteClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    // Для мультиязыковой поддержки
    procedure OnLanguageChanged(var Msg: TMessage); message WM_LANGUAGECHANGED;
    procedure LoadLanguageStrings;
  public
    { Public declarations }
  end;

var
  AboutForm: TAboutForm;

implementation

{$R *.dfm}
{$R About.res}

procedure TAboutForm.CloseButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TAboutForm.FormCreate(Sender: TObject);
var
  AboutBitmap: TBitmap;
begin
  // Для мультиязыковой поддержки
  AboutFormHandle := Handle;
  SetWindowLong(Handle, GWL_HWNDPARENT, 0);
  SetWindowLong(Handle, GWL_EXSTYLE, GetWindowLong(Handle, GWL_EXSTYLE) or WS_EX_APPWINDOW);
  // Грузим битовый образы из файла ресурсов
  AboutBitmap := TBitmap.Create;
  AboutBitmap.LoadFromResourceName(HInstance, 'About');
  Image1.Picture.Assign(AboutBitmap);
  AboutBitmap.Free;
  LabelAuthor.Cursor := crHandPoint;
  LabelWebSite.Cursor := crHandPoint;
  // Загружаем язык интерфейса
  LoadLanguageStrings;
  // Указываем версию в окне "О плагине"
  LVersionNum.Caption := GetMyExeVersion() + ' ' + PlatformType;
  {$ifdef LICENSE}
  if CheckLicense(ExtractFilePath(Application.ExeName), True) then
    LLicenseType.Caption := '#' + ReadLicenseInfo(ExtractFilePath(Application.ExeName), mLicNumber) + ', ' + ReadLicenseInfo(ExtractFilePath(Application.ExeName), mLicName) + ', ' + ReadLicenseInfo(ExtractFilePath(Application.ExeName), mLicDate);
  {$endif LICENSE}
end;

procedure TAboutForm.FormShow(Sender: TObject);
begin
  // Прозрачность окна
  AlphaBlend := AlphaBlendEnable;
  AlphaBlendValue := AlphaBlendEnableValue;
end;

procedure TAboutForm.LabelAuthorClick(Sender: TObject);
begin
  ShellExecute(0, 'open', 'mailto:sleuthhound@gmail.com?Subject=MSpeech', nil, nil, SW_RESTORE);
end;

procedure TAboutForm.LabelWebSiteClick(Sender: TObject);
begin
  ShellExecute(0, 'open', 'http://www.im-history.ru', nil, nil, SW_RESTORE);
end;

{ Смена языка интерфейса по событию WM_LANGUAGECHANGED }
procedure TAboutForm.OnLanguageChanged(var Msg: TMessage);
begin
  LoadLanguageStrings;
end;

{ Для мультиязыковой поддержки }
procedure TAboutForm.LoadLanguageStrings;
begin
  Caption := GetLangStr('AboutFormCaption');
  LProgramName.Caption := ProgramsName;
  CloseButton.Caption := GetLangStr('CloseButton');
  LVersion.Caption := GetLangStr('Version');
  LLicense.Caption := GetLangStr('License');
  // Позиционируем лейблы
  LVersionNum.Left := LVersion.Left + 1 + LVersion.Width;
  LLicenseType.Left := LLicense.Left + 1 + LLicense.Width;
end;

end.
 
