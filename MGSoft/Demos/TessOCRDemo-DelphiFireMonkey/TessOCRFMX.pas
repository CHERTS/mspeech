unit TessOCRFMX;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Memo, MGTessOCR, Vcl.XPMan, FMX.ListBox, FMX.Objects,
  FMX.TabControl;

type
  TMainForm = class(TForm)
    PanelLeft: TPanel;
    Panel: TPanel;
    PanelRight: TPanel;
    Splitter: TSplitter;
    ButtonCancel: TButton;
    ProgressBar: TProgressBar;
    ButtonRecognize: TButton;
    MGTessOCR: TMGTessOCR;
    LWordCount: TLabel;
    CBLanguage: TComboBox;
    OpenPictureDialog: TOpenDialog;
    Image: TImage;
    ButtonSelectPicture: TButton;
    TabControl: TTabControl;
    TabSheetText: TTabItem;
    MemoText: TMemo;
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

{$R *.fmx}

procedure TMainForm.FormCreate(Sender: TObject);
begin
  if MGTessOCR.GetLanguagesInFolder(CBLanguage.Items, IncludeTrailingBackSlash(ExtractFilePath(ParamStr(0)))+'tessdata', True) = False then
    CBLanguage.Items.Add(OCRLanguageList[OCR_English].LangCode);
  CBLanguage.ItemIndex := CBLanguage.Items.IndexOf(OCRLanguageList[OCR_English].LangDisplayName);
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  OpenPictureDialog.InitialDir := IncludeTrailingBackSlash(ExtractFilePath(ParamStr(0)));
  MemoText.Lines.Add('Tesseract OCR v' + MGTessOCR.TessVersion + #13#10 + MGTessOCR.LeptVersion  + #13#10 + MGTessOCR.ImageVersions);
end;

procedure TMainForm.ButtonSelectPictureClick(Sender: TObject);
begin
  with OpenPictureDialog do
    if Execute then
    begin
      ProgressBar.Value := 0;
      MemoText.Lines.Clear;
      try
        //Image.Picture.LoadFromFile(FileName);
        Image.Bitmap.LoadFromFile(FileName);
      except
        //Image.Picture := nil;
        Image.Bitmap := nil;
        ShowMessage('Preview of this image cannot be diplayed. Click Recognize button to start OCR.');
      end;
      if MGTessOCR.Active then
        MGTessOCR.Active := False;
      MGTessOCR.PictureFileName := FileName;
      if not MGTessOCR.Active then
      begin
        MGTessOCR.LanguageCode := MGTessOCR.LanguageNameToCode(CBLanguage.Items[CBLanguage.ItemIndex]);
        MGTessOCR.DataPath := IncludeTrailingBackSlash(ExtractFilePath(ParamStr(0)));
        MGTessOCR.Active := True;
      end;
      ButtonRecognize.Enabled := True;
    end
end;

procedure TMainForm.ButtonRecognizeClick(Sender: TObject);
begin
  try
    ProgressBar.Value := 0;
    CancelRequest := False;
    ButtonSelectPicture.Enabled := False;
    ButtonCancel.Visible := True;
    CBLanguage.Enabled := False;
    MemoText.Lines.Clear;
    MemoText.Repaint;
    if not CancelRequest then
      MemoText.Text := StringReplace(MGTessOCR.Text, #$a, #$d#$a, [rfReplaceAll]);
    if not CancelRequest then
      ProgressBar.Value := 100
    else
      ProgressBar.Value := 0;
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
  ProgressBar.Value := Progress;
  LWordCount.Text := IntToStr(WordCount);
  Application.ProcessMessages;
  Cancel := CancelRequest;
end;

end.
