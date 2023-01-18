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
 * The StageScaleMode class provides values for the Stage.scaleMode property.
 * @author eKameleon
 */
class asgard.display.StageScaleMode 
{

	/**
	 * Specifies that the entire Adobe® Flash® application be visible in the specified area without trying to preserve the original aspect ratio.
	 */
	static public var EXACT_FIT:String = "exactFit" ;
	
	/**
	 * Specifies that the entire Flash application fill the specified area, without distortion but possibly with some cropping, while maintaining the original aspect ratio of the application.
	 */
	static public var NO_BORDER:String = "noBorder" ;
	
	/**
	 * Specifies that the size of the Flash application be fixed, so that it remains unchanged even as the size of the player window changes.
	 */
	static public var NO_SCALE:String = "noScale" ;
	
	/**
	 * Specifies that the entire Flash application be visible in the specified area without distortion while maintaining the original aspect ratio of the application.
	 */
	static public var SHOW_ALL:String = "showAll" ;
	
	static private var __ASPF__ = _global.ASSetPropFlags(StageScaleMode, null , 7, 7) ;

}