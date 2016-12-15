unit Tools;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Graphics;
  type
    TFigure=class
      public
      BrushCol:TColor;
      PenW: integer;
      tl,br: TPoint;
      PenCol: TColor;
      Points: array of TPoint;
      procedure Draw(canvas :TCanvas); virtual;abstract;
      procedure CreateFigure(nextc:TPoint;col, PenCh:TColor; width: integer); virtual;abstract;
      procedure ChangePoint(nextc: TPoint); virtual;abstract;
   end;
   TEllipse=class(TFigure)
    public
      procedure Draw(canvas :TCanvas); override;
      procedure CreateFigure(nextc:TPoint;col, PenCh:TColor; width: integer); override;
      procedure ChangePoint(nextc: TPoint); override;
   end;

   TRectangle=class(TFigure)
     procedure Draw(canvas :TCanvas); override;
     procedure CreateFigure(nextc:TPoint;col, PenCh:TColor; width: integer);override;
     procedure ChangePoint(nextc: TPoint);override;
    end;
   TPolyLine=class(TFigure)
    procedure Draw(canvas :TCanvas); override;
    procedure CreateFigure(nextc:TPoint;col, PenCh:TColor; width: integer);override;
    procedure ChangePoint(nextc: TPoint);override;
   end;
   TLine=class(TFigure)
    procedure Draw(canvas :TCanvas); override;
    procedure CreateFigure(nextc:TPoint;col, PenCh:TColor; width: integer);override;
    procedure ChangePoint(nextc: TPoint);override;
   end;
   TPolyG=class(TFigure)
    procedure Draw(canvas :TCanvas); override;
    procedure CreateFigure(nextc:TPoint;col, PenCh:TColor; width: integer);override;
    procedure ChangePoint(nextc: TPoint);override;
   end;
 VectorEditor: TVectorEditor;
    CurrentTool: TFigure;
    arrF: array of TFigure;
    ButtDown: boolean;
    PenW, width: integer;
    x0,y0,x1,y1, CurT: integer;
    offset, zoom: integer;
implementation
  procedure TRectangle.CreateFigure(nextc: TPoint;col, PenCh:TColor; width: integer);
  begin
    setlength(arrF, length(arrF)+1);
    arrF[High(arrF)]:=TRectangle.Create;
    setlength(arrF[High(arrF)].Points,length(Points)+2);
    arrF[High(arrF)].Points[0]:=nextc;
    arrF[High(arrF)].Points[1]:=nextc;
    arrF[High(arrF)].BrushCol:=col;
    arrF[High(arrF)].PenW:=width;
    arrF[High(arrF)].PenCol:=PenCh;
  end;

  procedure TEllipse.CreateFigure(nextc: TPoint;col, PenCh:TColor; width:integer);
  begin
    setlength(arrF, length(arrF)+1);
    arrF[High(arrF)]:=TEllipse.Create;
    setlength(arrF[High(arrF)].Points,length(Points)+2);
    arrF[High(arrF)].Points[0]:=nextc;
    arrF[High(arrF)].Points[1]:=nextc;
    arrF[High(arrF)].BrushCol:=col;
    arrF[High(arrF)].PenW:=width;
    arrF[High(arrF)].PenCol:=PenCh;
  end;
  procedure TPolyLine.CreateFigure(nextc: TPoint;col, PenCh:TColor; width: integer);
  begin
    setlength(arrF, length(arrF)+1);
    arrF[High(arrF)]:=TPolyLine.Create;
    setlength(arrF[High(arrF)].Points,length(arrF[High(arrF)].Points)+1);
    arrF[High(arrF)].Points[high(arrF[High(arrF)].Points)]:=nextc;
    arrF[High(arrF)].BrushCol:=col;
    arrF[High(arrF)].PenW:=width;
    arrF[High(arrF)].PenCol:=PenCh;
  end;
    procedure TLine.CreateFigure(nextc: TPoint;col, PenCh:TColor; width:integer);
  begin
    setlength(arrF, length(arrF)+1);
    arrF[High(arrF)]:=TLine.Create;
    setlength(arrF[High(arrF)].Points,length(Points)+2);
  //  arrF[High(arrF)].Points[0]:=nextc;
    arrF[High(arrF)].Points[1]:=nextc;
    arrF[High(arrF)].BrushCol:=col;
    arrF[High(arrF)].PenW:=width;
    arrF[High(arrF)].PenCol:=PenCh;
  end;
     procedure TPolyG.CreateFigure(nextc: TPoint;col, PenCh:TColor; width: integer);
  begin
    setlength(arrF, length(arrF)+1);
    arrF[High(arrF)]:=TPolyG.Create;
    setlength(arrF[High(arrF)].Points,length(Points)+2);
    arrF[High(arrF)].Points[0]:=nextc;
    arrF[High(arrF)].Points[1]:=nextc;
    arrF[High(arrF)].BrushCol:=col;
    arrF[High(arrF)].PenW:=width;
    arrF[High(arrF)].PenCol:=PenCh;
  end;
  procedure TRectangle.ChangePoint(nextc: TPoint);
  begin
    arrF[High(arrF)].Points[1]:=nextc;
  end;
  procedure TEllipse.ChangePoint(nextc: TPoint);
  begin
    arrF[High(arrF)].Points[1]:=nextc;
  end;
    procedure TPolyLine.ChangePoint(nextc: TPoint);
  begin
    setlength(arrF[High(arrF)].Points,length(arrF[High(arrF)].Points)+1);
    arrF[High(arrF)].Points[high(arrF[High(arrF)].Points)]:=nextc;
  end;
     procedure TPolyG.ChangePoint(nextc: TPoint);
  begin
    arrF[High(arrF)].Points[0]:=nextc;
   { setlength(arrF[High(arrF)].Points,length(arrF[High(arrF)].Points)+1);
    arrF[High(arrF)].Points[high(arrF[High(arrF)].Points)]:=nextc;}
  end;
    procedure TLine.ChangePoint(nextc: TPoint);
  begin
    arrF[High(arrF)].Points[1]:=nextc;
  end;
  procedure TRectangle.Draw(canvas: TCanvas);
  begin
    Canvas.Brush.Color:=BrushCol;
    Canvas.Pen.Width:=PenW;
    canvas.Pen.Color:=PenCol;
    canvas.Rectangle(Points[0].x,Points[0].y,Points[1].x,Points[1].y);
  end;
  procedure TEllipse.Draw(canvas: TCanvas);
  begin
    canvas.Brush.Color:=BrushCol;
    Canvas.Pen.Width:=PenW;
    canvas.Pen.Color:=PenCol;
    canvas.Ellipse(Points[0].x,Points[0].y,Points[1].x,Points[1].y);
  end;
   procedure TPolyLine.Draw(canvas: TCanvas);
  begin
    Canvas.Brush.Color:=BrushCol;
    Canvas.Pen.Width:=PenW;
    canvas.Pen.Color:=PenCol;
    canvas.PolyLine(Points);
  end;
     procedure TLine.Draw(canvas: TCanvas);
  begin
    canvas.Brush.Color:=BrushCol;
    Canvas.Pen.Width:=PenW;
    canvas.Pen.Color:=PenCol;
    canvas.MoveTo(Points[0].x,Points[0].y);
    canvas.LineTo(Points[1].x,Points[1].y);
  end;
     procedure TPolyG.Draw(canvas: TCanvas);
  begin
    canvas.Brush.Color:=BrushCol;
    Canvas.Pen.Width:=PenW;
    canvas.Pen.Color:=PenCol;
    canvas.PolyGon(Points);
  end;
end.

