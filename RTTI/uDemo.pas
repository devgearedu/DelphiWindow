unit uDemo;

interface

uses StdCtrls, Controls;

type
  TDemoClass = class(TObject)
  private
    FCaption : string;
  public
    procedure CallButtonClick(aButton : TButton);
    procedure SetCaption(aButton : TButton);
  end;

implementation

{ TForm17 }

procedure TDemoClass.CallButtonClick(aButton: TButton);
begin
  aButton.Click;
end;

procedure TDemoClass.SetCaption(aButton : TButton);
begin
  aButton.Caption := FCaption;
end;

end.
