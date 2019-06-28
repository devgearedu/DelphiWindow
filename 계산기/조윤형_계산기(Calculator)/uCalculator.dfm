object frmCalculator: TfrmCalculator
  Left = 0
  Top = 0
  Caption = 'Calculator'
  ClientHeight = 326
  ClientWidth = 252
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Tag = 7
    Left = 7
    Top = 139
    Width = 40
    Height = 40
    Caption = '7'
    TabOrder = 0
    OnClick = Number_Input
  end
  object Button2: TButton
    Tag = 8
    Left = 53
    Top = 139
    Width = 40
    Height = 40
    Caption = '8'
    TabOrder = 1
    OnClick = Number_Input
  end
  object Button3: TButton
    Tag = 9
    Left = 99
    Top = 139
    Width = 40
    Height = 40
    Caption = '9'
    TabOrder = 2
    OnClick = Number_Input
  end
  object Button4: TButton
    Tag = 4
    Left = 7
    Top = 185
    Width = 40
    Height = 40
    Caption = '4'
    TabOrder = 3
    OnClick = Number_Input
  end
  object Button5: TButton
    Tag = 5
    Left = 53
    Top = 185
    Width = 40
    Height = 40
    Caption = '5'
    TabOrder = 4
    OnClick = Number_Input
  end
  object Button6: TButton
    Tag = 6
    Left = 99
    Top = 185
    Width = 40
    Height = 40
    Caption = '6'
    TabOrder = 5
    OnClick = Number_Input
  end
  object Button7: TButton
    Left = 99
    Top = 277
    Width = 40
    Height = 40
    Caption = '.'
    TabOrder = 6
    OnClick = Button7Click
  end
  object Button8: TButton
    Tag = 1
    Left = 7
    Top = 231
    Width = 40
    Height = 40
    Caption = '1'
    TabOrder = 7
    OnClick = Number_Input
  end
  object Button9: TButton
    Tag = 15
    Left = 206
    Top = 139
    Width = 40
    Height = 40
    Caption = '('
    TabOrder = 8
    OnClick = rb_Input
  end
  object Button10: TButton
    Tag = 20
    Left = 206
    Top = 231
    Width = 40
    Height = 86
    Caption = '='
    TabOrder = 9
    OnClick = Button10Click
  end
  object Button11: TButton
    Tag = 13
    Left = 160
    Top = 185
    Width = 40
    Height = 40
    Caption = '*'
    TabOrder = 10
    OnClick = Cal_Input
  end
  object Button12: TButton
    Tag = 11
    Left = 160
    Top = 277
    Width = 40
    Height = 40
    Caption = '+'
    TabOrder = 11
    OnClick = Cal_Input
  end
  object Button13: TButton
    Tag = 14
    Left = 160
    Top = 139
    Width = 40
    Height = 40
    Caption = '/'
    TabOrder = 12
    OnClick = Cal_Input
  end
  object Button14: TButton
    Tag = 15
    Left = 206
    Top = 185
    Width = 40
    Height = 40
    Caption = ')'
    TabOrder = 13
    OnClick = rb_Input
  end
  object Button15: TButton
    Tag = 3
    Left = 99
    Top = 231
    Width = 40
    Height = 40
    Caption = '3'
    TabOrder = 14
    OnClick = Number_Input
  end
  object Button17: TButton
    Left = 8
    Top = 277
    Width = 85
    Height = 40
    Caption = '0'
    TabOrder = 15
    OnClick = Number_Input
  end
  object Button19: TButton
    Tag = 2
    Left = 53
    Top = 231
    Width = 40
    Height = 40
    Caption = '2'
    TabOrder = 16
    OnClick = Number_Input
  end
  object Button20: TButton
    Tag = 12
    Left = 160
    Top = 231
    Width = 40
    Height = 40
    Caption = '-'
    TabOrder = 17
    OnClick = Cal_Input
  end
  object btnClear: TButton
    Tag = 22
    Left = 54
    Top = 93
    Width = 40
    Height = 40
    Caption = 'Clear'
    TabOrder = 18
    OnClick = btnClearClick
  end
  object btnBackspace: TButton
    Tag = 21
    Left = 8
    Top = 93
    Width = 40
    Height = 40
    Caption = #8592
    TabOrder = 19
    OnClick = btnBackspaceClick
  end
  object lbPrint: TListBox
    Left = 8
    Top = 8
    Width = 236
    Height = 79
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = []
    ItemHeight = 23
    Items.Strings = (
      ''
      '0'
      '0')
    ParentFont = False
    TabOrder = 20
  end
  object btn_NumChage: TButton
    Tag = 22
    Left = 160
    Top = 93
    Width = 40
    Height = 40
    Caption = #177
    TabOrder = 21
    OnClick = btn_NumChageClick
  end
end
