{$WARN SYMBOL_DEPRECATED OFF}
{$WARN UNSAFE_TYPE OFF}

unit Main_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, OleCtrls, ExtCtrls, ShockwaveFlashObjects_TLB;

type
  TMain_Form = class(TForm)
    Flash: TFlash;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FlashReadyStateChange(Sender: TObject; newState: Integer);
  private
    FlashOldProc: Pointer;
    FlashNewProc: Pointer;
    procedure LoadFlash;
    procedure StartFlashMsgHook;
    procedure StopFlashMsgHook;
    procedure FlashWndProc( var Message: TMessage );
  public
  end;

var
  Main_Form: TMain_Form;

implementation

uses
  BitmapRgn;

{$R *.dfm}

procedure SetWindowRgnFromBitmap(Wnd: HWnd; Bitmap: TBitmap);
var
  Rgn: HRGN;
begin
  Rgn := CreateBitmapRgn( Bitmap );
  try
    SetWindowRgn( Wnd, Rgn, True );
  finally
    DeleteObject( Rgn );
  end;
end;

procedure TMain_Form.LoadFlash;
begin
  Flash.LoadMovie( 0, ExtractFilePath( Application.ExeName ) + 'ÇÇÄ«Ãò.swf' );
end;

procedure TMain_Form.StartFlashMsgHook;
begin
  FlashOldProc := Pointer( GetWindowLong( Flash.Handle, GWL_WNDPROC ) );
  FlashNewProc := MakeObjectInstance( FlashWndProc );
  SetWindowLong( Flash.Handle, GWL_WNDPROC, Longint( FlashNewProc ) );
end;

procedure TMain_Form.StopFlashMsgHook;
begin
  SetWindowLong( Flash.Handle, GWL_WNDPROC, Longint( FlashOldProc ) );
  FreeObjectInstance( FlashNewProc );
end;

procedure TMain_Form.FlashWndProc(var Message: TMessage);
var
  Bitmap: TBitmap;
begin
  with Message do
   begin
     case Msg of
     WM_PAINT: begin
                 Bitmap := TBitmap.Create;
                 try
                   Bitmap.PixelFormat := pf24Bit;
                   Bitmap.Width := Width;
                   Bitmap.Height := Height;
                   CallWindowProc( FlashOldProc, Flash.Handle, Msg, Bitmap.Canvas.Handle, LParam );
                   SetWindowRgnFromBitmap( Handle, Bitmap );
                 finally
                   Bitmap.Free;
                 end;
               end;
     WM_RBUTTONDOWN: begin
                       Exit;
                     end;
     end;

     Result := CallWindowProc( FlashOldProc, Flash.Handle, Msg, WParam, LParam );
   end;
end;

{event handlers}

procedure TMain_Form.FormCreate(Sender: TObject);
begin
  Width := 0;

  LoadFlash;
  StartFlashMsgHook;
end;

procedure TMain_Form.FormDestroy(Sender: TObject);
begin
  StopFlashMsgHook;
end;

procedure TMain_Form.FlashReadyStateChange(Sender: TObject; newState: Integer);
begin
  case newState of
  4: begin
       Width := Flash.Width;
       Height := Flash.Height;
     end;
  end;
end;

end.
