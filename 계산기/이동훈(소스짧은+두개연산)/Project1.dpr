program Project1;

uses
  Vcl.Forms,
  Winapi.Windows,
  Unit1 in 'Unit1.pas' {Form1},
  USplash in 'USplash.pas' {SplashForm};

{$R *.res}

begin
  Application.Initialize;
  SplashForm:= TSplashForm.Create(Application);
  SplashForm.Show;
  SplashForm.Refresh;
  Sleep(3000);
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  SplashForm.Hide;
  SplashForm.Free;
  Application.Run;
end.
