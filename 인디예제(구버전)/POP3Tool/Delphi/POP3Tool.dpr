program POP3Tool;

uses
  Forms,
  Main in 'Main.pas' {formMain};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Indy POP3 Tool';
  Application.CreateForm(TformMain, formMain);
  Application.Run;
end.
