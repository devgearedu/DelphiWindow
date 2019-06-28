unit uPanelClock;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.ExtCtrls;

type
  TPanelClock = class(TPanel)
  private
    t:TTimer;
    Fformat: string;
    FClockEnabled: boolean;
    FCloclInterval: integer;
    FSetTime: string;
    FOnSetTime: TnotiFyEvent;
    procedure DisplayTime(Sender:TObject);
    procedure Setformat(const Value: string);
    procedure SetClockEnabled(const Value: boolean);
    procedure SetCloclInterval(const Value: integer);
    procedure SetSetTime(const Value: string);
    procedure SetOnSetTime(const Value: TnotiFyEvent);
    { Private declarations }
  protected
    { Protected declarations }
  public
    constructor create(aowner:tcomponent); override;
    destructor Destroy; override;
    { Public declarations }
  published
    property OnSetTime:TnotiFyEvent read FOnSetTime write SetOnSetTime;
    property SetTime:string read FSetTime write SetSetTime;
    property CloclInterval:integer read FCloclInterval write SetCloclInterval;
    property ClockEnabled:boolean read FClockEnabled write SetClockEnabled;
    property format:string read Fformat write Setformat;
    { Published declarations }
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Samples', [TPanelClock]);
end;

{ TPanelClock }

constructor TPanelClock.create(aowner: tcomponent);
begin
  inherited;
  t := Ttimer.create(self);
  t.onTimer := DisplayTime;
  SetFormat('hh:nn:ss');
  SetClockEnabled(true);
  SetCloclInterval(1000);
end;

destructor TPanelClock.Destroy;
begin
  t.free;
  inherited;
end;

procedure TPanelClock.DisplayTime(Sender: TObject);
begin
  caption := FormatDateTime(fformat, now);
  if fSetTime <> '' then
    if FormatDateTime('hh:nn:ss' ,time) = fSetTime then
       if Assigned(fonsettime) then fonSetTime(self);

end;

procedure TPanelClock.SetClockEnabled(const Value: boolean);
begin
  FClockEnabled := Value;
  t.Enabled := value;
end;

procedure TPanelClock.SetCloclInterval(const Value: integer);
begin
  FCloclInterval := Value;
  t.Interval := value;
end;

procedure TPanelClock.Setformat(const Value: string);
begin
  Fformat := Value;
end;

procedure TPanelClock.SetOnSetTime(const Value: TnotiFyEvent);
begin
  FOnSetTime := Value;
end;

procedure TPanelClock.SetSetTime(const Value: string);
begin
  FSetTime := Value;
end;

end.
