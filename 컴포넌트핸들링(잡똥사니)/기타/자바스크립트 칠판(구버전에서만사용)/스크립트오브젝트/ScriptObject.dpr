library ScriptObject;

uses
  ComServ,
  ScriptObject_TLB in 'ScriptObject_TLB.pas',
  TestObjectImpl in 'TestObjectImpl.pas' {TestObject: CoClass},
  BK_Board in '..\VCL\BK_Board.pas';

{$E ocx}

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
