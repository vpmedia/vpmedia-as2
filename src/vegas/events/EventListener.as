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

import vegas.events.Event;

/**
 * The {@code EventListener} interface is the primary method for handling events. Users implement the EventListener interface and register their listener on an {@code EventTarget} using the {@code addEventListener method}. The users should also remove their EventListener from its {@code EventTarget} after they have completed using the listener.
 * @author eKameleon
 */
interface vegas.events.EventListener 
{
	
	/**
	 * This method is called whenever an event occurs of the type for which the EventListener interface was registered.
	 * @param e The Event contains contextual information about the event.
	 */
	function handleEvent(e:Event) ;

}