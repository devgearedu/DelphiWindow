program CalCulator0118;

uses
  Vcl.Forms,
  uMain in 'uMain.pas' {FCal},
  uSplash in 'uSplash.pas' {SplashForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  SplashForm := TSplashForm.Create(Application);
  SplashForm.Show;
  SplashForm.Refresh;
  Application.CreateForm(TFCal, FCal);
  Application.CreateForm(TSplashForm, SplashForm);
  SplashForm.Hide;
  SplashForm.Free;
  Application.Run;
end.
