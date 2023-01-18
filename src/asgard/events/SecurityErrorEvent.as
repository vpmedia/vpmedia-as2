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
 * The {@code SecurityErrorEvent} are dispatched to report the occurrence of a security error. 
 * Security errors reported through this class are generally from asynchronous operations, such as loading data, 
 * in which security violations may not manifest immediately. 
 * Your event listener can access the object's text property to determine what operation was attempted and any URLs that were involved. 
 * There is one type of security error event: SecurityErrorEvent.SECURITY_ERROR.
 * @author eKameleon
 */
class asgard.events.SecurityErrorEvent extends ErrorEvent 
{
	
	/**
	 * Creates an Event object that contains information about security error events.
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
	public function SecurityErrorEvent( type:String, text:String, id:Number, target, context, bubbles:Boolean, eventPhase:Number, time:Number, stop:Number) 
	{
		super(type, text, id, target, context, bubbles, eventPhase, time, stop);
	}

	/**
	 * The SecurityErrorEvent.SECURITY_ERROR constant defines the value of the type property of a securityError event object.
	 */
	static public var SECURITY_ERROR : String = "securityError" ; 

	/**
	 * Returns the shallow copy of this event.
	 * @return the shallow copy of this event.
	 */
	public function clone() 
	{
		return new SecurityErrorEvent(getType(), text, errorID, getTarget(), getContext()) ;
	}

}