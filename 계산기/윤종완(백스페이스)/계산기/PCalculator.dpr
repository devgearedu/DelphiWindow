program PCalculator;

uses
  Vcl.Forms,
  WinApi.windows,
  UCalculator in 'UCalculator.pas' {Calculator_Form};

{$R *.res}

begin
  Application.Initialize;
  sleep(3000);
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TCalculator_Form, Calculator_Form);
  Application.Run;
end.
