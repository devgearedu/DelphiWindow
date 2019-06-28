{CreateBitmapRgn............                                                     }
{                                                                                }
{ 1. Bitmap의 바탕색을 따내서 Region으로 만든다.                                 }
{                                                                                }
{ 2. 첫번째 픽셀(0,0)을 바탕색으로 처리한다.(내맘이다^^)                         }
{                                                                                }
{ 3. Bitmap의 PixelFormat이 pf8Bit, pf16Bit, pf24Bit, pf32Bit만 사용할수 있다    }
{    pfDevice도 안된다.(이것도 내맘이다^^;)                                      }
{                                                                                }
{ 4. Rgn := CreateBitmapRgn(Bitmap);으로 생성한 Rgn은 DeleteObjct(Rgn)해야한다   }
{                                                                                }
{    양병규 delmadang@hanmail.net                                                }
{    Last update 2004-12-01                                                      }
{                                                                                }
{                                                                                }
{                                                                                }
{  var                                                                           }
{    Rgn: HRGN;                                                                  }
{  begin                                                                         }
{    Rgn := CreateBitmapRgn( Image1.Picture.Bitmap );                            }
{    try                                                                         }
{      SetWindowRgn( Form1.Handle, Rgn, True );                                  }
{    finally                                                                     }
{      DeleteObject( Rgn );                                                      }
{    end;                                                                        }
{  end                                                                           }

{$WARN UNSAFE_TYPE OFF}
{$WARN UNSAFE_CODE OFF}

unit BitmapRgn;

interface

uses
  Windows, Graphics;

function CreateBitmapRgn(Bitmap: TBitmap): HRGN;

implementation

const
  DEFAULTRECTCOUNT = 50;

function CreateBitmapRgn(Bitmap: TBitmap): HRGN;
type
  TPixels08 = array[0..0] of Byte;
  TPixels16 = array[0..0] of Word;
  TPixels24 = array[0..0] of TRGBTriple;
  TPixels32 = array[0..0] of Cardinal;
var
  PixelFormat: TPixelFormat;
  Pixels: Pointer;
  TransparentPixel: Pointer;
  RegionData: PRgnData;
  RegionBufferSize: Integer;
  RectCount, NewRectLeft: Integer;
  X, Y: Integer;
procedure GetTransparentPixel;
  begin
    GetMem( TransparentPixel, 4 );
    case PixelFormat of
    pf8Bit : PByte( TransparentPixel )^ := TPixels08( Pixels^ )[ 0 ];
    pf16Bit: PWord( TransparentPixel )^ := TPixels16( Pixels^ )[ 0 ];
    pf24Bit: PRGBTriple( TransparentPixel )^ := TPixels24( Pixels^ )[ 0 ];
    pf32Bit: PCardinal( TransparentPixel )^ := TPixels32( Pixels^ )[ 0 ];
    end;
  end;
function IsTransparent(X: Integer): Boolean;
  begin
    case PixelFormat of
    pf8Bit : Result := TPixels08( Pixels^ )[ X ] = PByte( TransparentPixel )^;
    pf16Bit: Result := TPixels16( Pixels^ )[ X ] = PWord( TransparentPixel )^;
    pf24Bit: Result := ( TPixels24( Pixels^ )[ X ].rgbtRed = PRGBTriple( TransparentPixel )^.rgbtRed ) and
                       ( TPixels24( Pixels^ )[ X ].rgbtGreen = PRGBTriple( TransparentPixel )^.rgbtGreen ) and
                       ( TPixels24( Pixels^ )[ X ].rgbtBlue = PRGBTriple( TransparentPixel )^.rgbtBlue );
    pf32Bit: Result := TPixels32( Pixels^ )[ X ] = PCardinal( TransparentPixel )^;
    else Result := False;
    end;
  end;
procedure AddRect(LastCol: Boolean = False);
  type
    PRectBuffer = ^TRectBuffer;
    TRectBuffer = array[0..0] of TRect;
  begin
    if ( RegionBufferSize div SizeOf( TRect ) ) = RectCount then
     begin
       Inc( RegionBufferSize, SizeOf( TRect ) * DEFAULTRECTCOUNT );
       ReallocMem( RegionData, SizeOf( TRgnDataHeader ) + RegionBufferSize + 3 );
     end;

    if LastCol then Inc( X );

    PRectBuffer( @RegionData^.Buffer )^[ RectCount ].Left := NewRectLeft;
    PRectBuffer( @RegionData^.Buffer )^[ RectCount ].Top := Y;
    PRectBuffer( @RegionData^.Buffer )^[ RectCount ].Right := X;
    PRectBuffer( @RegionData^.Buffer )^[ RectCount ].Bottom := Y + 1;

    Inc( RectCount );
    NewRectLeft := -1;
  end;
begin
  PixelFormat := Bitmap.PixelFormat;
  Pixels := Bitmap.ScanLine[ 0 ];
  GetTransparentPixel;

  RectCount := 0;
  RegionBufferSize := SizeOf( TRect ) * DEFAULTRECTCOUNT;
  GetMem( RegionData, SizeOf( TRgnDataHeader ) + RegionBufferSize + 3 );
  try

    for Y := 0 to Bitmap.Height - 1 do
     begin
       Pixels := Bitmap.ScanLine[ Y ];
       NewRectLeft := -1;
       for X := 0 to Bitmap.Width - 1 do
        if IsTransparent( X ) then
         begin
           if NewRectLeft >= 0 then AddRect;
         end
        else
         begin
           if NewRectLeft = -1 then NewRectLeft := X;
           if ( X = Bitmap.Width - 1 ) and ( NewRectLeft >= 0 ) then AddRect( True );
         end;
     end;

    RegionData^.rdh.dwSize := SizeOf( TRgnDataHeader );
    RegionData^.rdh.iType := RDH_RECTANGLES;
    RegionData^.rdh.nCount := RectCount;
    RegionData^.rdh.nRgnSize := RectCount * SizeOf( TRect );
    Result := ExtCreateRegion( nil, RegionData^.rdh.dwSize + RegionData^.rdh.nRgnSize, RegionData^ );

  finally
    FreeMem( RegionData );
    FreeMem( TransparentPixel );
  end;
end;

end.
