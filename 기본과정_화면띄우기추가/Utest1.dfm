object Form1: TForm1
  Left = 0
  Top = 0
  ActiveControl = Edit1
  Caption = 'Form1'
  ClientHeight = 478
  ClientWidth = 899
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  StyleElements = [seFont, seClient]
  StyleName = 'auric'
  OnActivate = FormActivate
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object MyButton: TButton
    Left = 24
    Top = 23
    Width = 105
    Height = 33
    Caption = 'Close'
    TabOrder = 0
    OnClick = MyButtonClick
  end
  object Button1: TButton
    Left = 152
    Top = 24
    Width = 105
    Height = 33
    Caption = #49549#49457#48320#44221
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 280
    Top = 22
    Width = 97
    Height = 35
    Caption = #54648#46308#47084#44277#50976
    TabOrder = 2
    OnClick = MyButtonClick
  end
  object Button3: TButton
    Left = 408
    Top = 22
    Width = 105
    Height = 35
    Caption = #54648#46308#47084#54840#52636
    TabOrder = 3
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 24
    Top = 80
    Width = 105
    Height = 33
    Caption = #48320#49688
    TabOrder = 4
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 152
    Top = 80
    Width = 105
    Height = 33
    Caption = #54532#47196#49884#51200
    TabOrder = 5
    OnClick = Button5Click
  end
  object Button6: TButton
    Left = 288
    Top = 80
    Width = 89
    Height = 33
    Caption = 'Add'
    TabOrder = 6
    OnClick = Button6Click
  end
  object Button7: TButton
    Left = 408
    Top = 80
    Width = 105
    Height = 33
    Caption = 'Divide'
    TabOrder = 7
    OnClick = Button7Click
  end
  object Button8: TButton
    Left = 24
    Top = 144
    Width = 105
    Height = 33
    Caption = 'th '#49373#49457
    TabOrder = 8
    OnClick = Button8Click
  end
  object GroupBox1: TGroupBox
    Left = 152
    Top = 144
    Width = 361
    Height = 298
    Caption = 'th '#51221#48372
    TabOrder = 9
    object Edit2: TEdit
      Left = 24
      Top = 51
      Width = 121
      Height = 21
      TabOrder = 1
      OnKeyPress = Edit2KeyPress
    end
    object Edit3: TEdit
      Left = 24
      Top = 78
      Width = 121
      Height = 21
      TabOrder = 2
    end
    object Edit4: TEdit
      Left = 24
      Top = 105
      Width = 121
      Height = 21
      TabOrder = 3
    end
    object Edit5: TEdit
      Left = 208
      Top = 24
      Width = 121
      Height = 21
      NumbersOnly = True
      TabOrder = 4
    end
    object Edit6: TEdit
      Left = 208
      Top = 51
      Width = 121
      Height = 21
      TabOrder = 5
    end
    object Edit7: TEdit
      Left = 208
      Top = 78
      Width = 121
      Height = 21
      TabOrder = 6
    end
    object Edit8: TEdit
      Left = 208
      Top = 105
      Width = 121
      Height = 21
      TabOrder = 7
    end
    object Edit1: TEdit
      Left = 24
      Top = 24
      Width = 121
      Height = 21
      TabOrder = 0
    end
  end
  object Button9: TButton
    Left = 24
    Top = 183
    Width = 105
    Height = 30
    Caption = #48260#53948#49373#49457'('#49688#46041')'
    TabOrder = 10
    OnClick = Button9Click
  end
  object Button10: TButton
    Left = 32
    Top = 256
    Width = 97
    Height = 33
    Caption = #48260#53948#54644#51228
    TabOrder = 11
    OnClick = Button10Click
  end
  object Button11: TButton
    Left = 32
    Top = 295
    Width = 97
    Height = 34
    Caption = 'Font'
    TabOrder = 12
    StyleName = 'windows10 blue'
    OnClick = Button11Click
  end
  object Button12: TButton
    Left = 32
    Top = 335
    Width = 97
    Height = 34
    Caption = 'Color'
    TabOrder = 13
    StyleName = 'silver'
    OnClick = Button12Click
  end
  object Button13: TButton
    Left = 32
    Top = 375
    Width = 97
    Height = 34
    Caption = 'Show'
    TabOrder = 14
    StyleName = 'carbon'
    OnClick = Button13Click
  end
  object Button14: TButton
    Left = 32
    Top = 415
    Width = 97
    Height = 33
    Caption = 'ShowModal'
    TabOrder = 15
    StyleName = 'ruby Graphite'
    OnClick = Button14Click
  end
  object Panel1: TPanel
    Left = 515
    Top = 0
    Width = 384
    Height = 478
    Align = alRight
    BevelInner = bvLowered
    Caption = 'Panel1'
    DockSite = True
    DragKind = dkDock
    TabOrder = 16
  end
  object Button15: TButton
    Left = 32
    Top = 454
    Width = 97
    Height = 25
    Caption = 'FLOAT'
    TabOrder = 17
    OnClick = Button15Click
  end
  object FontDialog1: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Left = 24
    Top = 216
  end
end
