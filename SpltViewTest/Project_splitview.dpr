program Project_splitview;

uses
  Vcl.Forms,
  USplitView in 'USplitView.pas' {DeptForm_New};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDeptForm_New, DeptForm_New);
  Application.Run;
end.
