unit ClientTask;

interface

uses
  IdTask, IdTCPClient;

type
  TClientTask = class(TIdTask)
  protected
    FCount: Integer;
    FClient: TIdTCPClient;
    FMaxCount: Integer;
  public
    procedure AfterRun; override;
    procedure BeforeRun; override;
    constructor Create(
      ACount: Integer
      ); reintroduce;
    function Run: Boolean; override;
  end;

implementation

uses
  SysUtils;

{ TClientTask }

procedure TClientTask.AfterRun;
begin
  FClient.IOHandler.WriteLn('Quit');
  FClient.Disconnect;
  FreeAndNil(FClient);
  inherited;
end;

procedure TClientTask.BeforeRun;
begin
  inherited;
  FCount := 0;
  FClient := TIdTCPClient.Create(nil);
  FClient.Connect('127.0.0.1', 6000);
end;

constructor TClientTask.Create(ACount: Integer);
begin
  inherited Create(nil);
  FMaxCount := ACount;
end;

function TClientTask.Run: Boolean;
begin
  FClient.IOHandler.WriteLn('Kudzu');
  FClient.IOHandler.ReadLn;
  Inc(FCount);
  Result := FCount < 500;
end;

end.
