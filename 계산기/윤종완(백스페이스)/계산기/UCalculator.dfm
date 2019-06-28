object Calculator_Form: TCalculator_Form
  Left = 0
  Top = 0
  Caption = #44228#49328#44592
  ClientHeight = 423
  ClientWidth = 272
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object CalcEdit: TEdit
    Left = 8
    Top = 25
    Width = 256
    Height = 49
    Alignment = taRightJustify
    AutoSize = False
    BiDiMode = bdLeftToRight
    Color = clSkyBlue
    Ctl3D = True
    Font.Charset = HANGEUL_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = #54620#52980' '#48177#51228' B'
    Font.Style = [fsBold]
    ImeName = 'Microsoft Office IME 2007'
    ParentBiDiMode = False
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 0
    Text = '0'
  end
  object PadBtnBack: TButton
    Tag = 20
    Left = 16
    Top = 97
    Width = 50
    Height = 50
    Caption = #8592
    Font.Charset = HANGEUL_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = #54620#52980' '#48177#51228' B'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    OnClick = PadBtnBackClick
  end
  object PadBtnCe: TButton
    Tag = 20
    Left = 78
    Top = 97
    Width = 50
    Height = 50
    Caption = 'CE'
    Font.Charset = HANGEUL_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = #54620#52980' '#48177#51228' B'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    OnClick = PadBtnCClick
  end
  object PadBtnC: TButton
    Left = 140
    Top = 97
    Width = 50
    Height = 50
    Caption = 'C'
    Font.Charset = HANGEUL_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = #54620#52980' '#48177#51228' B'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    OnClick = PadBtnCClick
  end
  object PadBtnNum7: TButton
    Tag = 7
    Left = 16
    Top = 162
    Width = 50
    Height = 50
    Caption = '7'
    Font.Charset = HANGEUL_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = #54620#52980' '#48177#51228' B'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 4
    OnClick = PadBtnNum0Click
  end
  object PadBtnNum8: TButton
    Tag = 8
    Left = 78
    Top = 162
    Width = 50
    Height = 50
    Caption = '8'
    Font.Charset = HANGEUL_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = #54620#52980' '#48177#51228' B'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 5
    OnClick = PadBtnNum0Click
  end
  object PadBtnPlus: TButton
    Tag = 11
    Left = 202
    Top = 97
    Width = 50
    Height = 50
    Caption = '+'
    Font.Charset = HANGEUL_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = #54620#52980' '#48177#51228' B'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 6
    OnClick = PadBtnPlusClick
  end
  object PadBtnNum4: TButton
    Tag = 4
    Left = 16
    Top = 228
    Width = 50
    Height = 50
    Caption = '4'
    Font.Charset = HANGEUL_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = #54620#52980' '#48177#51228' B'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 7
    OnClick = PadBtnNum0Click
  end
  object PadBtnNum5: TButton
    Tag = 5
    Left = 78
    Top = 228
    Width = 50
    Height = 50
    Caption = '5'
    Font.Charset = HANGEUL_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = #54620#52980' '#48177#51228' B'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 8
    OnClick = PadBtnNum0Click
  end
  object PadBtnNum9: TButton
    Tag = 9
    Left = 140
    Top = 162
    Width = 50
    Height = 50
    Caption = '9'
    Font.Charset = HANGEUL_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = #54620#52980' '#48177#51228' B'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 9
    OnClick = PadBtnNum0Click
  end
  object PadBtnNum1: TButton
    Tag = 1
    Left = 16
    Top = 293
    Width = 50
    Height = 50
    Caption = '1'
    Font.Charset = HANGEUL_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = #54620#52980' '#48177#51228' B'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 10
    OnClick = PadBtnNum0Click
  end
  object PadBtnNum2: TButton
    Tag = 2
    Left = 78
    Top = 293
    Width = 50
    Height = 50
    Caption = '2'
    Font.Charset = HANGEUL_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = #54620#52980' '#48177#51228' B'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 11
    OnClick = PadBtnNum0Click
  end
  object PadBtnNum6: TButton
    Tag = 6
    Left = 140
    Top = 228
    Width = 50
    Height = 50
    Caption = '6'
    Font.Charset = HANGEUL_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = #54620#52980' '#48177#51228' B'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 12
    OnClick = PadBtnNum0Click
  end
  object PadBtnNum0: TButton
    Left = 16
    Top = 359
    Width = 112
    Height = 50
    Caption = '0'
    Font.Charset = HANGEUL_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = #54620#52980' '#48177#51228' B'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 13
    OnClick = PadBtnNum0Click
  end
  object PadBtnDot: TButton
    Tag = 10
    Left = 140
    Top = 359
    Width = 50
    Height = 50
    Caption = '.'
    Font.Charset = HANGEUL_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = #54620#52980' '#48177#51228' B'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 14
    OnClick = PadBtnNum0Click
  end
  object PadBtnNum3: TButton
    Tag = 3
    Left = 140
    Top = 293
    Width = 50
    Height = 50
    Caption = '3'
    Font.Charset = HANGEUL_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = #54620#52980' '#48177#51228' B'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 15
    OnClick = PadBtnNum0Click
  end
  object PadBtnMin: TButton
    Tag = 12
    Left = 202
    Top = 162
    Width = 50
    Height = 50
    Caption = '-'
    Font.Charset = HANGEUL_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = #54620#52980' '#48177#51228' B'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 16
    OnClick = PadBtnPlusClick
  end
  object PadBtnMul: TButton
    Tag = 13
    Left = 202
    Top = 228
    Width = 50
    Height = 50
    Caption = '*'
    Font.Charset = HANGEUL_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = #54620#52980' '#48177#51228' B'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 17
    OnClick = PadBtnPlusClick
  end
  object PadBtnDiv: TButton
    Tag = 14
    Left = 202
    Top = 293
    Width = 50
    Height = 50
    Caption = '/'
    Font.Charset = HANGEUL_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = #54620#52980' '#48177#51228' B'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 18
    OnClick = PadBtnPlusClick
  end
  object PadBtnEqual: TButton
    Tag = 15
    Left = 202
    Top = 359
    Width = 50
    Height = 50
    Caption = '='
    Font.Charset = HANGEUL_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = #54620#52980' '#48177#51228' B'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 19
    OnClick = PadBtnEqualClick
  end
end
