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

/**
 * The StageQuality class provides values for the global function {@code _quality}.
 * Polymorphism with the flash.display.StageQuality class but in AS3 the {@code Stage.quality} property is defined for this values.
 * @author eKameleon
 */
class asgard.display.StageQuality 
{

	/**
	 * Specifies Very high rendering quality: graphics are anti-aliased using a 4 x 4 pixel grid and bitmaps are always smoothed.
 	 */
	static public var BEST:String = "best" ;
	
	/**
	 * Specifies high rendering quality: graphics are anti-aliased using a 4 x 4 pixel grid, and bitmaps are smoothed if the movie is static.
	 */
	static public var HIGH:String = "high" ;
	
	/**
	 * Specifies low rendering quality: graphics are not anti-aliased, and bitmaps are not smoothed.
	 */
	static public var LOW:String = "low" ;
	
	/**
	 * Specifies medium rendering quality: graphics are anti-aliased using a 2 x 2 pixel grid, but bitmaps are not smoothed.
	 */
	static public var MEDIUM:String = "medium" ;
	
	static private var __ASPF__ = _global.ASSetPropFlags(StageQuality, null , 7, 7) ;

}
