{ ################################################################################################### }
{ #                                                                                                 # }
{ #  MGSoft TessOCR Demo v1.0.0 - Демонстрация распознавания текста с использованием TesseractOCR   # }
{ #                                                                                                 # }
{ #  License: GPLv3                                                                                 # }
{ #                                                                                                 # }
{ #  MGSoft TessOCR Demo                                                                            # }
{ #                                                                                                 # }
{ #  Author: Mikhail Grigorev (icq: 161867489, email: sleuthhound@gmail.com)                        # }
{ #                                                                                                 # }
{ ################################################################################################### }

unit TessOCR;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, ExtDlgs, XPMan, MGTessOCR, Jpeg;

type
  TMainForm = class(TForm)
    OpenPictureDialog: TOpenPictureDialog;
    XPManifest: TXPManifest;
    PanelLeft: TPanel;
    Panel: TPanel;
    Image: TImage;
    ButtonSelectPicture: TButton;
    PanelRight: TPanel;
    Splitter: TSplitter;
    ButtonCancel: TButton;
    ProgressBar: TProgressBar;
    PageControl: TPageControl;
    TabSheetText: TTabSheet;
    MemoText: TMemo;
    ButtonRecognize: TButton;
    CBLanguage: TComboBox;
    LWordCount: TLabel;
    MGTessOCR: TMGTessOCR;
    procedure ButtonSelectPictureClick(Sender: TObject);
    procedure ButtonRecognizeClick(Sender: TObject);
    procedure ButtonCancelClick(Sender: TObject);
    procedure OcrProgress(Sender: TObject; var Cancel: Boolean; Progress, WordCount: Integer);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    CancelRequest: Boolean;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.FormCreate(Sender: TObject);
begin
  if MGTessOCR.GetLanguagesInFolder(CBLanguage.Items, IncludeTrailingBackSlash(ExtractFilePath(Application.ExeName))+'tessdata', True) = False then
    CBLanguage.Items.Add(OCRLanguageList[OCR_English].LangCode);
  CBLanguage.ItemIndex := CBLanguage.Items.IndexOf(OCRLanguageList[OCR_English].LangDisplayName);
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  MemoText.Lines.Add('Tesseract OCR v' + MGTessOCR.TessVersion + #13#10 + MGTessOCR.LeptVersion  + #13#10 + MGTessOCR.ImageVersions);
end;

procedure TMainForm.ButtonSelectPictureClick(Sender: TObject);
begin
  with OpenPictureDialog do
    if Execute then
    begin
      ProgressBar.Position := 0;
      MemoText.Clear;
      try
        Image.Picture.LoadFromFile(FileName);
      except
        Image.Picture := nil;
        ShowMessage('Preview of this image cannot be diplayed. Click Recognize button to start OCR.');
      end;
      if MGTessOCR.Active then
        MGTessOCR.Active := False;
      MGTessOCR.PictureFileName := FileName;
      if not MGTessOCR.Active then
      begin
        MGTessOCR.LanguageCode := MGTessOCR.LanguageNameToCode(CBLanguage.Text);
        MGTessOCR.DataPath := IncludeTrailingBackSlash(ExtractFilePath(Application.ExeName));
        MGTessOCR.Active := True;
      end;
      ButtonRecognize.Enabled := True;
    end
end;

procedure TMainForm.ButtonRecognizeClick(Sender: TObject);
begin
  try
    ProgressBar.Position := 0;
    CancelRequest := False;
    ButtonSelectPicture.Enabled := False;
    ButtonCancel.Visible := True;
    CBLanguage.Enabled := False;
    MemoText.Clear;
    Repaint;
    if not CancelRequest then
      MemoText.Text := StringReplace(MGTessOCR.Text, #$a, #$d#$a, [rfReplaceAll]);
    if not CancelRequest then
      ProgressBar.Position := 100
    else
      ProgressBar.Position := 0;
  finally
    ButtonCancel.Visible := False;
    ButtonSelectPicture.Enabled := True;
    CBLanguage.Enabled := True;
  end;
end;

procedure TMainForm.ButtonCancelClick(Sender: TObject);
begin
  CancelRequest := True;
end;

procedure TMainForm.OcrProgress(Sender: TObject; var Cancel: Boolean;
  Progress, WordCount: Integer);
begin
  ProgressBar.Position := Progress;
  LWordCount.Caption := IntToStr(WordCount);
  Application.ProcessMessages;
  Cancel := CancelRequest;
end;

end.
