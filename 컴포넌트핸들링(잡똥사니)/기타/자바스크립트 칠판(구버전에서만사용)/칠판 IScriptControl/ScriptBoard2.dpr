program ScriptBoard2;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  ScriptObject_TLB in '..\스크립트오브젝트\ScriptObject_TLB.pas',
  ScriptControls in 'ScriptControls.pas',
  BK_Board in '..\VCL\BK_Board.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
