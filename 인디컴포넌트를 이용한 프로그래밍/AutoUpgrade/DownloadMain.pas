unit DownloadMain;

interface

uses
  Windows, Messages, Classes, Controls, Forms, ComCtrls, StdCtrls, Dialogs,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP;

const
  WM_FORMINIT  = WM_USER + 1003;

type
  TDownFileRec = record
    Path: string;
    Size: integer;
    DateTime: TDateTime;
  end;

  TDownloadMainForm = class(TForm)
    Animate1: TAnimate;
    CurrProgressBar: TProgressBar;
    TotalProgressBar: TProgressBar;
    MsgLabel: TLabel;
    StatusLabel: TLabel;
    IdHTTP1: TIdHTTP;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    UpgradeUrl, UpgradeBaseUrl: string;
    ProgramToRun: string;
    SystemDirectory: string;
    CurPath: string;
    procedure FileSizeChange(Sender: TObject; OldPos, NewPos: integer);
    function DownloadFile(ADownRec: TDownFileRec; BaseUrl, CurPath: string): int64;
    function GetLocalPath(ServerPath: string): string;
    procedure WMFormInit(var Msg: TMessage); message WM_FORMINIT;
  public
    UserID, UserPass: string;
    function DownloadProduct(FolderName: string): integer;
  end;

var
  DownloadMainForm: TDownloadMainForm;

implementation

{$R *.dfm}

uses SysUtils, IniFiles, DateUtils, IdException, ImpFileStream, TlHelp32;

const
  SAutoUpgradeHeader = 'AutoUpgrade Server';
  SSysDirSymbol = '@system';
  SDefaultProgramToRun = 'SampleProgram.exe';
  SDefaultUpgradeUrl = 'http://www.devgear.co.kr/AutoUpgradeServer/AutoUpgradeServer.dll?path=vcl120';

procedure TDownloadMainForm.FormCreate(Sender: TObject);
var
  len: integer;
begin
  SetLength(SystemDirectory, MAX_PATH+1);
  len := GetSystemDirectory(PChar(SystemDirectory), MAX_PATH);
  SetLength(SystemDirectory, len);

  CurPath := ExtractFilePath(ParamStr(0));

  with TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'server.ini') do try
    UpgradeUrl   := ReadString('AutoUpgrade', 'UpgradeUrl', SDefaultUpgradeUrl);
    ProgramToRun := ReadString('AutoUpgrade', 'ProgramToRun', SDefaultProgramToRun);
  finally
    Free;
  end;

  if (Pos('/', UpgradeUrl)=0) or (Pos('?', UpgradeUrl)=0) then
    ShowMessage('���׷��̵� �ּҰ� �߸��Ǿ����ϴ�. server.ini�� Ȯ���Ͻʽÿ�.' + #13#10 + UpgradeBaseUrl);
  if LowerCase(Copy(UpgradeUrl, 1, 7))<>'http://' then
    UpgradeUrl := 'http://' + UpgradeUrl;

  // ���� ���ϵ��� �ٿ�ޱ� ���� ���� ��� : http://www.devgear.co.kr/AutoUpgradeServer/vcl120
  UpgradeBaseUrl := Copy(UpgradeUrl, 1, LastDelimiter('/', UpgradeUrl)) + Copy(UpgradeUrl, Pos('=', UpgradeUrl)+1, 10000);
end;

procedure TDownloadMainForm.FormShow(Sender: TObject);  // Ÿ��Ʋ���� �ݱ� ��ư�� �ý��۸޴��� �ݱ� �޴� ���ֱ�
var
  hMnu: HMENU;
begin
  hMnu := GetSystemMenu(Handle, false);
  EnableMenuItem(hMnu, SC_CLOSE, MF_BYCOMMAND or MF_GRAYED);
  DrawMenuBar(Handle);
  hMnu := GetSystemMenu(Application.Handle, false);
  EnableMenuItem(hMnu, SC_CLOSE, MF_BYCOMMAND or MF_GRAYED);
  DrawMenuBar(Application.Handle);
end;

procedure TDownloadMainForm.FormActivate(Sender: TObject);
begin
  PostMessage(self.Handle, WM_FORMINIT, 0, 0);
end;

procedure TDownloadMainForm.WMFormInit(var Msg: TMessage);

  function GetProcessModule(dwPID: dword; ProcessName: string): boolean;
  var
    hModuleSnap: THandle;
    ModEntry: TModuleEntry32;
  begin
    result := false;
    hModuleSnap := CreateToolhelp32Snapshot(TH32CS_SNAPMODULE, dwPID);
    if hModuleSnap = THandle(-1) then exit;
    ModEntry.dwSize := sizeof(TModuleEntry32);
    if Module32First(hModuleSnap, ModEntry) then
    begin
      repeat
        if ModEntry.szModule = ProcessName then
        begin
          CloseHandle(hModuleSnap);
          result := true;
          exit;
        end;
      until not Module32Next(hModuleSnap, ModEntry);
    end;
    CloseHandle(hModuleSnap);
  end;

  function KillProcess(ProcessName: string): integer;
  var
    hProcessSnap: THandle;
    ProcEntry: TProcessEntry32;
    bCurrent: boolean;
    hProcess: THandle;
    nCode: DWORD; //���μ��� ���� ����
  begin
    result := 0;
    hProcessSnap := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
    if hProcessSnap = THandle(-1) then exit;
    ProcEntry.dwSize := sizeof(TProcessEntry32);
    if Process32First(hProcessSnap, ProcEntry) then
    begin
      repeat
        bCurrent := GetProcessModule(ProcEntry.th32ProcessID, ProcessName);
        if bCurrent then
        begin
          hProcess := OpenProcess(PROCESS_ALL_ACCESS, false, ProcEntry.th32ProcessID);
          if hProcess <> 0 then
          begin
            if TerminateProcess(hProcess, 0) then
              GetExitCodeProcess(hProcess, nCode);
            CloseHandle(hProcess);
            Inc(result);
          end;
        end;
      //���� ���μ����� ������ ���Ͽ� ������ ������ ����.
      until not Process32Next(hProcessSnap, ProcEntry);
    end;
    CloseHandle(hProcessSnap);
  end;

var
  iRet: integer;
  bRet: boolean;
begin
  KillProcess(SDefaultProgramToRun);
  iRet := DownloadProduct('VCL120');
  if iRet>=0 then
  begin
    bRet := WinExec(PAnsiChar(SDefaultProgramToRun+' NOUPCHECK'), SW_SHOWNORMAL) > 31;
    if bRet=false then
      ShowMessage(SysErrorMessage(GetLastError));
  end;

  Application.Terminate;
end;

function TDownloadMainForm.DownloadProduct(FolderName: string): integer;

  function IsFileToDownload(LocalFilePath: string; RemoteFileTime: TDateTime): boolean;
  var
    LocalFileTime: TDateTime;
  begin
    result := true;
    if not FileExists(LocalFilePath) then exit;
    FileAge(LocalFilePath, LocalFileTime);
    if IncSecond(LocalFileTime, 1) < RemoteFileTime then exit;
    result := false;
  end;

var
  FileList, TmpList: TStringList;
  TotalSize, i: integer;
  AFilePath: string;
  DownList: array of TDownFileRec;
  ADownRec: TDownFileRec;
begin
  Animate1.Active := false;
  Animate1.Visible := false;
  Animate1.CommonAVI := aviFindFolder;
  Animate1.Active := true;
  Animate1.Visible := true;
  MsgLabel.Caption := '���׷��̵� ���� Ȯ����...';
  Application.ProcessMessages;

  FileList := TStringList.Create;
  try
    FileList.Text := idHTTP1.Get(UpgradeUrl);
  except
    on E: Exception do
    begin
      result := -1;
      exit;
    end;
  end;

  if (Trim(FileList.Text)='') or (FileList.Strings[0]<>SAutoUpgradeHeader) then
  begin
    ShowMessage('���׷��̵� ���� �ּҰ� �߸��Ǿ����ϴ�.');
    result := 0;
    exit;
  end;
  FileList.Delete(0); // ��� ����

  TmpList  := TStringList.Create;
  TotalSize := 0;
  for i:=0 to FileList.Count-1 do
  begin
    TmpList.Text := StringReplace(FileList.Strings[i], #9, #13#10, [rfReplaceAll]);
    with ADownRec do
    begin
      // ����� ���� -> List index out of bounds (1)
      try
        Path := TmpList.Strings[0];
        Size := StrToInt(TmpList.Strings[1]);
        DateTime := StrToDateTime(TmpList.Strings[2]);
      except
        on E: Exception do
        begin
          ShowMessage('�������� ���� ������ �߻��Ͽ����ϴ�.' + #13#10
                    + '�Ʒ��� ���� ���� �����Դϴ�.' + #13#10 + #13#10
                    + 'URL: ' + UpgradeUrl + #13#10
                    + '[' + FileList.Text + ']'  );
          result := -1;
          exit;
        end;
      end;
    end;
    AFilePath := GetLocalPath(ADownRec.Path);
    if IsFileToDownload(AFilePath, ADownRec.DateTime) then
    begin
      SetLength(DownList, Length(DownList)+1);
      DownList[Length(DownList)-1] := ADownRec;
      TotalSize := TotalSize + ADownRec.Size;
    end;
  end;
  TmpList.Free;
  FileList.Free;

  result := Length(DownList);
  if Application.MainForm<>self then exit;

  Animate1.CommonAVI := aviCopyFile;
  Animate1.Active := true;
  TotalProgressBar.Position := 0;
  TotalProgressBar.Max := TotalSize;
  StatusLabel.Visible := true;


  Application.ProcessMessages;
  for i:=0 to Length(DownList)-1 do
  begin
    MsgLabel.Caption := DownList[i].Path + ' �ٿ�ε���...';
    StatusLabel.Caption := IntToStr(i+1) + '/' + IntToStr(Length(DownList)) + '��°';
    CurrProgressBar.Position := 0;
    CurrProgressBar.Max := DownList[i].Size;
    Application.ProcessMessages;
    if DownloadFile(DownList[i], UpgradeBaseUrl, CurPath) < 0 then // ������ 0�� ���� ����Ʈ�� ���� ���ϵ��� �ٿ�ε� �õ� ���
    begin
      result := -1;
      exit;
    end;
    Application.ProcessMessages;
  end;
  Close;
end;

function TDownloadMainForm.DownloadFile(ADownRec: TDownFileRec; BaseUrl, CurPath: string): int64;
var
  AStream: TImpFileStream;
  TempPath, RealPath: string;
begin
  TempPath := CurPath + 'temp\' + ADownRec.Path;
  ForceDirectories(ExtractFilePath(TempPath));
  AStream := TImpFileStream.Create(TempPath, fmCreate);
  try
    AStream.OnPositionChange := FileSizeChange;
    try
      idHTTP1.Get(BaseUrl + '/' + ADownRec.Path, AStream);
      result := AStream.Size;
    except
      on E: EIdConnClosedGracefully do
      begin
        MsgLabel.Caption := ADownRec.Path + ' �ٿ�ε� ���� �߻�, ��õ���...';
        try
          idHTTP1.Get(BaseUrl + '/' + ADownRec.Path, AStream);
          result := AStream.Size;
        except
          on E: EIdConnClosedGracefully do
          begin
            ShowMessage('�ٿ�ε��߿� ��Ʈ��ũ ������ ���������ϴ�.' + #13#10 + '��Ʈ��ũ�� �����Ͻ� �� ��� �Ŀ� �ٽ� �õ��غ��ʽÿ�.');
            result := -1;
            exit;
          end;
        end;
      end;
      on E: EidHTTPProtocolException do
      begin
        ShowMessage(ADownRec.Path + ' ������ ã�� �� �����ϴ�.');
        result := 0;
        exit;
      end;
      on E: Exception do
      begin
        ShowMessage('�ٿ�ε��߿� �ý��� ������ �߻��߽��ϴ�.' + #13#10#13#10 + E.Message);
        result := -1;
        exit;
      end;
    end;
  finally
    AStream.Free;
  end;
  FileSetDate(TempPath, DateTimeToFileDate(ADownRec.DateTime));

  if ExtractFileName(ADownRec.Path)=ExtractFileName(ParamStr(0)) then exit;
  // �ڱ� �ڽ��� �̵���Ű�� �ʰ� ��ŵ�Ѵ� : ProgramToRun ���α׷����� �̵����Ѿ� �� ��.

  RealPath := GetLocalPath(ADownRec.Path);
  if Copy(ADownRec.Path, 1, Length(SSysDirSymbol)+1) = SSysDirSymbol+'\' then
    RealPath := SystemDirectory + Copy(ADownRec.Path, Length(SSysDirSymbol)+1, 1000)
  else
    RealPath := CurPath + ADownRec.Path;
  ForceDirectories(ExtractFilePath(RealPath));
  if FileExists(RealPath) then DeleteFile(RealPath);
  MoveFile(PChar(TempPath), PChar(RealPath));
end;

function TDownloadMainForm.GetLocalPath(ServerPath: string): string;
begin
  if Copy(ServerPath, 1, Length(SSysDirSymbol)+1) = SSysDirSymbol+'\' then
    result := SystemDirectory + Copy(ServerPath, Length(SSysDirSymbol)+1, 1000)
  else
    result := CurPath + ServerPath;
  if LowerCase(ExtractFileExt(result))='.zip' then
    result := Copy(result, 1, Length(result)-4);
  // ����� ���Ϸ� ���׷��̵��ϴ� ����� �ҽ� ���� ����� ������. ���� �ٽ� �߰� ����.
end;

procedure TDownloadMainForm.FileSizeChange(Sender: TObject; OldPos, NewPos: integer);
begin
  CurrProgressBar.Position := NewPos;
  TotalProgressBar.Position := TotalProgressBar.Position + (NewPos-OldPos);
  Application.ProcessMessages;
end;

end.
