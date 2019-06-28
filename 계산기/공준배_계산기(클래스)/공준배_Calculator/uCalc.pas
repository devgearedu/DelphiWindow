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

function Calc_Stack.Calc(x, y, Oper: integer): real; // ����
begin
  if isnumber(Formula[x],1) and isnumber(Formula[y],1) then //���� �ƴϸ� ����
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
        raise Exception.Create('0���� ���� �� �����ϴ�');
      end;
  end
  else
  begin
    result := 0;
    raise Exception.Create('�߸��� �����Դϴ�');
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

procedure Calc_Stack.Input(Num: real); // ���� �Է�
begin
  Formula[FormulaPoint] := FloatToStr(Num);
  Inc(FormulaPoint);
end;

procedure Calc_Stack.Input(Oper: string); // �����ȣ �Է�
begin
  if (Oper = '(') and not((Formula[FormulaPoint - 1] = '+') or
    // ( �Է��� �տ� ���ڸ� * �Է�
    (Formula[FormulaPoint - 1] = '-') or (Formula[FormulaPoint - 1] = '*') or
    (Formula[FormulaPoint - 1] = '/')) then
  begin
    Formula[FormulaPoint] := '*';
    Inc(FormulaPoint);
  end;
  Formula[FormulaPoint] := Oper;
  Inc(FormulaPoint);
end;

function Calc_Stack.Point: integer; // ��ġ��ȯ
begin
  result := FormulaPoint;
end;

function Calc_Stack.Postfix: string; // ���� -> ���� ǥ�� ���� �� ����
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
    // ���� �����ȣ�Ͻ� �켱���� �� �� �迭�� �Է�
    begin
      if OperPoint >= 1 then
      begin
        if Formula[i] = '(' then
        //�ƹ��͵��������� ( �Է�
        else if Formula[i] = ')' then
        begin
          while True do // ( ���������� �����鼭 ����
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
        // ������ �켱������ ���� ���ÿ��� �� ������ �ٷ� ����
        begin
          Dec(OperPoint);
          Formula[HeadPoint] := OperTemp[OperPoint];
          Formula[HeadPoint - 2] :=
            FloatToStr(Calc(HeadPoint - 2, HeadPoint - 1, HeadPoint));
          Dec(HeadPoint);
        end;

      end;
      if Formula[i] <> ')' then // ) �� �ƴ� ������ OperTemp���� ���
      begin
        OperTemp[OperPoint] := Formula[i];
        Inc(OperPoint);
      end;
    end
    else if Formula[i] = '=' then // ���� �������Ͻ� ���
    begin
      for j := OperPoint - 1 downto 0 do // OperTemp�� �����ִ� ������ ��� ������ ���
      begin
        Formula[HeadPoint] := OperTemp[j];
        Formula[HeadPoint - 2] :=
          FloatToStr(Calc(HeadPoint - 2, HeadPoint - 1, HeadPoint));
        Dec(HeadPoint);
      end;
    end
    else // ���� ���ڸ� �迭�� �Է�
    begin
      Formula[HeadPoint] := Formula[i];
      Inc(HeadPoint);
    end;
  end;

  result := Formula[HeadPoint - 1];
end;

function Calc_Stack.Priority(x: string): integer; // ������ �켱����
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

procedure Calc_Stack.ResetPoint; // �迭 ������ �ʱ�ȭ
begin
  FormulaPoint := 0;
end;

end.
