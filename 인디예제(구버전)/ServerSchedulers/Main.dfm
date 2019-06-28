object formMain: TformMain
  Left = 265
  Top = 207
  Width = 612
  Height = 311
  ActiveControl = butnStart
  Caption = 'Server Scheduler Demo'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object butnStart: TButton
    Left = 184
    Top = 16
    Width = 75
    Height = 25
    Caption = 'Start'
    Default = True
    TabOrder = 0
    OnClick = butnStartClick
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 169
    Height = 145
    Caption = 'Scheduler'
    TabOrder = 1
    object Label2: TLabel
      Left = 8
      Top = 85
      Width = 28
      Height = 13
      Caption = 'Fibers'
    end
    object Label1: TLabel
      Left = 10
      Top = 21
      Width = 39
      Height = 13
      Caption = 'Threads'
    end
    object rbtnFiberSingleThread: TRadioButton
      Left = 8
      Top = 101
      Width = 153
      Height = 17
      Caption = '&Single Thread - Standard IO'
      TabOrder = 0
    end
    object rbtnThreadPool: TRadioButton
      Left = 8
      Top = 53
      Width = 113
      Height = 17
      Caption = '&Pooled'
      TabOrder = 1
    end
    object rbtnThread: TRadioButton
      Left = 8
      Top = 37
      Width = 113
      Height = 17
      Caption = '&Default'
      TabOrder = 2
    end
    object radoFiberSingleThreadChain: TRadioButton
      Left = 8
      Top = 117
      Width = 137
      Height = 17
      Caption = 'Single Thread - &Chain'
      Checked = True
      TabOrder = 3
      TabStop = True
    end
  end
  object memoLog: TMemo
    Left = 0
    Top = 160
    Width = 604
    Height = 117
    Align = alBottom
    ReadOnly = True
    TabOrder = 2
  end
  object butnStop: TButton
    Left = 184
    Top = 48
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Stop'
    TabOrder = 3
    OnClick = butnStopClick
  end
  object tcpsTest: TIdTCPServer
    Bindings = <>
    DefaultPort = 6000
    OnConnect = tcpsTestConnect
    OnExecute = tcpsTestExecute
    Left = 24
    Top = 168
  end
  object schdThread: TIdSchedulerOfThreadDefault
    MaxThreads = 0
    Left = 96
    Top = 168
  end
  object schdThreadPool: TIdSchedulerOfThreadPool
    MaxThreads = 0
    PoolSize = 5
    Left = 168
    Top = 168
  end
  object indySchedulerOfFiberAlone: TIdSchedulerOfFiber
    Left = 264
    Top = 168
  end
  object indySchedulerOfFiber: TIdSchedulerOfFiber
    FiberWeaver = indyFiberWeaverThreaded
    Left = 320
    Top = 8
  end
  object indyIOHChain: TIdServerIOHandlerChain
    ChainEngine = indyChainEngine
    Left = 480
    Top = 16
  end
  object indyChainEngine: TIdChainEngine
    Left = 480
    Top = 64
  end
  object indyFiberWeaverThreaded: TIdFiberWeaverThreaded
    ThreadScheduler = indyThreadPoolForFibers
    Left = 320
    Top = 56
  end
  object indyThreadPoolForFibers: TIdSchedulerOfThreadPool
    MaxThreads = 0
    Left = 320
    Top = 104
  end
end
