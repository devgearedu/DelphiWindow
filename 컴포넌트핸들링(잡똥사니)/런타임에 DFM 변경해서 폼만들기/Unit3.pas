unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TForm3 = class(TForm)
    Button2: TButton;
    Button1: TButton;
    Label1: TLabel;
    Memo1: TMemo;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

uses Unit2;

{$R *.dfm}

{리소스에서 DFM을 찾아서 프로퍼티를 수정해서 콤포넌트에 적용한다.}

function InternalReadComponentRes(const ResName: String; HInst: THandle; var Instance: TComponent): Boolean;
var
  HRsrc: THandle;
  ResStream: TStream;
  TextStream: TStream;
  NewResStream: TStream;
  S: String;
begin
  if HInst = 0 then HInst := HInstance;
  HRsrc := FindResource(HInst, PChar(ResName), RT_RCDATA);
  Result := HRsrc <> 0;
  if not Result then Exit;

  TextStream := TMemoryStream.Create;
  ResStream := TResourceStream.Create(HInst, ResName, RT_RCDATA);
  NewResStream := TMemoryStream.Create;
  try
    ResStream.Position := 0;
    ObjectBinaryToText( ResStream, TextStream );
    SetLength( S, TextStream.Size );
    TextStream.Position := 0;
    TextStream.Read( S[1], TextStream.Size );


    
   {DFM에서 fsMDIChild를 fsNormal로 바꾸고
    Visible를 True에서 False로 바꾼다.
    이 부분을 원하는대로 수정해서 사용하면 된다.}
    S := StringReplace( S, 'FormStyle = fsMDIChild', 'FormStyle = fsNormal', [rfReplaceAll] );
    S := StringReplace( S, 'Visible = True', 'Visible = False', [rfReplaceAll] );



    TextStream.Size := 0;
    TextStream.Write( S[1], Length(S) );

    TextStream.Position := 0;
    ObjectTextToBinary( TextStream, NewResStream );
    NewResStream.Position := 0;

    Instance := NewResStream.ReadComponent(Instance);
  finally
    ResStream.Free;
    TextStream.Free;
    NewResStream.Free;
  end;

  Result := True;
end;

function InitInheritedComponent(Instance: TComponent; RootAncestor: TClass): Boolean;

  function InitComponent(ClassType: TClass): Boolean;
  begin
    Result := False;
    if (ClassType = TComponent) or (ClassType = RootAncestor) then Exit;
    Result := InitComponent(ClassType.ClassParent);
    Result := InternalReadComponentRes(ClassType.ClassName, FindResourceHInstance(FindClassHInstance(ClassType)), Instance) or Result;
  end;

var
  LocalizeLoading: Boolean;
begin
  GlobalNameSpace.BeginWrite;
  try
    LocalizeLoading := (Instance.ComponentState * [csInline, csLoading]) = [];
    if LocalizeLoading then BeginGlobalLoading;
    try
      Result := InitComponent(Instance.ClassType);
      if LocalizeLoading then NotifyGlobalLoading;
    finally
      if LocalizeLoading then EndGlobalLoading;
    end;
  finally
    GlobalNameSpace.EndWrite;
  end;
end;

type
  AForm = class(TForm);

function CreateFormFromNewDfm(Owner: TComponent; FormClass: TFormClass): TForm;
resourcestring
  SResNotFound = 'Resource %s not found';
type
  PFormState = ^TFormState;
var
  FormState: PFormState;
begin
  GlobalNameSpace.BeginWrite;
  try
    Result := FormClass.CreateNew( Owner );

    if (Result.ClassType <> TForm) and not (csDesigning in Result.ComponentState) then
     begin
       FormState := @Result.FormState;
       Include( FormState^, fsCreating );
       try
         if not InitInheritedComponent( Result, TForm ) then
          raise EResNotFound.CreateFmt(SResNotFound, [Result.ClassName]);
      finally
        Exclude( FormState^, fsCreating );
      end;
      if Result.OldCreateOrder then AForm(Result).DoCreate;
     end;
  finally
    GlobalNameSpace.EndWrite;
  end;
end;

procedure TForm3.Button1Click(Sender: TObject);
begin
  TForm2.Create( nil );
end;

procedure TForm3.Button2Click(Sender: TObject);
var
  Form2: TForm;
begin
  Form2 := CreateFormFromNewDfm( nil, TForm2 );

  Form2.Left := ( Screen.Width - Form2.Width ) div 2;
  Form2.Top := ( Screen.Height - Form2.Height ) div 2;

  Form2.Show;
end;

end.
