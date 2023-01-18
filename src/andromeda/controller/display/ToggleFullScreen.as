/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is Andromeda Framework based on VEGAS.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <vegas@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2007
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

import andromeda.controller.AbstractController;

import asgard.display.StageDisplayState;

import vegas.events.BooleanEvent;
import vegas.events.Event;

/**
 * This controller toggle the fullscreen mode of the application. 
 * @author eKameleon
 */
class andromeda.controller.display.ToggleFullScreen extends AbstractController 
{
	
	/**
	 * Creates a new ToggleFullScreen instance.
	 */
	public function ToggleFullScreen() 
	{
		super();
	}

	/**
	 * Handles the event.
	 */
	public function handleEvent(e:Event) 
	{
		getLogger().debug( this + " handleEvent." ) ;
		if ( e instanceof Boolean )
		{
			var b:Boolean = BooleanEvent(e).getBoolean() ;
			StageDisplayState.getInstance().displayState = b ? StageDisplayState.FULLSCREEN : StageDisplayState.NORMAL ;
		}
		else
		{
			StageDisplayState.getInstance().toggleFullScreen() ;
		}
	}

}