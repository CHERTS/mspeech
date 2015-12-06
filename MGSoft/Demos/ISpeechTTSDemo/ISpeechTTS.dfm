object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'ISpeech TTS Demo'
  ClientHeight = 340
  ClientWidth = 416
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
    416
    340)
  PixelsPerInch = 96
  TextHeight = 13
  object LabelLang: TLabel
    Left = 8
    Top = 11
    Width = 51
    Height = 13
    Caption = 'Language:'
  end
  object LabelAudioFormat: TLabel
    Left = 8
    Top = 38
    Width = 83
    Height = 13
    Caption = 'Audio file format:'
  end
  object LabelFrequencies: TLabel
    Left = 8
    Top = 65
    Width = 55
    Height = 13
    Caption = 'Frequency:'
  end
  object ButtonSay: TButton
    Left = 271
    Top = 121
    Width = 137
    Height = 25
    Caption = 'Save to file'
    TabOrder = 6
    OnClick = ButtonSayClick
  end
  object EditText: TEdit
    Left = 8
    Top = 123
    Width = 257
    Height = 21
    TabOrder = 5
    Text = 'Hello world'
  end
  object MemoLog: TMemo
    Left = 8
    Top = 152
    Width = 400
    Height = 180
    Anchors = [akLeft, akTop, akRight, akBottom]
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 7
  end
  object CBVoices: TComboBox
    Left = 151
    Top = 8
    Width = 257
    Height = 21
    Style = csDropDownList
    TabOrder = 0
    OnChange = CBVoicesChange
  end
  object EditAPIKey: TEdit
    Left = 8
    Top = 96
    Width = 257
    Height = 21
    TabOrder = 3
    Text = 'Enter iSpeech API key'
  end
  object ButtonGetAPIKey: TButton
    Left = 271
    Top = 94
    Width = 137
    Height = 25
    Caption = 'Get API key'
    TabOrder = 4
    OnClick = ButtonGetAPIKeyClick
  end
  object CBAudioFormat: TComboBox
    Left = 151
    Top = 35
    Width = 257
    Height = 21
    Style = csDropDownList
    TabOrder = 1
    OnChange = CBAudioFormatChange
  end
  object CBFrequencies: TComboBox
    Left = 151
    Top = 62
    Width = 257
    Height = 21
    Style = csDropDownList
    TabOrder = 2
    OnChange = CBFrequenciesChange
  end
  object MGISpeechTTS1: TMGISpeechTTS
    OutFileName = 'Out.mp3'
    TTSLang = ISpeechTTS_RussianFemale
    TTSLangCode = 'rurussianfemale'
    TTSString = #1055#1088#1086#1074#1077#1088#1082#1072' '#1089#1080#1085#1090#1077#1079#1072' '#1088#1077#1095#1080' '#1085#1072' '#1056#1091#1089#1089#1082#1086#1084' '#1103#1079#1099#1082#1077'.'
    TTSAudioFormat = ISpeechTTS_FLAC
    TTSAudioFormatCode = 'flac'
    TTSFrequenceValue = 16000
    ProxyAddress = '192.168.0.1'
    ProxyPort = '3128'
    OnEvent = MGISpeechTTS1Event
    Left = 304
    Top = 168
  end
end
