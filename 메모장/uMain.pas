unit uMain;

interface

uses
  winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Ribbon, Vcl.ActnMenus,
  Vcl.RibbonActnMenus, Vcl.StdCtrls, Vcl.RibbonActnCtrls, Vcl.ToolWin,
  Vcl.ActnMan, Vcl.ActnCtrls, Vcl.StdActns, Vcl.ExtActns, Vcl.ActnList,
  System.Actions, Vcl.RibbonLunaStyleActnCtrls, System.ImageList, Vcl.ImgList,
  Vcl.RibbonSilverStyleActnCtrls, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.Menus,
  Vcl.Touch.GestureMgr, System.Win.TaskbarCore, Vcl.Taskbar, Vcl.JumpList,
  Vcl.CategoryButtons, Vcl.ButtonGroup, Vcl.Themes, System.Win.ComObj,System.Win.ScktComp;

type
  TAboutProc =  procedure; stdcall;
  TcalcFunc<t> = function(x,y:t):t; stdcall;

  { TTreeView }

  TMainForm = class(TForm)
    ImageList1: TImageList;
    ActionManager1: TActionManager;
    FileOpen1: TFileOpen;
    FileSaveAs1: TFileSaveAs;
    FileExit1: TFileExit;
    EditCut1: TEditCut;
    EditCopy1: TEditCopy;
    EditPaste1: TEditPaste;
    EditSelectAll1: TEditSelectAll;
    EditUndo1: TEditUndo;
    EditDelete1: TEditDelete;
    FormatRichEditBold1: TRichEditBold;
    FormatRichEditItalic1: TRichEditItalic;
    FormatRichEditUnderline1: TRichEditUnderline;
    FormatRichEditAlignLeft1: TRichEditAlignLeft;
    FormatRichEditAlignRight1: TRichEditAlignRight;
    FormatRichEditAlignCenter1: TRichEditAlignCenter;
    SearchFind1: TSearchFind;
    SearchFindNext1: TSearchFindNext;
    SearchReplace1: TSearchReplace;
    SearchFindFirst1: TSearchFindFirst;
    New_Action: TAction;
    About_Action: TAction;
    Top_Action: TAction;
    Window_Action: TAction;
    Silver_Action: TAction;
    Auric_Action: TAction;
    Ribbon1: TRibbon;
    RibbonPage1: TRibbonPage;
    RibbonPage2: TRibbonPage;
    RibbonGroup1: TRibbonGroup;
    RibbonGroup2: TRibbonGroup;
    RibbonGroup3: TRibbonGroup;
    RibbonGroup4: TRibbonGroup;
    RibbonGroup5: TRibbonGroup;
    RibbonGroup6: TRibbonGroup;
    RibbonGroup7: TRibbonGroup;
    RibbonSpinEdit1: TRibbonSpinEdit;
    RibbonApplicationMenuBar1: TRibbonApplicationMenuBar;
    RibbonQuickAccessToolbar1: TRibbonQuickAccessToolbar;
    StatusBar1: TStatusBar;
    GridPanel1: TGridPanel;
    CategoryPanelGroup1: TCategoryPanelGroup;
    RichEdit1: TRichEdit;
    PopupMenu1: TPopupMenu;
    New1: TMenuItem;
    Open1: TMenuItem;
    SaveAs1: TMenuItem;
    N1: TMenuItem;
    About1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    Exit1: TMenuItem;
    TrayIcon1: TTrayIcon;
    JumpList1: TJumpList;
    Taskbar1: TTaskbar;
    Timer1: TTimer;
    GestureManager1: TGestureManager;
    CategoryPanel1: TCategoryPanel;
    CategoryPanel2: TCategoryPanel;
    CategoryPanel3: TCategoryPanel;
    CategoryPanel4: TCategoryPanel;
    CategoryButtons1: TCategoryButtons;
    ButtonGroup1: TButtonGroup;
    TreeView1: TTreeView;
    Action1: TAction;
    Action2: TAction;
    Action3: TAction;
    ImageList2: TImageList;
    RibbonGroup12: TRibbonGroup;
    ComboBox1: TComboBox;
    AboutForm_Action: TAction;
    ListView1: TListView;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure RibbonSpinEdit1Change(Sender: TObject);
    procedure New_ActionExecute(Sender: TObject);
    procedure Window_ActionExecute(Sender: TObject);
    procedure Silver_ActionExecute(Sender: TObject);
    procedure Auric_ActionExecute(Sender: TObject);
    procedure Top_ActionExecute(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure RichEdit1Gesture(Sender: TObject;
      const EventInfo: TGestureEventInfo; var Handled: Boolean);
    procedure ShowHint(Sender:Tobject);
    procedure FileOpen1BeforeExecute(Sender: TObject);
    procedure FileOpen1Accept(Sender: TObject);
    procedure FileSaveAs1BeforeExecute(Sender: TObject);
    procedure FileSaveAs1Accept(Sender: TObject);
    procedure About_ActionExecute(Sender: TObject);
    procedure RichEdit1Change(Sender: TObject);
    procedure ExceptionHandler(sender:TObject; e:exception);
    procedure TreeView1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Action1Execute(Sender: TObject);
    procedure Action2Execute(Sender: TObject);
    procedure Action3Execute(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure AboutForm_ActionExecute(Sender: TObject);
  private
    function GetCurrPos(RichEdit:TRichEdit):integer;
    function GetCurrLine(RichEdit:TRichEdit):integer;
    { Private declarations }
  public
    { Public decfunctiolarations }
  end;

var
  MainForm: TMainForm;

implementation

uses uListUp_DLL, uAbout;
type
  Delphi_Curri = record
    Instructor:string;
    Version:string;
    Cnt:integer;
  end;
  P_Delphi_Curri = ^Delphi_Curri;

  TMyListItem = class(TListColumn)
  public
    MyData: String;
  end;


var
  t:TTreeNode;
  Item:TListItem;
  p:P_Delphi_Curri;
  h:THandle;
  AboutProc:TAboutProc;
  AddFunc:TcalcFunc<integer>;
  DivFunc:TcalcFunc<real>;
  FilePath:string;

procedure Display_About; stdcall;
external 'PAboutBox.dll' delayed;

function Add(x,y:integer):integer; stdcall;
external 'PAboutBox.dll' delayed;

{$R *.dfm}

procedure TMainForm.AboutForm_ActionExecute(Sender: TObject);
begin
  AboutBox := TAboutBox.create(Application);
  try
    AboutBox.ShowModal;
  finally
    AboutBox.Free;
  end;
end;

procedure TMainForm.About_ActionExecute(Sender: TObject);
begin
    Display_About;
end;

procedure TMainForm.Action1Execute(Sender: TObject);
begin

     h := LoadLibrary('PAboutbox.dll');
     if h < 32  then
        raise Exception.Create('그런 라이브러리 없음 이름과 패쓰 확인');

     AboutProc := GetProcAddress(h, 'Display_About');
     AboutProc;

//     Addfunc := GetProcAddress(h, 'Add');
//     showmessage(inttostr(Addfunc(10,2)));

//     DivFunc := GetProcAddress(h, 'Divide');
//     ShowMessage(floattostr(DivFunc(12,3)));

     FreeLibrary(h);
end;

procedure TMainForm.Action2Execute(Sender: TObject);
var
  PackageModule: HModule;
  AClass: TPersistentClass;
begin
  PackageModule := LoadPackage('FormLoad.bpl');
  if PackageModule <> 0 then
  begin
    AClass := GetClass('TAboutBox');

    if AClass <> nil then
      with TComponentClass(AClass).Create(Application)
        as TCustomForm do
      begin
        ShowModal;
        Free;
      end;

    UnloadPackage(PackageModule);
  end;
end;

procedure TMainForm.Action3Execute(Sender: TObject);
begin
  DllLoadForm := TDllLoadForm.create(Application);
  DllLoadForm.Show;
end;

procedure TMainForm.Auric_ActionExecute(Sender: TObject);
begin
  TStyleManager.TrySetStyle('Auric');
end;

procedure TMainForm.ComboBox1Change(Sender: TObject);
begin
  TStyleManager.SetStyle(Combobox1.Text);
end;

procedure TMainForm.ExceptionHandler(sender: TObject; e: exception);
begin
  if e is EFopenError then
    ShowMessage('파일명이 틀립니다. 패스와 이름확인하십시오')
  else if e is EWriteError then
     ShowMessage('파일 저정 오류')
  else if e is EReadError then
     ShowMessage('파일 읽기 오류')
  else if e is EoutOfMemory then
     ShowMessage('메모리부족')
  else if E is EconvertError then
     ShowMessage('형변환 오류')
  else if e is eInvalidCast then
     ShowMessagE('as 연산자 오류')
  else if e is eOleError then
     showmessage('ms office 오류')
  else if e is EsocketError then
     showmessage('소켓 통신 오류')
  else if e is EintError then
     ShowMessage('정수형 오류')
  else if e is EMathError then
     ShowMessage('실수형 오류')
  else if e is eInvalidPointer then
     ShowMessage('포인터 오류')
  else if e is einouterror then
     ShowMessage('입출력장치 오류')
  else if e is EaccessViolation  then
     ShowMessage('억세스 오류 인스턴스 확인')
  else if e is ElistError then
      ShowMessagE('첨자 순서 오류')
  else Application.ShowException(e);


end;

procedure TMainForm.FileOpen1Accept(Sender: TObject);
begin
  try
     RichEdit1.Lines.LoadFromFile(FileOpen1.Dialog.FileName);
  except
     on eFopenError do
        Showmessage('파일명이 틀립니다');
     on eOutofResources do
        ShowMessage('사이즈가 너무 큽니다')
  end;
  Ribbon1.AddRecentItem(FileOpen1.Dialog.FileName);
end;

procedure TMainForm.FileOpen1BeforeExecute(Sender: TObject);
begin
   FileOpen1.Dialog.InitialDir := FilePath;
   FileOpen1.Dialog.Filter :=
   '프로젝트파일|*.dpr|유니트파일|*.pas|텍스트파일|*.txt';
end;

procedure TMainForm.FileSaveAs1Accept(Sender: TObject);
begin
   try
     RichEdit1.Lines.SaveToFile(FileSaveAs1.Dialog.FileName);
   except
     on e:Exception do
        ShowMessage(e.Message);
   end;
end;

procedure TMainForm.FileSaveAs1BeforeExecute(Sender: TObject);
begin
  FileSaveAs1.Dialog.InitialDir := FilePath;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i:byte;
begin
  for I := 0 to Treeview1.Items.Count - 1 do
    if Treeview1.Items[i].Data <> nil then
       Dispose(P_Delphi_Curri(Treeview1.Items[i].Data));

end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if RichEdit1.Lines.Text <> '' then
  begin
    Showmessage('메모장 지우시고 종료하십시오');
    CanClose := false;
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
type
  PListColumnClass = ^TCollectionItemClass;
var
  ItemClass: PListColumnClass;
  ListColumn: TListColumn;
  StyleName: string;
  Filename: string;
  jumpItem: TJumpListItem;
  CategoryIndex:integer;
begin
  t := ttreeNode.Create(TreeView1.Items);
  TreeView1.Selected := TreeView1.Items.Add(t,'교육부');
  TreeView1.Items.AddChild(treeview1.Selected, '자바');
  new(p);
  p^.Instructor := '김원경';
  p^.Version := '리우 10.4.1';
  p^.Cnt := 6;

  TreeView1.Items.AddChildObject(TreeView1.Selected,'델파이', p);
  TreeView1.FullExpand;

  FilePath := ExtractFilePath(Application.ExeName);
  FileName :=
  'D:\델파이교육소스\윈도우프로그래밍\리본컨트롤자동생성(액션포함)\Win32\Debug\test.exe';
//Jump list 동적생성 경로는 수정해서 사용하십시오 !!!!
  CategoryIndex := JumpList1.AddCategory('MyCategory');
  JumpList1.AddItemToCategory(CategoryIndex,
  'MyItem',FileName, '','');

  jumpItem := JumpList1.TaskList.add as TJumpListItem;
  jumpItem.FriendlyName := '테스트프로그램2';
  jumpItem.path := Filename;
  JumpList1.UpdateList;

 for StyleName in TStyleManager.StyleNames do
    Combobox1.Items.Add(StyleName);

  Combobox1.ItemIndex := Combobox1.Items.IndexOf(TStyleManager.ActiveStyle.Name);
  ItemClass := @ListView1.Columns.ItemClass;
  ItemClass^ := TMyListItem;

  RibbonSpinEdit1.Value := RichEdit1.Font.Size;
  Application.OnHint := ShowHint;
  Application.OnException := ExceptionHandler;
  //treeNode 동적으로 생성하는 방법
  t := ttreeNode.Create(TreeView1.Items);
  TreeView1.Selected := TreeView1.Items.Add(t,'교육부');
  TreeView1.Items.AddChild(treeview1.Selected, '자바');
  new(p);
  p^.Instructor := '김원경';
  p^.Version := '리우 10.3.1';
  p^.Cnt := 6;

  TreeView1.Items.AddChildObject(TreeView1.Selected,'델파이', p);
  TreeView1.FullExpand;
  //리스뷰의 컬럼 동적으로 추가하는 방법
  ListColumn := ListView1.Columns.Add;
  ListColumn.Caption := '기타정보';
  ListColumn.Width := 200;
  TMyListItem(ListColumn).MyData := '데스트데이터';

  // Caption := ListColumn.ClassName; :TmyListItem
  ListView1.Items[0].SubItems.Add(TMyListItem(ListView1.Columns[3]).MyData );
end;

function TMainForm.GetCurrLine(RichEdit: TRichEdit): integer;
begin
  result := RichEdit.Perform(EM_LINEFROMCHAR,richEdit.SelStart,0);
end;

function TMainForm.GetCurrPos(RichEdit: TRichEdit): integer;
begin
  result := RichEdit.SelStart - RichEdit.Perform(EM_LINEINDEX,GetcurrLine(RichEdit),0);

end;

procedure TMainForm.New_ActionExecute(Sender: TObject);
begin
   RichEdit1.Clear;
end;

procedure TMainForm.RibbonSpinEdit1Change(Sender: TObject);
begin
  RichEdit1.Font.Size := RibbonSpinEdit1.value;
end;

procedure TMainForm.RichEdit1Change(Sender: TObject);
begin
  statusbar1.Panels[1].Text :=
  Format('현재컬럼:%d 현재라인수:%d', [GetcurrPos(RichEdit1)+1,
  GetCurrLine(Richedit1)+1]);
end;

procedure TMainForm.RichEdit1Gesture(Sender: TObject;
  const EventInfo: TGestureEventInfo; var Handled: Boolean);
begin
  case EventInfo.GestureID of
     sgiCircle:Showmessage('원');
     sgiSquare:Showmessage('사각형');
     sgiTriAngle:Showmessage('삼각형');
  end;
end;

procedure TMainForm.ShowHint(Sender: Tobject);
begin
  StatusBar1.Panels[0].Text := Application.Hint;
//Application.hintpause
end;

procedure TMainForm.Silver_ActionExecute(Sender: TObject);
begin
  TStyleManager.TrySetStyle('auric');
end;

procedure TMainForm.Timer1Timer(Sender: TObject);
begin
   StatusBar1.Panels[2].Text :=
   FormatDateTime('yyyy-mmmm-dd dddd hh:nn:ss ampm',now);
// FormatFlaot('#,##0.00', i);
// Format('현재수 =%d , 총수 =%d',[i,j])
end;

procedure TMainForm.Top_ActionExecute(Sender: TObject);
begin
   Top_Action.Checked := not Top_Action.Checked;
   if Top_Action.Checked then
      FormStyle := fsStayOnTop
   else
      FormStyle := fsNormal;
end;


procedure TMainForm.TreeView1Click(Sender: TObject);
begin
  if TreeView1.Selected.Data <> nil then
  begin
     Item := listview1.Items.Add;
     Item.Caption := P_Delphi_Curri(TreeView1.Selected.Data)^.Instructor;
     Item.SubItems.Add(P_Delphi_Curri(TreeView1.Selected.Data)^.Version);
     Item.SubItems.Add(IntToStr(P_Delphi_Curri(TreeView1.Selected.Data)^.Cnt));
  end;
end;


procedure TMainForm.Window_ActionExecute(Sender: TObject);
begin
   TStyleManager.TrySetStyle('windows');
end;
end.
