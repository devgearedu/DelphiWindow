unit Main_Frm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs,StdCtrls, Buttons, ComCtrls, ToolWin, ExtCtrls, ExtDlgs,
  BitmapLists, IconsUtil;

type
  TMain_Form = class(TForm)
    OpenDialog: TOpenPictureDialog;
    ListBox: TListBox;
    Image: TImage;
    SaveDialog: TSavePictureDialog;
    ToolBar: TToolBar;
    Button_Open: TToolButton;
    Button_Save: TToolButton;
    CoolBar: TCoolBar;
    Button_Exit: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button_OpenClick(Sender: TObject);
    procedure Button_SaveClick(Sender: TObject);
    procedure Button_ExitClick(Sender: TObject);
    procedure ListBoxDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure ListBoxMeasureItem(Control: TWinControl; Index: Integer; var Height: Integer);
    procedure ListBoxClick(Sender: TObject);
  private
    BitmapList: TBitmapList;
  public
  end;

var
  Main_Form: TMain_Form;

implementation

{$R *.DFM}
{$R WindowsXP.res}

procedure ShowMessage(const S: String);
begin
  MessageBox( Application.MainForm.Handle, PChar( S ), '아쒸~', MB_OK or MB_ICONINFORMATION );
end;

procedure TMain_Form.FormCreate(Sender: TObject);
begin
  BitmapList := TBitmapList.Create;
end;

procedure TMain_Form.FormDestroy(Sender: TObject);
begin
  BitmapList.Free;
end;

procedure TMain_Form.Button_OpenClick(Sender: TObject);
var
  i: Integer;
begin
  if OpenDialog.Execute then
   begin
     ListBox.Items.BeginUpdate;
     try
       ListBox.Items.Clear;
       BitmapList.Clear;

       ReadIconFileToBitmapList( OpenDialog.FileName, BitmapList );

       for i := 0 to BitmapList.Count - 1 do
        ListBox.Items.Add( '' );
     finally
       ListBox.Items.EndUpdate;
     end;

     if BitmapList.Count = 0 then
      begin
        ShowMessage( '이 아이콘 파일에는 본 프로그램이 지원 가능한 아이콘이미지가 없습니다' );
        Exit;
      end;

     Button_Save.Enabled := ListBox.SelCount > 0;
   end;
end;

procedure TMain_Form.Button_SaveClick(Sender: TObject);
var
  BmpList: TBitmapList;
  i: Integer;
begin
  if ListBox.SelCount = 0 then
   begin
     ShowMessage( '리스트에서 저장 할 아이콘들을 선택하십시오' );
     Exit;
   end;

  if SaveDialog.Execute then
   begin
     if LowerCase( ExtractFileExt( SaveDialog.FileName ) ) <> '.ico' then SaveDialog.FileName := SaveDialog.FileName + '.ico';

     BmpList := TBitmapList.Create;
     try
       BmpList.FreeBeforeDelete := False;

       for i := 0 to ListBox.Items.Count - 1 do
        if ListBox.Selected[ i ] then
         BmpList.Add( BitmapList[ i ] );

       WriteIconFileFromBitmapList( SaveDialog.FileName, BmpList );
     finally
       BmpList.Free;
     end;
   end;
end;

procedure TMain_Form.Button_ExitClick(Sender: TObject);
begin
  Close;
end;

const
  Border = 5;

procedure TMain_Form.ListBoxDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  Canvas: TCanvas;
  S: String;
  Icon: TIcon;
  Stream: TStream;
begin
  Canvas := TListBox( Control ).Canvas;
  Canvas.Font := TListBox( Control ).Font;

  if odSelected in State then
   begin
     Canvas.Brush.Color := clHighlight;
     Canvas.Font.Color := clHighlightText;
   end
  else
   begin
     Canvas.Brush.Color := TListBox( Control ).Color;
     Canvas.Font.Color := TListBox( Control ).Font.Color;
   end;

  Canvas.FillRect( Rect );


  Icon := TIcon.Create;
  Stream := TMemoryStream.Create;
  try

    WriteIconStreamFromBitmap( Stream, BitmapList[ Index ] );
    Stream.Position := 0;
    Icon.LoadFromStream( Stream );

    Canvas.Draw( Rect.Left + Border, Rect.Top + Border, Icon );

  finally
    Stream.Free;
    Icon.Free;
  end;


  S := IntToStr( BitmapList[ Index ].Width ) + 'X ' + IntToStr( BitmapList[ Index ].Height ) + '   ';

  case BitmapList[ Index ].PixelFormat of
  pf1bit : S := S + '1Bit';
  pf4bit : S := S + '4Bit';
  pf8bit : S := S + '8Bit';
  pf15bit: S := S + '15Bit';
  pf16bit: S := S + '16Bit';
  pf24bit: S := S + '24Bit';
  pf32bit: S := S + '32Bit';
  end;

  Canvas.TextOut( 60, Rect.Top + ( ( ( Rect.Bottom - Rect.Top ) - Abs( Canvas.Font.Height ) ) div 2 ), S );
end;

procedure TMain_Form.ListBoxMeasureItem(Control: TWinControl; Index: Integer; var Height: Integer);
begin
  Height := BitmapList[ Index ].Height + Border * 2;
end;

procedure TMain_Form.ListBoxClick(Sender: TObject);
var
  Icon: TIcon;
  Stream: TStream;
begin
  Button_Save.Enabled := ( TListBox( Sender ).SelCount > 0 ) and ( BitmapList.Count > 0 );

  if TListBox( Sender ).ItemIndex >= 0 then
   begin
     Icon := TIcon.Create;
     Stream := TMemoryStream.Create;
     try
       WriteIconStreamFromBitmap( Stream, BitmapList[ TListBox( Sender ).ItemIndex ] );
       Stream.Position := 0;
       Icon.LoadFromStream( Stream );
       Image.Picture.Assign( Icon );
     finally
       Stream.Free;
       Icon.Free;
     end;
   end;
end;

end.
