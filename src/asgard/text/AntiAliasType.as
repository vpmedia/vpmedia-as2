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
 * The AntiAliasType class provides values for anti-aliasing in the flash.text.TextField class.
 * @author eKameleon
 */
class asgard.text.AntiAliasType 
{
	
	/**
	 * [static] Sets anti-aliasing to advanced anti-aliasing ("advanced").
	 */
	static public var ADVANCED:String = "advanced" ;
	
	/**
	 * [static] Sets anti-aliasing to the anti-aliasing that is used in Flash Player 7 and earlier ("normal").
	 */
	static public var NORMAL:String = "normal" ;
	
	static private var __ASPF__ = _global.ASSetPropFlags(AntiAliasType, null , 7, 7) ;

}