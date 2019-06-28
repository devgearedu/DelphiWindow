unit UInLine_Var;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,System.Generics.Collections;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
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
var
  I: Integer;
begin
  I := 10;
  Button1.Caption := I.ToString;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  var I, J: Integer;
  I := 10;
  j := I + 20;
  Button2.Caption := J.ToString;
end;
//이전 선언 방식과 비교해 가장 크게 변한 점은 변수 인라인 선언과 초기화를 한 문장에서 끝낼 수 있다는 것입니다.
//함수 선언부에서 변수를 초기화 하는 것도 훨씬 더 보기에 쉽고 파악하기 좋습니다.
procedure TForm1.Button3Click(Sender: TObject);
begin
  var I: Integer := 20;
  var J: Integer := 10 + I;
  var K: Integer := I + J;

  Button3.Caption := I.ToString;
  ShowMessage (K.ToString);
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  var I: Integer := 22;
  if I > 10 then
  begin
    var J: Integer := 3;
    ShowMessage(J.ToString);
  end
  else
  begin
    var K: Integer := 3;
  //  ShowMessage (J.ToString); // COMPILER ERROR: "Undeclared identifier: J"
  end;
  // J and K not accessible here

end;

procedure TForm1.Button5Click(Sender: TObject);
begin
 const ScreenWidth : Integer = Screen.width;
 const ScreenHeight : integer = Screen.Height;
 const pos = (ScreenWidth + ScreenHeight) div 2; // single identifier, without type specifier
 Button5.Caption := ScreenWIdth.ToString;
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
  var Total := 0;
  for var I: Integer := 1 to 10 do
    Inc(Total, I);
  Button6.Caption := Total.ToString;
//  ShowMessage (I.ToString);
//  compiler error: Undeclared Identifier ‘I’
end;

{저너릭(Generic)의 인스턴스처럼 복잡한 유형의 경우
변수 타입 유추하는 것이 상당히 유용합니다.
아래 코드를 보면, MyDictionary 변수에 대한
TDirtionary 타입 유추와 APair 변수에 대한
TPair 타입 유추를 확인할 수 있습니다.}
procedure TForm1.Button7Click(Sender: TObject);
begin
  var MyDictionary := TDictionary<string, Integer>.Create;
  MyDictionary.Add ('one', 1);
  var APair := MyDictionary.ExtractPair('one');
  Button7.Caption := APair.Value.ToString;
end;

end.
