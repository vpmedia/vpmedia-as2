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

/**
 * This static enumeration indicated the names of the events in a ITimer instance.
 * @author eKameleon
 * @see Timer
 * @see FrameTimer
 * @see TimerEvent
 */
class vegas.events.TimerEventType 
{

	/**
	 * The name of the event when the ITimer instance restart.
	 */
	static public var RESTART:String = "restart" ;

	/**
	 * The name of the event when the ITimer instance start.
	 */
	static public var START:String = "start" ;

	/**
	 * The name of the event when the ITimer instance stop.
	 */
	static public var STOP:String = "stop" ;
	
	/**
	 * The name of the event when the ITimer instance complete this timer.
	 */
	static public var TIMER:String = "timer" ;
	
	static private var __ASPF__ = _global.ASSetPropFlags(TimerEventType, null , 7, 7) ;
	
}
