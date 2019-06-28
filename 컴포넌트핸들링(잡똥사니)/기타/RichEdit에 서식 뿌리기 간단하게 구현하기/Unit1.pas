unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    RichEdit1: TRichEdit;
    Button1: TButton;
    Edit1: TLabeledEdit;
    Edit2: TLabeledEdit;
    Edit3: TLabeledEdit;
    procedure Button1Click(Sender: TObject);
  private
  public
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
{$R Formats.res}

procedure LoadRTF(RichEdit: TRichEdit; const ResName, Name, Tel, Address: String);
var
  RTF: String;
  Stream: TStream;
begin
  Stream := TResourceStream.Create( HInstance, ResName, 'RTF' );
  try
    SetLength( RTF, Stream.Size );
    Stream.Read( RTF[1], Stream.Size );
  finally
    Stream.Free;
  end;

  RTF := StringReplace( RTF, 'NAME', Name, [rfReplaceAll] );
  RTF := StringReplace( RTF, 'TEL', Tel, [rfReplaceAll] );
  RTF := StringReplace( RTF, 'ADDRESS', Address, [rfReplaceAll] );

  Stream := TMemoryStream.Create;
  try
    Stream.Write( RTF[1], Length( RTF ) );
    Stream.Position := 0;
    RichEdit.Lines.LoadFromStream( Stream );
  finally
    Stream.Free;
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  LoadRTF( RichEdit1, 'FORMAT1', Edit1.Text, Edit2.Text, Edit3.Text );
end;

end.
