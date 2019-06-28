unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TMainForm = class(TForm)
    n_1: TButton;
    n_2: TButton;
    n_3: TButton;
    n_4: TButton;
    n_5: TButton;
    n_6: TButton;
    n_7: TButton;
    n_8: TButton;
    n_9: TButton;
    n_0: TButton;
    n_Dot: TButton;
    Equal: TButton;
    Clear: TButton;
    O_Add: TButton;
    O_Sub: TButton;
    O_Multi: TButton;
    O_Divide: TButton;
    Toggle: TButton;
    Result: TStaticText;
    Panel: TPanel;
    Equation: TStaticText;
    Backspace: TButton;
    Sign: TButton;
    O_Bracket1: TButton;
    O_Bracket2: TButton;
    ClearError: TButton;
    procedure InputNum(Sender: TObject);
    procedure InputOper(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ToggleClick(Sender: TObject);
    procedure ClearClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure SignClick(Sender: TObject);
    procedure BackspaceClick(Sender: TObject);
    procedure n_DotClick(Sender: TObject);
    procedure ClearErrorClick(Sender: TObject);
  private
    { Private declarations }
    procedure CheckToggle(Key: string);
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

uses uCalc;

var
  Calc: Calc_Stack;
  Num: string;
  CheckOp: boolean; // 연산자 중복입력체크

{$R *.dfm}
  { TMainForm }

procedure TMainForm.BackspaceClick(Sender: TObject); // 맨 뒤 값 지우고 결과 다시 출력
begin
  if Copy(Num, Length(Num), 1) = '.' then
    n_Dot.Enabled := true;

  Delete(Num, Length(Num), 1);
  Result.Caption := Num;
  Result.SetFocus; // 버튼 포커스 해제
end;

procedure TMainForm.ClearErrorClick(Sender: TObject); // CE
begin
  n_Dot.Enabled := true;
  Num := '';
  Result.Caption := '';
  Result.SetFocus; // 버튼 포커스 해제
end;

procedure TMainForm.CheckToggle(Key: string); // 연산 및 화면 출력
var
  Temp: string;
begin

  if Num <> '' then // 숫자 넣기
  begin
    Calc.Input(StrToFloat(Num));
    CheckOp := true;
  end;

  if Key = ')' then // )는 바로입력
  begin
    Equation.Caption := Equation.Caption + Num + Key;
    Calc.Input(Key);
    Num := '';
    exit;
  end;

  n_Dot.Enabled := true;
  Temp := Equation.Caption;
  if Copy(Temp, Length(Temp), 1) = '=' then // = 이 나오면 그전에 있던 식 삭제
    Equation.Caption := '';
  Equation.Caption := Equation.Caption + Num + Key;
  if (Num = '') and not(Key = '(') and not(Key = '=') then
  // 연산자  중복입력방지
  begin
    if Copy(Temp, Length(Temp), 1) <> ')' then // ) 변경방지
    begin
      Temp := Equation.Caption;
      Delete(Temp, Length(Temp) - 1, 1);
      Equation.Caption := Temp;
      exit;
    end;
  end;
  Num := '';

  if (Toggle.ShowHint) and (Calc.GetPoint > 2) then // 입력순으로 연산
  begin
    Result.Caption := FloatToStr(Calc.Calc(0, 2, 1));
    Calc.ResetPoint;
    Calc.Input(Result.Caption);
    // Calc.Input(Key);
    if Pos('.',Result.Caption) <> 0 then // . 비활성화
      n_Dot.Enabled := false;
    if Key = '=' then
    begin
      Calc.ResetPoint;
      Num := Result.Caption;
    end;
  end
  else if Key = '=' then // 사칙연산
  begin
    Calc.Input(Key);
    Result.Caption := Calc.Postfix;
    Num := Result.Caption;
    Calc.ResetPoint;
    if Pos('.',Result.Caption) <> 0 then // . 비활성화
      n_Dot.Enabled := false;
  end;

end;

procedure TMainForm.ClearClick(Sender: TObject); // 초기화
begin
  n_Dot.Enabled := true;
  Result.Caption := '';
  Equation.Caption := '';
  Num := '';
  Calc.ResetPoint;
  Result.SetFocus; // 버튼 포커스 해제
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Calc.Free;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  Calc := Calc_Stack.Create;
end;

procedure TMainForm.FormKeyPress(Sender: TObject; var Key: Char); // 키보드 입력시
var
  Temp: string;
begin
  Temp := Equation.Caption;
  if (Key >= '0') and (Key <= '9') or (Key = '.') then // 숫자 및 . 입력
  begin
    if (Key = '.') and n_Dot.Enabled then // . 중복방지
    begin
      n_Dot.OnClick(n_Dot);
      exit;
    end
    else if (Key = '.') and not(n_Dot.Enabled) then
      exit;

    if (Calc.GetPoint >= 1) and CheckOp then // 첫입력시 널값입력 방지
    begin
      Calc.Input(Copy(Temp, Length(Temp), 1));
      CheckOp := false;
    end;
    Num := Num + Key;
    Result.Caption := Num;
  end
  else if (Key >= '(') and (Key <= '/') and not(Key = ',') then // 사칙연산 입력
  begin
    if Toggle.ShowHint and ((Key = '(') or (Key = ')')) then // 입력순서시 괄호 못하게
      exit;
    CheckToggle(Key);
  end
  else if integer(Key) = 13 then // '=' 입력
  begin

    if (Copy(Temp, Length(Temp), 1) <> '=') and (Temp <> '') then // = 중복 입력 방지
      CheckToggle('=');
  end
  else if integer(Key) = 8 then // 백스페이스 입력
  begin
    BackspaceClick(Backspace);
  end;
end;

procedure TMainForm.InputNum(Sender: TObject); // 숫자 버튼 클릭
var
  Temp: string;
begin
  if (Calc.GetPoint >= 1) and CheckOp then // 첫입력시 널값입력 방지, 연산자 중복입력 방지
  begin
    CheckOp := false;
    Temp := Equation.Caption;
    Calc.Input(Copy(Temp, Length(Temp), 1));
  end;

  Num := Num + IntToStr((Sender as TButton).Tag);
  Result.Caption := Num;
  Result.SetFocus; // 버튼 포커스 해제
end;

procedure TMainForm.InputOper(Sender: TObject); // 연산자 버튼 클릭
var
  Oper: string;
  Temp: string;
begin
  Oper := (Sender as TButton).Caption;
  Temp := Equation.Caption;
  if ((Copy(Temp, Length(Temp), 1) <> '=') or (Temp <> '')) then
    // = 중복 입력 방지
    CheckToggle(Oper); // 우선순위 체크 및 연산
  Result.SetFocus; // 버튼 포커스 해제
end;

procedure TMainForm.n_DotClick(Sender: TObject); // . 클릭
begin
  n_Dot.Enabled := false;
  if Result.Caption = '' then // . 만 입력시 0 붙임
    Num := '0';
  Num := Num + n_Dot.Caption;
  Result.Caption := Num;
  Result.SetFocus; // 버튼 포커스 해제
end;

procedure TMainForm.SignClick(Sender: TObject); // 부호 바꾸기
var
  Temp: string;
begin
  Temp := Result.Caption;
  try
    Num := FloatToStr(StrToFloat(Temp) * -1);
  except
    ShowMessage('숫자가 없습니다');
    exit;
  end;
  Result.Caption := Num;
  Result.SetFocus; // 버튼 포커스 해제
end;

procedure TMainForm.ToggleClick(Sender: TObject); // 연산순서 바꾸기
begin
  Toggle.ShowHint := not Toggle.ShowHint;
  O_Bracket1.Enabled := not O_Bracket1.Enabled;
  O_Bracket2.Enabled := not O_Bracket2.Enabled;
  ClearClick(Clear);
  if Toggle.ShowHint then
  begin
    Toggle.Caption := '입력순';
  end
  else
    Toggle.Caption := '사칙연산';
  Result.SetFocus; // 버튼 포커스 해제
end;

end.
