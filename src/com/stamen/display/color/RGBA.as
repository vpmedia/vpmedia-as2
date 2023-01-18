/*
 * vim:et sts=4 sw=4 cindent:
 * $Id$
 */

import com.stamen.utils.MathExt;
import com.stamen.display.color.*;

class com.stamen.display.color.RGBA extends RGB
{
	public var alpha:Number = 100;

	public static function black(alpha:Number):RGBA
	{
		return RGBA.fromRGB(RGB.black(), alpha);
	}

	public static function white(alpha:Number):RGBA
	{
		return RGBA.fromRGB(RGB.white(), alpha);
	}

	public static function grey(lightness:Number, alpha:Number):RGBA
	{
		return RGBA.fromRGB(RGB.grey(lightness), alpha);
	}

	public static function fromRGB(rgb:RGB, alpha:Number):RGBA
	{
		return new RGBA(rgb.red, rgb.green, rgb.blue, alpha);
	}

	public static function fromHex(hex):RGBA
	{
        if (typeof hex == 'string') hex = parseInt(hex, 16);
        else hex = Number(hex);

		var alpha:Number = (hex & 0xFF000000) >>> 24;
		hex = hex & 0x00FFFFFF;
		var rgb:RGB = RGB.fromHex(hex);
		return RGBA.fromRGB(rgb, alpha);
	}

	public function RGBA(red:Number, green:Number, blue:Number, alpha:Number)
	{
		super(red, green, blue);
		if (isFinite(alpha)) this.alpha = MathExt.bound(alpha, 0, 255);
	}

    public function copy():RGBA
    {
        return new RGBA(this.red, this.green, this.blue, this.alpha);
    }

    public function blend(color:RGBA, amount:Number):RGB
    {
		var parts:Array = this._blend(color, amount);
        return new RGBA(parts[0], parts[1], parts[2], parts[3]);
    }

	public function get rgb():RGB
	{
		return new RGB(this.red, this.green, this.blue);
	}

	public function set rgb(rgb:RGB):Void
	{
		this.red = rgb.red;
		this.green = rgb.green;
		this.blue = rgb.blue;
	}

	public function toHex(withAlpha:Boolean):Number
	{
		if (withAlpha)
        {
            var hex:Number = super.toHex() >> 8;
            hex |= ((255 * this.alpha / 100) << 24);
            return hex;
        }
        else
        {
            return super.toHex();
        }
	}
}

