unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IdBaseComponent, IdComponent, IdTCPServer, IdContext,
  IdScheduler, IdSchedulerOfThread, IdSchedulerOfThreadDefault, StdCtrls,
  IdSchedulerOfThreadPool, IdThreadSafe, IdServerIOHandler,
  IdServerIOHandlerChain, IdSchedulerOfFiber, IdIOHandlerChain,
  IdFiberWeaver, IdFiberWeaverThreaded;

type
  TformMain = class(TForm)
    tcpsTest: TIdTCPServer;
    schdThread: TIdSchedulerOfThreadDefault;
    butnStart: TButton;
    schdThreadPool: TIdSchedulerOfThreadPool;
    GroupBox1: TGroupBox;
    rbtnFiberSingleThread: TRadioButton;
    Label2: TLabel;
    rbtnThreadPool: TRadioButton;
    rbtnThread: TRadioButton;
    Label1: TLabel;
    radoFiberSingleThreadChain: TRadioButton;
    memoLog: TMemo;
    butnStop: TButton;
    indySchedulerOfFiberAlone: TIdSchedulerOfFiber;
    indySchedulerOfFiber: TIdSchedulerOfFiber;
    indyIOHChain: TIdServerIOHandlerChain;
    indyChainEngine: TIdChainEngine;
    indyFiberWeaverThreaded: TIdFiberWeaverThreaded;
    indyThreadPoolForFibers: TIdSchedulerOfThreadPool;
    procedure tcpsTestExecute(AContext: TIdContext);
    procedure butnStartClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure butnStopClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure tcpsTestConnect(AContext: TIdContext);
  private
  protected
    FConnections: TIdThreadSafeInteger;
    FReplies: TIdThreadSafeInteger;
  public
  end;

var
  formMain: TformMain;

implementation
{$R *.dfm}

procedure TformMain.tcpsTestExecute(AContext: TIdContext);
var
  s: string;
begin
  with AContext.Connection do begin
    s := IOHandler.ReadLn;
    if AnsiSameText(s, 'QUIT') then begin
      Disconnect;
    end else begin
      FReplies.Increment;
      IOHandler.WriteLn('Hello ' + s);
    end;
  end;
end;

procedure TformMain.butnStartClick(Sender: TObject);
begin
  memoLog.Clear;
  FConnections.Value := 0;
  FReplies.Value := 0;
  if rbtnThread.Checked then begin
    tcpsTest.Scheduler := schdThread;
  end else if rbtnThreadPool.Checked then begin
    tcpsTest.Scheduler := schdThreadPool;
  end else if rbtnFiberSingleThread.Checked then begin
    //No IOHandler, can only swap between calls to OnExecute
    tcpsTest.Scheduler := indySchedulerOfFiberAlone;
  end else if radoFiberSingleThreadChain.Checked then begin
    tcpsTest.IOHandler := indyIOHChain;
    tcpsTest.Scheduler := indySchedulerOfFiber;
  end;
  tcpsTest.Active := True;
  butnStart.Enabled := False;
end;

procedure TformMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // Necessary because during destruction of form, it tries to destroy
  // schedulers while server is still active
  tcpsTest.Active := False;
end;

procedure TformMain.butnStopClick(Sender: TObject);
begin
  tcpsTest.Active := False;
  with memoLog.Lines do begin
    Add('Connections: ' + IntToStr(FConnections.Value));
    Add('Replies: ' + IntToStr(FReplies.Value));
  end;
  butnStop.Enabled := False;
end;

procedure TformMain.FormCreate(Sender: TObject);
begin
  FConnections := TIdThreadSafeInteger.Create;
  FReplies := TIdThreadSafeInteger.Create;
end;

procedure TformMain.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FReplies);
  FreeAndNil(FConnections);
end;

procedure TformMain.tcpsTestConnect(AContext: TIdContext);
begin
  FConnections.Increment;
end;

end.
