/*
 * vim:et sts=4 sw=4 cindent:
 * $Id: ViewObject.as 602 2007-01-18 23:35:42Z migurski $
 */

import mx.core.UIObject;
import mx.events.EventDispatcher;
import com.digg.geo.*;

/**
 * ViewObject is the base class for all objects in the ust view. They share
 * several properties:
 *
 * - a common interface for obtaining their bounds ({@link mask()})
 * - the dispatching of events when they're finished attaching and detaching
 *   ({@link onDoneAttaching()}, {@link onDoneDetaching()})
 * - the ability to expire after a given amount of time ({@link expire()})
 */
class com.digg.fdk.view.ViewObject extends UIObject
{
    /**
     * @var expiry      the number of milliseconds after which this instance
     *                  should expire.
     * @see expire()
     */
    public var expiry:Number = 0;
    private var alreadyExpired:Boolean = false;

    /**
     * @var expiryInterval  a setInterval() ID assigned when {@link
     *                      resetExpirationInterval()} is called.
     * @see resetExpirationInterval()
     * @see expire()    
     */
    private var expiryInterval:Number;

    /**
     * @var maskClip    the instance representing this object's visual bounds.  
     */
    private var maskClip:MovieClip;

    // decorate ViewObject.prototype with EventDispatcher methods
    private static var dispatchLink = EventDispatcher.initialize(ViewObject.prototype);

    /**
     * Create the mask, start expiring.
     * @return  Void
     */
    public function init():Void
    {
        this.setupMask();
    }

    /**
     * Call a function once after a given number of milliseconds.
     *
     * @param   Function    fn          the function to call.
     * @param   Number      timeout     the number of milliseconds to wait
     *                                  before calling the function.
     */
    public function setTimeout(fn:Function, timeout:Number):Number
    {
        var id:Number;
        var scope = this;
        var args:Array = arguments.slice(2);
        var func:Function = function():Void
        {
            fn.apply(scope, args);
            clearInterval(id);
        };
        id = setInterval(func, timeout, args);
        return id;
    }

    /**
     * Reset the expiration interval. When the expiryInterval is triggered,
     * {@link expire()} will be called.
     *
     * @param   time        Number  an optional
     * @return  Void    
     */
    public function resetExpirationInterval(time:Number):Void
    {
        clearInterval(this.expiryInterval);
        if (null != time) this.expiry = time;
        if (this.expiry > 0)
        {
            this.expiryInterval = setInterval(this, 'expire', this.expiry);
        }
    }
    
    /**
     * Provided for backwards compatibility with classes that rely upon "bg".
     *
     * @return  MovieClip    
     */
    public function get bg():MovieClip
    {
        return this.mask();
    }
    
    /**
     * Get the movie clip that represents this object's visual bounds.  The
     * returned MovieClip instance is typically assigned mouse handlers, and the
     * return values of its getBounds() and hitTest() methods are used to
     * determine whether something (a Point, another MovieClip) intersects with
     * it.
     *
     * @return  MovieClip
     */
    public function mask():MovieClip
    {
        return this.maskClip;
    }
    
    /**
     * Create the mask, and perform any initialization on it (such as setting up
     * mouse handlers).
     *
     * @return  Void    
     */
    public function setupMask():Void
    {
        this.createMask();
    }
    
    /**
     * Actually create the mask it doesn't exist already.
     *
     * @return  Void    
     */
    public function createMask():Void
    {
        if (!this.maskClip)
        {
            this.createEmptyMovieClip('maskClip', this.getNextHighestDepth());
        }
    }
    
    /**
     * Attach to the display. By default, this method immediately dispatches a
     * 'doneAttaching' event. If you wish to perform an intro animation, you
     * should start that here and dispatch the event once the animation is
     * complete.
     *
     * @return  Void    
     */
    public function attach():Void
    {
        // trace(this + '.attach()');
        this.onDoneAttaching();
    }

    /**
     * Detach from the display. Like {@link attach()}, this dispatches a
     * 'doneDetaching' event by default.
     *
     * @param   reason  String  The optional reason for detaching. This is
     *                          passed along with the 'doneDetaching' event so
     *                          that listeners know why the detachment happend.
     * @return  Void
     */
    public function detach(reason:String):Void
    {
        // trace(this + '.detach()');
        this.onDoneDetaching(reason);
    }
    
    /**
     * Using {@link Delegate.create()}, you can use this method as an event
     * handler to perform the actual attachment event dispatch.
     *
     * @return  Void
     */
    public function onDoneAttaching():Void
    {
        this.dispatchEvent({type: 'doneAttaching'});
        this.resetExpirationInterval();
    }
    
    /**
     * Using {@link Delegate.create()}, you can use this method as an event
     * handler to perform the actual detachment event dispatch.
     *
     * @return  Void
     */
    public function onDoneDetaching(reason:String):Void
    {
        this.dispatchEvent({type: 'doneDetaching', reason: reason});
    }
    
    /**
     * expire() is called when the expiryInterval triggers, and by default just
     * detach()es immediately with a reason of 'expired'.
     *
     * @return  Void
     */
    public function expire():Void
    {
        if (!this.alreadyExpired && null != this)
        {
            // trace(this + ".expire(): expiring after " + this.expiry + "ms");
            clearInterval(this.expiryInterval);
            this.detach('expired');
            this.alreadyExpired = true;
        }
    }

    /**
     * Place the object on the display.
     *
     * @return  Void
     */
    public function place():Void
    {
    }

    /**
     * Update the object's size. We override this because UIObject's
     * implementation simply sets _width and _height to the values of __width
     * and __height, respectively.
     */
    public function size():Void
    {
        this.draw();
    }

    /**
     * Draw any visual elements. Line and fill operations should be performed on
     * the movie clip returned by {@link mask()}.
     *
     * @return  Void
     */
    public function draw():Void
    {
    }

    /**
     * Get this object's position as a Point object with context and rotation.
     *
     * @return  Point
     */
    public function point():Point
    {
        return new Point(this._x, this._y, this._parent, this._rotation);
    }
    
    /**
     * Clean up the expiryInterval, just in case we were removed without calling
     * detach() first.
     *
     * @return  Void
     */
    public function onUnload():Void
    {
        clearInterval(this.expiryInterval);
    }
}

