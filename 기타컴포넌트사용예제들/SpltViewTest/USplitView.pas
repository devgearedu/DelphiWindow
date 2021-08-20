unit USplitView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Imaging.pngimage, System.ImageList, Vcl.ImgList, System.Actions,
  Vcl.ActnList, Vcl.WinXPanels, Vcl.CategoryButtons, Vcl.WinXCtrls, Data.DB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.Client, FireDAC.Comp.DataSet,
  Vcl.Grids, Vcl.DBGrids;

type
  TDeptForm_New = class(TForm)
    Panel1: TPanel;
    imgMenu: TImage;
    grpDisplayMode: TRadioGroup;
    grpPlacement: TRadioGroup;
    grpCloseStyle: TRadioGroup;
    chkUseAnimation: TCheckBox;
    SV: TSplitView;
    catMenuItems: TCategoryButtons;
    CardPanel1: TCardPanel;
    chkClose: TCheckBox;
    Card1: TCard;
    DBGrid2: TDBGrid;
    Card2: TCard;
    StringGrid1: TStringGrid;
    Card3: TCard;
    Card4: TCard;
    Panel2: TPanel;
    procedure grpDisplayModeClick(Sender: TObject);
    procedure grpPlacementClick(Sender: TObject);
    procedure grpCloseStyleClick(Sender: TObject);
    procedure chkUseAnimationClick(Sender: TObject);
    procedure imgMenuClick(Sender: TObject);
    procedure SVClosed(Sender: TObject);
    procedure SVOpened(Sender: TObject);
    procedure SVOpening(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure actCountExecute(Sender: TObject);
    procedure ActInsertExecute(Sender: TObject);
    procedure actDetailExecute(Sender: TObject);
    procedure ActExcelExecute(Sender: TObject);
    procedure StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure FormCreate(Sender: TObject);
    procedure actHomeExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DeptForm_New: TDeptForm_New;

implementation

{$R *.dfm}


procedure TDeptForm_New.actCountExecute(Sender: TObject);
begin
  CardPanel1.Visible := true;
  CardPanel1.ActiveCard := card2;
   if Sv.Opened and chkClose.Checked then
    Sv.Close;
end;

procedure TDeptForm_New.actDetailExecute(Sender: TObject);
begin
  CardPanel1.Visible := true;
  CardPanel1.ActiveCard := card1;
  if Sv.Opened and chkClose.Checked then
     Sv.Close;
end;

procedure TDeptForm_New.ActExcelExecute(Sender: TObject);
begin
  CardPanel1.Visible := true;
  CardPanel1.ActiveCard := card4;
   if Sv.Opened and chkClose.Checked then
    Sv.Close;
end;

procedure TDeptForm_New.actHomeExecute(Sender: TObject);
begin
 if SV.Opened and chkClose.Checked then
    SV.Close;
 cardPanel1.Visible := false;
end;

procedure TDeptForm_New.ActInsertExecute(Sender: TObject);
begin
  CardPanel1.Visible := true;
  CardPanel1.ActiveCard := card3;
  if Sv.Opened and chkClose.Checked then
     Sv.Close;
end;



procedure TDeptForm_New.chkUseAnimationClick(Sender: TObject);
begin
  SV.UseAnimation := chkUseAnimation.Checked;
end;

procedure TDeptForm_New.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TDeptForm_New.FormCreate(Sender: TObject);
begin
  cardPanel1.visible := false;
end;

procedure TDeptForm_New.grpCloseStyleClick(Sender: TObject);
begin
  SV.CloseStyle := TSplitViewCloseStyle(grpCloseStyle.ItemIndex);

end;

procedure TDeptForm_New.grpDisplayModeClick(Sender: TObject);
begin
  SV.DisplayMode := TSplitViewDisplayMode(grpDisplayMode.ItemIndex);
end;

procedure TDeptForm_New.grpPlacementClick(Sender: TObject);
begin
  SV.Placement := TSplitViewPlacement(grpPlacement.ItemIndex);

end;

procedure TDeptForm_New.imgMenuClick(Sender: TObject);
begin
  if SV.Opened then
    SV.Close
  else
    SV.Open;
end;

procedure TDeptForm_New.StringGrid1DrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  s:string;
  pos:integer;
  OldAlign:integer;
begin
  s := StringGrid1.Cells[ACol,ARow];
  with StringGrid1.Canvas do
  begin
    FillRect(Rect);
    if ARow = 0 then
    begin
      Font.Color := clBlue;
      Font.Size := Font.Size + 4;
    end;
    if (ACol = 2) and (ARow <> 0) then
    begin
      if (ARow = StringGrid1.RowCount - 1) then
         Brush.color := clyellow;

      Font.Color := clred;
      Font.Size := Font.Size + 4;
      s := s + 'Έν';
      OldAlign := SetTextAlign(Handle,ta_Right);
      TextRect(Rect, Rect.Right, Rect.Top+3, s);
      SetTextAlign(Handle,OldAlign);
    end
    else
    begin
      pos := ((Rect.Right - Rect.Left) - TextWidth(s)) div 2;
      TextRect(Rect, Rect.Left+pos, Rect.Top+3, s);
    end;
  end;
end;

procedure TDeptForm_New.SVClosed(Sender: TObject);
begin
  // When TSplitView is closed, adjust ButtonOptions and Width
  catMenuItems.ButtonOptions := catMenuItems.ButtonOptions - [boShowCaptions];
  if SV.CloseStyle = svcCompact then
    catMenuItems.Width := SV.CompactWidth;

end;

procedure TDeptForm_New.SVOpened(Sender: TObject);
begin
  // When not animating, change size of catMenuItems when TSplitView is opened
  catMenuItems.ButtonOptions := catMenuItems.ButtonOptions + [boShowCaptions];
  catMenuItems.Width := SV.OpenedWidth;

end;

procedure TDeptForm_New.SVOpening(Sender: TObject);
begin
  // When animating, change size of catMenuItems at the beginning of open
  catMenuItems.ButtonOptions := catMenuItems.ButtonOptions + [boShowCaptions];
  catMenuItems.Width := SV.OpenedWidth;

end;

end.
