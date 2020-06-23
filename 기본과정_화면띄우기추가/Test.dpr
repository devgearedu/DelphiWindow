program test;

uses
  Vcl.Forms,
  Utest1 in 'Utest1.pas' {Form1},
  uTest2 in 'uTest2.pas' {Form2},
  uTest3 in 'uTest3.pas' {Form3},
  utest4 in 'utest4.pas',
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
