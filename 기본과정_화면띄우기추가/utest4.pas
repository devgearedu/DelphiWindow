unit utest4;
// type, var const, procedure, function 선언
// 이곳에 선언된 type, var const, procedure, function들은
// 자기유니트 및 외부 유니트에서 사용 가능
interface
uses  vcl.Dialogs;
type

   TPerson = class(Tobject)
   private
     ttt:string;     // 단 같은 유니트에서는 다른  클래스 사용 가능
   strict private    //+2007 더 제한적인 (같은 유니트에서도 사용 불가))
   protected
   strict protected
   public
     Name:string;
     Age:byte;
     Address:string;
     function GetName:string;
     constructor create; virtual;
   end;

   TDog = class
     Name:string;
     Age:byte;
     Address:string;
     function GetName:string;
   end;

   TEmp = Class(TPerson)
      Company:string;
      function salary:integer; virtual; abstract;     //dyanamic
      constructor create; override;
   End;

   TH = class(TEmp)        //class sealed(temp) 더 이상 계승안됨
     hrs:integer;
     rate:integer;
     function salary:integer; override;  final;
     constructor create; override;
   end;

   th1 = class(th)
     rank:string;
//     function salary:integer; override;
     constructor create; override;
   end;

   Person = record
     Name:string;
     Age:byte;
     Address:string;
     function GetName:string;    //+2007 레코드에도 루틴 추가 가능
   end;

   p_person = ^person;

   country = array [0..2] of string;
var
   p:p_person;
   countries:country;   // =('korea', 'america','japan');
   a1:array of string;
   a2:array of array of string;
   s:string;
    //디폴트 문자열 의미 2009~ : unicodestring,1.0 :shorttring, 2.0~2009이전 ansistring
   i:NativeInt = 100;    //32  or 64bit
   r:real;
   t:TDateTime;
   b:boolean; // bytebool, wordbool, longbool
   v:variant;
// 문자,숫자,날자, 불린, 정적배열, 동적베열, ole object(엑셀 워드..)
// unssigned 16 byte ---> 메모리 많이 ---> 속도 저하
   pi:^integer;
   ps:pchar;  //pAnsiChar, pUnicodeChar  PWideChar
procedure Hello;
function Add(x:integer = 2; y:integer = 3):integer;  inline;
function Sub(x,y:integer):integer;
function Divide(x,y:integer):integer; overload;
function divide(x,y:real):extended;  overload;

// (var x:integer) call bat ref
// (const x:string) call by const;
// (out x:integere)  x 변수에 값을 변경해서 넘길떄
//위에서 선언된 루틴들을 구현하는곳
//type,var,const,procedure,function 선언 ---> 외부 유니트에서는 사용 불가
implementation
var
  j:integer = 10;
procedure hello;
var
  k:integer;
begin
  ShowMessage('안녕하세요');
end;
function Add(x,y:integer):integer;
begin

//  add := x + y;
    result := x + y;  // +, -, *, /(실수), DIV(정수), MOD
//  exit(x+y);    //+2010
    x   := 200;
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
//초기처리 :메모리할당, 값을 할당, uses절을 만나면 실행
{ TPerson }

constructor TPerson.create;
begin
   Name := '김원경';
   Age := 20;
   Address := '서초구 반포동';
end;

function TPerson.GetName: string;
begin
   result := name;
end;

{ TDog }

function TDog.GetName: string;
begin
  result := Name;
end;

{ TH }

constructor TH.create;
begin
  inherited;
  hrs := 10;
  rate := 100000;
end;

function TH.salary: integer;
begin
  result := hrs * rate;
end;

{ TEmp }

constructor TEmp.create;
begin
  inherited;
  ComPany := '데브기어';
end;

{ th1 }

constructor th1.create;
begin
  inherited;
  rank := '임시';
end;


initialization
begin
   countries[0] := '한국';
   countries[1] := '미국';
   Countries[2] := '일본';
   SetLength(a1,2);
   a1[0] := 'a1';
   setLength(a2,2,2);
   a2[0,0] := 'a2';
end;
finalization
//초기화 섹션이 있는 유니트에만  사용.
//초기화 섹션에 할당 된 리소스를 해제,초기화 섹션과 반대 순서로 실행
//예를 들어애플리케이션이 유닛 A->B->C 초기화화면 C -> B-> A 로 실행

end.
