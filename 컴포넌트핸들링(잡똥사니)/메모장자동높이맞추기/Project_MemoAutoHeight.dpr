program Project_MemoAutoHeight;

uses
  Forms,
  UMemo_AutoHeight in 'UMemo_AutoHeight.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
