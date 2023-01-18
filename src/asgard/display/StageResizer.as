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

import vegas.core.IFormattable;
import vegas.events.DynamicEvent;
import vegas.events.Event;
import vegas.events.EventDispatcher;
import vegas.events.EventListener;
import vegas.events.EventType;
import vegas.events.TimerEvent;
import vegas.util.Timer;

/**
 * This controller manage the Stage.onResize event and use a delay to dispatch the EventType.RESIZE event.
 * <p><b>Example :</b></p>
 * {@code
 * import asgard.display.StageResizer ;
 * import vegas.events.* ;
 * 
 * var onDebug = function (ev:Event) 
 * {
 *     trace (">> " + ev.getType() ) ;
 * }
 * 
 * var debug:EventListener = new Delegate(this, onDebug) ;
 * var resizer:StageResizer = new StageResizer(true) ;
 * resizer.addEventListener(EventType.RESIZE, debug) ;
 * }
 */
class asgard.display.StageResizer extends EventDispatcher implements EventListener, IFormattable 
{

	/**
	 * Creates a new StageResizer instance.
	 */
	public function StageResizer(autoResize:Boolean, delay:Number) 
	{
		_timer = new Timer(isNaN(delay) ? DEFAULT_DELAY : delay, 1) ;
		_timer.addEventListener(TimerEvent.TIMER, this) ;
		Stage.addListener(this) ;
		if (autoResize) 
		{
			onResize() ;
		}
	}

	/**
	 * (read-write) Returns the default delay value ( 300 ms by default )
	 */
	static public function get DEFAULT_DELAY():Number 
	{
		return __defaultDelay ;
	}

	/**
	 * (read-write) Sets the default delay value.
	 */
	static public function set DEFAULT_DELAY(delay:Number):Void {
		__defaultDelay = (isNaN(delay) || delay < 0) ? 0 : delay ;
	}

	/**
	 * Returns the delay before dispatch the EventType.RESIZE event.
	 * @return the delay before dispatch the EventType.RESIZE event.
	 */
	public function get delay():Number { 
		return getDelay () ;
	}
	
	/**
	 * Sets the delay before dispatch the EventType.RESIZE event.
	 */
	public function set delay(time:Number):Void 
	{
		setDelay(time) ;
	}	

	/**
	 * Returns the delay before dispatch the EventType.RESIZE event.
	 */
	public function getDelay():Number 
	{
		return _timer.getDelay() ;
	}
	
	/**
	 * Handles the event.
	 */
	public function handleEvent(e:Event) 
	{
		dispatchEvent( new DynamicEvent(EventType.RESIZE, this) ) ;
	}

	/**
	 * Sets the delay before dispatch the EventType.RESIZE event.
	 */
	public function setDelay(time:Number):Void 
	{ 
		_timer.setDelay(time) ;
	}
	
	static private var __defaultDelay = 300 ;

	private var _timer:Timer ;
	
	private function onResize(Void):Void 
	{
		_timer.stop() ;
		_timer.start() ;
	}
	
}