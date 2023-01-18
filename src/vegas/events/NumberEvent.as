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

import vegas.events.DynamicEvent;

/**
 * The {@code NumberEvent} to dispatch an event with a number object.
 * @author eKameleon
 */
class vegas.events.NumberEvent extends DynamicEvent 
{
	
	/**
	 * Creates a new NumberEvent instance.
	 */
	public function NumberEvent(type:String, n:Number, target, context, bubbles:Boolean, eventPhase:Number, time:Number, stop:Number) 
	{
		
		super(type, target, context, bubbles, eventPhase, time, stop);
		_n = n ;
		
	}

	/**
	 * Creates and returns a shallow copy of this instance.
	 */
	public function clone() 
	{
		return new NumberEvent(getType(), getNumber(), getTarget(), getContext()) ;
	}
	
	/**
	 * Returns the number instance.
	 */
	public function getNumber():Number
	{
		return _n ;	
	}
	
	/**
	 * Sets the number instance.
	 */
	public function setNumber(n:Number):Void
	{
		_n = n ;	
	}
	
	/**
	 * The internal number instance.
	 */
	private var _n:Number ;

}