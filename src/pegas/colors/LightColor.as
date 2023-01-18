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

/**
 * This class is the basic extension of the actionscript Color class to changed light and contrast over a MovieClip. 
 * <p>Thanks 2003 Robert Penner - Use freely, giving credit where possible.</p>
 * <p>This code is based on the book : Robert Penner's Programming Macromedia Flash MX. More informations in :
 * <ul>
 * <li>http://www.robertpenner.com/profmx
 * <li>http://www.amazon.com/exec/obidos/ASIN/0072223561/robertpennerc-20
 * </ul>
 * </p>
 * <p>
 * {@code 
 * import asgard.colors.BasicColor;
 * var c:LightColor = new LightColor(mc); 
 * c.setBrightness(55);
 * }
 * </p>
 * @author eKameleon
 */
class pegas.colors.LightColor extends BasicColor {

	/**
	 * Creates a new LightColor instance.
	 */
	public function LightColor (mc:MovieClip) 
	{ 
		super (mc) ;
	}
	
	/**
	 * Returns the bright between 0 and 100 of an movieclip.
	 * @return the bright between 0 and 100 of an movieclip.
	 */
	public function get brightness():Number 
	{
		return getBrightness() ;	
	}

	/**
	 * Sets the bright between 0 and 100 of an movieclip.
	 */
	public function set brightness(n:Number):Void 
	{
		setBrightness(n) ;	
	}

	/**
	 * Returns the bright between -255 and 255 of an movieclip.
	 * @return the bright between 255 and 255 of an movieclip.
	 */
	public function get brightOffset():Number 
	{
		return getBrightOffset() ;	
	}

	/**
	 * Sets the bright between -255 and 255 of an movieclip.
	 */
	public function set brightOffset(n:Number):Void 
	{
		setBrightOffset(n) ;	
	}

	/**
	 * Returns the contrast value (percent) of the movieclip.
	 * @return the contrast value (percent) of the movieclip.
	 */
	public function get contrast():Number 
	{
		return getContrast() ;	
	}
	
	/**
	 * Sets the contrast value (percent) of the movieclip.
	 */
	public function set contrast(n:Number):Void 
	{
		setContrast(n) ;	
	}

	/**
	 * Returns the negative value of the movieclip.
	 * @return  the negative value of the movieclip.
	 */
	public function get negative():Number 
	{
		return getNegative() ;	
	}

	/**
	 * Sets the negative percent value of the movieclip.
	 */
	public function set negative(n:Number):Void 
	{
		setNegative(n) ;	
	}

	/**
	 * Returns the bright between 0 and 100 of an movieclip.
	 * @return the bright between 0 and 100 of an movieclip.
	 */
	public function getBrightness():Number 
	{
		var t:Object = getTransform();
		return t.rb ? 100-t.ra : t.ra-100;
	}

	/**
	 * Returns the contrast value (percent) of the movieclip.
	 * @return the contrast value (percent) of the movieclip.
	 */
	public function getContrast():Number
	{ 
		return getTransform().ra ; 
	}

	/**
	 * Returns the bright between 0 and 100 of an movieclip.
	 * @return the bright between 0 and 100 of an movieclip.
	 */
	public function getBrightOffset():Number 
	{ 
		return getTransform().rb ; 
	}
	
	/**
	 * Returns the negative color value of the movieclip.
	 */
	public function getNegative():Number 
	{ 
		return getTransform().rb * 2.55 ; 
	}

	/**
	 * Sets the bright between 0 and 100 of an movieclip.
	 */
	public function setBrightness(percent:Number):Void 
	{
		var t:Object = getTransform() ;
		t.ra = t.ga = t.ba = 100 - Math.abs (percent) ;
		t.rb = t.gb = t.bb = (percent > 0) ? (percent*2.56) : 0 ;
		setTransform (t);
	}
	
	/**
	 * Sets the contrast value (percent) of the movieclip.
	 */
	public function setContrast(percent:Number):Void 
	{
		var t:Object = {};
		t.ra = t.ga = t.ba = percent;
		t.rb = t.gb = t.bb = 128 - (128/100 * percent);
		setTransform(t);
	}

	/**
	 * Sets the brightness of a movieclip between -255 and 255.
	 */
	public function setBrightOffset(offset:Number):Void 
	{
		var t:Object = getTransform();
		t.rb = t.gb = t.bb = offset ;
		setTransform (t);
	}

	/**
	 * Sets the negative value of the movieclip.
	 */
	public function setNegative(percent:Number):Void 
	{
		var t:Object = {} ;
		t.ra = t.ga = t.ba = 100 - 2 * percent;
		t.rb = t.gb = t.bb = percent * (2.55) ;
		setTransform (t);
	}

}

