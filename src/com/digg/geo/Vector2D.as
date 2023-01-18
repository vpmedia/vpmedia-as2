/*
 * vim:et sts=4 sw=4 cindent tw=120:
 * $Id: Vector2D.as 228 2006-07-12 02:40:38Z aaron $
 */

class com.digg.geo.Vector2D
{
    public var x:Number;
    public var y:Number;

    public function Vector2D(x_:Number, y_:Number)
    {
        x = x_;
        y = y_;
    }

    public function setXY(x_:Number, y_:Number):Void
    {
        x = x_;
        y = y_;
    }
  
    public function magnitude():Number
    {
        return Math.sqrt(magnitudeSqrd());
    }

    public function magnitudeSqrd():Number
    {
        return (x*x + y*y);
    }

    public function copy():Vector2D
    {
        return new Vector2D(x, y);
    }

    public function plus(v:Vector2D):Void
    {
        x += v.x;
        y += v.y;
    }

    public function sub(v:Vector2D):Void
    {
        x -= v.x;
        y -= v.y;
    }

    public function mult(n:Number):Void
    {
        x *= n;
        y *= n;
    }

    public function div(n:Number):Void
    {
        x /= n;
        y /= n;
    }

    public function normalize():Void
    {
        var m:Number = magnitude();
        if (m > 0) {
            div(m);
        }
    }

    public function limit(max:Number):Void
    {
        if (magnitude() > max) {
            normalize();
            mult(max);
        }
    }

    public function limitSqrd(max:Number):Void
    {
        if( magnitudeSqrd() > (max*max) )
        {
            normalize();
            mult(max);
        }
    }

    public function getAngleR():Number
    {
        return Math.atan2(y,x);
    }

    public function getAngleD():Number
    {
        return Math.atan2(y,x) * (180/Math.PI);
    }

    public function setAngleR(angle:Number):Void
    {
        var r:Number = magnitude();
        x = r * Math.cos(angle);
        y = r * Math.sin(angle);
    }

    public function setAngleD(angle:Number):Void
    {
        var r:Number = magnitude();
        angle *= Math.PI/180;
        x = r * Math.cos(angle);
        y = r * Math.sin(angle);
    }
  
    public function getLength():Number
    {
        return magnitude();
    }

    public function setLength(len:Number):Void
    {
        var r:Number = magnitude();
        mult(len/r);
    }

    public function toString():String
    {
        return ("("+x+","+y+")");
    }
  
    public static function rotateAboutR(orbital:Vector2D, nucleus:Vector2D, rotation:Number):Vector2D
    {
        var offset:Vector2D = Vector2D.vSub(orbital, nucleus);
        offset.setAngleR(offset.getAngleR() + rotation);
        return Vector2D.vPlus(nucleus, offset);
    }

    public static function rotateAboutD(orbital:Vector2D, nucleus:Vector2D, rotation:Number):Vector2D
    {
        var offset:Vector2D = Vector2D.vSub(orbital, nucleus);
        offset.setAngleD(offset.getAngleD() + rotation);
        return Vector2D.vPlus(nucleus, offset);
    }

    public static function vPlus(v1:Vector2D, v2:Vector2D):Vector2D
    {
        return new Vector2D(v1.x + v2.x, v1.y + v2.y);
    }

    public static function vSub(v1:Vector2D, v2:Vector2D):Vector2D
    {
        return new Vector2D(v1.x - v2.x, v1.y - v2.y);
    }

    public static function vDiv(v:Vector2D, n:Number):Vector2D
    {
        return new Vector2D(v.x/n, v.y/n);
    }

    public static function vMult(v:Vector2D, n:Number):Vector2D
    {
        return new Vector2D(v.x*n, v.y*n);
    }

    public static function distance(v1:Vector2D, v2:Vector2D):Number
    {
        var dx:Number = v1.x - v2.x;
        var dy:Number = v1.y - v2.y;
        return Math.sqrt(dx*dx + dy*dy);
    }

    public static function distanceSqrd(v1:Vector2D, v2:Vector2D):Number
    {
        var dx:Number = v1.x - v2.x;
        var dy:Number = v1.y - v2.y;
        return (dx*dx + dy*dy);
    }
}

