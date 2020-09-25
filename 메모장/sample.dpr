program sample;

uses
  Vcl.Forms,
  USplash in 'USplash.pas' {SplashForm},
  uMain in 'uMain.pas' {MainForm},
  uListUp_DLL in 'uListUp_DLL.pas' {DllLoadForm},
  uAbout in 'uAbout.pas' {AboutBox},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('windows10 purple');
  Splashform := TSplashForm.Create(Application);
  SplashForm.Show;
  SplashForm.Refresh;
  Application.CreateForm(TMainForm, MainForm);
  SplashForm.hide;
  SplashForm.Free;
  Application.Run;
end.
