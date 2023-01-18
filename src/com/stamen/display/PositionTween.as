/*
 * vim:et sts=4 sw=4 cindent:
 * $Id: PositionTween.as 115 2006-05-18 23:24:10Z allens $
 */

import mx.transitions.Tween;
import mx.transitions.easing.*;

import com.digg.geo.*;

/**
 * @author	Shawn Allen <shawn@stamen.com>
 */
class com.stamen.display.PositionTween extends Tween
{
    public var begin:Point;
    public var change:Point;
    public var prevPos:Point;
    public var func:Function = Regular.easeInOut;
    private var _pos:Point;

    public function PositionTween(obj:MovieClip, begin:Point, finish:Point,
                                  func:Function, duration:Number, useSeconds:Boolean)
    {
        this.obj = obj;
        this.begin = begin;
        this.position = begin;
        this.finish = finish;

        this.duration = duration;
        this.useSeconds = useSeconds;

        if (null != func) this.func = func;
        this._listeners = [];
        this.addListener(this);
        this.start();
    }

    public function get position():Point
    {
        return this.getPosition();
    }

    public function getPosition(t:Number):Point
    {
        if (t == undefined) t = this._time;
        var x:Number = this.func(t, this.begin.x, this.change.x, this.duration);
        var y:Number = this.func(t, this.begin.y, this.change.y, this.duration);
        return new Point(x, y);
    }

    public function set position(p:Point):Void
    {
        this.setPosition(p);
    }

    public function setPosition(p:Point):Void
    {
        this.prevPos = this._pos;
        this.obj._x = p.x;
        this.obj._y = p.y;
        this._pos = p;
        this.broadcastMessage('onMotionChanged', this, this._pos);
        updateAfterEvent();
    }

    public function set finish(p:Point):Void
    {
        this.change = new Point(p.x - this.begin.x,
                                p.y - this.begin.y);
    }

    public function get finish():Point
    {
        return new Point(this.begin.x + this.change.x,
                         this.begin.y + this.change.y);
    }
    
    /**
     * @param	context	MovieClip	the context of the returned Point
     * @return			Point		a Point instance with the rotation member set according
	 *								to the angle between the previous and current positions
	 *								on the path.
     */
    public function getExitVector(context:MovieClip):Point
    {
        trace('PositionTween.getExitVector(): _pos = ' + this._pos + ', prevPos = ' + this.prevPos);
        var polar:PolarCoordinate = PolarCoordinate.fromCartesian(this._pos, this.prevPos);
        var p:Point = polar.toCartesian(this.prevPos);
        p.context = context ? context : this.obj._parent;
        return p;
    }
}
