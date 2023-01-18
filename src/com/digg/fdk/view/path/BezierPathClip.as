/*
 * vim:et sts=4 sw=4 cindent:
 * $Id: BezierPathClip.as 605 2007-01-18 23:51:57Z allens $
 */

import mx.utils.Delegate;
import mx.transitions.*;
import mx.transitions.easing.*;

import com.digg.geo.*;
import com.stamen.display.*;
import com.digg.fdk.view.DiggerClip;
import com.digg.fdk.view.path.PathClip;

class com.digg.fdk.view.path.BezierPathClip extends PathClip
{
    public var duration:Number = 2.0;
    // attach a digger
    private var diggerSymbol:String = DiggerClip.symbolName;
    private var speed:Number = 100; // pixels per second?

    private var tween:BezierPositionTween;
    private var tweenR:Tween;

    public static var symbolName:String = '__Packages.com.digg.fdk.view.path.BezierPathClip';
    public static var symbolOwner:Function = BezierPathClip;
    private static var symbolLink = Object.registerClass(symbolName, symbolOwner);

    public function init():Void
    {
        super.init();
        this.digger._visible = false;
    }

    public function place(initial:Boolean):Void
    {
        this.digger._visible = true;
        trace('BezierPathClip.place(' + initial + ')');
        var origin:Point = this.origin.asLocalPoint(this._parent);
        var destination:Point = this.destination.asLocalPoint(this._parent);

        var distance:Number = origin.distance(destination);

        var originControl:Point = this.getControlPoint(origin, distance / 5);
        var destinationControl:Point = this.getControlPoint(destination, distance / 4);

        if (initial)
        {
            this.duration = distance / this.speed;
            this.tween = new BezierPositionTween(this.digger, origin,
                                                 destination, originControl,
                                                 destinationControl,
                                                 this.duration, true);
            this.tween.onMotionFinished = Delegate.create(this, this.finishTraveling);

            if (this.digger.orientToPath)
            {
                this.tweenR = new Tween(this.digger, '_rotation', Regular.easeInOut,
                                        origin.rotation, destination.rotation,
                                        this.duration, true);
            }
        }
        else
        {
            this.tween.control1 = originControl;
            this.tween.control2 = destinationControl;
            this.tween.finish = destination;
            if (this.tweenR)
                this.tweenR.finish = destination.rotation;
        }

        updateAfterEvent();
    }

    public function detach():Void
    {
        delete this.tween.onMotionFinished;
        super.detach();
    }

    public function getControlPoint(point:Point, distance:Number):Point
    {
        var polar:PolarCoordinate = new PolarCoordinate(0, distance);
        polar.degrees = point.rotation;
        return polar.toCartesian(point);
    }

    public function point():Point
    {
        var p:Point = this.tween.getExitVector(this);
        trace('BezierPathClip.point(): exit vector = ' + p);
        return p.asLocalPoint(this._parent);
    }
}
