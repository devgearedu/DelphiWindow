unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

type
  TForm1 = class(TForm)
    ListView: TListView;
    Button1: TButton;
    Button2: TButton;
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

type
  TMyListItem = class(TListColumn)
  public
    MyData: String; 
  end;

procedure TForm1.FormCreate(Sender: TObject);
type
  PListColumnClass = ^TCollectionItemClass;
var
  ItemClass: PListColumnClass;
begin
  ItemClass := @ListView.Columns.ItemClass;
  ItemClass^ := TMyListItem;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  ListColumn: TListColumn;
begin
  ListColumn := ListView.Columns.Add;

  ListColumn.Caption := '1234';
  ListColumn.Width := 200;
  TMyListItem(ListColumn).MyData := '가나다라';

  Caption := ListColumn.ClassName;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  ShowMessage( TMyListItem(ListView.Columns[ 0 ]).MyData );
end;

end.
