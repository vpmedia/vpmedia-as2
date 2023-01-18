/*
 * vim:et sts=4 sw=4 cindent tw=120:
 * $Id: Line.as 199 2006-06-30 17:40:40Z allens $
 */

import com.stamen.display.Draw;
import com.stamen.utils.MathExt;
import com.digg.geo.*;

class com.digg.geo.Line
{
    public var start:Point;
    public var end:Point;

    public static function between(mc1:MovieClip, mc2:MovieClip, asGlobal:Boolean):Line
    {
        return new Line(Point.fromMovieClip(mc1, asGlobal),
                        Point.fromMovieClip(mc2, asGlobal));
    }

    public static function fromAngle(start:Point, angle:Number, length:Number, inDegrees:Boolean):Line
    {
        if (inDegrees) angle = MathExt.radians(angle);
        var end = new PolarCoordinate(length, angle);
        return new Line(start, end.toCartesian(start));
    }

    public function Line(start:Point, end:Point)
    {
        this.start = start;
        this.end = end;
    }

    public function toString():String
    {
        return this.start.toString() + ' -> ' + this.end.toString();
    }

    public function get length():Number
    {
        return this.start.distance(this.end);
    }

    public function set length(len:Number):Void
    {
        var end = new PolarCoordinate(this.angle, len);
        this.end = end.toCartesian(this.start);
    }

    public function get degrees():Number
    {
        return MathExt.degrees(this.angle);
    }

    public function set degrees(degrees:Number):Void
    {
        this.angle = MathExt.radians(degrees);
    }

    public function get angle():Number
    {
        return MathExt.angle(this.start.x, this.start.y,
                             this.end.x, this.end.y);
    }

    public function set angle(radians:Number):Void
    {
        var end = new PolarCoordinate(radians, this.length);
        this.end = end.toCartesian(this.start);
    }

    public function draw(mc:MovieClip):Void
    {
        mc.moveTo(this.start.x, this.start.y);
        mc.lineTo(this.end.x, this.end.y);
        Draw.circle(mc, this.end.x, this.end.y, 5);
    }

    public function get dx():Number
    {
        return this.end.x - this.start.x;
    }

    public function get dy():Number
    {
        return this.end.y - this.start.y;
    }

    public function set dx(x:Number):Void
    {
        this.end.x = this.start.x + x;
    }

    public function set dy(y:Number):Void
    {
        this.end.y = this.start.x + y;
    }

    public function perp(v:Object):Number
    {
        return (this.dx * v.dy) - (this.dy * v.dx);
    }

    public function intersection(v:Object, getT:Boolean, strict:Boolean):Object
    {
        if (this.dx == v.dx && this.dy == v.dy)
            return null;

        var v3 = new Line(new Point(0, 0), v.start.subtract(this.start));
        var t = v3.perp(v) / this.perp(v);

        if (strict && (t < 0 || t > 1))
        {
            return null;
        }
        else if (getT)
        {
            return t;
        }
        else
        {
            return this.start._add(this.dx * t, this.dy * t);
        }
    }
}
