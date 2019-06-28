program Calculator;

uses
  Vcl.Forms,
  UMain in 'UMain.pas' {MainForm},
  Vcl.Themes,
  Vcl.Styles,
  Windows,
  USplash in 'USplash.pas' {SplashForm};

{$R *.res}

begin
	Application.Initialize;
  Application.MainFormOnTaskbar := True;
	TStyleManager.TrySetStyle('Lavender Classico');
	SplashForm := TSplashForm.Create(Application);
	SplashForm.Show;
	SplashForm.Refresh;
	Sleep(1500);
	Application.CreateForm(TMainForm, MainForm);
  SplashForm.Hide;
	SplashForm.Free;

	Application.Run;
end.
