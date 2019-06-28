program Project_ListUp_DLL;

uses
  Forms,
  uListUp_DLL in 'uListUp_DLL.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
