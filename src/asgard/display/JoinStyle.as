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
 * The {@code JointStyle} class is an enumeration of constant values that specify the joint style to use in drawing lines. 
 * These constants are provided for use as values in the joints parameter of the {@code lineStyle()} method. 
 * The method supports three types of joints : 'miter', 'round', and 'bevel'. 
 * @author eKameleon
 */
class asgard.display.JoinStyle 
{

	/**
	 * Specifies beveled joints in the joints parameter of the {@code lineStyle()} method.
 	 */
	static public var BEVEL:String = "bevel" ;
	
	/**
	 * Specifies mitered joints in the joints parameter of the {@code lineStyle()} method.
	 */
	static public var MITER:String = "miter" ;
	
	/**
	 *  Specifies round joints in the joints parameter of the {@code lineStyle()} method.
	 */
	static public var ROUND:String = "round" ;
	
	static private var __ASPF__ = _global.ASSetPropFlags(JoinStyle, null , 7, 7) ;

}
