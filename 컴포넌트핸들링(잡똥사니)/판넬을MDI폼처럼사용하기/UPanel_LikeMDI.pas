unit UPanel_LikeMDI;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, Grids;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    TreeView1: TTreeView;
    StringGrid1: TStringGrid;
    Button3: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
  public
  end;

var
  Form1: TForm1;

implementation

uses MDIControls;

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  MakeMDIControl( Panel1, Panel1.Caption, True, False );
  MakeMDIControl( TreeView1, '트리뷰다!', True, True );
  MakeMDIControl( StringGrid1, '그리드다!', True, True );
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  Panel1.Visible := True;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  TreeView1.Visible := True;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  StringGrid1.Visible := True;
end;

end.
