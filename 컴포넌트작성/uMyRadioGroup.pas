unit uMyRadioGroup;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TMyRadioGroup = class(TCustomRadioGroup)
  private
    FValues: TStrings;
    FValue: string;
    FInSetValue: Boolean;
    FOnChange: TNotifyEvent;
    procedure SetValues(const Value: TStrings);
    procedure SetValue(const Value: string);
    procedure SetOnChange(const Value: TNotifyEvent);
    procedure DataChange(Sender: TObject);
    function  GetButtonValue(Index: Integer): string;
    procedure SetItems(Value: TStrings);
    { Private declarations }
  protected
    procedure Change; dynamic;
    procedure Click; override;
    { Protected declarations }
  public
    property Value: string read FValue write SetValue;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    { Public declarations }
  published
    property Align;
    property Anchors;
    property BiDiMode;
    property Caption;
    property Color;
    property Columns;
    property Ctl3D;
    property DoubleBuffered;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property ItemIndex;
    property Items write SetItems;
    property Constraints;
    property ParentBiDiMode;
    property ParentBackground default True;
    property ParentColor;
    property ParentCtl3D;
    property ParentDoubleBuffered;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Touch;
    property Visible;
    property WordWrap;
    property OnChange: TNotifyEvent read FOnChange write SetOnChange;
    property OnClick;
    property OnContextPopup;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGesture;
    property OnStartDock;
    property OnStartDrag;
    property Values: TStrings read FValues write SetValues;
    { Published declarations }
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Samples', [TMyRadioGroup]);
end;

{ TMyRadioGroup }

procedure TMyRadioGroup.Change;
begin
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TMyRadioGroup.Click;
begin
  inherited;
  if not FInSetValue then
  begin
    inherited Click;
    if ItemIndex >= 0 then Value := GetButtonValue(ItemIndex);
  end;
end;

constructor TMyRadioGroup.Create(AOwner: TComponent);
begin
  inherited;
  FValues := TStringList.Create;
end;

procedure TMyRadioGroup.DataChange(Sender: TObject);
begin
// if FDataLink.Field <> nil then
//    Value := FDataLink.Field.Text else
//    Value := '';
   Value := '';
end;

destructor TMyRadioGroup.Destroy;
begin
  FValues.Free;
  inherited;
end;

function TMyRadioGroup.GetButtonValue(Index: Integer): string;
begin
   if (Index < FValues.Count) and (FValues[Index] <> '') then
    Result := FValues[Index]
  else if Index < Items.Count then
    Result := Items[Index]
  else
    Result := '';
end;

procedure TMyRadioGroup.SetItems(Value: TStrings);
begin
  Items.Assign(Value);
  DataChange(Self);
end;

procedure TMyRadioGroup.SetOnChange(const Value: TNotifyEvent);
begin
  FOnChange := Value;
end;

procedure TMyRadioGroup.SetValue(const Value: string);
var
  WasFocused: Boolean;
  I, Index: Integer;
begin
  if FValue <> Value then
  begin
    FInSetValue := True;
    try
      WasFocused := (ItemIndex > -1) and (Buttons[ItemIndex].Focused);
      Index := -1;
      for I := 0 to Items.Count - 1 do
        if Value = GetButtonValue(I) then
        begin
          Index := I;
          Break;
        end;
      ItemIndex := Index;
      // Move the focus rect along with the selected index
      if WasFocused and (ItemIndex <> -1) then
        Buttons[ItemIndex].SetFocus;
    finally
      FInSetValue := False;
    end;
    FValue := Value;
    Change;
  end;
  FValue := Value;
end;

procedure TMyRadioGroup.SetValues(const Value: TStrings);
begin
  FValues.Assign(Value);
  DataChange(Self);
end;

end.
