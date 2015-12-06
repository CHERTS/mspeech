object MainForm: TMainForm
  Left = 265
  Top = 167
  Caption = 'HotKeyManager Demo'
  ClientHeight = 287
  ClientWidth = 518
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 264
    Top = 180
    Width = 237
    Height = 55
    AutoSize = False
    Caption = 
      #1055#1086#1089#1083#1077' '#1076#1086#1073#1072#1074#1083#1077#1085#1080#1103' '#1075#1086#1088#1103#1095#1080#1093' '#1082#1083#1072#1074#1080#1096' '#1080#1093' '#1084#1086#1078#1085#1086' '#1085#1072#1078#1072#1090#1100', '#1087#1086#1089#1083#1077' '#1101#1090#1086#1075#1086' '#1087#1086#1103 +
      #1074#1080#1090#1089#1103' MessageBox '#1089' '#1089#1086#1086#1073#1097#1077#1085#1080#1077#1084' '#1086' '#1085#1072#1078#1072#1090#1086#1081' '#1082#1083#1072#1074#1080#1096#1077'. '#1053#1072#1079#1085#1072#1095#1080#1090#1100' '#1086#1076#1085#1091' ' +
      #1080' '#1090#1091' '#1078#1077' '#1075#1086#1088#1103#1095#1091#1102' '#1082#1083#1072#1074#1080#1096#1091' '#1076#1074#1072#1078#1076#1099' '#1085#1077#1083#1100#1079#1103'.'
    ShowAccelChar = False
    WordWrap = True
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 241
    Height = 55
    Caption = ' '#1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1085#1080#1077' THotKey '
    TabOrder = 0
    object HotKey1: THotKey
      Left = 12
      Top = 22
      Width = 141
      Height = 21
      HotKey = 0
      Modifiers = []
      TabOrder = 0
    end
    object BtnAdd: TButton
      Left = 164
      Top = 21
      Width = 65
      Height = 23
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      TabOrder = 1
      OnClick = BtnAddClick
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 76
    Width = 241
    Height = 107
    Caption = ' '#1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1085#1080#1077' '#1084#1077#1090#1086#1076#1072' GetHotKey '
    TabOrder = 1
    object Label2: TLabel
      Left = 12
      Top = 78
      Width = 48
      Height = 13
      Caption = #1050#1083#1072#1074#1080#1096#1072':'
      FocusControl = ComboBox1
    end
    object BtnGetHotKey: TButton
      Left = 164
      Top = 21
      Width = 65
      Height = 23
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      TabOrder = 5
      OnClick = BtnGetHotKeyClick
    end
    object CheckBox1: TCheckBox
      Left = 12
      Top = 22
      Width = 45
      Height = 17
      Caption = 'Ctrl'
      Checked = True
      State = cbChecked
      TabOrder = 0
    end
    object CheckBox2: TCheckBox
      Left = 64
      Top = 22
      Width = 45
      Height = 17
      Caption = 'Shift'
      TabOrder = 1
    end
    object CheckBox3: TCheckBox
      Left = 12
      Top = 46
      Width = 45
      Height = 17
      Caption = 'Alt'
      TabOrder = 2
    end
    object CheckBox4: TCheckBox
      Left = 64
      Top = 46
      Width = 45
      Height = 17
      Caption = 'Win'
      TabOrder = 3
    end
    object ComboBox1: TComboBox
      Left = 66
      Top = 71
      Width = 117
      Height = 21
      Style = csDropDownList
      DropDownCount = 12
      TabOrder = 4
    end
  end
  object GroupBox3: TGroupBox
    Left = 8
    Top = 196
    Width = 241
    Height = 85
    Caption = ' '#1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1085#1080#1077' '#1084#1077#1090#1086#1076#1072' TextToHotKey'
    TabOrder = 2
    object BtnTextToHotKey: TButton
      Left = 164
      Top = 21
      Width = 65
      Height = 23
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      TabOrder = 1
      OnClick = BtnTextToHotKeyClick
    end
    object Edit1: TEdit
      Left = 12
      Top = 22
      Width = 141
      Height = 21
      TabOrder = 0
      Text = 'Ctrl+Alt+Num 1'
    end
    object BtnTest: TButton
      Left = 164
      Top = 50
      Width = 65
      Height = 23
      Caption = #1057#1074#1086#1073#1086#1076#1085#1072'?'
      TabOrder = 2
      OnClick = BtnTestClick
    end
  end
  object GroupBox4: TGroupBox
    Left = 264
    Top = 8
    Width = 246
    Height = 157
    Caption = ' '#1053#1072#1079#1085#1072#1095#1077#1085#1085#1099#1077' '#1075#1086#1088#1103#1095#1080#1077' '#1082#1083#1072#1074#1080#1096#1080' '
    TabOrder = 3
    object BtnClear: TButton
      Left = 164
      Top = 49
      Width = 74
      Height = 23
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1074#1089#1077
      TabOrder = 2
      OnClick = BtnClearClick
    end
    object ListBox1: TListBox
      Left = 12
      Top = 22
      Width = 141
      Height = 121
      IntegralHeight = True
      ItemHeight = 13
      TabOrder = 0
    end
    object BtnRemove: TButton
      Left = 164
      Top = 21
      Width = 73
      Height = 23
      Caption = #1059#1076#1072#1083#1080#1090#1100
      TabOrder = 1
      OnClick = BtnRemoveClick
    end
  end
  object BtnExit: TButton
    Left = 440
    Top = 259
    Width = 65
    Height = 23
    Caption = #1042#1099#1093#1086#1076
    TabOrder = 4
    OnClick = BtnExitClick
  end
  object MGHotKeyManager1: TMGHotKeyManager
    OnHotKeyPressed = MGHotKeyManager1HotKeyPressed
    Left = 336
    Top = 80
  end
end
