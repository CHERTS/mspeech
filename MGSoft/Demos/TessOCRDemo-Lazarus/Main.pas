unit Main;

interface

uses
{$IFNDEF FPC}
  Jpeg, Windows,
{$ELSE}
  LCLIntf, LCLType,
{$ENDIF}
  SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, ExtDlgs, TessOCR;

type
  TMainForm = class(TForm)
    OpenPictureDialog: TOpenPictureDialog;
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
    TessOCR: TTessOCR;
    procedure ButtonSelectPictureClick(Sender: TObject);
    procedure ButtonRecognizeClick(Sender: TObject);
    procedure ButtonCancelClick(Sender: TObject);
    procedure OcrProgress(Sender: TObject; var Cancel: Boolean; Progress, WordCount: Integer);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    CancelRequest: Boolean;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

procedure TMainForm.FormShow(Sender: TObject);
begin
  if TessOCR.GetLanguagesInFolder(CBLanguage.Items, IncludeTrailingBackSlash(ExtractFilePath(Application.ExeName))+'tessdata', True) = False then
    CBLanguage.Items.Add(OCRLanguageList[OCR_English].LangCode);
  CBLanguage.ItemIndex := CBLanguage.Items.IndexOf(OCRLanguageList[OCR_English].LangDisplayName);
  MemoText.Lines.Add('Tesseract OCR v' + TessOCR.TessVersion + #13#10 + TessOCR.LeptVersion  + #13#10 + TessOCR.ImageVersions);
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
      if TessOCR.Active then
        TessOCR.Active := False;
      TessOCR.PictureFileName := FileName;
      if not TessOCR.Active then
      begin
        TessOCR.LanguageCode := TessOCR.LanguageNameToCode(CBLanguage.Text);
        TessOCR.DataPath := IncludeTrailingBackSlash(ExtractFilePath(Application.ExeName));
        TessOCR.Active := True;
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
      MemoText.Text := StringReplace(TessOCR.Text, #$a, #$d#$a, [rfReplaceAll]);
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
