unit ShowApp;

interface

const
  SA_SUCCESS  = 0; {성공적으로 활성화 했음                        }
  SA_NOTEXIST = 1; {EXE가 실행되어 있지 않거나 Window가 없는 EXE임}
  SA_INACTIVE = 2; {EXE가 실행되어 있으나 활성화할 수 없음        }

function ShowApplication(const ExeName: String): Integer;  {ExeName: 경로명이 없는 EXE명 ex) notepad.exe }

implementation

uses
  Windows, Messages, SysUtils, TlHelp32;

function GetProcessExeName(ProcessId: DWord): String;
var
  Process32: TProcessEntry32;
  Handle: THandle;
  Next: Boolean;
function Check: Boolean;
  begin
    Result := False;
    if Process32.th32ProcessID = ProcessId then
     begin
       GetProcessExeName := Process32.szExeFile;
       Result := True;
     end;
  end;
begin
  Process32.dwSize := SizeOf( Process32 );
  Handle := CreateToolHelp32SnapShot( TH32CS_SNAPPROCESS, 0 );
  try
    Next := Process32First( Handle, Process32 );
    while Next do
     begin
       if Check then Exit;
       Next := Process32Next( Handle, Process32 );
     end;
  finally
    CloseHandle( Handle );
  end;
  Result := '';
end;

function GetWindowExeName(Wnd: HWnd): String;
var
  ProcessId: DWord;
begin
  GetWindowThreadProcessId( Wnd, @ProcessId );
  Result := GetProcessExeName( ProcessId );
end;

function GetAppWindow(Wnd: HWnd): HWnd;
var
  WindowRect: TRect;
begin
  Result := 0;
  if GetWindowLong( Wnd, GWL_STYLE ) and WS_CHILD <> 0 then Exit;
  if not IsWindowVisible( Wnd ) then Exit;
  if not GetWindowRect( Wnd, WindowRect ) then Exit;
  if ( WindowRect.Left = WindowRect.Right ) or ( WindowRect.Top = WindowRect.Bottom ) then Exit;

  while GetParent( Wnd ) <> 0 do Wnd := GetParent( Wnd );
  while GetWindow( Wnd, GW_OWNER ) <> 0 do Wnd := GetWindow( Wnd, GW_OWNER );

  Result := Wnd;
end;

var
  ShowAppExeName: String;
  ShowAppResult: Integer;

function ShowAppEnumWindowsProc(Wnd: HWnd; LParam: LParam): BOOL; stdcall;
begin
  Result := True;
  Wnd := GetAppWindow( Wnd );
  if ( Wnd <> 0 ) and ( LowerCase( GetWindowExeName( Wnd ) ) = ShowAppExeName ) then
   begin
     SetWindowPos( Wnd, HWND_TOP, 0, 0, 0, 0, SWP_NOSIZE or SWP_NOMOVE or SWP_SHOWWINDOW );

     if IsIconic( Wnd ) then
      SendMessage( Wnd, WM_SYSCOMMAND, SC_RESTORE, 0 );

     if LowerCase( GetWindowExeName( GetForegroundWindow ) ) = ShowAppExeName then ShowAppResult := SA_SUCCESS
                                                                              else ShowAppResult := SA_INACTIVE;
     Result := False;
   end;
end;

function ShowApplication(const ExeName: String): Integer;
begin
  ShowAppResult := SA_NOTEXIST;
  ShowAppExeName := LowerCase( ExeName );
  EnumDesktopWindows( 0, @ShowAppEnumWindowsProc, 0 );
  Result := ShowAppResult;
end;

end.
