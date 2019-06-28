unit Help_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

type
  THelp_Form = class(TForm)
    RichEdit: TRichEdit;
    procedure FormCreate(Sender: TObject);
  private
  public
  end;

var
  Help_Form: THelp_Form;

implementation

{$R *.dfm}

const
  Help = '{\rtf1\ansi\ansicpg949\deff0\deflang1033\deflangfe1042{\fonttbl{\f0\fmodern\fprq1\fcharset129 \''b1\''bc\''b8\''b2;}{\f1\fmodern\fprq1\fcharset129 \''b1\''bc\''b8\''b2\''c3\''bc;}}'#13#10 +
         '{\colortbl ;\red0\green0\blue255;\red255\green0\blue0;}'#13#10 +
         '{\*\generator Msftedit 5.41.15.1515;}\viewkind4\uc1\pard\lang1042\f0\fs18\par'#13#10 +
         '  \b\fs20\''b0\''e8\''bb\''ea\''c7\''cf\''b4\''c2 \''b9\''e6\''b9\''fd\b0\fs18\par'#13#10 +
         '\par'#13#10 +
         ' \''c8\''ad\''b8\''e9\''c0\''c7 \''b9\''f6\''c6\''b0\''c0\''bb \''c5\''ac\''b8\''af\''c7\''cf\''b0\''c5\''b3\''aa \''c5\''b0\''ba\''b8\''b5\''e5\''b7\''ce \''c5\''b8\''c0\''cc\''c7\''ce\''c7\''cf\''bf\''a9 \''bc\''f6\''bd\''c4\''c0\''bb \''c0\''d4\''b7\''c2\''c7\''d1 \''c8\''c4\par'#13#10 +
         '  =\''b9\''f6\''c6\''b0\''c0\''bb \''c5\''ac\''b8\''af\''c7\''cf\''b8\''e9 \''b0\''e8\''bb\''ea\''c0\''cc \''b5\''cb\''b4\''cf\''b4\''d9. \''c8\''a4\''c0\''ba \''bf\''a3\''c5\''cd\''c5\''b0\''b8\''a6 \''b4\''ad\''b7\''af\''b5\''b5 \''b5\''cb\''b4\''cf\''b4\''d9.\par'#13#10 +
         '\par'#13#10 +
         '\par'#13#10 +
         '  \b\fs20 sin, cos, tan\b0\fs18\par'#13#10 +
         '\par'#13#10 +
         ' \''c1\''d6\''be\''ee\''c1\''f8 \''b0\''a2\''b5\''b5\''c0\''c7 \''bb\''e7\''c0\''ce\''b0\''aa, \''c4\''da\''bb\''e7\''c0\''ce\''b0\''aa, \''c5\''ba\''c1\''a8\''c6\''ae\''b0\''aa\''c0\''bb \''b9\''dd\''c8\''af\''c7\''d5\''b4\''cf\''b4\''d9.\par'#13#10 +
         ' \''c0\''ce\''bc\''f6\''b0\''a1 \''b5\''b5 \''b4\''dc\''c0\''a7\''c0\''cc\''b8\''e9 pi/180\''c0\''bb \''b0\''f6\''c7\''d5\''b4\''cf\''b4\''d9.\par'#13#10 +
         '\par'#13#10 +
         '\par'#13#10 +
         '  \b\fs20 sin \''bf\''b9\''c1\''a6\b0\fs18\par'#13#10 +
         '\par'#13#10 +
         '\f1  \cf1 sin( pi/2 )\cf0       = \cf2 1\cf0                  (pi/2 \''b6\''f3\''b5\''f0\''be\''c8\''c0\''c7 \''bb\''e7\''c0\''ce\''b0\''aa\''c0\''d4\''b4\''cf\''b4\''d9.)\par'#13#10 +
         ' \cf1 sin( 30*pi/180 )\cf0  = \cf2 0.5\cf0                (30\''b5\''b5\''c0\''c7 \''bb\''e7\''c0\''ce\''b0\''aa\''c0\''d4\''b4\''cf\''b4\''d9.)\f0\par'#13#10 +
         '\par'#13#10 +
         '\par'#13#10 +
         '  \b\fs20 cos \''bf\''b9\''c1\''a6\b0\fs18\par'#13#10 +
         '\par'#13#10 +
         '\f1  \cf1 cos( 1.047 )\cf0      = \cf2 0.50017107459707\cf0   (1.047 \''b6\''f3\''b5\''f0\''be\''c8\''c0\''c7 \''c4\''da\''bb\''e7\''c0\''ce \''b0\''aa\''c0\''d4\''b4\''cf\''b4\''d9.)\par'#13#10 +
         ' \cf1 cos( 60*pi/180 )\cf0  = \cf2 0.5\cf0                (60\''b5\''b5\''c0\''c7 \''c4\''da\''bb\''e7\''c0\''ce \''b0\''aa\''c0\''d4\''b4\''cf\''b4\''d9.)\f0\par'#13#10 +
         '\par'#13#10 +
         '\par'#13#10 +
         '  \b\fs20 tan \''bf\''b9\''c1\''a6\b0\fs18\par'#13#10 +
         '\par'#13#10 +
         '\f1  \cf1 tan( 0.785 )\cf0      = \cf2 0.99920399\cf0         (0.785 \''b6\''f3\''b5\''f0\''be\''c8\''c0\''c7 \''c5\''ba\''c1\''a8\''c6\''ae\''c0\''d4\''b4\''cf\''b4\''d9.)\par'#13#10 +
         ' \cf1 tan( 45*pi/180 )\cf0  = \cf2 1\cf0                  (45\''b5\''b5\''c0\''c7 \''c5\''ba\''c1\''a8\''c6\''ae\''c0\''d4\''b4\''cf\''b4\''d9.)\f0\par'#13#10 +
         '\par'#13#10 +
         ' \par'#13#10 +
         '  \b\fs20 pi\b0\fs18\par'#13#10 +
         '\par'#13#10 +
         ' 3.14159265358979\''b8\''a6 \''c7\''a5\''bd\''c3\''c7\''d5\''b4\''cf\''b4\''d9.\par'#13#10 +
         ' \''bc\''f6\''b8\''ae \''bb\''f3\''bc\''f6 pi 15\''c0\''da\''b8\''ae\''b1\''ee\''c1\''f6\''c0\''c7 \''c1\''a4\''b9\''d0\''b5\''b5\''b7\''ce \''b1\''b8\''c7\''d5\''b4\''cf\''b4\''d9.\par'#13#10 +
         '\par'#13#10 +
         '\par'#13#10 +
         ' \b\''b8\''cd\''b1\''d9\''b3\''d1 & \''b6\''f3\''c0\''cc\''bc\''be\''bd\''ba\b0\par'#13#10 +
         '\par'#13#10 +
         ' \''be\''e7\''ba\''b4\''b1\''d4 delmadang@hanmail.net\par'#13#10 +
         '           http://www.bkayng.com\par'#13#10 +
         '\par'#13#10 +
         ' \''c0\''cc \''c7\''c1\''b7\''ce\''b1\''d7\''b7\''a5\''c0\''ba \''c7\''c1\''b8\''ae\''bf\''fe\''be\''ee\''c0\''d4\''b4\''cf\''b4\''d9. \par'#13#10 +
         ' \''b0\''b3\''c0\''ce, \''b1\''e2\''be\''f7, \''b0\''fc\''b0\''f8\''bc\''ad\''b5\''ee \''b4\''a9\''b1\''b8\''b3\''aa \''b9\''ab\''b7\''e1\''b7\''ce \''bb\''e7\''bf\''eb\''c7\''d2 \''bc\''f6 \''c0\''d6\''bd\''c0\''b4\''cf\''b4\''d9.\par'#13#10 +
         ' \''b9\''f6\''b1\''d7\''b8\''ae\''c6\''f7\''c6\''ae, \''b9\''ae\''c0\''c7 \''b5\''ee\''c0\''ba \''b9\''de\''c1\''f6 \''be\''ca\''bd\''c0\''b4\''cf\''b4\''d9.\fs20\par'#13#10 +
         '}';


procedure THelp_Form.FormCreate(Sender: TObject);
var
  Stream: TStream;
begin
  Stream := TStringStream.Create( Help );
  try
    RichEdit.Lines.LoadFromStream( Stream );
  finally
    Stream.Free;
  end;
end;

end.
