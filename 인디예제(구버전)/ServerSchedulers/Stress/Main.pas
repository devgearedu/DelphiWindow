unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, INIFiles;

type
  TformMain = class(TForm)
    editHost: TEdit;
    lablHost: TLabel;
    butnStart: TButton;
    Label1: TLabel;
    editClients: TEdit;
    butnStop: TButton;
    chckReconnect: TCheckBox;
    memoResults: TMemo;
    Label2: TLabel;
    Label3: TLabel;
    editAutoStop: TEdit;
    timrStop: TTimer;
    timrDisplay: TTimer;
    lablElapsedTime: TLabel;
    chckCopyResults: TCheckBox;
    procedure butnStartClick(Sender: TObject);
    procedure butnStopClick(Sender: TObject);
    procedure timrDisplayTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
  protected
    FINIFile: TINIFile;
    FTimerDisplay: Integer;
  public
  end;

var
  formMain: TformMain;

implementation
{$R *.dfm}

uses
  Clipbrd, ClientThread;

procedure TformMain.butnStartClick(Sender: TObject);
var
  i: Integer;
begin
  butnStart.Enabled := False;
  memoResults.Clear;

  timrStop.Interval := StrToIntDef(editAutoStop.Text, 0) * 1000;
  timrStop.Enabled := timrStop.Interval > 0;

  FTimerDisplay := 0;
  timrDisplay.Enabled := True;
  timrDisplayTimer(Sender);
  lablElapsedTime.Visible := True;

  for i := 1 to StrToIntDef(editClients.Text, 0) do begin
    with TClientThread.Create do begin
      Host := Trim(editHost.Text);
      Reconnect := chckReconnect.Checked;
      Start;
    end;
  end;
  butnStop.Enabled := True;
end;

procedure TformMain.butnStopClick(Sender: TObject);
var
  i: Integer;
  LThreadCount: Integer;
  LCountTotal: Cardinal;
begin
  timrStop.Enabled := False;
  timrDisplay.Enabled := False;

  LCountTotal := 0;
  memoResults.Lines.Add('-- Individual Reports --');

  // Stop them first so they dont sequentially disconnect
  with GThreads.LockList do try
    LThreadCount := Count;
    for i := Count - 1 downto 0 do begin
      TClientThread(Items[i]).Stop;
    end;
  finally GThreads.UnlockList; end;

  // Now go and catch results and free
  with GThreads.LockList do try
    for i := Count - 1 downto 0 do begin
      with TClientThread(Items[i]) do begin
        WaitFor;
        LCountTotal := LCountTotal + Trunc(Count / Time);
        memoResults.Lines.Add(IntToStr(Trunc(Count / Time)) + ' per second.');
        Free;
      end;
      Delete(i);
    end;
  finally GThreads.UnlockList; end;

  memoResults.Lines.Insert(0, '');
  memoResults.Lines.Insert(0, IntToStr(Trunc(LCountTotal / LThreadCount))
   + ' per second per thread.');
  memoResults.Lines.Insert(0, '-- Summary Report --');

  if chckCopyResults.Checked then begin
    Clipboard.AsText := memoResults.Lines.Text;
  end;

  butnStop.Enabled := False;
  butnStart.Enabled := True;
end;

procedure TformMain.timrDisplayTimer(Sender: TObject);
begin
  Inc(FTimerDisplay);
  lablElapsedTime.Caption := IntToStr(FTimerDisplay) + ' seconds';
end;

procedure TformMain.FormCreate(Sender: TObject);
begin
  FINIFile := TINIFile.Create(ChangeFileExt(Application.EXEName, '.ini'));
  with FINIFile do begin
    editHost.Text := ReadString('Main', 'Host', '');
    editClients.Text := ReadString('Main', 'Clients', '');
    editAutoStop.Text := ReadString('Main', 'Seconds', '');
    chckReconnect.Checked := Boolean(ReadInteger('Main', 'Reconnect', 0));
  end;
end;

procedure TformMain.FormDestroy(Sender: TObject);
begin
  with FINIFile do begin
    WriteString('Main', 'Host', Trim(editHost.Text));
    WriteString('Main', 'Clients', Trim(editClients.Text));
    WriteString('Main', 'Seconds', Trim(editAutoStop.Text));
    WriteInteger('Main', 'Reconnect', Integer(chckReconnect.Checked));
  end;
  FreeAndNil(FINIFile);
end;

end.
