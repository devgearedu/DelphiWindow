unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
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

end.
