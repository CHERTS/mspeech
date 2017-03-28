object SettingsForm: TSettingsForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080
  ClientHeight = 476
  ClientWidth = 797
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object SaveSettingsButton: TButton
    Left = 528
    Top = 443
    Width = 155
    Height = 25
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1085#1072#1089#1090#1088#1086#1081#1082#1080
    ImageIndex = 0
    Images = ImageList_Main
    TabOrder = 1
    OnClick = SaveSettingsButtonClick
  end
  object CloseButton: TButton
    Left = 689
    Top = 443
    Width = 100
    Height = 25
    Caption = #1047#1072#1082#1088#1099#1090#1100
    ImageIndex = 26
    TabOrder = 2
    OnClick = CloseButtonClick
  end
  object SettingtButtonGroup: TMGButtonGroup
    Left = 8
    Top = 8
    Width = 153
    Height = 429
    BevelKind = bkTile
    BorderStyle = bsNone
    ButtonOptions = [gboFullSize, gboGroupStyle, gboShowCaptions]
    Items = <
      item
        Caption = ' '#1054#1073#1097#1080#1077' '#1085#1072#1089#1090#1088#1086#1081#1082#1080
      end
      item
        Caption = ' '#1053#1072#1089#1090#1088#1086#1081#1082#1080' '#1079#1072#1087#1080#1089#1080
      end
      item
        Caption = ' '#1053#1072#1089#1090#1088#1086#1081#1082#1080' '#1088#1072#1089#1087#1086#1079#1085#1072#1074#1072#1085#1080#1103
      end
      item
        Caption = ' '#1053#1072#1089#1090#1088#1086#1081#1082#1080' '#1089#1086#1077#1076#1080#1085#1077#1085#1080#1103
      end
      item
        Caption = ' '#1050#1086#1084#1072#1085#1076#1099
      end
      item
        Caption = ' '#1043#1086#1088#1103#1095#1080#1077' '#1082#1083#1072#1074#1080#1096#1080
      end
      item
        Caption = ' '#1055#1077#1088#1077#1076#1072#1095#1072' '#1090#1077#1082#1089#1090#1072
      end
      item
        Caption = ' '#1050#1086#1088#1088#1077#1082#1094#1080#1103' '#1090#1077#1082#1089#1090#1072
      end
      item
        Caption = ' '#1057#1080#1085#1090#1077#1079' '#1075#1086#1083#1086#1089#1072
      end
      item
        Caption = ' '#1054' '#1087#1088#1086#1075#1088#1072#1084#1084#1077
      end>
    TabOrder = 3
    OnClick = SettingtButtonGroupClick
    OnKeyUp = SettingtButtonGroupKeyUp
    ButtonGradient = False
    Colors.BackColor = clWindow
    Colors.ButtonColor = clWindow
    Colors.ButtonColorFrom = clWindow
    Colors.ButtonColorTo = clWindow
    Colors.ButtonDownColor = 16772054
    Colors.ButtonDownColorFrom = 16772054
    Colors.ButtonDownColorTo = 16772054
    Colors.HotButtonColor = 16772054
    Colors.HotButtonColorFrom = 16772054
    Colors.HotButtonColorTo = 16772054
    Colors.BorderButtonColor = 6956042
    Colors.BorderButtonDownColor = 6956042
    HotTrack = False
    ButtonBorder = True
  end
  object SettingsPageControl: TPageControl
    Left = 167
    Top = 8
    Width = 622
    Height = 429
    ActivePage = TabSheetTextToSpeech
    TabOrder = 0
    object TabSheetSettings: TTabSheet
      Caption = #1054#1073#1097#1080#1077' '#1085#1072#1089#1090#1088#1086#1081#1082#1080
      ImageIndex = 2
      DesignSize = (
        614
        401)
      object GBInterfaceSettings: TGroupBox
        Left = 3
        Top = 64
        Width = 608
        Height = 105
        Anchors = [akLeft, akTop, akRight]
        Caption = ' '#1048#1085#1090#1077#1088#1092#1077#1081#1089' '
        TabOrder = 0
        object LLang: TLabel
          Left = 11
          Top = 73
          Width = 88
          Height = 13
          Caption = #1071#1079#1099#1082' '#1087#1088#1086#1075#1088#1072#1084#1084#1099':'
        end
        object AlphaBlendVar: TLabel
          Left = 386
          Top = 25
          Width = 18
          Height = 13
          Caption = '255'
        end
        object CBShowTrayEvents: TCheckBox
          Left = 11
          Top = 47
          Width = 233
          Height = 17
          Caption = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1074#1089#1087#1083#1099#1074#1072#1102#1097#1080#1077' '#1089#1086#1086#1073#1097#1077#1085#1080#1103
          TabOrder = 2
        end
        object CBAlphaBlend: TCheckBox
          Left = 11
          Top = 24
          Width = 177
          Height = 17
          Caption = #1042#1082#1083#1102#1095#1080#1090#1100' '#1087#1088#1086#1079#1088#1072#1095#1085#1086#1089#1090#1100' '#1086#1082#1086#1085
          TabOrder = 0
          OnClick = CBAlphaBlendClick
        end
        object AlphaBlendTrackBar: TTrackBar
          Left = 194
          Top = 18
          Width = 186
          Height = 23
          Ctl3D = True
          Max = 255
          ParentCtl3D = False
          Frequency = 20
          ShowSelRange = False
          TabOrder = 1
          ThumbLength = 12
          TickMarks = tmTopLeft
          OnChange = AlphaBlendTrackBarChange
        end
        object CBLang: TComboBox
          Left = 105
          Top = 70
          Width = 161
          Height = 21
          Style = csDropDownList
          TabOrder = 3
          OnChange = CBLangChange
        end
      end
      object GBLogs: TGroupBox
        Left = 3
        Top = 175
        Width = 608
        Height = 82
        Anchors = [akLeft, akTop, akRight]
        Caption = ' '#1042#1077#1076#1077#1085#1080#1077' '#1083#1086#1075#1086#1074' '
        TabOrder = 1
        object LErrLogSize: TLabel
          Left = 81
          Top = 47
          Width = 211
          Height = 13
          Caption = #1052#1072#1082#1089#1080#1084#1072#1083#1100#1085#1099#1081' '#1088#1072#1079#1084#1077#1088' '#1083#1086#1075'-'#1092#1072#1081#1083#1072' ('#1050#1073#1072#1081#1090')'
        end
        object SEErrLogSize: TSpinEdit
          Left = 11
          Top = 42
          Width = 64
          Height = 22
          MaxValue = 1024
          MinValue = 1
          TabOrder = 0
          Value = 1
        end
        object CBEnableLogs: TCheckBox
          Left = 11
          Top = 19
          Width = 350
          Height = 17
          Caption = #1042#1082#1083#1102#1095#1080#1090#1100' '#1074#1077#1076#1077#1085#1080#1077' '#1083#1086#1075#1086#1074
          TabOrder = 1
          OnClick = CBEnableLogsClick
        end
      end
      object GBMainSettings: TGroupBox
        Left = 3
        Top = 3
        Width = 608
        Height = 55
        Caption = ' '#1054#1073#1097#1077#1077' '
        TabOrder = 2
        object CBAutoRunMSpeech: TCheckBox
          Left = 11
          Top = 24
          Width = 574
          Height = 17
          Caption = #1047#1072#1087#1091#1089#1082#1072#1090#1100' MSpeech '#1087#1088#1080' '#1074#1093#1086#1076#1077' '#1074' '#1089#1080#1089#1090#1077#1084#1091
          TabOrder = 0
        end
      end
    end
    object TabSheetRecord: TTabSheet
      Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080' '#1079#1072#1087#1080#1089#1080
      ImageIndex = 5
      DesignSize = (
        614
        401)
      object GBRecordSettings: TGroupBox
        Left = 3
        Top = 0
        Width = 608
        Height = 398
        Anchors = [akLeft, akTop, akRight, akBottom]
        Caption = ' '#1053#1072#1089#1090#1088#1086#1081#1082#1080' '#1079#1072#1087#1080#1089#1080' '
        TabOrder = 0
        object LMaxLevel: TLabel
          Left = 16
          Top = 59
          Width = 268
          Height = 13
          Caption = #1052#1072#1082#1089#1080#1084#1072#1083#1100#1085#1099#1081' '#1091#1088#1086#1074#1077#1085#1100' '#1089#1080#1075#1085#1072#1083#1072' '#1076#1083#1103'  '#1085#1072#1095#1072#1083#1072' '#1079#1072#1087#1080#1089#1080':'
        end
        object LMaxLevelInterrupt: TLabel
          Left = 16
          Top = 81
          Width = 305
          Height = 13
          Caption = #1050#1086#1083'. '#1089#1088#1072#1073#1072#1090#1099#1074#1072#1085#1080#1081' '#1085#1072' '#1084#1072#1082#1089'-'#1099#1081' '#1091#1088#1086#1074#1077#1085#1100' '#1076#1083#1103' '#1085#1072#1095#1072#1083#1072' '#1079#1072#1087#1080#1089#1080':'
        end
        object LMinLevel: TLabel
          Left = 16
          Top = 105
          Width = 321
          Height = 13
          Caption = #1052#1080#1085#1080#1084#1072#1083#1100#1085#1099#1081' '#1091#1088#1086#1074#1077#1085#1100' '#1089#1080#1075#1085#1072#1083#1072' '#1076#1083#1103'  '#1085#1072#1095#1072#1083#1072' '#1072#1074#1090#1086'-'#1088#1072#1089#1087#1086#1079#1085#1072#1085#1080#1103':'
        end
        object LEMinLevelInterrupt: TLabel
          Left = 16
          Top = 127
          Width = 358
          Height = 13
          Caption = #1050#1086#1083'. '#1089#1088#1072#1073#1072#1090#1099#1074#1072#1085#1080#1081' '#1085#1072' '#1084#1080#1085'-'#1099#1081' '#1091#1088#1086#1074#1077#1085#1100' '#1076#1083#1103' '#1085#1072#1095#1072#1083#1072' '#1072#1074#1090#1086'-'#1088#1072#1089#1087#1086#1079#1085#1072#1085#1080#1103':'
        end
        object LDevice: TLabel
          Left = 16
          Top = 24
          Width = 52
          Height = 13
          Caption = #1048#1089#1090#1086#1095#1085#1080#1082':'
        end
        object LStopRecordAction: TLabel
          Left = 16
          Top = 155
          Width = 201
          Height = 13
          Caption = #1044#1077#1081#1089#1090#1074#1080#1077' '#1082#1085#1086#1087#1082#1080' "'#1054#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1079#1072#1087#1080#1089#1100'":'
        end
        object EMaxLevel: TEdit
          Left = 441
          Top = 55
          Width = 25
          Height = 21
          NumbersOnly = True
          TabOrder = 2
          Text = '0'
          OnKeyDown = EMaxLevelKeyDown
        end
        object UpDownMaxLevel: TUpDown
          Left = 466
          Top = 55
          Width = 16
          Height = 21
          Associate = EMaxLevel
          TabOrder = 3
          OnClick = UpDownMaxLevelClick
        end
        object CBMaxLevelControl: TCheckBox
          Left = 487
          Top = 57
          Width = 98
          Height = 17
          Caption = #1040#1074#1090#1086'-'#1079#1072#1087#1080#1089#1100
          TabOrder = 4
          OnClick = CBMaxLevelControlClick
        end
        object EMinLevelInterrupt: TEdit
          Left = 441
          Top = 123
          Width = 25
          Height = 21
          NumbersOnly = True
          TabOrder = 9
          Text = '0'
          OnKeyDown = EMinLevelInterruptKeyDown
        end
        object UpDownMinLevelInterrupt: TUpDown
          Left = 466
          Top = 123
          Width = 16
          Height = 21
          Associate = EMinLevelInterrupt
          TabOrder = 10
          OnClick = UpDownMinLevelInterruptClick
        end
        object UpDownMaxLevelInterrupt: TUpDown
          Left = 466
          Top = 78
          Width = 16
          Height = 21
          Associate = EMaxLevelInterrupt
          TabOrder = 6
          OnClick = UpDownMaxLevelInterruptClick
        end
        object UpDownMinLevel: TUpDown
          Left = 466
          Top = 101
          Width = 16
          Height = 21
          Associate = EMinLevel
          TabOrder = 8
          OnClick = UpDownMinLevelClick
        end
        object EMinLevel: TEdit
          Left = 441
          Top = 101
          Width = 25
          Height = 21
          NumbersOnly = True
          TabOrder = 7
          Text = '0'
          OnKeyDown = EMinLevelKeyDown
        end
        object StaticTextMinLevel: TStaticText
          Left = 487
          Top = 102
          Width = 40
          Height = 20
          Alignment = taCenter
          AutoSize = False
          BorderStyle = sbsSunken
          Caption = '0'
          TabOrder = 12
        end
        object StaticTextMaxLevelInterrupt: TStaticText
          Left = 487
          Top = 78
          Width = 40
          Height = 20
          Alignment = taCenter
          AutoSize = False
          BorderStyle = sbsSunken
          Caption = '0'
          TabOrder = 13
        end
        object StaticTextMinLevelInterrupt: TStaticText
          Left = 487
          Top = 124
          Width = 40
          Height = 20
          Alignment = taCenter
          AutoSize = False
          BorderStyle = sbsSunken
          Caption = '0'
          TabOrder = 14
        end
        object EMaxLevelInterrupt: TEdit
          Left = 441
          Top = 78
          Width = 25
          Height = 21
          NumbersOnly = True
          TabOrder = 5
          Text = '0'
          OnKeyDown = EMaxLevelInterruptKeyDown
        end
        object CBDevice: TComboBox
          Left = 74
          Top = 21
          Width = 361
          Height = 21
          Style = csDropDownList
          TabOrder = 0
          OnChange = CBDeviceChange
        end
        object MicSettingsButton: TButton
          Left = 441
          Top = 19
          Width = 137
          Height = 25
          Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080' '#1084#1080#1082#1088#1086#1092#1086#1085#1072
          TabOrder = 1
          OnClick = MicSettingsButtonClick
        end
        object CBStopRecordAction: TComboBox
          Left = 223
          Top = 152
          Width = 350
          Height = 21
          Style = csDropDownList
          TabOrder = 11
          OnChange = CBStopRecordActionChange
        end
        object CBEnableFilters: TCheckBox
          Left = 16
          Top = 179
          Width = 321
          Height = 17
          Caption = #1042#1082#1083#1102#1095#1080#1090#1100' '#1092#1080#1083#1100#1090#1088#1072#1094#1080#1102' '#1079#1074#1091#1082#1072
          TabOrder = 15
          Visible = False
          OnClick = CBEnableFiltersClick
        end
        object GBFilters: TGroupBox
          Left = 16
          Top = 202
          Width = 577
          Height = 193
          Caption = ' '#1053#1072#1089#1090#1088#1086#1081#1082#1080' '#1092#1080#1083#1100#1090#1088#1086#1074' '
          TabOrder = 16
          object RGFiltersType: TRadioGroup
            Left = 16
            Top = 16
            Width = 252
            Height = 62
            Caption = ' '#1058#1080#1087' '#1092#1080#1083#1100#1090#1088#1072' '
            ItemIndex = 0
            Items.Strings = (
              'Sinc Filter'
              'Voice Filter (Only for Windows 7 and above)')
            TabOrder = 0
            OnClick = RGFiltersTypeClick
          end
          object GBWindowedSincFilter: TGroupBox
            Left = 274
            Top = 15
            Width = 239
            Height = 138
            Caption = ' '#1053#1072#1089#1090#1088#1086#1081#1082#1080' Sinc Filter '
            TabOrder = 1
            object LSincFilterType: TLabel
              Left = 16
              Top = 24
              Width = 69
              Height = 13
              Caption = #1058#1080#1087' '#1092#1080#1083#1100#1090#1088#1072':'
            end
            object LLowFreq: TLabel
              Left = 16
              Top = 51
              Width = 45
              Height = 13
              Caption = 'LowFreq:'
            end
            object LHighFreq: TLabel
              Left = 124
              Top = 51
              Width = 47
              Height = 13
              Caption = 'HighFreq:'
            end
            object LKernelWidth: TLabel
              Left = 17
              Top = 78
              Width = 62
              Height = 13
              Caption = 'KernelWidth:'
            end
            object LWindowType: TLabel
              Left = 16
              Top = 107
              Width = 66
              Height = 13
              Caption = 'WindowType:'
            end
            object CBSincFilterType: TComboBox
              Left = 91
              Top = 21
              Width = 86
              Height = 21
              Style = csDropDownList
              ItemIndex = 0
              TabOrder = 0
              Text = 'ftAllPass'
              Items.Strings = (
                'ftAllPass'
                'ftBandPass'
                'ftBandReject'
                'ftHighPass'
                'ftLowPass')
            end
            object ELowFreq: TEdit
              Left = 64
              Top = 48
              Width = 50
              Height = 21
              MaxLength = 5
              NumbersOnly = True
              TabOrder = 1
              Text = '300'
            end
            object EHighFreq: TEdit
              Left = 175
              Top = 48
              Width = 50
              Height = 21
              MaxLength = 5
              NumbersOnly = True
              TabOrder = 2
              Text = '4000'
            end
            object EKernelWidth: TEdit
              Left = 85
              Top = 75
              Width = 28
              Height = 21
              MaxLength = 3
              NumbersOnly = True
              TabOrder = 3
              Text = '32'
            end
            object CBWindowType: TComboBox
              Left = 91
              Top = 102
              Width = 86
              Height = 21
              Style = csDropDownList
              ItemIndex = 0
              TabOrder = 4
              Text = 'fwBlackman'
              Items.Strings = (
                'fwBlackman'
                'fwHamming'
                'fwHann')
            end
          end
          object GBVoiceFilter: TGroupBox
            Left = 16
            Top = 85
            Width = 287
            Height = 101
            Caption = ' '#1053#1072#1089#1090#1088#1086#1081#1082#1080' Voice Filter '
            TabOrder = 2
            object CBVoiceFilterEnableAGC: TCheckBox
              Left = 16
              Top = 23
              Width = 249
              Height = 17
              Caption = #1042#1082#1083#1102#1095#1080#1090#1100' AGC (Automatic gain control)'
              TabOrder = 0
            end
            object CBVoiceFilterEnableNoiseReduction: TCheckBox
              Left = 16
              Top = 46
              Width = 249
              Height = 17
              Caption = #1042#1082#1083#1102#1095#1080#1090#1100' '#1087#1086#1076#1072#1074#1083#1077#1085#1080#1077' '#1096#1091#1084#1072' (Noise reduction)'
              TabOrder = 1
            end
            object CBVoiceFilterEnableVAD: TCheckBox
              Left = 16
              Top = 69
              Width = 249
              Height = 17
              Caption = #1042#1082#1083#1102#1095#1080#1090#1100' VAD (Voice Activity Detection)'
              TabOrder = 2
            end
          end
        end
      end
    end
    object TabSheetRecognize: TTabSheet
      Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080' '#1088#1072#1089#1087#1086#1079#1085#1072#1074#1072#1085#1080#1103
      ImageIndex = 8
      object GBRecognizeSettings: TGroupBox
        Left = 3
        Top = 0
        Width = 608
        Height = 398
        Caption = ' '#1053#1072#1089#1090#1088#1086#1082#1080' '#1088#1072#1089#1087#1086#1079#1085#1072#1074#1072#1085#1080#1103' '#1088#1077#1095#1080' '
        TabOrder = 0
        object LFirstRegion: TLabel
          Left = 16
          Top = 53
          Width = 187
          Height = 13
          Caption = #1054#1089#1085#1086#1074#1085#1086#1081' '#1103#1079#1099#1082' '#1088#1072#1089#1087#1086#1079#1085#1072#1074#1072#1085#1080#1103' '#1088#1077#1095#1080':'
        end
        object LSecondRegion: TLabel
          Left = 16
          Top = 80
          Width = 180
          Height = 13
          Caption = #1044#1086#1087#1086#1083#1085'. '#1103#1079#1099#1082' '#1088#1072#1089#1087#1086#1079#1085#1072#1074#1072#1085#1080#1103' '#1088#1077#1095#1080':'
        end
        object LASR: TLabel
          Left = 16
          Top = 26
          Width = 143
          Height = 13
          Caption = #1052#1077#1090#1086#1076' '#1088#1072#1089#1087#1086#1079#1085#1072#1074#1072#1085#1080#1103' '#1088#1077#1095#1080':'
        end
        object LSpeechAPIKey: TLabel
          Left = 16
          Top = 107
          Width = 157
          Height = 13
          Caption = #1042#1072#1096' '#1082#1083#1102#1095' '#1082' Google Speech API:'
        end
        object CBFirstRegion: TComboBox
          Left = 209
          Top = 50
          Width = 277
          Height = 21
          Style = csDropDownList
          TabOrder = 0
          Items.Strings = (
            'Afrikaans'
            'Bahasa Indonesia'
            'Bahasa Melayu'
            'Catal'#224
            #268'e'#353'tina'
            'Deutsch'
            'English - Australia'
            'English - Canada'
            'English - India'
            'English - New Zealand'
            'English - South Africa'
            'English - United Kingdom'
            'English - United States'
            'Espa'#241'ol - Argentina'
            'Espa'#241'ol - Bolivia'
            'Espa'#241'ol - Chile'
            'Espa'#241'ol - Colombia'
            'Espa'#241'ol - Costa Rica'
            'Espa'#241'ol - Ecuador'
            'Espa'#241'ol - El Salvador'
            'Espa'#241'ol - Espa'#241'a'
            'Espa'#241'ol - Estados Unidos'
            'Espa'#241'ol - Guatemala'
            'Espa'#241'ol - Honduras'
            'Espa'#241'ol - M'#233'xico'
            'Espa'#241'ol - Nicaragua'
            'Espa'#241'ol - Panam'#225
            'Espa'#241'ol - Paraguay'
            'Espa'#241'ol - Per'#250
            'Espa'#241'ol - Puerto Rico'
            'Espa'#241'ol - Rep'#250'blica Dominicana'
            'Espa'#241'ol - Uruguay'
            'Espa'#241'ol - Venezuela'
            'Euskara'
            'Fran'#231'ais'
            'Galego'
            'Hebrew'
            'Hrvatski'
            'IsiZulu'
            #205'slenska'
            'Italiano - Italia'
            'Italiano - Svizzera'
            'Magyar'
            'Nederlands'
            'Norsk bokm'#229'l'
            'Polski'
            'Portugu'#234's - Brasil'
            'Portugu'#234's - Portugal'
            'Rom'#226'n'#259
            'Sloven'#269'ina'
            'Suomi'
            'Svenska'
            'T'#252'rk'#231'e'
            #1073#1098#1083#1075#1072#1088#1089#1082#1080
            'P'#1091#1089#1089#1082#1080#1081
            #1057#1088#1087#1089#1082#1080
            'Korean'
            'Mandarin Chinese (Simplified)'
            'Hong Kong Chinese (Simplified)'
            'Taiwan Chinese (Traditional)'
            'Hong Kong Chinese (Traditional)'
            'Japanese'
            'Lingua lat'#299'na')
        end
        object CBSecondRegion: TComboBox
          Left = 209
          Top = 77
          Width = 277
          Height = 21
          Style = csDropDownList
          TabOrder = 1
          Items.Strings = (
            'Afrikaans'
            'Bahasa Indonesia'
            'Bahasa Melayu'
            'Catal'#224
            #268'e'#353'tina'
            'Deutsch'
            'English - Australia'
            'English - Canada'
            'English - India'
            'English - New Zealand'
            'English - South Africa'
            'English - United Kingdom'
            'English - United States'
            'Espa'#241'ol - Argentina'
            'Espa'#241'ol - Bolivia'
            'Espa'#241'ol - Chile'
            'Espa'#241'ol - Colombia'
            'Espa'#241'ol - Costa Rica'
            'Espa'#241'ol - Ecuador'
            'Espa'#241'ol - El Salvador'
            'Espa'#241'ol - Espa'#241'a'
            'Espa'#241'ol - Estados Unidos'
            'Espa'#241'ol - Guatemala'
            'Espa'#241'ol - Honduras'
            'Espa'#241'ol - M'#233'xico'
            'Espa'#241'ol - Nicaragua'
            'Espa'#241'ol - Panam'#225
            'Espa'#241'ol - Paraguay'
            'Espa'#241'ol - Per'#250
            'Espa'#241'ol - Puerto Rico'
            'Espa'#241'ol - Rep'#250'blica Dominicana'
            'Espa'#241'ol - Uruguay'
            'Espa'#241'ol - Venezuela'
            'Euskara'
            'Fran'#231'ais'
            'Galego'
            'Hebrew'
            'Hrvatski'
            'IsiZulu'
            #205'slenska'
            'Italiano - Italia'
            'Italiano - Svizzera'
            'Magyar'
            'Nederlands'
            'Norsk bokm'#229'l'
            'Polski'
            'Portugu'#234's - Brasil'
            'Portugu'#234's - Portugal'
            'Rom'#226'n'#259
            'Sloven'#269'ina'
            'Suomi'
            'Svenska'
            'T'#252'rk'#231'e'
            #1073#1098#1083#1075#1072#1088#1089#1082#1080
            'P'#1091#1089#1089#1082#1080#1081
            #1057#1088#1087#1089#1082#1080
            'Korean'
            'Mandarin Chinese (Simplified)'
            'Hong Kong Chinese (Simplified)'
            'Taiwan Chinese (Traditional)'
            'Hong Kong Chinese (Traditional)'
            'Japanese'
            'Lingua lat'#299'na')
        end
        object CBASR: TComboBox
          Left = 209
          Top = 23
          Width = 277
          Height = 21
          Style = csDropDownList
          ItemIndex = 0
          TabOrder = 2
          Text = 'Google (Online)'
          Items.Strings = (
            'Google (Online)')
        end
        object ESpeechAPIKey: TEdit
          Left = 209
          Top = 104
          Width = 280
          Height = 21
          TabOrder = 3
        end
        object GBAPINotes: TGroupBox
          Left = 16
          Top = 126
          Width = 577
          Height = 91
          Caption = ' '#1055#1086#1076#1089#1082#1072#1079#1082#1072' '
          TabOrder = 4
          object LAPINotes: TLabel
            Left = 18
            Top = 19
            Width = 543
            Height = 62
            AutoSize = False
            Caption = 
              #1045#1089#1083#1080' '#1042#1099' '#1085#1077' '#1091#1082#1072#1078#1080#1090#1077' '#1089#1086#1073#1089#1090#1074#1077#1085#1085#1099#1081' '#1082#1083#1102#1095' '#1076#1083#1103' '#1076#1086#1089#1090#1091#1087#1072' '#1082' Speech API, '#1090#1086 +
              ' '#1073#1091#1076#1077#1090' '#1080#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100#1089#1103' '#1087#1091#1073#1083#1080#1095#1085#1099#1081', '#1085#1086' '#1084#1099' '#1085#1077' '#1076#1072#1105#1084' '#1075#1072#1088#1072#1085#1090#1080#1080', '#1095#1090#1086' '#1089' '#1085 +
              #1080#1084' '#1089#1080#1089#1090#1077#1084#1072' '#1088#1072#1089#1087#1086#1079#1085#1072#1074#1072#1085#1080#1103' '#1073#1091#1076#1077#1090' '#1088#1072#1073#1086#1090#1072#1090#1100'. '#1044#1083#1103' '#1087#1086#1083#1091#1095#1077#1085#1080#1103' '#1089#1086#1073#1089#1090#1074#1077#1085#1085 +
              #1086#1075#1086' '#1082#1083#1102#1095#1072' '#1084#1086#1078#1085#1086' '#1074#1086#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100#1089#1103' '#1080#1085#1089#1090#1088#1091#1082#1094#1080#1077#1081' '#1088#1072#1079#1084#1077#1097#1077#1085#1085#1086#1081' '#1085#1072' '#1089#1072#1081#1090#1077 +
              ' https://cloud.google.com/speech/'
            WordWrap = True
          end
        end
        object CBStopRecognitionAfterLockingComputer: TCheckBox
          Left = 16
          Top = 223
          Width = 577
          Height = 17
          Caption = #1054#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1088#1072#1089#1087#1086#1079#1085#1072#1074#1072#1085#1080#1077' '#1087#1086#1089#1083#1077' '#1073#1083#1086#1082#1080#1088#1086#1074#1082#1080' '#1055#1050
          TabOrder = 5
        end
        object CBStartRecognitionAfterUnlockingComputer: TCheckBox
          Left = 16
          Top = 246
          Width = 569
          Height = 17
          Caption = #1047#1072#1087#1091#1089#1090#1080#1090#1100' '#1088#1072#1089#1087#1086#1079#1085#1072#1074#1072#1085#1080#1077' '#1087#1086#1089#1083#1077' '#1088#1072#1079#1073#1083#1086#1082#1080#1088#1086#1074#1082#1080' '#1055#1050
          TabOrder = 6
        end
      end
    end
    object TabSheetConnectSettings: TTabSheet
      Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080' '#1089#1086#1077#1076#1080#1085#1077#1085#1080#1103
      DesignSize = (
        614
        401)
      object GBConnectSettings: TGroupBox
        Left = 3
        Top = 0
        Width = 608
        Height = 398
        Anchors = [akLeft, akTop, akRight, akBottom]
        Caption = ' '#1053#1072#1089#1090#1088#1086#1081#1082#1080' '#1089#1086#1077#1076#1080#1085#1077#1085#1080#1103' '
        TabOrder = 0
        object LProxyAddress: TLabel
          Left = 16
          Top = 47
          Width = 118
          Height = 13
          Caption = #1040#1076#1088#1077#1089' '#1087#1088#1086#1082#1089#1080'-'#1089#1077#1088#1074#1077#1088#1072':'
        end
        object LProxyPort: TLabel
          Left = 267
          Top = 48
          Width = 29
          Height = 13
          Caption = #1055#1086#1088#1090':'
        end
        object LProxyUser: TLabel
          Left = 16
          Top = 98
          Width = 76
          Height = 13
          Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100':'
        end
        object LProxyUserPasswd: TLabel
          Left = 16
          Top = 125
          Width = 41
          Height = 13
          Caption = #1055#1072#1088#1086#1083#1100':'
        end
        object CBUseProxy: TCheckBox
          Left = 16
          Top = 24
          Width = 209
          Height = 17
          Caption = #1057#1086#1077#1076#1080#1085#1103#1090#1100#1089#1103' '#1095#1077#1088#1077#1079' '#1087#1088#1086#1082#1089#1080'-'#1089#1077#1088#1074#1077#1088
          TabOrder = 0
          OnClick = CBUseProxyClick
        end
        object EProxyAddress: TEdit
          Left = 140
          Top = 44
          Width = 121
          Height = 21
          TabOrder = 1
          Text = '127.0.0.1'
        end
        object EProxyPort: TEdit
          Left = 302
          Top = 44
          Width = 73
          Height = 21
          MaxLength = 5
          NumbersOnly = True
          TabOrder = 2
          Text = '3128'
        end
        object EProxyUser: TEdit
          Left = 98
          Top = 95
          Width = 163
          Height = 21
          TabOrder = 4
        end
        object CBProxyAuth: TCheckBox
          Left = 16
          Top = 71
          Width = 233
          Height = 17
          Caption = #1055#1088#1086#1082#1089#1080'-'#1089#1077#1088#1074#1077#1088' '#1090#1088#1077#1073#1091#1077#1090' '#1072#1074#1090#1086#1088#1080#1079#1072#1094#1080#1102
          TabOrder = 3
          OnClick = CBProxyAuthClick
        end
        object EProxyUserPasswd: TEdit
          Left = 98
          Top = 122
          Width = 163
          Height = 21
          PasswordChar = '*'
          TabOrder = 5
        end
      end
    end
    object TabSheetCommand: TTabSheet
      Caption = #1050#1086#1084#1072#1085#1076#1099
      ImageIndex = 7
      DesignSize = (
        614
        401)
      object GBCommand: TGroupBox
        Left = 3
        Top = 32
        Width = 608
        Height = 366
        Anchors = [akLeft, akTop, akRight, akBottom]
        Caption = ' '#1057#1087#1080#1089#1086#1082' '#1082#1086#1084#1072#1085#1076' '
        TabOrder = 1
        DesignSize = (
          608
          366)
        object LCommandKey: TLabel
          Left = 8
          Top = 22
          Width = 88
          Height = 13
          Caption = #1050#1083#1102#1095#1077#1074#1086#1077' '#1089#1083#1086#1074#1086':'
        end
        object LCommandExec: TLabel
          Left = 182
          Top = 22
          Width = 48
          Height = 13
          Caption = #1050#1086#1084#1072#1085#1076#1072':'
        end
        object LCommandType: TLabel
          Left = 431
          Top = 22
          Width = 70
          Height = 13
          Caption = #1058#1080#1087' '#1082#1086#1084#1072#1085#1076#1099':'
        end
        object SBCommandSelect: TSpeedButton
          Left = 404
          Top = 40
          Width = 23
          Height = 22
          Glyph.Data = {
            36040000424D3604000000000000360000002800000010000000100000000100
            20000000000000040000C40E0000C40E00000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000364
            94B6036494B6036494B6036494B6036494B6036494B6036494B6036494B60364
            94B6036494B6036494B6036494B6034C70930000000000000000036EA4A866B8
            DEFF87D1EFFF87D0EFFF87D0EFFF87D0EFFF87D0EFFF87D0EFFF87D0EFFF87D0
            EFFF87D0EFFF87D0EFFF87D1EFFF3896C3EC0357814A000000000378B49B49AB
            D8FF92D9F3FF8DD5F0FF8DD5F0FF8DD5F0FF8DD5F0FF8DD5F0FF8DD5F0FF8DD5
            F0FF8DD5F0FF8DD5F0FF8DD5F0FF77C8E9F6027EBD7D00000000027CB9964EB1
            DFFF8AD8F2FF9CE2F8FF9CE2F8FF9CE2F8FF9CE2F8FF9CE2F8FF9CE2F8FF9CE2
            F8FF9CE2F8FF9CE2F8FF9CE2F8FFA0E6FAFF289DD49D0287CA23027FBE9272C8
            ECFF6AC7EBFFADF1FEFFADF1FEFFADF1FEFFADF1FEFFADF1FEFFADF1FEFFADF1
            FEFFADF1FEFFADF1FEFFADF1FEFFADF1FEFF6FCEEEC8028DD2540282C28E8FD9
            F4FF4BB5E6FF4BB5E6FF4BB5E6FF4BB5E6FF4BB5E6FF4BB5E6FF4BB5E6FF4BB5
            E6FF4BB5E6FF4BB5E6FF4FB8E8FF028BD1C40291DA7A0291D95C0285C78A99E0
            F6FF92DAF3FF92DAF3FF92DAF3FF92DAF3FF92DAF3FF92DAF3FF92DAF3FF92DA
            F3FF92DAF3FF92DAF3FF99E0F6FF0285C78A00000000000000000288CB869FE5
            F9FF98DFF6FF98DFF6FF98DFF6FF98DFF6FF98DFF6FF98DFF6FF98DFF6FF98DF
            F6FF98DFF6FF98DFF6FF9FE5F9FF0288CB860000000000000000028ACF83A3E9
            FBFF9DE3F9FF9DE3F9FF9DE3F9FF9DE3F9FF9DE3F9FF9DE3F9FF9DE3F9FF9DE3
            F9FF9DE3F9FF9DE3F9FFA3E9FBFF028ACF830000000000000000028DD280A8ED
            FDFFA2E7FBFFA2E7FBFFA2E7FBFFA2E7FBFFA2E7FBFFA2E7FBFFA2E7FBFFA2E7
            FBFFA2E7FBFFA2E7FBFFA8EDFDFF028DD2800000000000000000028FD67DAEF3
            FFFFABF0FEFFABF0FEFFABF0FEFFABF0FEFFABF0FEFFABF0FEFFABF0FEFFABF0
            FEFFABF0FEFFABF0FEFFAEF3FFFF028FD67D00000000000000000291D95C0291
            D97B0291D97B0291D97B0291D97B0291D97B0291D97BFEFEFDFFF5F5EEFFEBEB
            DDFFFEC941FFF4B62EFF0291D97B0291D95C0000000000000000000000000000
            0000000000000000000000000000000000000292DB2B0292DB790292DB790292
            DB790292DB790292DB790292DB2B000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000}
          OnClick = SBCommandSelectClick
        end
        object LDefaultCommandExec: TLabel
          Left = 8
          Top = 341
          Width = 124
          Height = 13
          Caption = #1050#1086#1084#1072#1085#1076#1072' '#1087#1086'-'#1091#1084#1086#1083#1095#1072#1085#1080#1102':'
        end
        object LDefaultCommandExecDesc: TLabel
          Left = 304
          Top = 341
          Width = 259
          Height = 13
          Caption = #1042#1099#1087#1086#1083#1085#1103#1077#1090#1089#1103' '#1077#1089#1083#1080' '#1085#1077' '#1085#1072#1081#1076#1077#1085#1099' '#1082#1086#1084#1072#1085#1076#1099' '#1080#1079' '#1089#1087#1080#1089#1082#1072'.'
        end
        object SBDefaultCommandSelect: TSpeedButton
          Left = 275
          Top = 337
          Width = 23
          Height = 22
          Glyph.Data = {
            36040000424D3604000000000000360000002800000010000000100000000100
            20000000000000040000C40E0000C40E00000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000364
            94B6036494B6036494B6036494B6036494B6036494B6036494B6036494B60364
            94B6036494B6036494B6036494B6034C70930000000000000000036EA4A866B8
            DEFF87D1EFFF87D0EFFF87D0EFFF87D0EFFF87D0EFFF87D0EFFF87D0EFFF87D0
            EFFF87D0EFFF87D0EFFF87D1EFFF3896C3EC0357814A000000000378B49B49AB
            D8FF92D9F3FF8DD5F0FF8DD5F0FF8DD5F0FF8DD5F0FF8DD5F0FF8DD5F0FF8DD5
            F0FF8DD5F0FF8DD5F0FF8DD5F0FF77C8E9F6027EBD7D00000000027CB9964EB1
            DFFF8AD8F2FF9CE2F8FF9CE2F8FF9CE2F8FF9CE2F8FF9CE2F8FF9CE2F8FF9CE2
            F8FF9CE2F8FF9CE2F8FF9CE2F8FFA0E6FAFF289DD49D0287CA23027FBE9272C8
            ECFF6AC7EBFFADF1FEFFADF1FEFFADF1FEFFADF1FEFFADF1FEFFADF1FEFFADF1
            FEFFADF1FEFFADF1FEFFADF1FEFFADF1FEFF6FCEEEC8028DD2540282C28E8FD9
            F4FF4BB5E6FF4BB5E6FF4BB5E6FF4BB5E6FF4BB5E6FF4BB5E6FF4BB5E6FF4BB5
            E6FF4BB5E6FF4BB5E6FF4FB8E8FF028BD1C40291DA7A0291D95C0285C78A99E0
            F6FF92DAF3FF92DAF3FF92DAF3FF92DAF3FF92DAF3FF92DAF3FF92DAF3FF92DA
            F3FF92DAF3FF92DAF3FF99E0F6FF0285C78A00000000000000000288CB869FE5
            F9FF98DFF6FF98DFF6FF98DFF6FF98DFF6FF98DFF6FF98DFF6FF98DFF6FF98DF
            F6FF98DFF6FF98DFF6FF9FE5F9FF0288CB860000000000000000028ACF83A3E9
            FBFF9DE3F9FF9DE3F9FF9DE3F9FF9DE3F9FF9DE3F9FF9DE3F9FF9DE3F9FF9DE3
            F9FF9DE3F9FF9DE3F9FFA3E9FBFF028ACF830000000000000000028DD280A8ED
            FDFFA2E7FBFFA2E7FBFFA2E7FBFFA2E7FBFFA2E7FBFFA2E7FBFFA2E7FBFFA2E7
            FBFFA2E7FBFFA2E7FBFFA8EDFDFF028DD2800000000000000000028FD67DAEF3
            FFFFABF0FEFFABF0FEFFABF0FEFFABF0FEFFABF0FEFFABF0FEFFABF0FEFFABF0
            FEFFABF0FEFFABF0FEFFAEF3FFFF028FD67D00000000000000000291D95C0291
            D97B0291D97B0291D97B0291D97B0291D97B0291D97BFEFEFDFFF5F5EEFFEBEB
            DDFFFEC941FFF4B62EFF0291D97B0291D95C0000000000000000000000000000
            0000000000000000000000000000000000000292DB2B0292DB790292DB790292
            DB790292DB790292DB790292DB2B000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000}
          OnClick = SBDefaultCommandSelectClick
        end
        object ECommandKey: TEdit
          Left = 8
          Top = 41
          Width = 172
          Height = 21
          TabOrder = 0
          OnKeyUp = ECommandKeyKeyUp
        end
        object ECommandExec: TEdit
          Left = 181
          Top = 41
          Width = 220
          Height = 21
          TabOrder = 1
          OnKeyUp = ECommandExecKeyUp
        end
        object CommandStringGrid: TStringGrid
          Left = 8
          Top = 66
          Width = 567
          Height = 231
          Anchors = [akLeft, akTop, akRight]
          ColCount = 3
          DefaultColWidth = 150
          DefaultRowHeight = 18
          DrawingStyle = gdsClassic
          FixedCols = 0
          RowCount = 1
          FixedRows = 0
          Options = [goFixedVertLine, goFixedHorzLine, goRangeSelect, goColSizing, goRowSelect]
          TabOrder = 2
          OnSelectCell = CommandStringGridSelectCell
          ColWidths = (
            150
            150
            150)
          RowHeights = (
            18)
        end
        object AddCommandButton: TButton
          Left = 8
          Top = 303
          Width = 85
          Height = 25
          Caption = #1044#1086#1073#1072#1074#1080#1090#1100
          Enabled = False
          ImageIndex = 6
          Images = ImageList_Main
          TabOrder = 3
          OnClick = AddCommandButtonClick
        end
        object DeleteCommandButton: TButton
          Left = 190
          Top = 303
          Width = 85
          Height = 25
          Caption = #1059#1076#1072#1083#1080#1090#1100
          Enabled = False
          ImageIndex = 7
          Images = ImageList_Main
          TabOrder = 4
          OnClick = DeleteCommandButtonClick
        end
        object CBCommandType: TComboBox
          Left = 431
          Top = 41
          Width = 144
          Height = 21
          Style = csDropDownList
          TabOrder = 5
          OnChange = CBCommandTypeChange
          Items.Strings = (
            #1047#1072#1087#1091#1089#1090#1080#1090#1100' '#1087#1088#1086#1075#1088#1072#1084#1084#1091)
        end
        object ChangeCommandButton: TButton
          Left = 99
          Top = 303
          Width = 85
          Height = 25
          Caption = #1048#1079#1084#1077#1085#1080#1090#1100
          Enabled = False
          ImageIndex = 9
          Images = ImageList_Main
          TabOrder = 6
          OnClick = ChangeCommandButtonClick
        end
        object EDefaultCommandExec: TEdit
          Left = 138
          Top = 338
          Width = 136
          Height = 21
          TabOrder = 7
        end
      end
      object CBEnableExecCommand: TCheckBox
        Left = 3
        Top = 10
        Width = 465
        Height = 17
        Caption = #1042#1082#1083#1102#1095#1080#1090#1100' '#1074#1099#1087#1086#1083#1085#1077#1085#1080#1077' '#1082#1086#1084#1072#1085#1076
        TabOrder = 0
        OnClick = CBEnableExecCommandClick
      end
    end
    object TabSheetHotKey: TTabSheet
      Caption = #1043#1086#1088#1103#1095#1080#1077' '#1082#1083#1072#1074#1080#1096#1080
      ImageIndex = 3
      DesignSize = (
        614
        401)
      object CBEnableHotKey: TCheckBox
        Left = 3
        Top = 10
        Width = 231
        Height = 17
        Caption = #1042#1082#1083#1102#1095#1080#1090#1100' '#1087#1086#1076#1076#1077#1088#1078#1082#1091' '#1075#1086#1088#1103#1095#1080#1093' '#1082#1083#1072#1074#1080#1096
        TabOrder = 0
        OnClick = CBEnableHotKeyClick
      end
      object GBHotKey: TGroupBox
        Left = 3
        Top = 33
        Width = 608
        Height = 365
        Anchors = [akLeft, akTop, akRight, akBottom]
        Caption = ' '#1043#1086#1088#1103#1095#1080#1077' '#1082#1083#1072#1074#1080#1096#1080' '
        TabOrder = 1
        Visible = False
        DesignSize = (
          608
          365)
        object HotKetStringGrid: TStringGrid
          Left = 16
          Top = 24
          Width = 577
          Height = 81
          Anchors = [akLeft, akTop, akRight]
          ColCount = 2
          DefaultColWidth = 150
          DefaultRowHeight = 18
          DrawingStyle = gdsClassic
          FixedCols = 0
          RowCount = 2
          FixedRows = 0
          Options = [goFixedVertLine, goFixedHorzLine, goRangeSelect, goColSizing, goRowSelect]
          TabOrder = 0
          OnSelectCell = HotKetStringGridSelectCell
          ColWidths = (
            296
            133)
          RowHeights = (
            18
            18)
        end
        object IMHotKey: THotKey
          Left = 16
          Top = 114
          Width = 153
          Height = 19
          HotKey = 32833
          TabOrder = 1
        end
        object SetHotKeyButton: TButton
          Left = 182
          Top = 111
          Width = 91
          Height = 25
          Caption = #1053#1072#1079#1085#1072#1095#1080#1090#1100
          ImageIndex = 4
          Images = ImageList_Main
          TabOrder = 2
          OnClick = SetHotKeyButtonClick
        end
        object DeleteHotKeyButton: TButton
          Left = 279
          Top = 111
          Width = 93
          Height = 25
          Caption = #1059#1076#1072#1083#1080#1090#1100
          ImageIndex = 5
          Images = ImageList_Main
          TabOrder = 3
          OnClick = DeleteHotKeyButtonClick
        end
      end
    end
    object TabSheetSendText: TTabSheet
      Caption = #1055#1077#1088#1077#1076#1072#1095#1072' '#1090#1077#1082#1089#1090#1072
      ImageIndex = 4
      DesignSize = (
        614
        401)
      object GBSendText: TGroupBox
        Left = 3
        Top = 33
        Width = 608
        Height = 365
        Anchors = [akLeft, akTop, akRight, akBottom]
        Caption = ' '#1053#1072#1089#1090#1088#1086#1081#1082#1072' '#1087#1077#1088#1077#1076#1072#1095#1080' '#1090#1077#1082#1089#1090#1072' '#1074' '#1087#1086#1083#1103' '#1074#1074#1086#1076#1072' '#1076#1088#1091#1075#1080#1093' '#1087#1088#1086#1075#1088#1072#1084#1084' '
        TabOrder = 1
        Visible = False
        object LClassName: TLabel
          Left = 12
          Top = 51
          Width = 216
          Height = 13
          Caption = #1050#1083#1072#1089#1089' '#1087#1086#1083#1103' '#1074#1074#1086#1076#1072' '#1087#1088#1086#1075#1088#1072#1084#1084#1099'-'#1087#1086#1083#1091#1095#1072#1090#1077#1083#1103':'
        end
        object LNote: TLabel
          Left = 12
          Top = 125
          Width = 537
          Height = 38
          AutoSize = False
          Caption = 
            #1042#1053#1048#1052#1040#1053#1048#1045'! '#1056#1072#1089#1087#1086#1079#1085#1072#1085#1085#1099#1081' '#1090#1077#1082#1089#1090' '#1073#1091#1076#1077#1090' '#1087#1077#1088#1077#1076#1072#1074#1072#1090#1100#1089#1103' '#1074' '#1072#1082#1090#1080#1074#1085#1086#1077' '#1086#1082#1085#1086' ' +
            #1087#1088#1086#1075#1088#1072#1084#1084#1099'. '#1050#1083#1072#1089#1089' '#1087#1086#1083#1103' '#1074#1074#1086#1076#1072' '#1084#1086#1078#1085#1086' '#1086#1089#1090#1072#1074#1080#1090#1100' '#1087#1091#1089#1090#1099#1084' '#1080#1083#1080' '#1086#1087#1088#1077#1076#1077#1083#1080#1090#1100 +
            ' '#1089' '#1087#1086#1084#1086#1097#1100#1102' '#1076#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1086#1081' '#1087#1088#1086#1075#1088#1072#1084#1084#1099' SearchApplicationClassName.e' +
            'xe'
          WordWrap = True
        end
        object LMethodSendingText: TLabel
          Left = 12
          Top = 24
          Width = 126
          Height = 13
          Caption = #1052#1077#1090#1086#1076' '#1086#1090#1087#1088#1072#1074#1082#1080' '#1090#1077#1082#1089#1090#1072':'
        end
        object LInactiveWindowCaption: TLabel
          Left = 12
          Top = 78
          Width = 205
          Height = 13
          Caption = #1047#1072#1075#1086#1083#1086#1074#1086#1082' '#1086#1082#1085#1072' '#1087#1088#1086#1075#1088#1072#1084#1084#1099' '#1087#1086#1083#1091#1095#1072#1090#1077#1083#1103':'
          Enabled = False
        end
        object EClassNameReciver: TEdit
          Left = 234
          Top = 48
          Width = 315
          Height = 21
          TabOrder = 1
        end
        object CBMethodSendingText: TComboBox
          Left = 234
          Top = 21
          Width = 315
          Height = 21
          Style = csDropDownList
          TabOrder = 0
          OnChange = CBMethodSendingTextChange
          Items.Strings = (
            'WM_SETTEXT + EM_REPLACESEL'
            'WM_PASTE'
            'WM_CHAR'
            'WM_PASTE (MOD)')
        end
        object CBEnableSendTextInactiveWindow: TCheckBox
          Left = 12
          Top = 102
          Width = 413
          Height = 17
          Caption = #1054#1090#1087#1088#1072#1074#1083#1103#1090#1100' '#1090#1077#1082#1089#1090' '#1074' '#1085#1077#1072#1082#1090#1080#1074#1085#1086#1077' '#1086#1082#1085#1086' '#1087#1088#1086#1075#1088#1072#1084#1084#1099' (WM_COPYDATA)'
          TabOrder = 2
          OnClick = CBEnableSendTextInactiveWindowClick
        end
        object EInactiveWindowCaption: TEdit
          Left = 234
          Top = 75
          Width = 315
          Height = 21
          Enabled = False
          TabOrder = 3
        end
      end
      object CBEnableSendText: TCheckBox
        Left = 3
        Top = 10
        Width = 465
        Height = 17
        Caption = #1042#1082#1083#1102#1095#1080#1090#1100' '#1087#1077#1088#1077#1076#1072#1095#1091' '#1090#1077#1082#1089#1090#1072' '#1074' '#1087#1086#1083#1103' '#1074#1074#1086#1076#1072' '#1076#1088#1091#1075#1080#1093' '#1087#1088#1086#1075#1088#1072#1084#1084
        TabOrder = 0
        OnClick = CBEnableSendTextClick
      end
    end
    object TabSheetTextCorrection: TTabSheet
      Caption = #1050#1086#1088#1088#1077#1082#1094#1080#1103' '#1090#1077#1082#1089#1090#1072
      ImageIndex = 6
      DesignSize = (
        614
        401)
      object GBTextCorrection: TGroupBox
        Left = 3
        Top = 33
        Width = 608
        Height = 365
        Anchors = [akLeft, akTop, akRight, akBottom]
        Caption = ' '#1053#1072#1089#1090#1088#1086#1081#1082#1080' '#1082#1086#1088#1088#1077#1082#1094#1080#1080' '#1090#1077#1082#1089#1090#1072'  '
        TabOrder = 0
        Visible = False
        object CBEnableReplace: TCheckBox
          Left = 16
          Top = 25
          Width = 318
          Height = 17
          Caption = #1047#1072#1084#1077#1085#1103#1090#1100' '#1089#1083#1086#1074#1072' '#1087#1086' '#1089#1087#1080#1089#1082#1091
          TabOrder = 0
          OnClick = CBEnableReplaceClick
        end
        object CBFirstLetterUpper: TCheckBox
          Left = 16
          Top = 48
          Width = 334
          Height = 17
          Caption = #1044#1077#1083#1072#1090#1100' '#1087#1077#1088#1074#1099#1077' '#1073#1091#1082#1074#1099' '#1087#1088#1077#1076#1083#1086#1078#1077#1085#1080#1081' '#1087#1088#1086#1087#1080#1089#1085#1099#1084#1080
          TabOrder = 1
        end
        object GBReplaceList: TGroupBox
          Left = 16
          Top = 71
          Width = 577
          Height = 282
          Caption = ' '#1057#1087#1080#1089#1086#1082' '#1079#1072#1084#1077#1085#1099' '#1089#1083#1086#1074' '
          TabOrder = 2
          DesignSize = (
            577
            282)
          object LReplaceIN: TLabel
            Left = 16
            Top = 22
            Width = 52
            Height = 13
            Caption = #1047#1072#1084#1077#1085#1080#1090#1100':'
          end
          object LReplaceOUT: TLabel
            Left = 191
            Top = 22
            Width = 16
            Height = 13
            Caption = #1085#1072':'
          end
          object EReplaceIN: TEdit
            Left = 16
            Top = 41
            Width = 172
            Height = 21
            TabOrder = 0
            OnKeyUp = EReplaceINKeyUp
          end
          object EReplaceOUT: TEdit
            Left = 189
            Top = 41
            Width = 134
            Height = 21
            TabOrder = 1
            OnKeyUp = EReplaceOUTKeyUp
          end
          object ReplaceStringGrid: TStringGrid
            Left = 16
            Top = 68
            Width = 412
            Height = 159
            Anchors = [akLeft, akTop, akRight]
            ColCount = 2
            DefaultColWidth = 150
            DefaultRowHeight = 18
            DrawingStyle = gdsClassic
            FixedCols = 0
            RowCount = 1
            FixedRows = 0
            Options = [goFixedVertLine, goFixedHorzLine, goRangeSelect, goColSizing, goRowSelect]
            TabOrder = 2
            OnSelectCell = ReplaceStringGridSelectCell
            ColWidths = (
              170
              133)
            RowHeights = (
              18)
          end
          object AddReplaceButton: TButton
            Left = 16
            Top = 233
            Width = 85
            Height = 25
            Caption = #1044#1086#1073#1072#1074#1080#1090#1100
            Enabled = False
            ImageIndex = 6
            Images = ImageList_Main
            TabOrder = 3
            OnClick = AddReplaceButtonClick
          end
          object ChangeReplaceButton: TButton
            Left = 107
            Top = 233
            Width = 85
            Height = 25
            Caption = #1048#1079#1084#1077#1085#1080#1090#1100
            Enabled = False
            ImageIndex = 9
            Images = ImageList_Main
            TabOrder = 4
            OnClick = ChangeReplaceButtonClick
          end
          object DeleteReplaceButton: TButton
            Left = 198
            Top = 233
            Width = 85
            Height = 25
            Caption = #1059#1076#1072#1083#1080#1090#1100
            Enabled = False
            ImageIndex = 7
            Images = ImageList_Main
            TabOrder = 5
            OnClick = DeleteReplaceButtonClick
          end
        end
      end
      object CBEnableTextСorrection: TCheckBox
        Left = 3
        Top = 10
        Width = 366
        Height = 17
        Caption = #1042#1082#1083#1102#1095#1080#1090#1100' '#1082#1086#1088#1088#1077#1082#1094#1080#1102' '#1090#1077#1082#1089#1090#1072' '#1087#1088#1080' '#1087#1077#1088#1077#1076#1072#1095#1077
        TabOrder = 1
        OnClick = CBEnableTextСorrectionClick
      end
    end
    object TabSheetTextToSpeech: TTabSheet
      Caption = #1057#1080#1085#1090#1077#1079' '#1075#1086#1083#1086#1089#1072
      ImageIndex = 8
      DesignSize = (
        614
        401)
      object CBEnableTextToSpeech: TCheckBox
        Left = 3
        Top = 10
        Width = 465
        Height = 17
        Caption = #1042#1082#1083#1102#1095#1080#1090#1100' '#1087#1088#1077#1086#1073#1088#1072#1079#1086#1074#1072#1085#1080#1077' '#1090#1077#1082#1089#1090#1072' '#1074' '#1075#1086#1083#1086#1089
        TabOrder = 0
        OnClick = CBEnableTextToSpeechClick
      end
      object GBTextToSpeech: TGroupBox
        Left = 3
        Top = 33
        Width = 608
        Height = 365
        Anchors = [akLeft, akTop, akRight, akBottom]
        Caption = ' '#1053#1072#1089#1090#1088#1086#1081#1082#1080' '
        TabOrder = 1
        DesignSize = (
          608
          365)
        object LTextToSpeechEngine: TLabel
          Left = 16
          Top = 24
          Width = 89
          Height = 13
          Caption = #1057#1080#1089#1090#1077#1084#1072' '#1089#1080#1085#1090#1077#1079#1072':'
        end
        object CBTextToSpeechEngine: TComboBox
          Left = 111
          Top = 21
          Width = 203
          Height = 21
          Style = csDropDownList
          TabOrder = 0
          Items.Strings = (
            'Microsoft SAPI'
            'Google'
            'Yandex')
        end
        object GBTextToSpeechEngine: TGroupBox
          Left = 16
          Top = 48
          Width = 577
          Height = 113
          Caption = ' Microsoft SAPI '
          TabOrder = 1
          object LVoiceVolumeDesc: TLabel
            Left = 16
            Top = 56
            Width = 94
            Height = 13
            Caption = #1043#1088#1086#1084#1082#1086#1089#1090#1100' '#1075#1086#1083#1086#1089#1072':'
          end
          object LVoiceSpeedDesc: TLabel
            Left = 16
            Top = 84
            Width = 89
            Height = 13
            Caption = #1057#1082#1086#1088#1086#1089#1090#1100' '#1075#1086#1083#1086#1089#1072':'
          end
          object LVoice: TLabel
            Left = 16
            Top = 26
            Width = 33
            Height = 13
            Caption = #1043#1086#1083#1086#1089':'
          end
          object LVoiceVolume: TLabel
            Left = 303
            Top = 58
            Width = 6
            Height = 13
            Caption = '0'
          end
          object LVoiceSpeed: TLabel
            Left = 303
            Top = 87
            Width = 6
            Height = 13
            Caption = '0'
          end
          object SBVoiceTest: TSpeedButton
            Left = 304
            Top = 22
            Width = 23
            Height = 22
            Flat = True
            Glyph.Data = {
              36040000424D3604000000000000360000002800000010000000100000000100
              20000000000000040000C40E0000C40E00000000000000000000A0A0A02FA0A0
              A0FFA0A0A0FFA0A0A0FFA0A0A0FFA0A0A0FFA0A0A0FFA0A0A0FFA0A0A0FFA0A0
              A0FFA0A0A0FFA0A0A0FFA0A0A0FFA0A0A0FFA0A0A0FFA0A0A02FA0A0A0FFDCDC
              DCFFDCDCDCFFDCDCDCFFD4D4D4FFD4D4D4FFD4D4D4FFD4D4D4FFD4D4D4FFD4D4
              D4FFD4D4D4FFD4D4D4FFDCDCDCFFDCDCDCFFDCDCDCFFA0A0A0FFA0A0A0FFDFDF
              DFFFC9C9C9FFC9C9C9FFBCBCBCFFBCBCBCFFBCBCBCFFBCBCBCFFBCBCBCFFBCBC
              BCFFBCBCBCFFBCBCBCFFC9C9C9FFC9C9C9FFDFDFDFFFA0A0A0FFA0A0A0FFE0E0
              E0FFCCCCCCFFCCCCCCFFCCCCCCFFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0
              C0FFC0C0C0FFCCCCCCFFCCCCCCFFCCCCCCFFE0E0E0FFA0A0A0FFA0A0A0FFE3E3
              E3FFD0D0D0FFD0D0D0FF535353FFABABABFFC5C5C5FFC5C5C5FFC5C5C5FFC5C5
              C5FFC5C5C5FFD0D0D0FFD0D0D0FFD0D0D0FFE3E3E3FFA0A0A0FFA0A0A0FFE5E5
              E5FFD4D4D4FFD4D4D4FF262626FF545454FF8D8D8DFFAFAFAFFFCACACAFFCACA
              CAFFCACACAFFD4D4D4FFD4D4D4FFD4D4D4FFE5E5E5FFA0A0A0FFA0A0A0FFE7E7
              E7FFD7D7D7FFD7D7D7FF232323FF333333FF333333FF595959FF8E8E8EFFB2B2
              B2FFD7D7D7FFD7D7D7FFD7D7D7FFD7D7D7FFE7E7E7FFA0A0A0FFA0A0A0FFE9E9
              E9FFDBDBDBFFDBDBDBFF232323FF333333FF333333FF333333FF333333FF5151
              51FF8F8F8FFFBABABAFFDBDBDBFFDBDBDBFFE9E9E9FFA0A0A0FFA0A0A0FFF2F2
              F2FFDEDEDEFFDEDEDEFF232323FF333333FF333333FF333333FF333333FF2F2F
              2FFF535353FFABABABFFDEDEDEFFDEDEDEFFF2F2F2FFA0A0A0FFA0A0A0FFF3F3
              F3FFE2E2E2FFE2E2E2FF232323FF333333FF333333FF2E2E2EFF545454FFADAD
              ADFFE2E2E2FFE2E2E2FFE2E2E2FFE2E2E2FFF3F3F3FFA0A0A0FFA0A0A0FFF5F5
              F5FFE6E6E6FFE6E6E6FF1F1F1FFF2D2D2DFF565656FFB0B0B0FFE6E6E6FFE6E6
              E6FFE6E6E6FFE6E6E6FFE6E6E6FFE6E6E6FFF5F5F5FFA0A0A0FFA0A0A0FFF6F6
              F6FFE9E9E9FFE9E9E9FF4F4F4FFFB2B2B2FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9
              E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFF6F6F6FFA0A0A0FFA0A0A0FFF8F8
              F8FFEDEDEDFFEDEDEDFFEDEDEDFFEDEDEDFFEDEDEDFFEDEDEDFFEDEDEDFFEDED
              EDFFEDEDEDFFEDEDEDFFEDEDEDFFEDEDEDFFF8F8F8FFA0A0A0FFA0A0A0FFF9F9
              F9FFF1F1F1FFF1F1F1FFF1F1F1FFF1F1F1FFF1F1F1FFF1F1F1FFF1F1F1FFF1F1
              F1FFF1F1F1FFF1F1F1FFF1F1F1FFF1F1F1FFF9F9F9FFA0A0A0FFA0A0A0FFFBFB
              FBFFFBFBFBFFFBFBFBFFFBFBFBFFFBFBFBFFFBFBFBFFFBFBFBFFFBFBFBFFFBFB
              FBFFFBFBFBFFFBFBFBFFFBFBFBFFFBFBFBFFFBFBFBFFA0A0A0FFA0A0A030A0A0
              A0FFA0A0A0FFA0A0A0FFA0A0A0FFA0A0A0FFA0A0A0FFA0A0A0FFA0A0A0FFA0A0
              A0FFA0A0A0FFA0A0A0FFA0A0A0FFA0A0A0FFA0A0A0FFA0A0A030}
            StyleElements = [seFont]
            OnClick = SBVoiceTestClick
          end
          object LTTSAPIKey: TLabel
            Left = 18
            Top = 56
            Width = 82
            Height = 13
            Caption = 'iSpeech API Key:'
          end
          object LTTSAPPID: TLabel
            Left = 16
            Top = 80
            Width = 37
            Height = 13
            Caption = 'APP ID:'
          end
          object TBVoiceVolume: TTrackBar
            Left = 116
            Top = 50
            Width = 186
            Height = 23
            Ctl3D = True
            Max = 100
            ParentCtl3D = False
            Frequency = 5
            ShowSelRange = False
            TabOrder = 1
            ThumbLength = 12
            TickMarks = tmTopLeft
            OnChange = TBVoiceVolumeChange
          end
          object TBVoiceSpeed: TTrackBar
            Left = 116
            Top = 79
            Width = 186
            Height = 23
            Ctl3D = True
            Min = -10
            ParentCtl3D = False
            ShowSelRange = False
            TabOrder = 2
            ThumbLength = 12
            TickMarks = tmTopLeft
            OnChange = TBVoiceSpeedChange
          end
          object CBVoice: TComboBox
            Left = 122
            Top = 23
            Width = 176
            Height = 21
            Style = csDropDownList
            TabOrder = 0
          end
          object LBSAPIInfo: TListBox
            Left = 333
            Top = 20
            Width = 236
            Height = 84
            ItemHeight = 13
            TabOrder = 3
          end
          object ETTSAPIKey: TEdit
            Left = 122
            Top = 52
            Width = 175
            Height = 21
            TabOrder = 4
          end
          object GetAPIKeyButton: TButton
            Left = 315
            Top = 50
            Width = 122
            Height = 25
            Caption = #1055#1086#1083#1091#1095#1080#1090#1100' API '#1082#1083#1102#1095
            TabOrder = 5
            OnClick = GetAPIKeyButtonClick
          end
          object ETTSAPPID: TEdit
            Left = 122
            Top = 77
            Width = 175
            Height = 21
            TabOrder = 6
          end
        end
        object GBTextToSpeechList: TGroupBox
          Left = 16
          Top = 164
          Width = 577
          Height = 195
          Anchors = [akLeft, akTop, akRight, akBottom]
          Caption = ' '#1057#1087#1080#1089#1086#1082' '#1089#1080#1085#1090#1077#1079#1080#1088#1091#1077#1084#1099#1093' '#1089#1083#1086#1074' '
          TabOrder = 2
          DesignSize = (
            577
            195)
          object LTextToSpeechText: TLabel
            Left = 8
            Top = 20
            Width = 33
            Height = 13
            Caption = #1058#1077#1082#1089#1090':'
          end
          object LTextToSpeechEventsTypeStatus: TLabel
            Left = 402
            Top = 20
            Width = 40
            Height = 13
            Caption = #1057#1090#1072#1090#1091#1089':'
          end
          object LTextToSpeechEventsType: TLabel
            Left = 254
            Top = 20
            Width = 68
            Height = 13
            Caption = #1058#1080#1087' '#1089#1086#1073#1099#1090#1080#1103':'
          end
          object ETextToSpeech: TEdit
            Left = 8
            Top = 39
            Width = 247
            Height = 21
            TabOrder = 0
            OnKeyUp = ETextToSpeechKeyUp
          end
          object TextToSpeechStringGrid: TStringGrid
            Left = 8
            Top = 66
            Width = 541
            Height = 95
            Anchors = [akLeft, akTop, akRight]
            ColCount = 3
            DefaultColWidth = 150
            DefaultRowHeight = 18
            DrawingStyle = gdsClassic
            FixedCols = 0
            RowCount = 1
            FixedRows = 0
            Options = [goFixedVertLine, goFixedHorzLine, goRangeSelect, goColSizing, goRowSelect]
            TabOrder = 1
            OnSelectCell = TextToSpeechStringGridSelectCell
            ColWidths = (
              150
              150
              150)
            RowHeights = (
              18)
          end
          object AddTextToSpeechButton: TButton
            Left = 8
            Top = 167
            Width = 85
            Height = 25
            Caption = #1044#1086#1073#1072#1074#1080#1090#1100
            Enabled = False
            ImageIndex = 6
            Images = ImageList_Main
            TabOrder = 2
            OnClick = AddTextToSpeechButtonClick
          end
          object DeleteTextToSpeechButton: TButton
            Left = 190
            Top = 167
            Width = 85
            Height = 25
            Caption = #1059#1076#1072#1083#1080#1090#1100
            Enabled = False
            ImageIndex = 7
            Images = ImageList_Main
            TabOrder = 3
            OnClick = DeleteTextToSpeechButtonClick
          end
          object CBEventsType: TComboBox
            Left = 256
            Top = 39
            Width = 150
            Height = 21
            Style = csDropDownList
            TabOrder = 4
          end
          object CBTextToSpeechStatus: TComboBox
            Left = 407
            Top = 39
            Width = 142
            Height = 21
            Style = csDropDownList
            TabOrder = 5
          end
          object СhangeTextToSpeechButton: TButton
            Left = 99
            Top = 167
            Width = 85
            Height = 25
            Caption = #1048#1079#1084#1077#1085#1080#1090#1100
            Enabled = False
            ImageIndex = 9
            Images = ImageList_Main
            TabOrder = 6
            OnClick = СhangeTextToSpeechButtonClick
          end
        end
      end
    end
    object TabSheetAbout: TTabSheet
      Caption = #1054' '#1087#1088#1086#1075#1088#1072#1084#1084#1077
      ImageIndex = 9
      object AboutImage: TImage
        Left = 144
        Top = 16
        Width = 325
        Height = 55
        Transparent = True
      end
      object BAbout: TBevel
        Left = 16
        Top = 77
        Width = 585
        Height = 116
      end
      object LProgramName: TLabel
        Left = 24
        Top = 88
        Width = 54
        Height = 13
        Caption = 'MSpeech'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object LCopyright: TLabel
        Left = 24
        Top = 104
        Width = 130
        Height = 13
        Caption = 'Copyright '#169' 2011-2017 by'
      end
      object LAuthor: TLabel
        Left = 156
        Top = 104
        Width = 76
        Height = 13
        Cursor = crHandPoint
        Caption = 'Mikhail Grigorev'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        OnClick = LAuthorClick
      end
      object LVersionNum: TLabel
        Left = 65
        Top = 120
        Width = 36
        Height = 13
        Caption = '1.0.0.0'
      end
      object LVersion: TLabel
        Left = 24
        Top = 120
        Width = 42
        Height = 13
        Caption = 'Version: '
      end
      object LWeb: TLabel
        Left = 24
        Top = 136
        Width = 29
        Height = 13
        Caption = 'Web: '
      end
      object LLicense: TLabel
        Left = 24
        Top = 152
        Width = 42
        Height = 13
        Caption = 'License: '
      end
      object LLicenseType: TLabel
        Left = 65
        Top = 152
        Width = 519
        Height = 32
        AutoSize = False
        Caption = 'GPLv3'
        WordWrap = True
      end
      object LWebSite: TLabel
        Left = 53
        Top = 136
        Width = 94
        Height = 13
        Cursor = crHandPoint
        Caption = 'www.programs74.ru'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        OnClick = LWebSiteClick
      end
      object ELicense: TEdit
        Left = 16
        Top = 238
        Width = 585
        Height = 21
        TabOrder = 1
        Visible = False
      end
      object BActivate: TButton
        Left = 16
        Top = 265
        Width = 97
        Height = 25
        Caption = #1040#1082#1090#1080#1074#1080#1088#1086#1074#1072#1090#1100
        TabOrder = 2
        Visible = False
        OnClick = BActivateClick
      end
      object BActivateLicense: TButton
        Left = 16
        Top = 207
        Width = 150
        Height = 25
        Caption = #1040#1082#1090#1080#1074#1080#1088#1086#1074#1072#1090#1100' '#1083#1080#1094#1077#1085#1079#1080#1102
        TabOrder = 0
        Visible = False
        OnClick = BActivateLicenseClick
      end
    end
  end
  object ImageList_Main: TImageList
    ColorDepth = cd32Bit
    DrawingStyle = dsTransparent
    Left = 48
    Top = 232
    Bitmap = {
      494C01010D001100180010001000FFFFFFFF2110FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000004000000001002000000000000040
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000D0D0D0E000000000000000000000000000000000000
      0000262626270000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000141414156D6B6A73000000000000000000000000000000000000
      00004B4A4A514C4B4A5203030304000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00006C6A69737A78767F7B79787F000000000000000000000000121212135251
      505A00000000434242476B67647F000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000001515
      15167978767F7A79777F7B7A787F000000010A0A0A0B01010102000000003B3B
      3A3E000000011D1D1D1E6B67647F000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000005050506171717186C6A
      68737A78767F7B79787F7B7A797F52514F59000000014E4D4C54000000011313
      131427272728050505066865627A0C0C0C0D0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000706E6C797876747F7977
      757F7B79787F7B7A797F7C7B7B7F6B67647F444342485F5D5A6B454443490000
      00005C5A5867000000005B595765343433360000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000706E6C797977757F7A78
      767F7B7A797F7C7B7A7F7D7C7B7F6B67647F4A49484F5B5957654F4E4D550000
      0000615E5C6E00000000595856633939393C0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000232323243838373A7775
      747D7C7B7A7F7D7C7B7F7D7D7D7F6B67637E171717186A66637C2929292A0303
      03044847464D0000000165635F75252525260000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000002D2D
      2D2E7C7C7B7F7D7D7C7F7E7E7D7F2B2A2A2C0000000058565461010101022121
      2122202020210D0D0D0E6B67637E0B0B0B0C0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007978777D7E7D7D7F7E7E7E7F000000001E1E1E1F07070708000000005251
      4F59000000002D2D2D2F6B67647F000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000002D2D2D2E7B7A7A7D000000000000000008080809161616170000
      0000202020216B67637E4746464C000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000026262627000000000000000000000000000000000000
      0000615E5C6E4A49484F02020203000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000B0B
      0B0C252525260000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000008F5026C5C28356FFD38A66FFE18E6EFFDC8C6AFFDA8A
      6BFFD7896CFFCD8A6AFFAA6B42FFA55D2CFF0000000000000000000000000000
      0000103951F7265C84FB4685B9FB316A8EC1050F182200000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000262626266C6C6C81787878B5676767E7676767E7787878B56C6C6C812626
      2626000000000000000000000000000000000000000000000000000000000000
      0000444444467777778D888888C7828182F0828182F0888888C77777778D4444
      4446000000000000000000000000000000000000000000000000000000000000
      00000000000000000000C58253FFEFCEB9FFDDFFFFFF86EEC7FFA1F4D7FFA1F6
      D7FF8BEEC7FFE0FFFFFFDDA184FFAA683CFF00000000A37856C4CA9167F4D195
      66FF2C6481FF93C7F9FF90C9F9FF3F84C9FF2264A5FFA78163FFC28350FFC283
      50FFC28350FFC28350FF7F502CB0000000000000000000000000020202016363
      63715E5E5EF6545454FF616161FF797979FF7B7B7BFF636363FF545454FF5E5E
      5EF6636363710202020100000000000000000000000000000000212121207777
      778C8E8D8EC7B6B6BCFFCFD0DEFFEEF0F7FFEFF0F7FFD1D4DFFFB8B8BDFF8E8D
      8EC77777778C212121200000000000000000A37856C4CA9167F4D19566FFCE91
      61FFCB8D5CFFC98959FFC27D4FFFEFB599FFEAF3E8FF4FBE83FF6DC997FF6FC9
      98FF52BE83FFE4F4E9FFDD9B79FFA96738FF00000000D7A073FFF8F2EDFFF7F0
      EAFF4188A9FFE0F2FFFF5299D8FF1878BDFF4797C4FF458BC2FFD0D2D7FFF0E2
      D8FFF0E2D8FFF0E2D8FFC2885AFD0000000000000000020202017B7B7BB65656
      56FF6C6C6CFFD0D0D0FFE9E9E9FFEFEFEFFFF1F1F1FFEFEFEFFFDBDBDBFF7676
      76FF565656FF7B7B7BB602020201000000000000000021212120818181A3C3C3
      C3FFF9F9F9FFC2C6F7FF7481ECFF3A56E8FF3F64EDFF8B9EF7FFD5DAFEFFEFEF
      F9FFC3C3C3FF818181A32121212000000000D7A073FFF8F2EDFFF7F0EAFFF6ED
      E6FFF4EAE2FFF3E7DEFFC38052FFEAB596FFF3F3EAFFEDF1E6FFEFF1E6FFEFF0
      E6FFEDF1E5FFF3F5EDFFD59B77FFAF6E42FF00000000D9A378FFF9F3EEFFEBD2
      BDFFA6C4D9FF78B5D5FF8FB6D1FF53C9E4FF59DFF5FF76D0EDFF4F9CDDFFE4F0
      FAFFFFFFFFFFF0E2D8FFC58B5DFF0000000000000000646464715A5A5AFF8888
      88FFE2E2E2FFF1F1F1FFFAFAFAFFFCFCFCFFFDFDFDFFFCFCFCFFFAFAFAFFF1F1
      F1FF9C9C9CFF5A5A5AFF6464647100000000000000007777778CC3C3C3FFEAEA
      FCFF7575E0FF0F1DC7FF0622CAFF062ECFFF153DD4FF2F4DDAFF4E63E0FFA5AC
      F5FFF4F4FFFFC3C3C3FF7777778C00000000D9A378FFF9F3EEFFEBD2BDFFFFFF
      FFFFEBD3BEFFFFFFFFFFC98A5FFFE6B491FFE2A680FFE1A680FFDEA27BFFDCA0
      79FFDB9E77FFD99D75FFD49971FFBA7C55FF00000000DDA77CFFF9F3EFFFEBD0
      B9FFEBD0BAFFA6B6B8FF74B8D5FFC1F6FDFF61DFF7FF5BE2F8FF77D3F0FF4796
      DAFFD4C4B8FFF0E2D8FFC5895AFF0000000026262626676767F66D6D6DFFDDDD
      DDFFF1F1F1FFFCFCFCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCFC
      FCFFF1F1F1FF797979FF676767F626262626444444468E8D8EC7F9F9F9FF7575
      E0FF313BCBFF323ECCFF313DCCFF222FCAFF313ECDFF323ECEFF333FCEFF2737
      CCFF9AA4F5FFF9F9F9FF8E8D8EC744444446DDA77CFFF9F3EFFFEBD0B9FFEBD0
      BAFFEBD0BAFFEBD0BAFFCA8C63FFEAB798FFDDA47CFFDDA57EFFDBA27AFFD99F
      78FFD99F77FFD89E76FFD89D76FFBE835BFF00000000DFA981FFF9F3EFFFEACE
      B6FFFFFFFFFFEBD0BAFFB0D6E7FF75CBE7FFC7F7FDFF5CDCF5FF58E1F7FF79D4
      F1FF4A99DEFFCAD0D8FFC88C5DFF000000006E6E6E815F5F5FFFB8B8B8FFE9E9
      E9FFFAFAFAFFFAFAFEFFA09EECFF3C39DEFF3D3BE1FFA1A0F0FFFAFAFEFFFFFF
      FFFFFAFAFAFFDBDBDBFF5F5F5FFF6E6E6E807777778DB7B5BCFFC2C2F5FF0E0E
      C9FF1D2AC9FFFCFEF4FFF7F9F5FFFCFDFBFFFDFEFCFFFEFFFDFFFFFFFFFF2A3A
      CDFF3451E3FFCFD7FDFFB7B7BDFF7777778DDFA981FFF9F3EFFFEACEB6FFFFFF
      FFFFEBD0BAFFFFFFFFFFC8875BFFEFBEA0FFFDFCFAFFFEFCFBFFFEFDFDFFFEFD
      FCFFFDFBFAFFFDFCFBFFDDA784FFC07D51FF00000000E1AD86FFFAF4F0FFEACB
      B1FFEACCB2FFEACCB2FFEACCB2FFAFC3BEFF77D3EEFFC7F7FDFF5DDCF5FF59E2
      F7FF78D6F2FF4E9FDEFFAB8669FF000000007F7F7FB5686868FFD0D0D0FFEFEF
      EFFFFCFCFCFFA09EEBFF0A06D6FF0C0AE1FF0E0DE7FF0C0AE1FFA1A0F0FFFFFF
      FFFFFCFCFCFFEFEFEFFF6C6C6CFF7F7F7FB5888888C7D4D3DFFF8181E9FF0202
      C9FF2632C8FFF4F7F2FFF7F9F8FFF8FAF9FFFAFBFAFFFAFBFBFFFEFEFBFF2739
      CCFF0F39DEFF8096F3FFCFD3DFFF888888C7E1AD86FFFAF4F0FFEACBB1FFEACC
      B2FFEACCB2FFEACCB2FFC78559FFEFBF9DFFFFFFFFFFCC926CFFFFFFFFFFFFFF
      FFFFFFFBF7FFFFF8F1FFE4AE8BFFC7895FFF00000000E3B08BFFFAF6F1FFEAC9
      ADFFFFFFFFFFEAC9AFFFFFFFFFFFFFFFFFFFC0EBF7FF7BD4EDFFC3F6FDFF6ADD
      F6FF6BCAEDFF61A2D7FF6398C9FF0C161D26777777E7797979FFD5D5D5FFF1F1
      F1FFFDFDFDFF3B37D6FF0B08D9FF0E0DE7FF1111F5FF0E0DE7FF3D3BE1FFFFFF
      FFFFFDFDFDFFF1F1F1FF818181FF777777E7828182F0F1F1F7FF6C6CE7FF2C2C
      D9FF4345D7FFF9FAF8FFFCFCFCFFF5F7F6FFF7F8F7FFF2F4F3FFF8FAF6FF1B2B
      C9FF0229D8FF3A5BE8FFEEF0F7FF828182F0E3B08BFFFAF6F1FFEAC9ADFFFFFF
      FFFFEAC9AFFFFFFFFFFFCC8C63FFF3CDAFFFFFFFFFFFE3C7B2FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFEABEA0FFC9885EFF00000000E5B38EFFFAF6F2FFE9C5
      A9FFE9C5ABFFEAC7ABFFE9C7ACFFE9C9ADFFE9C9AFFFA5C0BDFF80D5EDFFB1E3
      F9FF8ABFE7FFADD3F6FFC3E0FCFF6199CCF7797979E77B7B7BFFD0D0D0FFEFEF
      EFFFFCFCFCFF6562DFFF3E3BDFFF3D3BE7FF3231EBFF201EE3FF423FDFFFFFFF
      FFFFFCFCFCFFEFEFEFFF818181FF797979E7828182F0F1F1F7FF6969E8FF4545
      DFFF4141DEFFF9F9F8FFF7F7F7FFE7E8E8FFE9EAEAFFEBEDECFFF2F4EFFF1A2A
      C8FF0216D1FF3A4BE3FFEEEFF7FF828182F0E5B38EFFFAF6F2FFE9C5A9FFE9C5
      ABFFEAC7ABFFE9C7ACFFD4966CFFD49D79FFD0976FFFD6A381FFCD8D66FFCD8F
      67FFD09973FFD19871FFC88A60FF2412063600000000E7B693FFFBF7F4FFE9C2
      A5FFFFFFFFFFE8C3A8FFFFFFFFFFFFFFFFFFFFFFFFFFE8C7ABFFB0E6F5FF75BD
      E7FFB3D2F0FFE5F3FFFFABD2EFFF407DB5E8828282B56F6F6FFFCECECEFFF1F1
      F1FFFCFCFCFFBFBDF1FF4A47DAFF3E3BDFFF322FDFFF2421DAFFA5A3EDFFFFFF
      FFFFFAFAFAFFE9E9E9FF717171FF828282B5888888C7D2D3E0FF9393F2FF3C3C
      DFFF3B3BDFFFFBFBFAFFF5F5F5FFF3F3F3FFF2F2F2FFF2F2F2FFF5F5F3FF3445
      C7FF1C28D3FF8D96EEFFD3D4DFFF888888C7E7B693FFFBF7F4FFE9C2A5FFFFFF
      FFFFE8C3A8FFFFFFFFFFFFFFFFFFFFFFFFFFE8C7ABFFFFFFFFFFFFFFFFFFFFFF
      FFFFF7F1EBFFCB8E5DFF000000000000000000000000E9B997FFFBF7F4FFE9C2
      A5FFE9C2A5FFE9C2A5FFE9C2A5FFE9C2A5FFE9C2A5FFE9C2A5FFE9C2A5FFACBC
      B7FF56A4D8FF84B0DBFF449CD0FF0F374D5E707070816C6C6CFFBEBEBEFFECEC
      ECFFF6F6F6FFFAFAFCFFB9B8F0FF6562DFFF5A57DCFFAAA8EDFFFAFAFEFFFCFC
      FCFFF1F1F1FFD0D0D0FF6C6C6CFF707070807777778DB7B7BDFFD0D0FBFF3B3B
      E2FF4545DFFFFEFEFAFFF7F7F4FFFCFCFBFFF9F9F7FFF8F8F6FFF9F9F6FF2A39
      CAFF545CDCFFD8DAFAFFB9B8BDFF7777778DE9B997FFFBF7F4FFE9C2A5FFE9C2
      A5FFE9C2A5FFE9C2A5FFE9C2A5FFE9C2A5FFE9C2A5FFE9C2A5FFE9C2A5FFE9C2
      A5FFFBF7F4FFCE9262FF000000000000000000000000EBBC9AFFFBF7F4FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFBF7F4FFD19668FF0000000027272726797979F6787878FFD5D5
      D5FFEDEDEDFFF6F6F6FFFBFBFBFFFDFDFDFFFDFDFDFFFCFCFCFFFAFAFAFFF1F1
      F1FFE2E2E2FF797979FF797979F627272726444444468E8D8EC7EAEAF8FF8A8A
      F2FF5151E1FF6464E1FF6161E0FF6060DFFF6060DEFF5E5EDDFF8080DBFF7F7F
      D3FF9797EAFFEDEDF8FF8E8D8EC744444446EBBC9AFFFBF7F4FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFBF7F4FFD19668FF000000000000000000000000ECBE9DFFFBF7F4FF9BD5
      A4FF97D3A0FF93D09CFF8FCE97FF8ACB92FF86C98DFF81C588FF7CC283FF78C0
      7EFF74BD7AFFFBF7F4FFD49A6DFF000000000000000067676771737373FF9090
      90FFD3D3D3FFE8E8E8FFEFEFEFFFF2F2F2FFF3F3F3FFF1F1F1FFEAEAEAFFDDDD
      DDFF8F8F8FFF737373FF6767677100000000000000007777778CC3C3C3FFEEEF
      FEFF8A8AF2FF3939E3FF3636DEFF3939DBFF3D3DDAFF3E3ED9FF4646DBFF9494
      EBFFF0F0FDFFC3C3C3FF7777778C00000000ECBE9DFFFBF7F4FF9BD5A4FF97D3
      A0FF93D09CFF8FCE97FF8ACB92FF86C98DFF81C588FF7CC283FF78C07EFF74BD
      7AFFFBF7F4FFD49A6DFF000000000000000000000000DBB193EBFBF7F4FFFBF7
      F4FFFBF7F4FFFBF7F4FFFBF7F4FFFBF7F4FFFBF7F4FFFBF7F4FFFBF7F4FFFBF7
      F4FFFBF7F4FFFBF7F4FFD19B6FF8000000000000000002020201888888B67777
      77FF7C7C7CFFBABABAFFD0D0D0FFD9D9D9FFDBDBDBFFD4D4D4FFBABABAFF7B7B
      7BFF777777FF888888B602020201000000000000000021212120818181A3C3C3
      C3FFEAEAF8FFCECEFBFF8E8EF2FF5F5FE9FF6161E7FF9292EEFFD1D1F9FFECEC
      F8FFC3C3C3FF818181A32121212000000000DBB193EBFBF7F4FFFBF7F4FFFBF7
      F4FFFBF7F4FFFBF7F4FFFBF7F4FFFBF7F4FFFBF7F4FFFBF7F4FFFBF7F4FFFBF7
      F4FFFBF7F4FFD19B6FF8000000000000000000000000765E507ED4AB8FE3EDBF
      9EFFEBBD9CFFEBBB99FFE9B995FFE7B692FFE6B48FFFE4B18BFFE2AE87FFE0AB
      83FFDDA87EFFDCA47BFFAC805FCA000000000000000000000000020202016767
      6771828282F6787878FF787878FF818181FF818181FF787878FF787878FF8282
      82F6676767710202020100000000000000000000000000000000212121207777
      778C8E8D8EC7B7B6BDFFD2D2E0FFF0F0F7FFF0F0F7FFD2D2DFFFB8B7BDFF8E8D
      8EC77777778C212121200000000000000000765E507ED4AB8FE3EDBF9EFFEBBD
      9CFFEBBB99FFE9B995FFE7B692FFE6B48FFFE4B18BFFE2AE87FFE0AB83FFDDA8
      7EFFDCA47BFFAC805FCA00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00002727272672727281898989B5888888E7888888E7898989B5727272812727
      2726000000000000000000000000000000000000000000000000000000000000
      0000444444467777778D888888C7828182F0828182F0888888C77777778D4444
      4446000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000C381C881664
      33F2176935FF166433F20C381C88000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000D275C78023A
      A1DF0340BAFE023DA4E30020587A000000000000000000000000000000000000
      000009140A231C46227D30773ADB33823BF32E8038F328712EDB143F187D0410
      0623000000000000000000000000000000000000000000000000000000000000
      0000090A1B231B275F7D2F46A2DB314BB3F32C47B2F326419DDB1424597D0409
      19230000000000000000000000000000000000000000A37856C4CA9167F4D195
      66FFCE9161FFCB8D5CFFC98959FFC78654FFC28350FF697542FF268B51FF62B9
      8CFF94D2B1FF62B98CFF268B51FF0D391E8C00000000A37856C4CA9167F4D195
      66FFCE9161FFCB8D5CFFC98959FFC78654FFC28350FF6C6B8AFF2563C7FF1F75
      E6FF0477EAFF0062DDFF044BBAFE0020587A0000000000000000000000001731
      1B533D8649E63F984EFF7BC18EFF95D0A5FF95CFA5FF76BD88FF348C40FF2673
      2DE60C280E53000000000000000000000000000000000000000000000000161B
      41533A4BB1E63A50CCFF7378E8FF8E91EEFF8E91EEFF6F76E4FF314BC0FF2541
      A4E60C173B5300000000000000000000000000000000D7A073FFF8F2EDFFF7F0
      EAFFF6EDE6FFF4EAE2FFF3E7DEFFF1E4DBFFF0E2D8FF206E3CFF60B98AFF5EB9
      86FFFFFFFFFF5EB886FF65BB8EFF176634F700000000D7A073FFF8F2EDFFF7F0
      EAFFF6EDE6FFF4EAE2FFF3E7DEFFF1E4DBFFF0E2D8FF1B54BBFF619CF4FF167D
      FFFF0074F8FF0074EEFF0266E1FF023CA5E4000000000000000019331E534894
      57F462B376FFA7DBB4FF86CC97FF64BB7BFF62B97AFF85CB97FFA4D9B3FF56A9
      69FF287A30F40C280E5300000000000000000000000000000000181C43534453
      C2F45A63E0FFA0A5F5FF7C85EFFF5961E9FF575BE7FF7B83EEFF9D9FF4FF4F5B
      D7FF2845AEF40C173B53000000000000000000000000D9A378FFF9F3EEFFEBD2
      BDFFFFFFFFFFEBD3BEFFFFFFFFFFFFFFFFFFFFFFFFFF2F794AFF9BD4B5FFFFFF
      FFFFFFFFFFFFFFFFFFFF94D2B1FF176935FF00000000D9A378FFF9F3EEFFEBD2
      BDFFFFFFFFFFEBD3BEFFFFFFFFFFFFFFFFFFFFFFFFFF0441BBFFADCDFEFFFFFF
      FFFFFFFFFFFFFFFFFFFF167DEFFF0340BAFE000000000B160D224C905AE568B8
      7BFFA7DBB1FF5EBB75FF5AB971FF57B76EFF57B46DFF56B46DFF59B672FFA4D9
      B2FF58A96AFF26742DE50511052200000000000000000B0D1C224955BAE55F69
      E3FFA0ABF5FF525DECFF4E5AEAFF4B57E9FF4C57E6FF4A54E6FF4E54E6FF9DA1
      F4FF525ED6FF2441A4E5050918220000000000000000DDA77CFFF9F3EFFFEBD0
      B9FFEBD0BAFFEBD0BAFFEBD0BAFFEBD0BAFFEBD1BCFF47885EFF8FD3B0FF91D6
      B0FFFFFFFFFF63BB8BFF65BB8EFF176634F700000000DDA77CFFF9F3EFFFEBD0
      B9FFEBD0BAFFEBD0BAFFEBD0BAFFEBD0BAFFEBD1BCFF2054B7FF8CB4F6FF4B91
      FFFF1075FFFF1F85FFFF3E89EBFF023AA0DE000000002C53367E51AA66FFA9DD
      B3FF62C077FF5DBD6FFF5EBB75FFFFFFFFFFFFFFFFFF57B76EFF56B46CFF5AB6
      72FFA5DAB3FF368E41FF1540197E00000000000000002A2E697E4954DBFFA1AA
      F6FF5462F0FF5064EEFF4B57E9FF4B57E9FF4B57E9FF4B57E9FF4A56E6FF5058
      E6FF9EA2F5FF324EC3FF13235A7E0000000000000000DFA981FFF9F3EFFFEACE
      B6FFFFFFFFFFEBD0BAFFFFFFFFFFFFFFFFFFFFFFFFFF9CAE90FF5FAA80FF94D4
      B3FFB9E6D0FF68BA8EFF2B8E55FF0D391E8C00000000DFA981FFF9F3EFFFEACE
      B6FFFFFFFFFFEBD0BAFFFFFFFFFFFFFFFFFFFFFFFFFF8A96BEFF3B74D2FF8CB4
      F7FFB7D6FEFF70A7F5FF2D69CAFF021C4F6D00000000519363DB89CC97FF88D3
      95FF69C578FF61C06EFF53AA63FFFFFFFFFFFFFFFFFF57B76EFF57B76EFF59B8
      70FF84CC96FF79BD8CFF28712FDB00000000000000004D52B8DB808BEEFF7C90
      F7FF5B71F3FF4B57E9FF4B57E9FF4B57E9FF4B57E9FF4B57E9FF4B57E9FF4D59
      E9FF7982F0FF7379E2FF26409FDB0000000000000000E1AD86FFFAF4F0FFEACB
      B1FFEACCB2FFEACCB2FFEACCB2FFEACCB2FFEACEB6FFE8C7ABFFA1AD8DFF5D96
      6FFF4D8D64FF47885DFF797D4DFF0000000000000000E1AD86FFFAF4F0FFEACB
      B1FFEACCB2FFEACCB2FFEACCB2FFEACCB2FFEACEB6FFE8C7ABFF8892B6FF2659
      BDFF0441BBFF1C55BCFF676583FF000000000000000060A874F6A8DDB2FF7BCF
      89FF73CC80FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF57B7
      6EFF65BD7BFF9BD4AAFF318239F600000000000000005A5ED2F6A0AAF7FF6E85
      F8FF6681F6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF4B57
      E9FF5A64EAFF959BF1FF2F4BB4F60000000000000000E3B08BFFFAF6F1FFEAC9
      ADFFFFFFFFFFEAC9AFFFFFFFFFFFFFFFFFFFFFFFFFFFE8C7ABFFFFFFFFFFFFFF
      FFFFFFFFFFFFF1E5DBFFC58553FF0000000000000000E3B08BFFFAF6F1FFEAC9
      ADFFFFFFFFFFEAC9AFFFFFFFFFFFFFFFFFFFFFFFFFFFE8C7ABFFFFFFFFFFFFFF
      FFFFFFFFFFFFF1E5DBFFC58553FF000000000000000063AB78F6B5E2BDFF8AD5
      96FF78C985FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF57B7
      6EFF67C07CFF9CD4A9FF34853EF600000000000000006063D3F6AEB8F9FF7D92
      FAFF6E84F0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF4B57
      E9FF5C68EEFF959CF1FF324AB6F60000000000000000E5B38EFFFAF6F2FFE9C5
      A9FFE9C5ABFFEAC7ABFFE9C7ACFFE9C9ADFFE9C9AFFFE8C7ABFFE9C9AFFFE8C8
      AFFFE8CCB4FFF2E7DEFFC88957FF0000000000000000E5B38EFFFAF6F2FFE9C5
      A9FFE9C5ABFFEAC7ABFFE9C7ACFFE9C9ADFFE9C9AFFFE8C7ABFFE9C9AFFFE8C8
      AFFFE8CCB4FFF2E7DEFFC88957FF00000000000000005C9A70DBABDDB5FFA5DF
      AEFF80CB8BFF7AC985FF6CBC77FFFFFFFFFFFFFFFFFF59AB68FF5EBB75FF5AB9
      71FF8AD198FF7EC491FF32793BDB00000000000000005759BEDBA4AEF5FF9CAA
      FAFF758BF0FF525DECFF525DECFF525DECFF525DECFF525DECFF525DECFF6175
      F2FF808DF4FF767DE9FF3046A4DB0000000000000000E7B693FFFBF7F4FFE9C2
      A5FFFFFFFFFFE8C3A8FFFFFFFFFFFFFFFFFFFFFFFFFFE8C7ABFFFFFFFFFFFFFF
      FFFFFFFFFFFFF7F1EBFFCB8E5DFF0000000000000000E7B693FFFBF7F4FFE9C2
      A5FFFFFFFFFFE8C3A8FFFFFFFFFFFFFFFFFFFFFFFFFFE8C7ABFFFFFFFFFFFFFF
      FFFFFFFFFFFFF7F1EBFFCB8E5DFF0000000000000000365A427E84C796FFD2EE
      D7FF94D99FFF89D393FF7DC888FFFFFFFFFFFFFFFFFF77CD84FF69C27AFF6DC7
      7CFFABDFB4FF439D55FF1F47247E000000000000000033326F7E7B82EAFFCDD4
      FCFF8A9CFAFF7C92F7FF7389EEFF6A83F6FF6A83F6FF6A83F6FF6A83F6FF6177
      F3FFA3AEF8FF3C4DD0FF1E285E7E0000000000000000E9B997FFFBF7F4FFE9C2
      A5FFE9C2A5FFE9C2A5FFE9C2A5FFE9C2A5FFE9C2A5FFE9C2A5FFE9C2A5FFE9C2
      A5FFE9C2A5FFFBF7F4FFCE9262FF0000000000000000E9B997FFFBF7F4FFE9C2
      A5FFE9C2A5FFE9C2A5FFE9C2A5FFE9C2A5FFE9C2A5FFE9C2A5FFE9C2A5FFE9C2
      A5FFE9C2A5FFFBF7F4FFCE9262FF00000000000000000F19122263A478E5A9DA
      B6FFD8F1DCFF91D89CFF87CD92FF83CC8DFF8AD495FF89D494FF82D28DFFAEE0
      B6FF69B87BFF3F874CE509140B2200000000000000000D0D1E225D5DC9E5A2A6
      F3FFD4DBFDFF8699FAFF7D90F0FF788DF1FF7D93F8FF7C91F9FF748BF8FFA7B5
      F8FF616CE3FF3C4CB2E5090B1A220000000000000000EBBC9AFFFBF7F4FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFBF7F4FFD19668FF0000000000000000EBBC9AFFFBF7F4FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFBF7F4FFD19668FF000000000000000000000000243C2D5369AF
      80F4AEDCBAFFDCF2E0FFB5E4BCFF9ADBA4FF95D99FFFA4DFAEFFBFE8C4FF77C1
      89FF4B9659F417321C5300000000000000000000000000000000232349536464
      D6F4A9ACF2FFD8DCFDFFADB9FAFF90A2FAFF8A9CFAFF9BA8FBFFB9C7FCFF6E79
      E9FF4755C3F4171B4253000000000000000000000000ECBE9DFFFBF7F4FF9BD5
      A4FF97D3A0FF93D09CFF8FCE97FF8ACB92FF86C98DFF81C588FF7CC283FF78C0
      7EFF74BD7AFFFBF7F4FFD49A6DFF0000000000000000ECBE9DFFFBF7F4FF9BD5
      A4FF97D3A0FF93D09CFF8FCE97FF8ACB92FF86C98DFF81C588FF7CC283FF78C0
      7EFF74BD7AFFFBF7F4FFD49A6DFF00000000000000000000000000000000243C
      2D5364A579E693CEA3FFC2E6CBFFCFEBD4FFC9E9CEFFAEDDB7FF6BB87DFF4D94
      5DE61A3420530000000000000000000000000000000000000000000000002323
      49535E5EC9E68D92EDFFBDC2F8FFCCD3F9FFC3CBF9FFA9B3F4FF646EE2FF4953
      BDE6191D435300000000000000000000000000000000DBB193EBFBF7F4FFFBF7
      F4FFFBF7F4FFFBF7F4FFFBF7F4FFFBF7F4FFFBF7F4FFFBF7F4FFFBF7F4FFFBF7
      F4FFFBF7F4FFFBF7F4FFD19B6FF80000000000000000DBB193EBFBF7F4FFFBF7
      F4FFFBF7F4FFFBF7F4FFFBF7F4FFFBF7F4FFFBF7F4FFFBF7F4FFFBF7F4FFFBF7
      F4FFFBF7F4FFFBF7F4FFD19B6FF8000000000000000000000000000000000000
      00000F191323365A427D5D9A71DB63A978F360A874F3539464DB2E53377D0B17
      0E23000000000000000000000000000000000000000000000000000000000000
      00000E0E1F2333326D7D5759BDDB5D5DD1F35A5DCFF34E53BADB2B2F687D0B0C
      1C230000000000000000000000000000000000000000765E507ED4AB8FE3EDBF
      9EFFEBBD9CFFEBBB99FFE9B995FFE7B692FFE6B48FFFE4B18BFFE2AE87FFE0AB
      83FFDDA87EFFDCA47BFFAC805FCA0000000000000000765E507ED4AB8FE3EDBF
      9EFFEBBD9CFFEBBB99FFE9B995FFE7B692FFE6B48FFFE4B18BFFE2AE87FFE0AB
      83FFDDA87EFFDCA47BFFAC805FCA000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000673A1D8F834924B5AB6031EEB666
      33FFB46633FFB36532FFB16432FFAF6331FFAD6231FFAB6130FFA96030FFA85F
      30FFA75E2FFFA55E2FFE9C592DF1804924C40000000000000000000000000000
      0000000000000000000029292963414141BF3C3C3CBF1F1F1F63000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000A15B2DDEEBC5ACFFEAC4ACFFFEFB
      F8FFFEFBF8FFFEFBF8FFFEFBF8FFFEFBF8FFFEFBF8FFFEFBF8FFFEFBF8FFFEFB
      F8FFFEFBF8FFC8997AFFC79777FF9A572CED0000000000000000000000001111
      11290505050E01010102767676EABDBDBDFFB2B2B2FF545454EA010101020404
      040E0C0C0C290000000000000000000000000000000000000000000000000000
      0000180F092353361E7D915E35DB9F6638F39E6436F38D582EDB5031187D160D
      0623000000000000000000000000000000000000000000000000000000000F0E
      3B41020207080000000000000000000000000000000000000000000000000101
      070806063A41000000000000000000000000B86935FEEDCAB2FFE0A178FFFEFA
      F7FF60BF87FF60BF87FF60BF87FF60BF87FF60BF87FF60BF87FF60BF87FF60BF
      87FFFDF9F6FFCA8C63FFC99A7AFFA55E2FFE00000000000000004E4E4E9B6D6D
      6DFD5A5A5AE70B0B0B19777777E7CBCBCBFFC7C7C7FF585858E7080808194F4F
      4FE74D4D4DFD2B2B2B9B00000000000000000000000000000000000000003B28
      1953A16E45E6D7BAA2FFE9DACAFFECE0D1FFECE0D1FFE8D8C8FFD3B49BFF9661
      33E636211153000000000000000000000000000000000000000013123C414D4A
      F2FF3E3CEBFD0202070800000000000000000000000000000000010107082220
      E1FC2F2DEAFF07063A410000000000000000BA6A36FFEECCB5FFE1A178FFFEFA
      F7FFBEDCC1FFBEDCC1FFBEDCC1FFBEDCC1FFBEDCC1FFBEDCC1FFBEDCC1FFBEDC
      C1FFFDF9F6FFCD8F66FFCC9D80FFA75F30FF000000004F4F4F7BBCBCBCFFDEDE
      DEFFA6A6A6FF7D7D7DF4848484FEC4C4C4FFC2C2C2FF6C6C6CFE686868F4A6A6
      A6FFD2D2D2FF808080FF2727277B0000000000000000000000003C2C1E53B280
      55F4E7D5C3FFE5D2BEFFC9A584FFB78D65FFB58963FFC4A07EFFE0CCB9FFE3D0
      BDFFA2693CF43723135300000000000000000000000014133D415654F5FF615F
      FAFF5653F6FF3F3DEAFC020207080000000000000000010107082A28E3FC3F3D
      F1FF4A48F6FF2F2DEAFF07063A4100000000BA6936FFEFCEB7FFE1A177FFFEFA
      F7FF60BF87FF60BF87FF60BF87FF60BF87FF60BF87FF60BF87FF60BF87FF60BF
      87FFFDF9F6FFCF9268FFCEA283FFA95F30FF000000005353537DA5A5A5FED5D5
      D5FFC5C5C5FFCBCBCBFFD1D1D1FFC9C9C9FFC7C7C7FFCCCCCCFFC5C5C5FFBDBD
      BDFFCBCBCBFF6D6D6DFE3131317D00000000000000001A140D22AE825DE5EAD8
      C9FFE3CDB9FFBF9369FFB98B60FFCFAF93FFCFAF93FFB6885DFFB1865FFFDABF
      A9FFE4D1BFFF9B673DE5170F092200000000000000000E0D282B5956F6FF6360
      FAFF6F6EFFFF5754F6FF3F3EEBFC02020708020207083330E6FC4543F2FF6160
      FFFF4846F4FF2D2BE9FF0605252B00000000B96834FFEFD0BAFFE2A178FFFEFB
      F8FFFEFBF8FFFEFBF8FFFEFBF8FFFEFBF8FFFEFBF8FFFEFBF8FFFEFBF8FFFEFB
      F8FFFEFBF8FFD3956BFFD2A689FFAA6030FF00000000000000005A5A5A85C5C5
      C5FFC1C1C1FFC5C5C5FFC7C7C7FFAAAAAAFFA7A7A7FFC1C1C1FFBEBEBEFFB5B5
      B5FFAAAAAAFF36363685000000000000000000000000644E3A7EE4CCB8FFEAD6
      C4FFC7986FFFBE8F64FFBE8F64FFF7F1ECFFF6F0EAFFB6885DFFB6885DFFB488
      61FFE2CEBAFFD9BCA5FF573B257E0000000000000000000000000E0E282B5957
      F6FF6461FAFF726FFFFF5856F6FF403FEBFC3C3AEAFD4E4BF4FF6665FFFF4E4C
      F5FF3432EBFF0706262B0000000000000000BA6834FFF0D2BDFFE2A278FFE2A2
      78FFE1A278FFE2A279FFE1A279FFE0A076FFDE9E75FFDD9E74FFDC9C72FFD99A
      70FFD8986FFFD6986EFFD5AA8DFFAC6131FF838383CD7F7F7FE3959595EECFCF
      CFFFC6C6C6FFCCCCCCFF7A7A7AC629292944272727446F6F6FC6C1C1C1FFBCBC
      BCFFB9B9B9FF5C5C5CEE4E4E4EE3424242CD00000000B58F71DBEFE1D3FFD9B4
      94FFC7976AFFC29467FFC09265FFBE8F64FFBE8F64FFBA8A61FFB88961FFB789
      60FFCBA685FFEADCCCFF9D7049DB000000000000000000000000000000000E0E
      282B5A58F6FF6562FAFF7270FFFF716EFFFF6E6CFFFF6C6AFFFF5553F7FF3D3B
      EEFF0707262B000000000000000000000000BA6834FFF2D5C1FFE3A278FFE3A2
      78FFE2A279FFE2A279FFE2A379FFE1A177FFE0A076FFDE9F75FFDE9D73FFDC9C
      72FFDA9A71FFD99A71FFDAAF94FFAE6231FFBEBEBEFDE2E2E2FFD2D2D2FFC6C6
      C6FFCDCDCDFFB1B1B1FF27272744000000000000000028282844A8A8A8FFC2C2
      C2FFB7B7B7FFC0C0C0FFD2D2D2FF5F5F5FFD00000000D1A989F6F2E4D9FFD1A4
      78FFC49869FFC39668FFC39567FFFAF6F2FFF3EAE1FFC1946BFFBD8E63FFBD8E
      62FFBF946BFFEFE3D5FFB7865CF6000000000000000000000000000000000000
      00000E0E282B5B59F7FF7774FFFF5754FFFF5552FFFF706EFFFF4644F0FF0908
      272B00000000000000000000000000000000BA6834FFF2D8C4FFE3A379FFE3A2
      78FFE3A378FFE2A379FFE2A279FFE1A279FFE1A177FFDF9F75FFDE9E74FFDD9D
      72FFDB9B70FFDC9C72FFDDB499FFB06332FFC2C2C2FDE9E9E9FFD6D6D6FFC9C9
      C9FFCECECEFFA5A5A5FF23232344000000000000000029292944ACACACFFC4C4
      C4FFBABABAFFC6C6C6FFDDDDDDFF696969FD00000000D8B293F6F2E5DAFFD1A5
      7CFFCC9C6FFFC7996AFFC49769FFE2CCB5FFF8F3EEFFF6EEE8FFD9BCA0FFC193
      66FFC49A6FFFF0E2D6FFBD8F66F6000000000000000000000000000000000000
      0000030308085A57F4FD7B77FFFF5C59FFFF5956FFFF7472FFFF4441EDFD0202
      070800000000000000000000000000000000BA6934FFF4D9C7FFE6A57BFFC88B
      62FFC98C63FFC98D65FFCB916AFFCB916BFFCA8F67FFC88B63FFC88B62FFC88B
      62FFC88B62FFDA9B72FFE1B99EFFB26432FFA0A0A0CDADADADE3B3B3B3EED8D8
      D8FFCDCDCDFFBCBCBCFF656565C61F1F1F44222222446F6F6FC6C3C3C3FFC2C2
      C2FFCDCDCDFF838383EE787878E3696969CD00000000C6A58BDBF3E5D9FFDFBA
      9DFFCF9F73FFCD9D70FFF5EBE3FFE4CBB3FFE7D3BEFFFBF8F6FFE5D3BEFFC397
      69FFD6B390FFEEE0D2FFAF8765DB000000000000000000000000000000000303
      08086360F6FC6E6BFBFF7E7CFFFF7C79FFFF7A77FFFF7775FFFF5C5AF7FF4441
      ECFC02020708000000000000000000000000B96934FEF4DCC9FFE7A67BFFF9EC
      E1FFF9ECE1FFF9EDE3FFFCF4EEFFFDFAF7FFFDF7F3FFFAEDE5FFF7E7DBFFF7E5
      D9FFF6E5D8FFDE9F75FFE4BDA3FFB36532FF000000000000000066666685D4D4
      D4FFCCCCCCFFC9C9C9FFBABABAFF9C9C9CFFA1A1A1FFC2C2C2FFC6C6C6FFC1C1
      C1FFB7B7B7FF474747850000000000000000000000007462557EF4E3D4FFEFDC
      CDFFD5A77CFFD09F75FFFBF8F5FFFCF8F5FFFCF8F5FFFBF8F5FFD1A780FFCFA3
      79FFEAD5C2FFEAD4C1FF6752407E000000000000000000000000040308086B68
      F9FC7572FDFF8581FFFF7471FCFF6260F8FF5E5BF7FF6B68FAFF7977FFFF5E5B
      F7FF4542ECFC020207080000000000000000B76733FAF5DDCCFFE7A77CFFFAF0
      E8FFFAF0E8FFC98C64FFFAF0E9FFFDF8F3FFFEFAF8FFFCF4EFFFF9E9DFFFF7E7
      DBFFF7E5D9FFE0A176FFE7C1A8FFB56633FF000000006363637DC3C3C3FEDCDC
      DCFFD4D4D4FFD9D9D9FFDBDBDBFFD6D6D6FFD4D4D4FFD9D9D9FFD2D2D2FFCBCB
      CBFFC8C8C8FF787878FE3636367D0000000000000000201C1822D6B9A0E5F6E9
      DDFFECD8C5FFD7AB80FFDCBA99FFF6ECE3FFF5ECE2FFE4C8ADFFD2A679FFE6CE
      B9FFF1E2D5FFC4A081E51D171322000000000000000004040808716EFCFD7B78
      FEFF8986FFFF7A77FDFF6A67FBFF100F292B0F0E292B5F5CF8FF6C6AFAFF7B78
      FFFF5F5DF7FF4643EDFC0000050500000000B06331F0F6DFD0FFE8A77CFFFCF6
      F1FFFCF6F1FFC88B62FFFAF1E9FFFBF4EEFFFDFAF7FFFDF9F6FFFAF0E8FFF8E8
      DDFFF7E6DBFFE1A278FFEFD5C2FFB56733FE000000006363637BDCDCDCFFEDED
      EDFFDBDBDBFFB9B9B9F4BDBDBDFED6D6D6FFD4D4D4FFAFAFAFFEA4A4A4F4CBCB
      CBFFE7E7E7FFB7B7B7FF4343437B0000000000000000000000004F453C53E7C9
      AFF4F7EADFFFEEDED0FFE3C0A6FFD8AD88FFD7AB85FFDDBA9BFFEBD6C7FFF3E6
      D9FFD9B597F4483C32530000000000000000000000000D0D1F1F7875FFFF807C
      FFFF807CFEFF726FFDFF1111292B00000000000000000F0F292B605DF8FF6D6B
      FBFF7C7AFFFF605DF8FF201D686F010102029E592CD8F6DFD1FFE9A97EFFFEFA
      F6FFFDFAF6FFC88B62FFFBF3EEFFFBF1EAFFFCF6F2FFFEFBF8FFFCF6F1FFF9EC
      E2FFF8E7DBFFEED0B9FFECD0BCFFB56B3BF800000000000000007F7F7F9BCCCC
      CCFDB7B7B7E713131319AFAFAFE7DEDEDEFFDDDDDDFFA1A1A1E7101010199C9C
      9CE7A6A6A6FD6363639B00000000000000000000000000000000000000005046
      3D53DDC1A9E6F9E9DCFFF6E8DDFFF3E5DAFFF3E5DAFFF5E7DCFFF5E4D6FFD4B4
      9AE64B40375300000000000000000000000000000000000000000D0D1F1F7875
      FFFF7774FEFF12122B2B000000000000000000000000000000000F0F292B625F
      F8FF6866F9FF3634A0A80C0C272900000000723F209BF6E0D1FFF7E0D1FFFEFB
      F8FFFEFBF7FFFDF9F6FFFCF5F0FFFAF0EAFFFBF2EDFFFDF9F6FFFDFAF7FFFBF1
      EBFFF7E8DEFEE8CCB9FBBA7E55EC452714630000000000000000000000002121
      21290A0A0A0E02020202B6B6B6EAE5E5E5FFE4E4E4FF9E9E9EEA010101020A0A
      0A0E1C1C1C290000000000000000000000000000000000000000000000000000
      0000221E1B237A6A5F7DD4BAA4DBEACDB4F3E9CBB2F3D0B59EDB7666597D201C
      1923000000000000000000000000000000000000000000000000000000000D0D
      1F1F13122B2B0000000000000000000000000000000000000000000000000F0F
      292B27276B6F14143C3E0000000000000000522E16006A3B1D9096542ACCAF62
      31EEB76733FAB96934FEBA6934FFBA6834FFBA6834FFBB6A37FFBC6C39FFBA6B
      38FFAE6233EF945831CB3C211154000000000000000000000000000000000000
      000000000000000000004E4E4E63959595BF929292BF4A4A4A63000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000003030A0A000000000000000000000000424D3E000000000000003E000000
      2800000040000000400000000100010000000000000200000000000000000000
      000000000000000000000000FFFFFF00FFFF000000000000FFFF000000000000
      FDF7000000000000F9F1000000000000F1C9000000000000E021000000000000
      8000000000000000801400000000000080140000000000008000000000000000
      E080000000000000F129000000000000F991000000000000FDF1000000000000
      FFE7000000000000FFFF00000000000000000000F00FF00F00000000C003C003
      0000000080018001000000008001800100000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000800180010000000080018001
      00000000C003C00300000000F00FF00F00000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000}
  end
  object CommandOpenDialog: TOpenDialog
    Left = 48
    Top = 280
  end
end
