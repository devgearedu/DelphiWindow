unit uListUp_DLL;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    ListBox: TListBox;
    procedure Button1Click(Sender: TObject);
  private
  public
  end;

var
  Form1: TForm1;

implementation

uses
  TlHelp32;

{$R *.dfm}

procedure EnumModules(Strings: TStrings);
var
  Snapshot: THandle;
  ModuleEntry: TModuleEntry32;
  NextModule: BOOL;
begin
  Snapshot := CreateToolhelp32Snapshot( TH32CS_SNAPALL, GetCurrentProcessID );
  ModuleEntry.dwSize := Sizeof(MODULEENTRY32);
  NextModule := Module32First( Snapshot, ModuleEntry );
  while NextModule do
   begin
     Strings.Add( ModuleEntry.szExePath );
     NextModule := Module32Next( Snapshot, ModuleEntry );
   end;
  CloseHandle( Snapshot );
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  ListBox.Items.Clear;
  EnumModules( ListBox.Items );
end;

end.


