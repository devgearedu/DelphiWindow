unit Main_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TMain_Form = class(TForm)
    Edit: TEdit;
    Button: TButton;
    Memo: TMemo;
    procedure EditKeyPress(Sender: TObject; var Key: Char);
    procedure ButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Main_Form: TMain_Form;

implementation

{$R *.dfm}

procedure TMain_Form.EditKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
   begin
     Key := #0;
     ButtonClick( nil );
   end;
end;

procedure TMain_Form.ButtonClick(Sender: TObject);
var
  Wnd: HWnd;
  X, Y: Integer;
  Bitmap: TBitmap;
function FindAfxOleControl42(Wnd: HWnd): HWnd;
  begin
    Result := FindWindowEx( Wnd, 0, 'AfxOleControl42', nil );
    if Result <> 0 then
     Result := FindWindowEx( Result, 0, '#32770', nil );
  end;
function FindWnd: HWnd;
  var
    Wnd: HWnd;
  begin
    Result := 0;
    Wnd := FindWindowEx( 0, 0, '#32770', nil );
    while Wnd <> 0 do
     begin
       Result := FindAfxOleControl42( Wnd );
       if Result <> 0 then Break;
       Wnd := FindWindowEx( 0, Wnd, '#32770', nil );
     end;
  end;
begin
  Bitmap := TBitmap.Create;
  try
    Bitmap.Width := 54;
    Bitmap.Height := 18;
    Bitmap.Canvas.TextOut( 2, 2, Edit.Text );

    Wnd := FindWnd;

    if Wnd <> 0 then
     for Y := 0 to 17 do
      for X := 0 to 53 do
       if Bitmap.Canvas.Pixels[ X, Y ] = clBlack then
        begin
          SendMessage( Wnd, WM_LBUTTONDOWN, 0, MakeLParam( X * 6, Y * 6 ) );
          SendMessage( Wnd, WM_LBUTTONUP, 0, MakeLParam( X * 6 + 1, Y * 6 + 1 ) );
        end;
  finally
    Bitmap.Free;
  end;

  Edit.SelectAll;
end;


end.
