program FlashRgn;

uses
  Forms,
  Main_Frm in 'Main_Frm.pas' {Main_Form};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMain_Form, Main_Form);
  Application.Run;
end.
