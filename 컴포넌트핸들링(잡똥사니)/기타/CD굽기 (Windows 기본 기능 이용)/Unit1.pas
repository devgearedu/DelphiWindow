{$WARN UNIT_PLATFORM OFF}

unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CDBurner, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    OpenDialog1: TOpenDialog;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    CDBurner: TCDBurner;
    procedure BurnDone(Sender: TObject);
  public
  end;

var
  Form1: TForm1;

implementation

uses
  FileCtrl, ShellAPI;

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  CDBurner := TCDBurner.Create( Self );
  CDBurner.OnDone := BurnDone;

  if CDBurner.Active then
   begin
     Caption := Caption + ' - ' + CDBurner.BurnerDrive;
     Button1.Enabled := True;
     Button2.Enabled := True;
   end;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if CDBurner.Burning then
   begin
     Action := caNone;
     ShowMessage( 'CD 굽는 중이다 기달려라...' );
   end;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  CDBurner.Free;
end;

function CopyToCDBurner(const FromDir, ToDir: String): Boolean;
var
  FileOpStruct: TSHFileOpStruct;
begin
  FileOpStruct.wFunc := FO_COPY;
  FileOpStruct.pFrom := PChar( FromDir + #0 );
  FileOpStruct.pTo := PChar( ToDir + #0 );

  FileOpStruct.fFlags := FOF_NOCONFIRMATION or FOF_NOCONFIRMMKDIR or FOF_SILENT;
  Result := not Boolean( SHFileOperation( FileOpStruct ) );
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  Path: String;
begin
  if SelectDirectory( '^^', '^^', Path ) then
   begin
     if Path[ Length( Path ) ] = '\' then Delete( Path, Length( Path ), 1 );
     if CopyToCDBurner( Path, CDBurner.BurnArea ) then
      begin
        Button1.Enabled := False;
        Button2.Enabled := False;
        CDBurner.StartBurn;
      end;
   end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  S: String;
  i: Integer;
begin
  if OpenDialog1.Execute then
   begin
     S := '';
     for i := 0 to OpenDialog1.Files.Count - 1 do
      S := S + OpenDialog1.Files[ i ] + #0;

     if CopyToCDBurner( S, CDBurner.BurnArea ) then
      begin
        Button1.Enabled := False;
        Button2.Enabled := False;
        CDBurner.StartBurn;
      end;
   end;
end;

procedure TForm1.BurnDone(Sender: TObject);
begin
  Button1.Enabled := True;
  Button2.Enabled := True;
  ShowMessage( '끝' );
end;

end.
