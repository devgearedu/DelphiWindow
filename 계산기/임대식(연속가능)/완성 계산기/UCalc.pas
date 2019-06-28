unit UCalc;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TClacForm = class(TForm)
    GroupBox1: TGroupBox;
    Lbsh: TLabel;            // 결과값을 보여줄 레이블
    ButNum1: TButton;        // 버튼
    ButNum2: TButton;
    ButNum3: TButton;
    ButNum4: TButton;
    ButNum5: TButton;
    ButNum6: TButton;
    ButNum7: TButton;
    ButNum8: TButton;
    ButNum9: TButton;
    ButNum0: TButton;
    ButAdd: TButton;
    ButSub: TButton;
    ButMult: TButton;
    ButDiv: TButton;
    ButCE: TButton;
    ButResult: TButton;
    ButOpr: TButton;

    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure ButOprClick(Sender: TObject);
    procedure ButResultClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
     procedure C_Command ;               // 입력삭제 ,연산자, 화면 출력 프로시저
     procedure DisplayNumber ;
     procedure Equal_Command ;
     procedure OP_Command ;
  end;

const
   AddOp = 1 ;
   SubOp = 2 ;              //
   MulOp = 3 ;
   DivOp = 4 ;
   EqlOP = 5 ;
   PerOP = 6 ;

var
  ClacForm: TClacForm;


  opWhat : Integer ;
  szValue,szOldValue : String ;
  bExistOldValue : Boolean ;
  eNow,eOld   : Extended ;
  bOperator : Boolean ;
  lbString : String ;

implementation

{$R *.DFM}

procedure TClacForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
   case Key of
      '0'..'9' :
        begin
          bOperator := False ;
          szValue := szOldValue + Key ;
          szOldValue := szValue ;
        end ;
      '+' : begin opWhat := AddOP ; OP_Command ; end ;
      '-' : begin opWhat := SubOP ; OP_Command ; end ;
      '=' : begin Equal_Command   ; opWhat := EqlOP ;end ;
      '/' : begin opWhat := DivOP ; OP_Command ; end ;
      '*' : begin opWhat := MulOP ; OP_Command ; end ;
      'c','C': begin opWhat := 0 ; C_Command ; end ;
   end ;

   lbString := szValue ;
   if not(bOperator) then
   begin
         DisplayNumber ;
      bOperator := False ;
   end ;
end;

procedure TClacForm.C_Command ;
begin
     bExistOldValue := False ;
     szValue := '0' ;
     lbString := szValue ;
     DisplayNumber ;
     szOldValue := '' ;
     eNow := 0 ;
     eOld := 0 ;
end ;


procedure TClacForm.OP_Command ;
begin
   if not(bOperator) then
   begin
       bOperator := True ;
       if bExistOldValue then
       begin
          eNow := StrToFloat(szValue) ;
          case opWhat of
               AddOP : eOld := eOld + eNow ;
               SubOP : eOld := eOld - eNow ;
               MulOP : eOld := eOld * eNow ;
               DivOP : eOld := eOld / eNow ;

          end ;
          lbString := FloatToStr(eOld) ;
          DisplayNumber ;
       end
       else
       begin
          eOld := StrToFloat(szValue) ;
          bExistOldValue := True ;
       end ;

       szValue := '' ;
       szOldValue := '' ;
   end ;
end ;



procedure TClacForm.Equal_Command ;
begin
   if not(bOperator) then
   begin
       bOperator := True ;
       eNow := StrToFloat(szValue) ;

       case opWhat of
               AddOP : eOld := eOld + eNow ;
               SubOP : eOld := eOld - eNow ;
               MulOP : eOld := eOld * eNow ;
               DivOP : eOld := eOld / eNow ;
       end ;
       lbString := FloatToStr(eOld) ;
       DisplayNumber ;
       szValue := '' ;
       szOldValue := '' ;
   end ;
end ;


procedure TClacForm.FormCreate(Sender: TObject);
begin
     bExistOldValue := False ;
     bOperator := False ;
     szValue := '' ;
     szOldValue := '' ;
     eNow := 0 ;
     eOld := 0 ;
end;



procedure TClacForm.ButResultClick(Sender: TObject);
begin
    C_Command ;
end;




procedure TClacForm.ButOprClick(Sender: TObject);
var
    szKey : String ;
    btnImsi : TButton ;
begin
    btnImsi := TButton(Sender) ;
    szKey := btnImsi.Caption ;
    FormKeyPress(Sender,szKey[1]) ;
end;
procedure TClacForm.DisplayNumber ;
begin
   Lbsh.Caption := lbString ;
end ;

end.
