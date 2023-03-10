/**
 * DrawingUtil
 * Copyright © 2006 András Csizmadia
 * Copyright © 2006 VPmedia
 * http://www.vpmedia.hu
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
 * IN THE SOFTWARE.
 * 
 * Project: DrawingUtil
 * File: DrawingUtil.as
 * Created by: András Csizmadia
 *
 */
// Implementations
import com.vpmedia.core.IFramework;
class com.vpmedia.utils.ColorUtilExtended extends Color implements IFramework
{
	// START CLASS
	public var className:String = "ColorUtilExtended";
	public var classPackage:String = "com.vpmedia.utils";
	public var version:String = "2.0.0";
	public var author:String = "András Csizmadia";
	//
	/* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	 * constructor
	 * -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- */
	function ColorUtilExtended (target:Object)
	{
		super (target);
	}
	private static var RGBMAX:Number = 256;
	private static var HUEMAX:Number = 360;
	private static var PCTMAX:Number = 100;
	/* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	 * private static helper methods
	 * -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- */
	private static function componentsFromHex (hexValue:Number):Object
	{
		var tmp = new Object ();
		tmp.r = Math.floor (hexValue / (RGBMAX * RGBMAX));
		tmp.g = Math.floor ((hexValue / RGBMAX) % RGBMAX);
		tmp.b = Math.floor (hexValue % RGBMAX);
		return tmp;
	}
	private static function hexFromComponents (a, b, c):Number
	{
		a = Number (a).toString (16).toUpperCase ();
		if (a.length < 2)
		{
			a = '0' + a;
		}
		else if (a.length > 2)
		{
			a = 'FF';
		}
		b = Number (b).toString (16).toUpperCase ();
		if (b.length < 2)
		{
			b = '0' + b;
		}
		else if (b.length > 2)
		{
			b = 'FF';
		}
		c = Number (c).toString (16).toUpperCase ();
		if (c.length < 2)
		{
			c = '0' + c;
		}
		else if (c.length > 2)
		{
			c = 'FF';
		}
		return Number ('0x' + a + b + c);
	}
	private static function hexFromPercentages (rgbVal:Object):Number
	{
		return hexFromComponents (rgbVal.r * RGBMAX, rgbVal.g * RGBMAX, rgbVal.b * RGBMAX);
	}
	// given three values, return the middle one
	private static function center (a:Number, b:Number, c:Number):Number
	{
		if ((a > b) && (a > c))
		{
			if (b > c)
			{
				return b;
			}
			else
			{
				return c;
			}
		}
		else if ((b > a) && (b > c))
		{
			if (a > c)
			{
				return a;
			}
			else
			{
				return c;
			}
		}
		else if (a > b)
		{
			return a;
		}
		else
		{
			return b;
		}
	}
	private static function limit (value, min, max, wrap)
	{
		if (wrap)
		{
			while (value > max)
			{
				value -= (max - min);
			}
			while (value < min)
			{
				value += (max - min);
			}
		}
		else
		{
			if (value > max)
			{
				value = max;
			}
			if (value < min)
			{
				value = min;
			}
		}
		return value;
	}
	/* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	 *	convert hue to rgb values using a linear transformation
	 *	inputs:	min = minimum of r,g,b
	 *			max = maximum of r,g,b
	 *			hue	= value angle hue
	 *	output:	an object with r,g,b properties on 0 to 1 scale
	 * -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- */
	private static function HueToRGB (min:Number, max:Number, hue:Number):Object
	{
		var mu, md, F, n;
		var am = RGBMAX;
		while (hue < 0)
		{
			hue += HUEMAX;
		}
		n = Math.floor (hue / 60);
		F = (hue - n * 60) / 60;
		n %= 6;
		mu = min + ((max - min) * F);
		md = max - ((max - min) * F);
		switch (n)
		{
		case 0 :
			return {r:max, g:mu, b:min};
		case 1 :
			return {r:md, g:max, b:min};
		case 2 :
			return {r:min, g:max, b:mu};
		case 3 :
			return {r:min, g:md, b:max};
		case 4 :
			return {r:mu, g:min, b:max};
		case 5 :
			return {r:max, g:min, b:md};
		}
	}
	/* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	 *	convert rgb values to a hue using a linear transformation
	 *	inputs:	red, grn, blu on 0 to 1 scale
	 *	output:	a hue degree between 0 and 360
	 * -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- */
	private static function RGBToHue (red:Number, grn:Number, blu:Number):Number
	{
		var F, min, mid, max, n;
		max = Math.max (red, Math.max (grn, blu));
		min = Math.min (red, Math.min (grn, blu));
		// achromatic case
		if (max - min == 0)
		{
			return 0;
		}
		mid = center (red, grn, blu);
		// using this loop to avoid super-ugly nested ifs
		while (true)
		{
			if (red == max)
			{
				if (blu == min)
				{
					n = 0;
				}
				else
				{
					n = 5;
				}
				break;
			}
			if (grn == max)
			{
				if (blu == min)
				{
					n = 1;
				}
				else
				{
					n = 2;
				}
				break;
			}
			if (red == min)
			{
				n = 3;
			}
			else
			{
				n = 4;
			}
			break;
		}
		if ((n % 2) == 0)
		{
			F = mid - min;
		}
		else
		{
			F = max - mid;
		}
		F = F / (max - min);
		return 60 * (n + F);
	}
	/* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	 *	convert RGB values to HLS values
	 *	inputs:	red, grn, blu on 0 to 1 scale
	 *	output:	object with h,l,s values
	 *			h on 0 to 360 scale
	 *			l,s on 0 to 1 scale
	 * -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- */
	static function RGBtoHLS (red:Number, grn:Number, blu:Number):Object
	{
		var min, max, delta;
		var l, s, h = 0;
		max = Math.max (red, Math.max (grn, blu));
		min = Math.min (red, Math.min (grn, blu));
		l = (min + max) / 2;
		// L
		if (l == 0)
		{
			return {h:h, l:0, s:1};
		}
		delta = (max - min) / 2;
		if (l < 0.5)
		{
			// S
			s = delta / l;
		}
		else
		{
			s = delta / (1 - l);
		}
		h = RGBToHue (red, grn, blu);
		return {h:h, l:l, s:s};
	}
	/* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	 *	convert HLS values to RGB values
	 *	inputs:	hue,lum,sat : hue on 0 to 360, others on 0 to 1 scale
	 *	output:	object with r,g,b values on 0 to 1 scale
	 * -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- */
	static function HLStoRGB (hue:Number, lum:Number, sat:Number):Object
	{
		var delta;
		if (lum < 0.5)
		{
			delta = sat * lum;
		}
		else
		{
			delta = sat * (1 - lum);
		}
		return HueToRGB (lum - delta, lum + delta, hue);
	}
	/* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	 *	convert RGB values to HSV values
	 *	inputs:	red, grn, blu on 0 to 1 scale
	 *	output:	object with h,s,v values
	 *			h on 0 to 360 scale
	 *			s,v on 0 to 1 scale
	 * -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- */
	static function RGBtoHSV (red:Number, grn:Number, blu:Number):Object
	{
		var min, max;
		var s, v, h = 0;
		max = Math.max (red, Math.max (grn, blu));
		min = Math.min (red, Math.min (grn, blu));
		if (max == 0)
		{
			return {h:0, s:0, v:0};
		}
		v = max;
		s = (max - min) / max;
		h = RGBToHue (red, grn, blu);
		return {h:h, s:s, v:v};
	}
	/* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	 *	convert HSV values to RGB values
	 *	inputs:	hue,sat,val : hue on 0 to 360, others on 0 to 1 scale
	 *	output:	object with r,g,b values on 0 to 1 scale
	 * -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- */
	static function HSVtoRGB (hue:Number, sat:Number, val:Number):Object
	{
		var min = (1 - sat) * val;
		return HueToRGB (min, val, hue);
	}
	/* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	 *	HSV<->HLS conversions
	 *	these simply use the RGB conversions as a go-between
	 *	preservation of color may be dubious, here
	 * -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- */
	static function HSVtoHLS (hue:Number, sat:Number, val:Number):Object
	{
		var rgbVal = HSVtoRGB (hue, sat, val);
		return RGBtoHLS (rgbVal.r, rgbVal.g, rgbVal.b);
	}
	static function HLStoHSV (hue:Number, lum:Number, sat:Number):Object
	{
		var rgbVal = HLStoRGB (hue, lum, sat);
		return RGBtoHSV (rgbVal.r, rgbVal.g, rgbVal.b);
	}
	/* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	 * RGB component methods
	 * -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- */
	function setRGBComponent (r:Number, g:Number, b:Number):Void
	{
		r = limit (r, 0, RGBMAX, false);
		g = limit (g, 0, RGBMAX, false);
		b = limit (b, 0, RGBMAX, false);
		this.setRGB (hexFromComponents (r, g, b));
	}
	function getRGBComponent ():Object
	{
		var tmpVal = componentsFromHex (this.getRGB ());
		return {r:tmpVal.r, g:tmpVal.g, b:tmpVal.b};
	}
	/* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	 * HLS component methods
	 * -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- */
	function setHLSComponent (h:Number, l:Number, s:Number):Void
	{
		h = limit (h, 0, HUEMAX, true);
		l = limit (l, 0, PCTMAX, false) / PCTMAX;
		s = limit (s, 0, PCTMAX, false) / PCTMAX;
		var rgbVal = HLStoRGB (h, l, s);
		this.setRGB (hexFromPercentages (rgbVal));
	}
	function getHLSComponent ():Object
	{
		var rgbVal = componentsFromHex (this.getRGB ());
		rgbVal.r /= 256;
		rgbVal.g /= 256;
		rgbVal.b /= 256;
		var hlsVal = RGBtoHLS (rgbVal.r, rgbVal.g, rgbVal.b);
		hlsVal.h = Math.round (hlsVal.h);
		hlsVal.l = Math.round (hlsVal.l * PCTMAX);
		hlsVal.s = Math.round (hlsVal.s * PCTMAX);
		return hlsVal;
	}
	/* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	 * HSV component methods
	 * -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- */
	function setHSVComponent (h:Number, s:Number, v:Number):Void
	{
		h = limit (h, 0, HUEMAX, true);
		s = limit (s, 0, PCTMAX, false) / PCTMAX;
		v = limit (v, 0, PCTMAX, false) / PCTMAX;
		var rgbVal = HSVtoRGB (h, s, v);
		this.setRGB (hexFromPercentages (rgbVal));
	}
	function getHSVComponent ():Object
	{
		var rgbVal = componentsFromHex (this.getRGB ());
		rgbVal.r /= 256;
		rgbVal.g /= 256;
		rgbVal.b /= 256;
		var hsvVal = RGBtoHSV (rgbVal.r, rgbVal.g, rgbVal.b);
		hsvVal.h = Math.round (hsvVal.h);
		hsvVal.s = Math.round (hsvVal.s * PCTMAX);
		hsvVal.v = Math.round (hsvVal.v * PCTMAX);
		return hsvVal;
	}
	/**
	 * <p>Description: Get Class version</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	public function getVersion ():String
	{
		//trace ("%%" + "getVersion" + "%%");
		var __version = this.version;
		return __version;
	}
	/**
	 * <p>Description: Get Class name</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	public function toString ():String
	{
		return ("[" + className + "]");
	}
	// END CLASS
}
