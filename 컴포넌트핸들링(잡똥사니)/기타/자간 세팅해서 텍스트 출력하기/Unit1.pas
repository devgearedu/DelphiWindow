unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs;

type
  TForm1 = class(TForm)
    procedure FormPaint(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormPaint(Sender: TObject);
const
  Text = '�����ٶ󸶹ٻ��';
var
  Arr: array[0..8] of Integer;
begin
  Arr[ 0 ] := 20;   //��
  Arr[ 1 ] := 30;
  Arr[ 2 ] := 10;   //��
  Arr[ 3 ] := 10;
  Arr[ 4 ] := 60;   //��
  Arr[ 5 ] := 70;
  Arr[ 6 ] := 80;   //��
  Arr[ 7 ] := 200;
  Arr[ 8 ] := 100;  //��

  ExtTextOut( Canvas.Handle, 0, 100, 0, nil, PChar( Text ), Length( Text ), @Arr );
end;

end.
