//---------------------------------------------------------------------------

#ifndef UMainH
#define UMainH
//---------------------------------------------------------------------------
#include <System.Classes.hpp>
#include <System.SysUtils.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.Forms.hpp>
//---------------------------------------------------------------------------
class TMainForm : public TForm
{
__published:	// IDE-managed Components
	TEdit *Edit1;
	TButton *Btn_Num0;
	TButton *Btn_Num1;
	TButton *Btn_Num2;
	TButton *Btn_Num3;
	TButton *Btn_Minus;
	TButton *Btn_Num7;
	TButton *Btn_Mul;
	TButton *Btn_Num8;
	TButton *Btn_Num9;
	TButton *Btn_Div;
	TButton *Btn_Back;
	TButton *Btn_Num4;
	TButton *Btn_Num5;
	TButton *Btn_Num6;
	TButton *Btn_Point;
	TButton *Btn_Plus;
	TButton *Btn_Result;
	TButton *Btn_Clear;
	void __fastcall OtherButtonClick(TObject *Sender);
	void __fastcall OperatorButtonClick(TObject *Sender);
	void __fastcall ResultButtonClick(TObject *Sender);
	void __fastcall FormCreate(TObject *Sender);
private:	// User declarations
	double operand1;
	double operand2;
	int operator1;
	bool operatorJustPressed;
	bool justCalculated;
public:		// User declarations
	__fastcall TMainForm(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TMainForm *MainForm;
//---------------------------------------------------------------------------
#endif
