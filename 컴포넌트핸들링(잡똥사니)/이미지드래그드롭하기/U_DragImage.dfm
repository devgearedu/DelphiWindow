object Form1: TForm1
  Left = 199
  Top = 104
  Caption = 'Drag Image Demo'
  ClientHeight = 603
  ClientWidth = 688
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object ScrollBox1: TScrollBox
    Left = 0
    Top = 41
    Width = 185
    Height = 562
    Align = alLeft
    TabOrder = 0
    object Shape2: TShape
      Left = 24
      Top = 16
      Width = 50
      Height = 90
      Brush.Color = clMaroon
      DragMode = dmAutomatic
      OnDragDrop = Shape1DragDrop
      OnDragOver = Shape1DragOver
      OnStartDrag = Shape1StartDrag
    end
    object Shape3: TShape
      Left = 16
      Top = 112
      Width = 100
      Height = 73
      Brush.Color = 16777088
      DragMode = dmAutomatic
      OnDragDrop = Shape1DragDrop
      OnDragOver = Shape1DragOver
      OnStartDrag = Shape1StartDrag
    end
    object Shape4: TShape
      Left = 16
      Top = 208
      Width = 100
      Height = 90
      Brush.Color = clRed
      DragMode = dmAutomatic
      OnDragDrop = Shape1DragDrop
      OnDragOver = Shape1DragOver
      OnStartDrag = Shape1StartDrag
    end
    object Shape5: TShape
      Left = 16
      Top = 312
      Width = 100
      Height = 40
      Brush.Color = clBlue
      DragMode = dmAutomatic
      OnDragDrop = Shape1DragDrop
      OnDragOver = Shape1DragOver
      OnStartDrag = Shape1StartDrag
    end
    object Shape8: TShape
      Left = 16
      Top = 375
      Width = 136
      Height = 70
      Brush.Color = 16744703
      DragMode = dmAutomatic
      OnDragDrop = Shape1DragDrop
      OnDragOver = Shape1DragOver
      OnStartDrag = Shape1StartDrag
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 688
    Height = 41
    Align = alTop
    TabOrder = 1
    object SnapBox: TCheckBox
      Left = 424
      Top = 8
      Width = 185
      Height = 17
      Caption = 'Snap dropped panels up and  left'
      TabOrder = 0
      OnClick = SnapBoxClick
    end
  end
  object ScrollBox2: TScrollBox
    Left = 185
    Top = 41
    Width = 503
    Height = 562
    Align = alClient
    TabOrder = 2
    object Panel2: TPanel
      Left = 32
      Top = 24
      Width = 425
      Height = 193
      TabOrder = 0
    end
    object Panel3: TPanel
      Left = 32
      Top = 223
      Width = 425
      Height = 169
      TabOrder = 1
    end
  end
  object DragImageList: TImageList
    Left = 259
    Top = 91
  end
end
