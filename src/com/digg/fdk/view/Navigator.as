/*
 * vim:et sts=4 sw=4 cindent:
 * $Id: Navigator.as 605 2007-01-18 23:51:57Z allens $
 */

import mx.core.UIObject;
import mx.utils.Delegate;

import com.stamen.display.*;
import com.stamen.utils.MathExt;

class com.digg.fdk.view.Navigator extends UIObject
{
    public var content:MovieClip;
    public var margin:Number = 16;
    private var alignment:String = 'TL';

    public var trackedClips:Array;
    public var trackStage:MovieClip;
    public var trackInterval:Number;

    public var frame:MovieClip;
    public var nav:MovieClip;
    public var dragging:Boolean = false;

    public static var symbolName:String = '__Packages.com.digg.fdk.view.Navigator';
    public static var symbolOwner:Function = Navigator;
    public static var symbolLink = Object.registerClass(symbolName, symbolOwner);

    public function init():Void
    {
        this.createEmptyMovieClip('frame', this.getNextHighestDepth());

        this.createEmptyMovieClip('nav', this.getNextHighestDepth());
        this.nav.onPress = Delegate.create(this, this.onNavDown);
        this.nav.onRelease = this.nav.onReleaseOutside = Delegate.create(this, this.onNavUp);

        this.createEmptyMovieClip('trackStage', this.getNextHighestDepth());
        this.trackedClips = new Array();
        this.trackInterval = setInterval(this, 'trackClips', 100);

        Stage.addListener(this);
        this.onResize();
    }

    public function startTracking(clip:MovieClip, color:Number):Boolean
    {
        for (var i = 0; i < this.trackedClips.length; i++)
        {
            if (this.trackedClips[i] == clip)
                return false;
        }
        this.trackedClips.push(clip);
        clip._trackColor = (null == color) ? 0xFFFF00 : color;
        return true;
    }

    public function stopTracking(clip:MovieClip):Boolean
    {
        for (var i = 0; i < this.trackedClips.length; i++)
        {
            if (this.trackedClips[i] == clip)
            {
                this.trackedClips.splice(i, 1);
                return true;
            }
        }
        return false;
    }

    public function trackClips():Void
    {
        this.trackStage.clear();
        for (var i:Number = 0; i < this.trackedClips.length; i++)
        {
            this._updateClipTracking(this.trackedClips[i]);
        }
        updateAfterEvent();
    }

	public function getContentBounds(clip:MovieClip, context:MovieClip):Object
	{
		var boundClip:MovieClip = clip;
		if (typeof this.content.mask == 'function')
		{
			boundClip = clip.mask();
		}
		else if (typeof this.content.mask == 'movieclip')
		{
			boundClip = clip.mask;
		}
		return boundClip.getBounds(context);
	}
	
    private function _updateClipTracking(clip:MovieClip):Void
    {
        if (!clip._visible) return;

        var contentBounds = this.getContentBounds(this.content, _root);
        var w = contentBounds.xMax - contentBounds.xMin;
        var h = contentBounds.yMax - contentBounds.yMin;
        var bounds:Object = this.getContentBounds(clip, this.content);
        var xMax = this.frame._width;
        var yMax = this.frame._height;
        bounds.xMin = Math.round(xMax * bounds.xMin / w);
        bounds.xMax = Math.round(xMax * bounds.xMax / w);
        bounds.yMin = Math.round(yMax * bounds.yMin / h);
        bounds.yMax = Math.round(yMax * bounds.yMax / h);
        if ((bounds.xMin < 0 && bounds.xMax < 0) ||
            (bounds.xMin > xMax && bounds.xMax > xMax) ||
            (bounds.yMin < 0 && bounds.yMax < 0) ||
            (bounds.yMin > yMax && bounds.yMax > yMax))
        {
            return;
        }

        bounds.xMin = MathExt.bound(bounds.xMin, 0, xMax);
        bounds.yMin = MathExt.bound(bounds.yMin, 0, yMax);
        bounds.xMax = MathExt.bound(bounds.xMax, 0, xMax);
        bounds.yMax = MathExt.bound(bounds.yMax, 0, yMax);
        this.trackStage.lineStyle(0, clip._trackColor, 100);
        Draw.rect(this.trackStage,
                  bounds.xMin,
                  bounds.yMin,
                  (bounds.xMax - bounds.xMin),
                  (bounds.yMax - bounds.yMin));
    }

    public function onResize():Void
    {
        this.size();
    }

    public function size():Void
    {
        this.updateNav();
        this.updateContent();
        this.updatePosition();
    }

    public function onNavDown():Void
    {
        if (!this.dragging)
        {
            if (this.nav._width <= this.frame._width &&
                this.nav._height <= this.frame._height)
            {
                this.nav.startDrag(false, 0, 0,
                                   this.frame._width - this.nav._width,
                                   this.frame._height - this.nav._height);
            }
            else
            {
                this.nav.startDrag();
            }

            this.onEnterFrame = this.dragEnterFrame;
            this.dragging = true;
        }
    }

    public function onNavUp():Void
    {
        if (this.dragging)
        {
            this.dragEnterFrame();
            this.nav.stopDrag();
            delete this.onEnterFrame;
            this.dragging = false;
        }
    }

    public function dragEnterFrame():Void
    {
        this.boundContent();
        updateAfterEvent();
    }

    public function setContent(content:MovieClip):Void
    {
        this.content = content;
        this.size();
    }

    public function updateContent():Void
    {
        if (!this.content) return;

        var bounds = this.getContentBounds(this.content, _root);
        var w = bounds.xMax - bounds.xMin;
        var h = bounds.yMax - bounds.yMin;
        this.frame.clear();
        // this.frame.lineStyle(0, 0x000000, 10);
        this.frame.beginFill(0x000000, 5);

        var aspectRatio = w / h;
        var actualWidth = this.__width;
        var actualHeight = actualWidth / aspectRatio;
        // trace('updateContent(): w/h = ' + actualWidth + '/' + actualHeight);

        Draw.rect(this.frame, 0, 0, actualWidth, actualHeight);
        this.frame.endFill();

        this.updatePosition();
        this.boundContent();
    }

    public function boundContent():Void
    {
        /*
        // trace('frame dimensions: ' + this.frame._width + '/' + this.frame._height);
        this.nav._x = MathExt.bound(this.nav._x, 0, this.frame._width - this.nav._width);
        this.nav._y = MathExt.bound(this.nav._y, 0, this.frame._height - this.nav._height);
        */

        var bounds = this.getContentBounds(this.content, _root);
        var w = bounds.xMax - bounds.xMin;
        var h = bounds.yMax - bounds.yMin;

        this.content._x = 0 - w * this.nav._x / this.frame._width;
        this.content._y = 0 - h * this.nav._y / this.frame._height;
    }

    public function updateNav():Void
    {
        this.nav.clear();
        this.nav.lineStyle(0, 0x000000, 20);
        this.nav.beginFill(0x000000, 10);
        var bounds = this.getContentBounds(this.content, _root);
        var contentWidth = bounds.xMax - bounds.xMin;
        var aspectRatio = Stage.width / Stage.height;
        var actualWidth = Stage.width / contentWidth * this.__width;
        var actualHeight = actualWidth / aspectRatio;
        // trace('updateNav(): w/h = ' + actualWidth + '/' + actualHeight);
        Draw.rect(this.nav, 0, 0, actualWidth, actualHeight);
        this.nav.endFill();
        this.nav.lineStyle();
    }

    public function updatePosition():Void
    {
        switch (this.alignment.substr(0, 1))
        {
            case 'B':
                this._y = Stage.height - (this.frame._height + this.margin);
                break;
            // assume 'T'
            case 'T':
            default:
                this._y = this.margin;
        }
        switch (this.alignment.substr(1, 1))
        {
            case 'R':
                this._x = Stage.width - (this.frame._width + this.margin);
                break;
            // assume 'L'
            case 'L':
            default:
                this._x = this.margin;
        }
        // trace('updatePosition(): x/y = ' + this._x + '/' + this._y);
    }

    public function set align(alignment:String):Void
    {
        this.alignment = alignment;
        this.size();
    }

    public function get align():String
    {
        return this.alignment;
    }
}
