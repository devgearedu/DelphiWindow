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

  CalcBool:Boolean;   // ���� �Է����� �ƴ���  true�� ���� false�� ����
  TmpCalc:Double;    // ���� ������ �ӽ� ����
  CalcType:integer;   // �����ڸ� ����


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
    8:    PadBtnBackClick(PadBtnBack);  //�齺���̽�
    27:   PadBtnCClick(PadBtnC);     // Esc
    46:   PadBtnCClick(PadBtnCE);   //Delete
    190:  PadBtnNum0Click(PadBtnDot); // . Ű

    13:   PadBtnEqualClick(PadBtnEqual);

  end;
end;

procedure TCalculator_Form.PadBtnBackClick(Sender: TObject);
var
  S: string;
  L: integer;
begin
  // Backspace Ű�� ������ �����ʺ��� �ѱ��ھ� ������ ��.
  if CalcEdit.Text <> '' then
  begin
    S := CalcEdit.Text;
    L := Length(CalcEdit.Text);
    Delete(S, L, 1); // ���ڼ� ���ؼ� �����ʺ��� 1���ھ� �����
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
  // False�϶��� ���� �ʱ�ȭ �ϰ� �Է¹���. (���� ��ư�� ���� ��)
  if CalcBool = False then
  begin
    CalcEdit.Text := '0';
    CalcBool := True;
  end;

    // .(�Ҽ���)�� ������
  if (ActiveControl.Tag = 10) then
    CalcEdit.Text := CalcEdit.Text + '.'

  else

  // 1~9�� ��ư�� Tag���� ���� �ش�Ǵ� ���ڰ��� �ֱ�.
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

  // �������� �ӽú����� ����
  TmpCalc := StrToFloat(CalcEdit.Text);

  // ���� �߰��� �� ������ False�� ����
  CalcBool := False;

  // ���ϱ�, ����, ���ϱ�, ������ ���� �ֱ�
  case ActiveControl.Tag of
    11:
      CalcType := 11; // ���ϱ�
    12:
      CalcType := 12; // ����
    13:
      CalcType := 13; // ���ϱ�
    14:
      CalcType := 14; // ������
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

  // ����� ���� �� �ٽ� ���� �ۼ��ǵ���.
  CalcBool := False;
    CalcEdit.SetFocus;
    CalcEdit.SelectAll;
end;

end.
