program Project_ClassHelper;

uses
  Vcl.Forms,
  umain_ClassHelperTest in 'umain_ClassHelperTest.pas' {Form21},
  utest4_Helper_Added in 'utest4_Helper_Added.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm21, Form21);
  Application.Run;
end.
