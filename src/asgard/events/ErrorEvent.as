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

import asgard.events.TextEvent;

/**
 * The {@code ErrorEvent} are dispatched when an error causes a network operation to fail. There is only one type of error event: {@code ErrorEvent.ERROR}.
 * The {@code ErrorEvent} class also serves as the base class for the {@code IOErrorEvent} and {@code SecurityErrorEvent} classes.
 * @author eKameleon
 */
class asgard.events.ErrorEvent extends TextEvent 
{
	
	/**
	 * Creates an Event object that contains information about error events. 
	 * Event objects are passed as parameters to event listeners.
	 * @param type The type of the event. Event listeners can access this information through the inherited type property. There is only one type of error event: ErrorEvent.ERROR.
	 * @param type Text to be displayed as an error message. Event listeners can access this information through the text property.
	 * @param id A reference number to associate with the specific error (default 0).
	 * @param target the target of the event.
	 * @param context the optional context object of the event.
	 * @param bubbles indicates if the event is a bubbling event.
	 * @param eventPhase the current EventPhase of the event.
	 * @param time this parameter is used in the Eden deserialization.
	 * @param stop this parameter is used in the Eden deserialization.
	 */
	public function ErrorEvent(type : String, text:String, id:Number, target, context, bubbles : Boolean, eventPhase : Number, time : Number, stop : Number) 
	{
		super(type, text, target, context, bubbles, eventPhase, time, stop);
		errorID = isNaN(id) ? 0 : id ;
	}

	/**
	 * Defines the value of the type property of an error event object.
	 */
	static public var ERROR:String = "error" ; 

	/**
	 * Contains the reference number associated with the specific error. 
	 * For a custom ErrorEvent object, this number is the value from the id  parameter supplied in the constructor.
	 */
	public var errorID:Number ;

	/**
	 * Returns the shallow copy of this event.
	 * @return the shallow copy of this event.
	 */
	public function clone() 
	{
		return new ErrorEvent(getType(), text, errorID, getTarget(), getContext()) ;
	}

}