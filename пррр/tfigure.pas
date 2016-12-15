unit Unit2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;
 type
   TFigure=class
   TRectangle=class(TFigure)
    strict protected
      tl, br: TPoint;
     procedure Draw;
     constructor Create;
   end;
  end;
   var
     tl, br: TPoint;
  implementation
    procedure TRectangle.Draw;
     Form1.PaintBox.canvas.rectangle(tl.x,tl.y,br.x,br.y);
   end;
    constructor TRectangle.Create(p1,p2: TPoint);
     begin
       tl:=p1;
       br:=p2;
      end;

 end.

