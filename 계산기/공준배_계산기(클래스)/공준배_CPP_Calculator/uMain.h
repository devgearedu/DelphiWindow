//---------------------------------------------------------------------------

#ifndef uMainH
#define uMainH
//---------------------------------------------------------------------------
#include <System.Classes.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.Forms.hpp>
#include <System.hpp>
#include <sysmac.h>
#include <Vcl.ExtCtrls.hpp>
//---------------------------------------------------------------------------
class TForm1 : public TForm
{
__published:	// IDE-managed Components
	TButton *Backspace;
	TButton *n_7;
	TButton *n_Dot;
	TStaticText *Result;
	TStaticText *Equation;
	TButton *n_4;
	TButton *n_8;
	TButton *n_5;
	TButton *n_9;
	TButton *n_6;
	TButton *n_0;
	TButton *n_1;
	TButton *n_2;
	TButton *n_3;
	TButton *Sign;
	TButton *ClearError;
	TButton *O_Bracket1;
	TButton *O_Bracket2;
	TButton *O_Add;
	TButton *O_Multi;
	TButton *O_Divide;
	TButton *O_Sub;
	TButton *Clear;
	TButton *Equal;
	TButton *Toggle;
	TPanel *Panel;
	void __fastcall BackspaceClick(TObject *Sender);
	void __fastcall InputNum(TObject *Sender);
	void __fastcall InputOper(TObject *Sender);
	void __fastcall FormCreate(TObject *Sender);
	void __fastcall ClearErrorClick(TObject *Sender);
	void __fastcall ClearClick(TObject *Sender);
	void __fastcall n_DotClick(TObject *Sender);
	void __fastcall ToggleClick(TObject *Sender);
	void __fastcall SignClick(TObject *Sender);
	void __fastcall FormClose(TObject *Sender, TCloseAction &Action);
	void __fastcall FormKeyPress(TObject *Sender, System::WideChar &Key);
private:	// User declarations
    void CheckToggle(String Key);
public:		// User declarations
	String num;
	__fastcall TForm1(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TForm1 *Form1;
//---------------------------------------------------------------------------
#endif
