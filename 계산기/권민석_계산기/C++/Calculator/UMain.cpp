//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "UMain.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
TMainForm *MainForm;
double operand1 = 0;
double operand2 = 0;
int operator1 = 0;
bool operatorJustPressed = false;
bool justCalculated = false;
//---------------------------------------------------------------------------
__fastcall TMainForm::TMainForm(TComponent* Owner)
	: TForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TMainForm::OtherButtonClick(TObject *Sender)	// 0~9, .(점), backspace, clear 버튼 클릭
{
	int tag = dynamic_cast<TButton*>(Sender)->Tag;

	switch (tag) {
		case 10: // . 클릭
				 if ( Pos('.', Edit1->Text) == 0 )
					 Edit1->Text = Edit1->Text + ".";
				 break;
		case 11: // backspace 클릭
				 Edit1->Text = Edit1->Text.Delete(Edit1->Text.Length(), 1);
				 break;
		case 12: // clear 버튼
				 Edit1->Text = "";
				 operator1 = 0;
				 break;
	default:	 // 숫자버튼 클릭
		if (operatorJustPressed == true) {
			operatorJustPressed = false;
			Edit1->Text = "";
		}
		Edit1->Text = Edit1->Text + IntToStr(tag);

	}
	justCalculated = false;
}
//---------------------------------------------------------------------------
void __fastcall TMainForm::OperatorButtonClick(TObject *Sender)	// 연산자 버튼 클릭
{
	if (Edit1->Text.Length() == 0 || Edit1->Text == "-"){	// 입력된 숫자가 없을 때
		if (dynamic_cast<TButton*>(Sender)->Tag == 22)	// -버튼 처리
			Edit1->Text = "-";
		return;
	}

	if (operator1 >= 21 && operator1 <= 24 && justCalculated == false)	// 시퀸스연산 처리
		ResultButtonClick(dynamic_cast<TButton*>(Sender));

	operand1 = StrToFloat(Edit1->Text);
	operator1 = dynamic_cast<TButton*>(Sender)->Tag;
	operatorJustPressed = true;
	justCalculated = false;
}
//---------------------------------------------------------------------------
void __fastcall TMainForm::ResultButtonClick(TObject *Sender)	// =버튼 클릭
{
	if (Edit1->Text.Length() == 0 || Edit1->Text == "-")	// 입력된 숫자가 없을 때
		return;

	if (justCalculated == false) 	// 이 if문이 없으면 =를 연속해서 눌렀을때 정확히 계산이 안 됨.
		operand2 = StrToFloat(Edit1->Text);

	try {
		switch (operator1) {
			case 21: Edit1->Text = FloatToStr(operand1 + operand2); break;
			case 22: Edit1->Text = FloatToStr(operand1 - operand2); break;
			case 23: Edit1->Text = FloatToStr(operand1 * operand2); break;
			case 24: Edit1->Text = FloatToStr(operand1 / operand2); break;
		default: ;
		}
	}
	catch (const EMathError& e) {
		ShowMessage(e.Message);
	}

	operand1 = StrToFloat(Edit1->Text);		// 시퀀스 연산을 위해 계산 결과값을 operand1에 저장
	justCalculated = true;
	operatorJustPressed = false;
}
//---------------------------------------------------------------------------
void __fastcall TMainForm::FormCreate(TObject *Sender)
{
	operand1 = 0;
	operand2 = 0;
	operator1 = 0;
	operatorJustPressed = false;
	justCalculated = false;	
}
//---------------------------------------------------------------------------
