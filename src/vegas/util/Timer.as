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

import vegas.events.TimerEvent;
import vegas.util.AbstractTimer;

/**
 * The {@code Timer} class is the interface to Flash Player timers. 
 * <p>You can create new Timer objects to run code on a specified time sequence. Use the start() method to start a timer.</p> 
 * <p>Add an EventListener for the timer event to set up code to be run on the timer interval.</p>
 * <p><b>Example :</b></p>
 * {@code
 * import vegas.events.Delegate ;
 * import vegas.events.EventListener ;
 * import vegas.events.TimerEvent ;
 * import vegas.util.Timer  ;
 * 
 * function onTimer(event:TimerEvent):Void 
 * {
 *     trace("onTimer: " + event.type) ;
 * }
 * 
 * var timeListener:EventListener = new Delegate(this, onTimer) ;
 * 
 * var myTimer:Timer = new Timer(1500, 3) ;
 * myTimer.addEventListener(TimerEvent.START, timeListener);
 * myTimer.addEventListener(TimerEvent.STOP, timeListener);
 * myTimer.addEventListener(TimerEvent.TIMER, timeListener);
 * myTimer.start();
 * }
 * @author eKameleon
 * @see TimerEvent
 */
class vegas.util.Timer extends AbstractTimer 
{

	/**
	 * Creates a new Timer object with the specified delay and repeat state. 
	 * The timer does not start automatically; you much call the start() method to start it.
	 * @param delay the delay between two intervals in this timer.
	 * @param repeatCount the number of repetitions of this timer.
	 */
	public function Timer(delay:Number, repeatCount:Number) 
	{
		super(delay, repeatCount) ;
	}

	/**
	 * Clear the timer interval.
	 */
	/*override*/ public function clear():Void 
	{
		clearInterval(_itv) ;
		_itv = null ;
	}
	
	/**
	 * Returns a shallow copy of this object.
	 * @return a shallow copy of this object.
	 */
	/*override*/ public function clone() 
	{
		return new Timer( getDelay(), getRepeatCount() ) ;
	}

	/**
	 * Returns a deep copy of this object.
	 * @return a deep copy of this object.
	 */
	/*override*/ public function copy() 
	{
		return new Timer( getDelay(), getRepeatCount() ) ;
	}

	/**
	 * Returns the interval id of this timer.
	 * This method is an internal method use with this class and this Unit test only.
	 * @return the interval id of this timer.
	 */
	public function getIntervalID():Number
	{
		return _itv ;	
	}

	/**
	 * Run the timer.
	 * @see IRunnable
	 */
	/*override*/ public function run():Void 
	{
		_itv = setInterval(this, "_next", _delay) ;
	}
	
	/**
	 * The internal timer interval.
	 */
	private var _itv:Number ;
	
	/**
	 * Launch the next interval.
	 */
	private function _next():Void 
	{
		dispatchEvent( new TimerEvent(TimerEvent.TIMER, this) ) ;
		_count ++ ;
		if (_repeatCount != 0 && _repeatCount == _count) 
		{
			this.stop() ;
		}
	}
	
}