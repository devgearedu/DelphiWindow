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
     ShowMessage( Device + '�� �� �� �����ϴ�.' );
     Exit;
   end;

  try

    SetFilePointer( DeviceHandle, Sector * 512, nil, FILE_BEGIN );
    if not ReadFile( DeviceHandle, Buffer, 512, BytesRead, nil ) then
     begin
       ShowMessage( Device + '�� ���� �� �����ϴ�.' );
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
     ShowMessage( Device + '�� �� �� �����ϴ�.' );
     Exit;
   end;

  try

    SetFilePointer( DeviceHandle, Sector * 512, nil, FILE_BEGIN );
    if not WriteFile( DeviceHandle, Buffer, Length( Buffer ), BytesRead, nil ) then
     begin
       Showmessage( Device + '�� �� �� �����ϴ�.' );
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

  ShowMessage( '���!'#13#13 +
               '�����̿��� ��ũ�� ����̺긦 ���� �а� ���� �����Դϴ�.'#13#13 +
               '"����"�� �׽�Ʈ�ϸ� ����̺��� ���Ͻý����� ���󰡰ų�'#13 +
               '��ũ�� ��Ƽ���� ���� �� �ֽ��ϴ�.'#13 +
               '(���� ����� ���� ������ ���Ͻý����̳� ��Ƽ���� �ٻ�� �ٷ� ���� �ִ� ����� ���� �����״�... --; )' );
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
  if MessageBox( Handle, '���⸦ �ϸ� ����̺��� ���Ͻý����̳� ��ũ�� ��Ƽ���� ���� �� �ֽ��ϴ�.'#13#13'���ڽ��ϱ�?', '���', MB_YESNO or MB_ICONWARNING ) <> IDYES then Exit;

  if Grid.Save( Buffer ) then
   WriteSector( CurrentDevice, UpDown_Sector.Position, Buffer );
end;

function TForm1.CurrentDevice: String;
begin
  Result := ComboBox_Drives.Items[ ComboBox_Drives.ItemIndex ];
end;

end.


