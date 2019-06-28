unit Grid;

interface

uses
  Windows, Classes, Grids, SysUtils, Dialogs;

type
  TBuffer = array[0..511] of Byte;

  TStringGrid = class(Grids.TStringGrid)
  protected
    function SelectCell(ACol, ARow: Longint): Boolean; override;
  public
    procedure InitFixedCol;
    procedure Clear;
    procedure Load(const Buffer: TBuffer);
    function Save(var Buffer: TBuffer): Boolean;
  end;

implementation

function TStringGrid.SelectCell(ACol, ARow: Integer): Boolean;
begin
  Result := ACol < 17;
end;

procedure TStringGrid.InitFixedCol;
var
  i: Integer;
begin
  for i := 0 to RowCount - 1 do
   Cells[ 0, i ] :=  '$' + IntToHex( i * 16, 4 );
end;

procedure TStringGrid.Clear;
var
  Col, Row: Integer;
begin
  for Row := 0 to RowCount - 1 do
   for Col := 1 to 17 do
    Cells[ Col, Row ] := '';
end;

procedure TStringGrid.Load(const Buffer: TBuffer);
var
  RowBuf: array[0..15] of Byte;
  BytesRead, Col, Row, i: Integer;
  S: String;
begin
  Clear;

  Col := 1;
  Row := 0;
  S := '';

  for i := Low( Buffer ) to High( Buffer ) do
   begin
     Cells[ Col, Row ] := IntToHex( Buffer[i], 2 );
     Inc( Col );

     if Col = 17 then
      begin
        Cells[ Col, Row ] := S;
        S := '';
        Col := 1;
        Inc( Row );
      end
     else
      begin
        if Buffer[i] in [32..126] then S := S + Char( Buffer[i] )
                                  else S := S + '.';
      end;
   end;
end;

function TStringGrid.Save(var Buffer: TBuffer): Boolean;
var
  Col, Row, Index: Integer;
  B: Byte;
begin
  Result := False;

  Index := Low( Buffer );
  B := 0;
  
  for Row := 0 to RowCount - 1 do
   for Col := 1 to 16 do
    begin
      try
        B := StrToInt( '$' + Cells[ Col, Row ] );
      except
        ShowMessage( 'Grid에 이상한게 써있습니다.' );
        Self.Col := Col;
        Self.Row := Row;
        Exit;
      end;

      Buffer[ Index ] := B;
      Inc( Index );
    end;

  Result := True;
end;

end.
