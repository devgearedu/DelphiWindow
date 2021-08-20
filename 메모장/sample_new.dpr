program sample_new;

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
   TStyleManager.TrySetStyle('Aqua Light Slate');
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
