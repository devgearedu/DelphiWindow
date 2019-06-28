program Ptcp_client_XE3;

uses
  Forms,
  Utcp_client in 'Utcp_client.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
