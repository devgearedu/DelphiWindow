unit utest_exception;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm188 = class(TForm)
    ListBox1: TListBox;
    Button1: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form188: TForm188;

implementation

{$R *.dfm}

procedure TForm188.Button1Click(Sender: TObject);
begin
// try
    try
      caption := ListBox1.Items[0];
    except
       on e:estringListerror do
       begin
          showmessage('error1 process');
       //   raise;
          abort;  // raise eabort.create('xxx')
       end;
    end;
//  except
//    showmessage('error2 process');
//  end;
   showmessage('ing');
end;

procedure TForm188.Button2Click(Sender: TObject);
var
  i:integer;
begin
  if edit1.Text = '' then
     raise Exception.Create('edit1 입력꼭');
  try
    i := strtoint(edit2.Text);
  except
    raise Exception.Create('숫자 아님');
  end;

  showmessagE('ok');
end;

end.
