program Project_MessageDialog;

uses
  Vcl.Forms,
  MsgBox in 'MsgBox.pas',
  uMessageDialog_Display in 'uMessageDialog_Display.pas' {Form1},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Silver');
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
