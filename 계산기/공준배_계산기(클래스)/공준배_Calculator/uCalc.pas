unit uCalc;

interface

uses System.SysUtils, Vcl.Dialogs, System.Character;

type

  Calc_Stack = class
  private
    Formula: array [0 .. 100] of string;
    FormulaPoint: integer;
  public
    constructor Create; //
    function Calc(x, y, Oper: integer): real; //
    function Priority(x: string): integer;  //
    function Point: integer;
    function GetPoint: integer; //
    function Postfix: string;
    procedure ResetPoint;   //
    procedure Input(Num: real); overload;   //
    procedure Input(Oper: string); overload;   //
  end;

implementation

{ Calc_Stack }

function Calc_Stack.Calc(x, y, Oper: integer): real; // 연산
begin
  if isnumber(Formula[x],1) and isnumber(Formula[y],1) then //숫자 아니면 에러
  begin
    if Formula[Oper] = '+' then
    begin
      result := StrToFloat(Formula[x]) + StrToFloat(Formula[y]);
    end
    else if Formula[Oper] = '-' then
    begin
      result := StrToFloat(Formula[x]) - StrToFloat(Formula[y]);
    end
    else if Formula[Oper] = '*' then
    begin
      result := StrToFloat(Formula[x]) * StrToFloat(Formula[y]);
    end
    else if Formula[Oper] = '/' then
      try
        result := StrToFloat(Formula[x]) / StrToFloat(Formula[y]);
      except
        result := 0;
        raise Exception.Create('0으로 나눌 수 없습니다');
      end;
  end
  else
  begin
    result := 0;
    raise Exception.Create('잘못된 수식입니다');
  end;
end;

constructor Calc_Stack.Create;
begin
  FormulaPoint := 0;
end;

function Calc_Stack.GetPoint: integer;
begin
  result := FormulaPoint;
end;

procedure Calc_Stack.Input(Num: real); // 숫자 입력
begin
  Formula[FormulaPoint] := FloatToStr(Num);
  Inc(FormulaPoint);
end;

procedure Calc_Stack.Input(Oper: string); // 연산기호 입력
begin
  if (Oper = '(') and not((Formula[FormulaPoint - 1] = '+') or
    // ( 입력후 앞에 숫자면 * 입력
    (Formula[FormulaPoint - 1] = '-') or (Formula[FormulaPoint - 1] = '*') or
    (Formula[FormulaPoint - 1] = '/')) then
  begin
    Formula[FormulaPoint] := '*';
    Inc(FormulaPoint);
  end;
  Formula[FormulaPoint] := Oper;
  Inc(FormulaPoint);
end;

function Calc_Stack.Point: integer; // 위치반환
begin
  result := FormulaPoint;
end;

function Calc_Stack.Postfix: string; // 중위 -> 후위 표기 변경 및 연산
var
  OperTemp: array [0 .. 20] of string;
  OperPoint: integer;
  HeadPoint: integer;
  i: integer;
  j: integer;
begin
  OperPoint := 0;
  HeadPoint := 0;
  for i := 0 to FormulaPoint - 1 do
  begin
    if (Formula[i] >= '(') and (Formula[i] <= '/') then
    // 값이 연산기호일시 우선순위 비교 후 배열에 입력
    begin
      if OperPoint >= 1 then
      begin
        if Formula[i] = '(' then
        //아무것도하지않음 ( 입력
        else if Formula[i] = ')' then
        begin
          while True do // ( 만날때까지 꺼내면서 연산
          begin
            Dec(OperPoint);
            if OperTemp[OperPoint] = '(' then
              break;
            Formula[HeadPoint] := OperTemp[OperPoint];
            Formula[HeadPoint - 2] :=
              FloatToStr(Calc(HeadPoint - 2, HeadPoint - 1, HeadPoint));
            Dec(HeadPoint);
          end;
        end
        else if Priority(OperTemp[OperPoint-1]) >= Priority(Formula[i]) then
        // 연산자 우선순위에 의해 스택에서 값 꺼내고 바로 연산
        begin
          Dec(OperPoint);
          Formula[HeadPoint] := OperTemp[OperPoint];
          Formula[HeadPoint - 2] :=
            FloatToStr(Calc(HeadPoint - 2, HeadPoint - 1, HeadPoint));
          Dec(HeadPoint);
        end;

      end;
      if Formula[i] <> ')' then // ) 가 아닌 연산자 OperTemp에서 대기
      begin
        OperTemp[OperPoint] := Formula[i];
        Inc(OperPoint);
      end;
    end
    else if Formula[i] = '=' then // 값이 마지막일시 계산
    begin
      for j := OperPoint - 1 downto 0 do // OperTemp에 남아있는 연산자 모두 꺼내며 계산
      begin
        Formula[HeadPoint] := OperTemp[j];
        Formula[HeadPoint - 2] :=
          FloatToStr(Calc(HeadPoint - 2, HeadPoint - 1, HeadPoint));
        Dec(HeadPoint);
      end;
    end
    else // 값이 숫자면 배열에 입력
    begin
      Formula[HeadPoint] := Formula[i];
      Inc(HeadPoint);
    end;
  end;

  result := Formula[HeadPoint - 1];
end;

function Calc_Stack.Priority(x: string): integer; // 연산자 우선순위
begin
  if (x = '(') or (x = ')') then
  begin
    result := 0;
  end
  else if (x = '+') or (x = '-') then
  begin
    result := 1;
  end
  else if (x = '*') or (x = '/') then
  begin
    result := 2;
  end
  else
    result := -1;
end;

procedure Calc_Stack.ResetPoint; // 배열 포인터 초기화
begin
  FormulaPoint := 0;
end;

end.
