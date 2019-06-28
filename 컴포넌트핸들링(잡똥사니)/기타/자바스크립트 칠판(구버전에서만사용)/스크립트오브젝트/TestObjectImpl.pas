unit TestObjectImpl;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  Windows, ActiveX, Classes, Controls, Graphics, Menus, Forms, StdCtrls,
  ComServ, StdVCL, AXCtrls, ScriptObject_TLB, ExtCtrls, BK_Board;

type
  TTestObject = class(TActiveXControl, ITestObject)
  private
    FBoard: TBK_Board;
  protected
    procedure DefinePropertyPages(DefinePropertyPage: TDefinePropertyPage); override;
    procedure EventSinkChanged(const EventSink: IUnknown); override;
    function Get_GetItemProperty(ItemIndex: Integer; const PropertyName: WideString): Integer; safecall;
    procedure SetItemProperty(ItemIndex: Integer; const PropertyName: WideString; PropertyValue: Integer); safecall;
    procedure SetBoard(BK_Board: Integer); safecall;
    function Get_ItemCount: Integer; safecall;
  end;

  TTestWindow = class(TActiveXControl, ITestWindow)
  private
    FForm: TForm;
    FStrigns: TStrings;
  protected
    procedure Close; safecall;
    procedure SetForm(Form: Integer); safecall;
    procedure alert(const S: WideString); safecall;
    procedure OnError(const Msg, URL: WideString; Line: Integer); safecall;
    procedure SetLoger(Strings: Integer); safecall;
    procedure ProcessMessages; safecall;
  end;

implementation

uses
  ComObj, Dialogs, SysUtils;

{ TTestObject }

procedure TTestObject.DefinePropertyPages(DefinePropertyPage: TDefinePropertyPage);
begin
end;

procedure TTestObject.EventSinkChanged(const EventSink: IUnknown);
begin
end;

function TTestObject.Get_GetItemProperty(ItemIndex: Integer; const PropertyName: WideString): Integer;
var
  Item: TBoardItem;
  PropName: String;
begin
  if FBoard <> nil then
   begin
     Item := FBoard.Items[ ItemIndex ];
     PropName := LowerCase( PropertyName );

     if PropName = 'left' then Result := Item.Left else
     if PropName = 'top' then Result := Item.Top else
     if PropName = 'right' then Result := Item.Right else
     if PropName = 'bottom' then Result := Item.Bottom else
     if PropName = 'color' then Result := ColorToRGB( Item.PenColor )
                            else Result := 0;
   end
  else
   Result := 0;
end;

procedure TTestObject.SetItemProperty(ItemIndex: Integer; const PropertyName: WideString; PropertyValue: Integer);
var
  Item: TBoardItem;
  PropName: String;
begin
  if FBoard <> nil then
   begin
     Item := FBoard.Items[ ItemIndex ];
     PropName := LowerCase( PropertyName );

     if PropName = 'left' then Item.Left := PropertyValue else
     if PropName = 'top' then Item.Top := PropertyValue else
     if PropName = 'right' then Item.Right := PropertyValue else
     if PropName = 'bottom' then Item.Bottom := PropertyValue else
     if PropName = 'color' then Item.PenColor := PropertyValue;
   end;
end;

procedure TTestObject.SetBoard(BK_Board: Integer);
begin
  FBoard := TBK_Board( BK_Board );
end;

{ TTestWindow }

procedure TTestWindow.Close;
begin
  FForm.Close;
  Application.Terminate;
end;

procedure TTestWindow.SetForm(Form: Integer);
begin
  FForm := TForm( Form );
end;

procedure TTestWindow.alert(const S: WideString);
begin
  ShowMessage( S );
end;

procedure TTestWindow.OnError(const Msg, URL: WideString; Line: Integer);
begin
  if FStrigns <> nil then
   FStrigns.Add( '[Error] ' + IntToStr( Line ) + '∂Û¿Œ  ' + Msg );
end;

procedure TTestWindow.SetLoger(Strings: Integer);
begin
  FStrigns := TStrings( Strings );
end;

function TTestObject.Get_ItemCount: Integer;
begin
  Result := FBoard.Items.Count;
end;

procedure TTestWindow.ProcessMessages;
begin
  Application.ProcessMessages;
end;

initialization
  TActiveXControlFactory.Create(
    ComServer,
    TTestObject,
    TPanel,
    Class_TestObject,
    1,
    '',
    OLEMISC_SIMPLEFRAME or OLEMISC_ACTSLIKELABEL,
    tmApartment);


  TActiveXControlFactory.Create(
    ComServer,
    TTestWindow,
    TPanel,
    CLASS_TestWindow,
    1,
    '',
    OLEMISC_SIMPLEFRAME or OLEMISC_ACTSLIKELABEL,
    tmApartment);

end.
