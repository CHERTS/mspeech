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

//{$DEFINE DEBUG}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, ExtDlgs, XPMan, MGTessOCR, Jpeg
{$ifdef CONDITIONALEXPRESSIONS}
  {$if CompilerVersion >= 30} // Delphi 10
    , GIFImg, PngImage
  {$ifend}
{$endif}
;

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
    Shape: TShape;
    procedure ButtonSelectPictureClick(Sender: TObject);
    procedure ButtonRecognizeClick(Sender: TObject);
    procedure ButtonCancelClick(Sender: TObject);
    procedure OcrProgress(Sender: TObject; var Cancel: Boolean; Progress, WordCount: Integer);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ImageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ImageMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ImageMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PanelResize(Sender: TObject);
    procedure CBLanguageChange(Sender: TObject);
  private
    { Private declarations }
    CancelRequest: Boolean;
    Selecting: Boolean;
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
  if (MGTessOCR.Picture.Width > 0) and (MGTessOCR.Picture.Height > 0) then
  begin
      MGTessOCR.PictureFileName := '';
      if not MGTessOCR.Active then
      begin
        MGTessOCR.LanguageCode := MGTessOCR.LanguageNameToCode(CBLanguage.Items[CBLanguage.ItemIndex]);
        MGTessOCR.DataPath := IncludeTrailingBackSlash(ExtractFilePath(Application.ExeName));
        MGTessOCR.Active := True;
      end;
      ButtonRecognize.Enabled := True;
  end;
end;

function RectToImageRect(Image: TImage; Rect: TRect): TRect;
var
  w, h, cw, ch: Integer;
  xyaspect: Double;
  DrawRect: TRect;
  Temp: Integer;
begin
  w := Image.Picture.Width;
  h := Image.Picture.Height;
  cw := Image.ClientWidth;
  ch := Image.ClientHeight;
  if Image.Stretch or (Image.Proportional and ((w > cw) or (h > ch))) then
  begin
    if Image.Proportional and (w > 0) and (h > 0) then
    begin
      xyaspect := w / h;
      if w > h then
      begin
        w := cw;
        h := Trunc(cw / xyaspect);
        if h > ch then
        begin
          h := ch;
          w := Trunc(ch * xyaspect);
        end;
      end
      else
      begin
        h := ch;
        w := Trunc(ch * xyaspect);
        if w > cw then
        begin
          w := cw;
          h := Trunc(cw / xyaspect);
        end;
      end;
    end
    else
    begin
      w := cw;
      h := ch;
    end;
  end;

  with DrawRect do
  begin
    Left := 0;
    Top := 0;
    Right := w;
    Bottom := h;
  end;

  if Image.Center then
    OffsetRect(DrawRect, (cw - w) div 2, (ch - h) div 2);

  if Rect.Left > Rect.Right then
  begin
    // swap
    Temp := Rect.Left;
    Rect.Left := Rect.Right;
    Rect.Right := Temp;
  end;

  if Rect.Top > Rect.Bottom then
  begin
    // swap
    Temp := Rect.Top;
    Rect.Top := Rect.Bottom;
    Rect.Bottom := Temp;
  end;

  Result.Left := Trunc((Rect.Left - DrawRect.Left) * (Image.Picture.Width / w));
  Result.Top := Trunc((Rect.Top - DrawRect.Top) * (Image.Picture.Height / h));
  Result.Right := Trunc(Result.Left + (Rect.Right - Rect.Left) * (Image.Picture.Width / w));
  Result.Bottom := Trunc(Result.Top + (Rect.Bottom - Rect.Top) * (Image.Picture.Height / h));

  if Result.Left < 0 then
    Result.Left := 0
  else if Result.Left >= Image.Picture.Width then
    Result.Left := Image.Picture.Width - 1;

  if Result.Top < 0 then
    Result.Top := 0
  else if Result.Top >= Image.Picture.Height then
    Result.Top := Image.Picture.Height - 1;

  if Result.Right < 0 then
    Result.Right := 0
  else if Result.Right >= Image.Picture.Width then
    Result.Left := Image.Picture.Width - 1;

  if Result.Bottom < 0 then
    Result.Bottom := 0
  else if Result.Bottom >= Image.Picture.Height then
    Result.Bottom := Image.Picture.Height - 1;
end;

function RectToShapeRect(UseShape: Boolean; Rect, ShapeRect: TRect): TRect;
begin
  Result := Rect;
  if UseShape then
  begin
    Inc(Result.Left, ShapeRect.Left);
    Inc(Result.Top, ShapeRect.Top);
    Inc(Result.Right, ShapeRect.Left);
    Inc(Result.Bottom, ShapeRect.Top);
  end;
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
        MGTessOCR.LanguageCode := MGTessOCR.LanguageNameToCode(CBLanguage.Items[CBLanguage.ItemIndex]);
        MGTessOCR.DataPath := IncludeTrailingBackSlash(ExtractFilePath(Application.ExeName));
        MGTessOCR.Active := True;
      end;
      ButtonRecognize.Enabled := True;
    end
end;

procedure TMainForm.CBLanguageChange(Sender: TObject);
begin
  if MGTessOCR.Active then
    MGTessOCR.Active := False;
  if not MGTessOCR.Active then
  begin
    MGTessOCR.LanguageCode := MGTessOCR.LanguageNameToCode((Sender as TComboBox).Items[(Sender as TComboBox).ItemIndex]);
    MGTessOCR.Active := True;
  end;
end;

procedure TMainForm.ButtonRecognizeClick(Sender: TObject);
var
  UseShape: Boolean;
  ShapeRect: TRect;
begin
  try
    ProgressBar.Position := 0;
    CancelRequest := False;
    ButtonSelectPicture.Enabled := False;
    ButtonCancel.Visible := True;
    CBLanguage.Enabled := False;
    MemoText.Clear;

    UseShape := (Shape.Width <> 0) and (Shape.Height <> 0);
    if UseShape then
    begin
      ShapeRect := RectToImageRect(Image, Shape.BoundsRect);
      MGTessOCR.PictureLeft := ShapeRect.Left;
      MGTessOCR.PictureTop := ShapeRect.Top;
      MGTessOCR.PictureWidth := ShapeRect.Right - ShapeRect.Left;
      MGTessOCR.PictureHeight := ShapeRect.Bottom - ShapeRect.Top;
    end
    else
    begin
      MGTessOCR.PictureLeft := 0;
      MGTessOCR.PictureTop := 0;
      MGTessOCR.PictureWidth := 0;
      MGTessOCR.PictureHeight := 0;
    end;

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

procedure TMainForm.ImageMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if MGTessOCR.Active then
    if Button = mbLeft then
    begin
      Selecting := True;
      Shape.Left := X;
      Shape.Top := Y;
      Shape.Width := 0;
      Shape.Height := 0;
    end;
end;

procedure TMainForm.ImageMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  if Selecting then
  begin
    Shape.Width := X - Shape.Left;
    Shape.Height := Y - Shape.Top;
  end;
end;

procedure TMainForm.ImageMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Selecting then
  begin
    Selecting := False;
    Shape.Width := X - Shape.Left;
    Shape.Height := Y - Shape.Top;
    Repaint;
  end;
end;

procedure TMainForm.PanelResize(Sender: TObject);
begin
  Shape.Width := 0;
  Shape.Height := 0;
end;

end.
