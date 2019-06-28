unit ScriptObject_TLB;

// ************************************************************************ //
// WARNING                                                                    
// -------                                                                    
// The types declared in this file were generated from data read from a       
// Type Library. If this type library is explicitly or indirectly (via        
// another type library referring to this type library) re-imported, or the   
// 'Refresh' command of the Type Library Editor activated while editing the   
// Type Library, the contents of this file will be regenerated and all        
// manual modifications will be lost.                                         
// ************************************************************************ //

// PASTLWTR : 1.2
// File generated on 2009-04-29 14:09:46 from Type Library described below.

// ************************************************************************  //
// Type Lib: D:\My Documents\My Delphis\Delphi7\시험\자바스크립트 칠판\스크립트오브젝트\ScriptObject.tlb (1)
// LIBID: {D437A2A1-1D86-48E3-A4F3-3051489E5CBA}
// LCID: 0
// Helpfile: 
// HelpString: ScriptObject Library
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINDOWS\SYSTEM32\STDOLE2.TLB)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
interface

uses Windows, ActiveX, Classes, Graphics, OleCtrls, StdVCL, Variants;
  

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  ScriptObjectMajorVersion = 1;
  ScriptObjectMinorVersion = 0;

  LIBID_ScriptObject: TGUID = '{D437A2A1-1D86-48E3-A4F3-3051489E5CBA}';

  IID_ITestObject: TGUID = '{C51BD907-F68B-487E-B36F-C3E92BEC3677}';
  CLASS_TestObject: TGUID = '{3C5E0F32-70EE-4513-9CCF-C5808ECC70E8}';
  IID_ITestWindow: TGUID = '{A834DE72-BC87-4126-818A-5DAE6B226B18}';
  CLASS_TestWindow: TGUID = '{B0FD9EE5-6F26-47B3-978E-61023FA27A09}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  ITestObject = interface;
  ITestObjectDisp = dispinterface;
  ITestWindow = interface;
  ITestWindowDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  TestObject = ITestObject;
  TestWindow = ITestWindow;


// *********************************************************************//
// Interface: ITestObject
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {C51BD907-F68B-487E-B36F-C3E92BEC3677}
// *********************************************************************//
  ITestObject = interface(IDispatch)
    ['{C51BD907-F68B-487E-B36F-C3E92BEC3677}']
    function Get_GetItemProperty(ItemIndex: Integer; const PropertyName: WideString): Integer; safecall;
    procedure SetItemProperty(ItemIndex: Integer; const PropertyName: WideString; 
                              PropertyValue: Integer); safecall;
    procedure SetBoard(BK_Board: Integer); safecall;
    function Get_ItemCount: Integer; safecall;
    property GetItemProperty[ItemIndex: Integer; const PropertyName: WideString]: Integer read Get_GetItemProperty;
    property ItemCount: Integer read Get_ItemCount;
  end;

// *********************************************************************//
// DispIntf:  ITestObjectDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {C51BD907-F68B-487E-B36F-C3E92BEC3677}
// *********************************************************************//
  ITestObjectDisp = dispinterface
    ['{C51BD907-F68B-487E-B36F-C3E92BEC3677}']
    property GetItemProperty[ItemIndex: Integer; const PropertyName: WideString]: Integer readonly dispid 203;
    procedure SetItemProperty(ItemIndex: Integer; const PropertyName: WideString; 
                              PropertyValue: Integer); dispid 204;
    procedure SetBoard(BK_Board: Integer); dispid 205;
    property ItemCount: Integer readonly dispid 201;
  end;

// *********************************************************************//
// Interface: ITestWindow
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A834DE72-BC87-4126-818A-5DAE6B226B18}
// *********************************************************************//
  ITestWindow = interface(IDispatch)
    ['{A834DE72-BC87-4126-818A-5DAE6B226B18}']
    procedure close; safecall;
    procedure SetForm(Form: Integer); safecall;
    procedure alert(const S: WideString); safecall;
    procedure OnError(const Msg: WideString; const URL: WideString; Line: Integer); safecall;
    procedure SetLoger(Strings: Integer); safecall;
    procedure ProcessMessages; safecall;
  end;

// *********************************************************************//
// DispIntf:  ITestWindowDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A834DE72-BC87-4126-818A-5DAE6B226B18}
// *********************************************************************//
  ITestWindowDisp = dispinterface
    ['{A834DE72-BC87-4126-818A-5DAE6B226B18}']
    procedure close; dispid 201;
    procedure SetForm(Form: Integer); dispid 202;
    procedure alert(const S: WideString); dispid 203;
    procedure OnError(const Msg: WideString; const URL: WideString; Line: Integer); dispid 204;
    procedure SetLoger(Strings: Integer); dispid 205;
    procedure ProcessMessages; dispid 206;
  end;


// *********************************************************************//
// OLE Control Proxy class declaration
// Control Name     : TTestObject
// Help String      : TestObject Control
// Default Interface: ITestObject
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (34) CanCreate Control
// *********************************************************************//
  TTestObject = class(TOleControl)
  private
    FIntf: ITestObject;
    function  GetControlInterface: ITestObject;
  protected
    procedure CreateControl;
    procedure InitControlData; override;
    function Get_GetItemProperty(ItemIndex: Integer; const PropertyName: WideString): Integer;
  public
    procedure SetItemProperty(ItemIndex: Integer; const PropertyName: WideString; 
                              PropertyValue: Integer);
    procedure SetBoard(BK_Board: Integer);
    property  ControlInterface: ITestObject read GetControlInterface;
    property  DefaultInterface: ITestObject read GetControlInterface;
    property GetItemProperty[ItemIndex: Integer; const PropertyName: WideString]: Integer read Get_GetItemProperty;
    property ItemCount: Integer index 201 read GetIntegerProp;
  published
    property Anchors;
    property  Align;
    property  DragCursor;
    property  DragMode;
    property  ParentShowHint;
    property  PopupMenu;
    property  ShowHint;
    property  TabOrder;
    property  Visible;
    property  OnDragDrop;
    property  OnDragOver;
    property  OnEndDrag;
    property  OnEnter;
    property  OnExit;
    property  OnStartDrag;
  end;


// *********************************************************************//
// OLE Control Proxy class declaration
// Control Name     : TTestWindow
// Help String      : 
// Default Interface: ITestWindow
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
  TTestWindow = class(TOleControl)
  private
    FIntf: ITestWindow;
    function  GetControlInterface: ITestWindow;
  protected
    procedure CreateControl;
    procedure InitControlData; override;
  public
    procedure close;
    procedure SetForm(Form: Integer);
    procedure alert(const S: WideString);
    procedure OnError(const Msg: WideString; const URL: WideString; Line: Integer);
    procedure SetLoger(Strings: Integer);
    procedure ProcessMessages;
    property  ControlInterface: ITestWindow read GetControlInterface;
    property  DefaultInterface: ITestWindow read GetControlInterface;
  published
    property Anchors;
    property  Align;
    property  DragCursor;
    property  DragMode;
    property  ParentShowHint;
    property  PopupMenu;
    property  ShowHint;
    property  TabOrder;
    property  Visible;
    property  OnDragDrop;
    property  OnDragOver;
    property  OnEndDrag;
    property  OnEnter;
    property  OnExit;
    property  OnStartDrag;
  end;

procedure Register;

resourcestring
  dtlServerPage = 'Servers';

  dtlOcxPage = 'ActiveX';

implementation

uses ComObj;

procedure TTestObject.InitControlData;
const
  CControlData: TControlData2 = (
    ClassID: '{3C5E0F32-70EE-4513-9CCF-C5808ECC70E8}';
    EventIID: '';
    EventCount: 0;
    EventDispIDs: nil;
    LicenseKey: nil (*HR:$00000000*);
    Flags: $00000000;
    Version: 401);
begin
  ControlData := @CControlData;
end;

procedure TTestObject.CreateControl;

  procedure DoCreate;
  begin
    FIntf := IUnknown(OleObject) as ITestObject;
  end;

begin
  if FIntf = nil then DoCreate;
end;

function TTestObject.GetControlInterface: ITestObject;
begin
  CreateControl;
  Result := FIntf;
end;

function TTestObject.Get_GetItemProperty(ItemIndex: Integer; const PropertyName: WideString): Integer;
begin
    Result := DefaultInterface.GetItemProperty[ItemIndex, PropertyName];
end;

procedure TTestObject.SetItemProperty(ItemIndex: Integer; const PropertyName: WideString; 
                                      PropertyValue: Integer);
begin
  DefaultInterface.SetItemProperty(ItemIndex, PropertyName, PropertyValue);
end;

procedure TTestObject.SetBoard(BK_Board: Integer);
begin
  DefaultInterface.SetBoard(BK_Board);
end;

procedure TTestWindow.InitControlData;
const
  CControlData: TControlData2 = (
    ClassID: '{B0FD9EE5-6F26-47B3-978E-61023FA27A09}';
    EventIID: '';
    EventCount: 0;
    EventDispIDs: nil;
    LicenseKey: nil (*HR:$00000000*);
    Flags: $00000000;
    Version: 401);
begin
  ControlData := @CControlData;
end;

procedure TTestWindow.CreateControl;

  procedure DoCreate;
  begin
    FIntf := IUnknown(OleObject) as ITestWindow;
  end;

begin
  if FIntf = nil then DoCreate;
end;

function TTestWindow.GetControlInterface: ITestWindow;
begin
  CreateControl;
  Result := FIntf;
end;

procedure TTestWindow.close;
begin
  DefaultInterface.close;
end;

procedure TTestWindow.SetForm(Form: Integer);
begin
  DefaultInterface.SetForm(Form);
end;

procedure TTestWindow.alert(const S: WideString);
begin
  DefaultInterface.alert(S);
end;

procedure TTestWindow.OnError(const Msg: WideString; const URL: WideString; Line: Integer);
begin
  DefaultInterface.OnError(Msg, URL, Line);
end;

procedure TTestWindow.SetLoger(Strings: Integer);
begin
  DefaultInterface.SetLoger(Strings);
end;

procedure TTestWindow.ProcessMessages;
begin
  DefaultInterface.ProcessMessages;
end;

procedure Register;
begin
  RegisterComponents(dtlOcxPage, [TTestObject, TTestWindow]);
end;

end.
