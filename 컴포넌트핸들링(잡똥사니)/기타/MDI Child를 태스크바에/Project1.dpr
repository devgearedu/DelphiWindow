program Project1;

uses
  Forms,
  Main in 'Main.pas' {MainForm},
  MDIChild in 'MDIChild.pas' {MDIChildForm},
  MDIChildTaskButtons in 'MDIChildTaskButtons.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
