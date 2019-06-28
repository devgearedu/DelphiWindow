unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
  private
    procedure CreateComponent(Reader: TReader; ComponentClass: TComponentClass; var Component: TComponent);
  protected
    procedure ReadState(Reader: TReader); override;
  public
  end;

var
  Form1: TForm1;

implementation

uses
  RedPanel;

{$R *.dfm}

procedure TForm1.CreateComponent(Reader: TReader; ComponentClass: TComponentClass; var Component: TComponent);
begin
  if ComponentClass = TPanel then
   Component := TRedPanel.Create( Self );
end;

procedure TForm1.ReadState(Reader: TReader);
begin
  Reader.OnCreateComponent := CreateComponent;

  inherited ReadState( Reader );
end;

end.
