object Form16: TForm16
  Left = 0
  Top = 0
  Caption = 'Form16'
  ClientHeight = 459
  ClientWidth = 833
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
  object Ribbon1: TRibbon
    Left = 0
    Top = 0
    Width = 833
    Height = 143
    Caption = 'Ribbon1'
    Tabs = <
      item
        Caption = #44592#51316#54168#51060#51648
        Page = RibbonPage1
      end>
    DesignSize = (
      833
      143)
    StyleName = 'Ribbon - Luna'
    object RibbonPage1: TRibbonPage
      Left = 0
      Top = 50
      Width = 832
      Height = 93
      Caption = #44592#51316#54168#51060#51648
      Index = 0
      object RibbonGroup1: TRibbonGroup
        Left = 4
        Top = 3
        Width = 89
        Height = 86
        ActionManager = ActionManager1
        Caption = #44592#51316#47532#48376#44536#47353
        GroupIndex = 0
      end
    end
  end
  object ActionManager1: TActionManager
    ActionBars = <
      item
        Items = <
          item
            Action = Action1
          end>
        ActionBar = RibbonGroup1
      end>
    Left = 56
    Top = 192
    StyleName = 'Platform Default'
    object Action1: TAction
      Category = 'File'
      Caption = #49444#44228#49884#51216#47700#45684
      OnExecute = Action1Execute
    end
  end
end
