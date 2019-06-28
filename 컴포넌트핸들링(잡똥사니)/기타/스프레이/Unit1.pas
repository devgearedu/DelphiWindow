unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, pngimage, ExtCtrls, StdCtrls, jpeg;

type
  TForm1 = class(TForm)
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Image7: TImage;
    Image6: TImage;
    RadioGroup1: TRadioGroup;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure RadioGroup1Click(Sender: TObject);
  private
    Draging: Boolean;
    Graphic: TGraphic;
  public
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  RadioGroup1Click( RadioGroup1 );
end;

procedure TForm1.FormPaint(Sender: TObject);
begin
  Canvas.Draw( 0, 0, Image7.Picture.Graphic );
end;

procedure TForm1.FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
   begin
     Draging := True;
     FormMouseMove( Sender, Shift, X, Y );
   end;
end;

procedure TForm1.FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  L, T: Integer;
begin
  if Draging then
   begin
     L := X - Graphic.Width div 2;
     T := Y - Graphic.Height div 2;
     Canvas.Draw( L, T, Graphic );
   end;
end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then Draging := False;
end;

procedure TForm1.RadioGroup1Click(Sender: TObject);
var
  Image: TImage;
begin
  Image := TImage( FindComponent( 'Image' + IntToStr( TRadioGroup( Sender ).ItemIndex + 1 ) ) );
  if Image <> nil then Graphic := Image.Picture.Graphic
                  else Graphic := nil;
end;

end.
