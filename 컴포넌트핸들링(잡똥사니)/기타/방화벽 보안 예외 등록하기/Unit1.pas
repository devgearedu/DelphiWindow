unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ScktComp;

type
  TForm1 = class(TForm)
    Button3: TButton;
    Memo1: TMemo;
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  Registry;

{$R *.dfm}


procedure AuthorizedFirewall(const Title, ExeName: String);
var
  Strings: TStrings;
begin
  with TRegistry.Create do
   try
     RootKey := HKEY_LOCAL_MACHINE;
     if OpenKey( 'SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile\AuthorizedApplications\List\', False ) then
      begin
        Strings := TStringList.Create;
        try
          GetValueNames( Strings );
          if Strings.IndexOf( ExeName ) >= 0 then Exit;
          WriteString( ExeName, ExeName + ':*:Enabled:' + Title );
        finally
          Strings.Free;
        end;
      end;
   finally
     Free;
   end;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  AuthorizedFirewall( 'Test App', Application.ExeName );
end;

end.
