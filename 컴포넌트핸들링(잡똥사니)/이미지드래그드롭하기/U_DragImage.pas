unit U_DragImage;
{Copyright ?2006, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{A drag/drop demo with separate scroll boxes for dragged objects "home" location
 and  area for target panels.  Dragcontrol images are the shape and color
 of the dragged shapes.  Shapes dropped on panel may be snapped" to top left
 positions}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ImgList, Contnrs, ShellAPI;

type

  {A class to hold the dragged objects}
  TMyDragObject = class(TDragControlObject)
  protected
    function GetDragImages: TDragImageList; override;
  end;

  {Main form}
  TForm1 = class(TForm)
    Panel1: TPanel;
    shape2:TShape;
    shape3:TShape;
    shape4:TShape;
    shape5:TShape;
    ScrollBox1: TScrollBox;
    ScrollBox2: TScrollBox;
    Panel2: TPanel;
    Panel3: TPanel;
    DragImageList: TImageList;
    SnapBox: TCheckBox;
    Shape8: TShape;

    {Set up a shape for dragging}
    procedure Shape1StartDrag(Sender: TObject;
      var DragObject: TDragObject);

    procedure FormCreate(Sender: TObject);


    {exit when dragging over or dropping a shape on a panel}
    procedure Panel1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure Panel1DragDrop(Sender, Source: TObject; X, Y: Integer);


    {Used when dragging over or dropping a shape on another shape(i.e.itself
     for a small adjustment move)}
    procedure Shape1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure Shape1DragDrop(Sender, Source: TObject; X, Y: Integer);


    {checkbox for snapping objects up and left}
    procedure SnapBoxClick(Sender: TObject);
  public
    PartsList:TObjectList; {List of the parts that may be dragged/dropped}
    hotx,hoty:integer; {Used to keep track of image offset from clicked position}
    {test if shape overlaps another shape already in place}
    function overlaps(sender:TWincontrol; shape:Tshape; x,y:integer):boolean;

    {Snap the shape up and left as far as possible without overlapping another}
    function snap(shape:Tshape):boolean;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

{************* IsBetween **************}
function IsBetween(i1,i2,i3:integer):boolean;
{return true if i1>i2 and i1<i3}
begin
  If (i1>i2) and (i1<i3) then result:=true
  else result:=false;;
end;

{************ GetDragImages **********}
function TMyDragObject.GetDragImages: TDragImageList;
{called at drag start time to get the image to be dragged}
begin
  Result := form1.DragImageList;
end;

{************** FormCreate *************8}
procedure TForm1.FormCreate(Sender: TObject);
var
  i,j:integer;
begin
  {Must add csDisplayDragImage to the ControlStyle of each control that is to
   diaply drag images}
  ControlStyle := ControlStyle + [csDisplayDragImage];
  {Create list of shapes which the pieces to be dropped}
  PartsList:=TObjectlist.create;

  {Fix up controlStyle property for all controls and child controls of scrollboxes
   (the shapes for Scrollbox1 and the panels on Scrollbox2)}
  for i:=0 to ControlCount-1 do
  with Controls[i] do
  begin
    ControlStyle:=ControlStyle + [csDisplayDragImage];
    if Controls[i] is TScrollbox then
    begin
      if controls[i]=Scrollbox1 then
      begin  {Scrollbox1 (the shapes parent) may accept pieces back}
        TScrollbox(Controls[i]).OnDragOver:=Panel1DragOver;
        TScrollbox(Controls[i]).OnDragDrop:=Panel1DragDrop;
      end;

      with Controls[i]as TScrollbox do
      begin
        for j:=0 to ControlCount-1 do {for all controls belonging to the scrollboxes}
        begin
          with Controls[j] do ControlStyle:=ControlStyle + [csDisplayDragImage];
          if Controls[j] is TShape then
          begin
            Partslist.Add(Controls[j]); {add shape to list}
            with Controls[j] as TShape do
            begin  {shapes may accept drops if other conditions are met}
              OnDragOver:=Shape1DragOver;
              OnDragDrop:=Shape1DragDrop;
            end;
          end
          else if Controls[j] is TPanel then
          begin
            with Controls[j] as TPanel do
            begin  {panels may accept dropped shapes}
              OnDragOver:=Panel1DragOver;
              OnDragDrop:=Panel1DragDrop;
            end;
          end;
        end;
      end;
    end;
  end;
end;

{*************** Overlaps *************}
function TForm1.Overlaps(Sender:TWincontrol; Shape:Tshape; x,y:integer):boolean;
{Check to see if shape at (x,y) would overlap any inplace shapes}
var
  i:integer;
  r:Trect; {holds boundary rectangle for shape being dropped}
  rr:Trect; {work rectangle }
  shape2:TShape;
  begin
    Result:=False;
    {the rectangle coordinates relative to the sender (the panel)}
    r:=Rect(x-hotx,y-hoty,x+Shape.Width-hotx,y+Shape.Height-hoty);

    {first make sure that it is entirely inside the sender -no intersect}
    InterSectRect(rr,r,Sender.ClientRect);
    if not EqualRect(rr,r) then Result:=True {r needs to be entirely inside the
                                             or scrollbox}
    else
    begin
      {check to make sure that this piece does not overlap any already in place}
      with PartsList do
      for i:=0 to Count-1 do
      begin
        Shape2:=TShape(items[i]);
        if (Shape2<>Shape) and (Sender=Shape2.Parent) and (InterSectRect(rr,r,Shape2.BoundsRect)) then
        begin {shapes overlap, deny drop}
          Result:=True;
          Break;
        end;
      end;
    end;
  end;


{************** Panel1dragDrop **************}
procedure TForm1.Panel1DragDrop(Sender, Source: TObject; X, Y: Integer);
{Dropping a hape on a panel}
var
  shape:Tshape; {points to shape being dropped, just for ease of reference}
begin
  if Source is TMyDragObject then
  with Source as TMyDragObject do
  begin
    Shape:=Tshape(Control);
    {Make sure it does overlap any other shape}
    if not Overlaps(TWincontrol(Sender),Shape,x,y) then
    begin {no overlap}
      {move the shape}
      Shape.Parent:=TWincontrol(Sender);
      Shape.Left:=x-hotx;
      Shape.Top:=y-hoty;

      {If we are dropping on a panel then snap it if option is set and add it
       to "PartInPlace" list}
      if (Shape.Parent is TPanel) and SnapBox.Checked then Snap(Shape);
    end;
  end;
end;

{************* PanelDragOver ************8}
procedure TForm1.Panel1DragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
{dragging a shape over a panel or the scrollbox}
var  shape:TShape;
begin
  if Source is TMyDragObject then
  with Source as TMyDragObject do
  begin
    Shape:=TShape(Control);
    if not Overlaps(TWincontrol(Sender),Shape,x,y) then Accept:=true
    else Accept:= False;
  end;
end;

{**************** ShapeStartDrag ************}
procedure TForm1.Shape1StartDrag(Sender: TObject;
  var DragObject: TDragObject);
{set up the dragimage list to reflect the image being dragged}
var
  b:TBitmap;
  index:integer;
  p:TPoint;
begin
  if Sender is TShape then
  with Sender as TShape do
  begin
    DragImageList.Clear;
    DragImageList.Height:= Height;
    DragImageList.Width:= Width;
    b:= TBitmap.Create;
    b.Width:= Width;
    b.Height:=Height;
    with b.Canvas do
    begin
      Brush.Color:= TShape(Sender).Brush.Color;
      Brush.Style:=bsSolid;
      case Shape of
        stRectangle: Rectangle(0,0,Width,Height);
        stRoundRect: RoundRect(0,0,Width,Height, Width div 4, Height div 4);
      end;
    end;
    if DragImageList.Add(b,nil)<0 then ShowMessage('Dragmage add failed');
    p:=ScreenToClient(Mouse.CursorPos);
    hotx:=p.x;  {keep track of cursor location relative to top left corner }
    hoty:=p.y;  {of the shape being dragged}

    DragImageList.SetDragImage(0,hotx,hoty);   {set the drag image}
    DragObject := TMyDragObject.Create(Tshape(Sender)); {Create the drag object}
    {remove from PartsList list is there}
    //index:=PartsList.indexof(TShape(sender));
    //if index>=0 then PartsList.extract(Tshape(sender));
  end;
end;

{************** ShapeDragOver ***************}
procedure TForm1.Shape1DragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
{shape can drag over other shapes, but only drop on itself!}
var
  shape:TShape;
begin
  if Source is TMyDragObject then
  with Source as TMyDragObject do
  begin
    Shape:=TShape(Control); {shape is the object being dragged, sender is the object
                             being dragged over - check if they are the sme}
    if  (Sender<>Shape) then Accept:= False else
      {even if dragging over ourselves, don't drop on another shape}
      Accept:=not Overlaps(Shape.Parent,Shape,Shape.Left+x,Shape.Top+y);
  end;
end;

{************ ShapeDragDrop *****************}
procedure TForm1.Shape1DragDrop(Sender, Source: TObject; X, Y: Integer);
var   Shape:TShape;
begin
  if Source is TMyDragobject then
  with Source as TMyDragObject do
  begin
    Shape:= TShape(Control);
    if (Sender= Shape)then {dropping on ourselves, move the shape}
    begin
      Shape.Left:= Shape.Left+x-hotx;
      Shape.Top:= Shape.Top+y-hoty;
      {snap if dropping on panel and option is checked}
      if Shape.Parent is TPanel then
      begin
        if SnapBox.Checked then Snap(Shape);
      end;
    end;
  end;
end;

{**************** Snap ************8}
function TForm1.Snap(shape:Tshape):boolean;
{"Snap" the passed shape as far up and left as it can go without overlapping
 any other shape already placed}
var
  j,n:integer;
  r,r2:Trect;
  Mindx,Mindy:Integer;
  Shape2:Tshape;
  Changed:Boolean;
begin
  result:= False;
  with PartsList do
  begin
    r:=Shape.BoundsRect;
    Mindx:=Shape.Left;   {the furthest we can move the shape left and up}
    Mindy:=Shape.Top;
    if Count>0 then
    repeat  {for all other PartsList}
      Changed:= False;
      for j:= 0 to Count-1  do
      begin  {check for furthest valid vertical move}
        Shape2:=TShape(Items[j]);
        if (Shape <> Shape2) and (Shape.Parent = Shape2.Parent) then
        with Shape2 do
        begin
          r2 := BoundsRect;
          n := r.Top-r2.Bottom;
          {we can move it this far if either left or right corener of either
           shape being tested is above the shape being snapped (n>0)
           and the distance is less than the previous minimum distance found
           and the left or right corner of ether shape lies within the boundaies
           of the other or left and right corners are in line}
          if (n >= 0) and (n < Mindy)
            and (IsBetween(r2.Left,r.Left,r.Right)
                 or IsBetween(r2.Right,r.Left,r.Right)
                 or IsBetween(r.Left,r2.Left,r2.Right)
                 or IsBetween(r.Right,r2.Left,r2.Right)
                 or ((r.Left=r2.Left) and (r.Right=r2.Right))
                 )
          then
          begin
            Changed := true;
            Mindy := n;
          end;
        end;
      end; {end vert move}
      OffsetRect(r,0,- Mindy); {move the snapped boundary rectangle up by mindy}
      Mindy:=0; {the min distance we can move up}

      {Now apply the same logic for a move left}
      for j:= 0 to Count -1 do
      begin
        Shape2 := TShape(Items[j]);
        if (Shape <> Shape2) and (Shape.Parent = Shape2.Parent) then
        with Shape2 do
        begin
          r2 := BoundsRect;
          n:=r.Left-r2.Right;
          if (n >= 0) and (n < Mindx)
            and (IsBetween(r2.Top,r.Top,r.Bottom)
            or IsBetween(r2.Bottom,r.Top,r.Bottom)
            or IsBetween(r.Top,r2.Top,r2.Bottom)
            or IsBetween(r.Bottom,r2.Top,r2.Bottom)
            or ((r.Top = r2.Top) and (r.Bottom = r2.Bottom))
            )
          then
          begin
            Changed := True;
            Mindx := n;
          end;
        end;
      end;
      OffsetRect(r,- Mindx,0);
      Mindx := 0;

      {If the boundary really moved, then move the shape and set result to true}
      if (Shape.Left <> r.Left) or (Shape.Top <> r.Top) then
      begin
        Result := True;
        Shape.Left := r.Left;
        Shape.Top := r.Top;
      end;
    until not Changed {loop (stairstep up and left) until no more moves possible}
    else
    begin {None in place, snap to (0,0)}
      if (Mindx>0) or (Mindy>0) then Result := True;
      Shape.Left := Shape.Left - Mindx;
      Shape.Top := Shape.Top- Mindy;
    end;
  end;
end;


{************** SnapBoxClick ***********}
procedure TForm1.SnapBoxClick(Sender: TObject);
var
  i:Integer;
  Snapped:Boolean;
begin
  Snapped := False;
  If Snapbox.Checked then
  repeat  {loop snapping all "inplace" shapes until no more movement}
    with PartsList do
    if Count>0 then
    begin
      Snapped := False;
      for i:=0 to Count-1 do
      with TShape(Items[i]) do
      if Parent is TPanel then
         Snapped := Snapped or Snap(TShape(Items[i]));
    end;
  until Snapped = False;
end;

end.

