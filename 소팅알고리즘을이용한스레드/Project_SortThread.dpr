program Project_SortThread;

uses
  Vcl.Forms,
  uSortThreads in 'uSortThreads.pas',
  USort in 'USort.pas' {SortForm},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Golden Graphite');
  Application.CreateForm(TSortForm, SortForm);
  Application.Run;
end.
