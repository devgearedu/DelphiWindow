unit IconsUtil;

interface

uses
  Windows, Classes, Graphics, BitmapLists;

procedure WriteIconFileFromBitmap(const IconFileName: String; Bitmap: TBitmap);
procedure WriteIconFileFromBitmapList(const IconFileName: String; BitmapList: TBitmapList);
procedure WriteIconStreamFromBitmap(DestStream: TStream; Bitmap: TBitmap);
procedure WriteIconStreamFromBitmapList(DestStream: TStream; SrcBitmaps: TBitmapList);
procedure ReadIconFileToBitmapList(const IconFileName: String; BitmapList: TBitmapList);
procedure ReadIconStramToBitmapList(SrcStream: TStream; BitmapList: TBitmapList);

implementation

procedure ShowMessage(const S: String);
begin
  MessageBox( GetTopWindow( 0 ), PChar( S ), '아쒸~', MB_OK or MB_ICONINFORMATION );
end;

function AllocMem(Size: Cardinal): Pointer;
begin
  GetMem(Result, Size);
  FillChar(Result^, Size, 0);
end;

{Write}

procedure WriteIconFileFromBitmap(const IconFileName: String; Bitmap: TBitmap);
var
  BitmapList: TBitmapList;
begin
  BitmapList := TBitmapList.Create;
  try
    BitmapList.FreeBeforeDelete := False;
    BitmapList.Add( Bitmap );
    WriteIconFileFromBitmapList( IconFileName, BitmapList );
  finally
    BitmapList.Free;
  end;
end;

procedure WriteIconFileFromBitmapList(const IconFileName: String; BitmapList: TBitmapList);
var
  Stream: TStream;
begin
  Stream := TFileStream.Create( IconFileName, fmCreate );
  try
    WriteIconStreamFromBitmapList( Stream, BitmapList );
  finally
    Stream.Free;
  end;
end;

procedure WriteIconStreamFromBitmap(DestStream: TStream; Bitmap: TBitmap);
var
  BitmapList: TBitmapList;
begin
  BitmapList := TBitmapList.Create;
  try
    BitmapList.FreeBeforeDelete := False;
    BitmapList.Add( Bitmap );
    WriteIconStreamFromBitmapList( DestStream, BitmapList );
  finally
    BitmapList.Free;
  end;
end;

procedure InitializeBitmapInfoHeader(Bitmap: HBITMAP; var BI: TBitmapInfoHeader; BitCount: Integer);
var
  DS: TDIBSection;
  Bytes: Integer;
procedure InvalidBitmap; 
  begin
    raise EInvalidGraphic.Create( '비트맵이미지가 없다' );
  end;
begin
  DS.dsbmih.biSize := 0;
  Bytes := GetObject(Bitmap, SizeOf(DS), @DS);
  if Bytes = 0 then InvalidBitmap
  else if (Bytes >= (sizeof(DS.dsbm) + sizeof(DS.dsbmih))) and
    (DS.dsbmih.biSize >= DWORD(sizeof(DS.dsbmih))) then
    BI := DS.dsbmih
  else
  begin
    FillChar(BI, sizeof(BI), 0);
    with BI, DS.dsbm do
    begin
      biSize := SizeOf(BI);
      biWidth := bmWidth;
      biHeight := bmHeight;
    end;
  end;

  BI.biBitCount := BitCount;

  BI.biPlanes := 1;
  if BI.biClrImportant > BI.biClrUsed then
    BI.biClrImportant := BI.biClrUsed;
  if BI.biSizeImage = 0 then
    BI.biSizeImage := BytesPerScanLine(BI.biWidth, BI.biBitCount, 32) * Abs(BI.biHeight);
end;

procedure InternalGetDIBSizes(Bitmap: HBITMAP; var InfoHeaderSize: DWORD; var ImageSize: DWORD; BitCount: Integer);
var
  BI: TBitmapInfoHeader;
begin
  InitializeBitmapInfoHeader(Bitmap, BI, BitCount);
  if BI.biBitCount > 8 then
  begin
    InfoHeaderSize := SizeOf(TBitmapInfoHeader);
    if (BI.biCompression and BI_BITFIELDS) <> 0 then
      Inc(InfoHeaderSize, 12);
  end
  else
    if BI.biClrUsed = 0 then
      InfoHeaderSize := SizeOf(TBitmapInfoHeader) +
        SizeOf(TRGBQuad) * (1 shl BI.biBitCount)
    else
      InfoHeaderSize := SizeOf(TBitmapInfoHeader) +
        SizeOf(TRGBQuad) * BI.biClrUsed;
  ImageSize := BI.biSizeImage;
end;

function InternalGetDIB(Bitmap: HBITMAP; Palette: HPALETTE; var BitmapInfo; var Bits; BitCount: Integer): Boolean;
var
  OldPal: HPALETTE;
  DC: HDC;
begin
  InitializeBitmapInfoHeader(Bitmap, TBitmapInfoHeader(BitmapInfo), BitCount);
  OldPal := 0;
  DC := CreateCompatibleDC(0);
  try
    if Palette <> 0 then
    begin
      OldPal := SelectPalette(DC, Palette, False);
      RealizePalette(DC);
    end;

    Result := GetDIBits(DC, Bitmap, 0, TBitmapInfoHeader(BitmapInfo).biHeight, @Bits, TBitmapInfo(BitmapInfo), DIB_RGB_COLORS) <> 0;
  finally
    if OldPal <> 0 then SelectPalette(DC, OldPal, False);
    DeleteDC(DC);
  end;
end;

type
  TIconItemInfo = record
    IconHandle: HICON;
    Palette: HPALETTE;
    BitCount: Integer;
    Bitmap: HBITMAP;
    ColorBitmap: TBitmap;
    MaskBitmap: TBitmap;
  end;

  TIcons = array[0..255] of TIconItemInfo;

procedure WriteIcon(DestStream: TStream; const SrcIcons: TIcons; IconCount: Integer);
var
  IconHandle: HICON;
  BitCount: Integer;
  IconInfo: TIconInfo;
  MonoInfoSize, ColorInfoSize: DWORD;
  MonoBitsSize, ColorBitsSize: DWORD;
  MonoInfo, MonoBits, ColorInfo, ColorBits: Pointer;
  CursorOrIcon: TCursorOrIcon;
  IconRec: TIconRec;
  ListStartPosition, BitmapStartPosition: Int64;
  i, AllBitmapSize: Integer;
begin
 {head  6Byte}
  with CursorOrIcon do
   begin
     Reserved := 0;
     wType := RC3_ICON;   {종류=아이콘}
     Count := IconCount;  {갯수}
   end;
  DestStream.Write( CursorOrIcon, SizeOf(CursorOrIcon) );


  ListStartPosition := DestStream.Position; {List 시작점}
  BitmapStartPosition := ListStartPosition + ( SizeOf(IconRec) * IconCount ); {Bitmap 시작점}


 {List 공간만큼 일단 채운다}
  FillChar( IconRec, SizeOf(IconRec), 0 );
  for i := 0 to IconCount - 1 do
   DestStream.Write( IconRec, SizeOf(IconRec) );


 {IconCount만큼 루프}
  AllBitmapSize := 0;
  for i := 0 to IconCount - 1 do
   begin

     IconHandle := SrcIcons[i].IconHandle;
     BitCount := SrcIcons[i].BitCount;

     FillChar( IconRec, SizeOf(IconRec), 0 );
     GetIconInfo( IconHandle, IconInfo );

     try
       InternalGetDIBSizes( IconInfo.hbmMask, MonoInfoSize, MonoBitsSize, 1 );
       InternalGetDIBSizes( SrcIcons[i].Bitmap, ColorInfoSize, ColorBitsSize, BitCount );
       MonoInfo := AllocMem( MonoInfoSize );
       MonoBits := AllocMem( MonoBitsSize );
       ColorInfo := AllocMem( ColorInfoSize );
       ColorBits := AllocMem( ColorBitsSize );
       try
         InternalGetDIB( IconInfo.hbmMask, 0, MonoInfo^, MonoBits^, 1 );
         InternalGetDIB( SrcIcons[i].Bitmap, SrcIcons[i].Palette, ColorInfo^, ColorBits^, BitCount );

        {List}
         with IconRec, PBitmapInfoHeader(ColorInfo)^ do
          begin
            Width := biWidth;
            Height := biHeight;
            Colors := biPlanes * biBitCount;
            DIBSize := ColorInfoSize + ColorBitsSize + MonoBitsSize;
            DIBOffset := BitmapStartPosition + AllBitmapSize;
          end;
         DestStream.Position := ListStartPosition + ( i * SizeOf(IconRec) );
         DestStream.Write( IconRec, SizeOf(IconRec) );

        {Bitmap}
         with PBitmapInfoHeader(ColorInfo)^ do Inc(biHeight, biHeight);
         DestStream.Position := BitmapStartPosition + AllBitmapSize;
         DestStream.Write( ColorInfo^, ColorInfoSize );
         DestStream.Write( ColorBits^, ColorBitsSize );
         DestStream.Write( MonoBits^, MonoBitsSize );


         Inc( AllBitmapSize, IconRec.DIBSize ); 

       finally
         FreeMem( ColorInfo, ColorInfoSize );
         FreeMem( ColorBits, ColorBitsSize );
         FreeMem( MonoInfo, MonoInfoSize );
         FreeMem( MonoBits, MonoBitsSize );
       end;

     finally
       DeleteObject( IconInfo.hbmColor );
       DeleteObject( IconInfo.hbmMask );
     end;

   end;
end;

procedure WriteIconStreamFromBitmapList(DestStream: TStream; SrcBitmaps: TBitmapList);
var
  BitCount: Integer;
  IconInfo: TIconInfo;
  Icons: TIcons;
  ColorBitmap, MaskBitmap: TBitmap;
  i: Integer;
begin
  for i := 0 to SrcBitmaps.Count - 1 do
   begin
     ColorBitmap := TBitmap.Create;
     ColorBitmap.Assign( SrcBitmaps[i] );
     ColorBitmap.Canvas.Brush.Color := clBlack;
     ColorBitmap.Canvas.FillRect( ColorBitmap.Canvas.ClipRect );
     ColorBitmap.Canvas.Draw( 0, 0, SrcBitmaps[i] );


     MaskBitmap := TBitmap.Create;
     MaskBitmap.Assign( SrcBitmaps[i] );
     MaskBitmap.Mask( SrcBitmaps[i].TransparentColor );


     case ColorBitmap.PixelFormat of
      pf1bit: BitCount := 1;
      pf4bit: BitCount := 4;
      pf8bit: BitCount := 8;
     pf32Bit: BitCount := 32;{XP}
     else   begin
              ColorBitmap.PixelFormat := pf24Bit;
              BitCount := 24;
            end;
     end;

     IconInfo.fIcon := True;
     IconInfo.xHotspot := 0;
     IconInfo.yHotspot := 0;
     IconInfo.hbmMask := MaskBitmap.Handle;
     IconInfo.hbmColor := ColorBitmap.Handle;

     Icons[i].IconHandle := CreateIconIndirect( IconInfo );
     Icons[i].BitCount := BitCount;
     Icons[i].Palette := ColorBitmap.Palette;
     Icons[i].Bitmap := ColorBitmap.Handle;
     Icons[i].ColorBitmap := ColorBitmap;
     Icons[i].MaskBitmap := MaskBitmap;
   end;

  try
    WriteIcon( DestStream, Icons, SrcBitmaps.Count );
  finally
    for i := 0 to SrcBitmaps.Count - 1 do
     begin
       DestroyIcon( Icons[i].IconHandle );
       Icons[i].ColorBitmap.Free;
       Icons[i].MaskBitmap.Free;
     end;
  end;
end;

{Read}

type
  PPixels8 = ^TPixels8;
  TPixels8 = array[0..0] of Byte;
  PPixels24 = ^TPixels24;
  TPixels24 = array[0..0] of TRGBTriple;
  PPixels32 = ^TPixels32;
  TPixels32 = array[0..0] of TRGBQuad;
  PLongArray = ^TLongArray;
  TLongArray = array[0..1] of Longint;
  PPaletteEntries = ^TPaletteEntries;
  TPaletteEntries = array[Byte] of TPaletteEntry;

function BitCountToColorCount(BitCount: Word): Integer;
begin
  case BitCount of
  1, 4, 8: Result := 1 shl BitCount;
      else Result := 0;
  end;
end;

procedure MakeAndBitmap(var BI: TBitmapInfoHeader; SrcPixels: Pointer; DestBitmap: TBitmap);
var
  DC, MemDC: HDC;
  Src, OldBitmap: HBITMAP;
  MonoBitmap: HBITMAP;
  Colors: PLongArray;
begin
  DestBitmap.PixelFormat := pf1Bit;

  BI.biBitCount := 1;
  BI.biSizeImage := BytesPerScanline( BI.biWidth, BI.biBitCount, 32 ) * BI.biHeight;
  BI.biClrUsed := 2;
  BI.biClrImportant := 2;

  Colors := Pointer(Longint(@BI) + SizeOf(BI));
  Colors^[0] := 0;
  Colors^[1] := $FFFFFF;

  DC := GetDC( 0 );

  Src := CreateDIBitmap( DC, BI, CBM_INIT, SrcPixels, PBitmapInfo(@BI)^, DIB_RGB_COLORS );
  MemDC := CreateCompatibleDC( 0 );
  MonoBitmap := CreateBitmap( DestBitmap.Width, DestBitmap.Height, 1, 1, nil );

  try
    OldBitmap := SelectObject( MemDC, Src );
    StretchBlt( DestBitmap.Canvas.Handle, 0, 0, DestBitmap.Width, DestBitmap.Height, MemDC, 0, 0, DestBitmap.Width, DestBitmap.Height, SRCCOPY );
    SelectObject( MemDC, OldBitmap );
  finally
    DeleteObject( MonoBitmap );
    DeleteDC( MemDC );
    DeleteObject( Src );
    ReleaseDC( 0, DC );
  end;  
end;

procedure CopyPalette(DestBitmap: TBitmap; PalettePtr: Pointer; BitCount: Integer);
var
  ColorCount, i: Integer;
  LogPaletteSize: Integer;
  LogPalette: PLogPalette;
begin
  case BitCount of
   1: DestBitmap.PixelFormat := pf1Bit;
   4: DestBitmap.PixelFormat := pf4Bit;
   8: DestBitmap.PixelFormat := pf8Bit;
  15: DestBitmap.PixelFormat := pf15Bit;
  16: DestBitmap.PixelFormat := pf16Bit;
  24: DestBitmap.PixelFormat := pf24Bit;
  32: DestBitmap.PixelFormat := pf32Bit;
  end;

  if DestBitmap.PixelFormat in [pf1Bit, pf4Bit, pf8Bit] then
   begin
     ColorCount := BitCountToColorCount( BitCount );

     LogPaletteSize := 4 + SizeOf( TPaletteEntry ) * ColorCount;
     GetMem( LogPalette, LogPaletteSize );
     try
       ZeroMemory( LogPalette, LogPaletteSize );
       LogPalette^.palVersion := $300;
       LogPalette^.palNumEntries := ColorCount;

       for i := 0 to ColorCount - 1 do
        begin
          LogPalette^.palPalEntry[ i ].peRed := PPaletteEntries( PalettePtr )^[ i ].peBlue;
          LogPalette^.palPalEntry[ i ].peGreen := PPaletteEntries( PalettePtr )^[ i ].peGreen;
          LogPalette^.palPalEntry[ i ].peBlue := PPaletteEntries( PalettePtr )^[ i ].peRed;
          LogPalette^.palPalEntry[ i ].peFlags := PPaletteEntries( PalettePtr )^[ i ].peFlags;
        end;

       DestBitmap.Palette := CreatePalette( LogPalette^ );

     finally
       FreeMem( LogPalette, LogPaletteSize );
     end;
   end;
end;

procedure TwoBitsFromDIB(var BI: TBitmapInfoHeader; XorBitmap, AndBitmap: TBitmap);
var
  ColorCount: Integer;
  Palettes, SrcPixels: Pointer;
  DestPixels: Pointer;
begin
  BI.biHeight := BI.biHeight shr 1; { Size in record is doubled }
  BI.biSizeImage := BytesPerScanline( BI.biWidth, BI.biBitCount, 32 ) * BI.biHeight;
  ColorCount := BitCountToColorCount( BI.biBitCount );

  
 {Xor Bitmap Size}
  XorBitmap.Width := BI.biWidth;
  XorBitmap.Height := BI.biHeight;

 {Xor Bitmap Palette}
  Palettes := Pointer( Longint(@BI) + SizeOf(BI) );
  CopyPalette( XorBitmap, Palettes, BI.biBitCount );

 {Xor Bitmap Pixels}
  SrcPixels := Pointer( Longint(@BI) + SizeOf(BI) + ColorCount * SizeOf(TRGBQuad) );
  DestPixels := XorBitmap.ScanLine[ XorBitmap.Height - 1 ];
  Move( SrcPixels^, DestPixels^, BI.biSizeImage );

 {And Bitmap Size}
  AndBitmap.Width := BI.biWidth;
  AndBitmap.Height := BI.biHeight;

 {AndBitmap Palette & Pixels}
  Inc( Longint(SrcPixels), BI.biSizeImage );
  MakeAndBitmap( BI, SrcPixels, AndBitmap );
end;

procedure MergeBitmaps(XorBitmap, AndBitmap, Bitmap: TBitmap);
procedure MergeBitmap8;
  var
    Col, Row: Integer;
    Pixels: PPixels8;
    AndPixels: PLongArray;
    TransparentIndex: Byte;
    NotUseColor: Boolean;
    NotUseRGB: Boolean;
    PaletteEntries: TPaletteEntries;
    R, G, B: Byte;
    MaxLogPalette: TMaxLogPalette;
    LogPalette: TLogPalette absolute MaxLogPalette;
    TransparentColor: TColor;
    OldPixels: Pointer;
  begin
    Bitmap.Assign( XorBitmap );
    AndBitmap.PixelFormat := pf32Bit;
    TransparentColor := clNone;

    GetPaletteEntries( XorBitmap.Palette, 0, 256, PaletteEntries );

   {안쓰는 파레트 색상 찾기} 
    TransparentIndex := 0;
    NotUseColor := False;
    while not NotUseColor do
     begin
       NotUseColor := True;
       for Row := 0 to Bitmap.Height - 1 do
        begin
          Pixels := Bitmap.ScanLine[ Row ];
          for Col := 0 to Bitmap.Width - 1 do
           if ( PaletteEntries[ Pixels^[ Col ] ].peRed = PaletteEntries[ TransparentIndex ].peRed ) and
              ( PaletteEntries[ Pixels^[ Col ] ].peGreen = PaletteEntries[ TransparentIndex ].peGreen ) and
              ( PaletteEntries[ Pixels^[ Col ] ].peBlue = PaletteEntries[ TransparentIndex ].peBlue ) then
            begin
              NotUseColor := False;
              Break;
            end;
          if not NotUseColor then Break;
        end;

       if NotUseColor then
        begin
          TransparentColor := RGB( PaletteEntries[ TransparentIndex ].peRed, PaletteEntries[ TransparentIndex ].peGreen, PaletteEntries[ TransparentIndex ].peBlue );
          Break;
        end;

       if TransparentIndex < 255 then Inc( TransparentIndex )
                                 else Break;
     end;


   {안쓰는 파레트 인덱스 찾기}
    if not NotUseColor then
     begin
       TransparentIndex := 0;
       NotUseColor := False;
       while not NotUseColor do
        begin
          NotUseColor := True;
          for Row := 0 to Bitmap.Height - 1 do
           begin
             Pixels := Bitmap.ScanLine[ Row ];
             for Col := 0 to Bitmap.Width - 1 do
              if Pixels^[ Col ] = TransparentIndex then
               begin
                 NotUseColor := False;
                 Break;
               end;
             if not NotUseColor then Break;
           end;

          if NotUseColor then Break;

          if TransparentIndex < 255 then Inc( TransparentIndex )
                                    else Break;
        end;


       if not NotUseColor then
        begin
          ShowMessage( '안쓰는 파레트인덱스를 찾을 수 없습니다--;' );
          Exit;
        end;

        
       if NotUseColor then
        begin
          R := $FF;
          G := 0;
          B := $FF;

          NotUseRGB := False;
          while not NotUseRGB do
           begin
             NotUseRGB := True;
             for Row := 0 to Bitmap.Height - 1 do
              begin
                Pixels := Bitmap.ScanLine[ Row ];
                for Col := 0 to Bitmap.Width - 1 do
                 if ( PaletteEntries[ Pixels^[ Col ] ].peRed = R ) and
                    ( PaletteEntries[ Pixels^[ Col ] ].peGreen = G ) and
                    ( PaletteEntries[ Pixels^[ Col ] ].peBlue = B ) then
                  begin
                    NotUseRGB := False;
                    Break;
                  end;
                if not NotUseRGB then Break;
              end;

             if NotUseRGB then
              begin
                MaxLogPalette.palVersion := $300;
                MaxLogPalette.palNumEntries := 256;
                Move( PaletteEntries, MaxLogPalette.palPalEntry, SizeOf( PaletteEntries ) );

                MaxLogPalette.palPalEntry[ TransparentIndex ].peRed := R;
                MaxLogPalette.palPalEntry[ TransparentIndex ].peGreen := G;
                MaxLogPalette.palPalEntry[ TransparentIndex ].peBlue := B;
                MaxLogPalette.palPalEntry[ TransparentIndex ].peFlags := 0;

                Pixels := Bitmap.ScanLine[ Bitmap.Height - 1 ];
                GetMem( OldPixels, Bitmap.Width * Bitmap.Height );
                try
                  Move( Pixels^, OldPixels^, Bitmap.Width * Bitmap.Height );
                  Bitmap.Palette := CreatePalette( LogPalette );
                  Pixels := Bitmap.ScanLine[ Bitmap.Height - 1 ];
                  Move( OldPixels^, Pixels^, Bitmap.Width * Bitmap.Height );
                finally
                  FreeMem( OldPixels );
                end;

                TransparentColor := RGB( R, G, B );

                Break;
              end;

             if B > 0 then Dec( B )
             else
              begin
                ShowMessage( '안쓰는 파레트색을 찾을 수 없습니다 --;' );
                Exit;
              end;
           end;
        end;
     end;



    for Row := 0 to Bitmap.Height - 1 do
     begin
       Pixels := Bitmap.ScanLine[ Row ];
       AndPixels := AndBitmap.ScanLine[ Row ];
       for Col := 0 to Bitmap.Width - 1 do
        if AndPixels^[ Col ] <> 0 then
         Pixels^[ Col ] := TransparentIndex;
     end;


    Bitmap.TransparentColor := TransparentColor;
    Bitmap.Transparent := True;
  end;

procedure MergeBitmap24;
  var
    Col, Row: Integer;
    Pixels: PPixels24;
    AndPixels: PLongArray;
    R, G, B: Byte;
    NotUseColor: Boolean;
  begin
    Bitmap.Assign( XorBitmap );
    AndBitmap.PixelFormat := pf32Bit;

    R := $FF;
    G := 0;
    B := $FF;

    NotUseColor := False;
    while not NotUseColor do
     begin
       NotUseColor := True;
       for Row := 0 to Bitmap.Height - 1 do
        begin
          Pixels := Bitmap.ScanLine[ Row ];
          for Col := 0 to Bitmap.Width - 1 do
           if ( Pixels^[ Col ].rgbtRed = R ) and ( Pixels^[ Col ].rgbtGreen = G ) and ( Pixels^[ Col ].rgbtBlue = B ) then
            begin
              NotUseColor := False;
              Break;
            end;
          if not NotUseColor then Break;
        end;

       if NotUseColor then Break;

       if B > 0 then Dec( B )
       else
        begin
          ShowMessage( '안쓰는 색을 찾을 수 없다네 --;' );
          Exit;
        end;
     end;

    for Row := 0 to Bitmap.Height - 1 do
     begin
       Pixels := Bitmap.ScanLine[ Row ];
       AndPixels := AndBitmap.ScanLine[ Row ];
       for Col := 0 to Bitmap.Width - 1 do
        if AndPixels^[ Col ] <> 0 then
         begin
           Pixels^[ Col ].rgbtRed := R;
           Pixels^[ Col ].rgbtGreen := G;
           Pixels^[ Col ].rgbtBlue := B;
         end;
     end;

    Bitmap.TransparentColor := RGB( R, G, B );
    Bitmap.Transparent := True;
  end;

procedure MergeBitmap32;
  var
    Col, Row: Integer;
    Pixels: PPixels32;
    AndPixels: PLongArray;
    R, G, B: Byte;
    NotUseColor: Boolean;
  begin
    Bitmap.Assign( XorBitmap );
    AndBitmap.PixelFormat := pf32Bit;

    R := $FF;
    G := 0;
    B := $FF;

    NotUseColor := False;
    while not NotUseColor do
     begin
       NotUseColor := True;
       for Row := 0 to Bitmap.Height - 1 do
        begin
          Pixels := Bitmap.ScanLine[ Row ];
          for Col := 0 to Bitmap.Width - 1 do
           if ( Pixels^[ Col ].rgbRed = R ) and ( Pixels^[ Col ].rgbGreen = G ) and ( Pixels^[ Col ].rgbBlue = B ) then
            begin
              NotUseColor := False;
              Break;
            end;
          if not NotUseColor then Break;
        end;

       if NotUseColor then Break;

       if B > 0 then Dec( B )
       else
        begin
          ShowMessage( '안쓰는 색을 찾을 수 없습니다 --;' );
          Exit;
        end;
     end;


    for Row := 0 to XorBitmap.Height - 1 do
     begin
       Pixels := Bitmap.ScanLine[ Row ];
       AndPixels := AndBitmap.ScanLine[ Row ];
       for Col := 0 to Bitmap.Width - 1 do
        if AndPixels^[ Col ] <> 0 then
         begin
           Pixels^[ Col ].rgbRed := R;
           Pixels^[ Col ].rgbGreen := G;
           Pixels^[ Col ].rgbBlue := B;
         end;
     end;

    Bitmap.TransparentColor := RGB( R, G, B );
    Bitmap.Transparent := True;
  end;
procedure MergeBitmapElse;
  var
    S: String;
  begin
    Bitmap.Assign( XorBitmap );

    case XorBitmap.PixelFormat of
    pf1Bit: S := '2색(1Bit)';
    pf4Bit: S := '16색(4Bit)';
    pf15Bit: S := '32768색(15Bit)';
    pf16Bit: S := '65536색(16Bit)';
    else S := '이 ';
    end;

    S := S + '규격의 아이콘이미지는 제대로 지원하지 않습니다 ^u^';

    ShowMessage( S );
  end;
begin
  case XorBitmap.PixelFormat of
  pf8Bit : MergeBitmap8;
  pf24Bit: MergeBitmap24;
  pf32Bit: MergeBitmap32;
  else MergeBitmapElse;
  end;
end;

procedure ReadIcon(Stream: TStream; ImageCount: Integer; StartPos: Int64; BitmapList: TBitmapList);
type
  TIconRecArray = array[0..300] of TIconRec;
var
  IconRecList: ^TIconRecArray;
  HeaderLen: Integer;
  BI: PBitmapInfoHeader;
  XorBitmap: TBitmap;
  AndBitmap: TBitmap;
  Bitmap: TBitmap;
  i: Integer;
begin
  HeaderLen := SizeOf(TIconRec) * ImageCount;
  IconRecList := AllocMem( HeaderLen );
  try
    Stream.Read( IconRecList^, HeaderLen );

    for i := 0 to ImageCount - 1 do
     begin
       BI := AllocMem( IconRecList^[ i ].DIBSize );
       try
         Stream.Position := StartPos + IconRecList^[ i ].DIBOffset;
         Stream.Read( BI^, IconRecList^[ i ].DIBSize );

         XorBitmap := TBitmap.Create;
         AndBitmap := TBitmap.Create;
         Bitmap := TBitmap.Create;
         try
           TwoBitsFromDIB( BI^, XorBitmap, AndBitmap );
           MergeBitmaps( XorBitmap, AndBitmap, Bitmap );

           BitmapList.Add( Bitmap );
         finally
           XorBitmap.Free;
           AndBitmap.Free;
         end;

       finally
         FreeMem( BI, IconRecList^[ i ].DIBSize );
       end;
     end;
  finally
    FreeMem( IconRecList, HeaderLen );
  end;
end;

procedure ReadIconFileToBitmapList(const IconFileName: String; BitmapList: TBitmapList);
const
  fmOpenRead      = $0000;
  fmShareDenyNone = $0040;
var
  Stream: TStream;
begin
  Stream := TFileStream.Create( IconFileName, fmOpenRead or fmShareDenyNone );
  try
    ReadIconStramToBitmapList( Stream, BitmapList );
  finally
    Stream.Free;
  end;
end;

procedure ReadIconStramToBitmapList(SrcStream: TStream; BitmapList: TBitmapList);
var
  CI: TCursorOrIcon;
  StartPos: Int64;
begin
  StartPos := SrcStream.Position;
  SrcStream.ReadBuffer( CI, SizeOf(CI) );

  case CI.wType of
  RC3_ICON: ReadIcon( SrcStream, CI.Count, StartPos, BitmapList );
  end;
end;

end.
