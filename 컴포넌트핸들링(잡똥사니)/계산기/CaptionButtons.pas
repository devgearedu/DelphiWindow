unit CaptionButtons;

interface

uses
  Windows, Classes, Graphics, Forms;

type
  TOnDrawIcon = procedure (Sender: TObject; Canvas: TCanvas; const ButtonRect: TRect) of object;

procedure CreateCaptionButton(Form: TForm; AOnClick: TNotifyEvent; AOnDrawIcon: TOnDrawIcon);

implementation

uses
  Messages, Menus, SysUtils, Controls, ExtCtrls, Themes;

const
  MENUICON_WIDTH  = 32;
  MENUICON_HEIGHT = 32;
  MENUMARGIN = 20;
  MONITORSELECTER_MARGIN = 6;
  MONITORSELECTER_SCALE = 16;
  MONITORSELECTER_FRAME = 3;

type
  TCaptionButton = class(TComponent)
  private
    FForm: TForm;
    FOldWndProc: Pointer;
    FNewWndProc: Pointer;
    FDrawBack: Integer;
    FMinmizeButtonLeft: Integer;
    FOnClick: TNotifyEvent;
    FOnDrawIcon: TOnDrawIcon;
    procedure WndProc(var Message: TMessage);
    procedure CalcButtonRect(var ButtonRect: TRect);
    procedure DrawButton;
    procedure DrawButtonBackground(Canvas: TCanvas; const ButtonRect: TRect);
    procedure DrawButtonIcon(Canvas: TCanvas; const ButtonRect: TRect);
    function CursorInButton: Boolean;
    function MinmizeButtonLeft: Integer;
    procedure DoClick;
    procedure MenuPopup;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property OnClick: TNotifyEvent read FOnClick write FOnClick;
    property OnDrawIcon: TOnDrawIcon read FOnDrawIcon write FOnDrawIcon;
  end;

type
  TTriVertEx = packed record
    X: DWord;
    Y: DWord;
    Red: Word;
    Green: Word;
    Blue: Word;
    Alpha: Word;
  end;

function GradientFill(DC: hDC; pVertex: Pointer; dwNumVertex: DWORD; pMesh: Pointer; dwNumMesh, dwMode: DWord): DWord; stdcall; external 'msimg32.dll';

procedure DrawGradient(Canvas: TCanvas; const Rect: TRect; StartColor, EndColor: TColor; Vertical: Boolean);
const
  Mode: array[Boolean] of DWord = (GRADIENT_FILL_RECT_H, GRADIENT_FILL_RECT_V);
var
  Vertex : array[0..1] of TTriVertEx;
  GradientRect: TGradientRect;
  Color1, Color2: Cardinal;
  R, G, B: Byte;
begin
  Color1 := ColorToRGB( StartColor );
  Color2 := ColorToRGB( EndColor );

  R := GetRValue( Color1 );
  G := GetGValue( Color1 );
  B := GetBValue( Color1 );

  Vertex[0].x := Rect.Left;
  Vertex[0].y := Rect.Top;
  Vertex[0].Red := R * $100;
  Vertex[0].Green := G * $100;
  Vertex[0].Blue := B * $100;
  Vertex[0].Alpha := $0000;

  R := GetRValue( Color2 );
  G := GetGValue( Color2 );
  B := GetBValue( Color2 );

  Vertex[1].x := Rect.Right;
  Vertex[1].y := Rect.Bottom;
  Vertex[1].Red := R * $100;
  Vertex[1].Green := G * $100;
  Vertex[1].Blue := B * $100;
  Vertex[1].Alpha := $0000;

  GradientRect.UpperLeft := 0;
  GradientRect.LowerRight := 1;

  GradientFill( Canvas.Handle, @Vertex, 2, @GradientRect, 1, Mode[ Vertical ] );
end;

function CanCreateCaptionButton(Form: TForm): Boolean;
var
  Style: Integer;
begin
  Result := ( Form <> nil ) and ( Form.FormStyle <> fsMDIChild ) and ( Form.Parent = nil );

  if Result then
   begin
     Style := GetWindowLong( Form.Handle, GWL_STYLE );
     Result := Result and
               ( Style and WS_CHILD = 0 ) and
               ( Style and WS_CAPTION <> 0 ) and
               ( Style and WS_SYSMENU <> 0 ) and
               ( ( Style and WS_MINIMIZEBOX <> 0 ) or ( Style and WS_MAXIMIZEBOX <> 0 ) );
   end;
end;

function GetAnimation: Boolean;
var
  Info: TAnimationInfo;
begin
  Info.cbSize := SizeOf(TAnimationInfo);
  if SystemParametersInfo(SPI_GETANIMATION, SizeOf(Info), @Info, 0) then
    Result := Info.iMinAnimate <> 0 else
    Result := False;
end;

procedure SetAnimation(Value: Boolean);
var
  Info: TAnimationInfo;
begin
  Info.cbSize := SizeOf(TAnimationInfo);
  BOOL(Info.iMinAnimate) := Value;
  SystemParametersInfo(SPI_SETANIMATION, SizeOf(Info), @Info, 0);
end;

constructor TCaptionButton.Create(AOwner: TComponent);
begin
  inherited Create( AOwner );

  if AOwner is TForm then
   begin
     FForm := TForm(AOwner);
     FOldWndProc := Pointer( GetWindowLong( FForm.Handle, GWL_WNDPROC ) );
     FNewWndProc := Classes.MakeObjectInstance( WndProc );
     SetWindowLong( FForm.Handle, GWL_WNDPROC, Integer( FNewWndProc ) );
   end
  else
   FForm := nil;

  FDrawBack := 0;
end;

destructor TCaptionButton.Destroy;
begin
  if FForm <> nil then
   begin
     //SetWindowLong( FForm.Handle, GWL_WNDPROC, Integer( FOldWndProc ) );
     Classes.FreeObjectInstance( FNewWndProc );
     FForm := nil;
   end;

  inherited Destroy;
end;

procedure TCaptionButton.WndProc(var Message: TMessage);
procedure CallOldWndProc;
  begin
    Message.Result := CallWindowProc( FOldWndProc, FForm.Handle, Message.Msg, Message.WParam, Message.LParam );
  end;
begin
  case Message.Msg of
  WM_NCLBUTTONDOWN,
  WM_NCLBUTTONDBLCLK: begin
                        if CursorInButton then DoClick;
                      end;

  WM_NCRBUTTONDOWN  : begin
                        if CursorInButton then
                         begin
                           MenuPopup;
                           Exit;
                         end;
                      end;

  $AE,
  WM_SIZE,
  WM_MOVE,
  WM_ACTIVATE,
  WM_NCPAINT        : begin
                        CallOldWndProc;
                        DrawButton;
                        Exit;
                      end;
  end;

  CallOldWndProc;
end;

function GetMinmizeButtonLeft(Wnd: HWnd): Integer;
var
  WindowRect: TRect;
  X, Y: Integer;
begin
  Result := 180;
  Exit;

  GetWindowRect( Wnd, WindowRect );
  Y := WindowRect.Top + GetSystemMetrics( SM_CYCAPTION ) div 2;

  for X := WindowRect.Left to WindowRect.Right - 1 do
   if SendMessage( Wnd, WM_NCHITTEST, 0, MakeLParam( X, Y ) ) = HTREDUCE then
    begin
      Result := X - WindowRect.Left;
      Exit;
    end;

  Result := 0;
end;

procedure TCaptionButton.CalcButtonRect(var ButtonRect: TRect);
var
  WindowRect: TRect;
  CaptionHeight, ButtonWidth: Integer;
begin
  GetWindowRect( FForm.Handle, WindowRect );
  CaptionHeight := GetSystemMetrics( SM_CYCAPTION );
  ButtonWidth := CaptionHeight - GetSystemMetrics( SM_CYFRAME ) - GetSystemMetrics( SM_CYBORDER );

//  ButtonRect.Right := MinmizeButtonLeft - 5;
//  ButtonRect.Left := ButtonRect.Right - ButtonWidth;

  ButtonRect.Left := MinmizeButtonLeft;
  ButtonRect.Right := ButtonRect.Left + ButtonWidth;

  ButtonRect.Bottom := CaptionHeight + GetSystemMetrics( SM_CYBORDER );
  ButtonRect.Top := ButtonRect.Bottom - ButtonWidth;
end;

procedure TCaptionButton.DrawButton;
var
  DC: HDC;
  Canvas: TCanvas;
  ButtonRect: TRect;
begin
  CalcButtonRect( ButtonRect );

  Canvas := TCanvas.Create;
  DC := GetWindowDC( FForm.Handle );
  try
    Canvas.Handle := DC;

    DrawButtonBackground( Canvas, ButtonRect );
    DrawButtonIcon( Canvas, ButtonRect );

  finally
    ReleaseDC( FForm.Handle, DC );
    Canvas.Free;
  end;
end;

procedure TCaptionButton.DrawButtonBackground(Canvas: TCanvas; const ButtonRect: TRect);
procedure DrawThemeBack;
  var
    ARect: TRect;
    Color1, Color2: TColor;
  begin
    ARect := ButtonRect;
    InflateRect( ARect, -2, -2 );

    Color1 := clInactiveCaption;
    if GetForegroundWindow = FForm.Handle then Color2 := clActiveCaption
                                          else Color2 := Color1;

    DrawGradient( Canvas, ARect,Color1, Color2, True );
  end;
procedure DrawTheme;
  const
    WP_MAXBUTTON = 17;
  var
    Themed: TThemedElementDetails;
  begin
    Themed := ThemeServices.GetElementDetails( twMaxButtonNormal );
    ThemeServices.DrawElement( Canvas.Handle, Themed, ButtonRect, nil );
  end;
procedure DrawIndirect;
  begin
    DrawFrameControl( Canvas.Handle, ButtonRect, DFC_BUTTON, DFCS_BUTTONPUSH );
  end;
begin
  case FDrawBack of
  0: if ThemeServices.ThemesEnabled then
      begin
        FDrawBack := 1;
        DrawTheme;
        DrawThemeBack;
      end
     else
      FDrawBack := 2;
  1: begin
       DrawTheme;
       DrawThemeBack;
     end;
  2: begin
       DrawIndirect;
     end;
  end;
end;

procedure TCaptionButton.DrawButtonIcon(Canvas: TCanvas; const ButtonRect: TRect);
begin
  if Assigned( OnDrawIcon ) then
   OnDrawIcon( Self, Canvas, ButtonRect );
end;

function TCaptionButton.CursorInButton: Boolean;
var
  ButtonRect: TRect;
  CursorPos: TPoint;
  WindowRect: TRect;
begin
  CalcButtonRect( ButtonRect );

  if GetCursorPos( CursorPos ) then
   begin
     GetWindowRect( FForm.Handle, WindowRect );

     Dec( CursorPos.X, WindowRect.Left );
     Dec( CursorPos.Y, WindowRect.Top );
     Result := PtInRect( ButtonRect, CursorPos );
   end
  else
   Result := False;
end;

function TCaptionButton.MinmizeButtonLeft: Integer;
begin
  if FMinmizeButtonLeft = 0 then FMinmizeButtonLeft := GetMinmizeButtonLeft( FForm.Handle );
  Result := FMinmizeButtonLeft; 
end;

procedure TCaptionButton.DoClick;
begin
  if Assigned( OnClick ) then OnClick( Self );
end;

procedure TCaptionButton.MenuPopup;
begin

end;

procedure CreateCaptionButton(Form: TForm; AOnClick: TNotifyEvent; AOnDrawIcon: TOnDrawIcon);
begin
  if CanCreateCaptionButton( Form ) then
   with TCaptionButton.Create( Form ) do
    begin
      OnClick := AOnClick;
      OnDrawIcon := AOnDrawIcon;
    end;
end;

end.
