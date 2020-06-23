unit utest1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    MyButton: TButton;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Button10: TButton;
    Button12: TButton;
    GroupBox1: TGroupBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    ColorDialog1: TColorDialog;
    Button11: TButton;
    Button13: TButton;
    Button14: TButton;
    Panel1: TPanel;
    procedure MyButtonClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Edit2KeyPress(Sender: TObject; var Key: Char);
    procedure Edit1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    procedure TestHandler(Sender:Tobject);
    function ShowOnce( AFormClass:TFormClass;AShowing:Boolean=True):TForm;
    { Public declarations }
  end;

const
  ScreenWidth = 1024;
  screenHeight = 768;

var
  Form1: TForm1;

implementation
uses utest4, utest3, utest2;
var
  h:th;
  Test_btn:TButton;
{$R *.dfm}

procedure TForm1.Button10Click(Sender: TObject);
begin
    if ColorDialog1.Execute then
       Color := ColorDialog1.Color;
end;

procedure TForm1.Button11Click(Sender: TObject);
var
  od:TOPenDialog;
begin
  OD := TOpenDialog.create(self);
  od.InitialDir := 'd:\';
  od.Filter := '텍스트파일|*.txt|유니트파일|*.pas|프로젝트파일|*.dpr';
  caption := inttostr(componentcount);
  if od.Execute then
     caption := od.FileName;

  od.Free;
end;

procedure TForm1.Button12Click(Sender: TObject);
var
  Fd:TFontDialog;
begin
  Fd := TFontDialog.Create(self);
  Caption := IntToStr(ComponentCount);
  if Fd.Execute then
     Font := Fd.Font;
  Fd.Free;
end;

procedure TForm1.Button13Click(Sender: TObject);
var
  i:word;
begin
//   for I := 0 to application.ComponentCount - 1 do
//     if Application.Components[i] is TForm2 then
//     begin
//        (Application.Components[i] as TForm).Show;
//        if (Application.Components[i] as TForm).WindowState = wsMinimized then
//           (Application.Components[i] as TForm).WindowState := wsNormal;
//        exit;
//     end;
//   Form2 := TForm2.create(application);
   Tform(Form2) := (ShowOnce(tForm2));
   Form2.ManualDock(panel1);
end;

Procedure TForm1.Button14Click(Sender: TObject);
begin
  Form3 := TForm3.Create(Application);
  caption := inttostr(application.ComponentCount);
  if Form3.ShowModal = mrok then
     showmessage(DateToStr(form3.DatePicker1.date));
  form3.free;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  MyButton.Caption :=  '닫기';
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
   ShowMessage('my process');
   Button1Click(Button1);
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
   Button4.Caption := IntToStr(i);
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  Hellow;
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
  Button6.Caption := IntToStr(Add(7,2));
end;

procedure TForm1.Button7Click(Sender: TObject);
begin
  Button7.Caption := IntToStr(Divide(12,3));
end;

procedure TForm1.Button8Click(Sender: TObject);
begin
  if h = nil then
     h := Th.Create;

  Edit1.Text := h.GetName;
  Edit2.Text := IntToStr(h.Age);
  Edit3.Text := h.Address;
  Edit4.Text := H.Office;
  Edit5.Text := IntToStr(h.Salary);
//  h.Free;
  FreeAndNil(h);
end;

procedure TForm1.Button9Click(Sender: TObject);
begin
   Test_btn := Tbutton.Create(self);
   Caption := IntToStr(ComponentCount);
   Test_btn.Parent := self;
   Test_btn.Left := Button9.Left;
   Test_btn.Top := Button9.Top + Button9.Height + 16;
   Test_btn.Caption := 'test';
   Test_btn.SetFocus;
   Test_btn.OnClick := TestHandler;
//   test_btn.OnClick := nil;
end;

procedure TForm1.Edit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if sender = Edit7 then
  begin
     Edit1.SetFocus;
     exit;
  end;

  case key of
     vk_return: SelectNext(sender as Twincontrol, true, true);
     vk_up: SelectNext(sender as Twincontrol, false, true);
     vk_down:SelectNext(sender as Twincontrol, true, true);
  end;
end;

procedure TForm1.Edit2KeyPress(Sender: TObject; var Key: Char);
begin
   if not (key in ['0'..'9', #8])then
      key := #0;

end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  caption := inttostr(ComponentCount);
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if Edit1.text <> '' then
  begin
    ShowMessagE('이름값 지우시고 종료하십시오');
    Canclose := false;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Scaled := True;
  if (Screen.Width <> ScreenWidth) then
  begin
    Height := LongInt(Height) * LongInt(Screen.Height) DIV ScreenHeight;
    Width := LongInt(Width) * LongInt(Screen.Width) DIV ScreenWidth;
    ScaleBy(Screen.Width, ScreenWidth);
  end;

  Button8Click(button8);
//  SetWindowLong(Edit5.Handle,GWL_STYLE,GetWindowLong(Edit1.Handle,GWL_STYLE) or ES_NUMBER);

end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if Activecontrol = Edit7 then
  begin
     Edit1.SetFocus;
     exit;
  end;

  case key of
     vk_return: SelectNext(activecontrol, true, true);
     vk_up: SelectNext(activecontrol, false, true);
     vk_down:SelectNext(activecontrol, true, true);
  end;
end;

procedure TForm1.MyButtonClick(Sender: TObject);
begin
  if sender = button2 then
     showmessage('button2');
  Close;
end;

function TForm1.ShowOnce(AFormClass: TFormClass; AShowing: Boolean): TForm;
var
   i : integer;
begin
   Result := nil;

   for i := 0 to Application.ComponentCount -1 do
     if Application.components[i] is AFormClass then
        Result := Application.components[i] as TForm;

   if not assigned(Result) then
      Result := AFormClass.Create(Application);

   if aShowing then
      Result.Show;
end;

procedure TForm1.TestHandler(Sender: Tobject);
begin
  ShowMessage('test');
end;

end.
