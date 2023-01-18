/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is ASGard Framework.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <vegas@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2007
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

import vegas.util.StringUtil;

/**
 * The StageAlign class provides constant values to use for the Stage.align property.
 * <p></b>Example :</b></p>
 * {@code
 * import asgard.display.StageAlign ;
 * 
 * trace ("---- constant") ;
 * 
 * trace ("StageAlign.TOP_LEFT : " + StageAlign.TOP_LEFT) ;
 * StageAlign.TOP_LEFT = "coucou" ;
 * trace ("StageAlign.TOP_LEFT : " + StageAlign.TOP_LEFT) ;
 * 
 * trace ("---- getAlign") ;
 * 
 * trace("get align 'tl' : " + StageAlign.getAlign("tl")) ;
 * trace("get align 'lt' : " + StageAlign.getAlign("LT")) ;
 * trace("get align 'unknow' : " + StageAlign.getAlign("unknow", StageAlign.BOTTOM_LEFT)) ;
 * 
 * }
 * @author eKameleon
 */
class asgard.display.StageAlign 
{
	/**
	 * Specifies that the Stage is aligned at the bottom.
	 */
	static public var BOTTOM:String = "B" ;
	
	/**
	 * Specifies that the Stage is aligned in the bottom-left corner.
	 */
	static public var BOTTOM_LEFT:String = "BL" ;
	
	/**
	 * Specifies that the Stage is aligned in the bottom-right corner.
	 */
	static public var BOTTOM_RIGHT:String = "BR" ;
	
	/**
	 * Specifies that the Stage is aligned in the center.
	 */
	static public var CENTER:String = "" ;
	
	/**
	 * Specifies that the Stage is aligned on the left.
	 */
	static public var LEFT:String = "L" ;
	
	/**
	 * Specifies that the Stage is aligned to the right.
	 */
	static public var RIGHT:String = "R" ;
	
	/**
	 * Specifies that the Stage is aligned at the top.
	 */
	static public var TOP:String = "T" ;
	
	/**
	 * Specifies that the Stage is aligned in the top-left corner.
	 */
	static public var TOP_LEFT:String = "TL" ;
	
	/**
	 * Specifies that the Stage is aligned in the top-right corner.
	 */
	static public var TOP_RIGHT:String = "TR" ;

	static private var __ASPF__ = _global.ASSetPropFlags(StageAlign, null , 7, 7) ;

	/**
	 * Returns the string representation of a StageAlign and a default align if this alignement don't exist in this enumeration. 
	 */	
	static public function getAlign(align:String, default_align:String):String 
	{
		var r:String = StringUtil.reverse(align.toUpperCase()) ;
		var aligns =  
		{
			B:BOTTOM, BL:BOTTOM_LEFT, BR:BOTTOM_RIGHT,
			L:LEFT, R:RIGHT, T:TOP, TL:TOP_LEFT, TR:TOP_RIGHT, C:CENTER
		} ;
		if (aligns[align]) 
		{
			return aligns[align] ;
		}
		else if (aligns[r])
		{
			return aligns[r] ;
		}
		else 
		{
			return default_align || StageAlign.CENTER ;
		}
	}
	
}
