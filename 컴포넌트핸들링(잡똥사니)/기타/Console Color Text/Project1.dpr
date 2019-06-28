program Project1;

{$APPTYPE CONSOLE}

uses
  Windows, SysUtils;


const
  LT = 1;
  RT = 2;
  LB = 3;
  RB = 4;
  VL = 5;
  HL = 6;
  CR = 16;
  BC = 21;
  TC = 22;
  RC = 23;
  LC = 25;
  
var
  Console: DWord;
//  Buffer: array[0..99] of Char;
//  Written: DWord;
  ConsoleScreenBufferInfo: TConsoleScreenBufferInfo;
  OldAttribute: Word;
  CursorPosition: TCoord;
  i: Integer;
  S: String;
begin
  Console := GetStdHandle( STD_OUTPUT_HANDLE );
  if GetConsoleScreenBufferInfo( Console, ConsoleScreenBufferInfo ) then OldAttribute := ConsoleScreenBufferInfo.wAttributes
                                                                    else OldAttribute := 0;


  SetConsoleTextAttribute( Console, FOREGROUND_BLUE or FOREGROUND_INTENSITY or BACKGROUND_RED or BACKGROUND_GREEN or BACKGROUND_BLUE or  BACKGROUND_INTENSITY );
                                                                    
  WriteLn( '콘솔창에다가 컬러로 글씨 쓰기 예제(양병규)' );


  SetConsoleTextAttribute( Console, FOREGROUND_RED or FOREGROUND_GREEN or FOREGROUND_INTENSITY );


  S := Char(LT) + Char(TC) + Char(RT);
  WriteLn( S );

  S := Char(LC) + Char(CR) + Char(RC);
  WriteLn( S );

  S := Char(LB) + Char(BC) + Char(RB);
  WriteLn( S );

  SetConsoleTextAttribute( Console, FOREGROUND_RED or FOREGROUND_INTENSITY or BACKGROUND_RED or BACKGROUND_GREEN or BACKGROUND_BLUE or BACKGROUND_INTENSITY );


  GetConsoleScreenBufferInfo( Console, ConsoleScreenBufferInfo );
  CursorPosition := ConsoleScreenBufferInfo.dwCursorPosition;
  Dec( CursorPosition.Y, 2);
  CursorPosition.X := 3;
  SetConsoleCursorPosition( Console, CursorPosition );

  for i := 0 to 99 do
   begin
     SetConsoleCursorPosition( Console, CursorPosition );
     WriteLn( IntToStr( i ) );
     Sleep(1);
   end;



// for i := 0 to 255 do
//   WriteLn( IntToStr( i ) + ': ' + Char(i) );

  SetConsoleTextAttribute( Console, OldAttribute );
end.



