program Project_ComboBox_Hint;

uses
  Forms,
  UComboBox_ShowHint in 'UComboBox_ShowHint.pas' {Form1},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  TStyleManager.TrySetStyle('Silver');
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
