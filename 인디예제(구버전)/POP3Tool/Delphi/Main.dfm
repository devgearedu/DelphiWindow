object formMain: TformMain
  Left = 290
  Top = 116
  Width = 677
  Height = 548
  Caption = 'POP3 Tool'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 0
    Top = 41
    Width = 669
    Height = 105
    Align = alTop
    Caption = 'Server Settings'
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 16
      Width = 65
      Height = 13
      Caption = 'POP3 &Server:'
      FocusControl = editPOP3Server
    end
    object Label2: TLabel
      Left = 216
      Top = 16
      Width = 51
      Height = 13
      Caption = '&Username:'
      FocusControl = editUsername
    end
    object Label3: TLabel
      Left = 216
      Top = 56
      Width = 49
      Height = 13
      Caption = '&Password:'
      FocusControl = editPassword
    end
    object editPOP3Server: TEdit
      Left = 8
      Top = 32
      Width = 201
      Height = 21
      TabOrder = 0
    end
    object editUsername: TEdit
      Left = 216
      Top = 32
      Width = 201
      Height = 21
      TabOrder = 1
    end
    object editPassword: TEdit
      Left = 216
      Top = 72
      Width = 201
      Height = 21
      PasswordChar = '*'
      TabOrder = 2
    end
    object butnSaveConfig: TButton
      Left = 424
      Top = 72
      Width = 75
      Height = 25
      Action = actnSaveConfig
      TabOrder = 3
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 669
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      669
      41)
    object butnConnect: TButton
      Left = 8
      Top = 8
      Width = 75
      Height = 25
      Action = actnConnect
      TabOrder = 0
    end
    object butnDisconnect: TButton
      Left = 88
      Top = 8
      Width = 75
      Height = 25
      Action = actnDisconnect
      TabOrder = 1
    end
    object butnGet: TButton
      Left = 360
      Top = 8
      Width = 75
      Height = 25
      Action = actnGetRaw
      TabOrder = 2
    end
    object butnDelete: TButton
      Left = 508
      Top = 8
      Width = 75
      Height = 25
      Action = actnDelete
      Anchors = [akTop, akRight]
      TabOrder = 3
    end
    object butnDeleteAll: TButton
      Left = 588
      Top = -48
      Width = 75
      Height = 25
      Action = actnDeleteAll
      Anchors = [akTop, akRight]
      TabOrder = 4
    end
    object Button1: TButton
      Left = 280
      Top = 8
      Width = 75
      Height = 25
      Action = actnGetHeader
      TabOrder = 5
    end
    object Button2: TButton
      Left = 200
      Top = 8
      Width = 75
      Height = 25
      Action = actnGet
      TabOrder = 6
    end
    object Button3: TButton
      Left = 588
      Top = 8
      Width = 75
      Height = 25
      Action = actnDeleteAll
      Anchors = [akTop, akRight]
      TabOrder = 7
    end
  end
  object lboxMsgs: TListBox
    Left = 0
    Top = 146
    Width = 57
    Height = 356
    Align = alLeft
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ItemHeight = 14
    ParentFont = False
    TabOrder = 2
    OnClick = lboxMsgsClick
    OnDblClick = lboxMsgsDblClick
  end
  object pctlMain: TPageControl
    Left = 57
    Top = 146
    Width = 612
    Height = 356
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 3
    object TabSheet1: TTabSheet
      Caption = 'Message'
      object memoMsg: TMemo
        Left = 0
        Top = 105
        Width = 604
        Height = 223
        Align = alClient
        ReadOnly = True
        ScrollBars = ssBoth
        TabOrder = 0
      end
      object panlHeader: TPanel
        Left = 0
        Top = 0
        Width = 604
        Height = 105
        Align = alTop
        TabOrder = 1
        object lablSubject: TLabel
          Tag = 1
          Left = 80
          Top = 8
          Width = 52
          Height = 13
          Caption = 'lablSubject'
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clHighlight
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentColor = False
          ParentFont = False
        end
        object Label4: TLabel
          Left = 33
          Top = 8
          Width = 39
          Height = 13
          Alignment = taRightJustify
          Caption = 'Subject:'
        end
        object Label5: TLabel
          Left = 322
          Top = 8
          Width = 62
          Height = 13
          Alignment = taRightJustify
          Caption = 'Attachments:'
        end
        object lablAttachments: TLabel
          Tag = 1
          Left = 392
          Top = 8
          Width = 6
          Height = 13
          Caption = '0'
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clHighlight
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentColor = False
          ParentFont = False
        end
        object Label6: TLabel
          Left = 46
          Top = 24
          Width = 26
          Height = 13
          Alignment = taRightJustify
          Caption = 'From:'
        end
        object lablFrom: TLabel
          Tag = 1
          Left = 80
          Top = 24
          Width = 39
          Height = 13
          Caption = 'lablFrom'
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clHighlight
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentColor = False
          ParentFont = False
        end
      end
    end
    object pageHeaders: TTabSheet
      Caption = 'Header'
      ImageIndex = 1
      object memoHeaders: TMemo
        Left = 0
        Top = 0
        Width = 604
        Height = 328
        Align = alClient
        ReadOnly = True
        ScrollBars = ssBoth
        TabOrder = 0
      end
    end
  end
  object pop3: TIdPOP3
    OnDisconnected = pop3Disconnected
    AutoLogin = True
    SASLMechanisms = <>
    Left = 8
    Top = 152
  end
  object ActionList1: TActionList
    OnUpdate = ActionList1Update
    Left = 12
    Top = 344
    object actnConnect: TAction
      Caption = '&Connect'
      OnExecute = actnConnectExecute
    end
    object actnDisconnect: TAction
      Caption = '&Disconnect'
      OnExecute = actnDisconnectExecute
    end
    object actnGetRaw: TAction
      Caption = 'Get Raw'
      ShortCut = 16466
      OnExecute = actnGetRawExecute
    end
    object actnGetHeader: TAction
      Caption = 'Get &Header'
      ShortCut = 16456
      OnExecute = actnGetHeaderExecute
    end
    object actnDelete: TAction
      Caption = '&Delete'
      ShortCut = 16452
      OnExecute = actnDeleteExecute
    end
    object actnDeleteAll: TAction
      Caption = 'Delete All'
      OnExecute = actnDeleteAllExecute
    end
    object actnSaveConfig: TAction
      Caption = 'Save Config'
      OnExecute = actnSaveConfigExecute
    end
    object actnGet: TAction
      Caption = '&Get'
      ShortCut = 16455
      OnExecute = actnGetExecute
    end
  end
  object MainMenu1: TMainMenu
    Left = 12
    Top = 296
    object File1: TMenuItem
      Caption = '&File'
      object SaveConfig1: TMenuItem
        Action = actnSaveConfig
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object mitmExit: TMenuItem
        Caption = 'E&xit'
        OnClick = mitmExitClick
      end
    end
    object Server1: TMenuItem
      Caption = '&Server'
      object Connect1: TMenuItem
        Action = actnConnect
      end
      object Disconnect1: TMenuItem
        Action = actnDisconnect
      end
    end
    object Message1: TMenuItem
      Caption = 'Message'
      object Get2: TMenuItem
        Action = actnGet
      end
      object GetHeader1: TMenuItem
        Action = actnGetHeader
      end
      object Get1: TMenuItem
        Action = actnGetRaw
      end
    end
    object ools1: TMenuItem
      Caption = 'Tools'
      object DeleteAll1: TMenuItem
        Action = actnDeleteAll
      end
    end
  end
  object IdAntiFreeze1: TIdAntiFreeze
    Left = 8
    Top = 248
  end
  object Msg: TIdMessage
    AttachmentEncoding = 'MIME'
    BccList = <>
    CCList = <>
    Encoding = meDefault
    FromList = <
      item
      end>
    Recipients = <>
    ReplyTo = <>
    ConvertPreamble = True
    Left = 8
    Top = 200
  end
end
