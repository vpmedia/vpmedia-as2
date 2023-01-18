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
 * An enumeration of constant values for setting the direction of a Display or a component.
 */
class asgard.display.Direction 
{

	/**
	 * Specifies the horizontal value to change the orientation of a Display or a component.
	 */
	static public var HORIZONTAL:Number = 0 ;

	/**
	 * Specifies the horizontal value to change the orientation of a Display or a component.
	 */
	static public var VERTICAL:Number = 1 ;

	static private var __ASPF__ = _global.ASSetPropFlags(Direction, null , 7, 7) ;

	/**
	 * Returns the number representation of the specified string passed in argument.
	 * If the string passed in argument is different of 'vertical' the method return the Direction.HORIZONTAL value.
	 * @return the number representation of the specified string passed in argument.
	 */
	static public function toNumber(str:String):Number 
	{
		switch (str.toLowerCase()) 
		{
			case "vertical" :
			{
				return Direction.VERTICAL ;
			}
			default :
			{
				return Direction.HORIZONTAL ;
				break ;
			}
		}
	}

	/**
	 * Returns the string representation of the number value passed in argument.
	 * <ul>
	 * <li>If the value is Direction.HORIZONTAL returns "horizontal".</li>
	 * <li>If the value is Direction.VERTICAL returns "vertical".</li>
	 * <li>If the value isn't Direction.HORIZONTAL or Direction.VERTICAL returns an empty string.</li>
	 * </ul>
	 * @return the string representation of the number value passed in argument.
	 */
	static public function toString(n:Number):String 
	{
		if (n == Direction.HORIZONTAL)
		{
			return "horizontal" ;
		}
		else if (n == Direction.VERTICAL) 
		{
			return "vertical" ;
		}
		else 
		{
			return "" ;
		}
	}

	
}