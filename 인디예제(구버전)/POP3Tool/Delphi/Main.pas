unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdExplicitTLSClientServerBase, IdMessageClient, IdPOP3, INIFiles,
  ComCtrls, ExtCtrls, ActnList, Menus, IdMessage, IdAntiFreezeBase,
  IdAntiFreeze;

type
  TformMain = class(TForm)
    pop3: TIdPOP3;
    ActionList1: TActionList;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    mitmExit: TMenuItem;
    actnConnect: TAction;
    actnDisconnect: TAction;
    actnGetRaw: TAction;
    actnGetHeader: TAction;
    actnDelete: TAction;
    actnDeleteAll: TAction;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    editPOP3Server: TEdit;
    Label2: TLabel;
    editUsername: TEdit;
    Label3: TLabel;
    editPassword: TEdit;
    butnSaveConfig: TButton;
    actnSaveConfig: TAction;
    Panel2: TPanel;
    butnConnect: TButton;
    butnDisconnect: TButton;
    butnGet: TButton;
    butnDelete: TButton;
    butnDeleteAll: TButton;
    lboxMsgs: TListBox;
    Server1: TMenuItem;
    Message1: TMenuItem;
    ools1: TMenuItem;
    DeleteAll1: TMenuItem;
    Connect1: TMenuItem;
    Disconnect1: TMenuItem;
    Get1: TMenuItem;
    GetHeader1: TMenuItem;
    N1: TMenuItem;
    SaveConfig1: TMenuItem;
    Button1: TButton;
    IdAntiFreeze1: TIdAntiFreeze;
    Msg: TIdMessage;
    pctlMain: TPageControl;
    TabSheet1: TTabSheet;
    pageHeaders: TTabSheet;
    memoMsg: TMemo;
    memoHeaders: TMemo;
    Button2: TButton;
    actnGet: TAction;
    Get2: TMenuItem;
    panlHeader: TPanel;
    lablSubject: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    lablAttachments: TLabel;
    Label6: TLabel;
    lablFrom: TLabel;
    Button3: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ActionList1Update(Action: TBasicAction;
      var Handled: Boolean);
    procedure mitmExitClick(Sender: TObject);
    procedure actnConnectExecute(Sender: TObject);
    procedure actnDisconnectExecute(Sender: TObject);
    procedure actnDeleteExecute(Sender: TObject);
    procedure actnDeleteAllExecute(Sender: TObject);
    procedure actnSaveConfigExecute(Sender: TObject);
    procedure actnGetHeaderExecute(Sender: TObject);
    procedure pop3Disconnected(Sender: TObject);
    procedure lboxMsgsClick(Sender: TObject);
    procedure actnGetRawExecute(Sender: TObject);
    procedure actnGetExecute(Sender: TObject);
    procedure lboxMsgsDblClick(Sender: TObject);
  private
  protected
    FINIFile: TINIFile;
    FMsgCount: Integer;
    FMsgNo: Integer;
    //
    procedure ClearFields;
    function MsgNo(const aIndex: integer): integer;
    procedure SetPOP3Props;
  public
  end;

var
  formMain: TformMain;

implementation
{$R *.dfm}

procedure TformMain.FormCreate(Sender: TObject);
begin
  ClearFields;
  FMsgNo := -1;
  FINIFile := TINIFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
  with FINIFile do begin
    editPOP3Server.Text := ReadString('Main', 'POP3 Server', '');
    editUsername.Text := ReadString('Main', 'Username', '');
    editPassword.Text := ReadString('Main', 'Password', '');
  end;
end;

procedure TformMain.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FINIFile);
end;

procedure TformMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if pop3.Connected then begin
    pop3.Disconnect;
  end;
end;

procedure TformMain.SetPOP3Props;
begin
  with pop3 do begin
    Host := Trim(editPOP3Server.Text);
    Username := Trim(editUsername.Text);
    Password := Trim(editPassword.Text);
  end;
end;

procedure TformMain.ActionList1Update(Action: TBasicAction;
  var Handled: Boolean);
var
  xConnected: Boolean;
  xMsgSelected: Boolean;
begin
  xConnected := POP3.Connected;
  xMsgSelected := xConnected and (FMsgNo > -1);
  editPOP3Server.Enabled := not xConnected;
  editUsername.Enabled := not xConnected;
  editPassword.Enabled := not xConnected;
  actnSaveConfig.Enabled := not xConnected;
  actnConnect.Enabled := not xConnected;
  actnDisconnect.Enabled := xConnected;
  actnGet.Enabled := xMsgSelected;
  actnGetHeader.Enabled := xMsgSelected;
  actnGetRaw.Enabled := xMsgSelected;
  actnDelete.Enabled := xMsgSelected;
  actnDeleteAll.Enabled := xConnected and (lboxMsgs.Count > 0);
  Handled := True;
end;

procedure TformMain.mitmExitClick(Sender: TObject);
begin
  Close;
end;

procedure TformMain.actnConnectExecute(Sender: TObject);
var
  i: Integer;
begin
  SetPOP3Props;
  pop3.Connect;
  FMsgCount := pop3.CheckMessages;
  ClearFields;
  if FMsgCount = 0 then begin
    ShowMessage('No messages on server.');
  end else begin
    for i := 1 to FMsgCount do begin
      lboxMsgs.Items.AddObject(IntToStr(i), TObject(i));
    end;
  end;
end;

procedure TformMain.actnDisconnectExecute(Sender: TObject);
begin
  pop3.Disconnect;
end;

procedure TformMain.actnDeleteExecute(Sender: TObject);
begin
  pop3.Delete(FMsgNo);
  lboxMsgs.Items.Delete(lboxMsgs.ItemIndex);
  FMsgNo := -1;
end;

procedure TformMain.actnDeleteAllExecute(Sender: TObject);
var
  i: Integer;
begin
  actnDeleteAll.Enabled := False; try
    for i := lboxMsgs.Count - 1 downto 0 do begin
      Caption := 'Purging ' + IntToStr(i) + ' / ' + IntToStr(lboxMsgs.Count);
      Application.ProcessMessages;
      Application.ProcessMessages;
      Application.ProcessMessages;
      Application.ProcessMessages;
      pop3.Delete(MsgNo(i));
      lboxMsgs.Items.Delete(i);
    end;
    Caption := Application.Title;
  finally actnDeleteAll.Enabled := True; end;
  ClearFields;
  FMsgNo := -1;
end;

procedure TformMain.actnSaveConfigExecute(Sender: TObject);
begin
  with FINIFile do begin
    WriteString('Main', 'POP3 Server', Trim(editPOP3Server.Text));
    WriteString('Main', 'Username', Trim(editUsername.Text));
    WriteString('Main', 'Password', Trim(editPassword.Text));
  end;
  ShowMessage('Configuration saved.');
end;

procedure TformMain.actnGetHeaderExecute(Sender: TObject);
begin
  ClearFields;
  pctlMain.ActivePage := pageHeaders;
  pop3.RetrieveHeader(FMsgNo, Msg);
  memoMsg.Lines.Assign(Msg.Headers);
end;

procedure TformMain.pop3Disconnected(Sender: TObject);
begin
  FMsgNo := -1;
end;

procedure TformMain.lboxMsgsClick(Sender: TObject);
begin
  FMsgNo := MsgNo(lboxMsgs.ItemIndex);
end;

procedure TformMain.actnGetRawExecute(Sender: TObject);
begin
  ClearFields;
  pop3.RetrieveRaw(FMsgNo, memoMsg.Lines);
end;

procedure TformMain.ClearFields;
var
  i: Integer;
  xCtrl: TControl;
begin
  pctlMain.ActivePageIndex := 0;
  memoMsg.Clear;
  memoHeaders.Clear;
  for i := 0 to panlHeader.ControlCount - 1 do begin
    xCtrl := panlHeader.Controls[i];
    if xCtrl.Tag = 1 then begin
      if xCtrl is TLabel then begin
        TLabel(xCtrl).Caption := '';
      end;
    end;
  end;
end;

procedure TformMain.actnGetExecute(Sender: TObject);
begin
  ClearFields;
  pop3.Retrieve(FMsgNo, Msg);
  memoMsg.Lines.Assign(Msg.Body);
  memoHeaders.Lines.Assign(Msg.Headers);
  lablSubject.Caption := Msg.Subject;
  lablFrom.Caption := Msg.From.Text;
  lablAttachments.Caption := IntToStr(Msg.MessageParts.AttachmentCount);
end;

procedure TformMain.lboxMsgsDblClick(Sender: TObject);
begin
  if actnGet.Enabled then begin
    actnGet.Execute;
  end;
end;

function TformMain.MsgNo(const aIndex: integer): integer;
begin
  Result := Integer(lboxMsgs.Items.Objects[aIndex]);
end;

end.
