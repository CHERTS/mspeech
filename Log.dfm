object LogForm: TLogForm
  Left = 0
  Top = 0
  Caption = 'MSpeechLog'
  ClientHeight = 286
  ClientWidth = 615
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  DesignSize = (
    615
    286)
  PixelsPerInch = 96
  TextHeight = 13
  object LFileNameDesc: TLabel
    Left = 8
    Top = 12
    Width = 79
    Height = 13
    Caption = #1048#1084#1103' '#1083#1086#1075'-'#1092#1072#1081#1083#1072':'
  end
  object CBFileName: TComboBox
    Left = 93
    Top = 9
    Width = 268
    Height = 21
    Style = csDropDownList
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
    OnChange = CBFileNameChange
    OnDropDown = CBFileNameDropDown
  end
  object DeleteLogButton: TButton
    Left = 485
    Top = 7
    Width = 122
    Height = 25
    Anchors = [akTop, akRight]
    Caption = #1059#1076#1072#1083#1080#1090#1100' '#1083#1086#1075'-'#1092#1072#1081#1083
    Enabled = False
    ImageIndex = 26
    TabOrder = 2
    OnClick = DeleteLogButtonClick
  end
  object ReloadLogButton: TButton
    Left = 367
    Top = 7
    Width = 112
    Height = 25
    Anchors = [akTop, akRight]
    Caption = #1054#1073#1085#1086#1074#1080#1090#1100
    Enabled = False
    ImageIndex = 0
    TabOrder = 1
    OnClick = ReloadLogButtonClick
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 267
    Width = 615
    Height = 19
    Panels = <
      item
        Width = 210
      end
      item
        Width = 200
      end
      item
        Width = 50
      end>
  end
  object TextListView: TListView
    Left = 0
    Top = 40
    Width = 615
    Height = 225
    Anchors = [akLeft, akTop, akRight, akBottom]
    Columns = <
      item
        AutoSize = True
        Caption = 'Text'
      end>
    ColumnClick = False
    MultiSelect = True
    OwnerData = True
    ReadOnly = True
    RowSelect = True
    ShowColumnHeaders = False
    TabOrder = 3
    ViewStyle = vsReport
    OnContextPopup = TextListViewContextPopup
    OnCustomDrawItem = TextListViewCustomDrawItem
    OnData = TextListViewData
  end
  object FileReadThread: TMGThread
    Exclusive = True
    MaxCount = 0
    RunOnCreate = True
    FreeOnTerminate = True
    OnExecute = FileReadThreadExecute
    OnFinish = FileReadThreadFinish
    Left = 464
    Top = 48
  end
  object LogPopupMenu: TPopupMenu
    Left = 376
    Top = 48
    object LogCopy: TMenuItem
      Caption = #1050#1086#1087#1080#1088#1086#1074#1072#1090#1100
      OnClick = LogCopyClick
    end
    object SelectAllRow: TMenuItem
      Caption = #1042#1099#1076#1077#1083#1080#1090#1100' '#1074#1089#1077
      OnClick = SelectAllRowClick
    end
  end
  object MGFormPlacement: TMGFormPlacement
    IniFileName = 'MSpeechFormStorage.ini'
    Options = [fpPosition]
    RegistryRoot = prCurrentConfig
    Left = 376
    Top = 104
  end
end
