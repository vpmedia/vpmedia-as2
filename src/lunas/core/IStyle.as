/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is LunAS Library.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <vegas@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2007
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

import vegas.events.EventTarget;

/**
 * The IStyle interface.
 * @author eKameleon
 */
interface lunas.core.IStyle extends EventTarget
{

	/**
	 * Returns the value of the specified property if it's exist in the object, else returns null.
	 * @return the value of the specified property if it's exist in the object or {@code null}.
	 */
	function getStyle(prop:String) ;

	/**
	 * Returns the style sheet reference of this object.
	 * @return the style sheet reference of this object.
	 */
	function getStyleSheet():TextField.StyleSheet ;

	/**
	 * Sets the properties of this {@code IStyle} object.
	 */
	function setStyle():Void ;

	/**
	 * Sets the style sheet if this {@code IStyle} object.
	 */
	function setStyleSheet(ss:TextField.StyleSheet):Void ;

	/**
	 * Update the {@code IStyle} object.
	 * You can override this method.
	 */
	function update():Void ;
	
}