unit umain_ClassHelperTest;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm21 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    ListBox1: TListBox;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TStringsHelper = class helper for TStrings
  public
    function Add(const V: Variant): Integer; overload;
    function Add(const Args: array of Variant): Integer; overload;
  end;

var
  Form21: TForm21;

implementation

uses utest4_Helper_Added;

var
   h:th;
{$R *.dfm}

procedure TForm21.Button1Click(Sender: TObject);
begin
  Th.Test;
  Th.Etc := 'etc';
  Edit5.Text := Th.Etc;
  h := Th.Create;
  Edit1.Text := h.Name;
  Edit2.Text := IntToStr(h.Age);
  Edit3.Text := h.Address;
  Edit4.Text := IntToStr(h.Salary);
  Edit5.Text := h.Echo('hi');
  h.Free;
end;

procedure TForm21.Button2Click(Sender: TObject);
begin
  Listbox1.Items.Add(now);
  Listbox1.Items.Add(1000);
  Listbox1.Items.Add(true);
  Listbox1.Items.Add(['a',1000]);
end;

{ TStringsHelper }

function TStringsHelper.Add(const V: Variant): Integer;
begin
    Result := Add([V]);
end;

function TStringsHelper.Add(const Args: array of Variant): Integer;
var
  tmp: string;
  cnt: Integer;
begin
  tmp := '';
  for cnt := Low(Args) to High(Args) do
    tmp := tmp + VarToStr(Args[cnt]);
  Result := Add(tmp);
end;

end.
