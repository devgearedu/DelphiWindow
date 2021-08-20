(**************************************************************************
  처음 TNumberEdit를 작성한 분이 누군지 알 길이 없어 허락없이 소스를 수정함을
    이해 바랍니다.
  2002-04-08 MrMonkey
    1. constructor Public으로 변경
    2. 몇가지 논리적 에러 몇 속성값 변수값 수정, 삭제
    3. FMin, FMax : integer로 변경
  2002-04-16 MrMonkey
    1. TCustomEdit에서 상속하여 CharCase, MaxLength, PasswordChar, Text 속성 오브젝트 인스펙트에
          안보이게함
    2. AsInteger 정수형 전용 런타임 읽기 속성 추가(기존 Value는 실수형)
**************************************************************************)
unit NumEdit;
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TNumberEdit = class(TCustomEdit)
  private
    FDigits   : byte;
    FMin,FMax : integer;
    FDec      : char;
    procedure SetMin(NewValue : integer);
    procedure SetMax(NewValue : integer);
    procedure SetDigits(NewValue : byte);
    procedure SetValue(NewValue : extended);
    function GetValue : extended;
    function StrToNumber(s:String) : Extended;
    function GetAsInteger: Longint;
  protected
    procedure DoExit; override;
    procedure DoEnter; override;
    procedure KeyPress(var Key: Char); override;
    procedure CreateParams(var Params: TCreateParams); override;

  public
    constructor create (aowner : TComponent);override;
    property AsInteger: Longint read GetAsInteger;
  published
    property Digits : byte read FDigits write SetDigits;
    property Value  : extended read GetValue write SetValue;
    property Min : integer read FMin write SetMin;
    property Max : integer read FMax write SetMax;

    property Anchors;
    property AutoSelect;
    property AutoSize;
    property BiDiMode;
    property BorderStyle;
    //property CharCase;
    property Color;
    property Constraints;
    property Ctl3D;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property HideSelection;
    property ImeMode;
    property ImeName;
    //property MaxLength;
    property OEMConvert;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
  //  property PasswordChar;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property TabOrder;
    property TabStop;
    //property Text;
    property Visible;
    property OnChange;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
  end;

procedure Register;

implementation
constructor TNumberEdit.Create (aowner : TComponent);
begin
     inherited Create(aowner);
     FDec := FormatSettings.DecimalSeparator;      // 델파이 xe에서 유닛 표현 변경
     FDigits := 0;
     FMin := Low(integer);
     FMax := High(integer);
     SetValue(0.0);
end;

procedure Register;
begin
  RegisterComponents('Additional', [TNumberEdit]);
end;

procedure TNumberEdit.SetValue(NewValue : extended);
begin
  if NewValue > FMax then
  begin
    showmessage('Invalid Value');
    NewValue := FMax;
  end;
  if NewValue < FMin then
  begin
    showmessage('Invalid Value');
    NewValue := FMin;
  end;
  Text := FloatToStrf(NewValue,ffNumber,18,fDigits);
end;
function TNumberEdit.GetValue : extended;
var ts : string;
begin
  ts := Text;
  if (ts = '-') or (ts = fdec) or (ts = '') then
    ts := '0';

  try
    Result := strtoNumber(ts);
  except
    showmessage('Invalid Value');
    Result := 0;
  end;

  if Result < FMin then  Result := FMin;
  if Result > FMax then  Result := FMax;
end;

procedure TNumberEdit.SetDigits(NewValue : byte);
begin
  if FDigits <> NewValue then
  begin
    if NewValue > 18 then NewValue := 18;
    FDigits := NewValue;
    SetValue(GetValue);
  end;
end;

procedure TNumberEdit.SetMin(NewValue : integer);
begin
  if FMin <> NewValue then
  begin
    if FMin > FMax then
    begin
      showmessage('Min-Value has to be less than or equal to Max-Value !');
      NewValue := FMax;
    end;
    FMin := NewValue;
    SetValue(GetValue);
  end;
end;
procedure TNumberEdit.SetMax(NewValue : integer);
begin
  if FMax <> NewValue then
  begin
    if FMin > FMax then
    begin
      showmessage('Max-Value has to be greater than or equal to Min-Value !');
      NewValue := FMin;
    end;
    FMax := NewValue;
    SetValue(GetValue);
  end;
end;


procedure TNumberEdit.KeyPress(var Key: Char);
var
  ts     : string;
  temp   : extended;
  ThisForm : TCustomForm;

begin
  if Key = #13 then                  // [Enter] Key 경우 다음항목으로
  begin
    ThisForm := GetParentForm( Self );
    if not (ThisForm = nil ) then
       SendMessage(ThisForm.Handle, WM_NEXTDLGCTL, 0, 0);
    Key := #0;
  end;

  if key < #32 then
  begin
    inherited;
    exit;
  end;

  ts := copy(Text,1,selstart)+copy(Text,selstart+sellength+1,500);

  if (key <'0') or (key > '9') then
     if (key <> fdec) and (key <> '-') then
     begin
       inherited;
       key := #0;
       exit;
     end;
  if key = fdec then
     if pos(fdec,ts) <> 0 then
     begin
       inherited;
       key := #0;
       exit;
     end;
  if key = '-' then
     if pos('-',ts) <> 0 then
     begin
       inherited;
       key := #0;
       exit;
     end;
  if key = '-' then
     if fmin >= 0 then
     begin
       inherited;
       key := #0;
       exit;
     end;
  if key = fdec then
     if fdigits = 0 then
     begin
       inherited;
       key := #0;
       exit;
     end;

  ts := copy(Text,1,selstart)+key+copy(Text,selstart+sellength+1,500);

  if key > #32 then if pos(fdec,ts)<> 0 then
  begin
    if length(ts)-pos(fdec,ts) > fdigits then
    begin
      inherited;
      key := #0;
      exit;
    end;
  end;

  if key = '-' then
     if pos('-',ts) <> 1 then
     begin
       inherited;
       key := #0;
       exit;
     end;

     if ts ='' then
     begin
       inherited;key := #0;
       Text := floattostrf(fmin,ffNumber,18,fdigits);selectall;
       exit;
     end;

     if ts = '-' then
     begin
       inherited;key:=#0;
       Text := '-0';selstart := 1;sellength:=1;
       exit;
     end;

     if ts = fdec then
     begin
       inherited;key:=#0;
       Text := '0'+FDec+'0';
       selstart :=2;
       sellength:=1;
       exit;
     end;

     try
        temp := strtoNumber(ts);
     except
        showmessage('Invalid Value');
        inherited;
        key := #0;
        Text := floattostrf(FMin,ffNumber,18,FDigits);
        selectall;
        exit;
     end;

     if temp < fmin then
     begin
       inherited;
       key := #0;
       showmessage('Invalid Value');
       Text := floattostrf(FMin,ffNumber,18,FDigits);
       selectall;
       exit;
     end;

     if temp > FMax then
     begin
       inherited;key := #0;
       showmessage('Invalid Value');
       Text := floattostrf(FMax,ffNumber,18,FDigits);
       selectall;
       exit;
     end;
     inherited;
end;

Function TNumberEdit.StrToNumber(s:String) : Extended;
var
  r : Extended;
  i : integer;
  v : string;
Begin
  v := '';
  for i := 1 to Length(s) do
  begin
    if s[i] in ['-','.','0'..'9'] then
       v := v + s[i]
    else if (s[i]<>',') and (s[i]<>' ') then
         begin
           Result := 0;
           exit;
         end;
  end;

  Val(v,r,i);

  if i = 0 then
    Result := r
  else
    Result := 0;

End;

procedure TNumberEdit.DoExit;
begin
  Text := floattostrf(Value,ffNumber,18,FDigits);
  inherited;
end;

procedure TNumberEdit.DoEnter;
begin
  Text := floattostrf(Value,ffFixed,18,FDigits);
  SelStart  := 0;
  SelLength := Length(Text);
  inherited;
end;

procedure TNumberEdit.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.Style := Params.Style or (ES_RIGHT or ES_MULTILINE);
end;

function TNumberEdit.GetAsInteger: Longint;
begin
  Result := Round(GetValue);
end;

end.
