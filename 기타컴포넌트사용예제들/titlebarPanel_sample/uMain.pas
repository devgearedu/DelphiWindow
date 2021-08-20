unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Touch.GestureMgr,
  System.Win.TaskbarCore, Vcl.Taskbar, Vcl.JumpList, Vcl.ExtCtrls, Vcl.Menus,
  Vcl.StdActns, Vcl.ExtActns, Vcl.ActnList, System.Actions,
  Vcl.RibbonSilverStyleActnCtrls, Vcl.ActnMan, System.ImageList, Vcl.ImgList,
  Vcl.StdCtrls, Vcl.ComCtrls, Vcl.CategoryButtons, Vcl.ButtonGroup, Vcl.ToolWin,
  Vcl.ActnCtrls, Vcl.ActnMenus, Vcl.TitleBarCtrls;

type
  TForm1 = class(TForm)
    TitleBarPanel1: TTitleBarPanel;
    ActionMainMenuBar1: TActionMainMenuBar;
    ImageList1: TImageList;
    ImageList2: TImageList;
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
    Action1: TAction;
    Action2: TAction;
    Action3: TAction;
    AboutForm_Action: TAction;
    PopupMenu1: TPopupMenu;
    New1: TMenuItem;
    Open1: TMenuItem;
    SaveAs1: TMenuItem;
    N1: TMenuItem;
    About1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    Exit1: TMenuItem;
    Timer1: TTimer;
    JumpList1: TJumpList;
    Taskbar1: TTaskbar;
    GestureManager1: TGestureManager;
    StatusBar1: TStatusBar;
    GridPanel1: TGridPanel;
    CategoryPanelGroup1: TCategoryPanelGroup;
    CategoryPanel4: TCategoryPanel;
    ListView1: TListView;
    CategoryPanel3: TCategoryPanel;
    TreeView1: TTreeView;
    CategoryPanel2: TCategoryPanel;
    ButtonGroup1: TButtonGroup;
    CategoryPanel1: TCategoryPanel;
    CategoryButtons1: TCategoryButtons;
    RichEdit1: TRichEdit;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    ToolBar32: TToolBar;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    procedure TitleBarPanel1CustomButtons0Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.TitleBarPanel1CustomButtons0Click(Sender: TObject);
begin
   showmessage('커스텀 버튼입니다');
end;

end.
