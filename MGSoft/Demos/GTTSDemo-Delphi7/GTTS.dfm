object MainForm: TMainForm
  Left = 869
  Top = 242
  Width = 481
  Height = 312
  Caption = 'Google TTS Demo'
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
    465
    274)
  PixelsPerInch = 96
  TextHeight = 13
  object ButtonSay: TButton
    Left = 344
    Top = 35
    Width = 112
    Height = 25
    Caption = 'Save to file'
    TabOrder = 2
    OnClick = ButtonSayClick
  end
  object EditText: TTntEdit
    Left = 8
    Top = 37
    Width = 329
    Height = 21
    TabOrder = 1
    Text = 'Hello world'
  end
  object MemoLog: TMemo
    Left = 8
    Top = 66
    Width = 449
    Height = 200
    Anchors = [akLeft, akTop, akRight, akBottom]
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 3
  end
  object CBVoices: TTntComboBox
    Left = 8
    Top = 8
    Width = 329
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
    OnChange = CBVoicesChange
  end
  object MGGoogleTTS1: TMGGoogleTTS
    OutFileName = 'Out.mp3'
    TTSLangCode = 'en'
    TTSString = 'Checking speech synthesis on English language.'
    ProxyAddress = '192.168.0.1'
    ProxyPort = '3128'
    OnEvent = MGGoogleTTS1Event
    Left = 320
    Top = 80
  end
end
