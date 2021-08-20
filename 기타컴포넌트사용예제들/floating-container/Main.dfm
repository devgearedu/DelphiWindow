object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'MainForm'
  ClientHeight = 237
  ClientWidth = 386
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 386
    Height = 237
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'TabSheet1'
      object Button1: TButton
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 372
        Height = 25
        Align = alTop
        Caption = 'Float tab 1'
        TabOrder = 0
        OnClick = Button1Click
      end
      object Memo1: TMemo
        AlignWithMargins = True
        Left = 3
        Top = 34
        Width = 372
        Height = 172
        Align = alClient
        Lines.Strings = (
          'Memo1')
        TabOrder = 1
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'TabSheet2'
      ImageIndex = 1
      object Memo2: TMemo
        AlignWithMargins = True
        Left = 3
        Top = 34
        Width = 372
        Height = 172
        Align = alClient
        Lines.Strings = (
          'Memo2')
        TabOrder = 0
      end
      object Button2: TButton
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 372
        Height = 25
        Align = alTop
        Caption = 'Float tab 2'
        TabOrder = 1
        OnClick = Button2Click
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'TabSheet3'
      ImageIndex = 2
      object Memo3: TMemo
        AlignWithMargins = True
        Left = 3
        Top = 34
        Width = 372
        Height = 172
        Align = alClient
        Lines.Strings = (
          'Memo3')
        TabOrder = 0
      end
      object Button3: TButton
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 372
        Height = 25
        Align = alTop
        Caption = 'Float tab 3'
        TabOrder = 1
        OnClick = Button3Click
      end
    end
  end
end
