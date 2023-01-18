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

import vegas.core.ICloneable;

/**
 * Event interface, that contains information about a generic event.
 * @author eKameleon
 */
interface vegas.events.Event extends ICloneable 
{

	// var stop:Number ;

	/**
	 * Cancel the event.
	 */
	function cancel():Void ;
		
	/**
	 * Returns {@code true} if this event is a bubbling event.
	 * @return {@code true} if this event is a bubbling event.
	 */
	function getBubbles():Boolean ;
		
	/**
	 * Returns the event context.
	 * @return the event context.
	 */
	function getContext() ;
		
	/**
	 * Returns the current target of this event in a capturing or a bubbling phase.
	 * @return the current target of this event in a capturing or a bubbling phase.
	 */
	function getCurrentTarget() ;
		
	/**
	 * Returns the event phase value.
	 * @see EventPhase
	 */
	function getEventPhase():Number ;
		
	/**
	 * Returns the target of this event.
	 */
	function getTarget() ;
	
	/**
	 * Returns the timestamp value of this event.
	 */
	function getTimeStamp():Number ;
	
	/**
	 * Returns the type of the event.
	 * @return the string representation of the type of this event.
	 */
	function getType():String ;
	
	/**
	 * Initialize the event.
	 */
	function initEvent(type:String, bubbles:Boolean, cancelable:Boolean):Void ;
	
	/**
	 * Check, whether the event has been cancelled.
	 * @return {@code true} if the event has been cancelled, false otherwise.
	 */
	function isCancelled():Boolean ;

	/**
	 * Check, whether the event already is in a queue.
	 * @return (@code true} if the event already is in a queue. 
	 */
	function isQueued():Boolean ;
	
	/**
	 * Flags the event as queued.
	 */
	function queueEvent():Void ;
	
	/**
	 * Sets if the event is bubbling.
	 */
	function setBubbles(b:Boolean):Void ;
	
	/**
	 * Sets the context of this event.
	 */
	function setContext(context):Void ;
	
	/**
	 * Sets the current target of this event in a bubbling or capturing phase.
	 */
	function setCurrentTarget(target):Void ;
	
	/**
	 * Sets the {@code EventPhase} of this event.
	 */
	function setEventPhase(n:Number):Void ;
	
	/**
	 * Sets the target of this event.
	 */
	function setTarget(target):Void ;
	
	/**
	 * Sets the event type.
	 */
	function setType(type:String):Void ;
	
	/**
	 * Stops the propagation of this event in the event flow.
	 */
	function stopPropagation():Void ;
	
	/**
	 * Stops immediately the propagation of this event in the event flow.
	 */
	function stopImmediatePropagation():Void ;
	
	/**
	 * Returns a Eden representation of the object.
	 * @return a string representing the source code of the object.
	 */
	function toSource(indent:Number, indentor:String):String ;

	/**
	 * Returns the string representation of this instance.
	 * @return the string representation of this instance.
	 */
	function toString():String ;
	
}