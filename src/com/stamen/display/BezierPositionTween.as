/*
 * vim:et sts=4 sw=4 cindent:
 * $Id: BezierPositionTween.as 199 2006-06-30 17:40:40Z allens $
 */

import com.digg.geo.Point;
import com.stamen.display.PositionTween;

class com.stamen.display.BezierPositionTween extends PositionTween
{
    public var control1:Point;
    public var control2:Point;

    public function BezierPositionTween(obj:MovieClip, begin:Point, finish:Point,
                                        control1:Point, control2:Point,
                                        duration:Number, useSeconds:Boolean)
    {
        super(obj, begin, finish, BezierPositionTween.tweenCubicBez, duration, useSeconds);
        this.control1 = control1;
        this.control2 = control2;
    }

    public function getPosition(t:Number):Point
    {
        if (t == undefined) t = this._time;
        var x:Number = this.func(t, this.begin.x, this.change.x,
                                 this.duration, this.control1.x, this.control2.x);
        var y:Number = this.func(t, this.begin.y, this.change.y,
                                 this.duration, this.control1.y, this.control2.y);
        return new Point(x, y);
    }

    /**
     * Bezier Tween function by Robert Penner (www.robertpenner.com)
     */
	static function tweenCubicBez(t:Number, b:Number, c:Number, d:Number, p1:Number,p2:Number):Number
    {
		return ((t /= d) * t * c + 3 * (1 - t) * (t * (p2 - b) + (1 - t) * (p1 - b))) * t + b;
	}
}
