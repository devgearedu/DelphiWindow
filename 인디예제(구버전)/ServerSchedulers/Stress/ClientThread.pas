unit ClientThread;

interface

uses
  Classes,
  IdGlobal, IdTCPClient, IdThread;

type
  TClientThread = class(TIdThread)
  protected
    FCount: Cardinal;
    FHost: string;
    FReconnect: Boolean;
    FTCPClient: TIdTCPClient;
    FTimeFinish: Cardinal;
    FTimeStart: Cardinal;
    //
    procedure AfterRun; override;
    procedure BeforeRun; override;
    procedure Run; override;
  public
    function Time: Cardinal;
    //
    property Count: Cardinal read FCount;
    property Host: string read FHost write FHost;
    property Reconnect: Boolean read FReconnect write FReconnect;
  end;

var
  GThreads: TThreadList = nil;

implementation

uses
  SysUtils;

{ TClientThread }

procedure TClientThread.AfterRun;
begin
  if not Reconnect then begin
    FTCPClient.WriteLn('Quit');
    FTCPClient.Disconnect;
  end;

  FreeAndNil(FTCPClient);
  FTimeFinish := GetTickCount;
  inherited;
end;

procedure TClientThread.BeforeRun;
begin
  inherited;
  FTimeStart := GetTickCount;
  GThreads.Add(Self);
  FTCPClient := TIdTCPClient.Create(nil);
  with FTCPClient do begin
    Host := FHost;
    Port := 6000;
    if not Reconnect then begin
      Connect;
    end;
  end;
end;

procedure TClientThread.Run;
begin
  with FTCPClient do begin
    if Reconnect then begin
      Connect;
    end;
    WriteLn('Kudzu');
    ReadLn;
    if Reconnect then begin
      WriteLn('Quit');
      Disconnect;
    end;
  end;
  Inc(FCount);
end;

function TClientThread.Time: Cardinal;
begin
  Result := GetTickDiff(FTimeStart, FTimeFinish) div 1000;
end;

initialization
  GThreads := TThreadList.Create;
finalization
  FreeAndNil(GThreads);
end.
