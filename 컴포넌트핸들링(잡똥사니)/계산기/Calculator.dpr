program Calculator;

{$R 'Resource.res' 'Resource.rc'}

uses
  Forms,
  Main_Frm in 'Main_Frm.pas' {Main_Form},
  Parser in 'Parser.pas',
  Help_Frm in 'Help_Frm.pas' {Help_Form},
  CaptionButtons in 'CaptionButtons.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := '계산기다!';
  Application.CreateForm(TMain_Form, Main_Form);
  Application.Run;
end.
