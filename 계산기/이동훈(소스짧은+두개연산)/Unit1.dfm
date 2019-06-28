object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 188
  ClientWidth = 582
  Color = clYellow
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 204
    Top = 49
    Width = 8
    Height = 33
    Alignment = taCenter
    Color = clYellow
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentColor = False
    ParentFont = False
  end
  object Label2: TLabel
    Left = 404
    Top = 48
    Width = 20
    Height = 33
    Alignment = taCenter
    Caption = '='
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Edit1: TEdit
    Left = 105
    Top = 56
    Width = 80
    Height = 21
    Alignment = taRightJustify
    ImeName = 'Microsoft Office IME 2007'
    TabOrder = 0
  end
  object Edit3: TEdit
    Left = 446
    Top = 56
    Width = 75
    Height = 21
    Alignment = taRightJustify
    ImeName = 'Microsoft Office IME 2007'
    TabOrder = 1
  end
  object Panel1: TPanel
    Left = 86
    Top = 99
    Width = 299
    Height = 54
    Color = clRed
    ParentBackground = False
    TabOrder = 2
    object SpeedButton1: TSpeedButton
      Left = 16
      Top = 16
      Width = 23
      Height = 22
      Caption = '+'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      OnClick = SpeedButton1Click
    end
    object SpeedButton2: TSpeedButton
      Left = 76
      Top = 16
      Width = 23
      Height = 22
      Caption = '-'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      OnClick = SpeedButton2Click
    end
    object SpeedButton3: TSpeedButton
      Left = 134
      Top = 16
      Width = 23
      Height = 22
      Caption = '*'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      OnClick = SpeedButton3Click
    end
    object SpeedButton4: TSpeedButton
      Left = 192
      Top = 16
      Width = 23
      Height = 22
      Caption = '/'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      OnClick = SpeedButton4Click
    end
    object SpeedButton5: TSpeedButton
      Left = 256
      Top = 16
      Width = 23
      Height = 22
      Caption = 'M'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      OnClick = SpeedButton5Click
    end
  end
  object Edit2: TEdit
    Left = 246
    Top = 56
    Width = 80
    Height = 21
    Alignment = taRightJustify
    ImeName = 'Microsoft Office IME 2007'
    TabOrder = 3
  end
  object Button1: TButton
    Left = 446
    Top = 128
    Width = 75
    Height = 25
    Caption = #51333#47308
    TabOrder = 4
    OnClick = Button1Click
  end
end
