program Icons;

uses
  Forms,
  Main_Frm in 'Main_Frm.pas' {Main_Form},
  IconsUtil in 'IconsUtil.pas',
  BitmapLists in 'BitmapLists.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := '������ �а� ����';
  Application.CreateForm(TMain_Form, Main_Form);
  Application.Run;
end.
