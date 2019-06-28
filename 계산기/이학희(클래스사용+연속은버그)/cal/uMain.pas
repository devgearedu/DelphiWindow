unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TFCal = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Button10: TButton;
    Button11: TButton;
    Button12: TButton;
    Button13: TButton;
    Button14: TButton;
    Button15: TButton;
    Button16: TButton;
    Button17: TButton;
    Button18: TButton;
    edDisplay: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure Button17Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button18Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }

  public
    { Public declarations }

    fnFlag : string;
    checkedit : string;
    function Add(x, y: double): double;
    function sub(x, y: double): double;
    function mul(x, y: double): double;
    function Divide(x,y: integer): integer; overload;
    function Divide(x,y: real): real; overload;
  end;

  TeditCal = class(TStringList)
  private
  public
    list : TStringList;
    Constructor Create;
    Destructor Destroy;
    function Gubun(a : string):TstringList;

  end;

var
  FCal: TFCal;


implementation

//uses uCal;
{$R *.dfm}

function TFCal.Add(x, y: double): double;
begin
  Result := X+ Y;
end;

procedure TFCal.Button17Click(Sender: TObject);
begin
  if (edDisplay.Text <>'') then
  begin
    checkedit := edDisplay.Text;
    if (Sender as TButton).Caption <> fnFlag then
    begin
    case (Sender as TButton).Tag of
    12 :
    begin
      edDisplay.text :=  edDisplay.text+ (Sender as TButton).Caption;
      fnFlag := '+';
    end;
    13 :
    begin
      edDisplay.text :=  edDisplay.text+(Sender as TButton).Caption;
      fnFlag := '-';
    end;
    14 :
    begin
      edDisplay.text :=  edDisplay.text+(Sender as TButton).Caption;
      fnFlag := '*';
    end;
    15 :
    begin
      edDisplay.text :=  edDisplay.text+(Sender as TButton).Caption;
      fnFlag := '/';
    end;

    end;

  end;

  end;
end;

procedure TFCal.Button18Click(Sender: TObject);
var
  Cal : TeditCal;
  sX : TstringList;
//  i: byte;
begin
  Cal := TeditCal.Create;

  sx := Cal.Gubun(edDisplay.Text);
//  showmessage(inttoStr(sx.count));

// for i := 0 to sx.Count do
//  begin
  if sx.Count >= 2 then
  begin
  if fnFlag = '+'  then
    edDisplay.text := FloatToStr(Add(strToFloat(sx[0]), strToFloat(sx[1])))
  else if fnFlag ='-' then
    edDisplay.text :=FloatToStr(Sub(strToFloat(sx[0]), strToFloat(sx[1])))
  else if fnFlag ='*' then
    edDisplay.text :=FloatToStr(Mul(strToFloat(sx[0]), strToFloat(sx[1])))
  else if fnFlag ='/' then
    edDisplay.text :=FloatToStr(divide(strToFloat(sx[0]), strToFloat(sx[1])))
  else
    showmessage('??');
//  end;
  end;
  fnFlag := '';
  cal.Free;

end;

procedure TFCal.Button1Click(Sender: TObject);
begin
  edDisplay.Text := '';
end;

procedure TFCal.Button4Click(Sender: TObject);
begin
  edDisplay.Text := checkEdit;
//  checkEdit := edDisplay.Text;
end;

procedure TFCal.Button5Click(Sender: TObject);
begin
  checkedit := edDisplay.Text;
  if edDisplay.Text <> '' then
    edDisplay.Text := edDisplay.Text + (Sender as TButton).Caption
  else
    edDisplay.Text := checkedit + (Sender as TButton).Caption;

end;

function TFCal.Divide(x, y: integer): integer;
begin
  Result := X div Y;
end;

function TFCal.Divide(x, y: real): real;
begin
  Result := X / Y;
end;

procedure TFCal.FormCreate(Sender: TObject);
begin
  Button1Click(Button1);
end;

procedure TFCal.FormDestroy(Sender: TObject);
begin
  //
end;

function TFCal.mul(x, y: double): double;
begin
  Result := x* y;
end;

function TFCal.sub(x, y: double): double;
begin
  Result := X -Y ;
end;

{ TeditCal }

constructor TeditCal.Create;
begin
  list := TStringList.Create;
end;

destructor TeditCal.Destroy;
begin
  list.Free;
end;

function TeditCal.Gubun(a: string): TstringList;
begin
//  StringReplace(a, '+', '#13#10', rfReplaceAll);
  ExtractStrings(['+','-','*','/'],[],pchar(a),list);
  Result := list;

end;

end.
