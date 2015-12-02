object MainForm: TMainForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Search AppControl ClassName'
  ClientHeight = 153
  ClientWidth = 404
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
    404
    153)
  PixelsPerInch = 96
  TextHeight = 13
  object GBSearch: TGroupBox
    Left = 8
    Top = 8
    Width = 388
    Height = 137
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = 
      ' Search the handle and name of the class controls the active win' +
      'dow '
    TabOrder = 0
    object LHandle: TLabel
      Left = 16
      Top = 54
      Width = 37
      Height = 13
      Caption = 'Handle:'
    end
    object LClassName: TLabel
      Left = 16
      Top = 81
      Width = 56
      Height = 13
      Caption = 'ClassName:'
    end
    object LCaption: TLabel
      Left = 16
      Top = 27
      Width = 41
      Height = 13
      Caption = 'Caption:'
    end
    object StartStopSearchButton: TButton
      Left = 78
      Top = 105
      Width = 113
      Height = 25
      Caption = 'Start search'
      TabOrder = 3
      OnClick = StartStopSearchButtonClick
    end
    object EHandle: TEdit
      Left = 78
      Top = 51
      Width = 299
      Height = 21
      ReadOnly = True
      TabOrder = 1
    end
    object EClassName: TEdit
      Left = 78
      Top = 78
      Width = 299
      Height = 21
      ReadOnly = True
      TabOrder = 2
    end
    object ECaption: TEdit
      Left = 78
      Top = 24
      Width = 299
      Height = 21
      ReadOnly = True
      TabOrder = 0
    end
  end
  object SearchTimer: TTimer
    Enabled = False
    Interval = 100
    OnTimer = SearchTimerTimer
    Left = 320
    Top = 72
  end
end
