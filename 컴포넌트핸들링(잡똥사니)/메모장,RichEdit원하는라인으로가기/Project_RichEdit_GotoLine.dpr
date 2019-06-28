program Project_RichEdit_GotoLine;

uses
  Forms,
  URichEdit_GoToLine in 'URichEdit_GoToLine.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
