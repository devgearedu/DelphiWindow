program Project_InLine_Var;

uses
  Vcl.Forms,
  UInLine_Var in 'UInLine_Var.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
