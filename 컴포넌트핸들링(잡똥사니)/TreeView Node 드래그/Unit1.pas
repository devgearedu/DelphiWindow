unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, CommCtrl, ImgList, StdCtrls, System.ImageList;

type

{ TTreeView }

  TTreeView = class(ComCtrls.TTreeView)
  private
    procedure WMEraseBkgnd(var Message: TMessage); message WM_ERASEBKGND;
  end;

{ TForm1 }

  TForm1 = class(TForm)
    TreeView: TTreeView;
    ImageList1: TImageList;
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure TreeViewDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure TreeViewDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure TreeViewEndDrag(Sender, Target: TObject; X, Y: Integer);
  private
    CurrentNode: TTreeNode;
    CurrentPos: Char;
    GhostNode: TTreeNode;
  public
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

{ TTreeView }

procedure TTreeView.WMEraseBkgnd(var Message: TMessage);
begin
end;

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
var
  Node: TTreeNode;
begin
  Node := TreeView.Items.AddChild( nil, 'AA11111' );
  TreeView.Items.AddChild( Node, 'BB11111' );
  TreeView.Items.AddChild( Node, 'CC11111' );
  TreeView.Items.AddChild( Node, 'DD11111' );
  TreeView.Items.AddChild( Node, 'EE11111' );

  Node := TreeView.Items.AddChild( nil, 'AA22222' );
  TreeView.Items.AddChild( Node, 'BB22222' );
  TreeView.Items.AddChild( Node, 'CC22222' );
  TreeView.Items.AddChild( Node, 'DD22222' );
  TreeView.Items.AddChild( Node, 'EE22222' );

  Node := TreeView.Items.AddChild( nil, 'AA33333' );
  TreeView.Items.AddChild( Node, 'BB33333' );
  TreeView.Items.AddChild( Node, 'CC33333' );
  TreeView.Items.AddChild( Node, 'DD33333' );
  TreeView.Items.AddChild( Node, 'EE33333' );

  Node := TreeView.Items.AddChild( nil, 'AA44444' );
  TreeView.Items.AddChild( Node, 'BB44444' );
  TreeView.Items.AddChild( Node, 'CC44444' );
  TreeView.Items.AddChild( Node, 'DD44444' );
  Node := TreeView.Items.AddChild( Node, 'EE44444' );
  TreeView.Items.AddChild( Node, 'EE11144444' );
  TreeView.Items.AddChild( Node, 'EE22244444' );
  TreeView.Items.AddChild( Node, 'EE33344444' );
  TreeView.Items.AddChild( Node, 'EE44444444' );

  Node := TreeView.Items.AddChild( nil, 'AA55555' );
  TreeView.Items.AddChild( Node, 'BB55555' );
  TreeView.Items.AddChild( Node, 'CC55555' );
  TreeView.Items.AddChild( Node, 'DD55555' );
  TreeView.Items.AddChild( Node, 'EE55555' );

  TreeView.FullExpand;
end;

procedure TForm1.TreeViewDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
const
  GhostText = 'ขั                ';
var
  Node: TTreeNode;
  HitPos: Char;
function GetHitPos: Char;
  var
    Rect: TRect;
  begin
    Rect := Node.DisplayRect( True );
    if ( Rect.Top <= Y ) and ( Y <= Rect.Bottom ) then
     begin
       if ( Rect.Right - X in [0..14] ) and
          ( ( Node.Count = 0 ) or ( ( Node.Count = 1 ) and ( Node.Item[0] = GhostNode ) ) ) then
        begin
          Result := 'R';
        end
       else
       if ( X - Rect.Left in [0..14] ) and
          ( ( Node.Parent <> nil ) and
          ( ( Node.GetNextSibling = nil ) or ( Node.GetNextSibling = GhostNode ) ) ) then
        begin
          Result := 'L';
        end
       else
        begin
          if ( Rect.Bottom - Y ) > ( Rect.Bottom - Rect.Top ) div 2 then Result := 'T'
                                                                    else Result := 'B';
        end;
     end
    else
     Result := #0;
  end;
begin
  Node := TTreeView(Sender).GetNodeAt( X, Y );

  if ( Node <> nil ) and ( Node <> GhostNode ) then
   begin
     HitPos := GetHitPos;

     if ( CurrentNode <> Node ) or ( CurrentPos <> HitPos ) and ( Node <> TTreeView(Sender).Selected ) then
      begin
        if GhostNode <> nil then GhostNode.Free;

        if HitPos <> #0 then
         begin
           GhostNode := TTreeNode.Create( TTreeView(Sender).Items );
           GhostNode.ImageIndex := -1;
         end
        else
         GhostNode := nil;

        case HitPos of
        'T': begin
               GhostNode := TTreeView(Sender).Items.InsertNode( GhostNode, Node, GhostText, nil );
             end;
        'B': begin
               if Node.GetNextSibling <> nil then GhostNode := TTreeView(Sender).Items.InsertNode( GhostNode, Node.GetNext, GhostText, nil )
                                             else GhostNode := TTreeView(Sender).Items.AddNode( GhostNode, Node, GhostText, nil, naAdd );
             end;
        'R': begin
               if Node.Count = 0 then
                begin
                  GhostNode := TTreeView(Sender).Items.AddNode( GhostNode, Node, GhostText, nil, naAddChild );
                  Node.Expand( True );
                end;
             end;
        'L': begin
               Node := Node.Parent;
               GhostNode := TTreeView(Sender).Items.AddNode( GhostNode, Node, GhostText, nil, naAdd );
             end;
        else Exit;
        end;
      end;

     CurrentNode := Node;
     CurrentPos := HitPos;

     ShowCursor( True );
   end;
end;

procedure TForm1.TreeViewDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  Node: TTreeNode;
  Expanded: Boolean;
begin
  if ( GhostNode <> nil ) and ( TTreeView(Sender).Selected <> nil ) then
   begin
     TTreeView(Sender).Items.BeginUpdate;
     try
       Node := TTreeView(Sender).Selected;
       Expanded := ( Node.Count > 0 ) and Node.Expanded;

       TTreeView(Sender).Selected.MoveTo( GhostNode, naInsert );

       Node.Expanded := Expanded;
       Node.Selected := True;
       Node.Focused := True;
     finally
       TTreeView(Sender).Items.EndUpdate;
     end;
   end;
end;

procedure TForm1.TreeViewEndDrag(Sender, Target: TObject; X, Y: Integer);
begin
  if GhostNode <> nil then
   begin
     GhostNode.Free;
     GhostNode := nil;
   end;
end;

end.
