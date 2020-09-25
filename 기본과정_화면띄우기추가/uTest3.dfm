object Form3: TForm3
  Left = 0
  Top = 0
  Caption = 'Form3'
  ClientHeight = 331
  ClientWidth = 535
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  StyleName = 'windows10 purple'
  PixelsPerInch = 96
  TextHeight = 13
  object MonthCalendar1: TMonthCalendar
    Left = 8
    Top = 8
    Width = 233
    Height = 201
    Date = 44096.000000000000000000
    FirstDayOfWeek = dowMonday
    TabOrder = 0
  end
  object DateTimePicker1: TDateTimePicker
    Left = 8
    Top = 232
    Width = 233
    Height = 21
    Date = 44096.000000000000000000
    Time = 0.465363900460943100
    ParseInput = True
    TabOrder = 1
    OnUserInput = DateTimePicker1UserInput
  end
  object DateTimePicker2: TDateTimePicker
    Left = 8
    Top = 259
    Width = 233
    Height = 21
    Date = 44096.000000000000000000
    Time = 0.474039490742143200
    TabOrder = 2
  end
  object CalendarPicker1: TCalendarPicker
    Left = 272
    Top = 232
    Width = 209
    Height = 32
    CalendarHeaderInfo.DaysOfWeekFont.Charset = DEFAULT_CHARSET
    CalendarHeaderInfo.DaysOfWeekFont.Color = clWindowText
    CalendarHeaderInfo.DaysOfWeekFont.Height = -13
    CalendarHeaderInfo.DaysOfWeekFont.Name = 'Segoe UI'
    CalendarHeaderInfo.DaysOfWeekFont.Style = []
    CalendarHeaderInfo.Font.Charset = DEFAULT_CHARSET
    CalendarHeaderInfo.Font.Color = clWindowText
    CalendarHeaderInfo.Font.Height = -20
    CalendarHeaderInfo.Font.Name = 'Segoe UI'
    CalendarHeaderInfo.Font.Style = []
    Color = clWindow
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGray
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    TextHint = 'select a date'
  end
  object CalendarView1: TCalendarView
    Left = 272
    Top = 25
    Width = 217
    Height = 201
    Date = 44096.000000000000000000
    FirstDayOfWeek = dwMonday
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'Segoe UI'
    Font.Style = []
    HeaderInfo.DaysOfWeekFont.Charset = DEFAULT_CHARSET
    HeaderInfo.DaysOfWeekFont.Color = clWindowText
    HeaderInfo.DaysOfWeekFont.Height = -13
    HeaderInfo.DaysOfWeekFont.Name = 'Segoe UI'
    HeaderInfo.DaysOfWeekFont.Style = []
    HeaderInfo.Font.Charset = DEFAULT_CHARSET
    HeaderInfo.Font.Color = clWindowText
    HeaderInfo.Font.Height = -20
    HeaderInfo.Font.Name = 'Segoe UI'
    HeaderInfo.Font.Style = []
    ParentFont = False
    TabOrder = 4
  end
  object Button1: TButton
    Left = 11
    Top = 295
    Width = 75
    Height = 25
    Caption = 'Yes'
    ModalResult = 6
    TabOrder = 5
  end
  object Button2: TButton
    Left = 104
    Top = 298
    Width = 75
    Height = 25
    Caption = 'No'
    ModalResult = 7
    TabOrder = 6
  end
  object BitBtn1: TBitBtn
    Left = 296
    Top = 298
    Width = 75
    Height = 25
    Kind = bkYes
    Layout = blGlyphRight
    NumGlyphs = 2
    TabOrder = 7
  end
  object BitBtn2: TBitBtn
    Left = 392
    Top = 296
    Width = 75
    Height = 25
    Kind = bkNo
    NumGlyphs = 2
    TabOrder = 8
  end
  object DatePicker1: TDatePicker
    Left = 272
    Top = 272
    Width = 209
    Height = 21
    Date = 44096.000000000000000000
    DateFormat = 'yyyy/MM/dd'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = []
    TabOrder = 9
  end
end
