unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ImgList, System.ImageList;

type
  TForm1 = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    ImageList_Drag: TImageList;
    procedure PageControl1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure PageControl1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure PageControl1MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure PageControl1StartDrag(Sender: TObject; var DragObject: TDragObject);
    procedure PageControl1DragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure PageControl1DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure PageControl1EndDrag(Sender, Target: TObject; X, Y: Integer);
  private
    FDraging: Boolean;
    FDragPos: TPoint;
    FDragTop: Integer;
    FDragLeft: Integer;
  public
  end;

var
  Form1: TForm1;

implementation

uses Types;

{$R *.dfm}
{$R WindowsXP.res}

type

{ TTabDragObject }

  TTabDragObject = class(TBaseDragControlObject)
  private
    PageControl: TPageControl;
    DragImageList: TImageList;
    PageIndex: Integer;
    CurrentWnd: HWnd;
  protected
    procedure WndProc(var Msg: TMessage); override;
    function GetDragCursor(Accepted: Boolean; X, Y: Integer): TCursor; override;
  end;

procedure TTabDragObject.WndProc(var Msg: TMessage);
var
  Wnd: HWnd;
begin
  inherited;

  case Msg.Msg of
  WM_MOUSEMOVE: begin
                  Wnd := WindowFromPoint( Mouse.CursorPos );

                  if Wnd <> CurrentWnd then
                   begin
                     if Wnd <> TWinControl(Control).Handle then
                      DragImageList.HideDragImage;
                     
                     CurrentWnd := Wnd;
                   end;
                end;
  end;
end;

function TTabDragObject.GetDragCursor(Accepted: Boolean; X, Y: Integer): TCursor;
begin
  if Accepted then Result := crArrow
              else Result := crNoDrop;
end;
  
procedure TForm1.PageControl1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FDraging := Button = mbLeft;
  if FDraging then
   FDragPos := Mouse.CursorPos;
end;

procedure Dark(Bitmap: TBitmap);
type
  PPixels = ^TPixels;
  TPixels = array[0..0] of TRGBQuad;
var
  Pixels: PPixels;
  Col, Row: Integer;
procedure DarkByte(var B: Byte);
  const
    DarkValue = 50;
  begin
    if B > DarkValue then Dec( B, DarkValue )
                     else B := 0;
  end;
begin
  for Row := 0 to Bitmap.Height - 1 do
   begin
     Pixels := Bitmap.ScanLine[ Row ];
     for Col := 0 to Bitmap.Width - 1 do
      begin
        DarkByte( Pixels^[ Col ].rgbRed );
        DarkByte( Pixels^[ Col ].rgbGreen );
        DarkByte( Pixels^[ Col ].rgbBlue );
      end;
   end;
end;

procedure TForm1.PageControl1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  Bitmap: TBitmap;
  Rect: TRect;
  DC: HDC;
begin
  if FDraging and ( TPageControl(Sender).ActivePage <> nil ) then
   begin
     if ( Abs( FDragPos.X -  Mouse.CursorPos.X ) >= 5 ) or ( Abs( FDragPos.Y -  Mouse.CursorPos.Y ) >= 5 ) then
      begin
        TControl(Sender).BeginDrag( False );


        Bitmap := TBitmap.Create;
        Bitmap.PixelFormat := pf32Bit;

        Rect := TPageControl(Sender).TabRect( TPageControl(Sender).ActivePageIndex );

        InflateRect( Rect, 2, 2 );


        FDragTop := Rect.Top;
        FDragLeft := X - Rect.Left;
        Bitmap.Width := Rect.Right - Rect.Left;
        Bitmap.Height := Rect.Bottom - Rect.Top;

        DC := GetDC( TWinControl(Sender).Handle );
        BitBlt( Bitmap.Canvas.Handle, 0, 0, Bitmap.Width, Bitmap.Height, DC, Rect.Left, Rect.Top, SRCCOPY );
        ReleaseDC( TWinControl(Sender).Handle, DC );

        Dark( Bitmap );

        ImageList_Drag.Clear;
        ImageList_Drag.Width := Bitmap.Width;
        ImageList_Drag.Height := Bitmap.Height;
        ImageList_Drag.Add( Bitmap, nil );
        ImageList_Drag.BeginDrag( TWinControl(Sender).Handle, X - FDragLeft, FDragTop );

        ShowCursor( True );
      end;
   end;
end;

procedure TForm1.PageControl1MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then FDraging := False;
end;

procedure TForm1.PageControl1StartDrag(Sender: TObject; var DragObject: TDragObject);
begin
  DragObject := TTabDragObject.Create( TPageControl(Sender) );
  TTabDragObject(DragObject).PageControl := TPageControl(Sender);
  TTabDragObject(DragObject).PageIndex := TPageControl(Sender).ActivePageIndex;
  TTabDragObject(DragObject).DragImageList := ImageList_Drag;
end;

procedure TForm1.PageControl1DragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
var
  HitTests: THitTests;
  DestIndex: Integer;
begin
  HitTests := TPageControl(Sender).GetHitTestInfoAt( X, Y );
  DestIndex := TPageControl(Sender).IndexOfTabAt( X, Y );
  Accept :=  ( htOnItem in HitTests ) and
             ( Source is TTabDragObject ) and
             ( TTabDragObject(Source).PageControl = Sender ) and
             ( TTabDragObject(Source).PageIndex <> TPageControl(Sender).Pages[ DestIndex ].PageIndex );

  ImageList_Drag.DragMove( X - FDragLeft, FDragTop );
  ImageList_Drag.ShowDragImage;
end;

procedure TForm1.PageControl1DragDrop(Sender, Source: TObject; X, Y: Integer);
var
  HitTests: THitTests;
  SourceIndex, DestIndex: Integer;
begin
  HitTests := TPageControl(Sender).GetHitTestInfoAt( X, Y );
  if ( htOnItem in HitTests ) and ( Source is TTabDragObject ) and ( TTabDragObject(Source).PageControl = Sender ) then
   begin
     SourceIndex := TTabDragObject(Source).PageIndex;
     DestIndex := TPageControl(Sender).IndexOfTabAt( X, Y );

     TPageControl(Sender).Pages[ SourceIndex ].PageIndex := DestIndex;
   end;
end;

procedure TForm1.PageControl1EndDrag(Sender, Target: TObject; X, Y: Integer);
begin
  ImageList_Drag.EndDrag;
end;

end.
