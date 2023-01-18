/*
 * vim:et sts=4 sw=4 cindent:
 * $Id: AnimatedPathClip.as 605 2007-01-18 23:51:57Z allens $
 */

import mx.utils.Delegate;

import com.digg.geo.*;
import com.stamen.display.*;
import com.digg.fdk.model.*;
import com.digg.fdk.view.DiggerClip;
import com.digg.fdk.view.path.PathClip;

class com.digg.fdk.view.path.AnimatedPathClip extends PathClip
{
    private var diggerSymbol:String = DiggerClip.symbolName;
    private var traveler:MovieClip;
    private var actualDistance:Number = 100;

    public static var symbolName:String = 'path_straight';
    public static var symbolOwner:Function = PathClip;
    private static var symbolLink = Object.registerClass(symbolName, symbolOwner);

    public function init():Void
    {
        super.init();
        this.traveler._visible = false;
        this.digger._visible = false;
    }

    public function attach():Void
    {
        trace('PathClip.attach()');
        this.dispatchEvent({type: 'doneAttaching'});
        this.doLater(this, 'start');
    }

    public function place(initial:Boolean):Void
    {
        var origin:Point = this.origin.asLocalPoint(this._parent);
        var destination:Point = this.destination.asLocalPoint(this._parent);
        this._x = origin.x;
        this._y = origin.y;

        var line:Line = new Line(origin, destination);
        this._rotation = line.degrees;
        this._xscale = 100 * line.length / this.actualDistance;
        this._yscale = this._xscale;
        this.digger._xscale = 100 / (this._xscale / 100);
        this.digger._yscale = 100 / (this._yscale / 100);
    }

    public function start():Void
    {
        super.start();
        this.gotoAndPlay(1);
        this.digger._visible = true;
        this.onEnterFrame = this.updateDiggerPosition;
    }

    public function updateDiggerPosition():Void
    {
        this.digger._x = this.traveler._x;
        this.digger._y = this.traveler._y;
        if (this.digger.orientToPath)
            this.digger._rotation = this.traveler._rotation;
        if (this._currentframe == this._totalframes)
        {
            this.finishTraveling();
        }
    }

    public function finishTraveling():Void
    {
        super.finishTraveling();
        delete this.onEnterFrame;
        this.stop();
    }
}
