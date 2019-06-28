
unit USort;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, System.Diagnostics;


type
  TSortForm = class(TForm)
    StartBtn: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    BubbleSort_ListBox: TListBox;
    SelectionSort_ListBox: TListBox;
    QuickSort_ListBox: TListBox;
    Result_ListBox: TListBox;
    Label4: TLabel;
    procedure StartBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
//    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    ThreadsRunning: Integer;
    procedure RandomizeArrays;
    procedure ThreadDone(Sender: TObject);
  public
  end;

var
  SortForm: TSortForm;


implementation

uses uSortThreads;

{$R *.dfm}
type
  PSortArray = ^TSortArray;
  TSortArray =  array[0..100] of Integer;

var
  ArraysRandom: Boolean;
  BubbleSortArray, SelectionSortArray, QuickSortArray: TSortArray;

{ TThreadSortForm }

procedure TSortForm.FormCreate(Sender: TObject);
var
  i:byte;
begin
  RandomizeArrays;
  Result_ListBox.Clear;
  QuickSort_ListBox.Items.clear;
  BubbleSort_ListBox.Items.clear;
  SelectionSort_ListBox.Items.Clear;

  for I := 0 to 199 do
  begin
      QuickSort_ListBox.Items.add(IntToStr(QuickSortArray[i]));
      BubbleSort_ListBox.Items.add(IntToStr(BubbleSortArray[i]));
      SelectionSort_ListBox.Items.add(IntToStr(SelectionSortArray[i]));
  end;
end;

procedure TSortForm.StartBtnClick(Sender: TObject);
begin
  RandomizeArrays;
  Result_ListBox.Clear;
  ThreadsRunning := 3;
  with TBubbleSort.Create(BubbleSort_ListBox,Result_ListBox,BubbleSortArray) do
       OnTerminate := ThreadDone;

  with TSelectionSort.Create(SelectionSort_ListBox,Result_ListBox, SelectionSortArray)do
       OnTerminate := ThreadDone;

  with TQuickSort.Create(QuickSort_ListBox,Result_ListBox, QuickSortArray ) do
       OnTerminate := ThreadDone;

end;

procedure TSortForm.RandomizeArrays;
var
  I: Integer;
begin
  if not ArraysRandom then
  begin
    Randomize;
    for I := Low(BubbleSortArray) to High(BubbleSortArray) do
        BubbleSortArray[I] := Random(200);
    SelectionSortArray := BubbleSortArray;
    QuickSortArray := BubbleSortArray;
    ArraysRandom := True;
  end;
end;

procedure TSortForm.ThreadDone(Sender: TObject);
var
  i:byte;
begin
  Dec(ThreadsRunning);
  if ThreadsRunning = 0 then
  begin
    StartBtn.Enabled := True;
    ArraysRandom := False;
  end;
end;


end.
