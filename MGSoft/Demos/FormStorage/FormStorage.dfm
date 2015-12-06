object MainForm: TMainForm
  Left = 354
  Top = 204
  Caption = 'FormStorage Demo'
  ClientHeight = 152
  ClientWidth = 244
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
  object TrackBar1: TTrackBar
    Left = 0
    Top = 122
    Width = 244
    Height = 30
    Align = alBottom
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 244
    Height = 122
    Align = alClient
    TabOrder = 1
  end
  object MGFormStorage1: TMGFormStorage
    IniFileName = '.\FormStorage.ini'
    Options = [fpState, fpPosition, fpActiveControl]
    StoredProps.Strings = (
      'TrackBar1.Position')
    StoredValues = <>
    Left = 160
    Top = 16
  end
end
