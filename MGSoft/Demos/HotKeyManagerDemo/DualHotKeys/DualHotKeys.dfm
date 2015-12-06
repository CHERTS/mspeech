object MainForm: TMainForm
  Left = 397
  Top = 362
  BorderStyle = bsDialog
  Caption = #1044#1074#1077' '#1075#1086#1103#1095#1080#1077' '#1082#1083#1072#1074#1080#1096#1080
  ClientHeight = 197
  ClientWidth = 222
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 100
    Height = 13
    Caption = #1043#1086#1088#1103#1095#1072#1103' '#1082#1083#1072#1074#1080#1096#1072' &1:'
    FocusControl = HotKey1
  end
  object Label2: TLabel
    Left = 8
    Top = 52
    Width = 100
    Height = 13
    Caption = #1043#1086#1088#1103#1095#1072#1103' '#1082#1083#1072#1074#1080#1096#1072' &2:'
    FocusControl = HotKey2
  end
  object Label3: TLabel
    Left = 8
    Top = 98
    Width = 206
    Height = 55
    AutoSize = False
    Caption = 
      #1055#1088#1080' '#1085#1072#1078#1072#1090#1080#1080' '#1083#1102#1073#1086#1081' '#1080#1079' '#1076#1074#1091#1093' '#1075#1086#1088#1103#1095#1080#1093' '#1082#1083#1072#1074#1080#1096' '#1076#1086#1083#1078#1077#1085' '#1087#1086#1103#1074#1080#1090#1089#1103' Message' +
      'Box, '#1076#1072#1078#1077' '#1077#1089#1083#1080' '#1101#1090#1086' '#1087#1088#1080#1083#1086#1078#1077#1085#1080#1077' '#1085#1077' '#1085#1072' '#1087#1077#1088#1077#1076#1085#1077#1084' '#1087#1083#1072#1085#1077'.'
    ShowAccelChar = False
    WordWrap = True
  end
  object HotKey1: THotKey
    Left = 8
    Top = 24
    Width = 121
    Height = 19
    HotKey = 49201
    Modifiers = [hkCtrl, hkAlt]
    TabOrder = 0
  end
  object HotKey2: THotKey
    Left = 8
    Top = 68
    Width = 121
    Height = 19
    HotKey = 49202
    Modifiers = [hkCtrl, hkAlt]
    TabOrder = 2
  end
  object Button1: TButton
    Left = 135
    Top = 20
    Width = 79
    Height = 25
    Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 135
    Top = 64
    Width = 79
    Height = 25
    Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100
    TabOrder = 3
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 71
    Top = 164
    Width = 75
    Height = 25
    Caption = '&'#1042#1099#1093#1086#1076
    TabOrder = 4
    OnClick = Button3Click
  end
  object MGHotKeyManager1: TMGHotKeyManager
    OnHotKeyPressed = MGHotKeyManager1HotKeyPressed
    Left = 144
    Top = 94
  end
end
