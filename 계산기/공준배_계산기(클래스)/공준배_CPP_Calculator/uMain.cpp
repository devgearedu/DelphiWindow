// ---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "uMain.h"
#include "uCalc.h"
// ---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
TForm1 *Form1;
Calc_Stack *Calc;
bool CheckOp;  //������ �ߺ��Է� üũ

// ---------------------------------------------------------------------------
__fastcall TForm1::TForm1(TComponent* Owner) : TForm(Owner) {
}

// ---------------------------------------------------------------------------
void __fastcall TForm1::BackspaceClick(TObject *Sender) { // �� �� �� ����� ��� �ٽ� ���
	if (num.SubString(num.Length(), 1) == ".") {
		n_Dot->Enabled = true;
	}

	num.Delete(num.Length(), 1);
	Result->Caption = num;
	Result->SetFocus();    //��ư ��Ŀ�� ����
}

// ---------------------------------------------------------------------------
void __fastcall TForm1::FormCreate(TObject *Sender) {
	Calc = new Calc_Stack;
}

// ---------------------------------------------------------------------------
void __fastcall TForm1::InputNum(TObject *Sender) {  //���� ��ư Ŭ��
	String temp;

	if (Calc->GetPoint() >= 1 && CheckOp) { //ù �Է½� �ΰ��Է¹���, ������ �ߺ��Է� ����
		CheckOp = false;
		temp = Equation->Caption;
		Calc->Input(num.SubString(num.Length(), 1));
	}
	num = num + IntToStr(dynamic_cast<TButton*>(Sender)->Tag);
	Result->Caption = num;
	Result->SetFocus();     // ��ư ��Ŀ�� ����
}

// ---------------------------------------------------------------------------
void __fastcall TForm1::ClearErrorClick(TObject *Sender) { // CE
	n_Dot->Enabled = true;
	num = "";
	Result->Caption = "";
	Result->SetFocus();	//��ư ��Ŀ�� ����
}
// ---------------------------------------------------------------------------

void __fastcall TForm1::ClearClick(TObject *Sender) { // �ʱ�ȭ
	n_Dot->Enabled = true;
	num = "";
	Result->Caption = "";
	Equation->Caption = "";
	Calc->ResetPoint();
	Result->SetFocus();  //��ư ��Ŀ�� ����
}

// ---------------------------------------------------------------------------

void __fastcall TForm1::InputOper(TObject *Sender) { // ������ ��ư Ŭ��
	String Oper;
	String temp;

	Oper = dynamic_cast<TButton*>(Sender)->Caption;
	temp = Equation->Caption;
	if (temp.SubString(temp.Length(), 1) != "=" || temp != "") { // = �ߺ� �Է� ����
		CheckToggle(Oper); // �켱���� üũ �� ����
	}
	Result->SetFocus(); // ��ư ��Ŀ�� ����
}

// ---------------------------------------------------------------------------

void TForm1::CheckToggle(String Key) { //���� �� ȭ�� ���
	String temp;

	if (num != "") { // ���� �ֱ�
		Calc->Input(StrToFloat(num));
		CheckOp = true;
	}

	if (Key == ")") { // )�� �ٷ� �Է�
		Equation->Caption = Equation->Caption + num + Key;
		Calc->Input(Key);
		num = "";
		return;
	}

	n_Dot->Enabled = true;
	temp = Equation->Caption;

	if (temp.SubString(temp.Length(), 1) == "=") { // = �� ������ ������ �ִ� �� ����
		Equation->Caption = "";
	}
	Equation->Caption = Equation->Caption + num + Key;

	if (num == "" && !(Key == "(") && !(Key == ")")) { //������ �ߺ��Է¹���
		if (temp.SubString(temp.Length(), 1) != ")") { // ) �������
			temp = Equation->Caption;
			temp.Delete(temp.Length() - 1, 1);
			Equation->Caption = temp;
			return;
		}

	}

	num = "";

	if (Toggle->ShowHint && Calc->GetPoint() > 2) { // �Է¼����� ����
		Result->Caption = FloatToStr(Calc->Calc(0, 2, 1));
		Calc->ResetPoint();
		Calc->Input(Result->Caption);
		if (Pos(".", Result->Caption, 1) != 0) { // . ��Ȱ��ȭ
			n_Dot->Enabled = false;
		}

		if (Key == "=") {
			Calc->ResetPoint();
			num = Result->Caption;
		}
	}
	else if (Key == "=") {  // ��Ģ����
		Calc->Input(Key);
		Result->Caption = Calc->Postfix();
		num = Result->Caption;
		Calc->ResetPoint();
		if (Pos(".", Result->Caption, 1) != 0) { // . ��Ȱ��ȭ
			n_Dot->Enabled = false;
		}
	}

}

// ---------------------------------------------------------------------------

void __fastcall TForm1::n_DotClick(TObject *Sender) { // . Ŭ��
	n_Dot->Enabled = false;
	if (Result->Caption == "") { // . �� �Է½� 0 ����
		num = "0";
	}
	num = num + n_Dot->Caption;
	Result->Caption = num;
	Result->SetFocus(); // ��ư ��Ŀ�� ����
}
// ---------------------------------------------------------------------------

void __fastcall TForm1::ToggleClick(TObject *Sender) {  //������� �ٲٱ�
	Toggle->ShowHint = !Toggle->ShowHint;
	O_Bracket1->Enabled = !O_Bracket1->Enabled;
	O_Bracket2->Enabled = !O_Bracket2->Enabled;
	ClearClick(Clear);
	if (Toggle->ShowHint) {
		Toggle->Caption = "�Է¼�";
	}
	else
		Toggle->Caption = "��Ģ����";
	Result->SetFocus();
}

// ---------------------------------------------------------------------------
void __fastcall TForm1::SignClick(TObject *Sender) { //��ȣ �ٲٱ�
	String temp = Result->Caption;
	try {
		num = FloatToStr(StrToFloat(temp)*-1);
	}
	catch (...) {
		ShowMessage("���ڰ� �����ϴ�");
		return;
	}
	Result->Caption = num;
	Result->SetFocus();
}
// ---------------------------------------------------------------------------

void __fastcall TForm1::FormClose(TObject *Sender, TCloseAction &Action) {
	delete Calc;
}
// ---------------------------------------------------------------------------

void __fastcall TForm1::FormKeyPress(TObject *Sender, System::WideChar &Key) { //Ű���� �Է½�
	String PressK = Key;
	String temp = Equation->Caption;
	if (PressK >= '0' && PressK <= '9' || PressK == '.') { // ���� �� . �Է�
		if (PressK == '.' && n_Dot->Enabled) { // . �ߺ� ����
			n_Dot->OnClick;
			return;
		}
		else if (PressK == '.' && !n_Dot->Enabled) {
			return;
		}

		if (Calc->GetPoint() >= 1 && CheckOp) { // ù�Է½� �ΰ��Է� ����
			Calc->Input(temp.SubString(temp.Length(), 1));
			CheckOp = false;
		}
		num = num + PressK;
		Result->Caption = num;
	}
	else if (PressK >= '(' && PressK <= '/' && !(PressK == ',')) {  //��Ģ���� �Է�
		if (Toggle->ShowHint && (PressK == '(' || PressK == ')')) { // �Է¼����� ��ȣ ���ϰ�
			return;
		}
		CheckToggle(PressK);
	}
	else if (int(Key) == 13) { // '=' �Է�
		if (temp.SubString(temp.Length(), 1) != "=" && temp != "") { // = �ߺ� �Է� ����
			CheckToggle("=");
		}
	}
	else if (int(Key) == 8) { // �齺���̽� �Է�
		BackspaceClick(Backspace);

	}
}
// ---------------------------------------------------------------------------
