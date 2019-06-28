//---------------------------------------------------------------------------

#ifndef uCalcH
#define uCalcH
#include <System.hpp>
#include <sysmac.h>
//---------------------------------------------------------------------------
#endif



class Calc_Stack{
private:
	String *Formula;
	int FormulaPoint;
public:
	Calc_Stack();
	double Calc(int x, int y, int Oper);
	int Priority(String x);
	int GetPoint(){return FormulaPoint; };
	String Postfix();
	void ResetPoint(){ FormulaPoint = 0; };
	void Input(double num);
	void Input(String Oper);
};