unit uTest1;

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
    GroupBox1: TGroupBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Button9: TButton;
    Button10: TButton;
    Button11: TButton;
    Button12: TButton;
    FontDialog1: TFontDialog;
    Button13: TButton;
    Button14: TButton;
    Panel1: TPanel;
    Button15: TButton;
    procedure FormActivate(Sender: TObject);
    procedure MyButtonClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Edit2KeyPress(Sender: TObject; var Key: Char);
    procedure Button15Click(Sender: TObject);
    procedure Edit1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    procedure TestHandler(sender:tobject);
    function ShowOnce( AFormClass:TFormClass;AShowing:Boolean=True):TForm;

    { Private declarations }
  public

    { Public declarations }
  end;
const
  screenwidth = 1920;
  screenheight =  1080;
var
  Form1: TForm1;

implementation
{$R *.dfm}
uses utest4, utest2, utest3;
var
  h:th;
  test_btn:tbutton;

procedure TForm1.Button10Click(Sender: TObject);
begin
  if test_btn <> nil then
     TEST_BTN.Free;

  CAPTION := inttostr(componentcount);
end;

procedure TForm1.Button11Click(Sender: TObject);
begin
  if FontDialog1.execute then
     Font := Fontdialog1.Font;

end;

procedure TForm1.Button12Click(Sender: TObject);
var
  cd:TColorDialog;
begin
   cd := TColorDialog.create(self);
   caption := inttostr(Componentcount);
   if cd.Execute then
      Color := cd.Color;
   cd.Free;
   caption := inttostr(Componentcount);
end;

procedure TForm1.Button13Click(Sender: TObject);
var
  i:byte;
begin
//   for I := 0 to application.ComponentCount - 1 do
//     if Application.Components[i] is TForm2 then
//     begin
//       (Application.Components[i] as Tform).Show;
//       if (Application.Components[i] as tform).WindowState = wsMinimized then
//           (Application.Components[i] as tform).WindowState := wsNormal;
//       exit;
//     end;

 //   Form2 := TForm2.Create(application);
 //   caption := inttostr(application.ComponentCount);
 //   Form2.Show;
    Tform(Form2) := (ShowOnce(TForm2));
    caption := inttostr(application.ComponentCount);
    form2.ManualDock(panel1);
end;

procedure TForm1.Button14Click(Sender: TObject);
begin
  form3 := TForm3.create(application);
  caption := inttostr(application.ComponentCount);
  if form3.showmodal = mrYes then
     caption := DateTostr(form3.DateTimePicker1.Date);
  form3.Free;
//  caption := inttostr(application.ComponentCount);
end;

procedure TForm1.Button15Click(Sender: TObject);
var
  ARect: TRect;
begin
  if panel1.DockClientCount = 1 then
  begin
    with panel1.DockClients[0] do
    begin
      ARect.TopLeft := panel1.ClientToScreen(Point(0, 0));
      ARect.BottomRight := panel1.ClientToScreen(Point(form2.UndockWidth, form2.UndockHeight));
      form2.ManualFloat(ARect);
    end;
end;
end;
procedure TForm1.Button1Click(Sender: TObject);
begin
  if sender = button3 then
     showmessage('button3 clicked');

   MyButton.Caption := '닫기';
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
   showmessage('my process');
   Button1Click(sender);
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
    Button4.Caption := countries[0]; //inttostr(i);
// inttostr strtoint strtofloat strtodate
// p:pchar
// s:string
// s := strpas(p) , strpcopy(p,s)
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  hello;
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
   Button6.Caption := IntToStr(Add(3,7));
end;

procedure TForm1.Button7Click(Sender: TObject);
begin
  button7.Caption := floattostr(Divide(10.0,2.0));
end;

procedure TForm1.Button8Click(Sender: TObject);
begin
  th.etc  := '기타';
  if h = nil then
     h := th.create;

  Edit1.Text := h.Name;
  Edit2.Text := inttostr(h.Age);
  Edit3.Text := h.Address;
  Edit4.Text := h.Company;
  Edit5.Text := inttostr(h.salary);
  Edit6.text := h.etc;
  freeAndNil(h);  //해제 ,널처리
//  h.Free;   // 메모리해제 인스턴스 널 처리 안함
end;

procedure TForm1.Button9Click(Sender: TObject);
begin
   test_btn := tbutton.Create(self);
   caption := inttostr(componentcount);
   test_btn.Parent := self;
   test_btn.Left := button9.Left;
   test_Btn.top := button9.Top + button9.Height + 16;
   test_Btn.Width := button9.Width;
   test_btn.Caption := 'test';
   test_btn.SetFocus;
   test_btn.OnClick := testHandler;
 //  test_btn.OnClick := nil;
end;

procedure TForm1.Edit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (sender = Edit8) and ( key in [vk_return, vk_down]) then
  begin
     Edit1.SetFocus;
     exit;
  end;

  case key of
     vk_return: selectNext(sender as twincontrol,true,true);
     vk_up: selectNext(sender as twincontrol,false,true);
     vk_down: selectNext(sender as twincontrol,true,true);
  end;
end;

procedure TForm1.Edit2KeyPress(Sender: TObject; var Key: Char);
const
  bksp = #08;
begin
  if not (key in ['0' .. '9',bksp]) then
     key := #0;

end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  caption := inttostr(componentcount);
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
   if Edit7.Text <> '' then
   begin
     ShowMessage('edit7 데이터 지우시고 종료하십시오');
     CanClose := false;
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
  SetWindowLong(Edit8.Handle,GWL_STYLE,GetWindowLong(Edit8.Handle,GWL_STYLE) or ES_NUMBER);
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (activecontrol = Edit8) and ( key in [vk_return, vk_down]) then
  begin
     Edit1.SetFocus;
     exit;
  end;

  case key of
     vk_return: selectNext(activecontrol,true,true);
     vk_up: selectNext(activecontrol,false,true);
     vk_down: selectNext(activecontrol,true,true);
  end;
end;

procedure TForm1.MyButtonClick(Sender: TObject);
begin
   if  sender = MyButton then
       close
   else
       showmessage('다른 버튼은 종료 안되요');
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

procedure TForm1.TestHandler(sender: tobject);
begin
   showmessage('test');
end;

end.
