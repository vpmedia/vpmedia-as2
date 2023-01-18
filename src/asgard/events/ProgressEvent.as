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
 * The ProgressEvent are dispatched when a load operation has begun or a socket has received data. 
 * These events are usually generated when SWF files, images or data are loaded into Flash Player. 
 * There are two types of progress events: ProgressEvent.PROGRESS and ProgressEvent.SOCKET_DATA.
 * @author eKameleon
 */
class asgard.events.ProgressEvent extends BasicEvent 
{
	
	/**
	 * Creates a new {@code ProgressEvent} instance.
	 * @param type the string type of the instance.
	 * @param bytesLoaded The number of items or bytes loaded at the time the listener processes the event (default 0).
	 * @param bytesTotal The total number of items or bytes that will be loaded if the loading process succeeds (default 0). 
	 * @param target the target of the event.
	 * @param context the optional context object of the event.
	 * @param bubbles indicates if the event is a bubbling event.
	 * @param eventPhase the current EventPhase of the event.
	 * @param time this parameter is used in the Eden deserialization.
	 * @param stop this parameter is used in the Eden deserialization.
	 */
	public function ProgressEvent(type : String, bytesLoaded:Number, bytesTotal:Number, target, context, bubbles : Boolean, eventPhase : Number, time : Number, stop : Number) 
	{
		super(type, target, context, bubbles, eventPhase, time, stop);
		this.bytesLoaded = isNaN(bytesLoaded) ? 0 : bytesLoaded ;
		this.bytesTotal  = isNaN(bytesTotal)  ? 0 : bytesTotal  ;
	}

	/**
	 * Defines the value of the type property of a progress event object.
	 */
	static public var PROGRESS:String = "progress" ; 

	/**
	 * Defines the value of the type property of a socketData event object.
	 */
	static public var SOCKET_DATA:String = "socketData" ; 

	/**
	 * The number of items or bytes loaded when the listener processes the event.
	 */
	public var bytesLoaded:Number ;
	
	/**
	 * The total number of items or bytes that will be loaded if the loading process succeeds.
	 */
	public var bytesTotal:Number ;

	/**
	 * The percentage of the process.
	 */
	public var percent:Number ;

	/**
	 * Returns the shallow copy of this event.
	 * @return the shallow copy of this event.
	 */
	public function clone() 
	{
		var e:ProgressEvent = new ProgressEvent(getType(), getTarget(), bytesLoaded, bytesTotal, getContext()) ;
		e.percent = this.percent ;
		return e ;
	}

}