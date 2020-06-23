unit utest4;
//type, const, var, procedure, function 선언
//이곳에 선언된  type, const,var, procedure, function들은 자기 유니트 및 외부 유니트에서도 사용 가능(uses)
interface
uses
  vcl.Dialogs;
type

  TPerson = class(tobject)
   private
    ttt:string;
   strict private     //+2007 strict protected
    ttt2:string;
   public
    name:string;
    Age:integer;
    Address:string;
    function GetName:string;
    constructor create; virtual;
  end;

  temp = class(tperson)
    office:string;
    function salary:integer; virtual; abstract;
    constructor create; override;
  end;

  th = class sealed(temp)
     hrs:integer;
     rate:integer;
     function salary:integer; override; // final;
     constructor create; override;
  end;

  TDog = class(tobject)
    name:string;
    Age:String;
    Address:string;
    function GetName:string;
  end;

  Person = record
    name:string;
    Age:String;
    Address:string;
    function GetName:string;
  end;
//  p_person = ^person;

  country = array [0..2] of string;
var
  p:^person;
  pa:pchar; //pansichar, pwidechar,punicodechar
  pi:^integer;
  a1:array of string;          //동적배열 1차원
  a2:array of array of string; //동적배열 2차원
  Countries:array [0..2] of string; // = ('korea', 'japan', 'america');
  s:string;  //1.0 shortstring; 2.0~2009이전 AnsiString, 2009~ :unicodestring
  i:NativeInt = 100;  //32 or 64
  r:real;
  t:TDateTime;
  b:boolean;   //bytebool, wordbool, longbool;
  v:variant;
// 문자,정수,실수,날자,불린,정적배열,동적배얼, ole object(엑셀 워드) 등을 가질수 있는 타입
// unsinged 16byte ----> 메모리효율셩이 떨어지고 성능 저하
procedure Hellow;  inline;
function Add(x:integer=2; y:integer=3):integer;
function Sub(x,y:integer):integer;
function Divide(x,y:integer):integer; overload;
function Divide(x,y:real):extended; overload;
//위에서 선언된 루틴들을 코드 구현  하는곳
//필요한 변수 상수 뤁니들을 구현할 수 있음--->외부유니트에서는 사용 불가
//자기 밑에 서만 사용 가능
implementation
var
  j:integer;
procedure Hellow;
var
  k:integer;
begin
  ShowMessage('안녕');
end;
function Add(x,y:integer):integer;
begin
  result := x + y;
//    exit(x+y);   +2010버전부터 리턴값 사용 가능
//   Add := x + y; //+,-,*,/, div,mod
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
function person.GetName:string;
begin
  result := name;
end;
//초기처리:디폴트값할당,메모리할당, 통신기기접속.....
//uses절을 만나면 실행
{ TPerson }

constructor TPerson.create;
begin
  name := '김원경';
  Age := 20;
  Address := '서초구 반포동 사평대로';
end;

function TPerson.GetName: string;
begin
  result := name;
end;

{ TDog }

function TDog.GetName: string;
begin
  result := name;
end;

{ th }

constructor th.create;
begin
  inherited;
  hrs := 10;
  rate := 100000;
end;

function th.salary: integer;
begin
   result := hrs * rate;
end;

{ temp }

constructor temp.create;
begin
  inherited;
  office := '데브기어';
end;
//초기처리 :메모리할당, 디폴트값 할당
//uses절을 만나면 실행
initialization
  countries[0] := '한국';
  countries[1] := '일본';
  countries[2] := '미국';
  SetLength(a1,2);
  a1[0] := 'a1';
  SetLength(a2,2,2);
  a2[0,0] := 'a2';
finalization


end.
