
//---------------------------------------------------------------------------

// This software is Copyright (c) 2011 Embarcadero Technologies, Inc. 
// You may only use this software if you are an authorized licensee
// of Delphi, C++Builder or RAD Studio (Embarcadero Products).
// This software is considered a Redistributable as defined under
// the software license agreement that comes with the Embarcadero Products
// and is subject to that software license agreement.

//---------------------------------------------------------------------------
unit uSortThreads;

interface

uses
  Classes, Graphics, ExtCtrls,Vcl.StdCtrls,sysutils;

type

{ TSortThread }

  PThreadSortArray = ^TThreadSortArray;
  TThreadSortArray = array[0..MaxInt div SizeOf(Integer) - 1] of Integer;

  TSortThread = class(TThread)
  private
    FBox: TListBox;
    FResult_Box:TListBox;
    FSortArray: PThreadSortArray;
    FSize: Integer;
    FName:string;
  protected
    procedure Result_Print;
    procedure DOVisualSwap(i,j:integer); virtual; abstract;
    procedure Execute; override;
    procedure Sort(var A: array of Integer); virtual; abstract;
  public
    constructor Create( Box,Result_Box: TListBox; var SortArray: array of Integer);
  end;

{ TBubbleSort }

  TBubbleSort = class(TSortThread)
  protected
    procedure Sort(var A: array of Integer); override;
    procedure DOVisualSwap(i,j:integer); override;
  end;

{ TSelectionSort }

  TSelectionSort = class(TSortThread)
  protected
    procedure Sort(var A: array of Integer); override;
    procedure DOVisualSwap(i,j:integer); override;
  end;

{ TQuickSort }

  TQuickSort = class(TSortThread)
  protected
    procedure Sort(var A: array of Integer); override;
    procedure DOVisualSwap(i,j:integer); override;
  end;

var
  thread_Name:string;

implementation

{ TSortThread }

constructor TSortThread.Create( Box,Result_Box: TListBox; var SortArray: array of Integer);
begin
  FName := ClassName;
  FResult_Box := Result_Box;
  FBox := Box;
  FSortArray := @SortArray;
  FSize := High(SortArray) - Low(SortArray) + 1;
  FreeOnTerminate := True;
  inherited Create(False);
end;

{ The Execute method is called when the thread starts }

procedure TSortThread.Execute;
begin
  NameThreadForDebugging(AnsiString(ClassName));
  Sort(Slice(FSortArray^, FSize));
  Synchronize(Result_Print);
end;

procedure TSortThread.Result_Print;
begin
  FResult_Box.Items.Add(fname);
end;

{ TBubbleSort }

procedure TBubbleSort.DOVisualSwap(i, j: integer);
var
  T:string;
begin
   t := FBox.Items[j];
   FBox.Items[j] := FBox.Items[j+1];
   Fbox.Items[j+1] := t;
end;

procedure TBubbleSort.Sort(var A: array of Integer);
var
  I, J, T: Integer;
begin
  for I := High(A) downto Low(A) do
    for J := Low(A) to High(A) - 1 do
      if A[J] > A[J + 1] then
      begin
        Dovisualswap(-1,j);
        T := A[J];
        A[J] := A[J + 1];
        A[J + 1] := T;
        if Terminated then
          exit;
      end;
end;

{ TSelectionSort }

procedure TSelectionSort.DOVisualSwap(i, j: integer);
var
  T:string;
begin
   t := FBox.Items[i];
   FBox.Items[i] := FBox.Items[J];
   Fbox.Items[j] := t;
end;

procedure TSelectionSort.Sort(var A: array of Integer);
var
  I, J, T: Integer;
begin
  for I := Low(A) to High(A) - 1 do
    for J := High(A) downto I + 1 do
      if A[I] > A[J] then
      begin
        Dovisualswap(i,j);
        T := A[I];
        A[I] := A[J];
        A[J] := T;
        if Terminated then
          exit;

      end;
end;

{ TQuickSort }

procedure TQuickSort.DOVisualSwap(i, j: integer);
var
  t:string;
begin
     t := FBox.Items[i];
     FBox.Items[i] := FBox.Items[J];
     Fbox.Items[j] := t;
end;

procedure TQuickSort.Sort(var A: array of Integer);

  procedure QuickSort(var A: array of Integer; iLo, iHi: Integer);
  var
    Lo, Hi, Mid, T: Integer;
  begin
    Lo := iLo;
    Hi := iHi;
    Mid := A[(Lo + Hi) div 2];
    repeat
      while A[Lo] < Mid do Inc(Lo);
      while A[Hi] > Mid do Dec(Hi);
      if Lo <= Hi then
      begin
        Dovisualswap(Lo,Hi);
        T := A[Lo];
        A[Lo] := A[Hi];
        A[Hi] := T;
        Inc(Lo);
        Dec(Hi);
      end;
    until Lo > Hi;
    if Hi > iLo then QuickSort(A, iLo, Hi);
    if Lo < iHi then QuickSort(A, Lo, iHi);
    if Terminated then
      Exit;
  end;

begin
  QuickSort(A, Low(A), High(A));
end;

end.
