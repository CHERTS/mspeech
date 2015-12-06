object MainForm: TMainForm
  Left = 275
  Top = 163
  Caption = 'TMGTextReader Demo'
  ClientHeight = 605
  ClientWidth = 763
  Color = clBtnFace
  Constraints.MinHeight = 200
  Constraints.MinWidth = 200
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    763
    605)
  PixelsPerInch = 96
  TextHeight = 13
  object LabelReadLn: TLabel
    Left = 200
    Top = 16
    Width = 64
    Height = 13
    Caption = 'LabelReadLn'
  end
  object TextListView: TListView
    Left = 0
    Top = 40
    Width = 763
    Height = 555
    Anchors = [akLeft, akTop, akRight, akBottom]
    Columns = <
      item
        Caption = 'Text'
        Width = 750
      end>
    ColumnClick = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    OwnerData = True
    ReadOnly = True
    RowSelect = True
    ParentFont = False
    TabOrder = 0
    ViewStyle = vsReport
    OnData = TextListViewData
  end
  object ButtonOpenFile: TButton
    Left = 8
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Open file'
    TabOrder = 1
    OnClick = ButtonOpenFileClick
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 586
    Width = 763
    Height = 19
    Panels = <
      item
        Width = 210
      end
      item
        Width = 210
      end
      item
        Width = 50
      end>
  end
  object ButtonReadLn: TButton
    Left = 89
    Top = 8
    Width = 75
    Height = 25
    Caption = 'ReadLn Test'
    TabOrder = 3
    OnClick = ButtonReadLnClick
  end
  object OpenDialog: TOpenDialog
    Filter = 'Text files (*.txt)|*.txt|All files (*.*)|*.*'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 288
    Top = 88
  end
end
