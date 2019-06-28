//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop
#include <tchar.h>
//---------------------------------------------------------------------------
#include <Vcl.Styles.hpp>
#include <Vcl.Themes.hpp>
USEFORM("uMain.cpp", Form1);
USEFORM("Usplash.cpp", SplashForm);
//---------------------------------------------------------------------------
#include "Usplash.h"
//---------------------------------------------------------------------------
int WINAPI _tWinMain(HINSTANCE, HINSTANCE, LPTSTR, int)
{
	try
	{
		Application->Initialize();
		Application->MainFormOnTaskBar = true;
		TStyleManager::TrySetStyle("Turquoise Gray");
		SplashForm = new TSplashForm(Application);
		SplashForm->Show();
		SplashForm->Update();
		Sleep(2000);
		Application->CreateForm(__classid(TForm1), &Form1);
		SplashForm->Hide();
		SplashForm->Free();
		Application->Run();
	}
	catch (Exception &exception)
	{
		Application->ShowException(&exception);
	}
	catch (...)
	{
		try
		{
			throw Exception("");
		}
		catch (Exception &exception)
		{
			Application->ShowException(&exception);
		}
	}
	return 0;
}
//---------------------------------------------------------------------------
