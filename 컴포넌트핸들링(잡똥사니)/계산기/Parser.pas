{
계산기용 문자열 파서
맹근넘 : 양병규 delmadang@hanmail.net

이 소스는 2006 한국델파이연합 세미나 발표용으로 만들었습니다.
이 소스에 대한 설명은 세미나 때 다 했습니다.(물론 충분하지는 않겠지만..)
이 소스에 대한 질문은 세미나에 참가하셨던 분만 이메일로 받습니다.


초간단 설명...
이 설명은 세미나에 참가하신 분들의 기억을 되살리는데 도움을 주기 위한 설명임.

파서 객체의 파싱형식
1. 단어
2. 리스트
3. 양식
4. 트리

TStatement         : 파서객체 추상클래스.
TValueStatement    : 값 기능이 추가된 추상클래스.

TOperatorStatement : 연산자 파서 클래스. 값 없음. 형식 1.
TRealStatement     : 숫자 파서 클래스. 값 있음. 형식 1.
TFenceStatement    : 괄호 파서 클래스. 값 있음. 형식 3.
TListStatement     : 숫자,연산자,괄호,파이,싸인,코싸인,탄젠트의 리스팅 파서 클래스. 값 있음. 형식 2.

TPiStatement       : 파이 파서 클래스. 값 있음. 형식 1.
TFunctionStatement : 함수 기능이 구현된 클래스. 값 있음. 형식 3.
TSinStatement      : 싸인 파서 클래스. 값 있음. 형식 3.
TCosStatement      : 코싸인 파서 클래스. 값 있음. 형식 3.
TTanStatement      : 탄젠트 파서 클래스. 값 있음. 형식 3.

TParser            : 계산기 파서
}

unit Parser;

interface

uses
  Classes, SysUtils;

type
  TStatementClass = class of TStatement;
  TListStatement = class;

{ TStatement }

  TStatement = class
  protected
    FSourceCode: String;
    FParsedLength: Integer;
    function GetSourceCode: String; virtual;
    procedure SkipBlanks(const S: String; var CharIndex: Integer); virtual;
  public
    constructor Create; virtual;
    function Parse(const S: String; CharIndex: Integer): Boolean; virtual;
    property ParsedLength: Integer read FParsedLength;
    property SourceCode: String read GetSourceCode;
  end;

{ TValueStatement } 

  TValueStatement = class(TStatement)
  protected
    function GetValue: Extended; virtual; abstract;
  public
    property Value: Extended read GetValue;
  end;

{ TOperatorStatement }

  TOperatorStatement = class(TStatement)
  public
    function Parse(const S: String; CharIndex: Integer): Boolean; override;
  end;

{ TRealStatement }

  TRealStatement = class(TValueStatement)
  protected
    function GetValue: Extended; override;
  public
    function Parse(const S: String; CharIndex: Integer): Boolean; override;
  end;

{ TFenceStatement }

  TFenceStatement = class(TValueStatement)
  private
    FListStatement: TListStatement;
  protected
    function GetSourceCode: String; override;
    function GetValue: Extended; override;
  public
    constructor Create; override;
    destructor Destroy; override;
    function Parse(const S: String; CharIndex: Integer): Boolean; override;
  end;

{ TPiStatement }

  TPiStatement = class(TValueStatement)
  protected
    function GetSourceCode: String; override;
    function GetValue: Extended; override;
  public
    function Parse(const S: String; CharIndex: Integer): Boolean; override;
  end;

{ TFunctionStatement }

  TFunctionStatement = class(TValueStatement)
  protected
    FListStatement: TListStatement;
    FFunction: String;
    function GetSourceCode: String; override;
  public
    constructor Create; override;
    destructor Destroy; override;
    function Parse(const S: String; CharIndex: Integer): Boolean; override;
  end;

{ TSinStatement }

  TSinStatement = class(TFunctionStatement)
  protected
    function GetValue: Extended; override;
  public
    constructor Create; override;
  end;

{ TCosStatement }

  TCosStatement = class(TFunctionStatement)
  protected
    function GetValue: Extended; override;
  public
    constructor Create; override;
  end;

{ TTanStatement }

  TTanStatement = class(TFunctionStatement)
  protected
    function GetValue: Extended; override;
  public
    constructor Create; override;
  end;

{ TSQRTStatement }

  TSQRTStatement = class(TFunctionStatement)
  protected
    function GetValue: Extended; override;
  public
    constructor Create; override;
  end;

{ TFunction2Statement }

  TFunction2Statement = class(TValueStatement)
  protected
    FListStatement1: TListStatement;
    FListStatement2: TListStatement;
    FFunction: String;
    function GetSourceCode: String; override;
    function GetValue: Extended; override;
  public
    constructor Create; override;
    destructor Destroy; override;
    function Parse(const S: String; CharIndex: Integer): Boolean; override;
  end;

{ TPowStatement }

  TPowStatement = class(TFunction2Statement)
  public
    constructor Create; override;
  end;

{ TListStatement }

  TListStatement = class(TValueStatement)
  private
    FList: TList;
  protected
    function GetSourceCode: String; override;
    function GetValue: Extended; override;
    function GetStatements(Index: Integer): TStatement;
    function Add(Statement: TStatement): Boolean;
    function Count: Integer;
    procedure Clear;
  public
    constructor Create; override;
    destructor Destroy; override;
    function Parse(const S: String; CharIndex: Integer): Boolean; override;
    property Statements[Index: Integer]: TStatement read GetStatements;
  end;

{ TParser }

  TParser = class
  private
    FStatements: TListStatement;
    FValue: Extended;
    FErrorPos: Integer;
  protected
    function GetSourceCode: String;
  public
    constructor Create;
    destructor Destroy; override;
    function Parse(const S: String): Boolean;
    property SourceCode: String read GetSourceCode;
    property Value: Extended read FValue;
    property ErrorPos: Integer read FErrorPos;
  end;

implementation

uses Math;

{ TParser }

constructor TParser.Create;
begin
  inherited Create;

  FStatements := TListStatement.Create;
end;

destructor TParser.Destroy;
begin
  FStatements.Free;

  inherited Destroy;
end;

function TParser.GetSourceCode: String;
begin
  Result := FStatements.SourceCode;
end;

function TParser.Parse(const S: String): Boolean;
begin
  if S = '' then
   begin
     Result := False;
     Exit;
   end;

  FValue := 0;

  case FStatements.Parse( S, 1 ) of
  True : begin
           if FStatements.ParsedLength < Length( S ) then
            begin
              Result := False;

              FErrorPos := FStatements.ParsedLength;
            end
           else
            begin
              Result := True;
              FValue := FStatements.Value;

              FErrorPos := 0;
            end;
         end;
  else   begin
           Result := False;

           FErrorPos := FStatements.ParsedLength;
         end;
  end;
end;

{ TStatement }

constructor TStatement.Create;
begin
  inherited Create;

  FParsedLength := 0;
  FSourceCode := '';
end;

function TStatement.GetSourceCode: String;
begin
  Result := FSourceCode;
end;

procedure TStatement.SkipBlanks(const S: String; var CharIndex: Integer);
begin
  while ( Length( S ) >= CharIndex ) and ( S[ CharIndex ] in [ ' ', #9, #10, #13 ] ) do
   begin
     Inc( CharIndex );
     Inc( FParsedLength );
   end;
end;

function TStatement.Parse(const S: String; CharIndex: Integer): Boolean;
begin
  Result := True;
end;

{ TOperatorStatement }

function TOperatorStatement.Parse(const S: String; CharIndex: Integer): Boolean;
begin
  if ( Length( S ) >= CharIndex ) and ( S[ CharIndex ] in ['+','-','*','/'] ) then
   begin
     FSourceCode := S[ CharIndex ];
     Inc( FParsedLength );
   end;

  Result := True;
end;

{ TRealStatement }

function TRealStatement.GetValue: Extended;
begin
  Result := StrToFloatDef( FSourceCode, 0 );
end;

function TRealStatement.Parse(const S: String; CharIndex: Integer): Boolean;
var
  Len: Integer;
begin
  Len := Length( S );

  while CharIndex <= Len do
   case S[ CharIndex ] of
   '0'..'9': begin
               FSourceCode := FSourceCode + S[ CharIndex ];
               Inc( CharIndex );
               Inc( FParsedLength );
             end;
        '.': begin
               if FSourceCode = '' then Break
               else
                begin
                  if Pos( '.', FSourceCode ) = 0 then
                   begin
                     FSourceCode := FSourceCode + S[ CharIndex ];
                     Inc( CharIndex );
                     Inc( FParsedLength );
                   end
                  else
                   begin
                     Result := False;
                     Exit;
                   end;
                end
             end;
        else begin
               Break;
             end;
   end;

  Result := True;
end;

{ TFenceStatement }

constructor TFenceStatement.Create;
begin
  inherited Create;

  FListStatement := TListStatement.Create;
end;

destructor TFenceStatement.Destroy;
begin
  FListStatement.Free;

  inherited Destroy;
end;

function TFenceStatement.GetSourceCode: String;
begin
  Result := '(' + FListStatement.SourceCode + ')';
end;

function TFenceStatement.GetValue: Extended;
begin
  Result := FListStatement.Value;
end;

function TFenceStatement.Parse(const S: String; CharIndex: Integer): Boolean;
begin
  Result := True;

  if S[ CharIndex ] = '(' then
   begin
     Inc( CharIndex );
     Inc( FParsedLength );
   end
  else
   Exit;

  SkipBlanks( S, CharIndex );

  case FListStatement.Parse( S, CharIndex ) of
  True: begin
          if FListStatement.ParsedLength = 0 then
           begin
             Result := False;
             Exit;
           end
          else
           begin
             Inc( CharIndex, FListStatement.ParsedLength );
             Inc( FParsedLength, FListStatement.ParsedLength );
           end;
        end;
  else  begin
          Inc( FParsedLength, FListStatement.ParsedLength );
          Result := False;
          Exit;
        end;
  end;

  SkipBlanks( S, CharIndex );

  if S[ CharIndex ] = ')' then
   begin
     Inc( CharIndex );
     Inc( FParsedLength );
   end
  else
   begin
     Result := False;
   end;
end;

{ TPiStatement }

function TPiStatement.GetSourceCode: String;
begin
  Result := 'PI';
end;

function TPiStatement.GetValue: Extended;
begin
  Result := Pi;
end;

function TPiStatement.Parse(const S: String; CharIndex: Integer): Boolean;
begin
  Result := True;

  if UpperCase( Copy( S, CharIndex, 2 ) ) = 'PI' then
   Inc( FParsedLength, 2 );
end;

{ TFunctionStatement }

constructor TFunctionStatement.Create;
begin
  inherited Create;

  FListStatement := TListStatement.Create;
end;

destructor TFunctionStatement.Destroy;
begin
  FListStatement.Free;

  inherited Destroy;
end;

function TFunctionStatement.GetSourceCode: String;
begin
  Result := FFunction + '(' + FListStatement.SourceCode + ')';
end;

function TFunctionStatement.Parse(const S: String; CharIndex: Integer): Boolean;
begin
  Result := True;

  if UpperCase( Copy( S, CharIndex, Length( FFunction ) ) ) = FFunction then
   begin
     Inc( CharIndex, Length( FFunction ) );
     Inc( FParsedLength, Length( FFunction ) );
   end
  else
   begin
     Exit;
   end;

  SkipBlanks( S, CharIndex );

  if S[ CharIndex ] = '(' then
   begin
     Inc( CharIndex );
     Inc( FParsedLength );
   end
  else
   begin
     Result := False;
     Exit;
   end;

  SkipBlanks( S, CharIndex );

  case FListStatement.Parse( S, CharIndex ) of
  True: begin
          if FListStatement.ParsedLength = 0 then
           begin
             Result := False;
             Exit;
           end
          else
           begin
             Inc( CharIndex, FListStatement.ParsedLength );
             Inc( FParsedLength, FListStatement.ParsedLength );
           end;
        end;
  else  begin
          Inc( FParsedLength, FListStatement.ParsedLength );
          Result := False;
          Exit;
        end;
  end;

  SkipBlanks( S, CharIndex );

  if S[ CharIndex ] = ')' then
   begin
     Inc( CharIndex );
     Inc( FParsedLength );
   end
  else
   begin
     Result := False;
   end;
end;

{ TSinStatement }

constructor TSinStatement.Create;
begin
  inherited Create;

  FFunction := 'SIN';
end;

function TSinStatement.GetValue: Extended;
begin
  Result := Sin( FListStatement.Value );
end;

{ TCosStatement }

constructor TCosStatement.Create;
begin
  inherited Create;

  FFunction := 'COS';
end;

function TCosStatement.GetValue: Extended;
begin
  Result := Cos( FListStatement.Value );
end;

{ TTanStatement }

constructor TTanStatement.Create;
begin
  inherited Create;

  FFunction := 'TAN';
end;

function TTanStatement.GetValue: Extended;
begin
  Result := Tan( FListStatement.Value );
end;

{ TSQRTStatement }

constructor TSQRTStatement.Create;
begin
  inherited Create;

  FFunction := 'SQRT';
end;

function TSQRTStatement.GetValue: Extended;
begin
  Result := Sqrt( FListStatement.Value );
end;

{ TFunction2Statement }

constructor TFunction2Statement.Create;
begin
  inherited Create;

  FListStatement1 := TListStatement.Create;
  FListStatement2 := TListStatement.Create;
end;

destructor TFunction2Statement.Destroy;
begin
  FListStatement1.Free;
  FListStatement2.Free;

  inherited Destroy;
end;

function TFunction2Statement.GetSourceCode: String;
begin
  Result := FFunction + '(' + FListStatement1.SourceCode + ',' + FListStatement2.SourceCode + ')';
end;

function TFunction2Statement.GetValue: Extended;
begin
  Result := Power( FListStatement1.Value, FListStatement2.Value );
end;

function TFunction2Statement.Parse(const S: String; CharIndex: Integer): Boolean;
begin
  Result := True;

  if UpperCase( Copy( S, CharIndex, Length( FFunction ) ) ) = FFunction then
   begin
     Inc( CharIndex, Length( FFunction ) );
     Inc( FParsedLength, Length( FFunction ) );
   end
  else
   begin
     Exit;
   end;

  SkipBlanks( S, CharIndex );

  if S[ CharIndex ] = '(' then
   begin
     Inc( CharIndex );
     Inc( FParsedLength );
   end
  else
   begin
     Result := False;
     Exit;
   end;

  SkipBlanks( S, CharIndex );

  case FListStatement1.Parse( S, CharIndex ) of
  True: begin
          if FListStatement1.ParsedLength = 0 then
           begin
             Result := False;
             Exit;
           end
          else
           begin
             Inc( CharIndex, FListStatement1.ParsedLength );
             Inc( FParsedLength, FListStatement1.ParsedLength );
           end;
        end;
  else  begin
          Inc( FParsedLength, FListStatement1.ParsedLength );
          Result := False;
          Exit;
        end;
  end;


  SkipBlanks( S, CharIndex );

  if CharIndex <= Length(S) then
   begin
     if S[ CharIndex ] = ',' then
      begin
        Inc( CharIndex );
        Inc( FParsedLength );
      end;
   end
  else
   begin
     Result := False;
     Exit;
   end;

  SkipBlanks( S, CharIndex );

  case FListStatement2.Parse( S, CharIndex ) of
  True: begin
          if FListStatement2.ParsedLength = 0 then
           begin
             Result := False;
             Exit;
           end
          else
           begin
             Inc( CharIndex, FListStatement2.ParsedLength );
             Inc( FParsedLength, FListStatement2.ParsedLength );
           end;
        end;
  else  begin
          Inc( FParsedLength, FListStatement2.ParsedLength );
          Result := False;
          Exit;
        end;
  end;

  SkipBlanks( S, CharIndex );

  if S[ CharIndex ] = ')' then
   begin
     Inc( CharIndex );
     Inc( FParsedLength );
   end
  else
   begin
     Result := False;
   end;
end;

{ TPowStatement }

constructor TPowStatement.Create;
begin
  inherited Create;

  FFunction := 'POW';
end;

{ TListStatement }

constructor TListStatement.Create;
begin
  inherited Create;

  FList := TList.Create;
end;

destructor TListStatement.Destroy;
begin
  Clear;
  FList.Free;

  inherited Destroy;
end;

function TListStatement.Add(Statement: TStatement): Boolean;
begin
  Result := False;

  if Count = 0 then
   begin

     if Statement is TOperatorStatement then
      if Statement.SourceCode[ 1 ] in ['*','/'] then Exit;

   end
  else
   begin

     if ( Statement is TValueStatement ) and ( Statements[ Count - 1 ] is TValueStatement ) then Exit;


     if ( Statement is TOperatorStatement ) and ( Statements[ Count - 1 ] is TOperatorStatement ) then
      begin
        if Count = 1 then Exit;

        if Statement.SourceCode[ 1 ] in ['*','/'] then Exit;

        if Statements[ Count - 2 ] is TOperatorStatement then Exit;
      end;

   end;

  FList.Add( Statement );
  Result := True;
end;

function TListStatement.Count: Integer;
begin
  Result := FList.Count;
end;

procedure TListStatement.Clear;
var
  i: Integer;
begin
  for i := Count - 1 downto 0 do
   Statements[ i ].Free;
  FList.Clear;
end;

function TListStatement.GetSourceCode: String;
var
  i: Integer;
begin
  Result := '';

  for i := 0 to Count - 1 do
   Result := Result + Statements[ i ].SourceCode;
end;

function TListStatement.GetValue: Extended;
type
  PElement = ^TElement;
  TElement = record
    Value: Extended;
    Operater: Char;
  end;
  
var
  List: TList;

function Element(Index: Integer): PElement;
  begin
    Result := PElement( List[ Index ] );
  end;

procedure Delete(Index: Integer);
  begin
    Dispose( List[ Index ] );
    List.Delete( Index );
  end;

procedure AddToList;
  var
    NewElement: PElement;
    IsOperator: Boolean;
    Minus: Boolean;
    i: Integer;
  begin
    IsOperator := Statements[ 0 ] is TOperatorStatement;
    Minus := False;

    for i := 0 to Count do
     begin
       if IsOperator then
        begin
          New( NewElement );
          if i > 0 then NewElement^.Value := TValueStatement( Statements[ i - 1 ] ).Value
                   else NewElement^.Value := 0;

          if i < Count then NewElement^.Operater := Statements[ i ].SourceCode[ 1 ]
                       else NewElement^.Operater := #0;

          if Minus then
           begin
             NewElement^.Value := - NewElement^.Value;
             Minus := False;
           end;

          List.Add( NewElement );
        end
       else
        begin
          if ( Statements[ i ] is TOperatorStatement ) and ( Statements[ i ].SourceCode[1] in ['-','+'] ) then
           begin
             if Statements[ i ].SourceCode[1] = '-' then
              begin
                Minus := True;
              end;

             IsOperator := True;
           end;
        end;

       IsOperator := not IsOperator
     end;
  end;

procedure ClearList;
  var
    i: Integer;
  begin
    for i := List.Count - 1 downto 0 do
     Delete( i );
    List.Clear;
  end;

procedure CalcMultiplicationAndDivision;
  var
    ExistsMultiplyAndDiv: Boolean;
    i: Integer;
  begin
    ExistsMultiplyAndDiv := True;
    while ExistsMultiplyAndDiv do
     begin
       ExistsMultiplyAndDiv := False;
       for i := 0 to List.Count - 1 do
        case Element( i ).Operater of
        '*','/': begin
                   case Element( i ).Operater of
                   '*': Element( i ).Value := Element( i ).Value * Element( i + 1 ).Value;
                   '/': Element( i ).Value := Element( i ).Value / Element( i + 1 ).Value;
                   end;
                   Element( i ).Operater := Element( i + 1 ).Operater;

                   Delete( i + 1 );

                   ExistsMultiplyAndDiv := True;
                   Break;
                 end;
        end;
     end;
  end;

procedure CalcAdditionAndSubtraction;
  var
    i: Integer;
  begin
    Result := Element( 0 ).Value;
    for i := 0 to List.Count - 2 do
     case Element( i ).Operater of
     '+': Result := Result + Element( i + 1 ).Value;
     '-': Result := Result - Element( i + 1 ).Value;
     end;
  end;

begin
  if Count = 0 then
   begin
     Result := 0;
     Exit;
   end;

  List := TList.Create;
  try

    AddToList;
    try
      CalcMultiplicationAndDivision;
      CalcAdditionAndSubtraction;
    finally
      ClearList;
    end;

  finally
    List.Free;
  end;
end;

function TListStatement.GetStatements(Index: Integer): TStatement;
begin
  Result := FList[ Index ];
end;

function TListStatement.Parse(const S: String; CharIndex: Integer): Boolean;
const
  SupportedStatementClasses: array[0..8] of TStatementClass = ( TRealStatement, TOperatorStatement, TFenceStatement, TPiStatement, TSinStatement, TCosStatement, TTanStatement, TPowStatement, TSQRTStatement );
var
  ParsingStatements: array[Low(SupportedStatementClasses)..High(SupportedStatementClasses)] of TStatement;
  Success: Boolean;
  i: Integer;
function ParseStatement(var Statement: TStatement; StatementClass: TStatementClass): Boolean;
  begin
    Result := True;

    if Statement.Parse( S, CharIndex ) then
     begin
       if Statement.ParsedLength > 0 then
        begin
          if Add( Statement ) then
           begin
             Inc( CharIndex, Statement.ParsedLength );
             Inc( FParsedLength, Statement.ParsedLength );

             Statement := StatementClass.Create;

             Success := True;
           end
          else
           begin
             Result := False;
             Exit;
           end;
        end;
     end
    else
     begin
       Inc( FParsedLength, Statement.ParsedLength );
       Result := False;
       Exit;
     end;
  end;
begin
  Result := True;

  for i := Low( ParsingStatements ) to High( ParsingStatements ) do
   ParsingStatements[ i ] := SupportedStatementClasses[ i ].Create;

  try
    SkipBlanks( S, CharIndex );

    Success := True;
    while Success do
     begin
       Success := False;

       for i := Low( ParsingStatements ) to High( ParsingStatements ) do
        begin
          if not ParseStatement( ParsingStatements[ i ], SupportedStatementClasses[ i ] ) then
           begin
             Result := False;
             Exit;
           end;

          SkipBlanks( S, CharIndex );

          if Success then Break;
        end;
     end;

    if ( Count > 0 ) and ( Statements[ Count - 1 ] is TOperatorStatement ) then Result := False;

  finally
    for i := Low( ParsingStatements ) to High( ParsingStatements ) do
     ParsingStatements[ i ].Free;
  end;
end;

end.
