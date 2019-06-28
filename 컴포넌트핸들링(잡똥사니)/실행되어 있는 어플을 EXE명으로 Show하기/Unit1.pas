unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    procedure Button1Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses ShowApp;

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  case ShowApplication( Edit1.Text ) of
  SA_SUCCESS : TButton( Sender ).Caption := '성공';
  SA_NOTEXIST: TButton( Sender ).Caption := 'EXE 없음';
  SA_INACTIVE: TButton( Sender ).Caption := '활성화 실패';
  end;
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
  Edit1.Text := TSpeedButton( Sender ).Caption;
end;

end.
