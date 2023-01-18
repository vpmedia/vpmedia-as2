/**
 * ColorUtil
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
 * Project: ColorUtil
 * File: ColorUtil.as
 * Created by: András Csizmadia
 *
 */
// Implementations
import com.vpmedia.core.IFramework;
class com.vpmedia.utils.ColorUtil extends Color implements IFramework
{
	// START CLASS
	public var className:String = "ColorUtil";
	public var classPackage:String = "com.vpmedia.utils";
	public var version:String = "2.0.0";
	public var author:String = "András Csizmadia";
	//
	//hue: 0-360
	//saturation: 0-100
	//brightness: 0-100
	public static function hsbtorgb (hue:Number, saturation:Number, brightness:Number):Object
	{
		var red, green, blue;
		hue %= 360;
		if (brightness == 0)
		{
			return {red:0, green:0, blue:0};
		}
		saturation /= 100;
		brightness /= 100;
		hue /= 60;
		var i = Math.floor (hue);
		var f = hue - i;
		var p = brightness * (1 - saturation);
		var q = brightness * (1 - (saturation * f));
		var t = brightness * (1 - (saturation * (1 - f)));
		switch (i)
		{
		case 0 :
			red = brightness;
			green = t;
			blue = p;
			break;
		case 1 :
			red = q;
			green = brightness;
			blue = p;
			break;
		case 2 :
			red = p;
			green = brightness;
			blue = t;
			break;
		case 3 :
			red = p;
			green = q;
			blue = brightness;
			break;
		case 4 :
			red = t;
			green = p;
			blue = brightness;
			break;
		case 5 :
			red = brightness;
			green = p;
			blue = q;
			break;
		}
		red = Math.round (red * 255);
		green = Math.round (green * 255);
		blue = Math.round (blue * 255);
		return {red:red, green:green, blue:blue};
	}
	//red: 0-255
	//green: 0-255
	//blue: 0-255
	public static function rgbtohsb (red:Number, green:Number, blue:Number):Object
	{
		var min = Math.min (Math.min (red, green), blue);
		var brightness = Math.max (Math.max (red, green), blue);
		var delta = brightness - min;
		var saturation = (brightness == 0) ? 0 : delta / brightness;
		var hue;
		if (saturation == 0)
		{
			hue = 0;
		}
		else
		{
			if (red == brightness)
			{
				hue = (60 * (green - blue)) / delta;
			}
			else if (green == brightness)
			{
				hue = 120 + (60 * (blue - red)) / delta;
			}
			else
			{
				hue = 240 + (60 * (red - green)) / delta;
			}
			if (hue < 0)
			{
				hue += 360;
			}
		}
		saturation *= 100;
		brightness = (brightness / 255) * 100;
		return {hue:hue, saturation:saturation, brightness:brightness};
	}
	//red: 0-255
	//green: 0-255
	//blue: 0-255
	public static function rgbtohex24 (red:Number, green:Number, blue:Number):Number
	{
		return (red << 16 | green << 8 | blue);
	}
	//color: 24 bit base 10 number
	public static function hex24torgb (color:Number):Object
	{
		var r = color << 16 & 0xff;
		var g = color << 8 & 0xFF;
		var b = color & 0xFF;
		return {red:r, green:g, blue:b};
	}
	//alpha: 0-255
	//red: 0-255
	//green: 0-255
	//blue: 0-255
	public static function argbtohex32 (red:Number, green:Number, blue:Number, alpha:Number):Number
	{
		return (alpha << 24 | red << 16 | green << 8 | blue);
	}
	//color: 32 bit base 10 number
	public static function hex32toargb (color:Number):Object
	{
		var a = color << 24 & 0xFF;
		var r = color << 16 & 0xff;
		var g = color << 8 & 0xFF;
		var b = color & 0xFF;
		return {alpha:a, red:r, green:g, blue:b};
	}
	public static function hex24tohsb (color:Number):Object
	{
		var rgb = ColorConversion.hex24torgb (color);
		return ColorConversion.rgbtohsb (rgb.red, rgb.green, rgb.blue);
	}
	public static function hsbtohex24 (hue:Number, saturation:Number, brightness:Number):Number
	{
		var rgb = ColorConversion.hsbtorgb (hue, saturation, brightness);
		return ColorConversion.rgbtohex24 (rgb.red, rgb.green, rgb.blue);
	}
	public static function toHexadecimalString (val:Number):String
	{
		return "0x" + val.toString (16).toUpperCase ();
	}
	public static function changeMcColor( _mcName:MovieClip, _color:String ):Void
	{
		var i_color:Color = new Color(_mcName);
		var val:Number = Number("0x"+_color);
		i_color.setRGB(val);
	}
	
	public static function changeDynamicTextColor( _txt:TextField, _color:String ):Void
	{
		var i_tf:TextFormat	= new TextFormat();
		i_tf.color = Number("0x"+_color);
		_txt.setTextFormat(i_tf);
	}
	
	public static function changeInputTextColor( _txt:TextField, _color:String ):Void
	{
	    var i_tf:TextFormat	= new TextFormat();
		i_tf.color = Number("0x"+_color);
		_txt.setNewTextFormat(i_tf);
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
