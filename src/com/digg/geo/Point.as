/*
 * vim:et sts=4 sw=4 cindent:
 * $Id: Point.as 199 2006-06-30 17:40:40Z allens $
 */

import com.stamen.utils.MathExt;
import com.stamen.display.*;
import com.digg.geo.*;

class com.digg.geo.Point extends Object
{
    public var x:Number = 0;
    public var y:Number = 0;
    public var context:MovieClip;
    public var converted:Boolean = false;
    public var rotation:Number = 0;

    public static var origin = new Point(0, 0);

    public static function fromMovieClip(mc:MovieClip, asGlobal:Boolean):Point
    {
        var p:Point = new Point(mc._x, mc._y, mc);
        if (asGlobal) p.localToGlobal();
        return p;
    }

    public function Point(x:Number, y:Number, context:MovieClip, rotation:Number)
    {
        this.moveTo(x, y);
        this.context = context;
        if (isFinite(rotation))
            this.rotation = rotation;
    }

	public function copy(copyContext:Boolean):Point
	{
		return (copyContext == false)
                ? new Point(this.x, this.y, null, this.rotation)
                : new Point(this.x, this.y, this.context, this.rotation);
	}

	public function asLocalPoint(context:MovieClip, convertRotation:Boolean):Point
	{
		var local:Point = this.copy(false);
		this.context.localToGlobal(local);
		context.globalToLocal(local);
		local.context = context;
        if (convertRotation || null == convertRotation)
            local.rotation = this.convertRotation(context);
		return local;
	}

    public function convertRotation(context:MovieClip):Number
    {
        // first, get a point 100 px from this point in the desired direction
        var theta:Number = MathExt.radians(this.rotation);
        var polar:PolarCoordinate = new PolarCoordinate(theta, 100);
        var cartesian:Point = polar.toCartesian(this);

        // then, convert both those points to the context's coordinate space
        var origin:Point = this.asLocalPoint(context, false);
        var rotated:Point = cartesian.asLocalPoint(context, false);

        // finally, return the angle of that line
        var line:Line = new Line(origin, rotated);
        return line.degrees;
    }

    public function moveTo(x:Number, y:Number):Void
    {
        if (isFinite(x)) this.x = x;
        if (isFinite(y)) this.y = y;
    }

    public function _add(x:Number, y:Number):Point
    {
        return new Point(this.x + x, this.y + y);
    }

    public function subtract(p:Point):Point
    {
        return new Point(this.x - p.x,
                         this.y - p.y);
    }

    public function distance(p:Point):Number
    {
        return MathExt.distance(this.x, this.y, p.x, p.y);
    }

    public function toString():String
    {
        var out:String = '(' + this.x + ', ' + this.y + ')';
        if (this.context || this.rotation)
            out += ' [context: ' + context + ', rotation: ' + this.rotation + ']';
        return out;
    }

    public function localToGlobal():Void
    {
        if (!this.converted)
        {
            this.context.localToGlobal(this);
            this.converted = true;
        }
    }

    public function globalToLocal():Void
    {
		if (this.context)
			this.context.globalToLocal(this);
    }

    public function draw(radius:Number):Void
    {
        if (null == radius) radius = 2;
        Draw.circle(this.context, this.x, this.y, radius);
    }
}
