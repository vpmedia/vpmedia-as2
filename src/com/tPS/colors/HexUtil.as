/**
 * @author tPS
 * Utility for
 * calculation in Hex to RGB
 * @version 1
 */
class com.tPS.colors.HexUtil {
	
	
	/**
	 * @name ARGB2Hex
	 * @description: outputs a 32-bit red hexadecimal value as a base-10 number
	 * @param a :	alpha value between 0 - 255
	 * @param r :	red value between 0 - 255
	 * @param g : 	green value between 0 - 255
	 * @param b : blue value between 0 - 255
	 */
	static function ARGB2Hex(a:Number, r:Number, g:Number, b:Number) : Number{
	    return (a<<24 | r<<16 | g<<8 | b);
	}
	
	/**
	 * @name ARGB2Hex
	 * @description: outputs a 24-bit red hexadecimal value as a base-10 number
	 * @param r :	red value between 0 - 255
	 * @param g : 	green value between 0 - 255
	 * @param b : blue value between 0 - 255
	 */
	static function RGB2Hex(r:Number, g:Number, b:Number) : Number{
	    return (r<<16 | g<<8 | b);
	}
	
	/**
	 * @name Hex2ARGB
	 * @description: outputs a 32-bit red hexadecimal value as a base-10 number
	 * @usage 		argb=hextoargb(0xFFFFCC00);
					alpha=argb.alpha;
					red=argb.red;
					green=argb.green;
					blue=argb.blue;
	 *@param val 	HEX-Colorvalue
	 */
	static function hex2ARGB(val:Number):Object{
	    var col={};
	    col.alpha = (val >> 24) & 0xFF;
	    col.red = (val >> 16) & 0xFF;
	    col.green = (val >> 8) & 0xFF;
	    col.blue = val & 0xFF;
	    return col;
	}
	
	/**
	 * @name Hex2RGB
	 * @description: outputs a 32-bit red hexadecimal value as a base-10 number
	 * @usage 		argb=hextoargb(0xFFFFCC);
					red=argb.red;
					green=argb.green;
					blue=argb.blue;
	 * @param val	Hex-Colorvalue
	 */
	static function hex2RGB(val:Number):Object{
	    var col={};
	    col.red = (val >> 16) & 0xFF;
	    col.green = (val >> 8) & 0xFF;
	    col.blue = val & 0xFF;
	    return col;
	}
	
	
	
	
	 
	
	
	
	
}