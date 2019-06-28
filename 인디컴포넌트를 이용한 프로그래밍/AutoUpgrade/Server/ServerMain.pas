unit ServerMain;

interface

uses
  SysUtils, Classes, HTTPApp;

type
  TAutoUpgradeWebModule = class(TWebModule)
    procedure WebModule4WebActionItem1Action(Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
  private
    RootPath,
    FileList: string;
    procedure DoFindFiles(AFileMask: string);
  public
    { Public declarations }
  end;

var
  AutoUpgradeWebModule: TAutoUpgradeWebModule;

implementation

{$R *.dfm}

const
  SAutoUpgradeHeader = 'AutoUpgrade Server' + #13#10;

procedure TAutoUpgradeWebModule.WebModule4WebActionItem1Action(Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  FolderToDownload: string;
begin
  Response.ContentType := 'text/plain';
  Response.Content := SAutoUpgradeHeader;

  FolderToDownload := Trim(Request.QueryFields.Values['path']);
  if Request.QueryFields.Values['path']='' then exit;

  RootPath := ExtractFilePath(GetModuleName(hinstance)) + FolderToDownload + '\';
  if Copy(RootPath, 1, 4)= '\\?\' then RootPath := Copy(RootPath, 5, 1000);

  FileList := '';
  DoFindFiles(RootPath + '*.*');

  Response.Content := Response.Content + FileList;
end;

procedure TAutoUpgradeWebModule.DoFindFiles(AFileMask: string);

  procedure DoFileFound(ACurrentPath: string; var SearchRec: TSearchRec);
  var
    APath: string;
    ADate: TDateTime;
  begin
    APath := Copy(ACurrentPath, Length(RootPath)+1, 100000);
    ADate := FileDateToDateTime(SearchRec.Time);
    FileList := FileList
              + APath + SearchRec.Name + #9
              + IntToStr(SearchRec.Size) + #9
              + FormatDateTime('yyyy-mm-dd hh:nn:ss', ADate) + #13#10;
  end;

var
  Sr: TSearchRec;
  CurrentPath: string;
begin
  CurrentPath := ExtractFilePath(AFileMask);
  if DirectoryExists(CurrentPath)=false then exit;

  // ���� �˻�
  if SysUtils.FindFirst(AFileMask, faAnyFile and not faDirectory, Sr)=0 then
  begin
    repeat
      DoFileFound(CurrentPath, Sr);
    until SysUtils.FindNext(Sr)<>0;
    SysUtils.FindClose(Sr);
  end;

  // ������丮 �˻�
  if SysUtils.FindFirst(CurrentPath + '*.*', faDirectory, Sr) = 0 then
  begin
    repeat
      if ((Sr.Attr and faDirectory) = faDirectory) and (Sr.Name[1] <> '.') then
        DoFindFiles(CurrentPath + Sr.Name + '\' + ExtractFileName(AFileMask));
    until SysUtils.FindNext(Sr)<>0;
    SysUtils.FindClose(Sr);
  end;
end;

end.

// �� ISAPI dll ����� IIS �󿡼� ����� ����Ǳ� ���ؼ���, �� ����� ����Ʈ ������ ���丮 Ȥ��
// �� ������ ���丮�� ��ġ���� �ϸ�, �ش� ���丮���� "���� (��ũ��Ʈ ����)" ��������� �����Ǿ� �־�� �մϴ�.

// ������ ���� �ٿ�ε� ��� ���ϵ��� ��ġ�� ������丮���� �߰��� ��������� "����"���� �����Ǿ�� �մϴ�.
// �̷��� �ؾ� �ϴ� ������, �ٿ�ε��ؾ� �� ���ϵ� �߿� exe�� dll�� ���ԵǾ� ���� ���,
// �ٿ�ε� ��û�� �޾��� �� �ش� ���丮�� ���� ������ ������ ������ cgi�� ������ �����ϰų�(.exe)
// �� ���ó�� ISAPI�� ������ �����Ͽ�(.dll) �����Ϸ��� �õ��ϱ� �����Դϴ�.
// �� ������ �� ������ ���Ȱ��� ū ������ �����Ƿ� �� �����ؾ� �մϴ�.

// IIS 6.0 (������ 2003 ����) �̻󿡼��� �ý��ۿ� �̹� ��ϵ� Ȯ����(MIME Ÿ��) �̿ܿ���
// IIS���� �ٿ�ε尡 ���� �ʴ� ������ �ֽ��ϴ�. �� ������ �ذ��Ϸ���,
//1. ������ ������������ ���ͳ� ���� ����(IIS) ���� ������ �����ŵ�ϴ�.
//2. ���� ��ǻ�͸� ������ �� �Ӽ� â�� �����մϴ�.
//3. MIME ���� ��ư�� Ŭ���մϴ�.
//4. �� ���� ��ư�� Ŭ���մϴ�.
//5. Ȯ��� *�� �Է��մϴ�.
//6. MIME ���Ŀ� application/octet-stream�� �Է��մϴ�.
//7. ���� ������ ���������� ���� �Ŵ������� IIS Admin Service�� World Wide Web Publishing Service�� ������ؾ� ����˴ϴ�.

