/*
 * vim:et sts=4 sw=4 cindent:
 * $Id: StoryClip.as 693 2007-02-26 19:34:20Z allens $
 */

import mx.utils.Delegate;
import mx.transitions.*;
import mx.transitions.easing.*;

import com.stamen.data.Hash;
import com.stamen.utils.MathExt;
import com.digg.geo.*;
import com.stamen.display.*;
import com.digg.fdk.model.*;
import com.digg.fdk.view.*;

class com.digg.fdk.view.StoryClip extends ViewObject
{
	public var expiry:Number = 0; // 30 * 60 * 1000; // 30 minutes
	
    public var story:Story;
    public var canvas:Canvas;
    
    public var userClips:Hash;
    public var origin:Point;
    public var submitTime:Number = 0;
    public var promoteTime:Number = 0;
    public var lastDiggTime:Number = -1;

    public var userAttachHandler:Function;
    public var userDetachHandler:Function;
    
    public var draggable:Boolean = true;
    public var dragging:Boolean = false;
    public var killable:Boolean = false;
    private var killModifier:Number = Key.SHIFT;
    
    private var tween:Tween;
    private var transDuration:Number = 0.25;
    private var transEasing:Function = Regular.easeOut;
    private var diggerSymbol:String = DiggerClip.symbolName;
    private var diggerParams:Object;

    public static var symbolName:String = '__Packages.com.digg.fdk.view.StoryClip';
    public static var symbolOwner:Function = StoryClip;
    private static var symbolLink = Object.registerClass(symbolName, symbolOwner);

    private var watchProperties:Object;
    private var watchInterval:Number;

    public function init():Void
    {
        super.init();
        /*
        watch('watchProperties', Delegate.create(this, onPropertyChanged));
        watchInterval = setInterval(this, 'updateWatch', 250);
        */

        origin = new Point(0, 0, this);

        userClips = new Hash();
        userAttachHandler = Delegate.create(this, onUserDoneAttaching);
        userDetachHandler = Delegate.create(this, onUserDoneDetaching);
        
        submitTime = story.submitDate.toTimestamp();
        promoteTime = (story.status == 'popular')
                      ? story.promoteDate.toTimestamp()
                      : -1;

        draw();
        place();
    }

    public function setupMask():Void
    {
		super.setupMask();
		var title:String = story.title;
		
		var mask:MovieClip = mask();
		mask.onRollOver = Delegate.create(this, showTooltip);
		mask.onRollOut = Delegate.create(this, hideTooltip);
		
		mask.onPress = Delegate.create(this, startDrag);
		mask.onRelease = mask.onReleaseOutside = Delegate.create(this, stopDrag);
    }
    
    public function showTooltip():Void
    {
    		Tooltip.show(story.title, this, 0, 0);
    }
    
    public function hideTooltip():Void
    {
    		Tooltip.hide(this);
    }

    public function updateWatch():Void
    {
        watchProperties = {x: _x,
                           y: _y,
                           w: mask()._width,
                           h: mask()._height,
                           r: _rotation,
                           d: getDepth()};
    }

    /*
    public function onPropertyChanged(property:String, oldValue:Object, newValue:Object):Object
    {
        if (property == 'watchProperties')
        {
            for (var k in newValue)
            {
                if (oldValue[k] != newValue[k])
                {
                    // trace(this + '.onPropertyChanged(): "' + k + '" changed!');
                    dispatchEvent({type: 'moved'});
                    break;
                }
            }
        }

        return newValue;
    }
    */

    public function place():Void
    {
        _x = MathExt.random(0.05, 0.95) * Stage.width;
        _y = MathExt.random(0.05, 0.95) * Stage.height;
    }

    public function attachUser(user:User, destination:Point):MovieClip
    {
        var params:Hash = new Hash({user: user});
        params.update(diggerParams);
        var clip:MovieClip = attachMovie(diggerSymbol,
                                         'digger_' + user.safeKey(),
                                         getNextHighestDepth(),
                                         params);
        // trace('StoryClip.attachUser(): attached ' + clip);
        if (clip.orientToPath)
            clip._rotation = destination.rotation;
        clip._x = destination.x;
        clip._y = destination.y;
        clip.addEventListener('doneAttaching', userAttachHandler);
        clip.addEventListener('doneDetaching', userDetachHandler);
        clip.attach();

        swapDepths(_parent.getNextHighestDepth());
        resetExpirationInterval();
        return clip;
    }

    public function onUserDoneAttaching(event:Object):Void
    {
        // bubble event up
        event.type = 'doneAttachingUser';
        dispatchEvent(event);

        var clip:DiggerClip = event.target;
        // trace('StoryClip.onUserDoneAttaching(): got clip ' + clip);
        var user:User = clip.user;
        userClips.setValue(user.safeKey(), clip);
    }

    public function detachUser(user:User):Boolean
    {
        var clip = this['digger_' + user.safeKey()];
        if (!clip) return false;

        clip.detach();
        return true;
    }

    public function onUserDoneDetaching(event:Object):Void
    {
        var clip:DiggerClip = event.target;
        var user:User = clip.user;
        userClips.deleteKey(user.safeKey());

        event.type = 'doneDetachingUser';
        // trace('StoryClip.onUserDoneDetaching(): bubbling "' + event.type + '" event');
        dispatchEvent(event);
    }

    public function attachPoint(origin:Point, relative:Boolean):Point
    {
        var angle:Number;
        if (relative)
        {
            var o:Point = origin.asLocalPoint(this);
            var line:Line = new Line(origin, o);
            angle = line.angle;
        }
        else
        {
            angle = MathExt.radians(Math.random() * 360);
        }

        /*
         * Find a point that intersects with the outer border of the background
         * clip. We'll start at some point 50px beyond the object's assumed
         * radius.
         */
		var mask:MovieClip = mask();
        var polar:PolarCoordinate = new PolarCoordinate(angle, mask._width / 2 + 50);
        var hit:Boolean = false;
        var cartesian:Point;
        while (!hit)
        {
            cartesian = polar.toCartesian();
            // hitTest() needs global coordinates
            localToGlobal(cartesian);
            hit = mask.hitTest(cartesian.x, cartesian.y, true);
            polar.radius -= 1;
        }
        // put the point back into the local coordinate space
        globalToLocal(cartesian);
        cartesian.context = this;
        return cartesian;
    }

    public function draw():Void
    {
        var mask:MovieClip = mask();
        if (mask.getDepth() >= 0)
        {
            mask.beginFill(0xFF0000, 50);
            Draw.circle(mask, 0, 0, 50);
            mask.endFill();
            mask.lineStyle(1, 0xFFFFFF, 50);
            Draw.circle(mask, 0, 45, 5);
            mask.lineStyle();
        }
    }

    public function attach():Void
    {
        tween = new ScaleTween(this, transEasing, 0, 100, transDuration, true);
        tween.onMotionFinished = Delegate.create(this, onDoneAttaching);
    }

    public function detach():Void
    {
        tween.onMotionFinished = Delegate.create(this, onDoneDetaching);
        tween.continueTo(0);
    }

    /**
     * We override MovieClip.startDrag() instead of onPress() so that the
     * StoryClip's contents can still be interacted with by the mouse.
     */
    public function startDrag(lockCenter:Boolean, left:Number, top:Number, right:Number, bottom:Number):Void
    {
        if (killable && Key.isDown(killModifier))
        {
            trace("StoryClip.startDrag(): killing!");
            detach('killed');
            return;
        }
        else if (!draggable)
        {
            getURL(story.url, "_blank");
            Tooltip.hide();
            return;
        }
        
        super.startDrag(lockCenter, left, top, right, bottom);
        dragging = true;
    }
    
    public function stopDrag():Void
    {
        dragging = false;
        super.stopDrag();
    }

    public function onUnload():Void
    {
        trace('StoryClip.onUnload()');
        super.onUnload();
        clearInterval(watchInterval);
    }
}
