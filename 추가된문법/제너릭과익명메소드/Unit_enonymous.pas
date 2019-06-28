unit Unit_enonymous;

interface
uses
  dialogs;
Type
  TMethodPointer = Procedure of object;
  TStringToInt = Function(x:string):integer of object;


  TObj = class
    Procedure HelloWord;
    Function  GetLength(x:string):integer;
  end;


implementation

{ Tobj }

function Tobj.GetLength(x: string): integer;
begin
  result := Length(x);
end;

procedure Tobj.HelloWord;
begin
   ShowMessage('Hello World');
end;

end.
