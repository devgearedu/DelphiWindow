unit UmyFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, VclTee.TeeGDIPlus,
  Data.DB, Vcl.StdCtrls, Vcl.ColorGrd, VCLTee.TeEngine, VCLTee.Series,
  Vcl.ExtCtrls, VCLTee.TeeProcs, VCLTee.Chart, VCLTee.DBChart;

type
  TFrame1 = class(TFrame)
    DBChart1: TDBChart;
    Series1: TBarSeries;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    ColorGrid1: TColorGrid;
    CheckBox1: TCheckBox;
    ComboBox1: TComboBox;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure ColorGrid1Change(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TFrame1.Button1Click(Sender: TObject);
begin
   DBChart1.Page := 1;
end;

procedure TFrame1.Button2Click(Sender: TObject);
begin
  DBChart1.PreviousPage;
end;

procedure TFrame1.Button3Click(Sender: TObject);
begin
  DBChart1.NextPage;
end;

procedure TFrame1.Button4Click(Sender: TObject);
begin
   DBChart1.Page :=  DBChart1.NumPages;
end;

procedure TFrame1.CheckBox1Click(Sender: TObject);
begin
//   CheckBox1.Checked := not CheckBox1.Checked;
   DBChart1.View3D := CheckBox1.Checked;
end;

procedure TFrame1.ColorGrid1Change(Sender: TObject);
begin
   DBChart1.Series[0].Color := ColorGrid1.ForegroundColor;
end;

procedure TFrame1.ComboBox1Change(Sender: TObject);
begin
  dbChart1.ZoomPercent(strtoint(ComboBox1.Items[Combobox1.ItemIndex]));
end;

end.
