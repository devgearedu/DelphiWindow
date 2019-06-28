unit CDBurner;

interface

uses
  Windows, Messages, SysUtils, Classes, COMObj, ShlObj, ActiveX, Forms;

type
  TBurnDoneEvent = procedure(Sender: TObject) of object;

{ TCDBurner }

  TCDBurner = class(TComponent)
  private
    FCDBurn: IUnknown;
    FActive: Boolean;
    FBurnArea: String;
    FBurnerDrive: String;
    FBurning: Boolean;
    FOnDone: TBurnDoneEvent;
  public
    constructor Create(AOwner: TComponent); override;
    function StartBurn: Boolean;
    property Active: Boolean read FActive;
    property BurnArea: String read FBurnArea;
    property BurnerDrive: String read FBurnerDrive;
    property Burning: Boolean read FBurning;
  published
    property OnDone: TBurnDoneEvent read FOnDone write FOnDone;
  end;

implementation

const
  CLSID_CDBURN: TGUID = '{FBEB8A05-BEEE-4442-804E-409D6C4515E9}';
  CSIDL_CDBURN_AREA   = $3B;

type

{ ICDBurn }

  ICDBurn = interface(IUnknown)
    ['{3D73A659-E5D0-4D42-AFC0-5121BA425C8D}']
    function GetRecorderDriveLetter(var StrDrive: WideChar; CharCount: UINT): HResult; stdcall;
    function Burn(hWindow: HWND): HResult; stdcall;
    function HasRecordableDrive(out pfHasRecorder: Bool): HResult; stdcall;
  end;
  
{ TCDBurner }

constructor TCDBurner.Create(AOwner: TComponent);
function CreateInterface: Boolean;
  begin
    try
      FCDBurn := CreateCOMObject( CLSID_CDBURN ) as ICDBurn;
      Result := True;
    except
      Result := False;
    end;
  end;
function GetCDBurnArea: Boolean;
  var
    ItemIDList: PItemIDList;
    Buffer: array [0..MAX_PATH] of Char;
    Malloc: IMalloc;
  begin
    Result := False;
    if Succeeded( SHGetSpecialFolderLocation( 0, CSIDL_CDBURN_AREA, ItemIDList ) ) then
     if ItemIDList <> nil then
      begin
        if SHGetPathFromIDList( ItemIDList, Buffer ) then
         begin
           FBurnArea := Buffer;
           if FBurnArea[ Length( FBurnArea ) ] <> '\' then FBurnArea := FBurnArea + '\';
           Result := True;
         end;

        if Succeeded( SHGetMalloc( Malloc ) ) then Malloc.Free( ItemIDList );
      end;
  end;
function GetCDBurnDrive: Boolean;
  var
    HasDrive: BOOL;
    S: array[0..3] of WideChar;
  begin
    Result := False;
    ( FCDBurn as ICDBurn ).HasRecordableDrive( HasDrive );
    if HasDrive and ( ( FCDBurn as ICDBurn ).GetRecorderDriveLetter( S[0], SizeOf( S ) ) = S_OK  ) then
     begin
       FBurnerDrive := S;
       Result := True;
     end;
  end;
begin
  inherited Create( AOwner );

  if csDesigning in ComponentState then Exit;

  FActive := False;
  FBurning := False;
  FBurnArea := '';
  FBurnerDrive := '';

  if CreateInterface and GetCDBurnArea and GetCDBurnDrive then FActive := True;
end;

function TCDBurner.StartBurn: Boolean;
begin
  Result := False;
  if FActive and not FBurning then
   begin
     FBurning := True;
     try
       ( FCDBurn as ICDBurn ).Burn( Application.Handle );
     finally
       FBurning := False;
       if Assigned( OnDone ) then OnDone( Self );
     end;

     Result := True;
   end;
end;

end.
