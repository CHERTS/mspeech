object MainForm: TMainForm
  Left = 994
  Top = 199
  Width = 403
  Height = 534
  Caption = 'SAPI Demo'
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
    387
    496)
  PixelsPerInch = 96
  TextHeight = 13
  object LVol: TLabel
    Left = 8
    Top = 183
    Width = 57
    Height = 13
    Caption = #1043#1088#1086#1084#1082#1086#1089#1090#1100':'
  end
  object LSpeed: TLabel
    Left = 8
    Top = 215
    Width = 52
    Height = 13
    Caption = #1057#1082#1086#1088#1086#1089#1090#1100':'
  end
  object LPos: TLabel
    Left = 8
    Top = 279
    Width = 123
    Height = 13
    Caption = #1055#1086#1079#1080#1094#1080#1103' '#1095#1090#1077#1085#1080#1103' '#1090#1077#1082#1089#1090#1072':'
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
    Width = 41
    Height = 13
    Caption = #1042#1099#1089#1086#1090#1072':'
  end
  object ButtonStart: TButton
    Left = 8
    Top = 152
    Width = 114
    Height = 25
    Caption = #1057#1090#1072#1088#1090
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
    Text = #1055#1088#1086#1074#1077#1088#1082#1072' '#1089#1080#1085#1090#1077#1079#1072' '#1088#1077#1095#1080' '#1085#1072' '#1056#1091#1089#1089#1082#1086#1084' '#1103#1079#1099#1082#1077
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
    ItemHeight = 13
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
    Caption = #1055#1072#1091#1079#1072
    TabOrder = 5
    OnClick = ButtonPauseResumeClick
  end
  object ButtonStop: TButton
    Left = 248
    Top = 152
    Width = 114
    Height = 25
    Caption = #1057#1090#1086#1087
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
