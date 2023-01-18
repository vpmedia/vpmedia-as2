/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is PEGAS Framework.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <vegas@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2007
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

import pegas.events.ActionEvent;
import pegas.transitions.ITransition;

/**
 * This TransitionEvent class is used by the ITransition process objects.
 * @author eKameleon
 */
class pegas.events.TransitionEvent extends ActionEvent 
{

	/**
	 * Creates a new TransitionEvent instance.
	 * @param type the string type of the instance. 
	 * @param target the target of the event.
	 * @param info The information object of this event.
	 * @param context the optional context object of the event.
	 * @param bubbles indicates if the event is a bubbling event.
	 * @param eventPhase the current EventPhase of the event.
	 * @param time this parameter is used in the Eden deserialization.
	 * @param stop this parameter is used in the Eden deserialization.
	 */
	public function TransitionEvent(type : String, target : Object, info, context, bubbles : Boolean, eventPhase : Number, time : Number, stop : Number) 
	{
		super(type, target, info, context, bubbles, eventPhase, time, stop);
	}

	/**
	 * Returns the ITransition reference of this event.
	 * @return the ITransition reference of this event.
	 */
	public function getTransition():ITransition
	{
		return _t ;
	}
	
	/**
	 * Returns the ITransition id of this event.
	 * @return the ITransition id of this event.
	 */
	public function getTransitionID():String
	{
		return _tID ;
	}

	/**
	 * Sets the ITransition reference of this event.
	 */
	public function setTransition( transition:ITransition ):Void
	{
		_t = transition ;
	}

	/**
	 * Sets the ITransition id of this event.
	 */
	public function setTransitionID( id:String ):Void
	{
		_tID = id ;
	}
	
	/**
	 * The internal ITransition reference of this event.
	 */
	private var _t:ITransition ;

	/**
	 * The internal ITransition ID of this event.
	 */
	private var _tID:String ;

}