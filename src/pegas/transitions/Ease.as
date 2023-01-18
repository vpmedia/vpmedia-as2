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

import vegas.util.ConstructorUtil;

/**
 * This static abstract class provides a skeletal implementation for all easing class in the pegas.transitions.easing directory.
 * @author eKameleon
 */
class pegas.transitions.Ease 
{

	/**
	 * The name of the easeIn static method in a Ease class.
	 */
	static public var EASE_IN:String = "easeIn" ; 

	/**
	 * The name of the easeOut static method in a Ease class.
	 */
	static public var EASE_IN_OUT:String = "easeInOut" ;

	/**
	 * The name of the easeInOut static method in a Ease class.
	 */
	static public var EASE_OUT:String = "easeOut" ;
		
	/**
	 * The ease-in method use in a Tween effect.
	 */	
	static public function easeIn (t:Number, b:Number, c:Number, d:Number):Number 
	{
		return null ;
	}

	/**
	 * The ease-out method use in a Tween effect.
	 */	
	static public function easeOut (t:Number, b:Number, c:Number, d:Number):Number 
	{
		return null ;
	}

	/**
	 * The ease-in-out method use in a Tween effect.
	 */	
	static public function easeInOut (t:Number, b:Number, c:Number, d:Number):Number 
	{
		return null ;
	}
	
	/**
	 * Returns {@code true} if the passed-in method is a valid easing class.
	 * The constructor in argument must be a subconstructor of the Ease class.
	 * @return {@code true} if the passed-in method is a valid easing class.
	 */
	static public function validate( c:Function ):Boolean 
	{
		 return ConstructorUtil.isSubConstructorOf(c, Ease) ;
	}
	
}