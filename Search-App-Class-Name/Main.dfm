object MainForm: TMainForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Search AppControl ClassName'
  ClientHeight = 153
  ClientWidth = 404
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  DesignSize = (
    404
    153)
  PixelsPerInch = 96
  TextHeight = 13
  object GBSearch: TGroupBox
    Left = 8
    Top = 8
    Width = 388
    Height = 137
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = 
      ' '#1055#1086#1080#1089#1082' '#1093#1101#1085#1076#1083#1072' '#1080' '#1080#1084#1077#1085#1080' '#1082#1083#1072#1089#1089#1072' '#1091#1087#1088#1072#1074#1083#1103#1102#1097#1080#1093' '#1101#1083#1077#1084#1077#1085#1090#1086#1074' '#1072#1082#1090#1080#1074#1085#1086#1075#1086' '#1086#1082#1085 +
      #1072' '
    TabOrder = 0
    object LHandle: TLabel
      Left = 16
      Top = 54
      Width = 37
      Height = 13
      Caption = 'Handle:'
    end
    object LClassName: TLabel
      Left = 16
      Top = 81
      Width = 56
      Height = 13
      Caption = 'ClassName:'
    end
    object LCaption: TLabel
      Left = 16
      Top = 27
      Width = 41
      Height = 13
      Caption = 'Caption:'
    end
    object StartStopSearchButton: TButton
      Left = 78
      Top = 105
      Width = 113
      Height = 25
      Caption = #1053#1072#1095#1072#1090#1100' '#1087#1086#1080#1089#1082
      TabOrder = 3
      OnClick = StartStopSearchButtonClick
    end
    object EHandle: TEdit
      Left = 78
      Top = 51
      Width = 299
      Height = 21
      ReadOnly = True
      TabOrder = 1
    end
    object EClassName: TEdit
      Left = 78
      Top = 78
      Width = 299
      Height = 21
      ReadOnly = True
      TabOrder = 2
    end
    object ECaption: TEdit
      Left = 78
      Top = 24
      Width = 299
      Height = 21
      ReadOnly = True
      TabOrder = 0
    end
  end
  object SearchTimer: TTimer
    Enabled = False
    Interval = 100
    OnTimer = SearchTimerTimer
    Left = 320
    Top = 72
  end
end
