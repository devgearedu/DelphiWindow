program PNGWidget;

uses
  Forms,
  Test_Frm in 'Test_Frm.pas' {Test_Form};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TTest_Form, Test_Form);
  Application.Run;
end.

