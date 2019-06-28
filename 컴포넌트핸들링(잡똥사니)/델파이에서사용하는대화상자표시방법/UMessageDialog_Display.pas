unit uMessageDialog_Display;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    TaskDialog1: TTaskDialog;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
 MsgBox;

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  ClickIndex: Integer;
begin
  ClickIndex := MessageBox( '메세지 박스입니다.'#13'테스트중중입니다', '메세지 박스', ['확인(&O)', '취소(&C)', '몰라'], 1 );

  TButton( Sender ).Caption := IntToStr( ClickIndex );
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  ShowMessage('안녕하세요 !');
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  NewString: string;
  ClickedOK: Boolean;
begin
  NewString := '기본값입니다';
  ClickedOK := Dialogs.InputQuery('입력창', '프롬프트', NewString);
  if ClickedOK then            { NewString contains new input string. }
     Button3.Caption := NewString;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  if MessageDlg('델파이로 오신것을 환영합니다. 프로그램 종료할래?',
    mtConfirmation, [mbYes, mbNo], 0, mbYes) = mrYes then
    Close;
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
   MessageDlgPos('위치가 여기가 맞습니까?', mtConfirmation, mbYesNoCancel, 0, 100, 100, mbYes);
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
  // display a task message dialog at a certain position
  TaskMessageDlgPos('Continue', '계속진행하시겠습니까?', mtWarning, mbYesNoCancel, 0, 10, 10);
end;

procedure TForm1.Button7Click(Sender: TObject);
begin
 // display another message dialog at the current position
  TaskMessageDlg('Error', '오류가 발생했습니다', mtError, mbAbortRetryIgnore, 0);
end;

procedure TForm1.Button8Click(Sender: TObject);
var
  TaskDialog: TTaskDialog;
  Button: TTaskDialogBaseButtonItem;
begin
  TaskDialog := TTaskDialog.Create(Self);
  TaskDialog.Title := '쿼리에서 오류가 발생했습니다.';
  TaskDialog.Caption := '쿼리결과';

  // assign a MB_OK modal result to the task dialog
  TaskDialog.ModalResult := MB_OK;

  // add some customized buttons to the task dialog
  Button := TaskDialog.Buttons.Add;
  Button.Caption := 'Continue';
  Button.ModalResult := MB_OK;

  Button := TaskDialog.Buttons.Add;
  Button.Caption := 'Retry';
  Button.ModalResult := MB_RETRYCANCEL;

  // display the dialog box
  TaskDialog.Execute;

end;

procedure TForm1.Button9Click(Sender: TObject);
begin
  TaskDialog1.Execute;

end;

end.
