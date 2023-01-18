/*
 * vim:et sts=4 sw=4 cindent tw=120:
 * $Id: HSV.as,v 1.4 2006-08-14 19:31:55 allens Exp $
 */

import com.stamen.utils.MathExt;
import com.stamen.display.color.*;

class com.stamen.display.color.HSV extends ColorModel implements IColorModel
{
    // 0-360
    public var hue:Number = 0;
    // 0-1
    public var sat:Number = 0;
    // 0-1
    public var value:Number = 0;

    public static function black():HSV
    {
        return new HSV(0, 0, 0);
    }

    public static function white():HSV
    {
        return new HSV(0, 0, 1);
    }

    public static function grey(value:Number):HSV
    {
        return new HSV(0, 0, value);
    }

    public static function random():HSV
    {
        return new HSV(MathExt.random(0, 360),
                       MathExt.random(0, 1),
                       MathExt.random(0, 1));
    }

    public static function fromHex(hex:Object):HSV
    {
        return RGB.fromHex(hex).toHSV();
    }

    public function HSV(hue:Number, sat:Number, value:Number)
    {
        if (isFinite(hue)) this.hue = hue;
        if (isFinite(sat)) this.sat = MathExt.bound(sat, 0, 1);
        if (isFinite(value)) this.value = MathExt.bound(value, 0, 1);
    }

    public function copy():IColorModel
    {
        return new HSV(hue, sat, value);
    }

    public function toHSV():HSV
    {
        return HSV(copy());
    }

    public function toRGB():RGB
    {
        var r:Number, g:Number, b:Number;
        // trace('HSV.toRGB(): hue = ' + hue + ', sat = ' + sat + ', value = ' + value);

        if (sat == 0)
        {
            r = g = b = value;
        }
        else
        {
            var hue:Number = hue / 360;
            hue = (hue * 6) % 6;

            var i:Number = Math.floor(hue);

            var v1:Number = value * (1 - sat);
            var v2:Number = value * (1 - sat * (hue - i));
            var v3:Number = value * (1 - sat * (1 - (hue - i)));

            switch (i)
            {
                case 0:
                    r = value;
                    g = v3;
                    b = v1;
                    break;

                case 1:
                    r = v2;
                    g = value;
                    b = v1;
                    break;

                case 2:
                    r = v1;
                    g = value;
                    b = v3;
                    break;

                case 3:
                    r = v1;
                    g = v2;
                    b = value;
                    break;

                case 4:
                    r = v3;
                    g = v1;
                    b = value;
                    break;

                default:
                    r = value;
                    g = v1;
                    b = v2;
                    break;
            }
        }

        r *= 255;
        g *= 255;
        b *= 255;
        // trace('HSV.toRGB(): r = ' + r + ', g = ' + g + ', b = ' + b);
		return new RGB(r, g, b);
    }

	public function invert():HSV
	{
		var inverted:HSV = new HSV(hue % 360, sat, value);
		inverted.hue = 360 - inverted.hue;
		inverted.value = 1 - inverted.value;
		return inverted;
	}

    public function blend(color:IColorModel, amount:Number, asRGB:Boolean):IColorModel
    {
        if (asRGB)
        {
            return toRGB().blend(color.toRGB(), amount, true).toHSV();
        }
        else
        {
            var parts:Array = _blend(color, amount);
            return new HSV(parts[0], parts[1], parts[2]);
        }
    }

    public function toString():String
    {
        var rgb:RGB = toRGB();
        return rgb.toString();
    }

    public function toHex():Number
    {
        var rgb:RGB = toRGB();
        return rgb.toHex();
    }

    public function toArray():Array
    {
        return [hue, sat, value];
    }
}
