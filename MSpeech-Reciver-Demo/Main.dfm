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
  object ReciverMemo: TMemo
    Left = 8
    Top = 8
    Width = 412
    Height = 202
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
  end
end
