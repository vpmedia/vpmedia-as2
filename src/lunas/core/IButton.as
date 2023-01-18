import lunas.core.IData;
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

/**
 * This interface defines all methods to implement in a button display components.
 */
interface lunas.core.IButton extends IData
{
	
	/**
	 * Returns the text label for a button instance.
	 * @return the text label for a button instance.
	 */
	function getLabel():String ;

	/**
	 * Returns a Boolean value indicating whether the button is selected (true) or not (false). The default value is false.
	 * @return a Boolean value indicating whether the button is selected (true) or not (false)
	 */
	function getSelected():Boolean ;

	/**
	 * Returns a boolean value indicating whether the button behaves as a toggle switch (true) or not (false). 
	 * @return a boolean value indicating whether the button behaves as a toggle switch (true) or not (false).
	 */
	function getToggle():Boolean ;

	/**
	 * Sets the text label for a button instance.
	 */
	function setLabel(str:String):Void ;

	/**
	 * Sets a Boolean value indicating whether the button is selected (true) or not (false). The default value is false.
	 */
	function setSelected (b:Boolean, noEvent:Boolean):Void ;

	/**
	 * Sets a boolean value indicating whether the button behaves as a toggle switch (true) or not (false). 
	 * The default value is false.
	 */
	function setToggle(b:Boolean):Void ;
	
}