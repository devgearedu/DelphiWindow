unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Grids, Grid, ComCtrls;

type 
  TStringGrid = class(Grid.TStringGrid);

  TForm1 = class(TForm)
    Panel1: TPanel;
    Label_Sector: TLabel;
    Label_Drive: TLabel;
    Edit_Sector: TEdit;
    Button_Read: TButton;
    Button_Write: TButton;
    ComboBox_Drives: TComboBox;
    Grid: TStringGrid;
    UpDown_Sector: TUpDown;
    procedure FormCreate(Sender: TObject);
    procedure Button_ReadClick(Sender: TObject);
    procedure Button_WriteClick(Sender: TObject);
  private
    function CurrentDevice: String;
  public
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure ScanDrives(Strings: TStrings);
procedure AddDrives;
  var
    Drives: DWord;
    C: Char;
  begin
    Drives := GetLogicalDrives;
    for C := 'A' to 'Z' do
     begin
       if ( Drives and 1 ) = 1 then
        Strings.Add( C + ':');
       Drives := Drives shr 1;
     end;
  end;
procedure AddPhysicalDisks;
  var
    i: Integer;
    S: String;
    R: THandle;
  begin
    i := 0;
    while True do
     begin
       S := '\\.\PHYSICALDRIVE' + IntToStr( i );
       R := CreateFile( PChar( S ), GENERIC_READ, FILE_SHARE_WRITE or FILE_SHARE_READ, nil, OPEN_EXISTING, 0, 0 );
       if R = INVALID_HANDLE_VALUE then Break;

       Strings.Add( 'PHYSICALDRIVE' + IntToStr( i ) );
       CloseHandle( R );
       Inc( i );
     end;
  end;
begin
  AddDrives;
  AddPhysicalDisks;
end;

function ReadSector(const Device: String; Sector: Integer; var Buffer: TBuffer): Boolean;
var
  DeviceHandle: THandle;
  BytesRead: DWord;
  DeviceName: String;
begin
  Result := False;

  DeviceName := '\\.\' + Device;
  DeviceHandle := CreateFile( PChar( DeviceName ), GENERIC_READ, FILE_SHARE_WRITE or FILE_SHARE_READ, nil, OPEN_EXISTING, 0, 0 );
  if DeviceHandle = INVALID_HANDLE_VALUE then
   begin
     ShowMessage( Device + '를 열 수 없습니다.' );
     Exit;
   end;

  try

    SetFilePointer( DeviceHandle, Sector * 512, nil, FILE_BEGIN );
    if not ReadFile( DeviceHandle, Buffer, 512, BytesRead, nil ) then
     begin
       ShowMessage( Device + '를 읽을 수 없습니다.' );
       Exit;
     end;

  finally
    CloseHandle( DeviceHandle );
  end;

  Result := True;
end;

procedure WriteSector(const Device: String; Sector: Integer; const Buffer: TBuffer);
var
  DeviceHandle: THandle;
  BytesRead: DWord;
  DeviceName: String;
begin
  DeviceName := '\\.\' + Device;
  DeviceHandle := CreateFile( PChar( DeviceName ), GENERIC_WRITE, FILE_SHARE_WRITE or FILE_SHARE_READ, nil, OPEN_EXISTING, 0, 0 );

  if DeviceHandle = INVALID_HANDLE_VALUE then
   begin
     ShowMessage( Device + '를 열 수 없습니다.' );
     Exit;
   end;

  try

    SetFilePointer( DeviceHandle, Sector * 512, nil, FILE_BEGIN );
    if not WriteFile( DeviceHandle, Buffer, Length( Buffer ), BytesRead, nil ) then
     begin
       Showmessage( Device + '에 쓸 수 없습니다.' );
       Exit;
     end;

  finally
    CloseHandle( DeviceHandle );
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  ScanDrives( ComboBox_Drives.Items );
  ComboBox_Drives.ItemIndex := 0;

  Grid.InitFixedCol;

  ShowMessage( '경고!'#13#13 +
               '델파이에서 디스크나 드라이브를 직접 읽고 쓰는 예제입니다.'#13#13 +
               '"쓰기"를 테스트하면 드라이브의 파일시스템이 날라가거나'#13 +
               '디스크의 파티션이 날라갈 수 있습니다.'#13 +
               '(물론 제대로 쓰면 되지만 파일시스템이나 파티션을 핵사로 바로 쑬수 있는 사람은 별로 없을테니... --; )' );
end;

procedure TForm1.Button_ReadClick(Sender: TObject);
var
  Buffer: TBuffer;
begin
  Grid.Clear;
  if ReadSector( CurrentDevice, UpDown_Sector.Position, Buffer ) then
   begin
     Grid.Load( Buffer );
   end;
end;

procedure TForm1.Button_WriteClick(Sender: TObject);
var
  Buffer: TBuffer;
begin
  if MessageBox( Handle, '쓰기를 하면 드라이브의 파일시스템이나 디스크의 파티션이 날라갈 수 있습니다.'#13#13'쓰겠습니까?', '경고', MB_YESNO or MB_ICONWARNING ) <> IDYES then Exit;

  if Grid.Save( Buffer ) then
   WriteSector( CurrentDevice, UpDown_Sector.Position, Buffer );
end;

function TForm1.CurrentDevice: String;
begin
  Result := ComboBox_Drives.Items[ ComboBox_Drives.ItemIndex ];
end;

end.


