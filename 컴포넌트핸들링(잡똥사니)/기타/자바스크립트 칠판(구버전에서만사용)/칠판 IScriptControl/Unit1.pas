unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons, Spin,
  BK_Board, ScriptObject_TLB, ComObj,
  ScriptControls, SynEditHighlighter, SynHighlighterJScript, SynEdit,
  MSHTML, OleCtrls, SynCompletionProposal;

type
  TForm1 = class(TForm)
    Button_Clear: TButton;
    Button_Delete: TButton;
    Button_Ellipse: TSpeedButton;
    Button_ItemTest: TButton;
    Button_Line: TSpeedButton;
    Button_Lines: TButton;
    Button_Move: TSpeedButton;
    Button_Rectangle: TSpeedButton;
    Button_Rectangles: TButton;
    Button_Redraw: TButton;
    Button_RoundRect: TSpeedButton;
    Button_Strings: TButton;
    Image_Border: TImage;
    Memo: TMemo;
    Panel_Black: TPanel;
    Panel_Pink: TPanel;
    Panel_SkyBlue: TPanel;
    Panel_Yellow: TPanel;
    SynJScriptSyn: TSynJScriptSyn;
    Button_Run: TButton;
    Label1: TLabel;
    Panel1: TPanel;
    Editor: TSynEdit;
    ListBox_ScriptMsg: TListBox;
    Splitter: TSplitter;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button_ClearClick(Sender: TObject);
    procedure Button_DeleteClick(Sender: TObject);
    procedure Button_ItemTestClick(Sender: TObject);
    procedure Button_LinesClick(Sender: TObject);
    procedure Button_RectanglesClick(Sender: TObject);
    procedure Button_RedrawClick(Sender: TObject);
    procedure Button_StringsClick(Sender: TObject);
    procedure Panel_WhiteMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Panel_WhiteMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ToolsClick(Sender: TObject);
    procedure Button_RunClick(Sender: TObject);
    procedure EditorSpecialLineColors(Sender: TObject; Line: Integer; var Special: Boolean; var FG, BG: TColor);
    procedure EditorChange(Sender: TObject);
    procedure EditorStatusChange(Sender: TObject; Changes: TSynStatusChanges);
    procedure ListBox_ScriptMsgDblClick(Sender: TObject);
    procedure ScriptControlError(Sender: TObject);
  private
    BK_Board: TBK_Board;
    ScriptControl: TScriptControl;
    BoardObject: ITestObject;
    FBreak: Integer;
    procedure RegisterOCX;
    procedure RunScript;
    procedure ShowBreak;
    procedure ClearBreak;
    procedure ShowLoger;
    procedure HideLoger;
  public
  end;

var
  Form1: TForm1;

implementation

uses
  Variants, ActiveX;
  
{$R *.DFM}

procedure TForm1.RegisterOCX;
var
  OCXFileName: String;
  DLL: THandle;
  DllRegisterServer: function: HResult; stdcall;
begin
  OCXFileName := ExtractFilePath( Application.ExeName ) + 'ScriptObject.ocx';
  if FileExists( OCXFileName ) then
   begin
     DLL := LoadLibrary( PChar( OCXFileName ) );
     try
       DllRegisterServer := GetProcAddress( DLL, 'DllRegisterServer' );
       DllRegisterServer;
     finally
       FreeLibrary( DLL );
     end;
   end;
end;

procedure TForm1.RunScript;
var
  Strings: TStrings;
  i: Integer;
begin
  HideLoger;
  ClearBreak;
  try
    if BoardObject = nil then
     begin
       BoardObject := CreateComObject(CLASS_TestObject) as ITestObject;
       BoardObject.SetBoard( Integer(BK_Board) );
     end;

    ScriptControl.Reset;
    try
      ScriptControl.AddObject( 'board', BoardObject, False );

      Strings := TStringList.Create;
      try
        for i := 0 to Editor.Lines.Count - 1 do
         Strings.Add( Editor.Lines[i] );

        ScriptControl.AddCode( Strings.Text );

      finally
        Strings.Free;
      end;

    except
    end;
  finally
    ShowLoger;
  end;
end;

function MsgToLine(const S: String): Integer;
var
  S1: String;
  PosResult: Integer;
begin
  S1 := S;
  Delete( S1, 1, 8 );

  PosResult := Pos( '라인', S1 );
  Delete( S1, PosResult, Length( S1 ) - PosResult + 1 );

  try
    Result := StrToInt( S1 );
  except
    Result := 1;
  end;
end;

procedure TForm1.ShowBreak;
begin
  ClearBreak;
  
  if ListBox_ScriptMsg.Items.Count > 0 then
   begin
     FBreak := MsgToLine( ListBox_ScriptMsg.Items[ ListBox_ScriptMsg.ItemIndex ] );

     Editor.OnStatusChange := nil;

     if Editor.TopLine > FBreak then Editor.TopLine := FBreak;
     if Editor.TopLine + Editor.LinesInWindow - 1 < FBreak then Editor.TopLine := FBreak;

     Editor.CaretXY := Point( 1, FBreak );
     Editor.SetFocus;

     Editor.InvalidateLine( FBreak );
     Editor.OnStatusChange := EditorStatusChange;
   end;
end;

procedure TForm1.ClearBreak;
begin
  if FBreak >= 0 then
   begin
     FBreak := -1;
     Editor.Repaint;
   end;
end;

procedure TForm1.ShowLoger;
begin
  if ListBox_ScriptMsg.Items.Count > 0 then
   begin
     ListBox_ScriptMsg.ItemIndex := 0;
     ListBox_ScriptMsg.Visible := True;
     Splitter.Visible := True;
     Splitter.Top := ListBox_ScriptMsg.Top - Splitter.Height;
   end;
end;

procedure TForm1.HideLoger;
begin
  ListBox_ScriptMsg.Visible := False;
  Splitter.Visible := False;
  ListBox_ScriptMsg.Items.Clear;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  RegisterOCX;

  BK_Board := TBK_Board.Create( Self );
  BK_Board.Parent := Self;
  BK_Board.Left := 18;
  BK_Board.Top := 22;
  BK_Board.Width := 499;
  BK_Board.Height := 247;
  BK_Board.DrawTool := dtRectangle;
  BK_Board.NewItemColor := clBlue;  


  ScriptControl := TScriptControl.Create( nil );
  ScriptControl.Language := 'JScript';
  ScriptControl.OnError := ScriptControlError;

  FBreak := -1;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  ScriptControl.Free;
end;

procedure TForm1.ToolsClick(Sender: TObject);
begin
  BK_Board.DrawTool := TDrawTool( TComponent( Sender ).Tag );
end;

procedure TForm1.Button_LinesClick(Sender: TObject);
begin
  BK_Board.Items.AddLine( 10, 10, 50, 50, Panel_Black.Color );
  BK_Board.Items.AddLine( 20, 10, 50, 50, Panel_SkyBlue.Color );
  BK_Board.Items.AddLine( 30, 10, 50, 50, Panel_Yellow.Color );
  BK_Board.Items.AddLine( 50, 10, 50, 50, Panel_Pink.Color );
end;

procedure TForm1.Button_StringsClick(Sender: TObject);
var
  ABoardText: TBoardText;
begin
  ABoardText := TBoardText.Create;
  with ABoardText do
   begin
     Left := 200;
     Top := 35;
     FontColor := clYellow;
     Lines.Assign( Memo.Lines );
   end;
  BK_Board.Items.Add( ABoardText );
end;

procedure TForm1.Button_ClearClick(Sender: TObject);
begin
  BK_Board.Items.Clear;
end;

procedure TForm1.Button_RectanglesClick(Sender: TObject);
begin
  BK_Board.Items.AddRectangle( 30, 70, 150, 150, Panel_Black.Color );
  BK_Board.Items.AddRectangle( 40, 75, 150, 150, Panel_SkyBlue.Color );
  BK_Board.Items.AddRectangle( 50, 80, 150, 150, Panel_Yellow.Color );
  BK_Board.Items.AddRectangle( 70, 90, 150, 150, Panel_Pink.Color );
end;

procedure TForm1.Button_ItemTestClick(Sender: TObject);
begin
  BK_Board.Items[ 3 ].Left := BK_Board.Items[ 3 ].Left + 2;
end;

procedure TForm1.Button_RedrawClick(Sender: TObject);
begin
  BK_Board.Redraw;
end;

procedure TForm1.Button_DeleteClick(Sender: TObject);
begin
  if ( BK_Board.DrawTool = dtSelect ) and ( BK_Board.Selected >= 0 ) then
   BK_Board.Items.Delete( BK_Board.Selected );
end;

procedure TForm1.Panel_WhiteMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then BK_Board.NewItemColor := TPanel( Sender ).Color;

  TPanel( Sender ).BevelOuter := bvLowered;
end;

procedure TForm1.Panel_WhiteMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  TPanel( Sender ).BevelOuter := bvNone;
end;

procedure TForm1.Button_RunClick(Sender: TObject);
begin
  RunScript;
end;

procedure TForm1.EditorSpecialLineColors(Sender: TObject; Line: Integer; var Special: Boolean; var FG, BG: TColor);
begin
  if Line = FBreak then
   begin
     Special := True;
     FG := clHighlightText;
     BG := clMaroon;
   end
  else
   Special := False;
end;

procedure TForm1.EditorChange(Sender: TObject);
begin
  ClearBreak;
end;

procedure TForm1.EditorStatusChange(Sender: TObject; Changes: TSynStatusChanges);
begin
  if ( scCaretX in Changes ) or ( scCaretY in Changes ) then ClearBreak;
end;

procedure TForm1.ListBox_ScriptMsgDblClick(Sender: TObject);
begin
  ShowBreak;
end;

procedure TForm1.ScriptControlError(Sender: TObject);
var
  ScriptError: IScriptError;
begin
  Beep;
  ScriptError := TScriptControl(Sender).Error;

  ClearBreak;
  FBreak := ScriptError.Get_Line;

  Editor.CaretX := ScriptError.Get_Column + 1;
  Editor.CaretY := ScriptError.Get_Line;

  Editor.Repaint;
  Editor.SetFocus;

  ListBox_ScriptMsg.Items.Add( '스크립트 오류'#13#13 + IntToStr( ScriptError.Get_Line ) + ' 라인(' + IntToStr( ScriptError.Get_Column ) + ') ' + ScriptError.Get_Description );
end;

end.
