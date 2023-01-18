/*
 * vim:et sts=4 sw=4 cindent:
 * $Id: ProgrammaticPathClip.as 605 2007-01-18 23:51:57Z allens $
 */

import mx.utils.Delegate;
import mx.transitions.*;
import mx.transitions.easing.*;

import com.digg.geo.*;
import com.stamen.display.*;
import com.stamen.utils.MathExt;
import com.digg.fdk.view.path.PathClip;
import com.digg.fdk.model.*;

class com.digg.fdk.view.path.ProgrammaticPathClip extends PathClip
{
    public var duration:Number = 2.0;
    private var speed:Number = 100; // pixels per second?

    private var tween:BezierPositionTween;
    private var tweenR:Tween;
    private var placementHandler:Function;

    public static var symbolName:String = '__Packages.com.digg.fdk.view.path.ProgrammaticPathClip';
    public static var symbolOwner:Function = ProgrammaticPathClip;
    private static var symbolLink = Object.registerClass(symbolName, symbolOwner);

    public function detach():Void
    {
        delete this.tween.onMotionFinished;
        super.detach();
    }

    public function place(initial:Boolean):Void
    {
        trace('ProgrammaticPathClip.place(' + initial + ')');
        var origin:Point = this.origin.asLocalPoint(this._parent);
        var destination:Point = this.destination.asLocalPoint(this._parent);

        var distance:Number = origin.distance(destination);

        var originControl:Point = this.getControlPoint(origin, distance / 5);
        var destinationControl:Point = this.getControlPoint(destination, distance / 4);

        this.tween.control1 = originControl;
        this.tween.control2 = destinationControl;

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
            this.tween.finish = destination;
            if (this.tweenR)
                this.tweenR.finish = destination.rotation;
        }

        updateAfterEvent();
    }

    public function start():Void
    {
        super.start();
        delete this.onEnterFrame;
    }

    public function getControlPoint(point:Point, distance:Number):Point
    {
        var polar:PolarCoordinate = new PolarCoordinate(0, distance);
        polar.degrees = point.rotation;
        return polar.toCartesian(point);
    }
}
