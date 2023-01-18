/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is Vegas Library.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <vegas@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2007
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

/**
 * Values for the horizontalScrollPolicy and verticalScrollPolicy properties of the Container and ScrollControlBase classes.
 * Compatibility with flash.display.* AS3 package.
 * @author eKameleon
 */
class asgard.display.ScrollPolicy {

	/**
	 * Show the scrollbar if the children exceed the owner's dimension.
	 */
	static public var AUTO:Number = 2 ;

	/**
	 * Never show the scrollbar.
	 */
	static public var OFF:Number = 0 ;

	/**
	 * Always show the scrollbar.
	 */
	static public var ON:Number = 1 ;

	static private var __ASPF__ = _global.ASSetPropFlags(ScrollPolicy, null , 7, 7) ;

	/**
	 * Returns {@code true} if the value passed in arguments is a valid ScrollPolicy constant.
	 */
	static public function validate(o):Boolean 
	{
		return (o == ScrollPolicy.AUTO || o == ScrollPolicy.OFF || o == ScrollPolicy.ON) ;
	}

}