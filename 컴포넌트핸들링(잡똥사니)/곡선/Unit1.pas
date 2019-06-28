unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin;

type
  TDPoint = record
    X: Double;
    Y: Double;
  end;


  TForm2 = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure SpinEdit1Change(Sender: TObject);
  private
    APt1, APt2, APt3: TDPoint;
    DragIndex: Integer;
    procedure DrawLines;
  public
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

const
  HotSpotWidth = 14;
  HotSpot = HotSpotWidth div 2;

procedure DrawQSPLine(Canvas: TCanvas; SplinePrecision: Integer; const LineA, Curve, LineB: TDPoint);
var
  OneSpline, CurrentSpline: Double;
  X, Y: Integer;
function Calc(const A, B, C: Double): Integer;
  begin
    Result := Round( ( A + B - C * 2 ) * Sqr( CurrentSpline ) + ( C - A ) * CurrentSpline * 2 + A );
  end;
begin
  OneSpline := 1 / SplinePrecision;
  CurrentSpline := OneSpline;

  Canvas.MoveTo( Round( LineA.X ), Round( LineA.Y ) );

  while CurrentSpline <= 1 do
   begin
     if CurrentSpline - OneSpline / 2 > 1 - OneSpline then CurrentSpline := 1;

     X := Calc( LineA.X, LineB.X, Curve.X );
     Y := Calc( LineA.Y, LineB.Y, Curve.Y );

     Canvas.LineTo( X, Y );

     CurrentSpline := CurrentSpline + OneSpline;
   end;

  Canvas.LineTo( Round( LineB.X ), Round( LineB.Y ) );
end;

function CalcSplinePrecision(const APt1, APt2, APt3: TDPoint): Integer;
var
  V1, V2, V3, VW, VH, V: Integer;
begin
  V1 := Abs( Round( APt1.X ) - Round( APt2.X ) );
  V2 := Abs( Round( APt2.X ) - Round( APt3.X ) );
  V3 := Abs( Round( APt1.X ) - Round( APt3.X ) );

  if V1 > V2 then VW := V1
             else VW := V2;
  if V3 > VW then VW := V3;

  V1 := Abs( Round( APt1.Y ) - Round( APt2.Y ) );
  V2 := Abs( Round( APt2.Y ) - Round( APt3.Y ) );
  V3 := Abs( Round( APt1.Y ) - Round( APt3.Y ) );

  if V1 > V2 then VH := V1
             else VH := V2;
  if V3 > VW then VH := V3;

  if VW > VH then V := VW
             else V := VH;

  V := ( V div 20 ) + ( 10 - ( V mod 10 ) ) + 10;
  Result := V;
end;

procedure TForm2.DrawLines;
var
  V: Integer;
begin

  V := CalcSplinePrecision( APt1, APt2, APt3 );
  Caption := IntToStr( V );


  Canvas.Brush.Color := Color;
  Canvas.FillRect( ClientRect );

  Canvas.Pen.Color := clBlue;
  Canvas.Brush.Color := clBlue;
  Canvas.Rectangle( Round( APt1.X ) - HotSpot, Round( APt1.Y ) - HotSpot, Round( APt1.X ) + HotSpot, Round( APt1.Y ) + HotSpot );
  Canvas.Rectangle( Round( APt3.X ) - HotSpot, Round( APt3.Y ) - HotSpot, Round( APt3.X ) + HotSpot, Round( APt3.Y ) + HotSpot );

  Canvas.Pen.Color := clRed;
  Canvas.Brush.Color := clRed;
  Canvas.Rectangle( Round( APt2.X ) - HotSpot, Round( APt2.Y ) - HotSpot, Round( APt2.X ) + HotSpot, Round( APt2.Y ) + HotSpot );

  Canvas.Pen.Color := clBlack;
  DrawQSPLine( Canvas, V, APt1, APt2, APt3 );
  
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  APt1.X := 100;
  APt1.Y := 500;

  APt2.X := 500;
  APt2.Y := 50;

  APt3.X := 900;
  APt3.Y := 500;
end;

procedure TForm2.FormPaint(Sender: TObject);
begin
  DrawLines;
end;

procedure TForm2.FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if PtInRect( Rect( Round( APt1.X ) - HotSpot, Round( APt1.Y ) - HotSpot, Round( APt1.X ) + HotSpot, Round( APt1.Y ) + HotSpot ), Point( X, Y ) ) then DragIndex := 1 else
  if PtInRect( Rect( Round( APt2.X ) - HotSpot, Round( APt2.Y ) - HotSpot, Round( APt2.X ) + HotSpot, Round( APt2.Y ) + HotSpot ), Point( X, Y ) ) then DragIndex := 2 else
  if PtInRect( Rect( Round( APt3.X ) - HotSpot, Round( APt3.Y ) - HotSpot, Round( APt3.X ) + HotSpot, Round( APt3.Y ) + HotSpot ), Point( X, Y ) ) then DragIndex := 3
                                                                                                                                                   else DragIndex := 0;
end;

procedure TForm2.FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  case DragIndex of
  1: begin
       APt1.X := X;
       APt1.Y := Y;
     end;
  2: begin
       APt2.X := X;
       APt2.Y := Y;
     end;
  3: begin
       APt3.X := X;
       APt3.Y := Y;
     end;
  end;

  if DragIndex in [1..3] then DrawLines;
end;

procedure TForm2.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  DragIndex := 0;
end;

procedure TForm2.SpinEdit1Change(Sender: TObject);
begin
  DrawLines;
end;

end.
