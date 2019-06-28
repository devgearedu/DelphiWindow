program Calculator;

uses
  Vcl.Forms, System.SysUtils,
  uMain in 'uMain.pas' {MainForm},
  uCalc in 'uCalc.pas',
  Vcl.Themes,
  Vcl.Styles,
  Usplash in 'Usplash.pas' {SplashForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Turquoise Gray');
  SplashForm := TSplashForm.Create(Application);
  SplashForm.Show;
  SplashForm.Refresh;
  Sleep(2000);
  Application.CreateForm(TMainForm, MainForm);
  SplashForm.Hide;
  SplashForm.Free;
  Application.Run;
end.
