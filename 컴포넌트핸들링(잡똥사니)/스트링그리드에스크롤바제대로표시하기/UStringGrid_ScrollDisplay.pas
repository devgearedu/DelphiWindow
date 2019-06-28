unit UStringGrid_ScrollDisplay;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls;

type

{ TStringGrid } 

  TScrollBarInfo = record
    Enabled: Boolean;
    Full: Integer;
    Page: Integer;
    Pos: Integer;
  end;

  TStringGrid = class(Grids.TStringGrid)
  private
    FScrollBars: TScrollStyle;
    FHorz: TScrollBarInfo;
    FVert: TScrollBarInfo;
    function GetScrollBars: TScrollStyle;
    procedure SetScrollBars(const Value: TScrollStyle);
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure WMHScroll(var Message: TWMHScroll); message WM_HSCROLL;
    procedure WMVScroll(var Message: TWMVScroll); message WM_VSCROLL;
  protected
    procedure CreateWnd; override;
    procedure TopLeftChanged; override;
    procedure InitScrollBar;
    procedure SetScrollBar;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property ScrollBars: TScrollStyle read GetScrollBars write SetScrollBars;
  end;

{ TForm1 }

  TForm1 = class(TForm)
    StringGrid1: TStringGrid;
    procedure StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure FormShow(Sender: TObject);
  private
  public
  end;

var
  Form1: TForm1;

implementation



{$R *.dfm}

uses UMain;

{ TStringGrid }

constructor TStringGrid.Create(AOwner: TComponent);
begin
  inherited Create( AOwner );

  inherited ScrollBars := ssNone;
  FScrollBars := ssBoth;
end;

procedure TStringGrid.CreateWnd;
begin
  inherited CreateWnd;

  InitScrollBar;
end;

procedure TStringGrid.TopLeftChanged;
function TopRowToPos: Integer;
  var
    i: Integer;
  begin
    Result := 0;
    for i := 0 to TopRow - 1 do
     Inc( Result, RowHeights[ i ] );
  end;
function LeftColToPos: Integer;
  var
    i: Integer;
  begin
    Result := 0;
    for i := 0 to LeftCol - 1 do
     Inc( Result, ColWidths[ i ] );
  end;
begin
  inherited;

  FHorz.Pos := LeftColToPos;
  FVert.Pos := TopRowToPos;

  SetScrollPos( Handle, SB_HORZ, FHorz.Pos, True );
  SetScrollPos( Handle, SB_VERT, FVert.Pos, True );
end;

function TStringGrid.GetScrollBars: TScrollStyle;
begin
  Result := inherited ScrollBars;
end;

procedure TStringGrid.SetScrollBars(const Value: TScrollStyle);
begin
  inherited ScrollBars := ssNone;

  FScrollBars := Value;
  InitScrollBar;
end;

procedure TStringGrid.InitScrollBar;
function GetVScrollPos: Integer;
  var
    i: Integer;
  begin
    Result := 0;
    for i := 0 to TopRow - 1 do
     Inc( Result, RowHeights[ i ] );
  end;
function GetHScrollPos: Integer;
  var
    i: Integer;
  begin
    Result := 0;
    for i := 0 to LeftCol - 1 do
     Inc( Result, ColWidths[ i ] );
  end;
var
  i: Integer;
begin
  FVert.Full := 0;
  FVert.Page := 0;

  for i := 0 to RowCount - 1 do
   Inc( FVert.Full, RowHeights[ i ] );

  for i := TopRow to RowCount - 1 do
   Inc( FVert.Page, RowHeights[ i ] );

  if FVert.Page > ClientHeight then
   FVert.Page := ClientHeight;

  FVert.Pos := GetVScrollPos;


  FHorz.Full := 0;
  FHorz.Page := 0;

  for i := 0 to ColCount - 1 do
   Inc( FHorz.Full, ColWidths[ i ] );

  for i := LeftCol to ColCount - 1 do
   Inc( FHorz.Page, ColWidths[ i ] );

  if FHorz.Page > ClientWidth then
   FHorz.Page := ClientWidth;

  SetScrollBar;
end;

procedure TStringGrid.SetScrollBar;
procedure DoSetScrollBar(ScrollBar, Page, Pos, Max: Integer; Enabled: Boolean);
  const
    E: array[Boolean] of Integer = (ESB_DISABLE_BOTH, ESB_ENABLE_BOTH);
  var
    ScrollInfo: TScrollInfo;
  begin
     ScrollInfo.cbSize := SizeOf( ScrollInfo );
     ScrollInfo.fMask := SIF_POS or SIF_PAGE or SIF_RANGE;
     ScrollInfo.nPage := Page;
     ScrollInfo.nPos := Pos;
     ScrollInfo.nMin := 0;
     ScrollInfo.nMax := Max;

     SetScrollInfo( Handle, ScrollBar, ScrollInfo, True );
     EnableScrollBar( Handle, ScrollBar, E[ Enabled ] );
  end;
begin
  FVert.Enabled := ( ClientHeight < FVert.Full ) and ( FScrollBars >= ssVertical );
  if FVert.Enabled then DoSetScrollBar( SB_VERT, FVert.Page, FVert.Pos, FVert.Full - ClientHeight + FVert.Page, True )
                   else DoSetScrollBar( SB_VERT, 0, 0, 100, False );

  FHorz.Enabled := ( ClientWidth < FHorz.Full ) and ( Integer( FScrollBars ) mod 2 = 1 );
  if FHorz.Enabled then DoSetScrollBar( SB_HORZ, FHorz.Page, FHorz.Pos, FHorz.Full - ClientWidth + FHorz.Page, True )
                   else DoSetScrollBar( SB_HORZ, 0, 0, 100, False );
end;

procedure TStringGrid.WMSize(var Message: TWMSize);
begin
  inherited;

  InitScrollBar;
end;

procedure TStringGrid.WMHScroll(var Message: TWMHScroll);
function GetNewScrollPos: Integer;
  var
    ScrollInfo: TScrollInfo;
  begin
    ScrollInfo.cbSize := SizeOf( ScrollInfo );
    ScrollInfo.fMask := SIF_TRACKPOS;
    Windows.GetScrollInfo( Handle, SB_HORZ, ScrollInfo );
    Result := ScrollInfo.nTrackPos;
  end;
function PosToLeftCol(ScrollPos: Integer): Integer;
  var
    i, W: Integer;
  begin
    if ScrollPos >= ( FHorz.Full - FHorz.Page ) - 5 then
     begin
       Result := -1;
       Exit;
     end;

    Result := 0;
    W := 0;
    for i := 0 to ColCount - 1 do
     if W + ColWidths[ i ] > ScrollPos then
      begin
        if ScrollPos - W < ColWidths[ i ] div 2 then Result := i
                                                else Result := i + 1;

        Break;
      end
     else
      Inc( W, ColWidths[ i ] );
  end;
procedure ApplyScrollPos;
  var
    NewLeftCol: Integer;
  begin
    FHorz.Pos := GetNewScrollPos;
    NewLeftCol := PosToLeftCol( FHorz.Pos );

    if NewLeftCol = - 1 then
     begin
       Message.ScrollCode := SB_RIGHT;
       inherited;
     end
    else
     LeftCol := NewLeftCol;
  end;
begin
  if not FHorz.Enabled then Exit;

  case Message.ScrollCode of
  SB_LINELEFT,
  SB_LINERIGHT,
  SB_PAGELEFT,
  SB_PAGERIGHT,
  SB_LEFT,
  SB_RIGHT,
  SB_THUMBPOSITION: begin
                      if not ( goThumbTracking in Options ) then ApplyScrollPos;
                    end;
  SB_THUMBTRACK   : begin
                      if goThumbTracking in Options then ApplyScrollPos;
                    end;
  SB_ENDSCROLL    : ;
  end;
end;

procedure TStringGrid.WMVScroll(var Message: TWMVScroll);
function GetNewScrollPos: Integer;
  var
    ScrollInfo: TScrollInfo;
  begin
    ScrollInfo.cbSize := SizeOf( ScrollInfo );
    ScrollInfo.fMask := SIF_TRACKPOS;
    Windows.GetScrollInfo( Handle, SB_VERT, ScrollInfo );
    Result := ScrollInfo.nTrackPos;
  end;
function PosToRow(ScrollPos: Integer): Integer;
  var
    i, H: Integer;
  begin
    if ScrollPos >= ( FVert.Full - FVert.Page ) - 5 then
     begin
       Result := -1;
       Exit;
     end;

    Result := 0;
    H := 0;
    for i := 0 to RowCount - 1 do
     if H + RowHeights[ i ] > ScrollPos then
      begin
        if ScrollPos - H < RowHeights[ i ] div 2 then Result := i
                                                 else Result := i + 1;

        Break;
      end
     else
      Inc( H, RowHeights[ i ] );
  end;
procedure ApplyScrollPos;
  var
    NewTopRow: Integer;
  begin
    FVert.Pos := GetNewScrollPos;
    NewTopRow := PosToRow( FVert.Pos );

    if NewTopRow = - 1 then
     begin
       Message.ScrollCode := SB_BOTTOM;
       inherited;
     end
    else
     TopRow := NewTopRow;
  end;
begin
  if not FVert.Enabled then Exit;

  case Message.ScrollCode of
  SB_LINEUP,
  SB_LINEDOWN,
  SB_PAGEUP,
  SB_PAGEDOWN,
  SB_TOP,
  SB_BOTTOM       : begin
                      inherited;
                    end;
  SB_THUMBPOSITION: begin
                      if not ( goThumbTracking in Options ) then ApplyScrollPos;
                    end;
  SB_THUMBTRACK   : begin
                      if goThumbTracking in Options then ApplyScrollPos;
                    end;
  SB_ENDSCROLL    : ;
  end;
end;

{ TForm1 }

procedure TForm1.StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  Grid: TDrawGrid absolute Sender;
begin
  if gdSelected in State then
   begin
     Grid.Canvas.Brush.Color := clHighlight;
     Grid.Canvas.Font.Color := clHighlightText;
   end
  else
   begin
     Grid.Canvas.Brush.Color := Grid.Color;
     Grid.Canvas.Font.Color := Grid.Font.Color;
   end;

  Grid.Canvas.FillRect( Rect );
  Grid.Canvas.TextOut( Rect.Left + 2, Rect.Top + 2, Format( '%D - %D', [ACol, ARow] ) );
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  with TForm2.Create( nil ) do
   try
     ShowModal;
   finally
     Free;
   end;
end;

end.
