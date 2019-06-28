unit uRibbonControl_RunTime;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Ribbon, Vcl.RibbonLunaStyleActnCtrls,
  Vcl.ActnList, Vcl.StdActns, Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnMan,
  Data.Bind.EngExt, Vcl.Bind.DBEngExt, System.Rtti, System.Bindings.Outputs,
  Vcl.Bind.Editors, Data.Bind.Components, Vcl.ToolWin, Vcl.ActnCtrls,
  System.Actions;

type
  TForm16 = class(TForm)
    Ribbon1: TRibbon;
    RibbonPage1: TRibbonPage;
    RibbonGroup1: TRibbonGroup;
    ActionManager1: TActionManager;
    Action1: TAction;
    procedure FormCreate(Sender: TObject);
    procedure Action1Execute(Sender: TObject);
  private
    { Private declarations }
  public
    procedure TestHandler(Sender:TObject);
    { Public declarations }
  end;

var
  Form16: TForm16;
  RibbonTabItem :TRibbonTabItem;
  RibbonGroup:TRibbonGroup;
  RibbonPage:TRibbonPage;
  Action:TCustomAction;
//  CollectionItem:TCollectionItem;
  ClientItem: TActionClientItem;
  ActionBarItem:TActionBarItem;
implementation

{$R *.dfm}

procedure TForm16.Action1Execute(Sender: TObject);
begin
  close;
end;

procedure TForm16.FormCreate(Sender: TObject);
var
  s:string;
  I: Integer;
begin
  RibbonTabItem := Ribbon1.Tabs.Add;
  RibbonTabItem.Caption := '기타';
  RibbonPage := TRibbonPage(RibbonTabItem.Page);
  RibbonGroup := TRibbonGroup.Create(Ribbon1);
  RibbonGroup.Parent := RibbonPage;
  RibbonGroup.Caption := '파일';


  Action := TAction.Create(ActionManager1);
  tAction(Action).Caption := '동적메뉴';
  TAction(Action).Category := 'File';
  TAction(Action).OnExecute := TestHandler;

  ActionBarItem := ActionManager1.ActionBars.Add;
  ClientItem := ActionBarItem.Items.add;
  ClientItem.Action := TContainedAction(Action);
  RibbonGroup.CreateControl(ClientItem);
 end;

procedure TForm16.TestHandler(Sender: TObject);
begin
  ShowMessage('Test');
end;

end.
