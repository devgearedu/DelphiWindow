unit Unit_generic;

interface
type
{  TSIPare = class
    Private
      FKey :String;
      FValue :Integer;
    Public
      Function GetKey:String;
      Procedure Setkey(Key:string);
      Function GetValue:Integer;
      Procedure SetValue(Value:Integer);
      Property Key:string read GetKey write SetKey;
      Property Value:integer read GetValue write SetValue;
  end; }
  TPair<TKey,TValue> = class
    Private
      FKey :TKey;
      FValue :TValue;
    Public
      Function GetKey:TKey;
      Procedure Setkey(Key:TKey);
      Function GetValue:TValue;
      Procedure SetValue(Value:TValue);
      Property Key:TKey read GetKey write SetKey;
      Property Value:TValue read GetValue write SetValue;
  end;

  TSIPair = TPair<String,Integer>;
  TSSPair = TPair<String,String>;
  TIIPair = TPair<Integer,Integer>;
  TISPair = TPair<Integer,String>;

  TMyProc<T> = Procedure(Param:T);
  TMyProc2<Y> = Procedure(Param1,Param2:Y) of object;

  TFoo = class
    Procedure Test;
    Procedure MyProc(x,y:Integer);
  end;

Procedure Sample(Param:Integer);

implementation
uses
  dialogs,sysutils;

{ TPair<TKey, TValue> }

Procedure Sample(Param:Integer);
begin
  showmessage(inttostr(Param));
end;

function TPair<TKey, TValue>.GetKey: TKey;
begin
  RESULT := FKey;
end;

function TPair<TKey, TValue>.GetValue: TValue;
begin
  Result := FValue;
end;

procedure TPair<TKey, TValue>.Setkey(Key: TKey);
begin
 FKey := Key;
end;

procedure TPair<TKey, TValue>.SetValue(Value: TValue);
begin
  FValue := Value;
end;

{ TFoo }

procedure TFoo.MyProc(x, y: Integer);
begin
   SHOWmessage(format('X :%d Y: %d', [X,Y]));
end;

procedure TFoo.Test;
Var
  X :TMyProc<Integer>;
  Y :TMyProc2<Integer>;
begin
  X := Sample;
  X(10);
  Y := MyProc;
  Y(20,30);
end;
end.
