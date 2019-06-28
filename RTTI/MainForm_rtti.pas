unit MainForm_rtti;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

type
  TForm17 = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    ListBox1: TListBox;
    Button1: TButton;
    btnTarget: TButton;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure btnTargetClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form17: TForm17;

implementation

{$R *.dfm}

uses RTTI, uDemo;

procedure TForm17.btnTargetClick(Sender: TObject);
begin
  ShowMessage('您呼叫我嗎?');
end;

procedure TForm17.Button1Click(Sender: TObject);
var
  ctx: TRttiContext;
  t: TRttiType;
  p: TRttiProperty;
  a: TArray<TRttiMethod>;
  m: TRttiMethod;
  f: TRttiField;
  n: string;
begin
  ctx := TRttiContext.Create;
  try
    t := ctx.GetType(TButton);

    ListBox1.Items.Add('Type: ' + t.Name);
    ListBox1.Items.Add('Methods:');
    a := t.GetMethods;
    for m in a do
    begin
      n := m.ToString;
      ListBox1.Items.Add('  ' +  n);
    end;

    ListBox1.Items.Add('Properties:');
    for p in t.GetProperties do
      ListBox1.Items.Add('  ' +  p.ToString);

    ListBox1.Items.Add('Fields:');
    for f in t.GetFields do
      ListBox1.Items.Add('  ' +  f.ToString);
  finally
    ctx.Free;
  end;

end;

procedure TForm17.Button3Click(Sender: TObject);
var
  ctx: TRttiContext;
  m: TRttiMethod;
  aDemoObj : TDemoClass;
begin
  ctx := TRttiContext.Create;
  aDemoObj := TDemoClass.Create;
  try
    ctx.GetType(TDemoClass).GetField('FCaption').SetValue(aDemoObj, '動態?定');

    m := ctx.GetType(TDemoClass).GetMethod('SetCaption');
    m.Invoke(aDemoObj, [btnTarget]);

    m := ctx.GetType(TDemoClass).GetMethod('CallButtonClick');
    m.Invoke(aDemoObj, [btnTarget]);
  finally
    ctx.Free;
    aDemoObj.Free;
  end;
end;

end.
