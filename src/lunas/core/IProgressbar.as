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

import lunas.display.components.IBar;

/**
 * This interface defined the methods to implement a progress bar display component.
 * @author eKameleon
 */
interface lunas.core.IProgressbar extends IBar 
{
	
	/**
	 * Returns the position of the progress bar.
	 * @return the position of the progress bar.
	 */
	function getPosition():Number ;

	/**
	 * Sets the position of the progress bar.
	 * @param pos the position value of the progress bar.
	 * @param noEvent (optional) this flag disabled the events of this method if this argument is {@code true}
	 * @param flag (optional) An optional boolean flag use in the method.
	 */
	function setPosition(pos:Number, noEvent:Boolean, flag:Boolean):Void ;
	
}