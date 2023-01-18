/*
 * vim:et sts=4 sw=4 cindent tw=120:
 * $Id: PolarCoordinate.as 199 2006-06-30 17:40:40Z allens $
 */

import com.stamen.utils.MathExt;
import com.digg.geo.*;

class com.digg.geo.PolarCoordinate
{
    public var theta:Number = 0;
    public var radius:Number = 0;

    public static function fromCartesian(p:Point, origin:Point):PolarCoordinate
    {
        // trace('PolarCoordinate.fromCartesian(' + p + ', ' + origin + ')');
        if (null == origin) origin = new Point(0, 0);

        var theta:Number = MathExt.angle(origin.x, origin.y, p.x, p.y);
        var radius:Number = MathExt.distance(origin.x, origin.y, p.x, p.y);

        return new PolarCoordinate(theta, radius);
    }

    public function PolarCoordinate(theta:Number, radius:Number)
    {
        this.theta = theta;
        this.radius = radius;
    }

    public function get degrees():Number
    {
        return MathExt.degrees(this.theta);
    }

    public function set degrees(degrees:Number):Void
    {
        this.theta = MathExt.radians(degrees);
    }

    public function toCartesian(origin:Point):Point
    {
        // trace('PolarCoordinate.toCartesian(' + origin + '): ' + this);

        if (null == origin) origin = new Point(0, 0);
        var x:Number = origin.x + this.radius * Math.cos(this.theta);
        var y:Number = origin.y + this.radius * Math.sin(this.theta);
        return new Point(x, y, origin.context, this.degrees);
    }

    public function toString():String
    {
        return '[radius: ' + this.radius + ', theta: ' + this.theta + ']';
    }
}
