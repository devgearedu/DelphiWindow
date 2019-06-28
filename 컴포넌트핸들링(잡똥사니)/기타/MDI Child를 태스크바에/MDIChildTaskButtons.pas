unit MDIChildTaskButtons;

interface

uses
  Windows, Messages, Classes, Controls, Forms;

type
  TMDIChildTaskButton = class(TForm)
  private
    MDIChildForm: TForm;
    MDIChildOldWindowProc: TWndMethod;
    procedure WMActivate(var Message: TWMActivate); message WM_ACTIVATE;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure MDIChildWndProc(var Message: TMessage);
  public
    constructor Create(MDIChildForm: TForm); reintroduce;
  end;

implementation

constructor TMDIChildTaskButton.Create(MDIChildForm: TForm);
begin
  CreateNew( nil );

  Self.MDIChildForm := MDIChildForm;
  MDIChildForm.FreeNotification( Self );
  MDIChildOldWindowProc := MDIChildForm.WindowProc;
  MDIChildForm.WindowProc := MDIChildWndProc;

  BorderStyle := bsNone;
  Caption := MDIChildForm.Caption;
  Icon.Assign( MDIChildForm.Icon );
  Height := 0;
  Width := 0;
end;

procedure TMDIChildTaskButton.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams( Params );
  Params.WndParent := 0;
end;

procedure TMDIChildTaskButton.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification( AComponent, Operation );

  if ( Operation = opRemove ) and ( AComponent = MDIChildForm ) then
   begin
     MDIChildForm := nil;
     Free;
   end;
end;

procedure TMDIChildTaskButton.MDIChildWndProc(var Message: TMessage);
begin
  case Message.Msg of
  WM_MDIACTIVATE: begin
                    if TWMMDIActivate( Message ).ActiveWnd = MDIChildForm.Handle then Show;
                  end;

  CM_TEXTCHANGED: begin
                    MDIChildOldWindowProc( Message );
                    Caption := MDIChildForm.Caption;
                  end;

  CM_ICONCHANGED: begin
                    MDIChildOldWindowProc( Message );
                    Icon.Assign( MDIChildForm.Icon );
                  end;
                  
  else MDIChildOldWindowProc( Message );
  end;
end;

procedure TMDIChildTaskButton.WMActivate(var Message: TWMActivate);
begin
  case Message.Active of
  WA_ACTIVE,
  WA_CLICKACTIVE: begin
                    if ( MDIChildForm <> nil ) and Application.MainForm.Visible then
                     begin
                       Message.Active := WA_INACTIVE;
                       MDIChildForm.Show;
                       if MDIChildForm.WindowState = wsMinimized then MDIChildForm.WindowState := wsNormal;

                       if GetForegroundWindow <> Application.MainForm.Handle then
                        Application.MainForm.Show;

                       case Message.Active of
                       WA_CLICKACTIVE: MessageBeep(0);
                       end;
                     end;
                  end;
  end;

  inherited;
end;

end.
