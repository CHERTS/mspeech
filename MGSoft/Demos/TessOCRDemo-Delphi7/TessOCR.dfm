object MainForm: TMainForm
  Left = 633
  Top = 166
  Width = 942
  Height = 712
  Caption = 'MGTessOCR Demo - Delphi 7'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter: TSplitter
    Left = 477
    Top = 0
    Height = 674
    Beveled = True
  end
  object PanelLeft: TPanel
    Left = 0
    Top = 0
    Width = 477
    Height = 674
    Align = alLeft
    BevelOuter = bvNone
    BorderWidth = 4
    TabOrder = 0
    object Panel: TPanel
      Left = 4
      Top = 37
      Width = 469
      Height = 633
      Align = alBottom
      Anchors = [akLeft, akTop, akRight, akBottom]
      BevelOuter = bvLowered
      TabOrder = 0
      object Image: TImage
        Left = 1
        Top = 1
        Width = 467
        Height = 631
        Align = alClient
        Center = True
        Proportional = True
        Stretch = True
      end
    end
    object ButtonSelectPicture: TButton
      Left = 5
      Top = 7
      Width = 105
      Height = 25
      Caption = 'Select Picture'
      TabOrder = 1
      OnClick = ButtonSelectPictureClick
    end
    object CBLanguage: TComboBox
      Left = 116
      Top = 9
      Width = 186
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 2
    end
  end
  object PanelRight: TPanel
    Left = 480
    Top = 0
    Width = 446
    Height = 674
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 4
    TabOrder = 1
    DesignSize = (
      446
      674)
    object LWordCount: TLabel
      Left = 82
      Top = 13
      Width = 6
      Height = 13
      Caption = '0'
    end
    object ButtonRecognize: TButton
      Left = 4
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Recognize'
      Enabled = False
      TabOrder = 3
      OnClick = ButtonRecognizeClick
    end
    object ButtonCancel: TButton
      Left = 3
      Top = 7
      Width = 75
      Height = 25
      Caption = 'Cancel'
      TabOrder = 0
      Visible = False
      OnClick = ButtonCancelClick
    end
    object ProgressBar: TProgressBar
      Left = 120
      Top = 11
      Width = 321
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 1
    end
    object PageControl: TPageControl
      Left = 4
      Top = 37
      Width = 438
      Height = 633
      ActivePage = TabSheetText
      Align = alBottom
      Anchors = [akLeft, akTop, akRight, akBottom]
      TabOrder = 2
      object TabSheetText: TTabSheet
        Caption = 'Text'
        object MemoText: TMemo
          Left = 0
          Top = 0
          Width = 430
          Height = 605
          Align = alClient
          BorderStyle = bsNone
          ReadOnly = True
          ScrollBars = ssBoth
          TabOrder = 0
        end
      end
    end
  end
  object OpenPictureDialog: TOpenPictureDialog
    Filter = 
      'All (*.jpg;*.jpeg;*.bmp;*.tif,*.tiff,*.gif,*.png)|*.jpg;*.jpeg;*' +
      '.bmp;*.tif;*.tiff;*.gif;*.png|JPEG Image File (*.jpg)|*.jpg|JPEG' +
      ' Image File (*.jpeg)|*.jpeg|Bitmaps (*.bmp)|*.bmp|Tiff (*.tif)|*' +
      '.tif|Tiff (*.tiff)|*.tiff|Gif (*.gif)|*.gif|Png (*.png)|*.png'
    Left = 64
    Top = 48
  end
  object XPManifest: TXPManifest
    Left = 144
    Top = 48
  end
  object MGTessOCR: TMGTessOCR
    Language = OCR_Russian
    LanguageCode = 'rus'
    PageNumber = 0
    OnProgress = OcrProgress
    Left = 216
    Top = 48
  end
end
