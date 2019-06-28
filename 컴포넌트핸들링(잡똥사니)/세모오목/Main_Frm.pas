unit Main_Frm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls;

const
  LineCount = 28;
  LineLength = 24;

  CloseButtonRect: TRect = ( Left: 145; Top: 1; Right: 161; Bottom: 15 );
  MinimizeButtonRect: TRect = ( Left: 127; Top: 1; Right: 143; Bottom: 15 );

type
  TStone = ( sNone, sWhite, sBlack );

  TMain_Form = class(TForm)
    Image_Background: TImage;
    Label_Message: TStaticText;
    Button_NewGame: TButton;
    Image_Stone: TImage;
    Panel_Caption: TPanel;
    PaintBox_Caption: TPaintBox;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Button_NewGameClick(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure PaintBox_CaptionPaint(Sender: TObject);
    procedure PaintBox_CaptionMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure PaintBox_CaptionMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure StaticText3Click(Sender: TObject);
  private
    Map: array[ 1..LineCount, 1..LineCount ] of TStone;
    Toggle: Boolean;
    BoardSize: TSize;
    BufBitmap: TBitmap;
    IsGameOver: Boolean;
    CloseButtonDown: Boolean;
    MinimizeButtonDown: Boolean;
    procedure NewGame;
    procedure CheckGameOver;
    procedure DrawStone(Stone: TStone);
    procedure DrawToBuffer;
    procedure DrawToScreen;
    procedure DrawCaptions;
    procedure GetStonePoint(MapX, MapY: Integer; var X, Y: Integer);
    function MouseToMap(X, Y: Integer; var MapX, MapY: Integer): Boolean;
    procedure Sound( ResName: String );
    procedure WMActivate( var Message: TMessage ); message WM_ACTIVATE;
    procedure WMGetMinMaxInfo( var Message: TWMGetMinMaxInfo ); message WM_GETMINMAXINFO;
  public
  end;

var
  Main_Form: TMain_Form;

implementation

uses
  ShellAPI, MMSystem;

{$R *.DFM}
{$R MEDIA.RES}

const
  StoneColor: array[TStone] of TColor = ( clNone, clWhite, clBlack );

procedure TMain_Form.NewGame;
begin
  Sound( 'newgame' );
  FillChar( Map, SizeOf( Map ), 0 );
  Toggle := False;
  IsGameOver := False;
  DrawStone( sBlack );
  DrawToBuffer;
  DrawToScreen;
  Label_Message.Caption := 'ÈæÀÌ µÑ Â÷·Ê';
end;

procedure TMain_Form.CheckGameOver;
type
  PPoint = ^TPoint;
var
  i, j: Integer;
  Arrays: TList;
  IsBlackVictory: Boolean;
procedure AddArrayPoint( X, Y: Integer );
  var
    APoint: PPoint;
  begin
    New( APoint );
    APoint^.X := X;
    APoint^.Y := Y;
    Arrays.Add( APoint );
  end;
procedure CheckArrays( X, Y: Integer );
  var
    F, B, i, j, k: Integer;
  begin

   {-}
    F := X;
    B := X;
    for i := X downto 1 do
     if Map[ X, Y ] = Map[ i, Y ] then F := i
                                  else Break;
    for i := X to LineCount do
     if Map[ X, Y ] = Map[ i, Y ] then B := i
                                  else Break;
    if B - F >= 4 then
     begin
       IsBlackVictory := Map[ X, Y ] = sBlack;
       for i := F to B do
        AddArrayPoint( i, Y );
     end
    else
    if B - F = 3 then
     begin
       if ( F > 1 ) and ( B < Y ) and ( Map[ F - 1, Y ] = sNone ) and ( Map[ B + 1, Y ] = sNone ) then
        begin
          IsBlackVictory := Map[ X, Y ] = sBlack;
          for i := F to B do
           AddArrayPoint( i, Y );
        end;
     end;


   {/}  
    F := Y;
    B := Y;
    for i := Y downto 1 do
     if Map[ X, Y ] = Map[ X, i ] then F := i
                                  else Break;
    for i := X to LineCount do
     if Map[ X, Y ] = Map[ X, i ] then B := i
                                  else Break;
    if B - F >= 4 then
     begin
       IsBlackVictory := Map[ X, Y ] = sBlack;
       for i := F to B do
        AddArrayPoint( X, i );
     end
    else
    if B - F = 3 then
     begin
       if ( F > X ) and ( B < LineCount ) and ( Map[ X, F - 1 ] = sNone ) and ( Map[ X, B + 1 ] = sNone ) then
        begin
          IsBlackVictory := Map[ X, Y ] = sBlack;
          for i := F to B do
           AddArrayPoint( X, i );
        end;
     end;
     

   {\}
    F := 0;
    B := 0;

    i := X;
    j := Y;
    k := 0;
    while ( i in [1..LineCount] ) and ( j in [1..LineCount] ) do
     begin
       if Map[ X, Y ] = Map[ i, j ] then F := k
                                    else Break;
       Dec( i );
       Dec( j );
       Dec( k );
     end;

    i := X;
    j := Y;
    k := 0;
    while ( i in [1..LineCount] ) and ( j in [1..LineCount] ) do
     begin
       if Map[ X, Y ] = Map[ i, j ] then B := k
                                    else Break;
       Inc( i );
       Inc( j );
       Inc( k );
     end;

    if B - F >= 4 then
     begin
       IsBlackVictory := Map[ X, Y ] = sBlack;
       for i := F to B do
        AddArrayPoint( X + i, Y + i );
     end
    else
    if B - F = 3 then
     begin
       if ( X + F > 1 ) and ( Y + B < LineCount ) and ( Map[ X + F - 1, Y + F - 1 ] = sNone ) and ( Map[ X + B + 1, Y + B + 1 ] = sNone ) then
        begin
          IsBlackVictory := Map[ X, Y ] = sBlack;
          for i := F to B do
           AddArrayPoint( X + i, Y + i );
        end;
     end;

  end;
procedure DrawArrays;
  var
    i, X, Y, StoneX, StoneY, EllipseSize: Integer;
  begin
    BufBitmap.Canvas.Brush.Style := bsSolid;
    BufBitmap.Canvas.Brush.Color := clRed;
    BufBitmap.Canvas.Pen.Color := clRed;
    EllipseSize := LineLength div 2 - 10;
    if Arrays.Count > 0 then
     for i := 0 to Arrays.Count - 1 do
      begin
        X := PPoint( Arrays[ i ] )^.X;
        Y := PPoint( Arrays[ i ] )^.Y;
        GetStonePoint( X, Y, StoneX, StoneY );
        BufBitmap.Canvas.Ellipse( StoneX - EllipseSize, StoneY - EllipseSize, StoneX + EllipseSize, StoneY + EllipseSize );
      end;
  end;
begin
  Arrays := TList.Create;
  try
    IsBlackVictory := True;

    for j := 1 to LineCount do
     for i := 1 to LineCount do
      if Map[ i, j ] <> sNone then
       CheckArrays( i, j );

    if Arrays.Count > 0 then
     begin
       Sound( 'gameover' );
       DrawArrays;
       DrawToScreen;
       if IsBlackVictory then
        begin
          DrawStone( sBlack );
          Label_Message.Caption := 'ÈæÀÌ ÀÌ°å´Ù';
        end
       else
        begin
          DrawStone( sWhite );
          Label_Message.Caption := '¹éÀÌ ÀÌ°å´Ù';
        end;
       IsGameOver := True;
     end;

  finally
    if Arrays.Count > 0 then
     for i := Arrays.Count - 1 downto 0 do
      Dispose( PPoint( Arrays[ i ] ) );
    Arrays.Free;
  end;
end;

procedure TMain_Form.DrawStone( Stone: TStone );
var
  StoneSize: Integer;
begin
  if Stone <> sNone then
   begin
     StoneSize := LineLength - 6;

     with Image_Stone.Canvas do
      begin
        Brush.Style := bsSolid;
        Brush.Color := Color;
        FillRect( Rect( 0, 0, Image_Stone.Width, Image_Stone.Height ) );
        Brush.Color := StoneColor[ Stone ];
        Pen.Color := clBlack;
        Pen.Width := 1;
        Ellipse( 0, 0, StoneSize, StoneSize );
      end;
   end;
end;

procedure TMain_Form.DrawToBuffer;
procedure DrawStone( X, Y: Integer );
  var
    StoneX, StoneY, StoneSize: Integer;
  begin
    if Map[ X, Y ] <> sNone then
     begin
       GetStonePoint( X, Y, StoneX, StoneY );
       StoneSize := LineLength div 2 - 3;

       with BufBitmap.Canvas do
        begin
          Brush.Style := bsSolid;
          Brush.Color := StoneColor[ Map[ X, Y ] ];
          Pen.Color := clBlack;
          Pen.Width := 1;
          Ellipse( StoneX - StoneSize, StoneY - StoneSize, StoneX + StoneSize, StoneY + StoneSize );
        end;
     end;
  end;
procedure DrawSpot( X, Y: Integer );
  var
    SpotX, SpotY, SpotSize: Integer;
  begin
    GetStonePoint( X, Y, SpotX, SpotY );
    SpotSize := LineLength div 8;

    with BufBitmap.Canvas do
     begin
       Brush.Style := bsSolid;
       Brush.Color := clBlack;
       Pen.Color := clBlack;
       Pen.Width := 1;
       Ellipse( SpotX - SpotSize, SpotY - SpotSize, SpotX + SpotSize, SpotY + SpotSize );
     end;
  end;
var
  i, j, BottomLeft, BottomWidth, TopLeft, TopHeight: Integer;
begin
  with BufBitmap.Canvas do
   begin

    {draw background}

     Draw( 0, 0, Image_Background.Picture.Bitmap );


    {draw lines}

     Pen.Color := clBlack;
     Pen.Width := 1;

    {//} 
     for i := 1 to LineCount do
      begin
        BottomLeft := i  * LineLength;
        BottomWidth := ( LineCount * LineLength ) - BottomLeft;
        TopLeft := BottomLeft + ( BottomWidth div 2 );
        TopHeight := Round( BottomWidth * Sqrt( 3 ) / 2 );

        MoveTo( BottomLeft, BoardSize.cy - 1 );
        LineTo( TopLeft, BoardSize.cy - 1 - TopHeight );
      end;

    {\\}  
     for i := 2 to LineCount do
      begin
        BottomWidth := ( i - 1 ) * LineLength;
        TopLeft := BottomWidth div 2;
        TopHeight := Round( BottomWidth * Sqrt( 3 ) / 2 );

        MoveTo( LineLength + BottomWidth, BoardSize.cy - 1 );
        LineTo( LineLength + TopLeft, BoardSize.cy - 1 - TopHeight );
      end;

    {-}  
     for i := 1 to LineCount do
      begin
        TopLeft := ( LineCount * LineLength ) div 2;
        BottomWidth := LineLength * i;
        TopHeight := Round( BottomWidth * Sqrt( 3 ) / 2 );
        BottomLeft := TopLeft - ( BottomWidth div 2 );

        MoveTo( LineLength + BottomLeft, TopHeight );
        LineTo( BottomLeft + BottomWidth, TopHeight );
      end;

      
    {draw spots}

     DrawSpot( 10, 19 );
     DrawSpot( 4, 25 );
     DrawSpot( 13, 25 );
     DrawSpot( 22, 25 );
     DrawSpot( 4, 7 );
     DrawSpot( 4, 16 );
     DrawSpot( 13, 16 );

     
    {draw stones}

     for j := 1 to LineCount do
      for i := 1 to LineCount do
       DrawStone( i, j );
   end;
end;

procedure TMain_Form.DrawToScreen;
begin
  Canvas.Draw( 0, 0, BufBitmap );
end;

procedure TMain_Form.DrawCaptions;
const
  CloseButtonState: array[Boolean] of UINT = (0, DFCS_PUSHED);
  ActiveCaptionFlags: array[Boolean] of UINT = (0, DC_ACTIVE);
begin
  DrawCaption( Handle, PaintBox_Caption.Canvas.Handle, Panel_Caption.ClientRect, DC_ICON or DC_TEXT or DC_GRADIENT or ActiveCaptionFlags[ GetForegroundWindow = Handle ] );
  DrawFrameControl( PaintBox_Caption.Canvas.Handle, CloseButtonRect, DFC_CAPTION, DFCS_CAPTIONCLOSE or CloseButtonState[ CloseButtonDown ] );
  DrawFrameControl( PaintBox_Caption.Canvas.Handle, MinimizeButtonRect, DFC_CAPTION, DFCS_CAPTIONMIN or CloseButtonState[ MinimizeButtonDown ] );
end;

procedure TMain_Form.GetStonePoint( MapX, MapY: Integer; var X, Y: Integer );
var
  TopLeft, BottomLeft, BottomWidth: Integer;
begin
  BottomWidth := MapY * LineLength;
  Y := Round( BottomWidth * Sqrt( 3 ) / 2 );
  TopLeft := ( LineCount * LineLength ) div 2;
  BottomLeft := TopLeft - ( BottomWidth div 2 );
  X := BottomLeft + ( MapX * LineLength );
end;

function TMain_Form.MouseToMap( X, Y: Integer; var MapX, MapY: Integer ): Boolean;
begin
  MapY := ( ( Y + LineLength div 2 ) div Round( LineLength * Sqrt( 3 ) / 2 ) ) ;
  MapX := ( ( X + LineLength div 2 )- ( ( ( LineCount * LineLength ) - ( MapY * LineLength ) ) div 2 ) ) div LineLength;
  Result := ( MapY in [1..LineCount] ) and ( MapX > 0 ) and  ( MapX < MapY + 1 );
  if not Result then
   begin
     MapX := 0;
     MapY := 0;
   end;
end;

procedure TMain_Form.Sound( ResName: String );
begin
  SndPlaySound( PChar( ResName ), SND_ASYNC or SND_RESOURCE );
end;

procedure TMain_Form.WMActivate( var Message: TMessage );
begin
  inherited;
  PaintBox_Caption.Repaint;
end;

procedure TMain_Form.WMGetMinMaxInfo( var Message: TWMGetMinMaxInfo );
begin
  Message.MinMaxInfo^.ptMinTrackSize := Point( 705, 634 );
  Message.MinMaxInfo^.ptMaxTrackSize := Point( 705, 634 );
end;

{ event handlers }

procedure TMain_Form.FormCreate(Sender: TObject);
begin
  BoardSize.cX := LineCount * LineLength;
  BoardSize.cY := Round( ( LineCount * LineLength ) * Sqrt( 3 ) / 2 ); 

  BufBitmap := TBitmap.Create;
  BufBitmap.Width := BoardSize.cx + LineLength + 1;
  BufBitmap.Height := BoardSize.cy + LineLength + 1;

  ClientWidth := BufBitmap.Width;
  ClientHeight := BufBitmap.Height;

  Constraints.MaxHeight := Height;
  Constraints.MinHeight := Height;
  Constraints.MaxWidth := Width;
  Constraints.MinWidth := Width;

  Label_Message.Color := RGB( 255, 181, 0 );
  StaticText1.Color := Label_Message.Color;
  StaticText2.Color := Label_Message.Color;
  StaticText3.Color := Label_Message.Color;

  Screen.Cursors[ 1 ] := LoadCursor( HInstance, 'BLACKCURSOR' );
  Screen.Cursors[ 2 ] := LoadCursor( HInstance, 'WHITECURSOR' );

  DoubleBuffered := True;

  NewGame;
end;

procedure TMain_Form.FormDestroy(Sender: TObject);
begin
  BufBitmap.Free;
end;

procedure TMain_Form.FormPaint(Sender: TObject);
begin
  DrawToScreen;
end;

procedure TMain_Form.FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  MapX, MapY: Integer;
begin
  if not IsGameOver and MouseToMap( X, Y, MapX, MapY ) and ( Map[ MapX, MapY ] = sNone ) then
   begin
     Sound( 'stone' );
     if Toggle then Map[ MapX, MapY ] := sWhite
               else Map[ MapX, MapY ] := sBlack;
     Toggle := not Toggle;
     if Toggle then
      begin
        Label_Message.Caption := '¹éÀÌ µÑ Â÷·Ê';
        DrawStone( sWhite );
      end
     else
      begin
        Label_Message.Caption := 'ÈæÀÌ µÑ Â÷·Ê';
        DrawStone( sBlack );
      end;

     DrawToBuffer;
     DrawToScreen;
     CheckGameOver;
   end;
end;

procedure TMain_Form.Button_NewGameClick(Sender: TObject);
begin
  NewGame;
end;

procedure TMain_Form.FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  MapX, MapY: Integer;
begin
  if not IsGameOver and MouseToMap( X, Y, MapX, MapY ) and ( Map[ MapX, MapY ] = sNone ) then
   begin
     if Toggle then Screen.Cursor := 2
               else Screen.Cursor := 1;
   end
  else
   Screen.Cursor := crDefault;


  if MouseToMap( X, Y, MapX, MapY ) then
       Button_NewGame.Caption := Format( '%d, %d', [MapX, MapY] )
  else Button_NewGame.Caption := '»õ·Î ½ÃÀÛ';
end;

procedure TMain_Form.FormShow(Sender: TObject);
var
  Rgn: HRgn;
  PolygonPoints: array[0..8] of TPoint;
  APoint: TPoint;
  i, T, L: Integer;
begin
  APoint := ClientToScreen( Point( 0, 0 ) );
  T := APoint.Y - Top;
  L := APoint.X - Left;


  PolygonPoints[ 0 ].X := 341;
  PolygonPoints[ 0 ].Y := 8;
  PolygonPoints[ 1 ].X := 354;
  PolygonPoints[ 1 ].Y := 8;

  PolygonPoints[ 2 ].X := 434;
  PolygonPoints[ 2 ].Y := 145;
  PolygonPoints[ 3 ].X := 619;
  PolygonPoints[ 3 ].Y := 145;
  PolygonPoints[ 4 ].X := 619;
  PolygonPoints[ 4 ].Y := 463;

  PolygonPoints[ 5 ].X := 688;
  PolygonPoints[ 5 ].Y := 582;
  PolygonPoints[ 6 ].X := 680;
  PolygonPoints[ 6 ].Y := 595;
  PolygonPoints[ 7 ].X := 17;
  PolygonPoints[ 7 ].Y := 595;
  PolygonPoints[ 8 ].X := 10;
  PolygonPoints[ 8 ].Y := 581;


  for i := 0 to 8 do
   begin
     Inc( PolygonPoints[ i ].X, L );
     Inc( PolygonPoints[ i ].Y, T );
   end;


  Rgn := CreatePolygonRgn( PolygonPoints, 9, 1 );
  try
    SetWindowRgn( Handle, Rgn, False );
  finally
    DeleteObject( Rgn );
  end;
end;

procedure TMain_Form.PaintBox_CaptionPaint(Sender: TObject);
begin
  DrawCaptions;
end;

procedure TMain_Form.PaintBox_CaptionMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if PtInRect( CloseButtonRect, Point( X, Y ) ) then
   begin
     CloseButtonDown := True;
     PaintBox_Caption.Repaint;
   end
  else
  if PtInRect( MinimizeButtonRect, Point( X, Y ) ) then
   begin
     MinimizeButtonDown := True;
     PaintBox_Caption.Repaint;
   end
  else
   begin
     ReleaseCapture;
     SendMessage( Handle, WM_SYSCOMMAND, $F012, 0 );
   end;
end;

procedure TMain_Form.PaintBox_CaptionMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if CloseButtonDown and PtInRect( CloseButtonRect, Point( X, Y ) ) then Close;
  if CloseButtonDown then
   begin
     CloseButtonDown := False;
     PaintBox_Caption.Repaint;
   end;

  if MinimizeButtonDown and PtInRect( MinimizeButtonRect, Point( X, Y ) ) then Application.Minimize;
  if MinimizeButtonDown then
   begin
     MinimizeButtonDown := False;
     PaintBox_Caption.Repaint;
   end;
end;

procedure TMain_Form.StaticText3Click(Sender: TObject);
begin
  ShellExecute( 0, nil, PChar( 'mailto:' + TControl( Sender ).Hint ), nil, nil, SW_SHOW );
end;

end.
