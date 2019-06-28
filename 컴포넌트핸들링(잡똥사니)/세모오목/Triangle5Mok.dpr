program Triangle5Mok;

uses
  Forms,
  Main_Frm in 'Main_Frm.pas' {Main_Form};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := '세모 오목';
  Application.CreateForm(TMain_Form, Main_Form);
  Application.Run;
end.
