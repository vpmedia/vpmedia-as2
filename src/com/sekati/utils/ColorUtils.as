/**
 * com.sekati.utils.ColorUtils
 * @version 1.0.0
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 * 
 * Some methods adopted from ca.nectere and gskinner for dependencies only
 */
 
import com.sekati.math.MathBase;

/**
 * Static class wrapping various Color utilities.
 */
class com.sekati.utils.ColorUtils {

	/**
	 * Convert hexadecimal Number to rgb Object
	 * @return Object - {r,g,b}
	 */
	public static function hex2rgb(hex:Number):Object {
		return { r: (hex >> 16) & 0xff, g: (hex >> 8) & 0xff, b: hex & 0xff};
	}

	/**
	 * Convert argb Object to hexidecimal Number
	 * @return Object - {a,r,g,b}
	 */
	public static function hex2argb(val:Number):Object {
		return {a: (val >> 24) & 0xff, r: (val >> 16) & 0xff, g: (val >> 8) & 0xff, b: val & 0xff};
	}	

	/**
	 * Convert argb to hexadecimal.
	 * {@code Usage:
	 * 	hex=argbtohex(255,0,255,0) //outputs a 32-bit red hexadecimal value as a base-10 number
	 * 	}
	 */
	public static function argb2hex(a:Number, r:Number, g:Number, b:Number):Number {
		return (a << 24 | r << 16 | g << 8 | b);
	}

	/**
	 * Convert rgb to hexadecimal.
	 * @return Number
	 */
	public static function rgb2hex(r:Number, g:Number, b:Number):Number {
		return (r << 16 | g << 8 | b);
	}	

	/**
	 * Convert rgb Object to hexadecimal
	 * @param o (Object) a color object {r,g,b}
	 * @return Number
	 */
	public static function rgbObj2hex(o:Object):Number {
		return (o.r << 16 | o.g << 8 | o.b);
	}		

	/**
	 * Convert rgb to hexadecimal String
	 * @param r (Number)
	 * @param g (Number)
	 * @param b (Number)
	 * @param hasPrefix (Boolean) add optional "0x" prefix to return
	 * @return String
	 */
	public static function rgb2hexString(r:Number, g:Number, b:Number, hasPrefix:Boolean):String {
		var hex:String = rgb2hex( r, g, b ).toString( 16 );
		while(hex.length < 6) hex = "0" + hex;
		return (hasPrefix) ? "0x" + hex : hex;
	}

	/**
	 * get a random hexidecimal color
	 * @return String
	 */
	public static function randHex():String {
		return "0x" + Math.floor( Math.random( ) * 16777215 ).toString( 16 ).toUpperCase( );
	}

	/**
	 * set color of a movieclip or textfield
	 * @param obj (Object)
	 * @param hex (Number)
	 * @return Void
	 */
	public static function setColor(obj:Object,hex:Number):Void {
		var c:Color = new Color( obj );
		c.setRGB( hex );
	}

	/**
	 * get color from a movieclip or textfield
	 * @param obj (Object)
	 * @return Number
	 */
	public static function getColor(obj:Object):Number {
		var c:Color = new Color( obj );
		return c.getRGB( );
	}

	/**
	 * Change the contrast of a hexidecimal Number by a certain increment
	 * @param hex (Number) color value to shift contrast on
	 * @param inc (Number) increment value to shift
	 * @return Number - new hex color value
	 */
	public static function changeContrast(hex:Number, inc:Number):Number {
		var o:Object = ColorUtils.hex2rgb( hex );
		o.r = MathBase.constrain( o.r + inc, 0, 255 );
		o.g = MathBase.constrain( o.g + inc, 0, 255 );
		o.b = MathBase.constrain( o.b + inc, 0, 255 );
		return ColorUtils.rgb2hex( o.r, o.g, o.b );
	}	

	private function ColorUtils() {
	}
}