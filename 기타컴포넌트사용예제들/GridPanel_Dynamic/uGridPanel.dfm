object Form28: TForm28
  Left = 0
  Top = 0
  Caption = 'Form28'
  ClientHeight = 201
  ClientWidth = 331
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
  object GridPanel1: TGridPanel
    Left = 0
    Top = 29
    Width = 331
    Height = 172
    Align = alClient
    Caption = 'GridPanel1'
    ColumnCollection = <
      item
        Value = 50.000000000000000000
      end
      item
        Value = 50.000000000000000000
      end>
    ControlCollection = <>
    RowCollection = <
      item
        Value = 50.000000000000000000
      end
      item
        Value = 50.000000000000000000
      end>
    TabOrder = 0
  end
  object ToolBar1: TToolBar
    Left = 0
    Top = 0
    Width = 331
    Height = 29
    ButtonHeight = 23
    Caption = 'ToolBar1'
    TabOrder = 1
    object Button1: TButton
      Left = 0
      Top = 0
      Width = 81
      Height = 23
      Caption = #53945#51221#50676','#52972#47100#44396#54616#44592
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 81
      Top = 0
      Width = 75
      Height = 23
      Align = alRight
      Caption = 'Button2'
      TabOrder = 1
      OnClick = Button2Click
    end
  end
end
