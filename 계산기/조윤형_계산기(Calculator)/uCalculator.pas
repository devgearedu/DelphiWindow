unit uCalculator;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Math,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TfrmCalculator = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Button10: TButton;
    Button11: TButton;
    Button12: TButton;
    Button13: TButton;
    Button14: TButton;
    Button15: TButton;
    Button17: TButton;
    Button19: TButton;
    Button20: TButton;
    btnClear: TButton;
    btnBackspace: TButton;
    lbPrint: TListBox;
    btn_NumChage: TButton;

    procedure Number_Input(Sender: TObject);
    procedure Cal_Input(Sender: TObject);
    procedure rb_Input(Sender: TObject);
    procedure Text_Print;
    Function Cal_Value: Integer;
    Procedure Calculation(From_i, To_i: Integer);

    procedure btnBackspaceClick(Sender: TObject);
    procedure btn_NumChageClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Button10Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCalculator: TfrmCalculator;

implementation

var
  sMemory: TStringList;

{$R *.dfm}

procedure TfrmCalculator.btn_NumChageClick(Sender: TObject);
begin
  lbPrint.Items.Strings[1] := IntToStr(-1 * StrToInt(lbPrint.Items.Strings[1]));
end;

procedure TfrmCalculator.Button10Click(Sender: TObject);
var
  i, ipb, idb: Integer;
begin
  ipb := 0;
  idb := 0;

  for i := 0 to sMemory.Count - 1 do
    if sMemory.Strings[i] = '(' then
      ipb := ipb + 1
    else if sMemory.Strings[i] = ')' then
      idb := idb + 1;

  if idb <> ipb then
  begin
    ShowMessage('수식 확인을 해주세요');
    exit;
  end;

  if lbPrint.Items.Strings[1] <> '0' then
  begin
    sMemory.Add(lbPrint.Items.Strings[1]);
    Text_Print;
  end;

  Cal_Value;

  lbPrint.Items.Strings[2] := sMemory.Strings[0];
end;

procedure TfrmCalculator.Button7Click(Sender: TObject);
begin
  if Pos('.', lbPrint.Items.Strings[1]) = 0 then
    lbPrint.Items.Strings[1] := lbPrint.Items.Strings[1] +
      (Sender as TButton).Caption;
end;

procedure TfrmCalculator.btnClearClick(Sender: TObject);
begin
  lbPrint.Items.Strings[0] := '';
  lbPrint.Items.Strings[1] := '0';
  lbPrint.Items.Strings[2] := '0';
  sMemory.Clear;
  // sMemory. := 1;
end;

procedure TfrmCalculator.btnBackspaceClick(Sender: TObject);
var
  s: String;
begin
  s := lbPrint.Items.Strings[1];

  Delete(s, Length(s), 1);

  if (s = '') or (s = '0') or (s = '-') then
    s := '0'
  else
    s := IntToStr(StrToInt(s));

  lbPrint.Items.Strings[1] := s;
end;

procedure TfrmCalculator.Number_Input(Sender: TObject);
begin
  if lbPrint.Items.Strings[1] = '0' then
    lbPrint.Items.Strings[1] := '';

  lbPrint.Items.Strings[1] := lbPrint.Items.Strings[1] +
    (Sender as TButton).Caption;
end;

procedure TfrmCalculator.rb_Input(Sender: TObject);
var
  i: Integer;
  ipb, idb: Integer;
begin
  ipb := 0;
  idb := 0;

  for i := 0 to sMemory.Count - 1 do
    if sMemory.Strings[i] = '(' then
      ipb := ipb + 1
    else if sMemory.Strings[i] = ')' then
      idb := idb + 1;

  if (Sender as TButton).Caption = ')' then
  begin
    if ipb <= idb then
      exit
    else if ipb > idb then
      if StrToInt(lbPrint.Items.Strings[1]) > 0 then
      begin
        sMemory.Add(lbPrint.Items.Strings[1]);
      end;
  end
  else if (Sender as TButton).Caption = '(' then
  begin
    if sMemory.Count > 0 then
    begin
      for i := 1 to Length(sMemory.Strings[sMemory.Count - 1]) do
      begin
        if CharInSet(sMemory.Strings[sMemory.Count - 1][i], ['0' .. '9']) or
          (sMemory.Strings[sMemory.Count-1]= ')') then
          exit;
      end;
    end;
  end;

  sMemory.Add((Sender as TButton).Caption);

  Text_Print;
end;

procedure TfrmCalculator.Cal_Input(Sender: TObject);
begin
  if sMemory.Count > 0 then
  begin
    if sMemory.Strings[sMemory.Count - 1] = ')' then
    begin
      sMemory.Add((Sender as TButton).Caption);
      Text_Print;
      exit;
    end;
  end;

  if lbPrint.Items.Strings[1] = '0' then
  begin
    if sMemory.Count > 0 then
      sMemory.Strings[sMemory.Count - 1] := (Sender as TButton).Caption;
  end
  else
  begin
    sMemory.Add(lbPrint.Items.Strings[1]);
    sMemory.Add((Sender as TButton).Caption);
  end;

  Text_Print;
end;

procedure TfrmCalculator.Text_Print;
var
  i: Integer;
begin
  lbPrint.Items.Strings[0] := '';

  for i := 0 to sMemory.Count - 1 do
    lbPrint.Items.Strings[0] := lbPrint.Items.Strings[0] + sMemory.Strings[i];

  lbPrint.Items.Strings[1] := '0';
end;

function TfrmCalculator.Cal_Value: Integer;
var
  i, j: Integer;
  s: String;
  FR, PR: TStringList;
begin

  while Pos('(', StringReplace(sMemory.Text, '#$D#$A', '',
    [rfReplaceAll])) > 0 do
  begin
    try
      FR := TStringList.Create;
      PR := TStringList.Create;
      for i := 0 to sMemory.Count - 1 do
      begin
        if (sMemory.Strings[i] = '(') then
          FR.Add(IntToStr(i))
        else if (sMemory.Strings[i] = ')') then
          PR.Add(IntToStr(i));
      end;

      for i := 0 to PR.Count - 1 do
      begin
        if StrToInt(FR.Strings[FR.Count - 1]) < StrToInt(PR.Strings[i]) then
        begin
          s := PR.Strings[i];
          Break;
        end;
      end;

      Calculation(StrToInt(FR.Strings[FR.Count - 1]), StrToInt(s));
    finally

      FreeAndNil(FR);
      FreeAndNil(PR);
    end;
  end;
  Calculation(0, sMemory.Count - 1);
end;

Procedure TfrmCalculator.Calculation(From_i, To_i: Integer);
label lb1, lb2;
var
  i, a: Integer;
  slTemp: TStringList;
  s: String;
begin
  Try
    slTemp := TStringList.Create;

    for i := From_i to To_i do
      if not((sMemory.Strings[i] = '(') or (sMemory.Strings[i] = ')')) then
        slTemp.Add(sMemory.Strings[i]);

  lb1:
    for i := 0 to slTemp.Count - 1 do
    begin
      if (slTemp.Strings[i] = '*') or (slTemp.Strings[i] = '/') then
      begin
        if (slTemp.Strings[i] = '*') then
          slTemp.Strings[i - 1] := FloatToStr(StrToFloat(slTemp.Strings[i - 1])
            * StrToFloat(slTemp.Strings[i + 1]))
        else if (slTemp.Strings[i] = '/') then
          slTemp.Strings[i - 1] := FloatToStr(StrToFloat(slTemp.Strings[i - 1])
            / StrToFloat(slTemp.Strings[i + 1]));

        slTemp.Delete(i + 1);
        slTemp.Delete(i);
        goto lb1;
      end;
    end;

  lb2:
    for i := 0 to slTemp.Count - 1 do
    begin
      if (slTemp.Strings[i] = '+') or (slTemp.Strings[i] = '-') then
      begin
        if (slTemp.Strings[i] = '+') then
          slTemp.Strings[i - 1] := FloatToStr(StrToFloat(slTemp.Strings[i - 1])
            + StrToFloat(slTemp.Strings[i + 1]))
        else if (slTemp.Strings[i] = '-') then
          slTemp.Strings[i - 1] := FloatToStr(StrToFloat(slTemp.Strings[i - 1])
            - StrToFloat(slTemp.Strings[i + 1]));

        slTemp.Delete(i + 1);
        slTemp.Delete(i);
        goto lb2;
      end;
    end;

    // ShowMessage(slTemp.Text);

    if slTemp.Count > 0 then
    begin
      sMemory.Strings[From_i] := slTemp.Strings[0];

      for i := To_i Downto From_i + 1 do
        sMemory.Delete(i);

      // ShowMessage(sMemory.Text);

      for i := 0 to sMemory.Count - 1 do
        if sMemory.Strings[i] = '' then
          sMemory.Delete(i);
    end;

  Finally
    FreeAndNil(slTemp);
  End;

end;

procedure TfrmCalculator.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  FreeAndNil(sMemory);
end;

procedure TfrmCalculator.FormCreate(Sender: TObject);
begin
  sMemory := TStringList.Create;
end;

end.
