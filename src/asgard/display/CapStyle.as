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
 * The {@code CapsStyle} class is an enumeration of constant values that specify the caps style to use in drawing lines. 
 * The constants are provided for use as values in the caps parameter of the {@code lineStyle()} method. 
 * You can specify the following three types of caps : NONE, ROUND or SQUARE. 
 * @author eKameleon
 */
class asgard.display.CapStyle 
{

	/**
	 * Used to specify no caps in the caps parameter of the lineStyle() method.
 	 */
	static public var NONE:String = "none" ;
	
	/**
	 * Used to specify round caps in the caps parameter of the lineStyle() method.
	 */
	static public var ROUND:String = "round" ;
	
	/**
	 * Used to specify square caps in the caps parameter of the lineStyle() method.
	 */
	static public var SQUARE:String = "square" ;
	
	static private var __ASPF__ = _global.ASSetPropFlags(CapStyle, null , 7, 7) ;

}
