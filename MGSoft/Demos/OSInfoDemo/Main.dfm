object MainForm: TMainForm
  Left = 667
  Top = 177
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'OSInfo Demo'
  ClientHeight = 201
  ClientWidth = 499
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  DesignSize = (
    499
    201)
  PixelsPerInch = 96
  TextHeight = 13
  object MemoVersion: TMemo
    Left = 8
    Top = 8
    Width = 483
    Height = 183
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
    ExplicitWidth = 554
    ExplicitHeight = 220
  end
  object MGOSInfo1: TMGOSInfo
    Left = 264
    Top = 40
  end
end
