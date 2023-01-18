/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is Vegas Framework.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <vegas@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2007
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

/**
 * The GridFitType class defines values for grid fitting in the TextField class.
 * Compatibility with flash.text.GridFitType class in AS3 framework (Flex SDK 2)
 * @author eKameleon
 */
class asgard.text.GridFitType 
{
	
	/**
	 * Doesn't set grid fitting. 
	 * <p>Horizontal and vertical lines in the glyphs are not forced to the pixel grid.</p> 
	 * <p>This constant is used in setting the gridFitType property of the TextField class. 
	 * This is often a good setting for animation or for large font sizes.
	 * Use the syntax GridFitType.NONE.</p>
	 */	
	static public var NONE:String = "none" ;
	
	/**
	 * Fits strong horizontal and vertical lines to the pixel grid.
	 * <p>This constant is used in setting the gridFitType property of the TextField class.</p>
	 * <p>This setting only works for left-justified text fields and acts like the GridFitType.SUBPIXEL constant in static text. This setting generally provides the best readability for left-aligned text. 
	 * Use the syntax GridFitType.PIXEL.</p>
	 */
	static public var PIXEL:String = "pixel" ;
	
	/**
	 * Fits strong horizontal and vertical lines to the sub-pixel grid on LCD monitors.
	 * <p>(Red, green, and blue are actual pixels on an LCD screen.)</p> 
	 * <p>This is often a good setting for right-aligned or center-aligned dynamic text, and it is sometimes a useful tradeoff for animation vs. text quality. This constant is used in setting the gridFitType property of the TextField class. 
	 * Use the syntax GridFitType.SUBPIXEL.</p> 
	 */
	static public var SUBPIXEL:String = "subpixel" ;

	static private var __ASPF__ = _global.ASSetPropFlags(GridFitType, null , 7, 7) ;

}