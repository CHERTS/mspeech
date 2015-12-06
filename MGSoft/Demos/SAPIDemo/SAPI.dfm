object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'SAPI5 Demo'
  ClientHeight = 496
  ClientWidth = 370
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    370
    496)
  PixelsPerInch = 96
  TextHeight = 13
  object LVol: TLabel
    Left = 8
    Top = 183
    Width = 38
    Height = 13
    Caption = 'Volume:'
  end
  object LSpeed: TLabel
    Left = 8
    Top = 215
    Width = 34
    Height = 13
    Caption = 'Speed:'
  end
  object LPos: TLabel
    Left = 8
    Top = 279
    Width = 103
    Height = 13
    Caption = 'Position text reading:'
  end
  object LPosition: TLabel
    Left = 137
    Top = 279
    Width = 6
    Height = 13
    Caption = '0'
  end
  object LPitch: TLabel
    Left = 8
    Top = 247
    Width = 27
    Height = 13
    Caption = 'Pitch:'
  end
  object ButtonStart: TButton
    Left = 8
    Top = 152
    Width = 114
    Height = 25
    Caption = 'Start'
    TabOrder = 3
    OnClick = ButtonStartClick
  end
  object EditText: TEdit
    Left = 8
    Top = 125
    Width = 354
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 2
    Text = 'Hello world'
  end
  object MemoLog: TMemo
    Left = 8
    Top = 304
    Width = 354
    Height = 184
    Anchors = [akLeft, akTop, akRight, akBottom]
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 4
  end
  object CBVoices: TComboBox
    Left = 8
    Top = 8
    Width = 354
    Height = 21
    Style = csDropDownList
    TabOrder = 0
    OnChange = CBVoicesChange
  end
  object LBSAPIInfo: TListBox
    Left = 8
    Top = 35
    Width = 354
    Height = 84
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 13
    TabOrder = 1
  end
  object ButtonPauseResume: TButton
    Left = 128
    Top = 152
    Width = 114
    Height = 25
    Caption = 'Pause'
    TabOrder = 5
    OnClick = ButtonPauseResumeClick
  end
  object ButtonStop: TButton
    Left = 248
    Top = 152
    Width = 114
    Height = 25
    Caption = 'Stop'
    TabOrder = 6
    OnClick = ButtonStopClick
  end
  object TBVol: TTrackBar
    Left = 71
    Top = 183
    Width = 291
    Height = 26
    Max = 100
    PageSize = 1
    TabOrder = 7
    ThumbLength = 15
    OnChange = TBVolChange
  end
  object TBSpeed: TTrackBar
    Left = 71
    Top = 215
    Width = 291
    Height = 26
    Min = -10
    PageSize = 1
    TabOrder = 8
    ThumbLength = 15
    OnChange = TBSpeedChange
  end
  object TBPitch: TTrackBar
    Left = 71
    Top = 247
    Width = 291
    Height = 26
    Min = -10
    PageSize = 1
    TabOrder = 9
    ThumbLength = 15
    OnChange = TBPitchChange
  end
  object MGSAPI1: TMGSAPI
    TTSLang = 0
    OnEvent = MGSAPI1Event
    OnPosition = MGSAPI1Position
    Left = 320
    Top = 48
  end
end
