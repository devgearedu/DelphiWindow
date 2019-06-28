unit FileLists;

interface

uses
  Windows, Classes, SysUtils, ShellAPI, ImgList, ComCtrls, Controls;

type

{ TFileList }

  PFile = ^TFile;
  TFile = record
    Name: String;
    Path: String;
    Date: TDateTime;
    Size: Int64;
    ShellInfo: record
      ImageIndex: Integer;
      Directory: Boolean;
      FileSize: String;
      FileType: String;
      FileDate: String;
    end;
  end;

  TFileList = class
  private
    FList: TList;
    FOnChange: TNotifyEvent;
    function GetItems(Index: Integer): PFile;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Add(const Path: String; FindData: PWin32FindData);
    function Count: Integer;
    procedure Clear;
    procedure Delete(Index: Integer);
    function GetText(Index: Integer): String;
    procedure MakeShellInfo(Index: Integer);
    property Items[Index: Integer]: PFile read GetItems; default;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

function FileSize(FindData: PWin32FindData): Int64;  
function FileDateTime(FileTime: TFileTime): TDateTime;
function FileType(const FileName: String): String;

implementation

function FileSize(FindData: PWin32FindData): Int64;
begin
  Result := (Int64(FindData.nFileSizeHigh) shl 32) + FindData.nFileSizeLow;
end;

function FileDateTime(FileTime: TFileTime): TDateTime;
var
  LocalFileTime: TFileTime;
  SysTime: TSystemTime;
function ValidFileTime( FileTime: TFileTime ): Boolean;
  begin
    Result := ( FileTime.dwLowDateTime <> 0 ) or ( FileTime.dwHighDateTime <> 0 );
  end;
begin
  FillChar( LocalFileTime, SizeOf( TFileTime ), #0 );

  if ValidFileTime( FileTime ) and FileTimeToLocalFileTime( FileTime, LocalFileTime ) and FileTimeToSystemTime( LocalFileTime, SysTime ) then
   try
     Result := SystemTimeToDateTime( SysTime );
   except
     Result := Now;
   end
  else
   Result := Now;;
end;

function FileType(const FileName: String): String;
var
  ShInfo: TSHFileInfo;
begin
  ShGetFileInfo( PChar(FileName), FILE_ATTRIBUTE_NORMAL, ShInfo, SizeOf(SHFileInfo), SHGFI_TYPENAME );
  Result := ShInfo.szTypeName;
end;

function GetFileImageIcon(const FileName: String): Integer;
var
  SHFileInfo: TSHFileInfo;
begin
  ShGetFileInfo( PChar(FileName), 0, SHFileInfo, SizeOf(SHFileInfo), SHGFI_SYSICONINDEX or SHGFI_EXETYPE );
  Result := SHFileInfo.iIcon;
end;

function GetFileType(const FileName: String; var Directory: Boolean): String;
var
  ShInfo: TSHFileInfo;
  Attribute: DWord;
begin
  Directory := DirectoryExists( FileName );
  if Directory then Attribute := FILE_ATTRIBUTE_DIRECTORY
               else Attribute := FILE_ATTRIBUTE_NORMAL;

  ShGetFileInfo( PChar(FileName), Attribute, ShInfo, SizeOf(SHFileInfo), SHGFI_TYPENAME or SHGFI_USEFILEATTRIBUTES );
  Result := ShInfo.szTypeName;
  if Result = '' then
   begin
     Result := UpperCase( ExtractFileExt( FileName ) ) + ' ÆÄÀÏ';
     System.Delete( Result, 1, 1 );
   end;
end;

{ TFileList }

constructor TFileList.Create;
begin
  inherited Create;

  FList := TList.Create;
end;

destructor TFileList.Destroy;
begin
  Clear;
  FList.Free;

  inherited Destroy;
end;

procedure TFileList.Add(const Path: String; FindData: PWin32FindData);
var
  AFile: PFile;
begin
  New( AFile );
  ZeroMemory( AFile, SizeOf(TFile) );
  AFile^.Name := FindData.cFileName;
  AFile^.Path := Path;
  AFile^.Date := FileDateTime( FindData.ftLastWriteTime );
  AFile^.Size := FileSize( FindData );

  FList.Add( AFile );

  if Assigned( OnChange ) then OnChange( Self );
end;

procedure TFileList.Clear;
var
  i: Integer;
begin
  for i := Count - 1 downto 0 do
   Dispose( FList[ i ] );
  FList.Clear;

  if Assigned( OnChange ) then OnChange( Self );
end;

function TFileList.Count: Integer;
begin
  Result := FList.Count;
end;

procedure TFileList.Delete(Index: Integer);
begin
  Dispose( FList[ Index ] );
  FList.Delete( Index );

  if Assigned( OnChange ) then OnChange( Self );
end;

function TFileList.GetItems(Index: Integer): PFile;
begin
  Result := FList[ Index ];
end;

function TFileList.GetText(Index: Integer): String;
begin
  Result := Items[ Index ].Path + Items[ Index ].Name;
end;

procedure TFileList.MakeShellInfo(Index: Integer);
var
  AFile: PFile;
begin
  AFile := Items[ Index ];
  if AFile.ShellInfo.ImageIndex = 0 then
   begin
     AFile.ShellInfo.ImageIndex := GetFileImageIcon( AFile.Path + AFile.Name );
     AFile.ShellInfo.FileType := GetFileType( AFile.Path + AFile^.Name, AFile.ShellInfo.Directory );
     AFile.ShellInfo.FileDate := DateTimeToStr( AFile.Date );
     if AFile.ShellInfo.Directory then AFile.ShellInfo.FileSize := ''
                                  else AFile.ShellInfo.FileSize := FormatFloat( '#,##0', AFile.Size ) + ' Bytes';
   end;
end;

end.
