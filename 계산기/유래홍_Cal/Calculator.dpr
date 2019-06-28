program Calculator;

uses
  Vcl.Forms,
  Umain in 'Umain.pas' {Form3},
  Usplash in 'Usplash.pas' {SplashForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  SplashForm := TSplashForm.Create(Application);
  SplashForm.Show;
  SplashForm.Refresh;
  Application.CreateForm(TForm3, Form3);
  SplashForm.Hide;
  SplashForm.Free;
  Application.Run;
end.
