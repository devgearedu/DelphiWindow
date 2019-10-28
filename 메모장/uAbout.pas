unit UABOUT;

interface

uses WinApi.Windows, System.SysUtils, System.Classes, Vcl.Graphics,
  Vcl.Forms, Vcl.Controls, VCl.themes,vcl.styles, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TAboutBox = class(TForm)
    Panel1: TPanel;
    ProgramIcon: TImage;
    ProductName: TLabel;
    Version: TLabel;
    Copyright: TLabel;
    Comments: TLabel;
    OKButton: TButton;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutBox: TAboutBox;

procedure Display_About; export; stdcall;
function Add(x,y:integer):integer; export; stdcall;
function Sub(x,y:integer):integer; export; stdcall;
function Divide(x,y:real):real; export; stdcall;

implementation
procedure Display_About;
var
  Abox:TAboutBox;
begin
  Abox := TAboutBox.Create(nil);
  try
    ABox.ShowModal;
  finally
    Abox.Free;
  end;
end;
function Add(x,y:integer):integer;
begin
  result := x + y;
end;
function Sub(x,y:integer):integer;
begin
  result := x - y;
end;
function Divide(x,y:real):real;
begin
  result := x / y;
end;
{$R *.dfm}

procedure TAboutBox.FormCreate(Sender: TObject);
begin
  TStyleManager.SetStyle('windows10 purple');
end;

end.

