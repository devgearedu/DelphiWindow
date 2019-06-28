program Calclator;

uses
  Vcl.Forms, system.sysutils,
  UCalc in 'UCalc.pas' {ClacForm},
  Usplash in 'Usplash.pas' {SplashForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Run;
  SplashForm := TSplashForm.Create(application);
  splashForm.show;
  splashForm.Refresh;

  sleep(8000);

  Application.CreateForm(TClacForm, ClacForm);


  splashForm.Hide;
  splashForm.Free;
  application.Run;

end.
