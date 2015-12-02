object MainForm: TMainForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'MSpeech Reciver Demo'
  ClientHeight = 218
  ClientWidth = 428
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object LInfoRU: TLabel
    Left = 8
    Top = 8
    Width = 412
    Height = 26
    AutoSize = False
    Caption = 
      #1055#1088#1080#1084#1077#1088' '#1087#1088#1086#1075#1088#1072#1084#1084#1099', '#1076#1077#1084#1086#1085#1089#1090#1088#1080#1088#1091#1102#1097#1077#1081' '#1087#1088#1080#1077#1084' '#1090#1077#1082#1089#1090#1072' '#1086#1090' MSpeech, '#1087#1086' '#1089#1086 +
      #1073#1099#1090#1080#1102' WM_COPYDATA.'
    WordWrap = True
  end
  object LInfoEN: TLabel
    Left = 8
    Top = 40
    Width = 412
    Height = 26
    AutoSize = False
    Caption = 
      'An example application demonstrating the reception of the text f' +
      'rom MSpeech, event WM_COPYDATA.'
    WordWrap = True
  end
  object ReciverMemo: TMemo
    Left = 8
    Top = 72
    Width = 412
    Height = 138
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
  end
end
