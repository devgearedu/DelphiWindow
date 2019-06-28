unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.ExtCtrls, Vcl.StdCtrls;

Var
i, j: Real;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Edit3: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Panel1: TPanel;
    Edit2: TEdit;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    Button1: TButton;
    procedure SpeedButton1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  close;
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
  Label1.Caption:= '+';
  i:= StrToFloat(Edit1.Text);
  j:= StrToFloat(Edit2.Text);
  Edit3.Text:= FloatToStr(i+j);
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
begin
  Label1.Caption:= '-';
  i:= StrToFloat(Edit1.Text);
  j:= StrToFloat(Edit2.Text);
  Edit3.Text:= FloatToStr(i-j);
end;

procedure TForm1.SpeedButton3Click(Sender: TObject);
begin
  Label1.Caption:= '*';
  i:= StrToFloat(Edit1.Text);
  j:= StrToFloat(Edit2.Text);
  Edit3.Text:= FloatToStr(i*j);
end;

procedure TForm1.SpeedButton4Click(Sender: TObject);
begin
  Label1.Caption:= '/';
  i:= StrToFloat(Edit1.Text);
  j:= StrToFloat(Edit2.Text);
  Edit3.Text:= FloatToStr(i/j);
end;

procedure TForm1.SpeedButton5Click(Sender: TObject);
Var
  i, j : Integer;
begin
  Label1.Caption:= 'M';
  i:= StrToInt(Edit1.Text);
  j:= StrToInt(Edit2.Text);
  Edit3.Text:= IntToStr(i Mod j);
end;

end.
