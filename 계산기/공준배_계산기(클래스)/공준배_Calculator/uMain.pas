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
  CheckOp: boolean; // ������ �ߺ��Է�üũ

{$R *.dfm}
  { TMainForm }

procedure TMainForm.BackspaceClick(Sender: TObject); // �� �� �� ����� ��� �ٽ� ���
begin
  if Copy(Num, Length(Num), 1) = '.' then
    n_Dot.Enabled := true;

  Delete(Num, Length(Num), 1);
  Result.Caption := Num;
  Result.SetFocus; // ��ư ��Ŀ�� ����
end;

procedure TMainForm.ClearErrorClick(Sender: TObject); // CE
begin
  n_Dot.Enabled := true;
  Num := '';
  Result.Caption := '';
  Result.SetFocus; // ��ư ��Ŀ�� ����
end;

procedure TMainForm.CheckToggle(Key: string); // ���� �� ȭ�� ���
var
  Temp: string;
begin

  if Num <> '' then // ���� �ֱ�
  begin
    Calc.Input(StrToFloat(Num));
    CheckOp := true;
  end;

  if Key = ')' then // )�� �ٷ��Է�
  begin
    Equation.Caption := Equation.Caption + Num + Key;
    Calc.Input(Key);
    Num := '';
    exit;
  end;

  n_Dot.Enabled := true;
  Temp := Equation.Caption;
  if Copy(Temp, Length(Temp), 1) = '=' then // = �� ������ ������ �ִ� �� ����
    Equation.Caption := '';
  Equation.Caption := Equation.Caption + Num + Key;
  if (Num = '') and not(Key = '(') and not(Key = '=') then
  // ������  �ߺ��Է¹���
  begin
    if Copy(Temp, Length(Temp), 1) <> ')' then // ) �������
    begin
      Temp := Equation.Caption;
      Delete(Temp, Length(Temp) - 1, 1);
      Equation.Caption := Temp;
      exit;
    end;
  end;
  Num := '';

  if (Toggle.ShowHint) and (Calc.GetPoint > 2) then // �Է¼����� ����
  begin
    Result.Caption := FloatToStr(Calc.Calc(0, 2, 1));
    Calc.ResetPoint;
    Calc.Input(Result.Caption);
    // Calc.Input(Key);
    if Pos('.',Result.Caption) <> 0 then // . ��Ȱ��ȭ
      n_Dot.Enabled := false;
    if Key = '=' then
    begin
      Calc.ResetPoint;
      Num := Result.Caption;
    end;
  end
  else if Key = '=' then // ��Ģ����
  begin
    Calc.Input(Key);
    Result.Caption := Calc.Postfix;
    Num := Result.Caption;
    Calc.ResetPoint;
    if Pos('.',Result.Caption) <> 0 then // . ��Ȱ��ȭ
      n_Dot.Enabled := false;
  end;

end;

procedure TMainForm.ClearClick(Sender: TObject); // �ʱ�ȭ
begin
  n_Dot.Enabled := true;
  Result.Caption := '';
  Equation.Caption := '';
  Num := '';
  Calc.ResetPoint;
  Result.SetFocus; // ��ư ��Ŀ�� ����
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Calc.Free;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  Calc := Calc_Stack.Create;
end;

procedure TMainForm.FormKeyPress(Sender: TObject; var Key: Char); // Ű���� �Է½�
var
  Temp: string;
begin
  Temp := Equation.Caption;
  if (Key >= '0') and (Key <= '9') or (Key = '.') then // ���� �� . �Է�
  begin
    if (Key = '.') and n_Dot.Enabled then // . �ߺ�����
    begin
      n_Dot.OnClick(n_Dot);
      exit;
    end
    else if (Key = '.') and not(n_Dot.Enabled) then
      exit;

    if (Calc.GetPoint >= 1) and CheckOp then // ù�Է½� �ΰ��Է� ����
    begin
      Calc.Input(Copy(Temp, Length(Temp), 1));
      CheckOp := false;
    end;
    Num := Num + Key;
    Result.Caption := Num;
  end
  else if (Key >= '(') and (Key <= '/') and not(Key = ',') then // ��Ģ���� �Է�
  begin
    if Toggle.ShowHint and ((Key = '(') or (Key = ')')) then // �Է¼����� ��ȣ ���ϰ�
      exit;
    CheckToggle(Key);
  end
  else if integer(Key) = 13 then // '=' �Է�
  begin

    if (Copy(Temp, Length(Temp), 1) <> '=') and (Temp <> '') then // = �ߺ� �Է� ����
      CheckToggle('=');
  end
  else if integer(Key) = 8 then // �齺���̽� �Է�
  begin
    BackspaceClick(Backspace);
  end;
end;

procedure TMainForm.InputNum(Sender: TObject); // ���� ��ư Ŭ��
var
  Temp: string;
begin
  if (Calc.GetPoint >= 1) and CheckOp then // ù�Է½� �ΰ��Է� ����, ������ �ߺ��Է� ����
  begin
    CheckOp := false;
    Temp := Equation.Caption;
    Calc.Input(Copy(Temp, Length(Temp), 1));
  end;

  Num := Num + IntToStr((Sender as TButton).Tag);
  Result.Caption := Num;
  Result.SetFocus; // ��ư ��Ŀ�� ����
end;

procedure TMainForm.InputOper(Sender: TObject); // ������ ��ư Ŭ��
var
  Oper: string;
  Temp: string;
begin
  Oper := (Sender as TButton).Caption;
  Temp := Equation.Caption;
  if ((Copy(Temp, Length(Temp), 1) <> '=') or (Temp <> '')) then
    // = �ߺ� �Է� ����
    CheckToggle(Oper); // �켱���� üũ �� ����
  Result.SetFocus; // ��ư ��Ŀ�� ����
end;

procedure TMainForm.n_DotClick(Sender: TObject); // . Ŭ��
begin
  n_Dot.Enabled := false;
  if Result.Caption = '' then // . �� �Է½� 0 ����
    Num := '0';
  Num := Num + n_Dot.Caption;
  Result.Caption := Num;
  Result.SetFocus; // ��ư ��Ŀ�� ����
end;

procedure TMainForm.SignClick(Sender: TObject); // ��ȣ �ٲٱ�
var
  Temp: string;
begin
  Temp := Result.Caption;
  try
    Num := FloatToStr(StrToFloat(Temp) * -1);
  except
    ShowMessage('���ڰ� �����ϴ�');
    exit;
  end;
  Result.Caption := Num;
  Result.SetFocus; // ��ư ��Ŀ�� ����
end;

procedure TMainForm.ToggleClick(Sender: TObject); // ������� �ٲٱ�
begin
  Toggle.ShowHint := not Toggle.ShowHint;
  O_Bracket1.Enabled := not O_Bracket1.Enabled;
  O_Bracket2.Enabled := not O_Bracket2.Enabled;
  ClearClick(Clear);
  if Toggle.ShowHint then
  begin
    Toggle.Caption := '�Է¼�';
  end
  else
    Toggle.Caption := '��Ģ����';
  Result.SetFocus; // ��ư ��Ŀ�� ����
end;

end.
