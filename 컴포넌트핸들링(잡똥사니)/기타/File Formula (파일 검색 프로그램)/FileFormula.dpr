program FileFormula;

uses
  Forms,
  Main_Frm in 'Main_Frm.pas' {Main_Form},
  SearchClasses in 'SearchClasses.pas',
  FileLists in 'FileLists.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'File Formula';
  Application.CreateForm(TMain_Form, Main_Form);
  Application.Run;
end.
