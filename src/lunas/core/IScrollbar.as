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

import lunas.display.components.IProgressbar;

/**
 * The IScrollbar interface.
 * @author eKameleon
 */
interface lunas.core.IScrollbar extends IProgressbar 
{

	/**
	 * Invoqued when the scroll bar is dragging.
	 */	
	function dragging():Void ;
	
	/**
	 * Returns the bar reference of this component display.
	 * @return the bar reference of this component display.
	 */
	function getBar():MovieClip ;

	/**
	 * Returns the thumb reference of this component display.
	 * @return the thumb reference of this component display.
	 */
	function getThumb():MovieClip ;
	
	/**
	 * Start the drag of the scroll bar.
	 */
	function startDragging():Void ;
	
	/**
	 * Stop the drag of the scroll bar.
	 */
	function stopDragging():Void ;
	
}