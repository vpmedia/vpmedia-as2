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
 * The {@code LineScaleMode} class provides values for the scaleMode parameter in the {@code lineStyle()} method. 
 * @author eKameleon
 */
class asgard.display.LineScaleMode 
{

	/**
	 * With this setting used as the scaleMode parameter of the lineStyle() method, the thickness of the line scales only vertically.
 	 */
	static public var HORIZONTAL:String = "horizontal" ;
	
	/**
	 * With this setting used as the scaleMode parameter of the lineStyle() method, the thickness of the line never scales.
	 */
	static public var NONE:String = "none" ;
	
	/**
	 * With this setting used as the scaleMode parameter of the lineStyle() method, the thickness of the line always scales when the object is scaled (the default).
	 */
	static public var NORMAL:String = "normal" ;
	
	/**
	 * With this setting used as the scaleMode parameter of the lineStyle() method, the thickness of the line scales only horizontally.
	 */
	static public var VERTICAL:String = "vertical" ;
	
	static private var __ASPF__ = _global.ASSetPropFlags(LineScaleMode, null , 7, 7) ;

}
