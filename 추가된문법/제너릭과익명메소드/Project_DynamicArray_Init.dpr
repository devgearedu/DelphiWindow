program Project_DynamicArray_Init;

uses
  Vcl.Forms,
  Unit_DynamicArray_init in 'Unit_DynamicArray_init.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
