unit UMemo_AutoHeight;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, ComCtrls;

type

{ TMemo }

  TMemo = class(StdCtrls.TMemo)
  private
    FAutoSizeHeight: Integer;
    FAutoSizeMargin: Integer;
    procedure WMKeyDown(var Message: TWMKeyDown); message WM_KEYDOWN;
    procedure WMChar(var Message: TWMChar); message WM_CHAR;
    procedure WMIMEComposition(var Message: TMessage); message WM_IME_COMPOSITION;
    procedure WMPaste(var Message: TMessage); message WM_PASTE;
    procedure WMCut(var Message: TMessage); message WM_CUT;
    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure RequestResize;
  end;

{ TForm1 }

  TForm1 = class(TForm)
    Memo: TMemo;
  private
  public
  end;

var
  Form1: TForm1;

implementation

uses
  IMM;

{$R *.dfm}

{ TMemo }

procedure TMemo.WMKeyDown(var Message: TWMKeyDown);
begin
  case Message.CharCode of
  VK_DELETE: begin
               Lines.BeginUpdate;
               try
                 inherited;
                 RequestResize;
               finally
                 Lines.EndUpdate;
               end;
             end;
  else       inherited;
  end;
end;

procedure TMemo.WMChar(var Message: TWMChar);
begin
  Lines.BeginUpdate;
  try
    inherited;
    RequestResize;
  finally
    Lines.EndUpdate;
  end;
end;

procedure TMemo.WMIMEComposition(var Message: TMessage);
var
  OldHeight: Integer;
  Key: Byte;
  IMEContext: HIMC;
  Size: Integer;
  S: WideChar;
begin
  Key := Ord('R');
  IMEContext := ImmGetContext( Handle );
  if IMEContext <> 0 then
   try
     if Message.LParam and GCS_COMPSTR <> 0 then
      begin
        Size := ImmGetCompositionStringW( IMEContext, GCS_COMPSTR, nil, 0 );
        if Size > 0 then
         begin
           ImmGetCompositionStringW( IMEContext, GCS_COMPSTR, @S, 2 );
           if ( S <> #0 ) and ( 12593 <= Word(S) ) and ( Word(S) <= 12662 ) then Key := Ord('K');
         end;
      end;
   finally
     ImmReleaseContext( WindowHandle, IMEContext );
   end;

  Lines.BeginUpdate;
  try
    inherited;
    OldHeight := Height;
    RequestResize;

    if OldHeight < Height then
     begin
       Keybd_Event( Key, MapVirtualKey( Key, 0 ), 0, 0 );
       Keybd_Event( Key, MapVirtualKey( Key, 0 ), KEYEVENTF_KEYUP, 0 );
       Keybd_Event( VK_BACK, MapVirtualKey( VK_BACK, 0 ), 0, 0 );
       Keybd_Event( VK_BACK, MapVirtualKey( VK_BACK, 0 ), KEYEVENTF_KEYUP, 0 );
     end;
  finally
    Lines.EndUpdate;
  end;
end;

procedure TMemo.WMPaste(var Message: TMessage);
begin
  Lines.BeginUpdate;
  try
    inherited;
    RequestResize;
  finally
    Lines.EndUpdate;
  end;
end;

procedure TMemo.WMCut(var Message: TMessage);
begin
  Lines.BeginUpdate;
  try
    inherited;
    RequestResize;
  finally
    Lines.EndUpdate;
  end;
end;

procedure TMemo.WMEraseBkgnd(var Message: TWMEraseBkgnd);
var
  Canvas: TCanvas;
  ARect: TRect;
begin
  if Message.DC <> 0 then
   begin
     ARect := ClientRect;
     ARect.Top := FAutoSizeHeight - FAutoSizeMargin;

     Canvas := TCanvas.Create;
     try
       Canvas.Handle := Message.DC;
       Canvas.Brush.Color := Color;
       Canvas.FillRect( ARect );
     finally
       Canvas.Free;
     end;
   end;
end;

procedure TMemo.RequestResize;
var
  LineCount: Integer;
  EditRect: TRect;
  NewHeight: Integer;
  RepaintParent: Boolean;
begin
  LineCount := SendMessage( Handle, EM_GETLINECOUNT, 0, 0 );

  SendMessage( Handle, EM_GETRECT, 0, LParam(@EditRect) );

  FAutoSizeMargin := 4;

  NewHeight := Abs( Font.Height ) * LineCount + FAutoSizeMargin;

  if NewHeight <> ClientHeight then
   begin
     RepaintParent := Height > NewHeight;

     FAutoSizeHeight := NewHeight;

     ClientHeight := NewHeight;

     if RepaintParent and ( Parent <> nil ) then
      Parent.Invalidate;
   end;
end;

end.
