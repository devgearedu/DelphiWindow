unit Unit2;

interface

uses
  Windows, Graphics, Types;

type
  TProgressEvent = procedure (Max, Position: Integer; Visible: Boolean) of object;

function GraphicToText(Graphic: TGraphic; Zoom: Integer; ProgressEvent: TProgressEvent): String;

implementation

const
  Chars: array[0..94] of Char = (' ','0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z','A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','`','~','!','@','#','$','%','^','&','*','(',')','_','+','-','=','\','|','[',']','{','}',';',':','''','"',',','.','/','<','>','?');

type
  TBits = array[0..6*12-1] of Boolean;

var
  CharBits: array[0..94] of TBits;
  InitedCharBits: Boolean = False;

type
  TPixels24 = array[0..0] of TRGBTriple;
  TPixels8 = array[0..0] of Byte;
  T8Bits = array[0..6*12-1] of Byte;
  
procedure InitCharBits;
var
  Bitmap: TBitmap;
  Pixels: ^TPixels8;
  Col, Row, Index, i: Integer;
begin
  Bitmap := TBitmap.Create;
  try
    Bitmap.PixelFormat := pf8Bit;
    Bitmap.Width := 6;
    Bitmap.Height := 12;
    Bitmap.Canvas.Font.Name := '±¼¸²Ã¼';
    Bitmap.Canvas.Font.Height := 12;
    Bitmap.Canvas.Font.Style := [];
    Bitmap.Canvas.Font.Color := clBlack;
    Bitmap.Canvas.Brush.Color := clWhite;

    for i := 0 to 94 do
     begin
       Bitmap.Canvas.FillRect( Bitmap.Canvas.ClipRect );
       Bitmap.Canvas.TextOut( 0, 0, Chars[i] );

       Index := 0;
       for Row := 0 to Bitmap.Height - 1 do
        begin
          Pixels := Bitmap.ScanLine[ Row ];
          for Col := 0 to Bitmap.Width - 1 do
           begin
             CharBits[ i ][ Index ] := Pixels^[ Col ] = 0;
             Inc( Index );
           end;
        end;
     end;
  
  finally
    Bitmap.Free;
  end;
end;

procedure GraphicToBitmap8(SrcGraphic: TGraphic; DestBitmap: TBitmap; Zoom: Integer);
var
  SrcBitmap: TBitmap;
  Pixels24: ^TPixels24;
  Pixels8: ^TPixels8;
  Col, Row: Integer;
begin
  DestBitmap.PixelFormat := pf8Bit;
  DestBitmap.Width := SrcGraphic.Width * Zoom;
  DestBitmap.Height := SrcGraphic.Height * Zoom;

  SrcBitmap := TBitmap.Create;
  try
    SrcBitmap.PixelFormat := pf24Bit;
    SrcBitmap.Width := SrcGraphic.Width * Zoom;
    SrcBitmap.Height := SrcGraphic.Height * Zoom;
    SrcBitmap.Canvas.StretchDraw( Rect( 0, 0, SrcBitmap.Width, SrcBitmap.Height ), SrcGraphic );

    for Row := 0 to SrcBitmap.Height - 1 do
     begin
       Pixels24 := SrcBitmap.ScanLine[ Row ];
       Pixels8 := DestBitmap.ScanLine[ Row ];

       for Col := 0 to SrcBitmap.Width - 1 do
        Pixels8^[ Col ] := ( Pixels24^[ Col ].rgbtRed + Pixels24^[ Col ].rgbtGreen + Pixels24^[ Col ].rgbtBlue ) div 3;
     end;

  finally
    SrcBitmap.Free;
  end;
end;

function GetValue(CharIndex: Integer; const Bits: T8Bits): Integer;
var
  i: Integer;
function GetValuePixel(PixelIndex: Integer): Byte;
  begin
    if CharBits[ CharIndex ][ PixelIndex ] then Result := 255 - Bits[ PixelIndex ]
                                           else Result := Bits[ PixelIndex ];
  end;
begin
  Result := 0;

  for i := 0 to 94 do
   Inc( Result, GetValuePixel( i ) );
end;

function FindCharFromBits(const Bits: T8Bits): Char;
var
  Values: array[0..94] of Integer;
  i, Max, MaxIndex: Integer;
begin
  for i := 0 to 94 do
   Values[ i ] := GetValue( i, Bits );

  MaxIndex := 0;
  Max := 0;
  for i := 0 to 94 do
   if Max < Values[ i ] then
    begin
      Max := Values[ i ];
      MaxIndex := i;
    end;

  Result := Chars[ MaxIndex ];
end;

function GraphicToText(Graphic: TGraphic; Zoom: Integer; ProgressEvent: TProgressEvent): String;
var
  S: String absolute Result;
var
  Bitmap: TBitmap;
  Col, Row: Integer;
  Rows: array of ^TPixels8;
  Max, Position: Integer;

function Convert(StartCol, StartRow: Integer): Char;
  var
    Bits: T8Bits;
    Index: Integer;
    Col, Row: Integer;
  begin
    Index := 0;

    for Row := StartRow to StartRow + 11 do
     for Col := StartCol to StartCol + 5 do
      begin
        Bits[ Index ] := Rows[ Row ]^[ Col ];
        Inc( Index );
      end;

    Result := FindCharFromBits( Bits );
  end;

begin
  if not InitedCharBits then InitCharBits;

  if Assigned( ProgressEvent ) then ProgressEvent( 0, 0, True );

  Bitmap := TBitmap.Create;
  try
    GraphicToBitmap8( Graphic, Bitmap, Zoom );

    SetLength( Rows, Bitmap.Height );
    for Row := 0 to Bitmap.Height - 1 do
     Rows[ Row ] := Bitmap.ScanLine[ Row ];

    Max := ( Bitmap.Height div 12 ) * ( Bitmap.Width div 6 );
    Position := 0;
    if Assigned( ProgressEvent ) then ProgressEvent( Max, Position, True );

    for Row := 0 to Bitmap.Height div 12 - 1 do
     begin
       for Col := 0 to Bitmap.Width div 6 - 1 do
        begin
          S := S + Convert( Col * 6, Row * 12 );
          if Assigned( ProgressEvent ) then ProgressEvent( Max, Position, True );
          Inc( Position );
        end;
       S := S + #13#10;
     end;
  
  finally
    Bitmap.Free;
  end;

  if Assigned( ProgressEvent ) then ProgressEvent( 0, 0, False );
end;

end.
 