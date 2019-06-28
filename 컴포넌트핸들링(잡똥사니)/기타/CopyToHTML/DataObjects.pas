unit DataObjects;

interface

procedure CopyHTMLToClipboard(const HTML: String);

implementation

uses
  Windows, Messages, Classes, SysUtils, ShlObj, ActiveX;

type

{ TDataObject }

  TDataObject = class(TInterfacedObject, IDataObject)
  private
    FDataFormatsCount: Integer;
    FDataFormats: array[0..19] of TFormatEtc;
    FHTML: String;
  protected
   {IDataObject}
    function GetData(const FormatEtcIn: TFormatEtc; out Medium: TStgMedium):HRESULT; stdcall;
    function GetDataHere(const FormatEtc: TFormatEtc; out Medium: TStgMedium):HRESULT; stdcall;
    function QueryGetData(const FormatEtc: TFormatEtc): HRESULT; stdcall;
    function GetCanonicalFormatEtc(const FormatEtc: TFormatEtc; out FormatEtcout: TFormatEtc): HRESULT; stdcall;
    function SetData(const FormatEtc: TFormatEtc; var Medium: TStgMedium; Release: Bool): HRESULT; stdcall;
    function EnumFormatEtc(dwDirection: Integer; out EnumFormatEtc: IEnumFormatEtc): HRESULT; stdcall;
    function dAdvise(const FormatEtc: TFormatEtc; advf: Integer; const advsink: IAdviseSink; out dwConnection: Integer): HRESULT; stdcall;
    function dUnadvise(dwConnection: Integer): HRESULT; stdcall;
    function EnumdAdvise(out EnumAdvise: IEnumStatData): HRESULT; stdcall;
   {TDataObject}
    procedure AddFormatEtc(cfFmt: TClipFormat; pt: PDVTargetDevice; dwAsp, lInd, tym: Longint);
  public
    constructor Create;
    destructor Destroy; override;
    procedure CopyToClipboard(const HTML: String);
    procedure Close;
  end;


{ TEnumFormatEtc }

  PFormatList = ^TFormatList;
  TFormatList = array[0..255] of TFormatEtc;

  TEnumFormatEtc = class(TInterfacedObject, IEnumFormatEtc)
  private
    FFormatList: PFormatList;
    FFormatCount: Integer;
    FIndex: Integer;
  public
    constructor Create(FormatList: PFormatList; FormatCount, Index: Integer);
   {IEnumFormatEtc}
    function Next(Celt: LongInt; out Elt; PCeltFetched: PLongInt): HRESULT; stdcall;
    function Skip(Celt: Integer): HRESULT; stdcall;
    function Reset: HRESULT; stdcall;
    function Clone(out Enum: IEnumFormatEtc): HRESULT; stdcall;
  end;

constructor TEnumFormatEtc.Create(FormatList: PFormatList; FormatCount, Index: Integer);
begin
  inherited Create;
  
  FFormatList := FormatList;
  FFormatCount := FormatCount;
  FIndex := Index;
end;

function TEnumFormatEtc.Next(Celt: LongInt; out Elt; PCeltFetched: PLongInt): HRESULT;
var
  i: Integer;
begin
  i := 0;
  while ( i < Celt ) and ( FIndex < FFormatCount ) do
   begin
     TFormatList( Elt )[i] := FFormatList[FIndex];
     Inc( FIndex );
     Inc( i );
   end;

  if PCeltFetched <> nil then PCeltFetched^ := i;
  if i = Celt then Result := S_OK else Result := S_FALSE;
end;

function TEnumFormatEtc.Skip(Celt: Integer): HRESULT;
begin
  if Celt <= FFormatCount - FIndex then
   begin
     FIndex := FIndex + Celt;
     Result := S_OK;
   end
  else
   begin
     FIndex := FFormatCount;
     Result := S_FALSE;
   end;
end;

function TEnumFormatEtc.Reset: HRESULT;
begin
  FIndex := 0;
  Result := S_OK;
end;

function TEnumFormatEtc.Clone(out Enum: IEnumFormatEtc): HRESULT;
begin
  Enum := TEnumFormatEtc.Create( FFormatList, FFormatCount, FIndex );
  Result := S_OK;
end;

{ TDataObject }

var
  CF_HTML: UINT;

constructor TDataObject.Create;
procedure AddFmtEtc(cfFmt: TClipFormat);
  begin
    if cfFmt <> 0 then AddFormatEtc( cfFmt, nil, DVASPECT_CONTENT, -1, TYMED_HGLOBAL );
  end;
begin
  inherited Create;

  FDataFormatsCount := 0;

  AddFmtEtc( CF_HTML );
end;

destructor TDataObject.Destroy;
begin
  inherited Destroy;
end;

procedure TDataObject.AddFormatEtc(cfFmt: TClipFormat; pt: PDVTargetDevice; dwAsp, lInd, tym: LongInt);
begin
  if FDataFormatsCount >= High( FDataFormats ) then Exit;

  with FDataFormats[FDataFormatsCount] do
   begin
     cfFormat := cfFmt;
     ptd := pt;
     dwAspect := dwAsp;
     lIndex := lInd;
     tymed := tym;
   end;

  Inc( FDataFormatsCount );
end;

function TDataObject.dAdvise(const FormatEtc: TFormatEtc; advf: Integer; const advsink: IAdviseSink; out dwConnection: Integer): HRESULT;
begin
  Result := OLE_E_ADVISENOTSUPPORTED;
end;

function TDataObject.dUnadvise(dwConnection: Integer): HRESULT;
begin
  Result := OLE_E_ADVISENOTSUPPORTED;
end;

function TDataObject.EnumdAdvise(out EnumAdvise: IEnumStatData): HRESULT;
begin
  Result := OLE_E_ADVISENOTSUPPORTED;
end;

function TDataObject.EnumFormatEtc(dwDirection: Integer; out EnumFormatEtc: IEnumFormatEtc): HRESULT;
begin
  if dwDirection = DATADIR_GET then
  begin
    EnumFormatEtc := TEnumFormatEtc.Create( @FDataFormats, FDataFormatsCount, 0 );
    Result := S_OK;
  end
  else
  if dwDirection = DATADIR_SET then
   begin
     Result := E_NOTIMPL;
   end
  else
   begin
     Result := E_INVALIDARG;
   end;
end;

function TDataObject.GetCanonicalFormatEtc(const FormatEtc: TFormatEtc; out FormatEtcout: TFormatEtc): HRESULT;
begin
  Result := DATA_S_SAMEFORMATETC;
end;

function TDataObject.GetData(const FormatEtcIn: TFormatEtc; out Medium: TStgMedium): HRESULT;
function CopyAnsiText(const S: String): HRESULT;
  var
    P: PChar;
  begin
    Medium.tymed := TYMED_HGLOBAL;
    Medium.hGlobal := GlobalAlloc( GMEM_SHARE or GMEM_ZEROINIT, Length( S ) + 1 );
    if Medium.hGlobal = 0 then Result := E_OUTOFMEMORY
    else
     begin
       P := GlobalLock( Medium.hGlobal );
       try
         StrPCopy( P, S );
       finally
         GlobalUnlock( Medium.hGlobal );
       end;
       Result := S_OK;
     end;
  end;

begin
  Result := DV_E_FORMATETC;

  if FormatEtcIn.cfFormat = CF_HTML then
   begin
     Result := CopyAnsiText( FHTML );
   end;
end;

function TDataObject.GetDataHere(const FormatEtc: TFormatEtc; out Medium: TStgMedium): HRESULT;
begin
  Result := E_NOTIMPL;
end;

function TDataObject.QueryGetData(const FormatEtc: TFormatEtc): HRESULT;
var
  i: Integer;
begin
  Result := S_OK;
  for i := 0 to FDataFormatsCount-1 do
   with FDataFormats[i] do
    if ( FormatEtc.cfFormat = cfFormat ) and
       ( FormatEtc.dwAspect = dwAspect ) and
       ( FormatEtc.tymed and tymed <> 0 ) then Exit;
  Result := E_FAIL;
end;

function TDataObject.SetData(const FormatEtc: TFormatEtc; var Medium: TStgMedium; Release: Bool): HRESULT;
begin
  Result := E_NOTIMPL;
end;

procedure TDataObject.CopyToClipboard(const HTML: String);
begin
  FHTML := HTML;
  OleSetClipboard( Self );
end;

procedure TDataObject.Close;
begin
  OleSetClipboard( nil );
end;

procedure CopyHTMLToClipboard(const HTML: String);
begin
  with TDataObject.Create do CopyToClipboard( HTML );
end;

initialization
begin
  OleInitialize( nil );
  CF_HTML := RegisterClipboardFormat( 'HTML Format' );
end;

finalization
begin
  OleUninitialize;
end;

end.
