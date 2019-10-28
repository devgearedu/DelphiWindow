object DeptForm_New: TDeptForm_New
  Left = 0
  Top = 0
  Caption = #48512#49436#44288#47532
  ClientHeight = 358
  ClientWidth = 600
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 600
    Height = 49
    Align = alTop
    TabOrder = 0
    object imgMenu: TImage
      Left = 10
      Top = 12
      Width = 32
      Height = 32
      Cursor = crHandPoint
      Picture.Data = {
        0954506E67496D61676589504E470D0A1A0A0000000D49484452000000200000
        00200806000000737A7AF40000002B744558744372656174696F6E2054696D65
        0053756E20322041756720323031352031373A30353A3430202D30363030AB9D
        78EE0000000774494D4507DF0802160936B3167602000000097048597300002E
        2300002E230178A53F760000000467414D410000B18F0BFC61050000003B4944
        415478DAEDD3310100200C0341EA5F3454020BA1C3BD81DC925A9F2B00809180
        DD3D19EB00AE00C9000066BE00201900C0CC1700240300003859BE2421B37CDF
        370000000049454E44AE426082}
      OnClick = imgMenuClick
    end
    object grpDisplayMode: TRadioGroup
      Left = 44
      Top = -4
      Width = 125
      Height = 48
      Caption = 'Display Mode'
      Columns = 2
      ItemIndex = 0
      Items.Strings = (
        'Docked'
        'Overlay')
      TabOrder = 0
      OnClick = grpDisplayModeClick
    end
    object grpPlacement: TRadioGroup
      Left = 175
      Top = 0
      Width = 130
      Height = 44
      Caption = 'Placement'
      Columns = 2
      ItemIndex = 0
      Items.Strings = (
        'Left'
        'Right')
      TabOrder = 1
      OnClick = grpPlacementClick
    end
    object grpCloseStyle: TRadioGroup
      Left = 311
      Top = 0
      Width = 157
      Height = 44
      Caption = 'Close Style'
      Columns = 2
      ItemIndex = 0
      Items.Strings = (
        'Collapse'
        'Compact')
      TabOrder = 2
      OnClick = grpCloseStyleClick
    end
    object chkUseAnimation: TCheckBox
      Left = 474
      Top = 0
      Width = 97
      Height = 17
      Caption = 'Use Animation'
      Checked = True
      State = cbChecked
      TabOrder = 3
      OnClick = chkUseAnimationClick
    end
    object chkClose: TCheckBox
      Left = 474
      Top = 26
      Width = 161
      Height = 17
      Caption = 'Close on Menu Click'
      TabOrder = 4
    end
  end
  object SV: TSplitView
    Left = 0
    Top = 49
    Width = 200
    Height = 309
    Color = clBlack
    OpenedWidth = 200
    Placement = svpLeft
    TabOrder = 1
    OnClosed = SVClosed
    OnOpened = SVOpened
    OnOpening = SVOpening
    object catMenuItems: TCategoryButtons
      Left = 0
      Top = 0
      Width = 200
      Height = 309
      Align = alClient
      BorderStyle = bsNone
      ButtonFlow = cbfVertical
      ButtonHeight = 40
      ButtonWidth = 100
      ButtonOptions = [boFullSize, boShowCaptions, boCaptionOnlyBorder]
      Categories = <
        item
          Color = clNone
          Collapsed = False
          Items = <
            item
              Caption = 'Home'
              ImageIndex = 1
              OnClick = actHomeExecute
            end
            item
              Caption = #48512#49436#48324#49324#50896#51312#54924
              ImageIndex = 2
            end
            item
              Caption = #48512#49436#48324#51064#50896#49688#53685#44228
              ImageIndex = 3
              OnClick = actCountExecute
            end
            item
              Caption = #48512#49436#46321#47197
              OnClick = ActInsertExecute
            end
            item
              Caption = #50641#49472#48520#47084#50724#44592
              OnClick = ActExcelExecute
            end>
        end>
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      HotButtonColor = 12477460
      RegularButtonColor = clNone
      SelectedButtonColor = clNone
      TabOrder = 0
    end
  end
  object CardPanel1: TCardPanel
    Left = 200
    Top = 49
    Width = 400
    Height = 309
    Align = alClient
    ActiveCard = Card2
    Caption = 'CardPanel1'
    TabOrder = 2
    object Card1: TCard
      Left = 1
      Top = 1
      Width = 398
      Height = 307
      Caption = 'Card1'
      CardIndex = 0
      TabOrder = 0
      object DBGrid2: TDBGrid
        Left = 0
        Top = 0
        Width = 398
        Height = 307
        Align = alClient
        Options = [dgEditing, dgAlwaysShowEditor, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
      end
    end
    object Card2: TCard
      Left = 1
      Top = 1
      Width = 398
      Height = 307
      Caption = 'Card2'
      CardIndex = 1
      TabOrder = 1
      object StringGrid1: TStringGrid
        Left = 0
        Top = 0
        Width = 398
        Height = 307
        Align = alClient
        ColCount = 3
        DrawingStyle = gdsClassic
        TabOrder = 0
      end
    end
    object Card3: TCard
      Left = 1
      Top = 1
      Width = 398
      Height = 307
      Caption = 'Card3'
      CardIndex = 2
      TabOrder = 2
    end
    object Card4: TCard
      Left = 1
      Top = 1
      Width = 398
      Height = 307
      Caption = 'Card4'
      CardIndex = 3
      TabOrder = 3
      object Panel2: TPanel
        Left = 0
        Top = 0
        Width = 398
        Height = 41
        Align = alTop
        TabOrder = 0
      end
    end
  end
end
