object FCal: TFCal
  Left = 0
  Top = 0
  AutoSize = True
  Caption = #44228#49328#44592
  ClientHeight = 433
  ClientWidth = 345
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 345
    Height = 433
    Color = clMenuText
    ParentBackground = False
    TabOrder = 0
    object Button1: TButton
      Left = 14
      Top = 88
      Width = 75
      Height = 57
      Caption = 'AC'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Tag = 15
      Left = 95
      Top = 88
      Width = 75
      Height = 57
      Caption = '/'
      TabOrder = 1
      OnClick = Button17Click
    end
    object Button3: TButton
      Tag = 14
      Left = 176
      Top = 88
      Width = 75
      Height = 57
      Caption = '*'
      TabOrder = 2
      OnClick = Button17Click
    end
    object Button4: TButton
      Left = 257
      Top = 88
      Width = 75
      Height = 57
      Caption = 'x'
      TabOrder = 3
      OnClick = Button4Click
    end
    object Button5: TButton
      Tag = 7
      Left = 14
      Top = 168
      Width = 75
      Height = 59
      Caption = '7'
      TabOrder = 4
      OnClick = Button5Click
    end
    object Button6: TButton
      Tag = 8
      Left = 95
      Top = 168
      Width = 75
      Height = 59
      Caption = '8'
      TabOrder = 5
      OnClick = Button5Click
    end
    object Button7: TButton
      Tag = 9
      Left = 176
      Top = 168
      Width = 75
      Height = 59
      Caption = '9'
      TabOrder = 6
      OnClick = Button5Click
    end
    object Button8: TButton
      Tag = 4
      Left = 14
      Top = 233
      Width = 75
      Height = 59
      Caption = '4'
      TabOrder = 7
      OnClick = Button5Click
    end
    object Button9: TButton
      Tag = 5
      Left = 95
      Top = 233
      Width = 75
      Height = 59
      Caption = '5'
      TabOrder = 8
      OnClick = Button5Click
    end
    object Button10: TButton
      Tag = 6
      Left = 176
      Top = 233
      Width = 75
      Height = 59
      Caption = '6'
      TabOrder = 9
      OnClick = Button5Click
    end
    object Button11: TButton
      Tag = 1
      Left = 14
      Top = 298
      Width = 75
      Height = 59
      Caption = '1'
      TabOrder = 10
      OnClick = Button5Click
    end
    object Button12: TButton
      Tag = 2
      Left = 95
      Top = 298
      Width = 75
      Height = 59
      Caption = '2'
      TabOrder = 11
      OnClick = Button5Click
    end
    object Button13: TButton
      Tag = 3
      Left = 176
      Top = 298
      Width = 75
      Height = 59
      Caption = '3'
      TabOrder = 12
      OnClick = Button5Click
    end
    object Button14: TButton
      Left = 14
      Top = 363
      Width = 156
      Height = 59
      Caption = '0'
      TabOrder = 13
      OnClick = Button5Click
    end
    object Button15: TButton
      Tag = 11
      Left = 176
      Top = 363
      Width = 75
      Height = 59
      Caption = '.'
      TabOrder = 14
      OnClick = Button5Click
    end
    object Button16: TButton
      Tag = 13
      Left = 257
      Top = 168
      Width = 75
      Height = 59
      Caption = '-'
      TabOrder = 15
      OnClick = Button17Click
    end
    object Button17: TButton
      Tag = 12
      Left = 257
      Top = 233
      Width = 75
      Height = 59
      Caption = '+'
      TabOrder = 16
      OnClick = Button17Click
    end
    object Button18: TButton
      Left = 257
      Top = 298
      Width = 75
      Height = 124
      Caption = '='
      TabOrder = 17
      OnClick = Button18Click
    end
    object edDisplay: TEdit
      Left = 14
      Top = 8
      Width = 318
      Height = 57
      AutoSelect = False
      AutoSize = False
      BevelKind = bkSoft
      BevelOuter = bvRaised
      BevelWidth = 5
      ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
      TabOrder = 18
    end
  end
end
