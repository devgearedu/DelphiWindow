unit Main_Frm;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Graphics, Forms, StdCtrls, ActnList, ComCtrls, Registry,
  ExtCtrls, Buttons, ToolWin;

const
  WindowWidth = 526;

type

{ TMemo }

  TMemo = class(StdCtrls.TMemo)
  private
    procedure WMPaste(var Message: TWMPaste); message WM_PASTE;
  public
    constructor Create(AOwner: TComponent); override;
  end;

{ TMain_Form }

  TMain_Form = class(TForm)
    Memo: TMemo;
    ActionList: TActionList;
    ActionSelectAll: TAction;
    StatusBar: TStatusBar;
    Panel: TPanel;
    PaintBox_Left: TPaintBox;
    PaintBox_Top: TPaintBox;
    CoolBar: TCoolBar;
    Button_7: TSpeedButton;
    Button_Backspace: TSpeedButton;
    Button_Clear: TSpeedButton;
    Button_8: TSpeedButton;
    Button_9: TSpeedButton;
    Button_6: TSpeedButton;
    Button_5: TSpeedButton;
    Button_4: TSpeedButton;
    Button_3: TSpeedButton;
    Button_2: TSpeedButton;
    Button_1: TSpeedButton;
    Button_Dot: TSpeedButton;
    Button_0: TSpeedButton;
    Button_Division: TSpeedButton;
    Button_Multiplication: TSpeedButton;
    Button_Minus: TSpeedButton;
    Button_Plus: TSpeedButton;
    Button_Calc: TSpeedButton;
    Button_Sin: TSpeedButton;
    Button_Cos: TSpeedButton;
    Button_Tan: TSpeedButton;
    Button_Pi: TSpeedButton;
    Button_OpenFence: TSpeedButton;
    Button_CloseFence: TSpeedButton;
    Button_Help: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ApplicationException(Sender: TObject; E: Exception);
    procedure ActionSelectAllExecute(Sender: TObject);
    procedure MemoChange(Sender: TObject);
    procedure MemoKeyPress(Sender: TObject; var Key: Char);
    procedure Button_Click(Sender: TObject);
    procedure Button_FunctionClick(Sender: TObject);
    procedure Button_BackspaceClick(Sender: TObject);
    procedure Button_ClearClick(Sender: TObject);
    procedure Button_CalcClick(Sender: TObject);
    procedure Button_HelpClick(Sender: TObject);
    procedure CaptionButtonClick(Sender: TObject);
    procedure CaptionButtonDrawIcon(Sender: TObject; Canvas: TCanvas; const ButtonRect: TRect);
  private
    procedure WMNCHitTest(var Message: TWMNCHitTest); message WM_NCHITTEST;
    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure PaintShadow(DC: HDC);
    procedure ReadConfig;
    procedure WriteConfig;
    procedure Calc;
  public
  end;

var
  Main_Form: TMain_Form;

implementation

uses
  ClipBrd, Themes, Parser, Help_Frm, CaptionButtons, Types;

{$R *.dfm}
{$R WindowsXP.res}

function CreateIni: TRegIniFile;
begin
  Result := TRegIniFile.Create( 'Software\계산기다!001\' );
end;

procedure KeyIn(Wnd: HWnd; Key: Byte);
begin
  SendMessage( Wnd, WM_CHAR, Key, 0 );
end;

var
  LeftShadow: TBitmap;
  TopShadow: TBitmap;

{ TMemo }

procedure SetFontSntialias(Font: TFont);
var
  LogFont: TLogFont;
begin
  GetObject( Font.Handle, SizeOf(TLogFont), @LogFont );

  if Abs( LogFont.lfHeight ) >= 18 then LogFont.lfQuality := ANTIALIASED_QUALITY
                                   else LogFont.lfQuality := 5;

  Font.Handle := CreateFontIndirect( LogFont );
end;

constructor TMemo.Create(AOwner: TComponent);
begin
  inherited Create( AOwner );

  SetFontSntialias( Font );
end;

procedure TMemo.WMPaste(var Message: TWMPaste);
begin
  SelText := StringReplace( Clipboard.AsText, ',', '', [rfReplaceAll] );
end;

{ TMain_Form }

procedure TMain_Form.PaintShadow(DC: HDC);
var
  Brush: HBRUSH;
  ScrollWidth: Integer;
begin
  ScrollWidth := GetSystemMetrics( SM_CXVSCROLL );

  BitBlt( DC, 0, 0, ClientWidth - ScrollWidth, TopShadow.Height, TopShadow.Canvas.Handle, 0, 0, SRCCOPY );
  BitBlt( DC, 0, 8, LeftShadow.Width, LeftShadow.Height, LeftShadow.Canvas.Handle, 0, 0, SRCCOPY );

  Brush := CreateSolidBrush( ColorToRGB( clBtnFace ) );
  FillRect( DC, Rect( ClientWidth - ScrollWidth, 0, ClientWidth, 8 ), Brush );
  DeleteObject( Brush );
end;

procedure TMain_Form.ReadConfig;
var
  L, T, W, H: Integer;
  B: Boolean;
begin
  W := Width;
  H := 140;
  L := ( Screen.Width - Width ) div 2;
  T := ( Screen.Height - Height ) div 2;

  with CreateIni do
   try
     L := ReadInteger( 'Window', 'Left', L );
     T := ReadInteger( 'Window', 'Top', T );
     W := ReadInteger( 'Window', 'Width', W );
     H := ReadInteger( 'Window', 'Height', H );
     B := ReadBool( 'Window', 'VisibleButtons', False );
   finally
     Free;
   end;

  if L < Screen.DesktopLeft then L := Screen.DesktopLeft else
  if T < Screen.DesktopTop then T := Screen.DesktopTop else
  if L > Screen.DesktopLeft + Screen.DesktopWidth then L := Screen.DesktopLeft + Screen.DesktopWidth - Width else
  if T > Screen.DesktopTop + Screen.DesktopHeight then T := Screen.DesktopTop + Screen.DesktopHeight - Height;

  SetBounds( L, T, W, H );

  if not B then
   begin
     Memo.Align := alNone;
     Panel.Visible := False;
     Memo.Align := alClient;
   end;
end;

procedure TMain_Form.WriteConfig;
begin
  with CreateIni do
   try
     WriteInteger( 'Window', 'Left', Left );
     WriteInteger( 'Window', 'Top', Top );
     WriteInteger( 'Window', 'Width', Width );
     WriteInteger( 'Window', 'Height', Height );
     WriteBool( 'Window', 'VisibleButtons', Panel.Visible );
   finally
     Free;
   end;
end;

procedure TMain_Form.Calc;
var
  Parser: TParser;
  Source: String;
  CalcResult: String;
procedure GetSource;
  var
    PosResult: Integer;
  begin
    Source := TrimRight( Memo.Text );

    PosResult := LastDelimiter( '=', Source );
    if PosResult > 0 then
     Delete( Source, PosResult, Length( Source ) );
  end;
begin
  Parser := TParser.Create;
  Memo.Lines.BeginUpdate;
  try

    GetSource;

    if Parser.Parse( Source ) then
     begin
       CalcResult := FloatToStr( Parser.Value );;

       Memo.SelStart := Length( Source );
       Memo.SelLength := High( Integer );

       Memo.SelText := '=' + CalcResult;

       Memo.SelStart := Memo.SelStart - Length( CalcResult );
       Memo.SelLength := Length( CalcResult );

       StatusBar.SimpleText := '계산 완료!';
     end
    else
     begin
       Beep;

       Memo.SelStart := Parser.ErrorPos;
       Memo.SelLength := 1;

       StatusBar.SimpleText := '오류! ' + IntToStr( Parser.ErrorPos + 1 ) + '번째 문자';
     end;

  finally
    Memo.Lines.EndUpdate;
    Parser.Free;
  end;
end;

procedure TMain_Form.FormCreate(Sender: TObject);
begin
  Application.OnException := ApplicationException;

  Width := WindowWidth;

  DoubleBuffered := False;
  Panel.ParentBackground := False;
  PaintBox_Top.Height := TopShadow.Height;
  PaintBox_Left.Width := LeftShadow.Width;
  Constraints.MaxWidth := WindowWidth;
  Constraints.MinWidth := WindowWidth;

  SetFontSntialias( Memo.Font );

  CreateCaptionButton( Self, CaptionButtonClick, CaptionButtonDrawIcon );
end;

procedure TMain_Form.FormShow(Sender: TObject);
begin
  ReadConfig;
end;

procedure TMain_Form.FormPaint(Sender: TObject);
begin
  PaintShadow( Canvas.Handle );
end;

procedure TMain_Form.FormDestroy(Sender: TObject);
begin
  WriteConfig;
end;

procedure TMain_Form.ApplicationException(Sender: TObject; E: Exception);
begin
  if E.ClassType = EZeroDivide then
   begin
     MessageBeep( MB_ICONHAND );
     StatusBar.SimpleText := '0으로 나눌 수 없습니다.';
   end;
end;

procedure TMain_Form.ActionSelectAllExecute(Sender: TObject);
begin
  Memo.SelectAll;
end;

procedure TMain_Form.MemoChange(Sender: TObject);
begin
  StatusBar.SimpleText := '';
end;

procedure TMain_Form.MemoKeyPress(Sender: TObject; var Key: Char);
begin
  case Key of
  #13: begin
         Key := #0;

         Calc;
       end;
  #27: begin
         Memo.Clear;
       end;
  end;
end;

procedure TMain_Form.WMNCHitTest(var Message: TWMNCHitTest);
begin
  inherited;

  case Message.Result of
  HTLEFT,
  HTRIGHT      : Message.Result := 0;
  HTBOTTOMLEFT,
  HTBOTTOMRIGHT: Message.Result := HTBOTTOM;
  HTTOPLEFT,
  HTTOPRIGHT   : Message.Result := HTTOP;
  end;

end;

procedure TMain_Form.WMEraseBkgnd(var Message: TWMEraseBkgnd);
begin
  PaintShadow( Message.DC );
end;

procedure TMain_Form.Button_Click(Sender: TObject);
begin
  Memo.SelText := TSpeedButton(Sender).Caption;
end;

procedure TMain_Form.Button_FunctionClick(Sender: TObject);
begin
  Memo.SelText := TSpeedButton(Sender).Caption + '()';
  Memo.SelStart := Memo.SelStart - 1;
end;

procedure TMain_Form.Button_BackspaceClick(Sender: TObject);
begin
  KeyIn( Memo.Handle, VK_BACK );
end;

procedure TMain_Form.Button_ClearClick(Sender: TObject);
begin
  Memo.Clear;
end;

procedure TMain_Form.Button_CalcClick(Sender: TObject);
begin
  Calc;
end;

procedure TMain_Form.Button_HelpClick(Sender: TObject);
begin
  if Help_Form = nil then
   Help_Form := THelp_Form.Create( nil );
  Help_Form.Show;  
end;


procedure TMain_Form.CaptionButtonClick(Sender: TObject);
begin
  if Panel.Visible then
   begin
     Memo.Align := alNone;
     Panel.Visible := False;
     Height := Height - Panel.Height;
     Memo.Align := alClient;
   end
  else
   begin
     Memo.Align := alNone;
     Height := Height + Panel.Height;
     Panel.Top := Memo.Top + Memo.Height;
     StatusBar.Top := Panel.Top + Panel.Height;
     Panel.Visible := True;
     Memo.Align := alClient;
   end;
end;

procedure TMain_Form.CaptionButtonDrawIcon(Sender: TObject; Canvas: TCanvas; const ButtonRect: TRect);
const
  ButtonWidth = 3;
var
  ARect: TRect;
begin
  ARect.Left := ButtonRect.Left + ButtonWidth;
  ARect.Bottom := ButtonRect.Bottom - ButtonWidth * 2 + 1;
  ARect.Right := ARect.Left + ButtonWidth - 1;
  ARect.Top := ARect.Bottom + ButtonWidth - 1;

  if ThemeServices.ThemesEnabled then Canvas.Brush.Color := clCaptionText
                                 else Canvas.Brush.Color := clWindowText;

  Canvas.FillRect( ARect );

  Dec( ARect.Top, ButtonWidth );
  Dec( ARect.Bottom, ButtonWidth );
  Canvas.FillRect( ARect );

  Dec( ARect.Top, ButtonWidth );
  Dec( ARect.Bottom, ButtonWidth );
  Canvas.FillRect( ARect );

  Inc( ARect.Left, ButtonWidth );
  Inc( ARect.Right, ButtonWidth );
  Canvas.FillRect( ARect );

  Inc( ARect.Top, ButtonWidth );
  Inc( ARect.Bottom, ButtonWidth );
  Canvas.FillRect( ARect );

  Inc( ARect.Top, ButtonWidth );
  Inc( ARect.Bottom, ButtonWidth );
  Canvas.FillRect( ARect );

  Inc( ARect.Left, ButtonWidth );
  Inc( ARect.Right, ButtonWidth );
  Canvas.FillRect( ARect );

  Dec( ARect.Top, ButtonWidth );
  Dec( ARect.Bottom, ButtonWidth );
  Canvas.FillRect( ARect );

  Dec( ARect.Top, ButtonWidth );
  Dec( ARect.Bottom, ButtonWidth );
  Canvas.FillRect( ARect );
end;

initialization
begin
  LeftShadow := TBitmap.Create;
  LeftShadow.Handle := LoadBitmap( HInstance, 'LeftShadow' );

  TopShadow := TBitmap.Create;
  TopShadow.Handle := LoadBitmap( HInstance, 'TopShadow' );
  TopShadow.Canvas.Brush.Color := clBtnFace;
end;

finalization
begin
  LeftShadow.Free;
  TopShadow.Free;
end;

end.
