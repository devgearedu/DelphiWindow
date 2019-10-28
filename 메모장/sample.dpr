program sample;

uses
  Vcl.Forms,
  USplash in 'USplash.pas' {SplashForm},
  uMain in 'uMain.pas' {MainForm},
  uListUp_DLL in 'uListUp_DLL.pas' {DllLoadForm},
  Uchart_Frame in 'Uchart_Frame.pas' {chartFrame: TFrame},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Windows10 Purple');
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
