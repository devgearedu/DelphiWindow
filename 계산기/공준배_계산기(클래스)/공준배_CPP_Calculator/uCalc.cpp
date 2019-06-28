// ---------------------------------------------------------------------------

#pragma hdrstop

#include <System.Character.hpp>
#include <Vcl.Dialogs.hpp>
#include "uCalc.h"
// ---------------------------------------------------------------------------
#pragma package(smart_init)

Calc_Stack::Calc_Stack() {
	FormulaPoint = 0;
	Formula = new String[100];
}

double Calc_Stack::Calc(int x, int y, int Oper) { //연산
	if (IsNumber(Formula[x], 1) && IsNumber(Formula[y], 1)) { // 숫자 아니면 에러

		if (Formula[Oper] == '+') {
			return StrToFloat(Formula[x]) + StrToFloat(Formula[y]);
		}
		else if (Formula[Oper] == '-') {
			return StrToFloat(Formula[x]) - StrToFloat(Formula[y]);
		}
		else if (Formula[Oper] == '*') {
			return StrToFloat(Formula[x]) * StrToFloat(Formula[y]);
		}
		else if (Formula[Oper] == '/') {
			try {
				return StrToFloat(Formula[x]) / StrToFloat(Formula[y]);
			}
			catch (...) {
				ShowMessage("0으로 나눌수 없습니다");

			}
		}

	}
	else
		return 0;

	return 0;
}

int Calc_Stack::Priority(String x) { // 연산자 우선순위

	if (x == '(' || x == ')') {
		return 0;
	}
	else if (x == '+' || x == '-') {
		return 1;
	}
	else if (x == '*' || x == '/') {
		return 2;
	}

	return -1;
}

void Calc_Stack::Input(double num) { // 숫자입력
	Formula[FormulaPoint++] = FloatToStr(num);
}

void Calc_Stack::Input(String Oper) {  // 연산기호 입력
	if (Oper == '(' && !((Formula[FormulaPoint - 1] == '+') || // ( 입력후 앞에 숫자면 * 입력
		(Formula[FormulaPoint - 1] == '-') ||
		(Formula[FormulaPoint - 1] == '*') ||
		(Formula[FormulaPoint - 1] == '/'))) {
		Formula[FormulaPoint++] = "*";
	}
	Formula[FormulaPoint++] = Oper;
}

String Calc_Stack::Postfix() { // 중위 -> 후위 표기 변경 및 연산
	String OperTemp[20];
	int OperPoint = 0;
	int HeadPoint = 0;
	int i, j;

	for (int i = 0; i < FormulaPoint; i++) {

		if (Formula[i] >= '(' && Formula[i] <= '/') {
		//값이 연산기호일시 우선순위 비교 후 배열에 입력
			if (OperPoint >= 1) {
				if (Formula[i] == '(') {
					// 아무것도 하지않음  ( 입력
				}
				else if (Formula[i] == ')') {

					while (true) { // ( 만날때까지 꺼내면서 연산
						OperPoint--;
						if (OperTemp[OperPoint] == '(') {
							break;
						}

						Formula[HeadPoint] = OperTemp[OperPoint];
						Formula[HeadPoint - 2] =
							FloatToStr(Calc(HeadPoint - 2, HeadPoint - 1,
							HeadPoint));
						HeadPoint--;

					}

				}
				else if (Priority(OperTemp[OperPoint - 1]) >=
					Priority(Formula[i])) {
					// 연산자 우선순위에 의해 스택에서 값 꺼내고 바로 연산

					OperPoint--;
					Formula[HeadPoint] = OperTemp[OperPoint];
					Formula[HeadPoint - 2] =
						FloatToStr(Calc(HeadPoint - 2, HeadPoint - 1,
						HeadPoint));
					HeadPoint--;

				}
			}
			if (Formula[i] != ')') {  // ) 가 아닌 연산자 OperTemp에서 대기
				OperTemp[OperPoint] = Formula[i];
				OperPoint++;
			}
		}
		else if (Formula[i] == '=') { // 값이 마지막일시 계산
			for (int j = OperPoint - 1; j >= 0; j--) { // OperTemp에 남아있는 연산자 모두 꺼내며 연산
				Formula[HeadPoint] = OperTemp[j];
				Formula[HeadPoint - 2] =
					FloatToStr(Calc(HeadPoint - 2, HeadPoint - 1, HeadPoint));
				HeadPoint--;
			}
		}
		else { // 값이 숫자면 배열에 입력
			Formula[HeadPoint] = Formula[i];
			HeadPoint++;
		}
	}
	return Formula[HeadPoint - 1];
}
