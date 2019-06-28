unit RedPanel;

interface

uses
  Classes, Graphics, ExtCtrls;

type
  TRedPanel = class(TPanel)
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

constructor TRedPanel.Create(AOwner: TComponent);
begin
  inherited Create( AOwner );
  Caption := 'TRedPanel';
//  Color := clRed;
end;

end.
