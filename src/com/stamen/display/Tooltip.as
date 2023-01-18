/*
 * vim:et sts=4 sw=4 cindent:
 * $Id: Tooltip.as 401 2006-09-29 17:24:27Z allens $
 */

import mx.core.UIObject;
import com.digg.geo.Point;
import com.stamen.display.color.RGBA;

class com.stamen.display.Tooltip extends UIObject
{
    private static var _instance:Tooltip;
    private static var _interval:Number;

    public var label:TextField;
    public var radius:Number = 5;
    public var padding:Number = 2;
    private var _follow:MovieClip;
    private var _followPosition:Object;

    public var borderColor:RGBA;
    public var bgColor:RGBA;

    public static var symbolName:String = '__Packages.com.stamen.display.Tooltip';
    public static var symbolOwner:Function = Tooltip;
    private static var symbolLinked = Object.registerClass(symbolName, symbolOwner);

    public static function create():Tooltip
    {
        if (!Tooltip._instance)
            Tooltip._instance = Tooltip(_root.attachMovie(Tooltip.symbolName, '_tooltip', _root.getNextHighestDepth()));
        return Tooltip._instance;
    }

    public static function show(text:String, where:MovieClip,
                                x:Number, y:Number,
                                xOff:Number, yOff:Number):Tooltip
    {
        var inst:Tooltip = Tooltip.create();

        if (null == x) x = 0;
        if (null == y) y = 0;

        if (where)
        {
            inst.follow(where, x, y);
        }
        else
        {
            inst.stopFollowing();
            inst._x = x;
            inst._y = y;
        }

        inst.text = text;
        inst._show(xOff, yOff);

        inst.swapDepths(_root.getNextHighestDepth());
        return inst;
    }

    public static function hide(where:MovieClip):Void
    {
        var inst:Tooltip = Tooltip.create();
        inst.stopFollowing(where);
        inst._hide();
    }

    public static function setTextFormat(tf:TextFormat, embedFonts:Boolean, antiAliasType:Boolean):TextFormat
    {
        var inst:Tooltip = Tooltip.create();
        var old:TextFormat = inst.label.getTextFormat();
        inst.label.embedFonts = (embedFonts == true);
        // inst.label.antiAliasType = (antiAliasType == true);
        inst.label.setNewTextFormat(tf);
        return old;
    }

    public static function getTextFormat():TextFormat
    {
        var inst:Tooltip = Tooltip.create();
        return inst.label.getTextFormat();
    }

    public static function setBackgroundColor(bgColor:RGBA):RGBA
    {
        var inst:Tooltip = Tooltip.create();
        var old:RGBA = inst.bgColor;
        inst.bgColor = bgColor;
        return old;
    }

    public static function setBorderColor(borderColor:RGBA):RGBA
    {
        var inst:Tooltip = Tooltip.create();
        var old:RGBA = inst.borderColor;
        inst.borderColor = borderColor;
        return old;
    }

    public function init():Void
    {
        this.createTextField('label', this.getNextHighestDepth(), 0, 0, 100, 0);
        with (this.label)
        {
            setNewTextFormat(new TextFormat('Verdana', 10, 0x666666));
            autoSize = 'left';
            selectable = false;
            embedFonts = false;
        }

        if (null == this.borderColor)
            this.borderColor = RGBA.fromHex(0xCCCCCC, 255);
        if (null == this.bgColor)
            this.bgColor = RGBA.fromHex(0xFFFFCC, 255);

        this._hide();
    }

    public function size():Void { return; }

    public function set text(text:String):Void
    {
        this.label.text = text;
    }

    public function get text():String
    {
        return this.label.text;
    }

    private function _show(xOff:Number, yOff:Number):Void
    {
        if (null == xOff) xOff = 1;
        if (null == yOff) yOff = -1;

        this.label._x = (xOff > 0)
                        ? this.radius
                        : (xOff < 0)
                          ? 0 - (this.label._width + this.radius)
                          : 0 - (this.label._width / 2);

        this.label._y = (yOff > 0)
                        ? this.radius
                        : (yOff < 0)
                          ? 0 - (this.label._height + this.radius)
                          : 0 - (this.label._height / 2);

        var p:Point = new Point(this.label._x + this.label._width, 0, this);
        p = p.asLocalPoint(_root, false);

        if (p.x >= Stage.width)
        {
            xOff = -1;
            this.label._x = 0 - (this.label._width + this.radius);
        }

        var r:Number = this.radius;
        var bounds:Object = {xMin: this.label._x - this.padding,
                             yMin: this.label._y - this.padding + 1,
                             xMax: this.label._x + this.label._width + this.padding,
                             yMax: this.label._y + this.label._height + this.padding - 2};

        var p1:Object = {x: bounds.xMin, y: bounds.yMax - r};
        var p2:Object = {x: 0, y: bounds.yMax};
        var p3:Object;
        var centered:Boolean = false;

        if (xOff > 0)
        {
            p2.x = bounds.xMin + r;
        }
        else if (xOff < 0)
        {
            p2.x = bounds.xMax - r;
            bounds._xMin = bounds.xMin;
            bounds.xMin = bounds.xMax;
            bounds.xMax = bounds._xMin;
            p1.x = bounds.xMin;
        }
        else
        {
            p1.x = bounds.xMin + (bounds.xMax - bounds.xMin) / 2 - r;
            p2.x = p1.x + r * 2;
            p1.y = p2.y = bounds.yMin;
        }

        if (yOff > 0)
        {
            if (xOff != 0)
            {
                p2.y = bounds.yMin;
                p1.y = bounds.yMin + r;
            }
            bounds._yMin = bounds.yMin;
            bounds.yMin = bounds.yMax;
            bounds.yMax = bounds._yMin;
        }
        else if (yOff < 0)
        {
        }
        else if (xOff != 0)
        {
            p1.x = p2.x = bounds.xMin;
            p1.y = bounds.yMin + (bounds.yMax - bounds.yMin) / 2 - r;
            p2.y = p1.y + r * 2;
            p3 = {x: bounds.xMin, y: bounds.yMax}
        }

        this.clear();
        this.moveTo(0, 0);
        this.lineStyle(0, this.borderColor.toHex(false), this.borderColor.alpha);
        this.beginFill(this.bgColor.toHex(false), this.bgColor.alpha);
        this.lineTo(p1.x, p1.y);
        this.lineTo(bounds.xMin, bounds.yMin);
        this.lineTo(bounds.xMax, bounds.yMin);
        this.lineTo(bounds.xMax, bounds.yMax);
        if (null != p3)
            this.lineTo(p3.x, p3.y);
        this.lineTo(p2.x, p2.y);
        this.lineTo(0, 0);
        this.endFill();
        this.lineStyle();

        this._visible = true;
    }

    public function follow(where:MovieClip, x:Number, y:Number):Void
    {
        this._follow = where;
        this._followPosition = {x: x, y: y};
        this.followEnterFrame();
        this.onEnterFrame = this.followEnterFrame;
    }

    public function stopFollowing(where:MovieClip):Void
    {
        if (null == where || this._follow == where)
        {
            delete this._follow;
            delete this._followPosition;
            delete this.onEnterFrame;
        }
    }

    public function followEnterFrame():Void
    {
        var pos:Object = {x: this._followPosition.x, y: this._followPosition.y};
        this._follow.localToGlobal(pos);
        this._x = pos.x;
        this._y = pos.y;
    }

    private function _hide():Void
    {
        this._visible = false;
    }
}
