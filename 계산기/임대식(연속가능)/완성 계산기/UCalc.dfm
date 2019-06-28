object ClacForm: TClacForm
  Left = 0
  Top = 0
  Caption = #44228#49328#44592' '#54532#47196#44536#47016
  ClientHeight = 282
  ClientWidth = 462
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 32
    Top = 26
    Width = 385
    Height = 225
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clDefault
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object Lbsh: TLabel
      Left = 16
      Top = 19
      Width = 350
      Height = 40
      Caption = #44228#49328#54624' '#44050#51012' '#51077#47141#54616#49884#50724
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clDefault
      Font.Height = -33
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      OnClick = ButOprClick
    end
    object ButNum1: TButton
      Left = 23
      Top = 74
      Width = 75
      Height = 25
      Caption = '1'
      TabOrder = 0
      OnClick = ButOprClick
    end
    object ButNum2: TButton
      Left = 110
      Top = 74
      Width = 75
      Height = 25
      Caption = '2'
      TabOrder = 1
      OnClick = ButOprClick
    end
    object ButNum3: TButton
      Left = 200
      Top = 74
      Width = 75
      Height = 25
      Caption = '3'
      TabOrder = 2
      OnClick = ButOprClick
    end
    object ButNum4: TButton
      Left = 23
      Top = 105
      Width = 75
      Height = 25
      Caption = '4'
      TabOrder = 3
      OnClick = ButOprClick
    end
    object ButNum5: TButton
      Left = 110
      Top = 105
      Width = 75
      Height = 25
      Caption = '5'
      TabOrder = 4
      OnClick = ButOprClick
    end
    object ButNum6: TButton
      Left = 200
      Top = 105
      Width = 75
      Height = 25
      Caption = '6'
      TabOrder = 5
      OnClick = ButOprClick
    end
    object ButNum7: TButton
      Left = 23
      Top = 136
      Width = 75
      Height = 25
      Caption = '7'
      TabOrder = 6
      OnClick = ButOprClick
    end
    object ButNum8: TButton
      Left = 111
      Top = 136
      Width = 75
      Height = 25
      Caption = '8'
      TabOrder = 7
      OnClick = ButOprClick
    end
    object ButNum9: TButton
      Left = 200
      Top = 136
      Width = 75
      Height = 25
      Caption = '9'
      TabOrder = 8
      OnClick = ButOprClick
    end
    object ButNum0: TButton
      Left = 23
      Top = 173
      Width = 75
      Height = 25
      Caption = '0'
      TabOrder = 9
      OnClick = ButOprClick
    end
    object ButAdd: TButton
      Left = 288
      Top = 74
      Width = 75
      Height = 25
      Caption = '+'
      TabOrder = 10
      OnClick = ButOprClick
    end
    object ButSub: TButton
      Left = 288
      Top = 105
      Width = 75
      Height = 25
      Caption = '-'
      TabOrder = 11
      OnClick = ButOprClick
    end
    object ButMult: TButton
      Left = 288
      Top = 136
      Width = 75
      Height = 25
      Caption = '*'
      TabOrder = 12
      OnClick = ButOprClick
    end
    object ButDiv: TButton
      Left = 288
      Top = 173
      Width = 75
      Height = 25
      Caption = '/'
      TabOrder = 13
      OnClick = ButOprClick
    end
    object ButCE: TButton
      Left = 200
      Top = 173
      Width = 75
      Height = 25
      Caption = 'CE'
      TabOrder = 14
      OnClick = ButOprClick
    end
    object ButResult: TButton
      Left = 110
      Top = 173
      Width = 75
      Height = 25
      Caption = '='
      TabOrder = 15
      OnClick = ButOprClick
    end
    object ButOpr: TButton
      Left = 336
      Top = 224
      Width = 1
      Height = 25
      TabOrder = 16
      OnClick = ButOprClick
    end
  end
end
