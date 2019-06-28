unit UComboBox_ShowHint;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    ComboBox1: TComboBox;
    procedure ComboBox1DropDown(Sender: TObject);
    procedure ComboBox1CloseUp(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses Types;

{$R *.dfm}

const
  ComboBoxHintMaxWidth = 300;
  HintLineSpacing = 3;
  HintMargin = 3;
   
type

{ TComboBoxHint }

  TComboBoxHint = class(THintWindow)
  private
    procedure DrawText(const S: String; ARect: PRect);
  protected
    procedure Paint; override;
  public
    procedure Show(const Pos: TPoint; const S: String);
  end;

{ TComboBoxHintTimer }

  TComboBoxHintTimer = class(TTimer)
  protected
    ComboBox: TComboBox;
    HintWindow: TComboBoxHint;
    LastWnd: HWnd;
    LastIndex: Integer;
    procedure TimerEvent(Sender: TObject);
    procedure HideHint;
    function GetHintText(Index: Integer): String;
  public
    constructor Create(AOwner: TComponent); override;
    procedure CreateHint(AComboBox: TComboBox);
    procedure FreeHint;
  end;

{ TComboBoxHint }

procedure TComboBoxHint.Show(const Pos: TPoint; const S: String);
var
  ARect: TRect;
begin
  ARect.TopLeft := Pos;
  DrawText( S, @ARect );
  ActivateHint( ARect, S );
end;

procedure TComboBoxHint.Paint;
begin
  DrawText( Caption, nil );
end;

procedure TComboBoxHint.DrawText(const S: String; ARect: PRect);
var
  WS: WideString;
  i, L, T, W: Integer;
  MaxWidth, MaxHeight, LineWidth: Integer;
  TextHeight: Integer;
  Line: String;
procedure NewLine;
  begin
    if ARect = nil then
     Canvas.TextOut( L-1, T, Line );

    Inc( MaxHeight, TextHeight );
    Inc( MaxHeight, HintLineSpacing );
    Inc( T, TextHeight + HintLineSpacing );
    Line := '';
  end;
begin
  WS := S;
  TextHeight := Canvas.TextHeight( ' ' );
  W := 0;
  L := HintMargin;
  T := HintMargin;
  LineWidth := 0;
  MaxWidth := 0;
  MaxHeight := TextHeight;
  Line := '';

  for i := 1 to Length(WS) do
   case WS[i] of
   WideChar(#10): ;
   WideChar(#13): begin
                    NewLine;
                    LineWidth := 0;
                  end;
   else           begin
                    W := Canvas.TextWidth( WS[i] );
                    if W + LineWidth <= ComboBoxHintMaxWidth then
                     begin
                       Inc( LineWidth, W );
                       if LineWidth > MaxWidth then MaxWidth := LineWidth;
                       Line := Line + WS[i];
                     end
                    else
                     begin
                       NewLine;
                       LineWidth := W;
                       Line := WS[i];
                     end;
                  end;
   end;

  if ARect <> nil then
   begin
     ARect^.Right := ARect^.Left + HintMargin + MaxWidth + HintMargin;
     ARect^.Bottom := ARect^.Top + HintMargin + MaxHeight + HintMargin - 2;
   end
  else
   Canvas.TextOut( L-1, T, Line );
end;

{ TComboBoxHintTimer }

constructor TComboBoxHintTimer.Create(AOwner: TComponent);
begin
  inherited Create( AOwner );

  Enabled := False;
  Interval := 10;
  OnTimer := TimerEvent;
end;

procedure TComboBoxHintTimer.TimerEvent(Sender: TObject);
var
  PopupWnd: HWnd;
  MouseWnd: HWnd;
  HintRect: TRect;
  ComboBoxInfo: TComboBoxInfo;
  TopIndex, BottomIndex, SelIndex, CurrIndex: Integer;
  S: String;
begin
  ComboBoxInfo.cbSize := SizeOf(ComboBoxInfo);
  if GetComboBoxInfo( ComboBox.Handle, ComboBoxInfo ) then
   begin
     PopupWnd := ComboBoxInfo.hwndList;
     MouseWnd := WindowFromPoint( Mouse.CursorPos );
     if ( MouseWnd = PopupWnd ) and GetWindowRect( PopupWnd, HintRect ) then
      begin
        HintRect.Left := HintRect.Right;

        TopIndex := SendMessage( PopupWnd, LB_GETTOPINDEX, 0, 0 );
        SelIndex := SendMessage( PopupWnd, LB_GETCURSEL, 0, 0 );
        BottomIndex := TopIndex + ( HintRect.Bottom - HintRect.Top ) div ComboBox.ItemHeight;
        CurrIndex := SelIndex - TopIndex;

        if ( SelIndex >= 0 ) and ( SelIndex < BottomIndex ) then
         begin
           if ( LastWnd <> PopupWnd ) or ( LastIndex <> CurrIndex ) then
            begin
              LastWnd := PopupWnd;
              LastIndex := CurrIndex;

              S := GetHintText( TopIndex + CurrIndex );
              Inc( HintRect.Top, ComboBox.ItemHeight * CurrIndex );
              HintWindow.Show( HintRect.TopLeft, S );
            end;
           Exit;
         end;
      end;
   end;
  HideHint;
end;

procedure TComboBoxHintTimer.CreateHint(AComboBox: TComboBox);
begin
  ComboBox := AComboBox;

  HintWindow := TComboBoxHint.Create( nil );
  HintWindow.Color := clInfoBk;
  HintWindow.ScalingFlags := [sfDesignSize];

  Enabled := True;
end;

procedure TComboBoxHintTimer.FreeHint;
begin
  Enabled := False;
  if HintWindow <> nil then
   begin
     LastWnd := 0;
     LastIndex := -1;
     HintWindow.Free;
     HintWindow := nil;
   end;
end;

procedure TComboBoxHintTimer.HideHint;
begin
  if HintWindow <> nil then
   ShowWindow( HintWindow.Handle, SW_HIDE );
end;

function TComboBoxHintTimer.GetHintText(Index: Integer): String;
begin
  Result := ComboBox.Items[ Index ];
end;

var
  ComboBoxHintTimer: TComboBoxHintTimer;

procedure ShowComboBoxHint(ComboBox: TComboBox);
begin
  if ComboBoxHintTimer = nil then
   ComboBoxHintTimer := TComboBoxHintTimer.Create( nil );

  ComboBoxHintTimer.CreateHint( ComboBox );
end;

procedure CloseComboBoxHint;
begin
  ComboBoxHintTimer.FreeHint;
end;


procedure TForm1.ComboBox1DropDown(Sender: TObject);
begin
  ShowComboBoxHint( TComboBox(Sender) );
end;

procedure TForm1.ComboBox1CloseUp(Sender: TObject);
begin
  CloseComboBoxHint;
end;

end.
