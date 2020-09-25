unit utest4;
// type, var const, procedure, function ����
// �̰��� ����� type, var const, procedure, function����
// �ڱ�����Ʈ �� �ܺ� ����Ʈ���� ��� ����
interface
uses  vcl.Dialogs;
type

   TPerson = class(Tobject)
   private
     ttt:string;     // �� ���� ����Ʈ������ �ٸ�  Ŭ���� ��� ����
   strict private    //+2007 �� �������� (���� ����Ʈ������ ��� �Ұ�))
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

   TH = class(TEmp)        //class sealed(temp) �� �̻� ��¾ȵ�
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
     function GetName:string;    //+2007 ���ڵ忡�� ��ƾ �߰� ����
   end;

   p_person = ^person;

   country = array [0..2] of string;
var
   p:p_person;
   countries:country;   // =('korea', 'america','japan');
   a1:array of string;
   a2:array of array of string;
   s:string;
    //����Ʈ ���ڿ� �ǹ� 2009~ : unicodestring,1.0 :shorttring, 2.0~2009���� ansistring
   i:NativeInt = 100;    //32  or 64bit
   r:real;
   t:TDateTime;
   b:boolean; // bytebool, wordbool, longbool
   v:variant;
// ����,����,����, �Ҹ�, �����迭, ��������, ole object(���� ����..)
// unssigned 16 byte ---> �޸� ���� ---> �ӵ� ����
   pi:^integer;
   ps:pchar;  //pAnsiChar, pUnicodeChar  PWideChar
procedure Hello;
function Add(x:integer = 2; y:integer = 3):integer;  inline;
function Sub(x,y:integer):integer;
function Divide(x,y:integer):integer; overload;
function divide(x,y:real):extended;  overload;

// (var x:integer) call bat ref
// (const x:string) call by const;
// (out x:integere)  x ������ ���� �����ؼ� �ѱ拚
//������ ����� ��ƾ���� �����ϴ°�
//type,var,const,procedure,function ���� ---> �ܺ� ����Ʈ������ ��� �Ұ�
implementation
var
  j:integer = 10;
procedure hello;
var
  k:integer;
begin
  ShowMessage('�ȳ��ϼ���');
end;
function Add(x,y:integer):integer;
begin

//  add := x + y;
    result := x + y;  // +, -, *, /(�Ǽ�), DIV(����), MOD
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
//�ʱ�ó�� :�޸��Ҵ�, ���� �Ҵ�, uses���� ������ ����
{ TPerson }

constructor TPerson.create;
begin
   Name := '�����';
   Age := 20;
   Address := '���ʱ� ������';
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
  ComPany := '������';
end;

{ th1 }

constructor th1.create;
begin
  inherited;
  rank := '�ӽ�';
end;


initialization
begin
   countries[0] := '�ѱ�';
   countries[1] := '�̱�';
   Countries[2] := '�Ϻ�';
   SetLength(a1,2);
   a1[0] := 'a1';
   setLength(a2,2,2);
   a2[0,0] := 'a2';
end;
finalization
//�ʱ�ȭ ������ �ִ� ����Ʈ����  ���.
//�ʱ�ȭ ���ǿ� �Ҵ� �� ���ҽ��� ����,�ʱ�ȭ ���ǰ� �ݴ� ������ ����
//���� �����ø����̼��� ���� A->B->C �ʱ�ȭȭ�� C -> B-> A �� ����

end.
