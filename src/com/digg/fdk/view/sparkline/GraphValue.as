/*
 * vim:et sts=4 sw=4 cindent:
 * $Id: GraphValue.as 602 2007-01-18 23:35:42Z migurski $
 */

import com.stamen.display.Tooltip;
import com.stamen.display.Draw;
import com.stamen.display.color.*;

class com.digg.fdk.view.sparkline.GraphValue extends MovieClip
{
    public var index:Number;
    public var value:Number;
    public var maxY:Number;
    public var label:String;
    public var width:Number;
    public var highlighted:Boolean = false;
    public var useHandCursor:Boolean = false;

    public var fillColor:RGBA;

    public static var symbolName:String = '__Packages.com.digg.fdk.view.sparkline.GraphValue';
    public static var symbolOwner:Function = GraphValue;
    public static var symbolLink:Boolean = Object.registerClass(symbolName, symbolOwner);

    public function GraphValue()
    {
        this.draw();
    }

    public function draw(active:Boolean):Void
    {
        var y:Number = this.maxY;
        y -= this._y;

        this.clear();
        var c:Number = this.fillColor.toHex(false) || 0xFF0000;
        var alpha:Number = this.fillColor.alpha || 90;

        this.beginFill(c, alpha);

        Draw.rect(this, 0, 0, this.width, y);
        this.endFill();
    }

    public function onRollOver():Void
    {
        this.draw(true);
        if (!this._parent.showTooltips) return;

        var b:Object = this.getBounds();
        Tooltip.show(this.label, this, this._width / 2, b.yMin);
    }

    public function onRollOut():Void
    {
        this.draw(false);
        if (!this._parent.showTooltips) return;
        Tooltip.hide();
    }
}
