unit MDIControls;

interface

uses
  Windows, Messages, Classes, Controls, Forms;

procedure MakeMDIControl(Control: TWinControl; const Caption: String; CloseButton, SizeBar: Boolean);

implementation

type
  TMDIControl = class(TComponent)
  private
    ControlName: String;
    FControl: TWinControl;
    FControlOldWindowProc: TWndMethod;
    procedure ControlWndProc(var Message: TMessage);
  private
    FForm: TCustomForm;
    FFormOldWindowProc: TWndMethod;
    procedure FormWndProc(var Message: TMessage);
  private
    FWndProc: Boolean;
    procedure BeginWndProc;
    procedure EndWndProc;
  public
    constructor Create(Control: TWinControl; Form: TCustomForm); reintroduce;
    destructor Destroy; override;
    procedure CreateCaption(const Caption: String; CloseButton, SizeBar: Boolean);
    procedure FlashWindow;
  end;

constructor TMDIControl.Create(Control: TWinControl; Form: TCustomForm);
begin
  inherited Create( nil );

  ControlName := Control.Name;

  FControl := Control;
  FForm := Form;

  BeginWndProc;
end;

destructor TMDIControl.Destroy;
begin
  EndWndProc;
  
  inherited Destroy;
end;

procedure TMDIControl.ControlWndProc(var Message: TMessage);
begin
  if FControl = nil then Exit;

  case Message.Msg of
  WM_ACTIVATE,
  WM_NCACTIVATE: begin
                   TWMNCActivate(Message).Active := GetForegroundWindow = FForm.Handle;
                 end;
  WM_CLOSE     : begin
                   FControl.Visible := False;
                   Exit;
                 end;
  WM_DESTROY   : begin
                   EndWndProc;
                   Free;
                   FForm := nil;
                   FControl := nil;
                 end;
  end;

  FControlOldWindowProc( Message );
end;

procedure TMDIControl.FormWndProc(var Message: TMessage);
begin
  if FForm = nil then Exit;

  case Message.Msg of
  WM_ACTIVATE,
  WM_NCACTIVATE: begin
                   FlashWindow;
                 end;
  WM_DESTROY   : begin
                   EndWndProc;
                   Free;
                   FForm := nil;
                   FControl := nil;
                 end;
  end;

  FFormOldWindowProc( Message );
end;

procedure TMDIControl.CreateCaption(const Caption: String; CloseButton, SizeBar: Boolean);
var
  NewStyle: Integer;
begin
  NewStyle := GetWindowLong( FControl.Handle, GWL_STYLE ) or WS_CAPTION;
  if CloseButton then NewStyle := NewStyle or WS_SYSMENU;
  if SizeBar then NewStyle := NewStyle or WS_THICKFRAME;
  SetWindowLong( FControl.Handle, GWL_STYLE,  NewStyle );

  SetWindowLong( FControl.Handle, GWL_EXSTYLE, GetWindowLong( FControl.Handle, GWL_EXSTYLE ) or WS_EX_TOOLWINDOW );

  SetWindowPos( FControl.Handle, 0, 0, 0, 0, 0, SWP_NOSIZE or SWP_NOMOVE or SWP_NOACTIVATE or SWP_FRAMECHANGED );

  SetWindowText( FControl.Handle, PChar(Caption) );
end;

procedure TMDIControl.FlashWindow;
begin
  Windows.FlashWindow( FControl.Handle, True );
end;

procedure MakeMDIControl(Control: TWinControl; const Caption: String; CloseButton, SizeBar: Boolean);
var
  Form: TCustomForm;
begin
  Form := GetParentForm( Control );
  if Form <> nil then
   with TMDIControl.Create( Control, Form ) do
    CreateCaption( Caption, CloseButton, SizeBar );
end;

procedure TMDIControl.BeginWndProc;
begin
  if FWndProc then Exit;
  
  FControlOldWindowProc := FControl.WindowProc;
  FControl.WindowProc := ControlWndProc;

  FFormOldWindowProc := FForm.WindowProc;
  FForm.WindowProc := FormWndProc;

  FWndProc := True;
end;

procedure TMDIControl.EndWndProc;
begin
  if FWndProc then
   begin
     FControl.WindowProc := FControlOldWindowProc;
     FForm.WindowProc := FFormOldWindowProc;
   end;
end;

end.
