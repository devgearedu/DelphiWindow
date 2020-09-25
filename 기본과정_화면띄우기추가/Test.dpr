program Test;

uses
  Vcl.Forms,
  Utest1 in 'Utest1.pas' {Form1},
  uTest2 in 'uTest2.pas' {Form2},
  utest4 in 'utest4.pas',
  uTest3 in 'uTest3.pas' {Form3},
  Vcl.Themes,
  Vcl.Styles,
  UmyFrame in 'UmyFrame.pas' {Frame1: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TstyleManager.TrySetStyle('silver') ;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
