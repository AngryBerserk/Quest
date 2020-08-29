unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,JPEG;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormPaint(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    Locations:TextFile;
    Pic:TBitmap;
    Map:TBitmap;
    Map2:TJPegImage;
    CLock:String;
    Procedure LoadLocation(Q:String);
    Procedure Redraw;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

Procedure TForm1.LoadLocation(Q:String);
Begin
Map2.LoadFromFile('maps\'+Q+'-mask.jpg');
Map.Assign(Map2);
Map2.LoadFromFile('maps\'+Q+'.jpg');
Pic.Assign(Map2);
Redraw
End;

procedure TForm1.FormShow(Sender: TObject);
begin
Map2:=TJpegImage.Create;
Pic:=TBitmap.Create;
Map:=TBitmap.Create;
AssignFile(Locations,'maps\locations.txt');
Reset(Locations);
Readln(Locations,CLock);
LoadLocation(CLock);
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
CloseFile(Locations)
end;

Procedure TForm1.Redraw;
Begin
Canvas.Draw(0,0,Pic)
End;

procedure TForm1.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
Edit1.Text:=IntToStr(GetRValue(Map.Canvas.Pixels[X,Y]))+'^'+IntToStr(GetGValue(Map.Canvas.Pixels[X,Y]))+'^'+IntToStr(GetBValue(Map.Canvas.Pixels[X,Y]));
If (Map.Canvas.Pixels[X,Y]=Rgb(0,0,254))or(Map.Canvas.Pixels[X,Y]=Rgb(254,0,0))or(Map.Canvas.Pixels[X,Y]=Rgb(0,255,1)) then Cursor:=CrHandPoint else cursor:=CrArrow
end;

procedure TForm1.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
 Var Ok:Boolean;Q:String;
begin
 Ok:=False;
 If (Map.Canvas.Pixels[X,Y]=Rgb(0,0,254))or(Map.Canvas.Pixels[X,Y]=Rgb(0,255,1))or(Map.Canvas.Pixels[X,Y]=Rgb(254,0,0)) then Begin
  Reset(Locations);
  Repeat Readln(Locations,Q) until Q='~'+CLock;
  Repeat
   ReadLn(Locations,Q);
    If Map.Canvas.Pixels[X,Y]=Rgb(0,0,254)  then If Q[1]='l' Then Begin Delete(Q,1,1);CLock:=Q;Ok:=True;LoadLocation(CLock) End;
    If Map.Canvas.Pixels[X,Y]=Rgb(254,0,0)  then If Q[1]='r' Then Begin Delete(Q,1,1);CLock:=Q;Ok:=True;LoadLocation(CLock) End;
    If Map.Canvas.Pixels[X,Y]=Rgb(0,255,1)  then If Q[1]='f' Then Begin Delete(Q,1,1);CLock:=Q;Ok:=True;LoadLocation(CLock) End;
  Until Eof(Locations)or(Ok)
 End
end;

procedure TForm1.FormPaint(Sender: TObject);
begin
Redraw
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
If Key=VK_ESCAPE then Form1.Close
end;

end.
