unit UCalculator;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TCalculator_Form = class(TForm)
    CalcEdit: TEdit;
    PadBtnBack: TButton;
    PadBtnCe: TButton;
    PadBtnC: TButton;
    PadBtnNum7: TButton;
    PadBtnNum8: TButton;
    PadBtnPlus: TButton;
    PadBtnNum4: TButton;
    PadBtnNum5: TButton;
    PadBtnNum9: TButton;
    PadBtnNum1: TButton;
    PadBtnNum2: TButton;
    PadBtnNum6: TButton;
    PadBtnNum0: TButton;
    PadBtnDot: TButton;
    PadBtnNum3: TButton;
    PadBtnMin: TButton;
    PadBtnMul: TButton;
    PadBtnDiv: TButton;
    PadBtnEqual: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure PadBtnBackClick(Sender: TObject);
    procedure PadBtnCClick(Sender: TObject);
    procedure PadBtnNum0Click(Sender: TObject);
    procedure PadBtnEqualClick(Sender: TObject);
    procedure PadBtnPlusClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Calculator_Form: TCalculator_Form;

  CalcBool:Boolean;   // 새로 입력인지 아닌지  true는 연속 false는 새로
  TmpCalc:Double;    // 이전 데이터 임시 저장
  CalcType:integer;   // 연산자를 구분


implementation

{$R *.dfm}

procedure TCalculator_Form.FormCreate(Sender: TObject);
begin
  CalcBool := True;
  CalcType := 0;
end;

procedure TCalculator_Form.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    8:    PadBtnBackClick(PadBtnBack);  //백스페이스
    27:   PadBtnCClick(PadBtnC);     // Esc
    46:   PadBtnCClick(PadBtnCE);   //Delete
    190:  PadBtnNum0Click(PadBtnDot); // . 키

    13:   PadBtnEqualClick(PadBtnEqual);

  end;
end;

procedure TCalculator_Form.PadBtnBackClick(Sender: TObject);
var
  S: string;
  L: integer;
begin
  // Backspace 키를 누를때 오른쪽부터 한글자씩 지워야 함.
  if CalcEdit.Text <> '' then
  begin
    S := CalcEdit.Text;
    L := Length(CalcEdit.Text);
    Delete(S, L, 1); // 글자수 구해서 오른쪽부터 1글자씩 지우기
    if S = '' then
      S := '0';
    CalcEdit.Text := S;
  end;
end;

procedure TCalculator_Form.PadBtnCClick(Sender: TObject);
begin
  CalcEdit.Text := '0';
  CalcType := 0;
end;

procedure TCalculator_Form.PadBtnNum0Click(Sender: TObject);
begin
  // False일때는 값을 초기화 하고 입력받음. (연산 버튼을 누른 후)
  if CalcBool = False then
  begin
    CalcEdit.Text := '0';
    CalcBool := True;
  end;

    // .(소숫점)을 누를때
  if (ActiveControl.Tag = 10) then
    CalcEdit.Text := CalcEdit.Text + '.'

  else

  // 1~9번 버튼의 Tag값에 각각 해당되는 숫자값을 넣기.
  begin
    if (CalcEdit.Text = '0') then
      CalcEdit.Text := '';
    CalcEdit.Text := CalcEdit.Text + IntToStr(ActiveControl.Tag);
  end;

  PadBtnEqual.SetFocus;

end;

procedure TCalculator_Form.PadBtnPlusClick(Sender: TObject);
begin
  begin

  // 기존값을 임시변수에 저장
  TmpCalc := StrToFloat(CalcEdit.Text);

  // 값을 추가로 안 적히게 False로 변경
  CalcBool := False;

  // 더하기, 빼기, 곱하기, 나누기 값을 넣기
  case ActiveControl.Tag of
    11:
      CalcType := 11; // 더하기
    12:
      CalcType := 12; // 빼기
    13:
      CalcType := 13; // 곱하기
    14:
      CalcType := 14; // 나누기
  end;

    CalcEdit.SetFocus;
    CalcEdit.SelectAll;

end;
end;

procedure TCalculator_Form.PadBtnEqualClick(Sender: TObject);
var
  TmpCalcValue: Double;
begin
  case CalcType of
    11:
      TmpCalcValue := TmpCalc + StrToFloat(CalcEdit.Text);
    12:
      TmpCalcValue := TmpCalc - StrToFloat(CalcEdit.Text);
    13:
      TmpCalcValue := TmpCalc * StrToFloat(CalcEdit.Text);
    14:
      TmpCalcValue := TmpCalc / StrToFloat(CalcEdit.Text);
  end;

  if (CalcType > 10) and (CalcType < 15) then
      CalcEdit.Text := FloatToStr(TmpCalcValue);

  // 계산이 끝난 후 다시 새로 작성되도록.
  CalcBool := False;
    CalcEdit.SetFocus;
    CalcEdit.SelectAll;
end;

end.
