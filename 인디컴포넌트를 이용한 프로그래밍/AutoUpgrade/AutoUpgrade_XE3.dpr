program AutoUpgrade_XE3;

uses
  Forms,
  DownloadMain in 'DownloadMain.pas' {DownloadMainForm},
  ImpFileStream in 'ImpFileStream.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := '�ڵ� ���׷��̵�';
  Application.CreateForm(TDownloadMainForm, DownloadMainForm);
  Application.Run;
end.
