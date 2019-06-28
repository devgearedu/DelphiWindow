object Form17: TForm17
  Left = 0
  Top = 0
  Caption = 'Form17'
  ClientHeight = 426
  ClientWidth = 781
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = #24494#36575#27491#40657#39636
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 20
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 781
    Height = 426
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'TabSheet1'
      object ListBox1: TListBox
        Left = 0
        Top = 0
        Width = 773
        Height = 321
        Align = alTop
        ImeName = 'Microsoft IME 2003'
        ItemHeight = 20
        TabOrder = 0
      end
      object Button1: TButton
        Left = 265
        Top = 327
        Width = 225
        Height = 57
        Caption = 'Button1'
        TabOrder = 1
        OnClick = Button1Click
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'TabSheet2'
      ImageIndex = 1
      object btnTarget: TButton
        Left = 40
        Top = 48
        Width = 209
        Height = 58
        Caption = '???'
        TabOrder = 0
        OnClick = btnTargetClick
      end
      object Button3: TButton
        Left = 40
        Top = 280
        Width = 209
        Height = 57
        Caption = 'Dynamic Invoke'
        TabOrder = 1
        OnClick = Button3Click
      end
    end
  end
end
