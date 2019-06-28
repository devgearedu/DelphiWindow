unit uCal;

interface
uses Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
     System.Classes;
type
  TeditCal = class(TStringList)
  private
    fFirst : string;
    fSecond : string;
    fCalfn : string;
  public

    Constructor Create;
    Destructor Destroy;
    function Gubun(a : string):string;
  end;

implementation



{ TeditCal }

constructor TeditCal.Create;
begin
  fFirst := '';
  fSecond := '';
  fCalfn := '';


end;

destructor TeditCal.Destroy;
begin
  //
end;

function TeditCal.Gubun(a: string): string;
var
  list : TStringList;
begin
  list := TStringList.Create;
//  StringReplace(a, '+', '#13#10', rfReplaceAll);
  ExtractStrings(['+'],[],pchar(a),list);

end;

end.
