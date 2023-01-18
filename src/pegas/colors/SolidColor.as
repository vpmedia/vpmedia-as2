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
 * Control the solid color of a Color Object.
 * <p>Thanks 2003 Robert Penner - Use freely, giving credit where possible.</p>
 * <p>This code is based on the book : Robert Penner's Programming Macromedia Flash MX. More informations in :
 * <ul>
 * <li>http://www.robertpenner.com/profmx
 * <li>http://www.amazon.com/exec/obidos/ASIN/0072223561/robertpennerc-20
 * </ul>
 * </p>
 * @author eKameleon
 */
class pegas.colors.SolidColor extends BasicColor 
{

	/**
	 * Creates a new SolidColor instance.
	 */
	public function SolidColor (mc:MovieClip) 
	{ 
		super(mc) ;
	}

	/**
	 * Returns the blue color value of a Color object.
	 * @return the blue color value of a Color object.
	 */
	public function get blue():Number 
	{
		return getBlue() ;	
	}

	/**
	 * Specifies a blue color value for a Color object.
	 */
	public function set blue(n:Number):Void 
	{
		setBlue(n) ;	
	}

	/**
	 * Returns the blue offset color value of a Color object.
	 * @return the blue offset color value of a Color object.
	 */
	public function get blueOffset():Number 
	{
		return getBlueOffset() ;	
	}

	/**
	 * Specifies a blue offset value for a Color object.
	 */
	public function set blueOffset(n:Number):Void 
	{
		setBlueOffset(n) ;	
	}

	/**
	 * Returns the blue percentage color value of a Color object.
	 * @return the blue percentage color value of a Color object.
	 */
	public function get bluePercent():Number 
	{
		return getBluePercent() ;	
	}

	/**
	 * Specifies a blue percentage color value for a Color object.
	 */
	public function set bluePercent(n:Number):Void 
	{
		setBluePercent(n) ;	
	}

	/**
	 * Returns the green color value for a Color object.
	 * @return the green color value for a Color object.
	 */
	public function get green():Number 
	{
		return getGreen() ;	
	}

	/**
	 * Specifies a green color value for a Color object.
	 */
	public function set green(n:Number):Void 
	{
		setGreen(n) ;	
	}

	/**
	 * Returns the green offset color value of a Color object.
	 * @return the green offset color value of a Color object.
	 */
	public function get greenOffset():Number 
	{
		return getGreenOffset() ;	
	}

	/**
	 * Specifies a green offset color value for a Color object.
	 */
	public function set greenOffset(n:Number):Void 
	{
		setGreenOffset(n) ;	
	}

	/**
	 * Returns the green percentage color value of a Color object.
	 * @return the green percentage color value of a Color object.
	 */
	public function get greenPercent():Number 
	{
		return getGreenPercent() ;	
	}

	/**
	 * Specifies a green percentage color value for a Color object.
	 */
	public function set greenPercent(n:Number):Void 
	{
		setGreenPercent(n) ;	
	}

	/**
	 * Returns the red color value of a Color object.
	 * @return the red color value of a Color object.
	 */
	public function get red():Number 
	{
		return getRed() ;	
	}

	/**
	 * Specifies a red color value for a Color object.
	 */
	public function set red(n:Number):Void 
	{
		setRed(n) ;	
	}

	/**
	 * Returns the red offset percentage color value of a Color object.
	 * @return the red offset percentage color value of a Color object.
	 */
	public function get redOffset():Number 
	{
		return getRedOffset() ;	
	}

	/**
	 * Specifies a red offset color value for a Color object.
	 */
	public function set redOffset(n:Number):Void 
	{
		setRedOffset(n) ;	
	}

	/**
	 * Returns the red percentage color value of a Color object.
	 * @return the redn percentage color value of a Color object.
	 */
	public function get redPercent():Number 
	{
		return getRedPercent() ;	
	}

	/**
	 * Specifies a red percentage color value for a Color object.
	 */
	public function set redPercent(n:Number):Void 
	{
		setRedPercent(n) ;	
	}

	/**
	 * Returns the blue color value of a Color object.
	 * @return the blue color value of a Color object.
	 */
	public function getBlue():Number 
	{ 
		return getTransform().bb ; 
	}

	/**
	 * Returns the blue offset color value of a Color object.
	 * @return the blue offset color value of a Color object.
	 */
	public function getBlueOffset():Number 
	{ 
		return getTransform().bb ; 
	}

	/**
	 * Returns the blue percentage value of a Color object.
	 * @return the blue percentage value of a Color object.
	 */
	public function getBluePercent():Number 
	{ 
		return getTransform().ba ; 
	}

	/**
	 * Returns the green color value of a Color object.
	 * @return the green color value of a Color object.
	 */
	public function getGreen():Number 
	{ 
		return getTransform().gb ; 
	}

	/**
	 * Returns the green offset color value of a Color object.
	 * @return the green offset color value of a Color object.
	 */
	public function getGreenOffset():Number 
	{ 
		return getTransform().gb ; 
	}
	/**
	 * Returns the green percentage color value of a Color object.
	 * @return the green percentage value of a Color object.
	 */
	public function getGreenPercent():Number 
	{ 
		return getTransform().ga ; 
	}

	/**
	 * Returns the red color value of a Color object.
	 * @return the red color value of a Color object.
	 */
	public function getRed():Number 
	{ 
		return getTransform().rb ; 
	}

	/**
	 * Returns the red offset color value of a Color object.
	 * @return the red offset color value of a Color object.
	 */
	public function getRedOffset():Number 
	{ 
		return getTransform().rb ; 
	}

	/**
	 * Returns the red percentage color value of a Color object.
	 * @return the red percentage color value of a Color object.
	 */
	public function getRedPercent():Number 
	{ 
		return getTransform().ra ; 
	}

	/**
	 * Returns the R+G+B values currently in use by the Color object as individual red, green, and blue values.
	 * <p><b>Example :</b></p>
	 * {@code 
	 * var my_color:Color = new Color(my_mc);
	 * my_color.setRGB2(255, 0, 255);
	 * var rgb:Object = my_color.getRGB2();
	 * trace (rgb.r);
	 * trace (rgb.g);
	 * trace (rgb.b);
	 * }
	 */
	public function getRGB2():Object 
	{
		var t:Object = getTransform() ;
		return {r:t.rb, g:t.gb, b:t.bb} ;
	}
	
	/**
	 * Specifies a blue value for a Color object.
	 * @param amount The blue value.
	 */
	public function setBlue(amount:Number):Void 
	{
		var t:Object = getTransform() ;
		setRGB (ColorRGB.rgb2hex(t.rb, t.gb, amount)) ;
	}

	/**
	 * Specifies a blue offset value for a Color object.
	 * @param offset The blue offset value.
	 */
	public function setBlueOffset(offset:Number):Void 
	{
		var t:Object = getTransform() ;
		t.bb = offset ; setTransform (t);
	}

	/**
	 * Specifies a blue percentage value for a Color object.
	 * @param percent The blue offset value.
	 */
	public function setBluePercent(percent:Number):Void 
	{
		var t:Object = getTransform();
		t.ba = percent ; setTransform (t);
	}

	/**
	 * Specifies a green color value for a Color object.
	 * @param amount The green value.
	 */
	public function setGreen(amount:Number) 
	{
		var t:Object = getTransform();
		setRGB (ColorRGB.rgb2hex(t.rb, amount, t.bb)) ;
	}

	/**
	 * Specifies a green offset color value for a Color object.
	 * @param offset The green offset value.
	 */
	public function setGreenOffset(offset:Number):Void 
	{
		var t:Object = getTransform();
		t.gb = offset; setTransform (t);
	}

	/**
	 * Specifies a green percentage value for a Color object.
	 * @param percent The green percent value.
	 */
	public function setGreenPercent(percent:Number):Void 
	{
		var t:Object = getTransform();
		t.ga = percent ; setTransform (t);
	}

	/**
	 * Specifies a red value for a Color object.
	 * @param amount The red value.
	 */
	public function setRed(amount:Number):Void
	{
		var t:Object = getTransform();
		setRGB (ColorRGB.rgb2hex(amount, t.gb, t.bb)) ;
	}

	/**
	 * Specifies a red offset value for a Color object.
	 * @param offset The red offset value.
	 */
	public function setRedOffset(offset:Number):Void 
	{
		var t:Object = getTransform() ;
		t.rb = offset ; setTransform (t) ;
	}

	/**
	 * Specifies a red percentage value for a Color object.
	 * @param percent The red percent value.
	 */
	public function setRedPercent(percent:Number):Void 
	{
		var t:Object = getTransform();
		t.ra = percent ; setTransform (t) ; 
	}

	/**
	 * Specifies an RGB color for a Color object using individual red, green, and blue values.
	 * <p><b>Example :</b></p>
	 * {@code
	 * var my_color:SolidColor = new SolidColor(my_mc);
	 * my_color.setRGB2(255, 0, 255);
	 * }
	 * @param r The red color value.
	 * @param g The green color value.
	 * @param b The blue color value.
	 */
	public function setRGB2(r:Number, g:Number, b:Number):Void  
	{ 
		setRGB(ColorRGB.rgb2hex(r,g,b)) ; 
	}

}

