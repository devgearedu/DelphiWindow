unit Test_Frm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, PngImage,
  ExtCtrls;

type
  TTest_Form = class(TForm)
    procedure FormShow(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  private
    procedure LoadPng(const FileName: String);
    procedure UpdateFromBitmap(Bitmap: TBitmap);
  public
  end;

var
  Test_Form: TTest_Form;

implementation

{$R *.DFM}

function FindPngFile: String;
var
  Path: String;
  SearchRec: TSearchRec;
  FindResult: Integer;
begin
  Path := ExtractFilePath( Application.ExeName );

  FindResult := FindFirst( Path + '*.png', faReadOnly or faHidden or faSysFile or faArchive, SearchRec );
  try
    if FindResult = 0 then
     Result := Path + String( SearchRec.FindData.cFileName );
  finally
    FindClose( SearchRec );
  end;
end;

procedure TTest_Form.LoadPng(const FileName: String);
var
  PngImage: TPngObject;
  Bitmap: TBitmap;
begin
  PngImage := TPngObject.Create;
  Bitmap := TBitmap.Create;

  try
    PngImage.LoadFromFile( FileName );
    PngImage.CopyToBitmap32( Bitmap ); {TPngObject.CopyToBitmap32메소드는 양병규가 추가한거다. 첨부된 PNG폴더에 있다.}

    UpdateFromBitmap( Bitmap );

  finally
    PngImage.Free;
    Bitmap.Free;
  end;
end;

procedure TTest_Form.UpdateFromBitmap(Bitmap: TBitmap);
var
  DestPoint, SourcePoint: TPoint;
  BlendFunction: TBlendFunction;
  Size: TSize;
  DC: HDC;
begin
  SetWindowLong( Handle, GetWindowLong( Handle, GWL_EXSTYLE ) or GWL_EXSTYLE, WS_EX_LAYERED );
  Size.cx := Bitmap.Width;
  Size.cy := Bitmap.Height;

  ClientWidth := Size.cx;
  ClientHeight := Size.cy;

  DestPoint := BoundsRect.TopLeft;
  SourcePoint := Point( 0, 0 );

  DC := GetDC( 0 );

  BlendFunction.BlendOp := AC_SRC_OVER;
  BlendFunction.BlendFlags := 0;
  BlendFunction.SourceConstantAlpha := 255;
  BlendFunction.AlphaFormat := AC_SRC_ALPHA;

  UpdateLayeredWindow( Handle, DC, @DestPoint, @Size, Bitmap.Canvas.Handle, @SourcePoint, clNone, @BlendFunction, ULW_ALPHA );

  ReleaseDC( 0, DC );
end;

procedure TTest_Form.FormShow(Sender: TObject);
var
  FileName: String;
begin
  FileName := FindPngFile;
  if FileExists( FindPngFile ) then LoadPng(  FindPngFile );
end;

procedure TTest_Form.FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture;
  SendMessage( Handle, WM_SYSCOMMAND, $F012, 0 );
end;

end.

