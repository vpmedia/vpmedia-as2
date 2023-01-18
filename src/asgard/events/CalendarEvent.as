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

import asgard.date.Calendar;

import vegas.events.DynamicEvent;

/**
 * The {@code CalendarEvent} to dispatch an event with a {@code Calendar} object.
 * @author eKameleon
 */
class asgard.events.CalendarEvent extends DynamicEvent 
{
	
	/**
	 * Creates a new CalendarEvent instance.
	 * @param type the string type of the instance.
	 * @param cal The {@code Calendar} object of this event. 
	 * @param target the target of the event.
	 * @param context the optional context object of the event.
	 * @param bubbles indicates if the event is a bubbling event.
	 * @param eventPhase the current EventPhase of the event.
	 * @param time this parameter is used in the Eden deserialization.
	 * @param stop this parameter is used in the Eden deserialization.
	 */
	public function CalendarEvent(type:String, cal:Calendar, target, context, bubbles:Boolean, eventPhase:Number, time:Number, stop:Number) 
	{
		
		super(type, target, context, bubbles, eventPhase, time, stop);
		_cal = cal ;
		
	}

	/**
	 * Creates and returns a shallow copy of this instance.
	 * @return a shallow copy of this event.
	 */
	public function clone() 
	{
		return new CalendarEvent(getType(), getCalendar(), getTarget(), getContext()) ;
	}
	
	/**
	 * Returns the {@code Date} instance.
	 * @return the {@code Date} instance.
	 */
	public function getCalendar():Calendar
	{
		return _cal ;	
	}
	
	/**
	 * Sets the {@code Calendar} instance.
	 */
	public function setCalendar(cal:Calendar):Void
	{
		_cal = cal ;
	}
	
	/**
	 * The internal {@code Calendar} instance.
	 */
	private var _cal:Calendar ;

}