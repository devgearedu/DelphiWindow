unit SearchClasses;

interface

uses
  Windows, Classes, SysUtils, FileLists, Forms;

type
  TDataType = (dtString, dtInteger, dtDateTime, dtBoolean);

  TProperty = record
    Name: String;
    DataType: TDataType;
  end;

  TData = record
    Path: String;
    FindData: PWin32FindData;
  end;

const
  Identifiers: array[0..30] of TProperty = ( ( Name: 'FullName'      ; DataType: dtString   ), { "C:\My Images\Bitmap\test 1.bmp" }
                                             ( Name: 'Path'          ; DataType: dtString   ), { "C:\My Images\Bitmap\"           }
                                             ( Name: 'DirName'       ; DataType: dtString   ), { "Bitmap"                         }
                                             ( Name: 'Folder'        ; DataType: dtString   ), { DirName                          }
                                             ( Name: 'FileName'      ; DataType: dtString   ), { "test 1.bmp"                     }
                                             ( Name: 'Name'          ; DataType: dtString   ), { "test 1"                         }
                                             ( Name: 'Ext'           ; DataType: dtString   ), { "bmp"                            }
                                             ( Name: 'Drive'         ; DataType: dtString   ), { "C:"                             }
                                             ( Name: 'Size'          ; DataType: dtInteger  ), { 1,000                            }
                                             ( Name: 'DateTime'      ; DataType: dtDateTime ), { ModifyDateTime                   }
                                             ( Name: 'Date'          ; DataType: dtDateTime ), { ModifyDate                       }
                                             ( Name: 'Time'          ; DataType: dtDateTime ), { ModifyTime                       }
                                             ( Name: 'CreateDateTime'; DataType: dtDateTime ), { "2008-10-11 12:34:56"            }
                                             ( Name: 'CreateDate'    ; DataType: dtDateTime ), { "2008-10-11"                     }
                                             ( Name: 'CreateTime'    ; DataType: dtDateTime ), { "12:34:56"                       }
                                             ( Name: 'ModifyDateTime'; DataType: dtDateTime ), { "2008-10-12 01:23:56"            }
                                             ( Name: 'ModifyDate'    ; DataType: dtDateTime ), { "2008-10-12"                     }
                                             ( Name: 'ModifyTime'    ; DataType: dtDateTime ), { "01:23:45"                       }
                                             ( Name: 'AccessDateTime'; DataType: dtDateTime ), { "2008-10-13 02:34:56"            }
                                             ( Name: 'AccessDate'    ; DataType: dtDateTime ), { "2008-10-13"                     }
                                             ( Name: 'AccessTime'    ; DataType: dtDateTime ), { "02:34:56"                       }
                                             ( Name: 'Type'          ; DataType: dtString   ), { "비트맵 이미지"                  }
                                             ( Name: 'Readonly'      ; DataType: dtBoolean  ), { true/false                       }
                                             ( Name: 'Hidden'        ; DataType: dtBoolean  ), { true/false                       }
                                             ( Name: 'System'        ; DataType: dtBoolean  ), { true/false                       }
                                             ( Name: 'Directory'     ; DataType: dtBoolean  ), { true/false                       }
                                             ( Name: 'Archive'       ; DataType: dtBoolean  ), { true/false                       }
                                             ( Name: 'Temporary'     ; DataType: dtBoolean  ), { true/false                       }
                                             ( Name: 'Compressed'    ; DataType: dtBoolean  ), { true/false                       }
                                             ( Name: 'Offline'       ; DataType: dtBoolean  ), { true/false                       }
                                             ( Name: 'Stream'        ; DataType: dtString   )  { "xxx"                            }
                                             );

  BooleanStr: array[Boolean] of String = ('false','true');

  Operator_Equal              = 0;
  Operator_LessThanOrEqual    = 1;
  Operator_GreaterThanOrEqual = 2;
  Operator_NotEqual           = 3;
  Operator_LessThan           = 4;
  Operator_GreaterThan        = 5;
  Operator_Like               = 6;
  Operator_And                = 7;
  Operator_Or                 = 8;

type
  TFileSearch = class;
  TParseResult = (prOK, prError, prPass);
  TElementClass = class of TElement;

{ TElement }

  TElement = class
  protected
    ParsedLength: Integer;
    procedure SkipSpace(const Source: String; var Index: Integer);
    function ParseIdentifier(const Source: String; var Index: Integer; const Identifier: String; var Text: String; TestOnly: Boolean = False): Boolean;
  public
    constructor Create; virtual;
    function Parse(const Source: String; var Index: Integer): TParseResult; virtual; abstract;
  end;

{ TText }

  TText = class(TElement)
  protected
    FText: String;
    FDataType: TDataType;
    function AsString(const Data: TData): String; virtual;
    function AsInteger(const Data: TData): Int64;
    function AsBoolean(const Data: TData): Boolean;
    function AsDateTime(const Data: TData): TDateTime;
    property DataType: TDataType read FDataType;
  end;

{ TIdentifier }

  TIdentifier = class(TText)
  protected
    function AsString(const Data: TData): String; override;
  public
    function Parse(const Source: String; var Index: Integer): TParseResult; override;
  end;

{ TValue }

  TValue = class(TText)
  protected
    FQuote: Char;
    function CheckNumber(Char: Char): Boolean;
    procedure CheckDataType;
  public
    function Parse(const Source: String; var Index: Integer): TParseResult; override;
  end;

{ TFunction }

  TFunction = class(TText)
  protected
    FElement: TText;
    function AsString(const Data: TData): String; override;
  public
    function Parse(const Source: String; var Index: Integer): TParseResult; override;
  end;

{ TOperator }

  TOperator = class(TElement)
  protected
    FOperator: Integer;
  end;

{ TComparisonOperator }

  TComparisonOperator = class(TOperator)
  public
    function Parse(const Source: String; var Index: Integer): TParseResult; override;
  end;

{ TLogicalOperator }

  TLogicalOperator = class(TOperator)
  public
    function Parse(const Source: String; var Index: Integer): TParseResult; override;
  end;

{ TFormula }

  TFormula = class(TElement)
  public
    function Strain(const Data: TData): Boolean; virtual;
  end;

{ TComparisonFormula }

  TComparisonFormula = class(TFormula)
  protected
    FLeft: TText;
    FRight: TText;
    FOperater: TComparisonOperator;
    function StringStrain(const Data: TData): Boolean;
    function IntegerStrain(const Data: TData): Boolean;
    function BooleanStrain(const Data: TData): Boolean;
    function DateTimeStrain(const Data: TData): Boolean;
  public
    function Parse(const Source: String; var Index: Integer): TParseResult; override;
    function Strain(const Data: TData): Boolean; override;
  end;

{ TLogicalFormula }

  TLogicalFormula = class(TFormula)
  protected
    FList: TList;
    function Add(Element: TElement): Boolean;
    procedure Clear;
    function Count: Integer;
    function GetItems(Index: Integer): TElement;
    property Items[Index: Integer]: TElement read GetItems; default;
  public
    constructor Create; override;
    destructor Destroy; override;
    function Parse(const Source: String; var Index: Integer): TParseResult; override;
    function Strain(const Data: TData): Boolean; override;
  end;

{ TFence }

  TFence = class(TLogicalFormula)
  public
    function Parse(const Source: String; var Index: Integer): TParseResult; override;
  end;
  
{ TFileSearch }

  TFileSearch = class
  private
    FElements: TFormula;
    FParsedLength: Integer;
    FAbort: Boolean;
    FSearching: Boolean;
    FParsing: Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    function Parse(const Source: String): Boolean;
    procedure Search(Paths: TStrings; FileList: TFileList);
    procedure Abort;
    property ParsedLength: Integer read FParsedLength;
    property Aborted: Boolean read FAbort;
    property Parsing: Boolean read FParsing;
    property Searching: Boolean read FSearching;
  end;

implementation

const
  STREMMAXSIZE = 100 * 1024 * 1024;

var
  FileStream: String;
  StreamFileName: String;

procedure GetFileStream(const FileName: String; var S: String);
var
  Stream: TStream;
begin
  if LowerCase( StreamFileName ) = LowerCase( FileName ) then
   begin
     S := FileStream;
     Exit;
   end;

  try
    Stream := TFileStream.Create( FileName, fmOpenRead or fmShareDenyNone );
  except
    FileStream := '';
    StreamFileName := '';
    Exit;
  end;

  try
    if Stream.Size > STREMMAXSIZE then
     begin
       FileStream := '';
       StreamFileName := '';
       Exit;
     end;

    SetLength( S, Stream.Size );
    Stream.Read( S[1], Stream.Size );
  
  finally
    Stream.Free;
  end;
end;

{ TElement }

constructor TElement.Create;
begin
  inherited Create;
end;

procedure TElement.SkipSpace(const Source: String; var Index: Integer);
var
  i: Integer;
begin
  for i := Index to Length(Source) do
   if Source[i] <= ' ' then
    begin
      Inc( Index );
      Inc( ParsedLength );
    end
   else Break;
end;

function TElement.ParseIdentifier(const Source: String; var Index: Integer; const Identifier: String; var Text: String; TestOnly: Boolean = False): Boolean;
const
  IdentifierChars = ['a'..'z','0'..'9','_'];
var
  S, LastChar: String;
function NotIdentifierChars(const S: String): Boolean;
  begin
    Result := ( S = '' ) or not ( S[1] in IdentifierChars );
  end;
begin
  S := LowerCase( Copy( Source, Index, Length( Identifier ) ) );
  LastChar := LowerCase( Copy( Source, Index + Length( Identifier ), 1 ) );

  Result := ( S = LowerCase( Identifier ) ) and NotIdentifierChars( LastChar );

  if not TestOnly and Result then
   begin
     Inc( Index, Length( S ) );
     Inc( ParsedLength, Length( S ) );
     Text := S;
   end;
end;

{ TText }

function TText.AsString(const Data: TData): String;
begin
  Result := FText;
end;

function TText.AsInteger(const Data: TData): Int64;
var
  S: String;
begin
  S := AsString( Data );
  if not TryStrToInt64( S, Result ) then Result := 0;
end;

function TText.AsBoolean(const Data: TData): Boolean;
begin
  Result := LowerCase( AsString( Data ) ) = BooleanStr[True];
end;

function TText.AsDateTime(const Data: TData): TDateTime;
var
  S: String;
begin
  S := AsString( Data );
  if not TryStrToDateTime( S, Result ) then Result := 0;
end;

{ TIdentifierElement }

function TIdentifier.Parse(const Source: String; var Index: Integer): TParseResult;
var
  i: Integer;
begin
  for i := Low(Identifiers) to High(Identifiers) do
   if ParseIdentifier( Source, Index, Identifiers[i].Name, FText ) then
    begin
      FDataType := Identifiers[i].DataType;
      Result := prOK;
      Exit;
    end;

  Result := prPass;
end;

function TIdentifier.AsString(const Data: TData): String;
var
  Identifier: String;
begin
  Identifier := LowerCase( FText );

  if Identifier = 'fullname' then Result := LowerCase( Data.Path + Data.FindData.cFileName ) else
  if Identifier = 'path' then Result := LowerCase( Data.Path ) else
  if ( Identifier = 'dirname' ) or ( Identifier = 'folder' ) then Result := LowerCase( ExtractFileName( ExtractFileDir( Data.Path ) ) ) else
  if Identifier = 'filename' then Result := LowerCase( Data.FindData.cFileName ) else
  if Identifier = 'name' then Result := LowerCase( ChangeFileExt( Data.FindData.cFileName, '' ) ) else
  if Identifier = 'ext' then Result := LowerCase( Copy( ExtractFileExt( Data.FindData.cFileName ), 2, $FFFFFFF ) ) else
  if Identifier = 'drive' then Result := LowerCase( ExtractFileDrive( Data.Path ) ) else
  if Identifier = 'size' then Result := IntToStr( FileSize( Data.FindData ) ) else
  if ( Identifier = 'datetime' ) or ( Identifier = 'modifydatetime' ) then Result := DateTimeToStr( FileDateTime( Data.FindData.ftLastWriteTime ) ) else
  if ( Identifier = 'date' ) or ( Identifier = 'modifydate' ) then Result := DateToStr( FileDateTime( Data.FindData.ftLastWriteTime ) ) else
  if ( Identifier = 'time' ) or ( Identifier = 'modifytime' ) then Result := TimeToStr( FileDateTime( Data.FindData.ftLastWriteTime ) ) else
  if Identifier = 'createdatetime' then Result := DateTimeToStr( FileDateTime( Data.FindData.ftCreationTime ) ) else
  if Identifier = 'createdate' then Result := DateToStr( FileDateTime( Data.FindData.ftCreationTime ) ) else
  if Identifier = 'createtime' then Result := TimeToStr( FileDateTime( Data.FindData.ftCreationTime ) ) else
  if Identifier = 'accessdatetime' then Result := DateTimeToStr( FileDateTime( Data.FindData.ftLastAccessTime ) ) else
  if Identifier = 'accessdate' then Result := DateToStr( FileDateTime( Data.FindData.ftLastAccessTime ) ) else
  if Identifier = 'accesstime' then Result := TimeToStr( FileDateTime( Data.FindData.ftLastAccessTime ) ) else
  if Identifier = 'type' then Result := FileType( Data.Path + Data.FindData.cFileName ) else
  if Identifier = 'readonly' then Result := BooleanStr[ Data.FindData.dwFileAttributes and FILE_ATTRIBUTE_READONLY <> 0 ] else
  if Identifier = 'hidden' then Result := BooleanStr[ Data.FindData.dwFileAttributes and FILE_ATTRIBUTE_HIDDEN <> 0 ] else
  if Identifier = 'system' then Result := BooleanStr[ Data.FindData.dwFileAttributes and FILE_ATTRIBUTE_SYSTEM <> 0 ] else
  if Identifier = 'directory' then Result := BooleanStr[ Data.FindData.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY <> 0 ] else
  if Identifier = 'archive' then Result := BooleanStr[ Data.FindData.dwFileAttributes and FILE_ATTRIBUTE_ARCHIVE <> 0 ] else
  if Identifier = 'normal' then Result := BooleanStr[ Data.FindData.dwFileAttributes and FILE_ATTRIBUTE_NORMAL <> 0 ] else
  if Identifier = 'temporary' then Result := BooleanStr[ Data.FindData.dwFileAttributes and FILE_ATTRIBUTE_TEMPORARY <> 0 ] else
  if Identifier = 'compressed' then Result := BooleanStr[ Data.FindData.dwFileAttributes and FILE_ATTRIBUTE_COMPRESSED <> 0 ] else
  if Identifier = 'offline' then Result := BooleanStr[ Data.FindData.dwFileAttributes and FILE_ATTRIBUTE_OFFLINE <> 0 ] else
  if Identifier = 'stream' then GetFileStream( Data.Path + Data.FindData.cFileName, Result )
                           else Result := '';
end;

{ TValue }

function TValue.Parse(const Source: String; var Index: Integer): TParseResult;
const
  Keywords: array[0..2] of String = ('and','or','like');
var
  i: Integer;
  B: Boolean;
  S: String;
  EndQuote: Boolean;
begin
  if Source[ Index ] in ['<','>','=','(',')'] then
   begin
     Result := prPass;
     Exit;
   end;

  for i := Low(Keywords) to High(Keywords) do
   if ParseIdentifier( Source, Index, Keywords[i], S, True ) then
    begin
      Result := prPass;
      Exit;
    end;

  for i := Low(Identifiers) to High(Identifiers) do
   if ParseIdentifier( Source, Index, Identifiers[i].Name, S, True ) then
    begin
      Result := prPass;
      Exit;
    end;

  for B := Low(BooleanStr) to High(BooleanStr) do
   if ParseIdentifier( Source, Index, BooleanStr[B], FText ) then
    begin
      Result := prOK;
      Exit;
    end;

  EndQuote := False;

  if Source[ Index ] in ['"',''''] then
   begin
     FQuote := Source[ Index ];
     Inc( Index );
     Inc( ParsedLength );
   end
  else
   FQuote := #0;

  while Index <= Length(Source) do
   begin
     if ( FQuote <> #0 ) and ( Source[ Index ] = FQuote ) then
      begin
        EndQuote := True;
        Inc( Index );
        Inc( ParsedLength );
        Break;
      end;

     if ( FQuote = #0 ) and not CheckNumber( Source[ Index ] ) then Break;

     FText := FText + Source[ Index ];
     Inc( Index );
     Inc( ParsedLength );
   end;

  if FText <> '' then
   begin
     if FQuote <> #0 then
      begin
        if EndQuote then Result := prOK
                    else Result := prError
      end
     else
      Result := prOK;
   end
  else
  if ( FQuote <> #0 ) and EndQuote then Result := prOK
                                   else Result := prPass;

  if Result = prOK then CheckDataType;
end;

function TValue.CheckNumber(Char: Char): Boolean;
begin
  if not ( Char in ['0'..'9'] ) then
   begin
     Result := False;
     Exit;
   end;

  Result := True;
end;

procedure TValue.CheckDataType;
var
  D: TDateTime;
  I: Int64;
  S: String;
begin
  if FQuote = #0 then
   begin
     if TryStrToInt64( FText, I ) then FDataType := dtInteger
     else
      begin
        S := LowerCase( FText );
        if ( S = BooleanStr[False] ) or ( S = BooleanStr[True] ) then FDataType := dtBoolean
                                                                 else FDataType := dtString;
      end;
   end
  else
   begin
     S := Copy( FText, 2, Length(FText) - 2 );
     if TryStrToDateTime( S, D ) then FDataType := dtDateTime
                                 else FDataType := dtString;
   end;
end;

{ TFunction }

function TFunction.Parse(const Source: String; var Index: Integer): TParseResult;
begin
  if ParseIdentifier( Source, Index, 'length', FText ) then
   begin
     SkipSpace( Source, Index );

     if Source[Index] = '(' then
      begin
        Inc( Index );
        Inc( ParsedLength );
      end
     else
      begin
        Result := prError;
        Exit;
      end;

     SkipSpace( Source, Index );

     FElement := TIdentifier.Create;
     case FElement.Parse( Source, Index ) of
     prOK   : begin
                Inc( ParsedLength, FElement.ParsedLength );
              end;
     prError: begin
                Inc( ParsedLength, FElement.ParsedLength );
                Result := prError;
                FElement.Free;
                FElement := nil;
                Exit;
              end;
     prPass : begin
                FElement.Free;
                FElement := TValue.Create;
                case FElement.Parse( Source, Index ) of
                prOK   : begin
                           Inc( ParsedLength, FElement.ParsedLength );
                         end;
                prError: begin
                           Inc( ParsedLength, FElement.ParsedLength );
                           Result := prError;
                           FElement.Free;
                           FElement := nil;
                           Exit;
                         end;
                prPass : begin
                           Result := prError;
                           FElement.Free;
                           FElement := nil;
                           Exit;
                         end;
                end;
              end;
     end;

     SkipSpace( Source, Index );

     if Source[Index] = ')' then
      begin
        Inc( Index );
        Inc( ParsedLength );
        FDataType := dtInteger;
        Result := prOK;
      end
     else
      begin
        Result := prError;
        FElement.Free;
        FElement := nil;
      end;
   end
  else
   Result := prPass;
end;

function TFunction.AsString(const Data: TData): String;
begin
  if FElement <> nil then
   begin
     if FText = 'length' then Result := IntToStr( Length( FElement.AsString( Data ) ) )
                         else Result := '';
   end
  else
   Result := '';
end;

{ TComparisonOperator }

function TComparisonOperator.Parse(const Source: String; var Index: Integer): TParseResult;
const
  ComparisonOperaters: array[0..5] of String = ('=', '<=', '>=', '<>', '<', '>');
var
  i: Integer;
  S: String;
begin
  if ParseIdentifier( Source, Index, 'like', S ) then
   begin
     FOperator := Operator_Like;
     Result := prOK;
     Exit;
   end;

  for i := Low(ComparisonOperaters) to High(ComparisonOperaters) do
   begin
     S := Copy( Source, Index, Length( ComparisonOperaters[i] ) );
     if S = ComparisonOperaters[i] then
      begin
        FOperator := i;
        Inc( Index, Length(S) );
        Inc( ParsedLength, Length(S) );
        Result := prOK;
        Exit;
      end;
   end;

  Result := prPass;
end;

{ TLogicalOperator }

function TLogicalOperator.Parse(const Source: String; var Index: Integer): TParseResult;
var
  S: String;
begin
  if ParseIdentifier( Source, Index, 'and', S ) then
   begin
     FOperator := Operator_And;
     Result := prOK;
     Exit;
   end;

  if ParseIdentifier( Source, Index, 'or', S ) then
   begin
     FOperator := Operator_Or;
     Result := prOK;
     Exit;
   end;

  Result := prPass;
end;

{ TFormula }

function TFormula.Strain(const Data: TData): Boolean;
begin
  Result := False;
end;

{ TComparisonFormula }

function TComparisonFormula.Parse(const Source: String; var Index: Integer): TParseResult;
begin
  FLeft := TIdentifier.Create;
  case FLeft.Parse( Source, Index ) of
  prOK    : begin
              Inc( ParsedLength, FLeft.ParsedLength );
            end;
  prError : begin
              Inc( ParsedLength, FLeft.ParsedLength );
              Result := prError;
              FLeft.Free;
              FLeft := nil;
              Exit;
            end;
       else begin
              FLeft.Free;
              FLeft := TValue.Create;
              case FLeft.Parse( Source, Index ) of
              prOK   : begin
                         Inc( ParsedLength, FLeft.ParsedLength );
                       end;
              prError: begin
                         Inc( ParsedLength, FLeft.ParsedLength );
                         Result := prError;
                         FLeft.Free;
                         FLeft := nil;
                         Exit;
                       end;
                  else begin
                         FLeft.Free;
                         FLeft := TFunction.Create;
                         case FLeft.Parse( Source, Index ) of
                         prOK   : Inc( ParsedLength, FLeft.ParsedLength );
                         prError: begin
                                    Inc( ParsedLength, FLeft.ParsedLength );
                                    Result := prError;
                                    FLeft.Free;
                                    FLeft := nil;
                                    Exit;
                                  end;
                         prPass: begin
                                   Result := prPass;
                                   FLeft.Free;
                                   FLeft := nil;
                                   Exit;
                                 end;
                         end;
                       end;
              end;
            end;
  end;

  SkipSpace( Source, Index );

  FOperater := TComparisonOperator.Create;
  case FOperater.Parse( Source, Index ) of
  prOK   : begin
             Inc( ParsedLength, FOperater.ParsedLength );
           end;
  prError: begin
             Inc( ParsedLength, FOperater.ParsedLength );
             Result := prError;
             FLeft.Free;
             FLeft := nil;
             FOperater.Free;
             FOperater := nil;
             Exit;
           end;
      else begin
             Result := prError;
             FLeft.Free;
             FLeft := nil;
             FOperater.Free;
             FOperater := nil;
             Exit;
           end;
  end;

  SkipSpace( Source, Index );

  FRight := TIdentifier.Create;
  case FRight.Parse( Source, Index ) of
  prOK   : begin
             Inc( ParsedLength, FRight.ParsedLength );
             Result := prOK;
           end;
  prError: begin
             Inc( ParsedLength, FRight.ParsedLength );
             Result := prError;
             FLeft.Free;
             FLeft := nil;
             FOperater.Free;
             FOperater := nil;
             FRight.Free;
             FRight := nil;
           end;
      else begin
             FRight.Free;
             FRight := TValue.Create;
             case FRight.Parse( Source, Index ) of
             prOK   : begin
                        Inc( ParsedLength, FRight.ParsedLength );
                        Result := prOK;
                      end;
             prError: begin
                        Inc( ParsedLength, FRight.ParsedLength );
                        Result := prError;
                        FLeft.Free;
                        FLeft := nil;
                        FOperater.Free;
                        FOperater := nil;
                        FRight.Free;
                        FRight := nil;
                      end;
                 else begin
                        FRight.Free;
                        FRight := TFunction.Create;
                        case FRight.Parse( Source, Index ) of
                        prOK   : begin
                                   Inc( ParsedLength, FRight.ParsedLength );
                                   Result := prOK;
                                 end;  
                        prError: begin
                                   Inc( ParsedLength, FRight.ParsedLength );
                                   Result := prError;
                                   FRight.Free;
                                   FRight := nil;
                                 end;
                            else begin
                                  Inc( ParsedLength, FRight.ParsedLength );
                                  Result := prError;
                                  FLeft.Free;
                                  FLeft := nil;
                                  FOperater.Free;
                                  FOperater := nil;
                                  FRight.Free;
                                  FRight := nil;
                                end;
                        end;
                      end;
             end;
           end;
  end;
end;

function TComparisonFormula.Strain(const Data: TData): Boolean;
var
  SLeft, SRight: TDataType;
function TypeAs(DataType: TDataType): Boolean;
  begin
    Result := ( SLeft = DataType ) and ( SRight = DataType );
  end;
begin
  SLeft := FLeft.DataType;
  SRight := FRight.DataType;


  if LowerCase( Data.FindData.cFileName ) = 'screenbitmaps.pas' then
   begin
     Beep;
   end;

  
  if TypeAs( dtInteger ) then Result := IntegerStrain( Data ) else
  if TypeAs( dtBoolean ) then Result := BooleanStrain( Data ) else
  if TypeAs( dtDateTime ) then Result := DateTimeStrain( Data )
                          else Result := StringStrain( Data );
end;

function TComparisonFormula.StringStrain(const Data: TData): Boolean;
var
  SLeft, SRight: String;
  PercentSymbol: Integer;
begin
  SLeft := LowerCase( FLeft.AsString( Data ) );
  SRight := LowerCase( FRight.AsString( Data ) );

  case FOperater.FOperator of
  Operator_Equal             : Result := SLeft = SRight;
  Operator_LessThanOrEqual   : Result := SLeft <= SRight;
  Operator_GreaterThanOrEqual: Result := SLeft >= SRight;
  Operator_NotEqual          : Result := SLeft <> SRight;
  Operator_LessThan          : Result := SLeft < SRight;
  Operator_GreaterThan       : Result := SLeft > SRight;
  Operator_Like              : begin
                                 PercentSymbol := 0;
                                 if ( Length(SRight) > 1 ) and ( SRight[1] = '%' ) then Inc( PercentSymbol );
                                 if ( Length(SRight) > 1 ) and ( SRight[Length(SRight)] = '%' ) then Inc( PercentSymbol, 2 );

                                 case PercentSymbol of
                                   1: Result := Copy( SLeft, Length(SLeft) - ( Length(SRight) - 1 ) + 1, Length(SRight) - 1 ) = Copy( SRight, 2, Length(SRight) - 1 );
                                   2: Result := Copy( SLeft, 1, Length(SRight) - 1 ) = Copy( SRight, 1, Length(SRight) - 1 );
                                   3: Result := Pos( Copy( SRight, 2, Length(SRight) - 2 ), SLeft ) > 0;
                                 else Result := SLeft = SRight;
                                 end;
                               end;
                          else Result := False;
  end;
end;

function TComparisonFormula.IntegerStrain(const Data: TData): Boolean;
var
  SLeft, SRight: Int64;
begin
  SLeft := FLeft.AsInteger( Data );
  SRight := FRight.AsInteger( Data );

  case FOperater.FOperator of
  Operator_Equal             : Result := SLeft = SRight;
  Operator_LessThanOrEqual   : Result := SLeft <= SRight;
  Operator_GreaterThanOrEqual: Result := SLeft >= SRight;
  Operator_NotEqual          : Result := SLeft <> SRight;
  Operator_LessThan          : Result := SLeft < SRight;
  Operator_GreaterThan       : Result := SLeft > SRight;
  Operator_Like              : Result := StringStrain( Data );
                         else  Result := False;
  end;
end;

function TComparisonFormula.BooleanStrain(const Data: TData): Boolean;
var
  SLeft, SRight: Boolean;
begin
  SLeft := FLeft.AsBoolean( Data );
  SRight := FRight.AsBoolean( Data );

  case FOperater.FOperator of
  Operator_Equal             : Result := SLeft = SRight;
  Operator_LessThanOrEqual   : Result := SLeft <= SRight;
  Operator_GreaterThanOrEqual: Result := SLeft >= SRight;
  Operator_NotEqual          : Result := SLeft <> SRight;
  Operator_LessThan          : Result := SLeft < SRight;
  Operator_GreaterThan       : Result := SLeft > SRight;
  Operator_Like              : Result := StringStrain( Data );
                         else  Result := False;
  end;
end;

function TComparisonFormula.DateTimeStrain(const Data: TData): Boolean;
var
  SLeft, SRight: TDateTime;
begin
  SLeft := FLeft.AsDateTime( Data );
  SRight := FRight.AsDateTime( Data );

  case FOperater.FOperator of
  Operator_Equal             : Result := SLeft = SRight;
  Operator_LessThanOrEqual   : Result := SLeft <= SRight;
  Operator_GreaterThanOrEqual: Result := SLeft >= SRight;
  Operator_NotEqual          : Result := SLeft <> SRight;
  Operator_LessThan          : Result := SLeft < SRight;
  Operator_GreaterThan       : Result := SLeft > SRight;
  Operator_Like              : Result := StringStrain( Data );
                         else  Result := False;
  end;
end;

{ TLogicalFormula }

constructor TLogicalFormula.Create;
begin
  inherited Create;

  FList := TList.Create;
end;

destructor TLogicalFormula.Destroy;
begin
  Clear;
  FList.Free;

  inherited Destroy;
end;

function TLogicalFormula.Add(Element: TElement): Boolean;
begin
  if Odd( Count ) then Result := Element is TLogicalOperator
                  else Result := Element is TFormula;
  if Result then
   FList.Add( Element );
end;

procedure TLogicalFormula.Clear;
var
  i: Integer;
begin
  for i := Count - 1 downto 0 do
   TObject( FList[i] ).Free;
  FList.Clear;
end;

function TLogicalFormula.Count: Integer;
begin
  Result := FList.Count;
end;

function TLogicalFormula.GetItems(Index: Integer): TElement;
begin
  Result := FList[ Index ];
end;

function TLogicalFormula.Parse(const Source: String; var Index: Integer): TParseResult;
const
  Elements: array[0..1] of TElementClass = (TComparisonFormula, TFence);
var
  Element: TElement;
  OK: Boolean;
  i: Integer;
begin
  Clear;

  while Index <= Length(Source) do
   begin
     OK := False;

     if Odd( Count ) then
      begin

        SkipSpace( Source, Index );
        Element := TLogicalOperator.Create;
        case Element.Parse( Source, Index ) of
           prOK: begin
                   if not Add( Element ) then
                    begin
                      Result := prError;
                      Exit;
                    end;
                   Inc( ParsedLength, Element.ParsedLength );
                   OK := True;
                 end;
        prError: begin
                   Inc( ParsedLength, Element.ParsedLength );
                   Element.Free;
                   Result := prError;
                   Exit;
                 end;
        else     begin
                   Element.Free;
                   Break;
                 end;
        end;

      end
     else
      begin

        for i := Low(Elements) to High(Elements) do
         begin
           SkipSpace( Source, Index );
           if not OK then
            begin
              Element := Elements[i].Create;

              case Element.Parse( Source, Index ) of
                 prOK: begin
                         if not Add( Element ) then
                          begin
                            Result := prError;
                            Exit;
                          end;
                         Inc( ParsedLength, Element.ParsedLength );
                         OK := True;
                         Break;
                       end;
              prError: begin
                         Inc( ParsedLength, Element.ParsedLength );
                         Element.Free;
                         Result := prError;
                         Exit;
                       end;
               prPass: Element.Free;
              end;
            end;
         end;

      end;

     if not OK then Break;
   end;

  if Count > 0 then
   begin
     if Items[Count-1] is TFormula then Result := prOK
                                   else Result := prError;
   end
  else
   Result := prPass;
end;

function TLogicalFormula.Strain(const Data: TData): Boolean;
var
  i: Integer;
  LastOperator: Integer;
begin
  if Count > 0 then
   begin
     Result := TFormula( Items[0] ).Strain( Data );
     LastOperator := 0;

     for i := 1 to Count - 1 do
      if Items[i] is TLogicalOperator then LastOperator := TLogicalOperator( Items[i] ).FOperator
      else
       case LastOperator of
       Operator_And: Result := Result and TFormula( Items[i] ).Strain( Data );
       Operator_Or : begin
                       if Result then Break;
                       Result := Result or TFormula( Items[i] ).Strain( Data );
                       if Result then Break;
                     end;
       end;
   end
  else
   Result := False;
end;

{ TFence }

function TFence.Parse(const Source: String; var Index: Integer): TParseResult;
begin
  if Source[ Index ] <> '(' then
   begin
     Result := prPass;
     Exit;
   end;

  Inc( Index );
  Inc( ParsedLength );

  SkipSpace( Source, Index );

  case inherited Parse( Source, Index ) of
  prOK: begin
          SkipSpace( Source, Index );

          if Length(Source) >= Index then
           if Source[ Index ] = ')' then
            begin
              Inc( Index );
              Inc( ParsedLength );
              Result := prOK;
              Exit;
            end;
        end;
  end;

  Result := prError;
end;

{ TFileSearch }

constructor TFileSearch.Create;
begin
  inherited Create;

  FElements := TLogicalFormula.Create;
end;

destructor TFileSearch.Destroy;
begin
  FElements.Free;

  inherited Destroy;
end;

function TFileSearch.Parse(const Source: String): Boolean;
var
  Index: Integer;
begin
  FParsing := True;
  try
    FParsedLength := 0;
    Index := 1;

    if FElements.Parse( Source, Index ) = prOK then
     begin
       Inc( FParsedLength, FElements.ParsedLength );
       Result := FParsedLength = Length(Source);
     end
    else
     begin
       Inc( FParsedLength, FElements.ParsedLength );
       Result := False;
     end;
  finally
    FParsing := False;
  end;
end;

procedure TFileSearch.Search(Paths: TStrings; FileList: TFileList);
var
  i: Integer;
  Path: String;
procedure Strain(const Data: TData);
  begin
    if FElements.Strain( Data ) then
     FileList.Add( Data.Path, Data.FindData );
  end;
procedure SearchPath(const Path: String);
  var
    Data: TData;
    SearchRec: TSearchRec;
    SearchResult: Integer;
  begin
    SearchResult := FindFirst( Path + '*.*', faAnyFile, SearchRec );
    try
      while SearchResult = 0 do
       begin
         if ( SearchRec.Name <> '.' ) and ( SearchRec.Name <> '..' ) then
          begin
            Data.Path := Path;
            Data.FindData := @SearchRec.FindData;
            Strain( Data );
            Application.ProcessMessages;

            if FAbort then Break;

            if Data.FindData.dwFileAttributes and faDirectory <> 0 then
             SearchPath( Data.Path + Data.FindData.cFileName + '\' );
          end;
         SearchResult := FindNext( SearchRec );
       end;
    finally
      FindClose( SearchRec );
    end;
  end;
begin
  FileList.Clear;
  FAbort := False;
  FSearching := True;
  try

    for i := 0 to Paths.Count - 1 do
     begin
       Path := Paths[i];
       if Path[ Length(Path) ] <> '\' then Path := Path + '\';
       SearchPath( Path );
     end;

  finally
    FSearching := False;
  end;
end;

procedure TFileSearch.Abort;
begin
  FAbort := True;
end;

end.

