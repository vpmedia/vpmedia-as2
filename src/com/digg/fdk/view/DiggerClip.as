/*
 * vim:et sts=4 sw=4 cindent:
 * $Id: DiggerClip.as 602 2007-01-18 23:35:42Z migurski $
 */

import com.stamen.display.*;
import com.digg.fdk.model.*;
import com.digg.fdk.view.*;

class com.digg.fdk.view.DiggerClip extends ViewObject
{
    public var user:User;
    public var orientToPath:Boolean = true;

    private var expiry:Number = 5 * 60 * 1000; // 5 minutes

    public static var symbolName:String = '__Packages.com.digg.fdk.view.DiggerClip';
    public static var symbolOwner:Function = DiggerClip;
    private static var symbolLink = Object.registerClass(symbolName, symbolOwner);

    public function init():Void
    {
        super.init();
        // trace('DiggerClip.init(): ' + this.user.name);
    }

    public function draw():Void
    {
        var mask:MovieClip = this.mask();
        // trace('DiggerClip.draw(): mask = ' + mask + ', depth: ' + mask.getDepth());
        if (mask.getDepth() >= 0)
        {
            mask.beginFill(0xFFFF00);
            Draw.rect(mask, -4, -4, 8, 8);
            mask.endFill();
        }
    }

    public function onRollOver():Void
    {
        var mask:MovieClip = this.mask();
        Tooltip.show(this.user.name, this, mask._x, mask._y);
    }

    public function onRollOut():Void
    {
        Tooltip.hide(this);
    }

    public function onPress():Void
    {
        getURL(this.user.url, '_blank');
        this.onRollOut();
    }
}
