unit Main_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ActnList, Buttons, CheckLst, Menus, ToolWin, ComCtrls, ImgList,
  SearchClasses, FileLists;

type

{ TMemoSheet }

  TMemoSheet = class(TTabSheet)
    Memo: TMemo;
  public
    constructor Create(AOwner: TComponent); override;
    procedure SetFocus; override;
  end;

{ TListViewSheet }

  TListViewSheet = class(TTabSheet)
    ListView: TListView;
    FileList: TFileList;
  private
    procedure ListViewData(Sender: TObject; Item: TListItem);
    procedure ListViewKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ListViewDblClick(Sender: TObject);
    procedure FileListChange(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetFocus; override;
    procedure CopyToClipboard;
    procedure Execute;
  end;

{ TMain_Form  }

  TMain_Form = class(TForm)
    Action_Abort: TAction;
    Action_AddPath: TAction;
    Action_Close: TAction;
    Action_CloseListBox: TAction;
    Action_DeletePath: TAction;
    Action_New: TAction;
    Action_Open: TAction;
    Action_Run: TAction;
    Action_Save: TAction;
    ActionList: TActionList;
    Button_Abort: TToolButton;
    Button_Close: TToolButton;
    Button_CloseListBox: TToolButton;
    Button_New: TToolButton;
    Button_Open: TToolButton;
    Button_Save: TToolButton;
    Button_Search: TToolButton;
    Button_Separator1: TToolButton;
    CoolBar_PathsToolbar: TCoolBar;
    ToolBar: TToolBar;
    ImageList: TImageList;
    ImageList_Disabled: TImageList;
    ListBox_Paths: TCheckListBox;
    Menu_AccessDate: TMenuItem;
    Menu_AccessDateTime: TMenuItem;
    Menu_AccessTime: TMenuItem;
    Menu_Archive: TMenuItem;
    Menu_Compressed: TMenuItem;
    Menu_Copy: TMenuItem;
    Menu_CreatDateTime: TMenuItem;
    Menu_CreateDate: TMenuItem;
    Menu_CreateTime: TMenuItem;
    Menu_Date: TMenuItem;
    Menu_DateTime: TMenuItem;
    Menu_Directory: TMenuItem;
    Menu_DirName: TMenuItem;
    Menu_Drive: TMenuItem;
    Menu_Ext: TMenuItem;
    Menu_FileName: TMenuItem;
    Menu_Folder: TMenuItem;
    Menu_FullName: TMenuItem;
    Menu_Hidden: TMenuItem;
    Menu_ModifyDate: TMenuItem;
    Menu_ModifyDateTime: TMenuItem;
    Menu_ModifyTime: TMenuItem;
    Menu_Name: TMenuItem;
    Menu_Offline: TMenuItem;
    Menu_OpenToExplorer: TMenuItem;
    Menu_Path: TMenuItem;
    Menu_Readonly: TMenuItem;
    Menu_SearchFormulaCopy: TMenuItem;
    Menu_SearchFormulaCut: TMenuItem;
    Menu_SearchFormulaDelete: TMenuItem;
    Menu_SearchFormulaPaste: TMenuItem;
    Menu_SearchFormulaSelectAll: TMenuItem;
    Menu_SearchFormulaUndo: TMenuItem;
    Menu_Size: TMenuItem;
    Menu_Split1: TMenuItem;
    Menu_Split2: TMenuItem;
    Menu_Stream: TMenuItem;
    Menu_System: TMenuItem;
    Menu_Temporary: TMenuItem;
    Menu_Time: TMenuItem;
    Menu_Type: TMenuItem;
    OpenDialog: TOpenDialog;
    PageControl_ListBox: TPageControl;
    PageControl_Memo: TPageControl;
    Panel_SearchFormula: TPanel;
    PopupMenu_ListView: TPopupMenu;
    PopupMenu_SearchFormula: TPopupMenu;
    SaveDialog: TSaveDialog;
    Splitter_Paths: TSplitter;
    Splitter_SearchFormula: TSplitter;
    StatusBar: TStatusBar;
    Menu_Hint1: TMenuItem;
    Menu_Hint2: TMenuItem;
    Menu_Blank: TMenuItem;
    Button_DeletePath: TToolButton;
    Button_AddPath: TToolButton;
    ToolButton1: TToolButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    PaintBox1: TPaintBox;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Action_AbortExecute(Sender: TObject);
    procedure Action_NewExecute(Sender: TObject);
    procedure Action_OpenExecute(Sender: TObject);
    procedure Action_RunExecute(Sender: TObject);
    procedure Action_SaveExecute(Sender: TObject);
    procedure Action_AddPathClick(Sender: TObject);
    procedure Action_DeletePathClick(Sender: TObject);
    procedure Action_CloseExecute(Sender: TObject);
    procedure Action_CloseListBoxExecute(Sender: TObject);
    procedure Menu_AttributesClick(Sender: TObject);
    procedure Menu_CopyClick(Sender: TObject);
    procedure Menu_OpenToExplorerClick(Sender: TObject);
    procedure Menu_SearchFormulaUndoClick(Sender: TObject);
    procedure Menu_SearchFormulaCutClick(Sender: TObject);
    procedure Menu_SearchFormulaCopyClick(Sender: TObject);
    procedure Menu_SearchFormulaPasteClick(Sender: TObject);
    procedure Menu_SearchFormulaDeleteClick(Sender: TObject);
    procedure Menu_SearchFormulaSelectAllClick(Sender: TObject);
    procedure PopupMenu_ListViewPopup(Sender: TObject);
    procedure PopupMenu_SearchFormulaPopup(Sender: TObject);
    procedure Splitter_CanResize(Sender: TObject; var NewSize: Integer; var Accept: Boolean);
  private
    FileSearch: TFileSearch;
    function ActivateMemo: TMemo;
    function ActiveListViewSheet: TListViewSheet;
  public
  end;

var
  Main_Form: TMain_Form;

implementation

uses
  FileCtrl, ClipBrd, IniFiles, ShellAPI;

{$R *.dfm}
{$R WindowsXP.res}

{ TMemoSheet }

constructor TMemoSheet.Create(AOwner: TComponent);
begin
  inherited Create( AOwner );

  Memo := TMemo.Create( Self );
  Memo.Color := clBlack;
  Memo.Font.Name := '굴림';
  Memo.Font.Size := 14;
  Memo.Font.Color := clSilver;
  Memo.Font.Style := [fsBold];
  Memo.ScrollBars := ssVertical;
  Memo.Parent := Self;
  Memo.Align := alClient;
end;

procedure TMemoSheet.SetFocus;
begin
  Memo.SetFocus;
end;

{ TListViewSheet }

constructor TListViewSheet.Create(AOwner: TComponent);
var
  SHFileInfo: TSHFileInfo;
begin
  inherited Create( AOwner );

  ListView := TListView.Create( Self );
  ListView.Align := alClient;
  ListView.Font.Name := 'Tahoma';
  ListView.Font.Size := 9;
  ListView.OwnerData := True;
  ListView.RowSelect := True;
  ListView.Parent := Self;
  ListView.ViewStyle := vsReport;
  ListView.OnData := ListViewData;
  ListView.OnDblClick := ListViewDblClick;
  ListView.OnKeyDown := ListViewKeyDown;
  ListView.SmallImages := TImageList.Create( ListView );
  ListView.SmallImages.Handle := SHGetFileInfo( '', 0, SHFileInfo, SizeOf(SHFileInfo), SHGFI_SYSICONINDEX or SHGFI_SMALLICON );
  if ListView.SmallImages.Handle <> 0 then
   ListView.SmallImages.ShareImages := True;

  with ListView.Columns.Add do
   begin
     Caption := '파일 명';
     Width := 200;
   end;

  with ListView.Columns.Add do
   begin
     Caption := '크기';
     Alignment := taRightJustify;
     Width := 100;
   end;

  with ListView.Columns.Add do
   begin
     Caption := '종류';
     Width := 150;
   end;

  with ListView.Columns.Add do
   begin
     Caption := '수정한 날짜';
     Width := 150;
   end;

  with ListView.Columns.Add do
   begin
     Caption := '경로';
     Width := 500;
   end;

  FileList := TFileList.Create;
  FileList.OnChange := FileListChange;
end;

destructor TListViewSheet.Destroy;
begin
  FileList.OnChange := nil;
  FileList.Free;

  inherited Destroy;
end;

procedure TListViewSheet.ListViewData(Sender: TObject; Item: TListItem);
var
  Index: Integer;
begin
  Index := Item.Index;
  FileList.MakeShellInfo( Index );

  Item.Caption := FileList[ Index ].Name;
  Item.ImageIndex := FileList[ Index ].ShellInfo.ImageIndex;
  Item.SubItems.Clear;
  Item.SubItems.Add( FileList[ Index ].ShellInfo.FileSize );
  Item.SubItems.Add( FileList[ Index ].ShellInfo.FileType );
  Item.SubItems.Add( FileList[ Index ].ShellInfo.FileDate );
  Item.SubItems.Add( FileList[ Index ].Path );
end;

procedure TListViewSheet.ListViewKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
  VK_DELETE: if TListView(Sender).ItemIndex >= 0 then
              FileList.Delete( TListView(Sender).ItemIndex );
  Byte('C'): CopyToClipboard;
  end;
end;

procedure TListViewSheet.ListViewDblClick(Sender: TObject);
begin
  Execute;
end;

procedure TListViewSheet.FileListChange(Sender: TObject);
begin
  ListView.Items.Count := TFileList(Sender).Count;
end;

procedure TListViewSheet.SetFocus;
begin
  ListView.SetFocus;
end;

procedure TListViewSheet.CopyToClipboard;
begin
  if ListView.ItemIndex >= 0 then
   Clipboard.AsText := FileList.GetText( ListView.ItemIndex );
end;

procedure TListViewSheet.Execute;
var
  FileName: String;
begin
  if ListView.ItemIndex >= 0 then
   begin
     FileName := FileList[ ListView.ItemIndex ].Path + FileList[ ListView.ItemIndex ].Name;
     if FileExists( FileName ) or DirectoryExists( FileName ) then
      WinExec( pansichar('explorer /select, "' + FileName + '"'), SW_NORMAL );
   end;
end;

{ TMain_Form }

procedure TMain_Form.FormCreate(Sender: TObject);
var
  Drive: Char;
  i, Index: Integer;
  S: String;
begin
  with TIniFile.Create( 'FSFormula.ini' ) do
   try
     Left := ReadInteger( 'Window', 'Left', ( Screen.Width - Width ) div 2 );
     Top := ReadInteger( 'Window', 'Top', ( Screen.Height - Height ) div 2 );
     Width := ReadInteger( 'Window', 'Width', Width );
     Height := ReadInteger( 'Window', 'Height', Height );
     Panel_SearchFormula.Height := ReadInteger( 'SearchFormulaPanel', 'Height', Panel_SearchFormula.Height );
     Splitter_SearchFormula.Top := Panel_SearchFormula.Top - 1;
     ListBox_Paths.Width := ReadInteger( 'PathPanel', 'Width', ListBox_Paths.Width );
     Splitter_Paths.Left := ListBox_Paths.Left - 1;

     if ReadString( 'Path', 'Count', '' ) = '' then
      begin
        for Drive := 'A' to 'Z' do
         if GetDriveType( PChar( Drive + ':\' ) ) = DRIVE_FIXED then
          begin
            ListBox_Paths.Items.Add( Drive + ':\' );
            ListBox_Paths.Checked[ ListBox_Paths.Items.Count - 1 ] := True;
          end;
      end
     else
      begin
        for i := 0 to ReadInteger( 'Path', 'Count', 0 ) - 1 do
         ListBox_Paths.Items.Add( ReadString( 'Path', IntToStr( i + 1 ), '' ) );

        for i := 0 to ReadInteger( 'Checked', 'Count', 0 ) - 1 do
         begin
           S := ReadString( 'Checked', IntToStr( i + 1 ), '' );
           Index := ListBox_Paths.Items.IndexOf( S );
           if Index >= 0 then
            ListBox_Paths.Checked[ Index ] := True;
         end;
      end;
   finally
     Free;
   end;

  StatusBar.Top := ClientHeight;
end;

procedure TMain_Form.FormShow(Sender: TObject);
begin
  Action_NewExecute( Action_New );
end;

procedure TMain_Form.FormDestroy(Sender: TObject);
var
  i, Count: Integer;
begin
  with TIniFile.Create( 'FSFormula.ini' ) do
   try
     if WindowState = wsNormal then
      begin
        WriteInteger( 'Window', 'Left', Left );
        WriteInteger( 'Window', 'Top', Top );
        WriteInteger( 'Window', 'Width', Width );
        WriteInteger( 'Window', 'Height', Height );
      end;
     WriteInteger( 'SearchFormulaPanel', 'Height', Panel_SearchFormula.Height );
     WriteInteger( 'PathPanel', 'Width', ListBox_Paths.Width );

     EraseSection( 'Path' );
     WriteInteger( 'Path', 'Count', ListBox_Paths.Items.Count );
     for i := 0 to ListBox_Paths.Items.Count - 1 do
      WriteString( 'Path', IntToStr( i + 1 ), ListBox_Paths.Items[i] );

     Count := 0;
     EraseSection( 'Checked' );
     for i := 0 to ListBox_Paths.Items.Count - 1 do
      if ListBox_Paths.Checked[i] then
       begin
         WriteString( 'Checked', IntToStr( Count + 1 ), ListBox_Paths.Items[i] );
         Inc( Count );
       end;
     WriteInteger( 'Checked', 'Count', Count );
   finally
     Free;
   end;
end;

procedure TMain_Form.Action_AbortExecute(Sender: TObject);
begin
  if FileSearch <> nil then FileSearch.Abort;
end;

procedure TMain_Form.Action_NewExecute(Sender: TObject);
var
  TabSheet: TMemoSheet;
begin
  TabSheet := TMemoSheet.Create( PageControl_Memo );
  TabSheet.Caption := IntToStr( PageControl_Memo.PageCount + 1 );
  TabSheet.PageControl := PageControl_Memo;
  TabSheet.Memo.PopupMenu := PopupMenu_SearchFormula;
  PageControl_Memo.ActivePage := TabSheet;
  TabSheet.SetFocus;
end;

procedure TMain_Form.Action_CloseExecute(Sender: TObject);
begin
  if PageControl_Memo.PageCount > 1 then
   begin
     PageControl_Memo.ActivePage.Free;
     PageControl_Memo.ActivePageIndex := 0;
   end
  else
   begin
     ActivateMemo.Lines.Clear;
     PageControl_Memo.ActivePage.Caption := '1';
     PageControl_Memo.ActivePage.SetFocus;
   end;
end;

procedure TMain_Form.Action_OpenExecute(Sender: TObject);
begin
  if OpenDialog.Execute then
   begin
     if ActivateMemo.Text <> '' then
      Action_NewExecute( Action_New );
     PageControl_Memo.ActivePage.Caption := ChangeFileExt( ExtractFileName( OpenDialog.FileName ), '' );
     ActivateMemo.Lines.LoadFromFile( OpenDialog.FileName );
   end;
end;

procedure TMain_Form.Action_RunExecute(Sender: TObject);
var
  Paths: TStrings;
  ListBoxSheet: TListViewSheet;
  ListView: TListView;
  FileList: TFileList;
  i: Integer;
begin
  Screen.Cursor := crAppStart;
  Action_Run.Enabled := False;
  Action_Abort.Enabled := True;
  Action_Close.Enabled := False;
  Action_CloseListBox.Enabled := False;
  try
    Paths := TStringList.Create;
    try
      for i := 0 to ListBox_Paths.Items.Count - 1 do
       if ListBox_Paths.Checked[ i ] then
        Paths.Add( ListBox_Paths.Items[i] );

      if Paths.Count = 0 then
       begin
         MessageBeep( 0 );
         Exit;
       end;

      StatusBar.Panels[0].Text := '';
      StatusBar.Panels[1].Text := '';

      FileSearch := TFileSearch.Create;
      try
        if FileSearch.Parse( ActivateMemo.Text ) then
         begin
           StatusBar.Panels[0].Text := '검색 중...';

           ListView := nil;
           FileList := nil;

           for i := 0 to PageControl_ListBox.PageCount - 1 do
            if PageControl_ListBox.Pages[i].Caption = PageControl_Memo.ActivePage.Caption then
             begin
               PageControl_ListBox.ActivePageIndex := i;
               ListView := TListViewSheet( PageControl_ListBox.Pages[i] ).ListView;
               FileList := TListViewSheet( PageControl_ListBox.Pages[i] ).FileList;
               Break;
             end;

           if ListView = nil then
            begin
              ListBoxSheet := TListViewSheet.Create( PageControl_ListBox );
              ListBoxSheet.PageControl := PageControl_ListBox;
              ListBoxSheet.Caption := PageControl_Memo.ActivePage.Caption;
              ListBoxSheet.ListView.PopupMenu := PopupMenu_ListView;
              PageControl_ListBox.ActivePage := ListBoxSheet;
              ListView := ListBoxSheet.ListView;
              FileList := ListBoxSheet.FileList;
            end;

           if ListView = nil then Exit;

           ListView.Items.Count := 0;
           ListView.Repaint;

           FileSearch.Search( Paths, FileList );
           if FileSearch.Aborted then StatusBar.Panels[0].Text := '작업 취소'
                                 else StatusBar.Panels[0].Text := '검색 완료!';

           StatusBar.Panels[1].Text := '  찾은 파일 : ' + FormatFloat( '#,##0', ListView.Items.Count );
         end
        else
         begin
           ActivateMemo.SelStart := FileSearch.ParsedLength;
           ActivateMemo.SelLength := 1;
           ActivateMemo.SetFocus;
           StatusBar.Panels[0].Text := '문법 오류';
         end;
      finally
        FileSearch.Free;
        FileSearch := nil;
      end;
    finally
      Paths.Free;
    end;

  finally
    Action_Run.Enabled := True;
    Action_Abort.Enabled := False;
    Action_Close.Enabled := True;
    Action_CloseListBox.Enabled := PageControl_ListBox.PageCount > 0;
    Screen.Cursor := crDefault;
    MessageBeep( 0 );
  end;
end;

procedure TMain_Form.Action_SaveExecute(Sender: TObject);
begin
  if SaveDialog.Execute then
   begin
     SaveDialog.FileName := ChangeFileExt( SaveDialog.FileName, '.txt' );
      ActivateMemo.Lines.SaveToFile( SaveDialog.FileName );
   end;
end;

procedure TMain_Form.Action_AddPathClick(Sender: TObject);
var
  Path: String;
begin
  if SelectDirectory( '^^', '', Path ) then
   begin
     ListBox_Paths.Items.Add( Path );
     ListBox_Paths.Checked[ ListBox_Paths.Items.Count - 1 ] := True;
   end;
end;

procedure TMain_Form.Action_DeletePathClick(Sender: TObject);
begin
  if ListBox_Paths.ItemIndex >= 0 then
   ListBox_Paths.Items.Delete( ListBox_Paths.ItemIndex );
end;

procedure TMain_Form.Menu_AttributesClick(Sender: TObject);
begin
  ActivateMemo.SelText := TMenuItem(Sender).Caption;
end;

procedure TMain_Form.Action_CloseListBoxExecute(Sender: TObject);
begin
  if PageControl_ListBox.ActivePage <> nil then
   begin
     PageControl_ListBox.ActivePage.Free;
     Action_CloseListBox.Enabled := PageControl_ListBox.PageCount > 0;
   end;
end;

procedure TMain_Form.Menu_CopyClick(Sender: TObject);
begin
  if ActiveListViewSheet <> nil then
   ActiveListViewSheet.CopyToClipboard;
end;

procedure TMain_Form.Menu_OpenToExplorerClick(Sender: TObject);
begin
  if ActiveListViewSheet <> nil then
   ActiveListViewSheet.Execute; 
end;

procedure TMain_Form.Menu_SearchFormulaUndoClick(Sender: TObject);
begin
  ActivateMemo.Undo;
end;

procedure TMain_Form.Menu_SearchFormulaCutClick(Sender: TObject);
begin
  ActivateMemo.CutToClipboard;
end;

procedure TMain_Form.Menu_SearchFormulaCopyClick(Sender: TObject);
begin
  ActivateMemo.CopyToClipboard;
end;

procedure TMain_Form.Menu_SearchFormulaPasteClick(Sender: TObject);
begin
  ActivateMemo.PasteFromClipboard;
end;

procedure TMain_Form.Menu_SearchFormulaDeleteClick(Sender: TObject);
begin
  ActivateMemo.SelText := '';
end;

procedure TMain_Form.Menu_SearchFormulaSelectAllClick(Sender: TObject);
begin
  ActivateMemo.SelectAll;
end;

procedure TMain_Form.PopupMenu_ListViewPopup(Sender: TObject);
begin
  if ActiveListViewSheet = nil then Exit;

  Menu_Copy.Enabled := ActiveListViewSheet.ListView.ItemIndex >= 0;
  Menu_OpenToExplorer.Enabled := ActiveListViewSheet.ListView.ItemIndex >= 0;
end;

procedure TMain_Form.PopupMenu_SearchFormulaPopup(Sender: TObject);
begin
  Menu_SearchFormulaUndo.Enabled := ActivateMemo.CanUndo;
  Menu_SearchFormulaCut.Enabled := ActivateMemo.SelLength > 0;
  Menu_SearchFormulaCopy.Enabled := ActivateMemo.SelLength > 0;
  Menu_SearchFormulaPaste.Enabled := Clipboard.AsText <> '';
  Menu_SearchFormulaDelete.Enabled := ActivateMemo.SelLength > 0;
  Menu_SearchFormulaSelectAll.Enabled := ActivateMemo.Text <> '';
end;

procedure TMain_Form.Splitter_CanResize(Sender: TObject; var NewSize: Integer; var Accept: Boolean);
begin
  if NewSize < 90 then NewSize := 90;
end;

function TMain_Form.ActivateMemo: TMemo;
begin
  Result := TMemoSheet(PageControl_Memo.ActivePage).Memo;
end;

function TMain_Form.ActiveListViewSheet: TListViewSheet;
begin
  if PageControl_ListBox.ActivePage <> nil then Result := TListViewSheet(PageControl_ListBox.ActivePage)
                                           else Result := nil;

end;

end.
