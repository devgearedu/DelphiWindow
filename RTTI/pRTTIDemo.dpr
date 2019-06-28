program pRTTIDemo;

uses
  Forms,
  MainForm_rtti in 'MainForm_rtti.pas' {Form17},
  uDemo in 'uDemo.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm17, Form17);
  Application.Run;
end.
