unit utest4_Helper_Added;

interface
uses
  vcl.dialogs;
type

  TPerson = class(TObject)
   private
    ttt:string;
   strict private
    ttt2:string;  //+2007
   public
    Name:string;
    Age:byte;
    Address:string;
    function GetName:string;
    constructor Create; virtual;
  end;

  TEmp = class(TPerson)
    Office:string;
    function Salary:integer; virtual; abstract; //dynamic
    constructor Create; override;
  end;

  TH = class sealed(TEmp)
     Hrs:integer;
     Rate:integer;
     class var etc:string;
     class procedure test; static;
     function Salary:integer; override; // final;
     constructor Create; override;
  end;

  THhelper = class helper for th
    function Echo(value:string):string;
  end;

  TDog = class
     Name:string;
     Age:byte;
     Address:string;
     function GetName:string;
  end;

  Country = array [0..2] of string;

  Person = record
     Name:string;
     Age:byte;
     Address:string;
     function GetName:string;
  end;
//  p_person = ^person;

var
  p:^person;  //p_person;
  a1:array of string;
  a2:array of array of string;
  ps:pchar;
  pi:^integer;
  Countries:Country; // = ('korea','america','japan');
  s:string; //1.0:shortstring ,2.0~2009이전 ansistring; 2009~ unicodestring;
  i:NativeInt = 100; //32 bit or 64 bit;
  r:real;
  t:TDateTime;
  b:boolean;  //bytebool, wordbool, longbool
  v:variant;
 //문자 정수 실수 불린, 배열, 날자, ole boejct(엑셀, 워드 ,파워포인드)값들을 가질수 있어
 // unssinged 16 byte, 많이사용--->> 메모리사용량 중가,성능저하
procedure Hello;
function Add(x:integer=2;y:integer=3):integer; inline;
function Sub(x,y:integer):integer;
function Divide(x,y:integer):integer; overload;
function Divide(x,y:real):extended; overload;

//위에서 선언된 루틴들을 구현하는곳
//const, var, procedure, funciton 선언-----> 자기유니트밑 에서만 사용
implementation
var
  j:integer;

procedure Hello;
var
  k:integer;
begin
  ShowMessage('안녕');
end;
function Add(x,y:integer):integer;
begin
//   Add := x + y;
//   exit(x+y);      //2010 exit 리턴값 가능
   result := x + y;  //+,-,*, div, /, mod
end;
function Sub(x,y:integer):integer;
begin
   result := x - y;
end;

function Divide(x,y:integer):integer;
begin
   result := x div y;
end;

function Divide(x,y:real):extended;
begin
   result := x / y;
end;

function Person.GetName:string;
begin
  result := Name;
end;

constructor TPerson.Create;
begin
  Name := '김원경';
  Age := 20;
  Address := '서초구 반포동 사평대로';
end;

function TPerson.GetName: string;
begin
   result := Name;
end;

function TDog.GetName: string;
begin
  result := Name;
end;

constructor TH.Create;
begin
  inherited;
  Hrs := 10;
  Rate := 100000;
end;

function TH.Salary: integer;
begin
  result := Hrs * Rate;
end;

class procedure TH.test;
begin
  ShowMessage('Test');
end;

constructor Temp.Create;
begin
  inherited;
  Office := '데브기어';
end;

//uses절을 만나면 실행 :초기처리(메모리할당 디폴트값설정)
{ THhelper }

function THhelper.Echo(value: string): string;
begin
    result := value;
end;

initialization
begin
  Countries[0] := '한국';
  Countries[1] := '미국';
  Countries[2] := '일본';

  SetLength(a1,2);
  a1[0] := 'a1';
  SetLength(a2,2,2);
  a2[0,0] := 'a2';
end;
finalization
end.
