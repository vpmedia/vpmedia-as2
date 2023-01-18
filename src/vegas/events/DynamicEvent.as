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

import vegas.events.BasicEvent;

/**
 * {@code BasicEvent} is the dynamic event structure to work with {@link EventDispatcher} and {@link FastDispatcher}.
 * <p><b>Example</b></p>
 * {@code var e:BasicEvent = new DynamicEvent(type, target, context) ; } 
 * @author  eKameleon
 * @see     CoreObject	
 * @see     Event	
 */
dynamic class vegas.events.DynamicEvent extends BasicEvent 
{

	/**
	 * Constructs a new {@code DynamicEvent} instance.
	 * <p>
	 * {@code
	 *     var e:DynamicEvent = new DynamicEvent(type, target, context, [bubbles:Boolean, [eventPhase:Number, [time:Number, [stop:Boolean]]]]) ;
	 * }
	 * </p>
	 * @param type the string type of the instance. 
	 * @param target the target of the event.
	 * @param context the optional context object of the event.
	 * @param bubbles indicates if the event is a bubbling event.
	 * @param eventPhase the current EventPhase of the event.
	 * @param time this parameter is used in the Eden deserialization.
	 * @param stop this parameter is used in the Eden deserialization.
	 */
	public function DynamicEvent( type:String, target, context, bubbles:Boolean, eventPhase:Number, time:Number, stop:Number) 
	{
		super(type, target, context, bubbles, eventPhase, time, stop) ;
	}

	/**
	 * Returns {@code true} if the event is bubbling.
	 * @return {@code true} if the event is bubbling.
	 */
	public function get bubbles():Boolean 
	{
		return getBubbles() ;	
	}

	/**
	 * Sets {@code true} if the event is bubbling.
	 */
	public function set bubbles(b:Boolean):Void 
	{
		setBubbles(b) ;	
	}

	/**
	 * Returns the optional context of this event.
	 * @return an object, corresponding the optional context of this event.
	 */
	public function get context() 
	{
		return getContext() ;	
	}

	/**
	 * Sets the optional context of this event.
	 */
	public function set context(o):Void 
	{
		setContext(o) ;	
	}

	/**
	 * Returns the object that is actively processing the Event object with an event listener.
	 * @return the object that is actively processing the Event object with an event listener.
	 */
	public function get currentTarget() 
	{
		return getCurrentTarget() ;	
	}

	/**
	 * Sets the object that is actively processing the Event object with an event listener.
	 */
	public function set currentTarget(o):Void 
	{
		setCurrentTarget(o) ;	
	}

	/**
	 * Returns the current phase in the event flow.
	 * @return the current phase in the event flow.
	 * @see EventPhase
	 */
	public function get eventPhase():Number 
	{
		return getEventPhase() ;	
	}

	/**
	 * Sets the current phase in the event flow.
	 * @see EventPhase
	 */
	public function set eventPhase(n:Number):Void 
	{
		setEventPhase(n) ;	
	}

	/**
	 * Returns the event target.
	 * @return the event target.
	 */
	public function get target() 
	{
		return getTarget() ;	
	}

	/**
	 * Sets the event target.
	 */
	public function set target(o):Void 
	{
		setTarget(o) ;	
	}
	
	/**
	 * Returns the timestamp of the event.
	 * @return the timestamp of the event.
	 */
	public function get timeStamp():Number 
	{
		return getTimeStamp() ;	
	}

	/**
	 * Returns the type of event.
	 * @return the type of event.
	 */
	public function get type():String 
	{
		return getType() ;	
	}

	/**
	 * Sets the type of event.
	 */
	public function set type(s:String):Void 
	{
		setType(s) ;	
	}

	/**
	 * Returns the shallow copy of this event.
	 * @return the shallow copy of this event.
	 */
	/*override*/ public function clone() 
	{
		return new DynamicEvent(getType(), getTarget(), getContext()) ;
	}

}
