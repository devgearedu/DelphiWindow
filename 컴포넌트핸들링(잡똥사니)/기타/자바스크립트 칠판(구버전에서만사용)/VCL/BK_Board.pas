unit BK_Board;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

const
  clBoard = $00404000;
  GrapWidth = 7;
  GrapCursors : array[0..7] of TCursor = (crCross, crSizeNS, crCross, crSizeWE, crCross, crSizeNS, crCross, crSizeWE);
  msMove = True;
  msSize = False;

type

  TCustomBoard = class;
  TBoardGraps = class;
  TDrawTool = (dtNone, dtSelect, dtLine, dtRectangle, dtRoundRect, dtEllipse, dtText);

{ TBoardItem }

  TBoardItem = class
  private
    FOwner: TCustomBoard;
    FLeft: Integer;
    FTop: Integer;
    FRight: Integer;
    FBottom: Integer;
    FPenColor: TColor;
    procedure SetPenColor(Value: TColor);
    procedure SetLeft(Value: Integer);
    procedure SetTop(Value: Integer);
    procedure SetRight(Value: Integer);
    procedure SetBottom(Value: Integer);
  protected
    procedure Paint(Canvas: TCanvas; Mask: Boolean); virtual;
    procedure Redraw;
    function GetDrawTool: TDrawTool; virtual;
    function PtInItem(Point: TPoint): Boolean; virtual;
    function PtInItemWithBitmap(Point: TPoint): Boolean;
  public
    procedure SetBounds(Left, Top, Right, Bottom: Integer);
    property DrawTool: TDrawTool read GetDrawTool;
    property Owner: TCustomBoard read FOwner write FOwner;
    property Left: Integer read FLeft write SetLeft;
    property Top: Integer read FTop write SetTop;
    property Right: Integer read FRight write SetRight;
    property Bottom: Integer read FBottom write SetBottom;
    property PenColor: TColor read FPenColor write SetPenColor;
  end;

{ TBoardLine }

  TBoardLine = class(TBoardItem)
  private
  public
    procedure Paint(Canvas: TCanvas; Mask: Boolean); override;
    function GetDrawTool: TDrawTool; override;
  end;

{ TBoardRectangle }

  TBoardRectangle = class(TBoardLine)
  private
  public
    procedure Paint(Canvas: TCanvas; Mask: Boolean); override;
    function GetDrawTool: TDrawTool; override;
  end;

{ TBoardRoundRect }

  TBoardRoundRect = class(TBoardRectangle)
  private
    FRoundWidth: Integer;
    FRoundHeight: Integer;
    procedure SetRoundWidth(Value: Integer);
    procedure SetRoundHeight(Value: Integer);
  public
    procedure Paint(Canvas: TCanvas; Mask: Boolean); override;
    function GetDrawTool: TDrawTool; override;
    property RoundWidth: Integer read FRoundWidth write SetRoundWidth;
    property RoundHeight: Integer read FRoundHeight write SetRoundHeight;
  end;

{ TBoardEllipse }

  TBoardEllipse = class(TBoardRectangle)
  public
    procedure Paint(Canvas: TCanvas; Mask: Boolean); override;
    function GetDrawTool: TDrawTool; override;
  end;

{ TBoardText }

  TBoardText = class(TBoardItem)
  private
    FFontName: String;
    FFontSize: Integer;
    FFontColor: TColor;
    FLineInterval: Integer;
    FStrings: TStringList;
    function GetRight: Integer;
    function GetBottom: Integer;
    procedure SetFontName(const Value: String);
    procedure SetFontSize(Value: Integer);
    procedure SetFontColor(Value: TColor);
    procedure SetLineInterval(Value: Integer);
    procedure SetStrings(Value: TStringList);
    procedure StringsChange(Sender: TObject);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Paint(Canvas: TCanvas; Mask: Boolean); override;
    function GetDrawTool: TDrawTool; override;
    property FontName: String read FFontName write SetFontName;
    property FontSize: Integer read FFontSize write SetFontSize;
    property FontColor: TColor read FFontColor write SetFontColor;
    property LineInterval: Integer read FLineInterval write SetLineInterval;
    property Lines: TStringList read FStrings write SetStrings;
    property Right: Integer read GetRight;
    property Bottom: Integer read GetBottom;
  end;

{ TBoardItems }

  TBoardItems = class
  private
    FOwner: TCustomBoard;
    FList: TList;
    FUpdateCount: Integer;
    function GetItem(Index: Integer): TBoardItem;
    procedure Redraw;
  public
    constructor Create(AOwner: TCustomBoard);
    destructor Destroy; override;
    function Count: Integer;
    procedure Add(Item: TBoardItem);
    procedure Clear;
    procedure Delete(Index: Integer);
    procedure Move(FromIndex, ToIndex: Integer);
    procedure Exchange(Index1, Index2: Integer);
    procedure BeginUpdate;
    procedure EndUpdate;
    procedure AddLine(ALeft, ATop, ARight, ABottom, APenColor: TColor);
    procedure AddRectangle(ALeft, ATop, ARight, ABottom, APenColor: TColor);
    procedure AddRoundRect(ALeft, ATop, ARight, ABottom, APenColor: TColor; ARoundWidth, ARoundHeight: Integer);
    procedure AddEllipse(ALeft, ATop, ARight, ABottom, APenColor: TColor);
    procedure AddText(ALeft, ATop: Integer; const AFontName: String; AFontSize: Integer; AFontColor: TColor; const AText: String);
    procedure AddStrings(ALeft, ATop: Integer; const AFontName: String; AFontSize: Integer; AFontColor: TColor; AStrings: TStrings);
    property Item[Index: Integer]: TBoardItem read GetItem; default;
    property UpdateCount: Integer read FUpdateCount;
  end;

{ TBoardGrapItem }

  TBoardGrapItem = class(TCustomControl)
  private
    FOwner: TBoardGraps;
    FIndex: Integer;
    FMoving: Boolean;
    procedure SetParams(Index: Integer; Owner: TBoardGraps);
    procedure WMLButtonDown(var Message: TWMLButtonDown); message WM_LBUTTONDOWN;
    procedure WMMoveMove(var Message: TWMMouseMove); message WM_MOUSEMOVE;
    procedure WMLButtonUp(var Message: TWMLButtonUp); message WM_LBUTTONUP;
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetPosition(Left, Top: Integer);
  end;

{ TBoardGraps }

  TBoardGraps = class(TComponent)
  private
    FOwner: TCustomBoard;
    FVisible: Boolean;
    FGraps: array[0..7] of TBoardGrapItem;
    FSelected: Integer;
    procedure SetVisible(Value: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetBounds(ShowItem: TBoardItem);
    property Selected: Integer read FSelected;
    property Visible: Boolean read FVisible write SetVisible;
  end;

{ TCustomBoard }

  TStore = record
    PenColor: TColor;
    Count: Integer;
  end;

  TMoveSize = Boolean;
  TBoardItemEvent = procedure (Sender: TObject; Item: TBoardItem) of Object;
  TBoardItemDeleteEvent = procedure (Sender: TObject; Item: TBoardItem; var ADelete: Boolean) of Object;
  TBoardItemClearEvent = procedure (Sender: TObject; var AClear: Boolean) of Object;

  TCustomBoard = class(TCustomControl)
  private
    FItems: TBoardItems;
    FBoardGraps: TBoardGraps;
    FDrawTool: TDrawTool;
    FMoveSize: TMoveSize;
    FSelected: Integer;
    FDblBufferBitmap: TBitmap;
    FMaskBitmap: TBitmap;
    FBoardColor: TColor;
    FDrawing: Boolean;
    FLeftTopPoint: TPoint;
    FRightBottomPoint: TPoint;
    FMovePoint: TPoint;
    FOnItemAdd: TBoardItemEvent;
    FOnItemDelete: TBoardItemDeleteEvent;
    FOnItemClear: TBoardItemClearEvent;
    FOnItemMoveSized: TBoardItemEvent;
    FOnItemSelected: TBoardItemEvent;
    FNewItemColor: TColor;
    procedure SetBoardColor(Value: TColor);
    procedure SetDrawTool(Value: TDrawTool);
    procedure DrawBackground;
    procedure DrawItems;
    procedure DrawShape(TopLeft, BottomRight: TPoint; DrawTool: TDrawTool);
    procedure AddItem(Point1, Point2: TPoint);
    procedure ClearMaskBitmap;
    function IndexFromPoint(Point: TPoint): Integer;
    procedure DrawModeMouseDown(X, Y: Integer);
    procedure DrawModeMouseMove(X, Y: Integer);
    procedure DrawModeMouseUp(X, Y: Integer);
    procedure MoveModeMouseDown(X, Y: Integer);
    procedure MoveModeMouseMove(X, Y: Integer);
    procedure MoveModeMouseUp(X, Y: Integer);
    procedure WMEraseBkgrnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure WMLButtonDown(var Message: TWMLButtonDown); message WM_LBUTTONDOWN;
    procedure WMMouseMove(var Message: TWMMouseMove); message WM_MOUSEMOVE;
    procedure WMLButtonUp(var Message: TWMLButtonUp); message WM_LBUTTONUP;
  protected
    procedure CreateWindowHandle(const Params: TCreateParams); override;
    procedure Paint; override;
    property BoardColor: TColor read FBoardColor write SetBoardColor default clBoard;
    property DrawTool: TDrawTool read FDrawTool write SetDrawTool;
    property Items: TBoardItems read FItems;
    property Selected: Integer read FSelected;
    property OnItemAdd: TBoardItemEvent read FOnItemAdd write FOnItemAdd;
    property OnItemDelete: TBoardItemDeleteEvent read FOnItemDelete write FOnItemDelete;
    property OnItemClear: TBoardItemClearEvent read FOnItemClear write FOnItemClear;
    property OnItemMoveSized: TBoardItemEvent read FOnItemMoveSized write FOnItemMoveSized;
    property OnItemSelected: TBoardItemEvent read FOnItemSelected write FOnItemSelected;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Redraw;
    property Color default clBoard;
    property NewItemColor: TColor read FNewItemColor write FNewItemColor;
  end;

{ TBK_Board }

  TBK_Board = class(TCustomBoard)
  published
    property BoardColor;
    property DrawTool;
    property Items;
    property Selected;
    property OnItemAdd;
    property OnItemDelete;
    property OnItemClear;
    property OnItemMoveSized;
    property OnItemSelected;

    property Align;
    property Canvas;
    property DockSite;
    property DragCursor;
    property DragKind;
    property DragMode;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnClick;
    property OnConstrainedResize;
    property OnDockDrop;
    property OnDockOver;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetSiteInfo;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
    property OnUnDock;
  end;
  

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('BKs', [TBK_Board]);
end;

{ TBoardItem }

procedure TBoardItem.SetLeft(Value: Integer);
begin
  FLeft := Value;
  Redraw;
end;

procedure TBoardItem.SetTop(Value: Integer);
begin
  FTop := Value;
  Redraw;
end;

procedure TBoardItem.SetRight(Value: Integer);
begin
  FRight := Value;
  Redraw;
end;

procedure TBoardItem.SetBottom(Value: Integer);
begin
  FBottom := Value;
  Redraw;
end;

procedure TBoardItem.SetPenColor(Value: TColor);
begin
  FPenColor := Value;
  Redraw;
end;

procedure TBoardItem.Redraw;
begin
  if FOwner <> nil then
   FOwner.Redraw;
end;

procedure TBoardItem.Paint(Canvas: TCanvas; Mask: Boolean);
begin
 {for overriding}
end;

procedure TBoardItem.SetBounds(Left, Top, Right, Bottom: Integer);
begin
  if FOwner <> nil then
   FOwner.Items.BeginUpdate;
  try
    Self.Left := Left;
    Self.Top := Top;
    Self.Right := Right;
    Self.Bottom := Bottom;
  finally
    if FOwner <> nil then
     FOwner.Items.EndUpdate;
    Redraw;
  end;
end;

function TBoardItem.GetDrawTool: TDrawTool;
begin
  Result := dtNone;
end;

function TBoardItem.PtInItem(Point: TPoint): Boolean;
begin
  Result := PtInItemWithBitmap( Point );
end;

function TBoardItem.PtInItemWithBitmap(Point: TPoint): Boolean;
begin
  FOwner.ClearMaskBitmap;
  Paint( FOwner.FMaskBitmap.Canvas, True );
  Result := FOwner.FMaskBitmap.Canvas.Pixels[ Point.X, Point.Y ] = clBlack;
end;

{ TBoardLine }

const
  DefaultPenWidth = 5;

procedure TBoardLine.Paint(Canvas: TCanvas; Mask: Boolean);
begin
  with Canvas do
   begin
     if Mask then
      begin
        Pen.Width := DefaultPenWidth + 2;
        Pen.Color := clBlack;
      end
     else
      begin
        Pen.Width := DefaultPenWidth;
        Pen.Color := FPenColor;
      end;
     Pen.Mode := pmCopy;

     MoveTo( FLeft, FTop );
     LineTo( FRight, FBottom );
   end;
end;

function TBoardLine.GetDrawTool: TDrawTool;
begin
  Result := dtLine;
end;

{ TBoardRectangle }

procedure TBoardRectangle.Paint(Canvas: TCanvas; Mask: Boolean);
begin
  with Canvas do
   begin
     if Mask then
      begin
        Pen.Width := DefaultPenWidth + 2;
        Pen.Color := clBlack;
      end
     else
      begin
        Pen.Width := DefaultPenWidth;
        Pen.Color := FPenColor;
      end;
     Pen.Mode := pmCopy;
     Brush.Style := bsClear;

     Rectangle( Left, Top, Right, Bottom );
   end;
end;

function TBoardRectangle.GetDrawTool: TDrawTool;
begin
  Result := dtRectangle;
end;

{ TBoardRoundRect }

procedure TBoardRoundRect.SetRoundWidth(Value: Integer);
begin
  FRoundWidth := Value;
  Redraw;
end;

procedure TBoardRoundRect.SetRoundHeight(Value: Integer);
begin
  FRoundHeight := Value;
  Redraw;
end;

procedure TBoardRoundRect.Paint(Canvas: TCanvas; Mask: Boolean);
begin
  with Canvas do
   begin
     if Mask then
      begin
        Pen.Width := DefaultPenWidth + 2;
        Pen.Color := clBlack;
      end
     else
      begin
        Pen.Width := DefaultPenWidth;
        Pen.Color := FPenColor;
      end;
     Pen.Mode := pmCopy;

     RoundRect(Left, Top, Right, Bottom, FRoundWidth, FRoundHeight);
   end;
end;

function TBoardRoundRect.GetDrawTool: TDrawTool;
begin
  Result := dtRoundRect;
end;

{ TBoardEllipse }

procedure TBoardEllipse.Paint(Canvas: TCanvas; Mask: Boolean);
begin
  with Canvas do
   begin
     if Mask then
      begin
        Pen.Width := DefaultPenWidth + 2;
        Pen.Color := clBlack;
      end
     else
      begin
        Pen.Width := DefaultPenWidth;
        Pen.Color := FPenColor;
      end;
     Pen.Mode := pmCopy;

     Ellipse( Left, Top, Right, Bottom );
   end;
end;

function TBoardEllipse.GetDrawTool: TDrawTool;
begin
  Result := dtEllipse;
end;

{ TBoardText }  

constructor TBoardText.Create;
begin
  inherited Create;
  FFontName := '±¼¸²Ã¼';
  FFontSize := 9;
  FFontColor := clWhite;
  FLineInterval := 3;
  FStrings := TStringList.Create;
  FStrings.OnChange := StringsChange;
end;

destructor TBoardText.Destroy;
begin
  FStrings.Free;
  inherited Destroy;
end;

function TBoardText.GetRight: Integer;
begin
  Result := inherited Right;
end;

function TBoardText.GetBottom: Integer;
begin
  Result := inherited Bottom;
end;

procedure TBoardText.SetFontName(const Value: String);
begin
  FFontName := Value;
  Redraw;
end;

procedure TBoardText.SetFontSize(Value: Integer);
begin
  FFontSize := Value;
  Redraw;
end;

procedure TBoardText.SetFontColor(Value: TColor);
begin
  FFontColor := Value;
  Redraw;
end;

procedure TBoardText.SetLineInterval(Value: Integer);
begin
  FLineInterval := Value;
  Redraw;
end;

procedure TBoardText.SetStrings(Value: TStringList);
begin
  FStrings.Assign( Value );
end;

procedure TBoardText.StringsChange(Sender: TObject);
begin
  Redraw;
end;

procedure TBoardText.Paint(Canvas: TCanvas; Mask: Boolean);
var
  i, R: Integer;
begin
  FOwner.Items.BeginUpdate;
  try

    inherited Right := Left;
    inherited Bottom := Top;

    if FStrings.Count > 0 then
     with Canvas do
      begin
      
        Font.Name := FFontName;
        Font.Size := FFontSize;
        Font.Style := [];
        if Mask then Font.Color := clBlack
                else Font.Color := FFontColor;


        for i := 0 to FStrings.Count - 1 do
         begin
           TextOut( Left, Top + i * (Abs(Font.Height) + FLineInterval ), FStrings[ i ]);
           R := Left + TextWidth( FStrings[ i ] );
           if R > inherited Right then inherited Right := R;
         end;

        inherited Bottom := Top + ( FStrings.Count ) * ( Abs( Font.Height ) + FLineInterval );
        
      end;

  finally
    FOwner.Items.EndUpdate;
  end;
end;

function TBoardText.GetDrawTool: TDrawTool;
begin
  Result := dtText;
end;

{ TBoardItems }

constructor TBoardItems.Create(AOwner: TCustomBoard);
begin
  inherited Create;
  FOwner := AOwner;
  FList := TList.Create;
  FUpdateCount := 0;
end;

destructor TBoardItems.Destroy;
begin
  FList.Free;
  inherited Destroy;
end;

function TBoardItems.GetItem(Index: Integer): TBoardItem;
begin
  Result := TBoardItem( FList[ Index ] );
end;

function TBoardItems.Count: Integer;
begin
  Result := FList.Count;
end;

procedure TBoardItems.Add(Item: TBoardItem);
begin
  Item.Owner := FOwner;
  FList.Add( Item );
  Item.Paint( FOwner.Canvas, False );
  Item.Paint( FOwner.FDblBufferBitmap.Canvas, False );
  if Assigned( FOwner.FOnItemAdd ) then FOwner.FOnItemAdd( FOwner, Item );
end;

procedure TBoardItems.Clear;
var
  i: Integer;
  AClear: Boolean;
begin
  AClear := True;
  if Assigned( FOwner.FOnItemClear ) then FOwner.FOnItemClear( FOwner, AClear );

  if AClear then
   begin
     if Count > 0 then
      for i := Count - 1 downto 0 do
       GetItem( i ).Free;
     FList.Clear;
     Redraw;
   end;
end;

procedure TBoardItems.Delete(Index: Integer);
var
  ADelete: Boolean;
begin
  ADelete := True;
  if Assigned( FOwner.FOnItemDelete ) then FOwner.FOnItemDelete( FOwner, GetItem( Index ), ADelete );

  if ADelete then
   begin
     GetItem( Index ).Free;
     FList.Delete( Index );
     FOwner.FSelected := -1;
     FOwner.FBoardGraps.Visible := False;
     Redraw;
   end;
end;

procedure TBoardItems.Move(FromIndex, ToIndex: Integer);
begin
  FList.Move( FromIndex, ToIndex );
  Redraw;
end;

procedure TBoardItems.Exchange(Index1, Index2: Integer);
begin
  FList.Exchange( Index1, Index2 );
  Redraw;
end;

procedure TBoardItems.BeginUpdate;
begin
  Inc( FUpdateCount );
end;

procedure TBoardItems.EndUpdate;
begin
  if FUpdateCount > 0 then Dec( FUpdateCount ) else
  if FUpdateCount < 0 then FUpdateCount := 0;
end;

procedure TBoardItems.AddLine(ALeft, ATop, ARight, ABottom, APenColor: TColor);
var
  AItem: TBoardLine;
begin
  AItem := TBoardLine.Create;
  with AItem do
   begin
     SetBounds( ALeft, ATop, ARight, ABottom );
     PenColor := APenColor;
   end;
  Add( AItem );
end;

procedure TBoardItems.AddRectangle(ALeft, ATop, ARight, ABottom, APenColor: TColor);
var
  AItem: TBoardRectangle;
begin
  AItem := TBoardRectangle.Create;
  with TBoardRectangle( AItem ) do
   begin
     SetBounds( ALeft, ATop, ARight, ABottom );
     PenColor := APenColor;
   end;
  Add( AItem );
end;

procedure TBoardItems.AddRoundRect(ALeft, ATop, ARight, ABottom, APenColor: TColor; ARoundWidth, ARoundHeight: Integer);
var
  AItem: TBoardRoundRect;
begin
  AItem := TBoardRoundRect.Create;
  with TBoardRoundRect( AItem ) do
   begin
     SetBounds( ALeft, ATop, ARight, ABottom );
     PenColor := APenColor;
     RoundWidth := ARoundWidth;
     RoundHeight := ARoundHeight;
   end;
  Add( AItem );
end;

procedure TBoardItems.AddEllipse(ALeft, ATop, ARight, ABottom, APenColor: TColor);
var
  AItem: TBoardEllipse;
begin
  AItem := TBoardEllipse.Create;
  with TBoardEllipse( AItem ) do
   begin
     SetBounds( ALeft, ATop, ARight, ABottom );
     PenColor := APenColor;
   end;
  Add( AItem );
end;

procedure TBoardItems.AddText(ALeft, ATop: Integer; const AFontName: String; AFontSize: Integer; AFontColor: TColor; const AText: String);
var
  AItem: TBoardText;
begin
  AItem := TBoardText.Create;
  with AItem do
   begin
     Left := ALeft;
     Top := ATop;
     FontName := AFontName;
     FontColor := FontColor;
     FontSize := AFontSize;
     Lines.Add( AText );
   end;
  Add( AItem );
end;

procedure TBoardItems.AddStrings(ALeft, ATop: Integer; const AFontName: String; AFontSize: Integer; AFontColor: TColor; AStrings: TStrings);
var
  AItem: TBoardText;
begin
  AItem := TBoardText.Create;
  with AItem do
   begin
     Left := ALeft;
     Top := ATop;
     FontName := AFontName;
     FontColor := FontColor;
     FontSize := AFontSize;
     Lines.Assign( AStrings );
   end;
  Add( AItem );
end;

procedure TBoardItems.Redraw;
begin
  if FOwner <> nil then FOwner.Redraw;
end;

{ TBoardGrapItem }

constructor TBoardGrapItem.Create(AOwner: TComponent);
begin
  inherited Create( AOwner );
  
  Width := GrapWidth;
  Height := GrapWidth;
  Color := clWhite;
  Visible := False;
end;

destructor TBoardGrapItem.Destroy;
begin
  inherited Destroy;
end;

procedure TBoardGrapItem.SetPosition(Left, Top: Integer);
begin
  SetBounds( Left - GrapWidth div 2, Top - GrapWidth div 2, Width, Height ); 
end;

procedure TBoardGrapItem.SetParams(Index: Integer; Owner: TBoardGraps);
begin
  FIndex := Index;
  FOwner := Owner;
  Cursor := GrapCursors[ FIndex ];
end;

var
  APoint: TPoint;

procedure TBoardGrapItem.WMLButtonDown(var Message: TWMLButtonDown);
begin
  inherited;
  
  FMoving := True;
  FOwner.FSelected := FIndex;
  FOwner.FOwner.FMoveSize := msSize;
  APoint := Point( Message.XPos, Message.YPos );
  FOwner.FOwner.MoveModeMouseDown( Left + Message.XPos, Top + Message.YPos );
end;

procedure TBoardGrapItem.WMMoveMove(var Message: TWMMouseMove);
begin
  inherited;
  
  if FMoving then
   FOwner.FOwner.MoveModeMouseMove( Left + Message.XPos, Top + Message.YPos );
end;

procedure TBoardGrapItem.WMLButtonUp(var Message: TWMLButtonUp);
begin
  inherited;
  
  if FMoving then
   begin
     FOwner.FOwner.MoveModeMouseUp( Left + Message.XPos, Top + Message.YPos );
     FMoving := False;
   end;
end;

procedure TBoardGrapItem.Paint;
begin
  inherited;

  Canvas.Pen.Width := 1;
  Canvas.Pen.Color := clBlack;
  Canvas.Brush.Style := bsSolid;
  Canvas.Brush.Color := clWhite;
  Canvas.Rectangle( ClientRect );
end;

{ TBoardGraps }

constructor TBoardGraps.Create(AOwner: TComponent);
var
  i: Integer;
begin
  inherited Create( AOwner );
  
  FOwner := TCustomBoard( AOwner );

  if not ( csDesigning in ComponentState ) then
   for i := 0 to 7 do
    begin
      FGraps[ i ] := TBoardGrapItem.Create( FOwner );
      FGraps[ i ].SetParams( i, Self );  
      FGraps[ i ].Parent := FOwner;
    end;
end;

destructor TBoardGraps.Destroy;
begin
  inherited Destroy;
end;

procedure TBoardGraps.SetBounds(ShowItem: TBoardItem);
begin
  if csDesigning in ComponentState then Exit;
  
  with ShowItem do
  case DrawTool of
  dtLine      : begin
                  FGraps[ 0 ].SetPosition( Left, Top );
                  FGraps[ 1 ].SetPosition( Right, Bottom );
                  FGraps[ 1 ].Cursor := crCross;
                end;
  dtRectangle,
  dtRoundRect,
  dtEllipse,
  dtText      : begin
                  FGraps[ 0 ].SetPosition( Left, Top );
                  FGraps[ 1 ].SetPosition( Left + ( ( Right - Left ) div 2 ), Top );
                  FGraps[ 2 ].SetPosition( Right, Top );
                  FGraps[ 3 ].SetPosition( Right, Top + ( ( Bottom - Top ) div 2 ) );
                  FGraps[ 4 ].SetPosition( Right, Bottom );
                  FGraps[ 5 ].SetPosition( Left + ( ( Right - Left ) div 2 ), Bottom );
                  FGraps[ 6 ].SetPosition( Left, Bottom );
                  FGraps[ 7 ].SetPosition( Left, Top + ( ( Bottom - Top ) div 2 ) );
                  FGraps[ 1 ].Cursor := GrapCursors[ 1 ];
                end;
  end;
end;

procedure TBoardGraps.SetVisible(Value: Boolean);
var
  i: Integer;
begin
  FVisible := Value;
  if csDesigning in ComponentState then Exit;

  if Value and ( FOwner.DrawTool = dtSelect ) and ( FOwner.Selected >= 0 ) then
   begin
     case FOwner.Items[ FOwner.Selected ].DrawTool of
     dtLine      : begin
                     FGraps[ 0 ].Visible := True;
                     FGraps[ 1 ].Visible := True;
                     for i := 2 to 7 do
                      FGraps[ i ].Visible := False;
                   end;
     dtRectangle,
     dtRoundRect,
     dtEllipse,
     dtText      : begin
                     for i := 0 to 7 do
                        FGraps[ i ].Visible := True;
                   end;
     else          begin
                     for i := 0 to 7 do
                        FGraps[ i ].Visible := False;
                   end;
     end;
   end
  else
   begin
     for i := 0 to 7 do
      begin
        FGraps[ i ].Visible := False;
        FGraps[ i ].Update;
      end;
   end;
end;

{ TCustomBoard }

constructor TCustomBoard.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  
  ControlStyle := [ csAcceptsControls, csCaptureMouse, csClickEvents, csOpaque, csDoubleClicks, csReplicatable ];

  Width := 200;
  Height := 100;
  FBoardColor := clBoard;
  FItems := TBoardItems.Create( Self );
  FBoardGraps := TBoardGraps.Create( Self );
  FDblBufferBitmap := TBitmap.Create;
  FMaskBitmap := TBitmap.Create;
end;

procedure TCustomBoard.CreateWindowHandle(const Params: TCreateParams);
begin
  inherited CreateWindowHandle( Params );
  
  DrawBackground;
  DrawItems;

  with Canvas do
   begin
     Pen.Width := 1;
     Pen.Style := psSolid;
     Pen.Color := clWhite;
     Font.Name := '±¼¸²';
     Font.Size := 9;
     Font.Color := clWhite;
     Font.Style := [];
   end;
end;

destructor TCustomBoard.Destroy;
begin
  FItems.Free;
  FBoardGraps.Free;
  FDblBufferBitmap.Free;
  FMaskBitmap.Free;
  inherited Destroy;
end;

procedure TCustomBoard.WMEraseBkgrnd(var Message: TWMEraseBkgnd);
begin
  Paint;
end;

procedure TCustomBoard.WMLButtonDown(var Message: TWMLButtonDown);
begin
  inherited;
  
  FDrawing := True;
  FMoveSize := msMove;
  with Message do
   if FDrawTool = dtSelect then MoveModeMouseDown( XPos, YPos )
                           else DrawModeMouseDown( XPos, YPos );
end;

procedure TCustomBoard.WMMouseMove(var Message: TWMMouseMove);
begin
  inherited;

  if FDrawing then
   with Message do
    begin
      if FDrawTool = dtSelect then MoveModeMouseMove( XPos, YPos )
                              else DrawModeMouseMove( XPos, YPos );
    end
   else
    begin
      if ( FDrawTool = dtSelect ) and ( IndexFromPoint( Point( Message.XPos, Message.YPos ) ) >= 0 ) then
       begin
         Cursor := crHandPoint;
         FMoveSize := msMove;
       end
      else Cursor := crDefault;
    end
end;

procedure TCustomBoard.WMLButtonUp(var Message: TWMLButtonUp);
begin
  inherited;

  if FDrawing then
   with Message do
    begin
      if FDrawTool = dtSelect then MoveModeMouseUp( XPos, YPos )
                              else DrawModeMouseUp( XPos, YPos );
      FDrawing := False;
    end;
end;

procedure TCustomBoard.DrawModeMouseDown(X, Y: Integer);
begin
  FLeftTopPoint := Point( X, Y );
  FRightBottomPoint := FLeftTopPoint;

  with Canvas do
   begin
     Pen.Width := 1;
     Pen.Color := clBlack;
   end;
end;

procedure TCustomBoard.DrawModeMouseMove(X, Y: Integer);
begin
  DrawShape( FLeftTopPoint, FRightBottomPoint, FDrawTool );
  FRightBottomPoint := Point( X, Y );
  DrawShape( FLeftTopPoint, FRightBottomPoint, FDrawTool );
end;

procedure TCustomBoard.DrawModeMouseUp(X, Y: Integer);
begin
  FRightBottomPoint := Point( X, Y );
  DrawShape( FLeftTopPoint, FRightBottomPoint, FDrawTool );
  AddItem( FLeftTopPoint, FRightBottomPoint );
end;

procedure TCustomBoard.MoveModeMouseDown(X, Y: Integer);
var
  AIndex: Integer;
begin
  case FMoveSize of
  msMove: begin
            AIndex := IndexFromPoint( Point( X, Y ) );

            if AIndex < 0 then
             begin
               FDrawing := False;
               FSelected := -1;
               FBoardGraps.Visible := False;
               Exit;
             end
            else
             begin
               FBoardGraps.Visible := False;
               if AIndex <> FSelected then
                begin
                  FSelected := AIndex;
                  FBoardGraps.SetBounds( FItems[ FSelected ] );
                end;
             end;
          end;
  msSize: FBoardGraps.Visible := False;
  end;

  if Assigned( FOnItemSelected ) then FOnItemSelected( Self, FItems[ FSelected ] );

  FLeftTopPoint := Point( FItems[ FSelected ].Left, FItems[ FSelected ].Top );
  FRightBottomPoint := Point( FItems[ FSelected ].Right, FItems[ FSelected ].Bottom );
  FMovePoint := Point( X, Y );

  with Canvas do
   begin
     Pen.Width := 1;
     Pen.Color := clBlack;
   end;
  DrawShape( FLeftTopPoint, FRightBottomPoint, FItems[ FSelected ].DrawTool );
end;

procedure TCustomBoard.MoveModeMouseMove(X, Y: Integer);
begin
  case FMoveSize of
  msMove: begin
            DrawShape( FLeftTopPoint, FRightBottomPoint, FItems[ FSelected ].DrawTool );
            Inc( FLeftTopPoint.X, X - FMovePoint.X );
            Inc( FLeftTopPoint.Y, Y - FMovePoint.Y );
            Inc( FRightBottomPoint.X, X - FMovePoint.X );
            Inc( FRightBottomPoint.Y, Y - FMovePoint.Y );
            FMovePoint := Point( X, Y );
            DrawShape( FLeftTopPoint, FRightBottomPoint, FItems[ FSelected ].DrawTool );
          end;
  msSize: begin
            DrawShape( FLeftTopPoint, FRightBottomPoint, FItems[ FSelected ].DrawTool );

            case FBoardGraps.FSelected of
            0: begin
                 Inc( FLeftTopPoint.X, X - FMovePoint.X );
                 Inc( FLeftTopPoint.Y, Y - FMovePoint.Y );
               end;
            1: begin
                 case FItems[ FSelected ].DrawTool of
                 dtLine: begin
                           Inc( FRightBottomPoint.X, X - FMovePoint.X );
                           Inc( FRightBottomPoint.Y, Y - FMovePoint.Y );
                         end
                 else    Inc( FLeftTopPoint.Y, Y - FMovePoint.Y );
                 end;
               end;
            2: begin
                 Inc( FRightBottomPoint.X, X - FMovePoint.X );
                 Inc( FLeftTopPoint.Y, Y - FMovePoint.Y );
               end;
            3: begin
                 Inc( FRightBottomPoint.X, X - FMovePoint.X );
               end;
            4: begin
                 Inc( FRightBottomPoint.X, X - FMovePoint.X );
                 Inc( FRightBottomPoint.Y, Y - FMovePoint.Y );
               end;
            5: begin
                 Inc( FRightBottomPoint.Y, Y - FMovePoint.Y );
               end;
            6: begin
                 Inc( FLeftTopPoint.X, X - FMovePoint.X );
                 Inc( FRightBottomPoint.Y, Y - FMovePoint.Y );
               end;
            7: begin
                 Inc( FLeftTopPoint.X, X - FMovePoint.X );
               end;
            end;
            FMovePoint := Point( X, Y );
            DrawShape( FLeftTopPoint, FRightBottomPoint, FItems[ FSelected ].DrawTool );
          end;
  end;
end;

procedure TCustomBoard.MoveModeMouseUp(X, Y: Integer);
begin
  DrawShape( FLeftTopPoint, FRightBottomPoint, FItems[ FSelected ].DrawTool );
  FItems[ FSelected ].SetBounds( FLeftTopPoint.X, FLeftTopPoint.Y, FRightBottomPoint.X, FRightBottomPoint.Y );
  FBoardGraps.SetBounds( FItems[ FSelected ] );
  FBoardGraps.Visible := True;
  if Assigned( FOnItemMoveSized ) then FOnItemMoveSized( Self, FItems[ FSelected ] );
end;

procedure TCustomBoard.Paint;
begin
  if csDesigning in ComponentState then DrawBackground;
  Canvas.Draw( 0, 0, FDblBufferBitmap );
end;

procedure TCustomBoard.Redraw;
begin
  if FItems.UpdateCount = 0 then
   with Canvas do
    begin
      DrawBackground;
      DrawItems;
      Paint;
    end;
end;

procedure TCustomBoard.DrawBackground;
begin
  FDblBufferBitmap.Width := Width;
  FDblBufferBitmap.Height := Height;
  FMaskBitmap.Width := Width;
  FMaskBitmap.Height := Height;


  FDblBufferBitmap.Canvas.Brush.Style := bsSolid;
  FDblBufferBitmap.Canvas.FillRect( ClientRect );
end;

procedure TCustomBoard.DrawItems;
var
  i: Integer;
begin
  FDblBufferBitmap.Canvas.Lock;
  try
  if FItems.Count > 0 then
   for i := 0 to FItems.Count - 1 do
    FItems[ i ].Paint( FDblBufferBitmap.Canvas, False );
  finally
    FDblBufferBitmap.Canvas.Unlock;
  end;
end;

procedure TCustomBoard.SetBoardColor(Value: TColor);
begin
  if FBoardColor <> Value then
   begin
     FBoardColor := Value;
     Redraw;
   end;
end;

procedure TCustomBoard.SetDrawTool(Value: TDrawTool);
begin
  FDrawTool := Value;
  if Value <> dtSelect then
   begin
     FSelected := -1;
     FBoardGraps.Visible := False;
   end;
end;

procedure TCustomBoard.DrawShape(TopLeft, BottomRight: TPoint; DrawTool: TDrawTool);
begin
  with Canvas do
  begin
    Pen.Mode := pmNotXor;
    case DrawTool of
    dtLine     : begin
                   MoveTo( TopLeft.X, TopLeft.Y );
                   LineTo( BottomRight.X, BottomRight.Y );
                 end;
    dtRectangle: Rectangle( TopLeft.X, TopLeft.Y, BottomRight.X, BottomRight.Y );
    dtEllipse  : Ellipse( Topleft.X, TopLeft.Y, BottomRight.X, BottomRight.Y );
    dtRoundRect: RoundRect( TopLeft.X, TopLeft.Y, BottomRight.X, BottomRight.Y, ( TopLeft.X - BottomRight.X ) div 2, ( TopLeft.Y - BottomRight.Y ) div 2 );
    dtText     : Rectangle( TopLeft.X, TopLeft.Y, BottomRight.X, BottomRight.Y ); 
    end;
  end;
end;

procedure TCustomBoard.AddItem(Point1, Point2: TPoint);
begin
  case FDrawTool of
  dtLine     : FItems.AddLine( Point1.X, Point1.Y, Point2.X, Point2.Y, NewItemColor );
  dtRectangle: FItems.AddRectangle( Point1.X, Point1.Y, Point2.X, Point2.Y, NewItemColor );
  dtEllipse  : FItems.AddEllipse( Point1.X, Point1.Y, Point2.X, Point2.Y, NewItemColor );
  dtRoundRect: FItems.AddRoundRect( Point1.X, Point1.Y, Point2.X, Point2.Y, NewItemColor, ( Point1.X - Point2.X ) div 2, ( Point1.Y - Point2.Y ) div 2 );
  end;
end;

procedure TCustomBoard.ClearMaskBitmap;
begin
  with FMaskBitmap do
   begin
     Canvas.Brush.Color := clWhite;
     Canvas.FillRect( Rect( 0, 0, Width, Height ) );
   end;
end;

function TCustomBoard.IndexFromPoint(Point: TPoint): Integer;
var
  i: Integer;
begin
  if FItems.Count > 0 then
   for i := FItems.Count - 1 downto 0 do
    if FItems[ i ].PtInItem( Point ) then
     begin
       Result := i;
       Exit;
     end;
  Result := -1;
end;

end.
