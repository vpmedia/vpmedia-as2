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

import asgard.events.ErrorEvent;

/**
 * The {@code IOErrorEvent} are dispatched when an error causes a send or load operation to fail. 
 * There is only one type of input/output error event: {@code IOErrorEvent.IO_ERROR}
 * @author eKameleon
 */
class asgard.events.IOErrorEvent extends ErrorEvent 
{
	
	/**
	 * Creates an Event object that contains specific information about ioError events.
	 * @param type the string type of the instance. 
	 * @param txt The text to be displayed as an error message. Event listeners can access this information through the text property.
	 * @param id A reference number to associate with the specific error (default 0).
	 * @param target the target of the event.
	 * @param context the optional context object of the event.
	 * @param bubbles indicates if the event is a bubbling event.
	 * @param eventPhase the current EventPhase of the event.
	 * @param time this parameter is used in the Eden deserialization.
	 * @param stop this parameter is used in the Eden deserialization.
	 */
	public function IOErrorEvent( type:String, text:String, id:Number, target, context, bubbles:Boolean, eventPhase:Number, time:Number, stop:Number) 
	{
		super(type, text, id, target, context, bubbles, eventPhase, time, stop);
	}

	/**
	 * Defines the value of the type property of an ioError event object.
	 */
	static public var IO_ERROR : String = "ioError" ; 

	/**
	 * Returns the shallow copy of this event.
	 * @return the shallow copy of this event.
	 */
	public function clone() 
	{
		return new IOErrorEvent(getType(), text, errorID, getTarget(), getContext()) ;
	}

}