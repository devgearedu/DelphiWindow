unit MDIChild;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs;

type
  TMDIChildForm = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
  public
  end;

var
  MDIChildForm: TMDIChildForm;

implementation

uses
  MDIChildTaskButtons;

{$R *.dfm}

const
  Colors: array[0..3] of TColor = ( clRed, clYellow, clBlue, clWhite );

var
  ColorIndex: Integer = 0;

procedure TMDIChildForm.FormCreate(Sender: TObject);
begin
  Color := Colors[ColorIndex];
  Inc( ColorIndex );
  if ColorIndex > High( Colors ) then ColorIndex := 0;
  Caption := ColorToString( Color );

  TMDIChildTaskButton.Create( Self );
end;

procedure TMDIChildForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

end.
