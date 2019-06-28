unit MsgBox;

interface

function MessageBox(const AText, ACaption: String; const AButtonCaptions: array of String; ADefault: Integer = -1): Integer;

implementation

uses
  Windows, Classes, Controls, Graphics, StdCtrls, ExtCtrls, Forms, ClipBrd;

type
  TMsgBox = class(TForm)
  private
    FClickIndex: Integer;
    procedure MsgBoxKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ButtonClick(Sender: TObject);
    function GetFormText: String;
  public
    constructor Create(AOwner: TComponent); override;
    procedure CreateControls(const AText, ACaption: String; const AButtonCaptions: array of String; ADefault: Integer = -1);
    property ClickIndex: Integer read FClickIndex;
  end;

function MessageBox(const AText, ACaption: String; const AButtonCaptions: array of String; ADefault: Integer = -1): Integer;
begin
  with TMsgBox.Create( nil ) do
   try
     CreateControls( AText, ACaption, AButtonCaptions, ADefault );

     ShowModal;
     Result := ClickIndex;
   finally
     Free;
   end;
end;

{ TMsgBox }

constructor TMsgBox.Create(AOwner: TComponent);
begin
  CreateNew( AOwner, 0 );

  FClickIndex := -1;
  Position := poScreenCenter;
  BorderStyle := bsDialog;
  Font.Name := '±¼¸²';
  Font.Charset := HANGEUL_CHARSET;
  Font.Size := 9;
  Font.Style := [];
  KeyPreview := True;

  OnKeyDown := MsgBoxKeyDown;

  MessageBeep( MB_ICONINFORMATION ); 
end;

procedure TMsgBox.MsgBoxKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
  VK_ESCAPE  : begin
                 Close;
               end;
  Byte( 'C' ): begin
                 if Shift = [ssCtrl] then
                  begin
                    Clipboard.AsText := GetFormText;
                    MessageBeep( 0 );
                  end;
               end;
  end;
end;

procedure TMsgBox.ButtonClick(Sender: TObject);
begin
  Close;
  FClickIndex := TButton( Sender ).Tag;
end;

function TMsgBox.GetFormText: String;
function GetLabelCaption: String;
  var
    ALabel: TLabel;
  begin
    ALabel := TLabel( FindComponent( 'Label' ) );

    if ALabel <> nil then Result := ALabel.Caption
                     else Result := '';

  end;
function GetButtonsCaption: String;
  var
    i: Integer;
  begin
    Result := '';

    for i := 0 to ComponentCount - 1 do
     if Components[ i ] is TButton then
      begin
        if Result <> '' then Result := Result + '   ';
        Result := Result + TButton( Components[ i ] ).Caption;
      end;
  end;
begin
  Result := '---------------------------'#13#10 +
            Caption + #13#10 +
            '---------------------------'#13#10 +
            GetLabelCaption + #13#10 +
            '---------------------------'#13#10 +
            GetButtonsCaption + #13#10 +
            '---------------------------';
end;

function GetAveCharSize(Canvas: TCanvas): TPoint;
var
  I: Integer;
  Buffer: array[0..51] of Char;
begin
  for I := 0 to 25 do Buffer[I] := Chr(I + Ord('A'));
  for I := 0 to 25 do Buffer[I + 26] := Chr(I + Ord('a'));
  GetTextExtentPoint(Canvas.Handle, Buffer, 52, TSize(Result));
  Result.X := Result.X div 52;
end;

function CalcLabeSize(const S: String): TSize;
var
  ARect: TRect;
  Canvas: TCanvas;
begin
  Canvas := TCanvas.Create;
  try
    Canvas.Handle := GetDC( 0 );

    Canvas.Font.Name := '±¼¸²';
    Canvas.Font.Charset := HANGEUL_CHARSET;
    Canvas.Font.Size := 9;
    Canvas.Font.Style := [];

    ZeroMemory( @ARect, SizeOf( ARect ) );
    ARect.Right := 450;

    DrawText( Canvas.Handle, PChar( S ), Length( S ), ARect, DT_LEFT or DT_END_ELLIPSIS or DT_CALCRECT );

    Result.cx := ARect.Right;
    Result.cy := ARect.Bottom;

    ReleaseDC( 0, Canvas.Handle );
  finally
    Canvas.Free;
  end;
end;

function GetTextWidth(const S: String; const Font: TFont): Integer;
var
  Canvas: TCanvas;
begin
  Canvas := TCanvas.Create;
  try
    Canvas.Handle := GetDC( 0 );
    Canvas.Font.Assign( Font );

    Result := Canvas.TextWidth( S );

    ReleaseDC( 0, Canvas.Handle );
  finally
    Canvas.Free;
  end;
end;

procedure TMsgBox.CreateControls(const AText, ACaption: String; const AButtonCaptions: array of String; ADefault: Integer = -1);
const
  IconLeft = 14;
  IconTop = 12;
  LabelLeft = 70;
  ButtonWidth = 80;
  ButtonHeight = 24;
  ButtonSpace = 10;
var
  LabelSize: TSize;
  MinWidth: Integer;
  LabelTop: Integer;
  ButtonsTop: Integer;
  ButtonsWidth: Integer;
  ButtonsCount: Integer;
  i, W, L: Integer;
  DefaultButton: String;
  TabOrder: Integer;
begin
  MinWidth := 100;

  
 {Icon}

  with TImage.Create( Self ) do
   begin
     Name := 'Image';
     Parent := Self;
     Picture.Icon.Handle := LoadIcon( 0, IDI_INFORMATION );
     SetBounds( IconLeft, IconTop, 32, 32 );
     AutoSize := True;
   end;


 {Label}

  LabelSize := CalcLabeSize( AText );
  with TLabel.Create( Self ) do
   begin
     Name := 'Label';
     Parent := Self;
     Caption := AText;

     if LabelSize.cy > 24 then LabelTop := 10 else
     if LabelSize.cy > 20 then LabelTop := 15
                          else LabelTop := 20;

     SetBounds( LabelLeft, LabelTop, LabelSize.cx, LabelSize.cy );

     if Left + LabelSize.cx > MinWidth then
      MinWidth := Left + LabelSize.cx + 32;

     ButtonsTop := Top + LabelSize.cy + 32;
   end;


  {Buttons}
   
   ButtonsWidth := 0;
   ButtonsCount := 0;
   DefaultButton := '';
   for i := Low( AButtonCaptions ) to High( AButtonCaptions ) do
    with TButton.Create( Self ) do
     begin
       Parent := Self;
       Caption := AButtonCaptions[ i ];
       Default := i = ADefault;
       Tag := i;
       Top := ButtonsTop;
       Height := ButtonHeight;
       OnClick := ButtonClick;

       if i = ADefault then
        DefaultButton := Caption;

       W := GetTextWidth( Caption, Font ) + 20;
       if W <= ButtonWidth then Width := ButtonWidth
                           else Width := W;

       Inc( ButtonsWidth, Width );
       Inc( ButtonsCount );
     end;

  Inc( ButtonsWidth, ( ButtonsCount - 1 ) * ButtonSpace );



 {Form}  

  Caption := ACaption;

  W := ButtonsWidth + 32;
  if W > MinWidth then
   MinWidth := W;

  ClientWidth := MinWidth;
  ClientHeight := ButtonsTop + ButtonHeight + 16;



 {Buttons Left, TagOrder}
  
  L := ( ClientWidth - ButtonsWidth ) div 2;
  TabOrder := 0;

  for i := 0 to ComponentCount - 1 do
   if Components[ i ] is TButton then
    begin
      TControl( Components[ i ] ).Left := L;
      Inc( L, TControl( Components[ i ] ).Width );
      Inc( L, ButtonSpace );

      if ( TButton( Components[ i ] ).Caption = DefaultButton ) or ( TabOrder > 0 ) then
       begin
         TButton( Components[ i ] ).TabOrder := TabOrder;
         Inc( TabOrder );
       end;
    end;

  for i := 0 to ComponentCount - 1 do
   if Components[ i ] is TButton then
    begin
      if TButton( Components[ i ] ).Caption = DefaultButton then Break;

      TButton( Components[ i ] ).TabOrder := TabOrder;
      Inc( TabOrder );
    end;
end;

end.
