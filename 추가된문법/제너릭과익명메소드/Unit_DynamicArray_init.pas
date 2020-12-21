unit Unit_DynamicArray_init;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,System.Generics.Collections;

type

  TNamePair = array[0..2] of String;
  TTest = array of string;

  TArrayEx = class(TArray)
  public
    class function CloneArray<T>(const A: array of T): TArray<T>;
  end;


  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

const
  Tests:TTest = ['a','b','c'];       //xe7에 추가 된 문법

  NameList:TNamePAIR = (('KIM'), ('LEE'), ('PARK'));

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  ShowMessage(Tests[2]);
end;

{ TArrayEx }

class function TArrayEx.CloneArray<T>(const A: array of T): TArray<T>;
var
  Idx: Integer;
begin
  SetLength(Result, Length(A));
  for Idx := Low(A) to High(A) do
      Result[Idx - Low(A)] := A[Idx];
end;


procedure TForm1.Button2Click(Sender: TObject);
var
  IA: TArray<Integer>;
  SA: TArray<string>;
  FA: TArray<real>;
begin
  IA := TArrayEx.CloneArray<Integer>([0,1,2,3,5,7,11,13,100,101,200,300,400]);
  SA := TArrayEx.CloneArray<string>(['bonnie', 'clyde','kwk', 'lee','jim']);
  FA := TArrayEx.CloneArray<real>([10.1,22.3]);

  ShowMessage(IntToStr(IA[10]));
end;



end.

