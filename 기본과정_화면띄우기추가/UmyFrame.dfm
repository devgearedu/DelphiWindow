object Frame1: TFrame1
  Left = 0
  Top = 0
  Width = 504
  Height = 363
  TabOrder = 0
  object DBChart1: TDBChart
    Left = 32
    Top = 24
    Width = 449
    Height = 257
    BackWall.Pen.Width = 5
    BottomWall.Color = clNavy
    BottomWall.Pen.Width = 6
    Title.Font.Height = -21
    Title.Text.Strings = (
      #52264#53944)
    Frame.Width = 5
    Legend.Color = clAqua
    Legend.TextStyle = ltsRightValue
    Pages.MaxPointsPerPage = 3
    View3DOptions.Zoom = 106
    BevelInner = bvLowered
    TabOrder = 0
    DefaultCanvas = 'TGDIPlusCanvas'
    PrintMargins = (
      15
      22
      15
      22)
    ColorPaletteIndex = 13
    object Series1: TBarSeries
      BarBrush.Gradient.EndColor = clRed
      BarPen.Width = 3
      DarkPen = 10
      Marks.Style = smsLabelPercent
      Marks.Arrow.Color = clNavy
      Marks.Arrow.Width = 4
      Marks.Callout.Arrow.Color = clNavy
      Marks.Callout.Arrow.Width = 4
      Marks.Callout.ArrowHeadSize = 10
      Marks.Callout.Length = 22
      SeriesColor = clRed
      BarWidthPercent = 80
      Gradient.EndColor = clRed
      Shadow.Color = 11316396
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Bar'
      YValues.Order = loNone
    end
  end
  object Button1: TButton
    Left = 32
    Top = 296
    Width = 75
    Height = 25
    Caption = #52376#51020
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 113
    Top = 296
    Width = 75
    Height = 25
    Caption = #51060#51204
    TabOrder = 2
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 32
    Top = 327
    Width = 75
    Height = 25
    Caption = #45796#51020
    TabOrder = 3
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 113
    Top = 327
    Width = 75
    Height = 25
    Caption = #47592#45149
    TabOrder = 4
    OnClick = Button4Click
  end
  object ColorGrid1: TColorGrid
    Left = 194
    Top = 298
    Width = 88
    Height = 64
    TabOrder = 5
    OnChange = ColorGrid1Change
  end
  object CheckBox1: TCheckBox
    Left = 320
    Top = 301
    Width = 161
    Height = 21
    Caption = '3D'
    Checked = True
    State = cbChecked
    TabOrder = 6
    OnClick = CheckBox1Click
  end
  object ComboBox1: TComboBox
    Left = 320
    Top = 328
    Width = 161
    Height = 21
    ItemIndex = 1
    TabOrder = 7
    Text = '100'
    OnChange = ComboBox1Change
    Items.Strings = (
      '75'
      '100'
      '125')
  end
end
