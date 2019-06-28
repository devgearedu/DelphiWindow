unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    PaintBox1: TPaintBox;
    Memo1: TMemo;
    procedure FormPaint(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure Draw(Canvas: TCanvas);
begin
  Canvas.Brush.Color := clYellow;
  Canvas.Brush.Style := bsSolid;
  Canvas.Pen.Color := clRed;
  Canvas.Pen.Width := 3;
  Canvas.Pen.Style := psSolid;
  Canvas.Pen.Mode := pmCopy;
  Canvas.Ellipse( 50, 50, 200, 200 );


  Canvas.Brush.Color := clAqua;
  Canvas.Pen.Color := clBlue;
  Canvas.Rectangle( 100, 150, 300, 300 );

  Canvas.Brush.Style := bsClear;
  Canvas.Font.Name := '굴림';
  Canvas.Font.Size := 20;
  Canvas.TextOut( 30, 250, '가나다라 마바사아' );

  Canvas.Brush.Color := clBlack;
  Canvas.Brush.Style := bsSolid;
  Canvas.Pen.Mode := pmNotXor;
  Canvas.Pen.Style := psClear;
  Canvas.Pen.Width := 0;
  Canvas.Rectangle( 50, 100, 150, 200 );
end;

procedure TForm1.FormPaint(Sender: TObject);
var
  OldMapMode: Integer;
  OldWindowExtEx: TSize;
  OldViewportExtEx: TSize;
begin
  OldMapMode := SetMapMode( Canvas.Handle, MM_ANISOTROPIC );

  SetWindowExtEx  ( Canvas.Handle, 10, 10, @OldWindowExtEx );
  SetViewportExtEx( Canvas.Handle, 20, 20, @OldViewportExtEx );

  Draw( Canvas );

  SetWindowExtEx( Canvas.Handle, OldWindowExtEx.cx, OldWindowExtEx.cy, nil );
  SetViewportExtEx( Canvas.Handle, OldViewportExtEx.cx, OldViewportExtEx.cy, nil );
  SetMapMode( Canvas.Handle, OldMapMode );
end;

procedure TForm1.PaintBox1Paint(Sender: TObject);
begin
  Draw( TPaintBox(Sender).Canvas );
end;

end.
