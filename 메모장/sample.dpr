program sample;

uses
  Vcl.Forms,
  USplash in 'USplash.pas' {SplashForm},
  uMain in 'uMain.pas' {MainForm},
  uListUp_DLL in 'uListUp_DLL.pas' {DllLoadForm},
  Vcl.Themes,
  Vcl.Styles,
  uAbout in 'uAbout.pas' {AboutBox};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Windows10 Purple');
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
