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

double Calc_Stack::Calc(int x, int y, int Oper) { //����
	if (IsNumber(Formula[x], 1) && IsNumber(Formula[y], 1)) { // ���� �ƴϸ� ����

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
				ShowMessage("0���� ������ �����ϴ�");

			}
		}

	}
	else
		return 0;

	return 0;
}

int Calc_Stack::Priority(String x) { // ������ �켱����

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

void Calc_Stack::Input(double num) { // �����Է�
	Formula[FormulaPoint++] = FloatToStr(num);
}

void Calc_Stack::Input(String Oper) {  // �����ȣ �Է�
	if (Oper == '(' && !((Formula[FormulaPoint - 1] == '+') || // ( �Է��� �տ� ���ڸ� * �Է�
		(Formula[FormulaPoint - 1] == '-') ||
		(Formula[FormulaPoint - 1] == '*') ||
		(Formula[FormulaPoint - 1] == '/'))) {
		Formula[FormulaPoint++] = "*";
	}
	Formula[FormulaPoint++] = Oper;
}

String Calc_Stack::Postfix() { // ���� -> ���� ǥ�� ���� �� ����
	String OperTemp[20];
	int OperPoint = 0;
	int HeadPoint = 0;
	int i, j;

	for (int i = 0; i < FormulaPoint; i++) {

		if (Formula[i] >= '(' && Formula[i] <= '/') {
		//���� �����ȣ�Ͻ� �켱���� �� �� �迭�� �Է�
			if (OperPoint >= 1) {
				if (Formula[i] == '(') {
					// �ƹ��͵� ��������  ( �Է�
				}
				else if (Formula[i] == ')') {

					while (true) { // ( ���������� �����鼭 ����
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
					// ������ �켱������ ���� ���ÿ��� �� ������ �ٷ� ����

					OperPoint--;
					Formula[HeadPoint] = OperTemp[OperPoint];
					Formula[HeadPoint - 2] =
						FloatToStr(Calc(HeadPoint - 2, HeadPoint - 1,
						HeadPoint));
					HeadPoint--;

				}
			}
			if (Formula[i] != ')') {  // ) �� �ƴ� ������ OperTemp���� ���
				OperTemp[OperPoint] = Formula[i];
				OperPoint++;
			}
		}
		else if (Formula[i] == '=') { // ���� �������Ͻ� ���
			for (int j = OperPoint - 1; j >= 0; j--) { // OperTemp�� �����ִ� ������ ��� ������ ����
				Formula[HeadPoint] = OperTemp[j];
				Formula[HeadPoint - 2] =
					FloatToStr(Calc(HeadPoint - 2, HeadPoint - 1, HeadPoint));
				HeadPoint--;
			}
		}
		else { // ���� ���ڸ� �迭�� �Է�
			Formula[HeadPoint] = Formula[i];
			HeadPoint++;
		}
	}
	return Formula[HeadPoint - 1];
}
