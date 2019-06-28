program Project_Panel_LikeMDIForm;

uses
  Forms,
  UPanel_LikeMDI in 'UPanel_LikeMDI.pas' {Form1},
  MDIControls in 'MDIControls.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
