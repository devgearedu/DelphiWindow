unit URichEdit_GoToLine;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

type
  TForm1 = class(TForm)
    RichEdit1: TRichEdit;
    Button1: TButton;
    ComboBox1: TComboBox;
    procedure Button1Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
procedure SetLineScroll(Line: Integer);
  begin
    RichEdit1.Lines.BeginUpdate;
    try
      SendMessage( RichEdit1.Handle, EM_LINESCROLL, 0, - RichEdit1.Lines.Count );
      SendMessage( RichEdit1.Handle, EM_LINESCROLL, 0, Line );
    finally
      RichEdit1.Lines.EndUpdate;
    end;
  end;
begin
  SetLineScroll( 10 );
end;

procedure TForm1.ComboBox1Change(Sender: TObject);
procedure SetLineScroll(Line: Integer);
  begin
    RichEdit1.Lines.BeginUpdate;
    try
      SendMessage( RichEdit1.Handle, EM_LINESCROLL, 0, - RichEdit1.Lines.Count );
      SendMessage( RichEdit1.Handle, EM_LINESCROLL, 0, Line );
    finally
      RichEdit1.Lines.EndUpdate;
    end;
  end;
begin
  SetLineScroll(StrToint(ComboBox1.Items[ComboBox1.ItemIndex]));
end;

end.
