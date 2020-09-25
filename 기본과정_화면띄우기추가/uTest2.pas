unit utest2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.Bind.EngExt, Vcl.Bind.DBEngExt,
  Vcl.Bind.Grid, System.Rtti, System.Bindings.Outputs, Vcl.Bind.Editors,
  Vcl.StdCtrls, Vcl.ExtCtrls, Data.Bind.Components, Data.Bind.Grid,
  Data.Bind.DBScope, Data.DB, Datasnap.DBClient, Vcl.Grids, Vcl.ComCtrls,
  UmyFrame;

type
  TForm2 = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    차트: TTabSheet;
    TabControl1: TTabControl;
    StringGrid1: TStringGrid;
    ClientDataSet1: TClientDataSet;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkGridToDataSourceBindSourceDB1: TLinkGridToDataSource;
    Image1: TImage;
    Edit1: TEdit;
    TFrame11: TFrame1;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation
var
  t:TTabSheet;
  memo:TMemo;

{$R *.dfm}

procedure TForm2.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   action := caFree;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  t := TTabSheet.Create(pagecontrol1);
  t.Caption := '기타';
  t.PageControl := PageControl1;
  Pagecontrol1.ActivePage := t;
  memo := Tmemo.Create(t);
  memo.Parent := t;
  memo.Align := alclient;
//  memo.lines.clear;
//  memo.Lines.Add('안녕하세요');
  memo.Lines.Text := '안녕하세요';

end;

procedure TForm2.StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
  s:string;
  pos:integer;
  OldAlign:integer;
begin
  s := StringGrid1.Cells[ACol,ARow];
  with StringGrid1.Canvas do
  begin
    FillRect(Rect);
    if ARow = 0 then
    begin
      Font.Color := clBlue;
      Font.Size := Font.Size + 4;
    end;
    if (ACol = 2) and (ARow <> 0) then
    begin
      if (ARow = StringGrid1.RowCount - 1) then
         Brush.color := clyellow;

      Font.Color := clred;
      Font.Size := Font.Size + 4;
      OldAlign := SetTextAlign(Handle,ta_Right);
      TextRect(Rect, Rect.Right, Rect.Top+3, s);
      SetTextAlign(Handle,OldAlign);
    end
    else
    begin
      pos := ((Rect.Right - Rect.Left) - TextWidth(s)) div 2;
      TextRect(Rect, Rect.Left+pos, Rect.Top+3, s);
    end;
  end;

end;

end.
