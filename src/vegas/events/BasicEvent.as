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

import vegas.core.CoreObject;
import vegas.events.Event;
import vegas.events.EventPhase;
import vegas.util.ConstructorUtil;
import vegas.util.serialize.Serializer;

/**
 * {@code BasicEvent} is the basical event structure to work with {@link EventDispatcher} and {@link FastDispatcher}.
 * <p><b>Example</b></p>
 * {@code var e:BasicEvent = new BasicEvent(type:String, target, context) ; } 
 * @author  eKameleon
 * @see Event	
 */
class vegas.events.BasicEvent extends CoreObject implements Event 
{

	/**
	 * Constructs a new {@code BasicEvent} instance.
	 * <p>
	 * {@code
	 *     var e:BasicEvent = new BasicEvent(type, target, context, [bubbles:Boolean, [eventPhase:Number, [time:Number, [stop:Boolean]]]]) ;
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
	public function BasicEvent ( type:String , target, context, bubbles:Boolean, eventPhase:Number, time:Number, stop:Number ) 
	{
		
		_type = (getType() != null) ? getType() : type ;
		_context = (getContext() != null) ? getContext() : context ;
		_target = (getTarget() != null) ? getTarget() : target ;
		_bubbles = ( bubbles != null) ? bubbles : true ;
		_eventPhase = isNaN( eventPhase) ? EventPhase.AT_TARGET : eventPhase ;
		_time = ( time > 0) ? time : ( (new Date()).valueOf() ) ;
		
		this.stop = isNaN( stop) ? EventPhase.NONE : stop ;
		
	}

	/**
	 * This property indicated in the event model if this event is stopped.
	 */	
	public var stop:Number ;
	
	/**
	 * Indicates whether the behavior associated with the event can be prevented.
	 */
	public function cancel():Void 
	{
		_cancelled = true ;
	}
	
	/**
	 * Returns the shallow copy of this event.
	 * @return the shallow copy of this event.
	 */
	public function clone() 
	{
		return new BasicEvent(getType(), getTarget(), getContext()) ;
	}

	/**
	 * Returns {@code true} if the event is bubbling.
	 * @return {@code true} if the event is bubbling.
	 */
	public function getBubbles():Boolean 
	{
		return _bubbles ;
	}

	/**
	 * Returns the optional context of this event.
	 * @return an object, corresponding the optional context of this event.
	 */
	public function getContext() 
	{
		return _context ;
	}

	/**
	 * The object that is actively processing the Event object with an event listener.
	 */
	public function getCurrentTarget() 
	{
		return _currentTarget ;
	}

	/**
	 * Returns the current phase in the event flow.
	 * @return the current phase in the event flow.
	 * @see EventPhase
	 */
	public function getEventPhase():Number 
	{
		return _eventPhase ;
	}

	/**
	 * Returns the event target.
	 * @return the event target.
	 */
	public function getTarget() {
		return _target ;
	}
	
	/**
	 * Returns the timestamp of the event.
	 * @return the timestamp of the event.
	 */
	public function getTimeStamp():Number 
	{
		return _time ;
	}
	
	/**
	 * Returns the type of event.
	 * @return the type of event.
	 */
	public function getType():String 
	{
		return _type ;
	}

	/**
	 * Initialize the event with the properties type, bubbles, cancelable.
	 * @param type the type of the event.
	 * @param bubbles a boolean to indicate if the event is a bubbling event.
	 * @param cancelable a boolean to indicate if the event is a capturing event.
	 */
	public 	function initEvent(type:String, bubbles:Boolean, cancelable:Boolean):Void 
	{
		_type = type ;
		_bubbles = bubbles ;
		_cancelled = cancelable ;
		_time = (new Date()).valueOf() ;
	}

	/**
	 * Returns {@code true} if the event is cancelled.
	 * @return {@code true} if the event is cancelled.  
	 */
	public function isCancelled():Boolean 
	{
		return _cancelled ;
	}

	/**
	 * Returns {@code true} if the event is queued.
	 * @return {@code true} if the event is queued.
	 */
	public function isQueued():Boolean 
	{
		return _inQueue ;
	}
	
	/**
	 * Sets if the event is queued.
	 */
	public function queueEvent():Void 
	{
		_inQueue = true ;
	}

	/**
	 * Sets if the event is bubbling.
	 */
	public function setBubbles(b:Boolean):Void 
	{
		_bubbles = b ;
	}

	/**
	 * Sets the optional context object of this event. 
	 */
	public function setContext(context):Void 
	{
		_context = context || null ;
	}

	/**
	 * Set the object that is actively processing the Event object with an event listener.
	 */
	public function setCurrentTarget(target):Void {
		_currentTarget = target ;
	}

	/**
	 * Sets the current phase in the event flow.
	 */
	public function setEventPhase(n:Number):Void 
	{
		_eventPhase = n ;
	}

	/**
	 * Sets the event target.
	 */
	public function setTarget(target):Void 
	{
		_target = target || null ;
	}

	/**
	 * Sets the event type.
	 */
	public function setType(type:String):Void 
	{
		_type = type || null ;
	}

	/**
	 * Prevents processing of any event listeners in the current node and any subsequent nodes in the event flow.
	 */
	public function stopImmediatePropagation():Void {
		stop = EventPhase.STOP_IMMEDIATE ;
	}

	/**
	 * Prevents processing of any event listeners in nodes subsequent to the current node in the event flow.
	 */	
	public function stopPropagation():Void 
	{
		stop = EventPhase.STOP ;
	}
	
	/**
	 * Returns a Eden representation of the object.
	 * @return a string representing the source code of the object.
	 */
	/*override*/ public function toSource(indent : Number, indentor : String) : String 
	{
		return Serializer.getSourceOf(this, _getParams()) ;
	}

	/**
	 * Returns the string representation of this event.
	 * @return the string representation of this event.
	 */
	public function toString():String 
	{
		var phase:Number = getEventPhase() ;
		var name:String = ConstructorUtil.getName(this);
		var txt:String = "[" + name ;
		if (getType()) txt += " " + getType() ;
		switch (phase) 
		{
			case EventPhase.CAPTURING_PHASE :
			{
				txt += ", CAPTURING" ;
				break;
			}
			case EventPhase.AT_TARGET:
			{
				txt += ", AT TARGET" ;
				break ;
			}
			case EventPhase.BUBBLING_PHASE:
			{
				txt += ", BUBBLING" ;
				break ;
			}
			default :
			{
				txt += ", (inactive)" ;
				break;
			}
		}
		if (getBubbles() && phase != EventPhase.BUBBLING_PHASE) 
		{
			txt += ", bubbles" ;
		}
		if (isCancelled()) 
		{
			txt += ", can cancel" ;
		}
		txt += "]" ;
		return txt ;
	}
  
	private var _bubbles:Boolean ;

	private var _context = null ;

	private var _currentTarget ;

	private var _cancelled:Boolean = false ;

	private var _eventPhase:Number ;

	private var _inQueue:Boolean = false ;

	private var _target = null ;

	private var _time:Number ;

	private var _type:String ;

	/**
	 * This method is used by toSource method. Overrides this method in other Event concrete class if you want extend the arguments in the constructor class.
	 */
	/*protected*/ private function _getParams():Array 
	{
		return [
			Serializer.toSource(getType()) ,
			Serializer.toSource(getTarget()) ,
			Serializer.toSource(getContext()) ,
			Serializer.toSource(getBubbles()) ,
			Serializer.toSource(getEventPhase()) ,
			Serializer.toSource(getTimeStamp()) ,
			Serializer.toSource(stop)
		] ;
	}
	
	/**
	 * Sets the timestamp of the event (used this method only in internal in the Event class).
	 */
	/*protected*/ private function _setTimeStamp( nTime:Number ):Void 
	{
		_time = (nTime >= 0) ? nTime : (new Date()).valueOf() ;	
	}

}