/*
 * vim:et sts=4 sw=4 cindent tw=120:
 * $Id: RGB.as,v 1.11 2006-08-14 19:31:55 allens Exp $
 */

import com.stamen.utils.MathExt;
import com.stamen.utils.StringExt;
import com.stamen.display.color.*;
import com.stamen.geom.PolarCoordinate;

class com.stamen.display.color.RGB extends ColorModel implements IColorModel
{
    public var red:Number = 0;
    public var green:Number = 0;
    public var blue:Number = 0;

    public static function black():RGB
    {
        return new RGB(0, 0, 0);
    }

    public static function white():RGB
    {
        return new RGB(255, 255, 255);
    }

    public static function grey(n:Number):RGB
    {
        return new RGB(n, n, n);
    }

    public static function random():RGB
    {
        return new RGB(MathExt.random(0, 255),
                       MathExt.random(0, 255),
                       MathExt.random(0, 255));
    }

    public static function fromHex(hex):RGB
    {
        // trace('RGB.fromHex(' + hex + ')');

        if (typeof hex == 'string') hex = parseInt(hex, 16);
        else hex = Number(hex);

        var red:Number = (hex & 0xFF0000) >>> 16;
        var green:Number = (hex & 0x00FF00) >>> 8; 
        var blue:Number = hex & 0x0000FF;

        return new RGB(red, green, blue);
    }

    public function RGB(red:Number, green:Number, blue:Number)
    {
        if (isFinite(red)) this.red = MathExt.bound(red, 0, 255);
        if (isFinite(green)) this.green = MathExt.bound(green, 0, 255);
        if (isFinite(blue)) this.blue = MathExt.bound(blue, 0, 255);
    }

    public function copy():IColorModel
    {
        return new RGB(red, green, blue);
    }

    public function toRGB():RGB
    {
        return RGB(copy());
    }

	public function invert():RGB
	{
		var hsv:HSV = toHSV();
		var inverted:HSV = hsv.invert();
		return inverted.toRGB();
	}

    public function blend(color:IColorModel, amount:Number, asRGB:Boolean):IColorModel
    {
        if (asRGB)
        {
            var parts:Array = _blend(color.toRGB(), amount);
            return new RGB(parts[0], parts[1], parts[2]);
        }
        else
        {
            return toHSV().blend(color.toHSV(), amount, false).toRGB();
        }
    }

    public function toString():String
    {
        var parts:Array = toArray();
        for (var i = 0; i < parts.length; i++)
            parts[i] = StringExt.zerofill(parts[i].toString(16), 2);
        return parts.join('').toUpperCase();
    }
    
    public function toHSV():HSV
    {
        var r:Number = red / 255;
        var g:Number = green / 255;
        var b:Number = blue / 255;
        // trace('RGB.toHSV(): r = ' + r + ', g = ' + g + ', b = ' + b);

        var min:Number = Math.min(r, Math.min(g, b));
        var max:Number = Math.max(r, Math.max(g, b));
        var delta:Number = max - min;
        // trace('RGB.toHSV(): min = ' + min + ', max = ' + max + ', delta = ' + delta);

        var value:Number = max;
        var hue:Number, sat:Number;

        if (max == 0 || delta == 0)
        {
            hue = 0;
            sat = 0;
        }
        else
        {
            sat = delta / max;

            if      (r == max)  { hue = (g - b) / delta;     }
            else if (g == max)  { hue = 2 + (b - r) / delta; }
            else                { hue = 4 + (r - g) / delta; }

            hue *= 60;
            if (hue < 0) hue += 360;
        }

        // trace('RGB.toHSV(): hue = ' + hue + ', sat = ' + sat + ', value = ' + value);
		return new HSV(hue, sat, value);
    }

    public function toHex():Number
    {
        return (red << 16) | (green << 8) | blue;
    }

    public function toArray():Array
    {
        return [red, green, blue];
    }
}
