program Project_RibbonControl_RunTime;

uses
  Vcl.Forms,
  uRibbonControl_RunTime in 'uRibbonControl_RunTime.pas' {Form16};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm16, Form16);
  Application.Run;
end.
