/*
 * vim:et sts=4 sw=4 cindent:
 * $Id: PathClip.as 602 2007-01-18 23:35:42Z migurski $
 */

import mx.core.UIObject;
import mx.events.EventDispatcher;
import mx.utils.Delegate;

import com.stamen.data.Hash;
import com.digg.geo.*;
import com.digg.fdk.model.*;

class com.digg.fdk.view.path.PathClip extends UIObject
{
    public var user:User;
    public var origin:Point;
    public var destination:Point;

    /*
     * override this with a symbol name if you want a digger attached
     * automatically (in attachDigger())
     */
    private var digger:MovieClip;
    private var diggerSymbol:String;
    private var diggerParams:Object;

    private var placementHandler:Function;

    public static var symbolName:String = '__Packages.com.digg.fdk.view.path.PathClip';
    public static var symbolOwner:Function = PathClip;
    private static var symbolLink = Object.registerClass(symbolName, symbolOwner);
    private static var dispatchLink = EventDispatcher.initialize(PathClip.prototype);

    public function init():Void
    {
        this.attachDigger();
        this.placementHandler = Delegate.create(this, this.onPlacementChanged);
    }

    public function attachDigger():Void
    {
        if (this.diggerSymbol)
        {
            var params:Hash = new Hash({user: user});
            params.update(this.diggerParams);
            this.attachMovie(this.diggerSymbol, 'digger',
                             this.getNextHighestDepth(), params);
        }
    }

    public function attach():Void
    {
        this.dispatchEvent({type: 'doneAttaching'});
        this.start();
    }

    public function start():Void
    {
        trace('PathClip.start(): destination = ' + this.destination.context);
        this.origin.context.addEventListener('moved', this.placementHandler);
        this.destination.context.addEventListener('moved', this.placementHandler);

        this.place(true);
    }

    /**
     * Override me!
     */
    public function place(initial:Boolean):Void
    {
        this.finishTraveling();
    }

    public function onPlacementChanged(event:Object):Void
    {
        trace('PathClip.onPlacementChanged()');
        this.place(false);

        if (event.target._parent == this._parent &&
            event.target.getDepth() > this.getDepth())
        {
            // place in front
            this.swapDepths(event.target);
        }
    }

    public function finishTraveling():Void
    {
        // trace('PathClip.finishTraveling()');
        this.origin.context.removeEventListener('moved', this.placementHandler);
        this.destination.context.removeEventListener('moved', this.placementHandler);
        this.dispatchEvent({type: 'doneTraveling'});
    }

    public function detach():Void
    {
        this.origin.context.removeEventListener('moved', this.placementHandler);
        this.destination.context.removeEventListener('moved', this.placementHandler);
        this.dispatchEvent({type: 'doneDetaching'});
    }

    public function point():Point
    {
        var p:Point = new Point(this.digger._x, this.digger._y, null, this.digger._rotation);
        return p.asLocalPoint(_root);
    }
}
