/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
        http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is ASGard Framework.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <vegas@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2007
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

import vegas.events.BooleanEvent;

/**
 * The {@code FullScreenEvent} to dispatch an event in a {@code StageDisplayState} object.
 * @author eKameleon
 */
class asgard.events.FullScreenEvent extends BooleanEvent 
{
	
	/**
	 * Creates a new FullScreenEvent instance.
	 * @param type the string type of the instance.
	 * @param b The {@code Boolean} flag object of this event. 
	 * @param target the target of the event.
	 * @param context the optional context object of the event.
	 * @param bubbles indicates if the event is a bubbling event.
	 * @param eventPhase the current EventPhase of the event.
	 * @param time this parameter is used in the Eden deserialization.
	 * @param stop this parameter is used in the Eden deserialization.
	 */
	public function FullScreenEvent(type:String, b:Boolean, target, context, bubbles:Boolean, eventPhase:Number, time:Number, stop:Number) 
	{
		super(type, b, target, context, bubbles, eventPhase, time, stop);
	}

	/**
	 * The FullScreenEvent.FULL_SCREEN constant defines the value of the type property of a fullScreen event object.
	 */
	static public var FULLSCREEN:String = "fullscreen" ;

	/**
	 * (read_only) Indicates whether the Stage object is in full-screen mode (true) or not (false).
	 * @return {@code true} if the Stage object is in full-screen mode.
	 */	
	public function get fullScreen():Boolean
	{
		return this.getBoolean() ;	
	} 

	/**
	 * Creates and returns a shallow copy of this instance.
	 * @return a shallow copy of this event.
	 */
	public function clone() 
	{
		return new FullScreenEvent(getType(), getBoolean(), getTarget(), getContext()) ;
	}
	
}