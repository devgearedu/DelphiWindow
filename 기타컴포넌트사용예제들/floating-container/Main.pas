unit Main;

{

Float And Dock Controls In Delphi ?No Dock Sites, No Dragging

http://zarko-gajic.iz.hr/float-and-dock-controls-in-delphi-no-dock-sites-no-dragging/

One users asked: “Can we undock this tab so that it floats and then activate other tabs on the page control? We would also want to dock the viewer tab back. Further, we have two monitors and would like to move the floating viewer to the second monitor.?

}


interface

uses
  floating,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls;

type
  TMainForm = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    Button1: TButton;
    Memo1: TMemo;
    Memo2: TMemo;
    Button2: TButton;
    Memo3: TMemo;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    fFloating1 : TFloatingForm;
    function GetFloating1: TFloatingForm;

    property Floating1 : TFloatingForm read GetFloating1;

    procedure Floating1AfterDock(Sender : TObject);
    procedure Floating1AfterFloat(Sender : TObject);
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

{ TMainForm }

procedure TMainForm.Button1Click(Sender: TObject);
begin
  Floating1.Float;
end;

procedure TMainForm.Button2Click(Sender: TObject);
begin
  //For this you need to impement "Floating2" in the same way as Floating1
end;

procedure TMainForm.Button3Click(Sender: TObject);
begin
  //For this you need to impement "Floating3" in the same way as Floating1
end;

procedure TMainForm.Floating1AfterDock(Sender: TObject);
begin
  memo1.Lines.Add('dock at ' + DateTimeToStr(Now));
  TabSheet1.TabVisible := true;

  PageControl1.ActivePage := TabSheet1;
end;

procedure TMainForm.Floating1AfterFloat(Sender: TObject);
begin
  TabSheet1.TabVisible := false;
  memo1.Lines.Add('float at ' + DateTimeToStr(Now));
end;

function TMainForm.GetFloating1: TFloatingForm;
begin
  if fFloating1 = nil then
  begin
    fFloating1 := TFloatingForm.Create(self, TabSheet1, Button1);

    fFloating1.OnAfterDock := Floating1AfterDock;
    fFloating1.OnAfterFloat := Floating1AfterFloat;
  end;
  result := fFloating1;
end;

end.
