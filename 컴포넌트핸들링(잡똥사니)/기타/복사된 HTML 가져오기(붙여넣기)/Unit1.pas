unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, MSHTML;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
  public
  end;

var
  Form1: TForm1;

implementation

uses
  ActiveX, StrUtils, SHDocVW;

{$R *.dfm}

var
  CF_HTML: UINT;

function GetCopiedHTML(var S: String): Boolean;
var
  DataObject: IDataObject;
  Etc: TFormatETC;
  Med: TSTGMedium;
  Res: Integer;
  DataPtr: PChar;
procedure DeleteHeaders;
  var
    SourceURL: String;
    PosResult1, PosResult2: Integer;
  begin
    SourceURL := '';
    PosResult1 := Pos( 'SourceURL:', S );
    if PosResult1 > 0 then
     begin
       PosResult2 := PosEx( #13, S, PosResult1 + 1 );
       if PosResult2 > PosResult1 then
        SourceURL := Copy( S, PosResult1 + Length( 'SourceURL:' ), PosResult2 - PosResult1 - Length( 'SourceURL:' ) );
     end;

     if SourceURL <> '' then SourceURL := '<BASE HREF="' + SourceURL + '">'#13#10
                        else SourceURL := '';

     S := SourceURL + Copy( S, Pos( '<HTML', S ), Length( S ) );
  end;  
begin
  Result := False;

  if OleGetClipboard( DataObject ) = S_OK then
   begin
     Etc.cfFormat := CF_HTML;
     Etc.ptd := nil;
     Etc.dwAspect := DVASPECT_CONTENT;
     Etc.lIndex := -1;
     Etc.Tymed := TYMED_HGLOBAL;

     Res := DataObject.GetData( Etc, Med );
     if Res = S_OK then
      begin
        DataPtr := GlobalLock( Med.hGlobal );
        try
          S := UTF8Decode( DataPtr );
        finally
          GlobalUnlock( Med.hGlobal );
        end;

        DeleteHeaders;

        Result := S <> '';
      end;
   end;
end;


{이거는 그냥 시험용으로 간단하게 만들어 본거나 별로 좋지 않다...쓰지말자..}
procedure HTMLToBitmap(const HTML: String; Bitmap: TBitmap);
var
  Window: TWinControl;
  WebBrowser: TWebBrowser;
  Control: TControl absolute WebBrowser;
  Document: IHTMLDocument2;
  Buffer: array[0..MAX_PATH-1] of Char;
  FileName: OleVariant;
begin
  GetTempPath( SizeOf( Buffer ), Buffer );
  FileName := String( Buffer ) + 'askdfhaasdfaksd.htm';
  with TFileStream.Create( FileName, fmCreate ) do
   try
     Write( HTML[1], Length( HTML ) )
   finally
     Free;
   end;

  try
    Window := TWinControl.Create( nil );
    try
      Window.Width := 0;
      Window.Height := 0;
      Window.Parent := Application.MainForm;
      WebBrowser := TWebBrowser.Create( nil );
      try
        WebBrowser.Visible := True;
        WebBrowser.AddressBar := False;
        WebBrowser.MenuBar := False;
        WebBrowser.ToolBar := 0;
        WebBrowser.StatusBar := False;
        WebBrowser.Width := Bitmap.Width;
        WebBrowser.Height := Bitmap.Height;
        WebBrowser.Resizable := False;
        Control.Parent := Window;
        WebBrowser.Navigate2( FileName );

        while WebBrowser.ReadyState <> READYSTATE_COMPLETE do
         Application.ProcessMessages;

        Document := WebBrowser.Document as IHTMLDocument2;
        OleDraw( Document, DVASPECT_CONTENT, Bitmap.Canvas.Handle, Rect( 0, 0, Bitmap.Width, Bitmap.Height ) );

      finally
        WebBrowser.Free;
      end;
    finally
      Window.Free;
    end;
  finally
    DeleteFile( FileName );
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  S: String;
  Bitmap: TBitmap;
begin
  if GetCopiedHTML( S ) then
   begin
     Memo1.Text := S;

     Bitmap := TBitmap.Create;
     try
       Bitmap.Width := ClientWidth;
       Bitmap.Height := ClientHeight;

       HTMLToBitmap( S, Bitmap );

       Canvas.Draw( 0, 0, Bitmap ); 

     finally
       Bitmap.Free;
     end;
   end;
end;

initialization
begin
  CF_HTML := RegisterClipboardFormat( 'HTML Format' );
end;

end.
