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
bool CheckOp;  //연산자 중복입력 체크

// ---------------------------------------------------------------------------
__fastcall TForm1::TForm1(TComponent* Owner) : TForm(Owner) {
}

// ---------------------------------------------------------------------------
void __fastcall TForm1::BackspaceClick(TObject *Sender) { // 맨 뒤 값 지우고 결과 다시 출력
	if (num.SubString(num.Length(), 1) == ".") {
		n_Dot->Enabled = true;
	}

	num.Delete(num.Length(), 1);
	Result->Caption = num;
	Result->SetFocus();    //버튼 포커스 해제
}

// ---------------------------------------------------------------------------
void __fastcall TForm1::FormCreate(TObject *Sender) {
	Calc = new Calc_Stack;
}

// ---------------------------------------------------------------------------
void __fastcall TForm1::InputNum(TObject *Sender) {  //숫자 버튼 클릭
	String temp;

	if (Calc->GetPoint() >= 1 && CheckOp) { //첫 입력시 널값입력방지, 연산자 중복입력 방지
		CheckOp = false;
		temp = Equation->Caption;
		Calc->Input(num.SubString(num.Length(), 1));
	}
	num = num + IntToStr(dynamic_cast<TButton*>(Sender)->Tag);
	Result->Caption = num;
	Result->SetFocus();     // 버튼 포커스 해제
}

// ---------------------------------------------------------------------------
void __fastcall TForm1::ClearErrorClick(TObject *Sender) { // CE
	n_Dot->Enabled = true;
	num = "";
	Result->Caption = "";
	Result->SetFocus();	//버튼 포커스 해제
}
// ---------------------------------------------------------------------------

void __fastcall TForm1::ClearClick(TObject *Sender) { // 초기화
	n_Dot->Enabled = true;
	num = "";
	Result->Caption = "";
	Equation->Caption = "";
	Calc->ResetPoint();
	Result->SetFocus();  //버튼 포커스 해제
}

// ---------------------------------------------------------------------------

void __fastcall TForm1::InputOper(TObject *Sender) { // 연산자 버튼 클릭
	String Oper;
	String temp;

	Oper = dynamic_cast<TButton*>(Sender)->Caption;
	temp = Equation->Caption;
	if (temp.SubString(temp.Length(), 1) != "=" || temp != "") { // = 중복 입력 방지
		CheckToggle(Oper); // 우선순위 체크 및 연산
	}
	Result->SetFocus(); // 버튼 포커스 해제
}

// ---------------------------------------------------------------------------

void TForm1::CheckToggle(String Key) { //연산 및 화면 출력
	String temp;

	if (num != "") { // 숫자 넣기
		Calc->Input(StrToFloat(num));
		CheckOp = true;
	}

	if (Key == ")") { // )는 바로 입력
		Equation->Caption = Equation->Caption + num + Key;
		Calc->Input(Key);
		num = "";
		return;
	}

	n_Dot->Enabled = true;
	temp = Equation->Caption;

	if (temp.SubString(temp.Length(), 1) == "=") { // = 이 나오면 그전에 있던 식 삭제
		Equation->Caption = "";
	}
	Equation->Caption = Equation->Caption + num + Key;

	if (num == "" && !(Key == "(") && !(Key == ")")) { //연산자 중복입력방지
		if (temp.SubString(temp.Length(), 1) != ")") { // ) 변경방지
			temp = Equation->Caption;
			temp.Delete(temp.Length() - 1, 1);
			Equation->Caption = temp;
			return;
		}

	}

	num = "";

	if (Toggle->ShowHint && Calc->GetPoint() > 2) { // 입력순으로 연산
		Result->Caption = FloatToStr(Calc->Calc(0, 2, 1));
		Calc->ResetPoint();
		Calc->Input(Result->Caption);
		if (Pos(".", Result->Caption, 1) != 0) { // . 비활성화
			n_Dot->Enabled = false;
		}

		if (Key == "=") {
			Calc->ResetPoint();
			num = Result->Caption;
		}
	}
	else if (Key == "=") {  // 사칙연산
		Calc->Input(Key);
		Result->Caption = Calc->Postfix();
		num = Result->Caption;
		Calc->ResetPoint();
		if (Pos(".", Result->Caption, 1) != 0) { // . 비활성화
			n_Dot->Enabled = false;
		}
	}

}

// ---------------------------------------------------------------------------

void __fastcall TForm1::n_DotClick(TObject *Sender) { // . 클릭
	n_Dot->Enabled = false;
	if (Result->Caption == "") { // . 만 입력시 0 붙임
		num = "0";
	}
	num = num + n_Dot->Caption;
	Result->Caption = num;
	Result->SetFocus(); // 버튼 포커스 해제
}
// ---------------------------------------------------------------------------

void __fastcall TForm1::ToggleClick(TObject *Sender) {  //연산순서 바꾸기
	Toggle->ShowHint = !Toggle->ShowHint;
	O_Bracket1->Enabled = !O_Bracket1->Enabled;
	O_Bracket2->Enabled = !O_Bracket2->Enabled;
	ClearClick(Clear);
	if (Toggle->ShowHint) {
		Toggle->Caption = "입력순";
	}
	else
		Toggle->Caption = "사칙연산";
	Result->SetFocus();
}

// ---------------------------------------------------------------------------
void __fastcall TForm1::SignClick(TObject *Sender) { //부호 바꾸기
	String temp = Result->Caption;
	try {
		num = FloatToStr(StrToFloat(temp)*-1);
	}
	catch (...) {
		ShowMessage("숫자가 없습니다");
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

void __fastcall TForm1::FormKeyPress(TObject *Sender, System::WideChar &Key) { //키보드 입력시
	String PressK = Key;
	String temp = Equation->Caption;
	if (PressK >= '0' && PressK <= '9' || PressK == '.') { // 숫자 및 . 입력
		if (PressK == '.' && n_Dot->Enabled) { // . 중복 방지
			n_Dot->OnClick;
			return;
		}
		else if (PressK == '.' && !n_Dot->Enabled) {
			return;
		}

		if (Calc->GetPoint() >= 1 && CheckOp) { // 첫입력시 널값입력 방지
			Calc->Input(temp.SubString(temp.Length(), 1));
			CheckOp = false;
		}
		num = num + PressK;
		Result->Caption = num;
	}
	else if (PressK >= '(' && PressK <= '/' && !(PressK == ',')) {  //사칙연산 입력
		if (Toggle->ShowHint && (PressK == '(' || PressK == ')')) { // 입력순서시 괄호 못하게
			return;
		}
		CheckToggle(PressK);
	}
	else if (int(Key) == 13) { // '=' 입력
		if (temp.SubString(temp.Length(), 1) != "=" && temp != "") { // = 중복 입력 방지
			CheckToggle("=");
		}
	}
	else if (int(Key) == 8) { // 백스페이스 입력
		BackspaceClick(Backspace);

	}
}
// ---------------------------------------------------------------------------
