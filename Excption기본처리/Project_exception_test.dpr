program Project_exception_test;

uses
  Vcl.Forms,
  utest_exception in 'utest_exception.pas' {Form188};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm188, Form188);
  Application.Run;
end.
