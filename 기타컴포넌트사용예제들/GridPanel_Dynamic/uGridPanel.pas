unit uGridPanel;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,stdctrls, Vcl.ToolWin,
  Vcl.ComCtrls;

type
  TForm28 = class(TForm)
    GridPanel1: TGridPanel;
    ToolBar1: TToolBar;
    Button1: TButton;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
   procedure TestHandler(Sender:Tobject);
   procedure CreateButtonGrid(const rowCount, colCount : integer);
   procedure GetRowColumn(const AControl: TControl; var ARow, AColumn: Integer);
var
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form28: TForm28;

implementation

{$R *.dfm}

procedure TForm28.Button1Click(Sender: TObject);
var
  aControl : TControl;
begin
  aControl := GridPanel1.ControlCollection.Controls[1,1]; //3rd row, 4th column
  if Assigned(aControl) AND (aControl IS TButton) then
     TButton(aControl).Caption := 'hit';
end;

procedure TForm28.Button2Click(Sender: TObject);
var
  aControl : TControl;
  abutton:tbutton;
  idx : integer;
  cRow, cColumn : integer;
begin
  //"pseudo" code (as aControl is nil)
  aControl := tcontrol(tbutton);
  cRow := -1; cColumn := -1;
  idx := GridPanel1.ControlCollection.IndexOf(aControl);
  if idx > -1 then
  begin
    cRow := GridPanel1.ControlCollection[idx].Row;
    cColumn := GridPanel1.ControlCollection[idx].Column;
    button2.Caption := format('ÄÃ·³= %d, Çà= %d' ,[cColumn,cRow]);
  end;
end;

procedure TForm28.CreateButtonGrid(const rowCount, colCount : integer);
var
  i : integer;
  aButton: TButton;
begin
  GridPanel1.RowCollection.BeginUpdate;
  GridPanel1.ColumnCollection.BeginUpdate;

  for i := 0 to -1 + GridPanel1.ControlCount do
    GridPanel1.Controls[0].Free;

  //btw, cannot clear if there are controls, so first remove "old" controls above
  GridPanel1.RowCollection.Clear;
  GridPanel1.ColumnCollection.Clear;

  for i := 1 to rowCount do
    with GridPanel1.RowCollection.Add do
    begin
      SizeStyle := ssPercent;
      Value := 100 / rowCount; //have cells evenly distributed
    end;

  for i := 1 to colCount do
    with GridPanel1.ColumnCollection.Add do
    begin
      SizeStyle := ssPercent;
      Value := 100 / colCount; //have cells evenly distributed
    end;

  for i := 0 to -1 + rowCount * colCount do
  begin
    aButton := TButton.Create(self);
    aButton.Parent := GridPanel1; //magic: place in the next empty cell
    aButton.Visible := True;
    aButton.Align := AlClient;
    aButton.Caption := 'tBtn ' + IntToStr(i);
    aButton.AlignWithMargins := true;
    aButton.OnClick :=  TestHandler;
  end;

  GridPanel1.RowCollection.EndUpdate;
  GridPanel1.ColumnCollection.EndUpdate;
end;

procedure TForm28.FormCreate(Sender: TObject);
begin
  GridPanel1.Caption := '';
  CreateButtonGrid(3,5);
end;

procedure TForm28.GetRowColumn(const AControl: TControl; var ARow,
  AColumn: Integer);
var
  I: Integer;
begin
  if AControl.Parent is TGridPanel then
  begin
    I := TGridPanel(AControl.Parent).ControlCollection.IndexOf(AControl);
    if I > -1 then
    begin
      ARow := TGridPanel(AControl.Parent).ControlCollection[I].Row;
      AColumn := TGridPanel(AControl.Parent).ControlCollection[I].Column;
    end;
  end;
end;

procedure TForm28.TestHandler(Sender: Tobject);
var
  Row, Column : Integer;
begin
  GetRowColumn(Sender as TControl, Row, Column);
  // do something with Row and Column
  ShowMessage( Format('row=%d - col=%d',[Row, Column]));
end;
end.
