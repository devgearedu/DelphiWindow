unit umyDBGrid;

interface

uses
  System.SysUtils, Winapi.Messages,System.Classes, Vcl.Controls, Vcl.Grids, Vcl.DBGrids;

type
  tmydbgrid = class(TDBGrid)
  private
    FOnClick: TNotifyEvent;
    procedure SetOnClick(const Value: TNotifyEvent);
    procedure CMclick(var message:TMessage); message WM_LBUTTONDOWN;
    { Private declarations }
  protected
    { Protected declarations }
  public
    constructor create(Aowner:TComponent); override;
    destructor Destroy; override;
    { Public declarations }
  published
    property OnClick:TNotifyEvent read FOnClick write SetOnClick;
    { Published declarations }
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Samples', [tmydbgrid]);
end;

{ tmydbgrid }

procedure tmydbgrid.CMclick(var message: TMessage);
begin
  if Assigned(fonClick) then  fonClick(self);

end;

constructor tmydbgrid.create(Aowner: TComponent);
begin
  inherited;
end;

destructor tmydbgrid.Destroy;
begin
  inherited;
end;

procedure tmydbgrid.SetOnClick(const Value: TNotifyEvent);
begin
  FOnClick := Value;
end;

end.
