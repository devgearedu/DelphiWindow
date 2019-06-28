unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, ComCtrls, CommCtrl, StdCtrls, System.ImageList;

type
  TForm1 = class(TForm)
    ListView1: TListView;
    ImageList1: TImageList;
    ImageList2: TImageList;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ListView1ColumnClick(Sender: TObject; Column: TListColumn);
  private
    B1, B2, B3: Boolean;
  public
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

type
  TLVColumnEx = packed record
    mask: UINT;
    fmt: Integer;
    cx: Integer;
    pszText: PAnsiChar;
    cchTextMax: Integer;
    iSubItem: Integer;
    iImage: integer; // New
    iOrder: integer; // New
  end;

function ListView_GetColumnEx(LVWnd: HWND; iCol: Integer; var pcol: TLVColumnEx): bool;
begin
  Result := bool(SendMessage(LVWnd, LVM_GETCOLUMN, iCol, LPARAM(@pcol)));
end;

function ListView_SetColumnEx(LVWnd: HWnd; iCol: Integer; const pcol: TLVColumnEx): Bool;
begin
  Result := bool(SendMessage(LVWnd, LVM_SETCOLUMN, iCol, Longint(@pcol)));
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Header_SetImageList( FindWindowEx( ListView1.Handle, 0, 'SysHeader32', nil ), ImageList2.Handle );
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  Column: TLVColumnEx;
  i:word;
begin
//  ListView1.Columns[0].Caption := 'ÁöÈ­ÀÚ';
//  Exit;
  for I := 0 to ListView1.Columns.Count - 1 do
  begin
    FillChar(Column, SizeOf(Column), #0);
    ListView_GetColumnEx( ListView1.Handle, i, Column );

    Column.mask := Column.mask or LVCF_IMAGE or LVCF_FMT;
    Column.fmt := Column.fmt or LVCFMT_BITMAP_ON_RIGHT or LVCFMT_IMAGE;
    Column.iImage := Integer( B1 );

    B1 := not B1;
    ListView_SetColumnEx( ListView1.Handle, i, Column );
   end;
end;

procedure TForm1.ListView1ColumnClick(Sender: TObject;
  Column: TListColumn);
var
  AColumn: TLVColumnEx;
begin
  FillChar( AColumn, SizeOf(AColumn), 0 );
  ListView_GetColumnEx( ListView1.Handle, Column.Index, AColumn );

  AColumn.mask := AColumn.mask or LVCF_IMAGE or LVCF_FMT;
  AColumn.fmt := AColumn.fmt or LVCFMT_BITMAP_ON_RIGHT or LVCFMT_IMAGE;
  AColumn.iImage := Column.Index;

  B1 := not B1;

  ListView_SetColumnEx( ListView1.Handle, Column.Index, AColumn );
end;

end.
