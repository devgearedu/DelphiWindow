program Project_StringGrid__Scroll;

uses
  Vcl.Forms,
  UStringGrid_ScrollDisplay in 'UStringGrid_ScrollDisplay.pas' {Form1},
  UMain in 'UMain.pas' {Form2};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
