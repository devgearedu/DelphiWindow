unit BitmapLists;

interface

uses
  Classes, Graphics;

type
  TBitmapList = class
  private
    FList: TList;
    FFreeBeforeDelete: Boolean;
    function GetBitmap(Index: Integer): TBitmap;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Add(Bitmap: TBitmap);
    procedure Delete(Index: Integer);
    procedure Clear;
    function Count: Integer;
    property Items[Index: Integer]: TBitmap read GetBitmap; default;
    property FreeBeforeDelete: Boolean read FFreeBeforeDelete write FFreeBeforeDelete;
  end;

implementation

constructor TBitmapList.Create;
begin
  inherited Create;
  FList := TList.Create;
  FFreeBeforeDelete := True;
end;

destructor TBitmapList.Destroy;
begin
  Clear;
  FList.Free;
  inherited Destroy;
end;

procedure TBitmapList.Add(Bitmap: TBitmap);
begin
  FList.Add( Bitmap );
end;

procedure TBitmapList.Clear;
var
  i: Integer;
begin
  for i := Count - 1 downto 0 do Delete( i );
end;

function TBitmapList.Count: Integer;
begin
  Result := FList.Count;
end;

procedure TBitmapList.Delete(Index: Integer);
begin
  if FreeBeforeDelete then Items[ Index ].Free;
  FList.Delete( Index );
end;

function TBitmapList.GetBitmap(Index: Integer): TBitmap;
begin
  Result := FList[ Index ];
end;

end.
