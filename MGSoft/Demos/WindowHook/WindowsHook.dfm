object MainForm: TMainForm
  Left = 422
  Top = 272
  BorderStyle = bsDialog
  Caption = 'TMGWindowHook Demo'
  ClientHeight = 74
  ClientWidth = 255
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object ButtonActivate: TButton
    Left = 8
    Top = 8
    Width = 233
    Height = 25
    Caption = 'Activate MGWindowHook'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    OnClick = ButtonActivateClick
  end
  object ButtonHook: TButton
    Left = 8
    Top = 40
    Width = 233
    Height = 25
    Caption = 'Active = False'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
  end
  object MGWindowHook1: TMGWindowHook
    Active = False
    WinControl = ButtonHook
    AfterMessage = MGWindowHook1AfterMessage
    Left = 192
    Top = 8
  end
end
