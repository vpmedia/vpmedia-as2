/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is PEGAS Framework.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <vegas@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2007
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

import pegas.colors.BasicColor;
import pegas.colors.ColorRGB;

/**
 * Control the tint of a Color object.
 * <p>Thanks 2003 Robert Penner - Use freely, giving credit where possible.</p>
 * <p>This code is based on the book : Robert Penner's Programming Macromedia Flash MX. More informations in :
 * <ul>
 * <li>http://www.robertpenner.com/profmx
 * <li>http://www.amazon.com/exec/obidos/ASIN/0072223561/robertpennerc-20
 * </ul>
 * </p>
 * @author eKameleon
 */
class pegas.colors.TintColor extends BasicColor 
{

	/**
	 * Creates a new TintColor instance.
	 * @param mc the movieclip target of the TintColor object.
 	 */
	public function TintColor (mc:MovieClip) 
	{ 
		super(mc) ;
	}

	/**
	 * Returns the tint of a Color object.
	 * <p><b>Example</b></b>
	 * {@code
	 * var cTint:TintColor = new TintColor(my_mc);
	 * cTint.setTint( 0, 0, 128, 50 ) ;
	 * var tint:Object = cTint.getTint();
	 * trace ("r : " + tint.r);
	 * trace ("g : " + tint.g);
	 * trace ("b : " + tint.b);
	 * trace ("percent : " + tint.percent);
	 * }
	 * @return The tint value object with r, g, b, and percent properties.
	 */
	public function getTint():Object 
	{
		var t:Object = getTransform();
		var percent:Number = 100 - t.ra ;
		var ratio:Number = 100 / percent;
		return { 
			percent: percent ,
			r : t.rb * ratio ,
			g : t.gb * ratio ,
			b : t.bb * ratio 
		} ;
	}

	/**
	 * Returns the tint of a Color object.
	 * <p><b>Example</b></b>
	 * {@code
	 * var cTint:TintColor = new TintColor(my_mc);
	 * cTint.setTint2( 0x0000FF, 100 ) ;
	 * var tint:Object = cTint.getTint2();
	 * trace ("rgb     : " + tint.rgb);
	 * trace ("percent : " + tint.percent);
	 * }
	 * @return The tint value object with rgb and percent properties.
	 */
	public function getTint2():Object 
	{
		var t:Object = getTransform();
		var percent:Number = 100 - t.ra ;
		var ratio:Number = 100 / percent ;
		return { 
			percent:percent ,
			rgb:ColorRGB.rgb2hex(t.rb*ratio, t.gb*ratio, t.bb*ratio) 
		} ;
	}

	/**
	 * Returns the tint offset of a Color object.
	 * <p><b>Example</b></b>
	 * {@code
	 * var cTint:TintColor = new TintColor(my_mc);
	 * cTint.setTintOffset(0, 0, 128);
	 * var tint:Object = cTint.getTintOffset();
	 * trace ("r : " + tint.r);
	 * trace ("g : " + tint.g);
	 * trace ("b : " + tint.b);
	 * }
	 * @return The tint offset value object with r, g, and b properties.
	 */
	public function getTintOffset():Object 
	{
		var t:Object = getTransform() ;
		return {r:t.rb, g:t.gb, b:t.bb} ;
	}

	/**
	 * Tints a color object with a Color according to a certain percentage.
	 * <p><b>Example</b></b>
	 * {@code
	 * var cTint:TintColor = new TintColor(my_mc);
	 * cTint.setTint( 0, 0, 128, 50 ) ;
	 * }
	 * @param r The red color value.
	 * @param g The green color value.
	 * @param b The blue color value.
	 * @param percent
	 */
	public function setTint(r:Number, g:Number, b:Number, percent:Number):Void 
	{
		var ratio:Number = percent / 100;
		var t:Object = { rb:r*ratio, gb:g*ratio, bb:b*ratio } ;
		t.ra = t.ga = t.ba = 100-percent ;
		setTransform (t);
	}

	/**
	 * Tints a color object with a Color according to a certain percentage.
	 * <p><b>Example</b></b>
	 * {@code
	 * var cTint:TintColor = new TintColor(my_mc);
	 * cTint.setTint2( 0x0000FF, 100 ) ;
	 * }
	 * @param hex The rgb value.
	 * @param percent The tint percentage.
	 */
	public function setTint2(hex:Number, percent:Number):Void 
	{
		var c:Object = ColorRGB.hex2rgb (hex) ;
		var ratio:Number = percent / 100 ;
		var t:Object = {rb:c.r*ratio, gb:c.g*ratio, bb:c.b*ratio};
		t.ra = t.ga = t.ba = 100-percent;
		setTransform (t);
	}

	/**
	 * Tints a Color object with a color according to red, green, and blue values.
	 * <p><b>Example</b></b>
	 * {@code
	 * var cTint:TintColor = new TintColor(my_mc);
	 * cTint.setTintOffset( 0, 0, 128 ) ;
	 * }
	 * @param r The red color value.
	 * @param g The green color value.
	 * @param b The blue color value.
	 */
	public function setTintOffset(r:Number, g:Number, b:Number):Void 
	{
		var t:Object = getTransform();
		t.rb = r ; 
		t.gb = g ; 
		t.bb = b ;
		setTransform (t);
	}

}

