unit floating;

{

Float And Dock Controls In Delphi – No Dock Sites, No Dragging

http://zarko-gajic.iz.hr/float-and-dock-controls-in-delphi-no-dock-sites-no-dragging/

One users asked: “Can we undock this tab so that it floats and then activate other tabs on the page control? We would also want to dock the viewer tab back. Further, we have two monitors and would like to move the floating viewer to the second monitor.”

}


interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs;

type
  TFloatingForm = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    fNoFloatParent : TWinControl;
    fSetFloatControl : TControl;

    fOnBeforeDock: TNotifyEvent;
    fOnAfterDock: TNotifyEvent;
    fOnBeforeFloat: TNotifyEvent;
    fOnAfterFloat: TNotifyEvent;
  public
    procedure CreateParams (var Params: TCreateParams); override;
    constructor Create(AOwner : TComponent; const noFloatParent : TWinControl; const setFloatControl : TControl); reintroduce;

    procedure Float;

    property OnBeforeDock : TNotifyEvent read fOnBeforeDock write fOnBeforeDock;
    property OnAfterDock : TNotifyEvent read fOnAfterDock write fOnAfterDock;
    property OnBeforeFloat : TNotifyEvent read fOnBeforeFloat write fOnBeforeFloat;
    property OnAfterFloat : TNotifyEvent read fOnAfterFloat write fOnAfterFloat;
  end;

var
  FloatingForm: TFloatingForm;

implementation
{$R *.dfm}

constructor TFloatingForm.Create(AOwner: TComponent;
  const noFloatParent: TWinControl; const setFloatControl: TControl);
begin
  fNoFloatParent := noFloatParent;
  fSetFloatControl := setFloatControl;

  inherited Create(AOwner);
end;

procedure TFloatingForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  //desktop button
  Params.ExStyle := Params.ExStyle or WS_EX_APPWINDOW;
end;

procedure TFloatingForm.Float;
var
  cnt : integer;
begin
  if Visible then Exit; //already floating

  fSetFloatControl.Visible := false;

  if Assigned(fOnBeforeFloat) then fOnBeforeFloat(self);

  //"magic" :)
  for cnt := -1 + fNoFloatParent.ControlCount downto 0 do
  begin
    fNoFloatParent.Controls[cnt].Parent := self;
  end;

  Visible := true;

  if Assigned(fOnAfterFloat) then fOnAfterFloat(self);
end;

procedure TFloatingForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
// HIDE by default!
// Action := caNone;
end;

procedure TFloatingForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var
  cnt : integer;
begin
  if Assigned(fOnBeforeDock) then fOnBeforeDock(self);

  for cnt:= -1 + ControlCount downto 0 do
  begin
    Controls[cnt].Parent := fNoFloatParent;
  end;

  fSetFloatControl.Visible := true;

  if Assigned(fOnAfterDock) then fOnAfterDock(self);
  //form is hidden by default (Action = caHide on OnClose)
end;

procedure TFloatingForm.FormCreate(Sender: TObject);
begin
  FormStyle := fsStayOnTop;
end;

end.
