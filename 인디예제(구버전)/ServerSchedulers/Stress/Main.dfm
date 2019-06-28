object formMain: TformMain
  Left = 378
  Top = 164
  BorderStyle = bsDialog
  Caption = 'Server Scheduler Stress Tester'
  ClientHeight = 412
  ClientWidth = 318
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object lablHost: TLabel
    Left = 24
    Top = 16
    Width = 25
    Height = 13
    Caption = '&Host:'
    FocusControl = editHost
  end
  object Label1: TLabel
    Left = 24
    Top = 56
    Width = 34
    Height = 13
    Caption = '&Clients:'
    FocusControl = editClients
  end
  object Label2: TLabel
    Left = 0
    Top = 200
    Width = 35
    Height = 13
    Caption = 'Results'
  end
  object Label3: TLabel
    Left = 24
    Top = 96
    Width = 110
    Height = 13
    Caption = '&Auto stop in x seconds:'
    FocusControl = editAutoStop
  end
  object lablElapsedTime: TLabel
    Left = 192
    Top = 96
    Width = 49
    Height = 13
    Caption = '0 seconds'
    Visible = False
  end
  object editHost: TEdit
    Left = 24
    Top = 32
    Width = 121
    Height = 21
    TabOrder = 0
    Text = '127.0.0.1'
  end
  object butnStart: TButton
    Left = 192
    Top = 24
    Width = 75
    Height = 25
    Caption = '&Start'
    Default = True
    TabOrder = 1
    OnClick = butnStartClick
  end
  object editClients: TEdit
    Left = 24
    Top = 72
    Width = 121
    Height = 21
    TabOrder = 2
    Text = '5'
  end
  object butnStop: TButton
    Left = 192
    Top = 56
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'S&top'
    Enabled = False
    TabOrder = 3
    OnClick = butnStopClick
  end
  object chckReconnect: TCheckBox
    Left = 24
    Top = 144
    Width = 193
    Height = 17
    Caption = 'Reconnect for each command'
    TabOrder = 4
  end
  object memoResults: TMemo
    Left = 0
    Top = 216
    Width = 318
    Height = 196
    Align = alBottom
    ReadOnly = True
    TabOrder = 5
  end
  object editAutoStop: TEdit
    Left = 24
    Top = 112
    Width = 121
    Height = 21
    TabOrder = 6
    Text = '5'
  end
  object chckCopyResults: TCheckBox
    Left = 24
    Top = 168
    Width = 193
    Height = 17
    Caption = 'Copy results to clipboard'
    Checked = True
    State = cbChecked
    TabOrder = 7
  end
  object timrStop: TTimer
    Enabled = False
    OnTimer = butnStopClick
    Left = 48
    Top = 256
  end
  object timrDisplay: TTimer
    OnTimer = timrDisplayTimer
    Left = 112
    Top = 256
  end
end
