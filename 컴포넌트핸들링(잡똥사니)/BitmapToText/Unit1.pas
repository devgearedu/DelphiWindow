unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ExtDlgs, Jpeg, PngImage, ComCtrls;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Image: TImage;
    Memo: TMemo;
    Button1: TButton;
    Button2: TButton;
    OpenDialog: TOpenPictureDialog;
    ProgressBar: TProgressBar;
    ComboBox_Zoom: TComboBox;
    Splitter1: TSplitter;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    procedure Progress(Max, Position: Integer; Visible: Boolean);
  public
  end;

var
  Form1: TForm1;

implementation

uses Unit2;

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  if OpenDialog.Execute then
   begin
     Image.Picture.LoadFromFile( OpenDialog.FileName );
     Image.AutoSize := True;
     Image.AutoSize := False;
     Memo.Lines.Clear;
   end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
  try
    Memo.Lines.BeginUpdate;
    try
      Memo.Text := GraphicToText( Image.Picture.Graphic, ComboBox_Zoom.ItemIndex + 1, Progress );
    finally
      Memo.Lines.EndUpdate;
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TForm1.Progress(Max, Position: Integer; Visible: Boolean);
begin
  ProgressBar.Visible := Visible;
  ProgressBar.Max := Max;
  ProgressBar.Position := Position;
end;

end.
