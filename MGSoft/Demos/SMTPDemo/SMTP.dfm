object MainForm: TMainForm
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'SMTP Demo'
  ClientHeight = 406
  ClientWidth = 393
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
    393
    406)
  PixelsPerInch = 96
  TextHeight = 13
  object LHost: TLabel
    Left = 16
    Top = 11
    Width = 55
    Height = 13
    Caption = 'SMTP Host:'
  end
  object LPort: TLabel
    Left = 16
    Top = 38
    Width = 53
    Height = 13
    Caption = 'SMTP Port:'
  end
  object LLogin: TLabel
    Left = 16
    Top = 65
    Width = 58
    Height = 13
    Caption = 'SMTP Login:'
  end
  object LPasswd: TLabel
    Left = 16
    Top = 92
    Width = 79
    Height = 13
    Caption = 'SMTP Password:'
  end
  object LFrom: TLabel
    Left = 16
    Top = 142
    Width = 28
    Height = 13
    Caption = 'From:'
  end
  object LText: TLabel
    Left = 16
    Top = 169
    Width = 26
    Height = 13
    Caption = 'Text:'
  end
  object LLog: TLabel
    Left = 16
    Top = 226
    Width = 21
    Height = 13
    Caption = 'Log:'
  end
  object EHost: TEdit
    Left = 101
    Top = 8
    Width = 286
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
    Text = 'smtp.gmail.com'
  end
  object EPort: TEdit
    Left = 101
    Top = 35
    Width = 286
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    MaxLength = 5
    NumbersOnly = True
    TabOrder = 1
    Text = '587'
  end
  object ELogin: TEdit
    Left = 101
    Top = 62
    Width = 286
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 2
  end
  object EPasswd: TEdit
    Left = 101
    Top = 89
    Width = 286
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    PasswordChar = '*'
    TabOrder = 3
  end
  object CBTLS: TCheckBox
    Left = 101
    Top = 116
    Width = 75
    Height = 17
    Caption = 'Use TLS'
    Checked = True
    State = cbChecked
    TabOrder = 4
  end
  object EFrom: TEdit
    Left = 77
    Top = 139
    Width = 310
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 5
  end
  object MemoText: TMemo
    Left = 77
    Top = 166
    Width = 308
    Height = 51
    Anchors = [akLeft, akTop, akRight]
    Lines.Strings = (
      'Hello!')
    TabOrder = 6
  end
  object ButtonSend: TButton
    Left = 77
    Top = 367
    Width = 75
    Height = 25
    Caption = 'Send'
    TabOrder = 7
    OnClick = ButtonSendClick
  end
  object MemoLog: TMemo
    Left = 77
    Top = 223
    Width = 308
    Height = 138
    Anchors = [akLeft, akTop, akRight]
    ScrollBars = ssVertical
    TabOrder = 8
  end
  object CBFullSSL: TCheckBox
    Left = 182
    Top = 116
    Width = 97
    Height = 17
    Caption = 'Full SSL'
    TabOrder = 9
  end
  object MGSMTP1: TMGSMTP
    Host = 'smtp.gmail.com'
    FromEmail = 'sleuthhound@gmail.com'
    FromName = 'Mikhail Grigorev'
    Port = 587
    UseTLS = True
    FullSSL = False
    OnStatus = MGSMTP1Status
    OnReadFilter = MGSMTP1ReadFilter
    Left = 296
    Top = 248
  end
end
