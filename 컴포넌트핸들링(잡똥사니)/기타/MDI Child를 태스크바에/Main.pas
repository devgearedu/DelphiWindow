unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus;

type
  TMainForm = class(TForm)
    MainMenu1: TMainMenu;
    MDIChild1: TMenuItem;
    procedure MDIChild1Click(Sender: TObject);
  private
  public
  end;

var
  MainForm: TMainForm;

implementation

uses
  MDIChild;

{$R *.dfm}

procedure TMainForm.MDIChild1Click(Sender: TObject);
begin
  TMDIChildForm.Create( nil );
end;

end.
