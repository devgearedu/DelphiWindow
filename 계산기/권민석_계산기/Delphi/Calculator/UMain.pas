unit UMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
	Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.UITypes;

type
	TMainForm = class(TForm)
    Edit1: TEdit;
    Btn_Num0: TButton;
    Btn_Num1: TButton;
    Btn_Num2: TButton;
    Btn_Num3: TButton;
    Btn_Minus: TButton;
    Btn_Num7: TButton;
		Btn_Mul: TButton;
    Btn_Num8: TButton;
    Btn_Num9: TButton;
    Btn_Div: TButton;
    Btn_Back: TButton;
		Btn_Num4: TButton;
    Btn_Num5: TButton;
		Btn_Num6: TButton;
    Btn_Point: TButton;
    Btn_Plus: TButton;
		Btn_Result: TButton;
		Btn_Clear: TButton;
		procedure OtherButtonClick(Sender: TObject);			 // 0~9, .(��), backspace, clear ��ư Ŭ��
		procedure OperatorButtonClick(Sender: TObject); 	 // ������ ��ư Ŭ��
		procedure ResultButtonClick(Sender: TObject);			 // =��ư Ŭ��
    procedure FormCreate(Sender: TObject);
	private
		{ Private declarations }
  public
    { Public declarations }
  end;

var
	MainForm: TMainForm;
	operand1: Double;
	operand2: Double;
	operator1: Integer;
	operatorJustPressed: BOOL;
	justCalculated: BOOL;

implementation

{$R *.dfm}

uses USplash;

procedure TMainForm.OtherButtonClick(Sender: TObject);	// 0~9, .(��), backspace, clear ��ư Ŭ��
var
	tag: NativeInt;
begin
	tag := (Sender as TButton).Tag;

	case tag of
		10:	begin  // . Ŭ��
					if Pos('.', Edit1.Text) = 0 then	// .(��)�� �� �� �̻� �Է� ����
						Edit1.Text := Edit1.Text + '.'
				end;
		11:	Edit1.Text := Copy(Edit1.Text, 1, Length(Edit1.Text)-1);	// backspace Ŭ��
		12:	begin  // clear��ư Ŭ��
					Edit1.Text := '';
					operator1 := 0;
				end;
	else  // ���ڹ�ư Ŭ��
		if operatorJustPressed = True then
		begin
			operatorJustPressed := False;
			Edit1.Text := '';
		end;

		Edit1.Text := Edit1.Text + IntToStr(tag);
	end;

	justCalculated := False;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
	operand1 := 0;
	operand2 := 0;
	operator1 := 0;
	operatorJustPressed := False;
	justCalculated := False;
end;

procedure TMainForm.OperatorButtonClick(Sender: TObject); // ������ ��ư Ŭ��
begin
	if (Length(Edit1.Text) = 0) OR (Edit1.Text = '-') then	// �Էµ� ���ڰ� ������ exit
	begin
		if ((Sender as TButton).Tag = 22) then	// -��ư ó��
			Edit1.Text := '-';
		Exit;			
	end;

	if (operator1 >= 21) AND (operator1 <= 24) AND (justCalculated = False) then	// ���������� ó��
		ResultButtonClick(Btn_Result);

	operand1 := StrToFloat(Edit1.Text);
	operator1 := (Sender as TButton).Tag;
	operatorJustPressed := True;
	justCalculated := False;
end;

procedure TMainForm.ResultButtonClick(Sender: TObject);	// =��ư Ŭ��
begin
	if (Length(Edit1.Text) = 0) OR (Edit1.Text = '-') then // �Էµ� ���ڰ� ������ exit
		exit;

	if justCalculated = False then		// �� if���� ������ =�� �����ؼ� �������� ��Ȯ�� ����� �� ��.
		operand2 := StrToFloat(Edit1.Text);

	try
		case operator1 of
			21: Edit1.Text := FloatToStr(operand1 + operand2);
			22: Edit1.Text := FloatToStr(operand1 - operand2);
			23: Edit1.Text := FloatToStr(operand1 * operand2);
			24: Edit1.Text := FloatToStr(operand1 / operand2);
		end;
	except on e:EMathError do
		ShowMessage(e.message);
	end;

	operand1 := StrToFloat(Edit1.Text); // ������ ������ ���� ��� ������� operand1�� ����
	justCalculated := True;
	operatorJustPressed := False;
end;

end.
