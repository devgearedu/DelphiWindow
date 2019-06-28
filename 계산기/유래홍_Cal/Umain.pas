unit Umain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TForm3 = class(TForm)
    Panel1: TPanel;
    btn_Backspace: TButton;
    btn_Reset: TButton;
    btn_Sign: TButton;
    btn_Root: TButton;
    btn_Percent: TButton;
    btn_Div: TButton;
    btn_Num3: TButton;
    btn_Num2: TButton;
    btn_Num1: TButton;
    btn_Inverse: TButton;
    btn_Mul: TButton;
    btn_Num6: TButton;
    btn_Num5: TButton;
    btn_Num4: TButton;
    btn_Enter: TButton;
    btn_Sub: TButton;
    btn_Num9: TButton;
    btn_Num8: TButton;
    btn_Num7: TButton;
    btn_Add: TButton;
    btn_Dat: TButton;
    btn_Num0: TButton;
    Panel2: TPanel;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btn_Num1Click(Sender: TObject);

    procedure InputData(var Key:Word);  // 입력이 일어났을때 분기해주는 프로시져
    procedure OperatorProc(var _str:string);
    procedure NumberProc(var _str:string);
    procedure EnterProc;
    procedure StringSplit(const Delimiter: Char; Input: string; var Strings: TStringList);
    procedure btn_Num2Click(Sender: TObject);
    procedure btn_Num3Click(Sender: TObject);
    procedure btn_Num4Click(Sender: TObject);
    procedure btn_Num5Click(Sender: TObject);
    procedure btn_Num6Click(Sender: TObject);
    procedure btn_Num7Click(Sender: TObject);
    procedure btn_Num8Click(Sender: TObject);
    procedure btn_Num9Click(Sender: TObject);
    procedure btn_Num0Click(Sender: TObject);
    procedure btn_DatClick(Sender: TObject);
    procedure btn_ResetClick(Sender: TObject);
    procedure btn_BackspaceClick(Sender: TObject);
    procedure btn_EnterClick(Sender: TObject);
    procedure btn_DivClick(Sender: TObject);
    procedure btn_MulClick(Sender: TObject);
    procedure btn_SubClick(Sender: TObject);
    procedure btn_AddClick(Sender: TObject);
    procedure btn_PercentClick(Sender: TObject); //입력된 식을 배열로 분할해주는 프로시져
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;
  isOperator:bool = false; //방금 들어온 입력이 연산자인가 체크
implementation

{$R *.dfm}

procedure TForm3.btn_AddClick(Sender: TObject);
var
  temp:word;
begin
  temp := 107;
  InputData(temp);
end;

procedure TForm3.btn_BackspaceClick(Sender: TObject);
var
  temp:word;
begin
  temp := 8;
  InputData(temp);
end;

procedure TForm3.btn_DatClick(Sender: TObject);
var
  temp:word;
begin
  temp := 110;
  InputData(temp);
end;

procedure TForm3.btn_DivClick(Sender: TObject);
var
  temp:word;
begin
  temp := 111;
  InputData(temp);
end;
procedure TForm3.btn_EnterClick(Sender: TObject);
var
  temp:word;
begin
  temp := 13;
  InputData(temp);
end;

procedure TForm3.btn_MulClick(Sender: TObject);
var
  temp:word;
begin
  temp := 106;
  InputData(temp);
end;

procedure TForm3.btn_Num0Click(Sender: TObject);
var
  temp:word;
begin
  temp := 48;
  InputData(temp);
end;

procedure TForm3.btn_Num1Click(Sender: TObject);
var
  temp:word;
begin
  temp := 49;
  InputData(temp);
end;


procedure TForm3.btn_Num2Click(Sender: TObject);
var
  temp:word;
begin
  temp := 50;
  InputData(temp);
end;

procedure TForm3.btn_Num3Click(Sender: TObject);
var
  temp:word;
begin
  temp := 51;
  InputData(temp);
end;

procedure TForm3.btn_Num4Click(Sender: TObject);
var
  temp:word;
begin
  temp := 52;
  InputData(temp);
end;

procedure TForm3.btn_Num5Click(Sender: TObject);
var
  temp:word;
begin
  temp := 53;
  InputData(temp);
end;

procedure TForm3.btn_Num6Click(Sender: TObject);
var
  temp:word;
begin
  temp := 54;
  InputData(temp);
end;

procedure TForm3.btn_Num7Click(Sender: TObject);
var
  temp:word;
begin
  temp := 55;
  InputData(temp);
end;

procedure TForm3.btn_Num8Click(Sender: TObject);
var
  temp:word;
begin
  temp := 56;
  InputData(temp);
end;

procedure TForm3.btn_Num9Click(Sender: TObject);
var
  temp:word;
begin
  temp := 57;
  InputData(temp);
end;



procedure TForm3.btn_ResetClick(Sender: TObject);
var
  temp:word;
begin
  temp := 27;
  InputData(temp);
end;
procedure TForm3.btn_SubClick(Sender: TObject);
var
  temp:word;
begin
  temp := 109;
  InputData(temp);
end;

procedure TForm3.btn_PercentClick(Sender: TObject);
begin
  ShowMessage('추후 지원 예정입니다.');
end;


procedure TForm3.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  InputData(Key);
end;

procedure TForm3.InputData(var Key: Word);              // 입력값에 따른 분기 프로시져. 키보드 입력이든 버튼 입력이든 모두 여길 탄다.
var
  str,value:string;
begin

  str := staticText1.Caption;
  case Key of
    13{enter}: EnterProc;
    187,107{+}:
    begin
      value := ' + ';
      OperatorProc(value);
    end;
    189,109{-}:
    begin
      value := ' - ';
      OperatorProc(value);
    end;
    168,106{*}:
    begin
      value := ' * ';
      OperatorProc(value);
    end;
    191,111{/}:
    begin
      value := ' / ';
      OperatorProc(value);
    end;

    48{0},96{num0}:
    begin
      value := '0';
      NumberProc(value);
    end;
    49{1},97{num1}:
    begin
      value := '1';
      NumberProc(value);
    end;
    50{2},98{num2}:
    begin
      value := '2';
      NumberProc(value);
    end;
    51{3},99{num3}:
    begin
      value := '3';
      NumberProc(value);
    end;
    52{4},100{num4}:
    begin
      value := '4';
      NumberProc(value);
    end;
    53{5},101{num5}:
    begin
      value := '5';
      NumberProc(value);
    end;
    54{6},102{num6}:
    begin
      value := '6';
      NumberProc(value);
    end;
    55{7},103{num7}:
    begin
      value := '7';
      NumberProc(value);
    end;
    56{8},104{num8}:
    begin
      value := '8';
      NumberProc(value);
    end;
    57{9},105{num9}:
    begin
      value := '9';
      NumberProc(value);
    end;
    110, 190{.}:
    begin
      if Pos('.', str) = 0 then  //소수점이 찍혀있는지 검사. 안찍혀있을때만 찍어줌
        StaticText1.Caption := StaticText1.Caption + '.';
    end;
    27{esc}:
    begin
     StaticText1.Caption := '';
     StaticText2.Caption := '';
    end;
    8{back}: StaticText1.Caption := str.Substring(0,str.Length-1);
  end;
end;

procedure TForm3.OperatorProc(var _str:string);   //연산자 입력 처리   + - * / 입력시
var
  temp1,temp2:string;
begin
  temp1 := StaticText1.Caption;
  temp2 := StaticText2.Caption;
  if isOperator then
  begin
     if StaticText2.Caption = '' then
     else
        Delete(temp2,Length(temp2)-2,3);
        StaticText2.Caption := temp2 + _str;
  end
  else
  begin
    StaticText2.Caption := StaticText2.Caption + StaticText1.Caption + _str;
    isOperator := true;
  end;
end;

procedure TForm3.NumberProc(var _str: string);    //피연산자 입력 처리    0~9 입력시
var
  temp2:string;
begin
  temp2 := StaticText2.Caption;
  Delete(temp2,0,1);
  if isOperator then
  begin
    StaticText1.Caption := _str;
    if StaticText2.Caption = '' then
    else
  end
  else
  begin
    StaticText1.Caption := StaticText1.Caption + _str;
  end;

  isOperator := false;
end;

procedure TForm3.EnterProc;       //연산 결과 처리   엔터 혹은 =버튼
var
  str:string;
  x,y,op,result:Variant;
  S:TStringList;
  i:integer;
begin
  if StaticText2.Caption = '' then
  else
  begin
    try
    str := StaticText2.Caption;
    S := TStringList.Create;
    StringSplit(' ', str, S);
    S.Add(StaticText1.Caption);
    x := S[0];
    op := S[1];
    y := S[2];
      for I := 2 to s.Count-1 do
        begin
          if (i mod 2) = 0 then
          begin
            if op = '+' then
              result := StrToFloat(x) + StrToFloat(y)
            else if op = '-' then
              result := StrToFloat(x) - StrToFloat(y)
            else if op = '*' then
              result := x * y
            else if op = '/' then
            try
              result := x / y;
            except
              ShowMessage('나누기 에러. 0으로 나눌 수 없습니다')
            end;
            //ShowMessage(result);
            x:= result;
            op:= S[i+1];
            y:= S[i+2];
          end;
        end;
    except;
    end;
      StaticText2.Caption := '';
      StaticText1.Caption := result;
      isOperator := false;

  end;
end;

procedure TForm3.StringSplit(const Delimiter: Char; Input: string;     // 입력된 식을 배열로 분할
  var Strings: TStringList);
begin
  Assert(Assigned(Strings)) ;
   Strings.Clear;
   ExtractStrings([Delimiter], [' '], PChar(Input), Strings);
end;

end.
