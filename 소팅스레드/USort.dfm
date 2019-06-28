object SortForm: TSortForm
  Left = 212
  Top = 110
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #49548#54021' '#50508#44256#47532#51608' '#44208#44284
  ClientHeight = 295
  ClientWidth = 731
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 14
    Top = 8
    Width = 55
    Height = 13
    Caption = 'Bubble Sort'
  end
  object Label2: TLabel
    Left = 198
    Top = 8
    Width = 66
    Height = 13
    Caption = 'Selection Sort'
  end
  object Label3: TLabel
    Left = 383
    Top = 8
    Width = 50
    Height = 13
    Caption = 'Quick Sort'
  end
  object Label4: TLabel
    Left = 567
    Top = 8
    Width = 48
    Height = 13
    Caption = #49548#54021#44208#44284
  end
  object StartBtn: TButton
    Left = 557
    Top = 256
    Width = 162
    Height = 31
    Caption = #49548#54021' '#49884#51089
    TabOrder = 0
    OnClick = StartBtnClick
  end
  object BubbleSort_ListBox: TListBox
    Left = 13
    Top = 27
    Width = 162
    Height = 209
    ItemHeight = 13
    TabOrder = 1
  end
  object SelectionSort_ListBox: TListBox
    Left = 196
    Top = 27
    Width = 162
    Height = 209
    ItemHeight = 13
    TabOrder = 2
  end
  object QuickSort_ListBox: TListBox
    Left = 379
    Top = 27
    Width = 162
    Height = 209
    ItemHeight = 13
    TabOrder = 3
  end
  object Result_ListBox: TListBox
    Left = 557
    Top = 27
    Width = 162
    Height = 209
    ItemHeight = 13
    TabOrder = 4
  end
end
