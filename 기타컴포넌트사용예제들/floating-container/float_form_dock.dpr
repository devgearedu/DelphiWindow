program float_form_dock;

{

Float And Dock Controls In Delphi ?No Dock Sites, No Dragging

http://zarko-gajic.iz.hr/float-and-dock-controls-in-delphi-no-dock-sites-no-dragging/

One users asked: “Can we undock this tab so that it floats and then activate other tabs on the page control? We would also want to dock the viewer tab back. Further, we have two monitors and would like to move the floating viewer to the second monitor.?

}


uses
  Vcl.Forms,
  Main in 'Main.pas' {MainForm},
  floating in 'floating.pas' {FloatingForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  //Application.CreateForm(TFloatingForm, FloatingForm); // no auto create, create when needed lazy
  Application.Run;
end.
