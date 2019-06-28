program Calculator;

uses
  Vcl.Forms,
  uCalculator in 'uCalculator.pas' {frmCalculator} ,
  uSplash in 'uSplash.pas' {SplashForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  SplashForm := TSplashForm.Create(Application);
  SplashForm.Show;
  SplashForm.Refresh;
  Application.CreateForm(TfrmCalculator, frmCalculator);
  Application.CreateForm(TSplashForm, SplashForm);
  SplashForm.Hide;
  SplashForm.Free;
  Application.Run;

end.
