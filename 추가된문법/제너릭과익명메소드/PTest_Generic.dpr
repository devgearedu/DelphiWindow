program PTest_Generic;

uses
  Forms,
  Utest_Generic in 'Utest_Generic.pas' {Form1},
  Unit_generic in 'Unit_generic.pas',
  Unit_enonymous in 'Unit_enonymous.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
