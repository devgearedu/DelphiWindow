program ServerSchedulers;

uses
  Forms,
  Main in 'Main.pas' {formMain};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TformMain, formMain);
  Application.Run;
end.
