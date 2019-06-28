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
void __fastcall TMainForm::OtherButtonClick(TObject *Sender)	// 0~9, .(��), backspace, clear ��ư Ŭ��
{
	int tag = dynamic_cast<TButton*>(Sender)->Tag;

	switch (tag) {
		case 10: // . Ŭ��
				 if ( Pos('.', Edit1->Text) == 0 )
					 Edit1->Text = Edit1->Text + ".";
				 break;
		case 11: // backspace Ŭ��
				 Edit1->Text = Edit1->Text.Delete(Edit1->Text.Length(), 1);
				 break;
		case 12: // clear ��ư
				 Edit1->Text = "";
				 operator1 = 0;
				 break;
	default:	 // ���ڹ�ư Ŭ��
		if (operatorJustPressed == true) {
			operatorJustPressed = false;
			Edit1->Text = "";
		}
		Edit1->Text = Edit1->Text + IntToStr(tag);

	}
	justCalculated = false;
}
//---------------------------------------------------------------------------
void __fastcall TMainForm::OperatorButtonClick(TObject *Sender)	// ������ ��ư Ŭ��
{
	if (Edit1->Text.Length() == 0 || Edit1->Text == "-"){	// �Էµ� ���ڰ� ���� ��
		if (dynamic_cast<TButton*>(Sender)->Tag == 22)	// -��ư ó��
			Edit1->Text = "-";
		return;
	}

	if (operator1 >= 21 && operator1 <= 24 && justCalculated == false)	// ���������� ó��
		ResultButtonClick(dynamic_cast<TButton*>(Sender));

	operand1 = StrToFloat(Edit1->Text);
	operator1 = dynamic_cast<TButton*>(Sender)->Tag;
	operatorJustPressed = true;
	justCalculated = false;
}
//---------------------------------------------------------------------------
void __fastcall TMainForm::ResultButtonClick(TObject *Sender)	// =��ư Ŭ��
{
	if (Edit1->Text.Length() == 0 || Edit1->Text == "-")	// �Էµ� ���ڰ� ���� ��
		return;

	if (justCalculated == false) 	// �� if���� ������ =�� �����ؼ� �������� ��Ȯ�� ����� �� ��.
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

	operand1 = StrToFloat(Edit1->Text);		// ������ ������ ���� ��� ������� operand1�� ����
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
