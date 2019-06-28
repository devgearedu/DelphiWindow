unit Utest_Generic;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,System.Generics.Collections;

type
  { Declare a new object type. }
  TNewObject = class
  private
    FName: String;

  public
    constructor Create(const AName: String);
    destructor Destroy(); override;
  end;

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button5: TButton;
    Button4: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TSimpleProcedure = reference to procedure;
  TSimpleFunction = reference to function(x:string):integer;

var
  Form1: TForm1;

implementation

uses Unit_generic, Unit_enonymous;

var
  List: TList<Integer>;
  FoundIndex: Integer;
  x: TMethodPointer;
  y: TStringToInt;
  Obj:TObj;

  x1: TSimpleProcedure;
  y1: TSimpleFunction;

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  F:TFoo;
begin
  F := TFoo.Create;
  F.Test;
  F.Free;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Obj := TObj.Create;
  x := Obj.HelloWord;
  x;
  y := Obj.GetLength;
  ShowMessage(IntToStr(y('hi')));
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  x1 := procedure
  begin
     ShowMessage('hello world');
  end;
  x1;  // 방금 정의된 루틴 호출

  y1 := function(x:string):integer
  begin
    result := Length(x);
  end;
  ShowMessage(IntToStr(y1('aaaa')));
end;

constructor TNewObject.Create(const AName: String);
begin
  FName := AName;
end;

destructor TNewObject.Destroy;
begin
  { Show a message whenever an object is destroyed. }
  ShowMessage('Object "' + FName + '" was destroyed!');
  inherited;
end;

procedure TForm1.Button4Click(Sender: TObject);
var
  List: TObjectList<TNewObject>;
  Obj: TNewObject;
begin
  { Create a new List. }
  { The OwnsObjects property is set by default to true -- the list will free the owned objects automatically. }
  List := TObjectList<TNewObject>.Create();

  { Add some items to the List. }
  List.Add(TNewObject.Create('One'));
  List.Add(TNewObject.Create('Two'));

  { Add a new item, but keep the reference. }
  Obj := TNewObject.Create('Three');
  List.Add(Obj);

  {
    Remove an instance of the TNewObject class. The destructor
    is called for the owned objects, because you have set the OwnsObjects
    to true.
  }
  List.Delete(0);
  List.Extract(Obj);

  { Destroy the List completely -- more message boxes will be shown. }
  List.Free;
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  { Create a new List. }
  List := TList<Integer>.Create;
  { Add a few values to the list. }
  List.AddRange([5, 1, 8, 2, 9, 14, 4, 5, 1]);
  showmessage('Index of first 1 is ' + IntToStr(List.IndexOf(1)));
  showmessage('Index of last 1 is ' + IntToStr(List.LastIndexOf(1)));
  showmessage('Does List contains element 100? ' + BoolToStr(List.Contains(100)));

  { Add another element to the list. }
  List.Add(100);

  showmessage('There are ' + IntToStr(List.Count) + ' elements in the list.');

  { Remove the first occurrence of 1. }
  List.Remove(1);
  { Delete a few elements from position 0. }
  List.Delete(0);
  List.DeleteRange(0, 2);
  { Extract the remaining 1 from the list. }
  List.Extract(1);
  { Set the capacity to the actual length. }
  List.TrimExcess;
  showmessage('Capacity of the list is ' + IntToStr(List.Capacity));

  { Clear the list. }
  List.Clear;
  { Insert some elements. }
  List.Insert(0, 2);
  List.Insert(1, 1);
  List.InsertRange(0, [6, 3, 8, 10, 11]);

  { Sort the list. }
  List.Sort;

  { Binary search for the required element. }
  if List.BinarySearch(6, FoundIndex) then
    showmessage('Found element 6 at index ' + IntToStr(FoundIndex));

  { Reverse the list. }
  List.Reverse;
  showmessage('The element on position 0 is ' + IntToStr(List.Items[0]));
  List.Free;

end;

end.
