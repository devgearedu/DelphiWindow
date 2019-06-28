program ServerSchedulerStress;

uses
  Forms,
  Main in 'Main.pas' {formMain},
  ClientThread in 'ClientThread.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TformMain, formMain);
  Application.Run;
end.
