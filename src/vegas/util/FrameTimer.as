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
import vegas.util.FrameBeacon;

/**
 * Constructs a {@code new FrameTimer} object with the specified delay and repeat state. This timer use the frames by second of the animation. The timer does not start automatically, you much call the {@code start()} method to start it.
 * <p><b>Example :</b></p>
 * {@code
 * import vegas.events.EventListener ;
 * import vegas.events.Delegate ;
 * import vegas.events.TimerEvent ;
 * import vegas.util.FrameTimer  ;
 * 
 * function onTimer(event:TimerEvent):Void 
 * {
 *     trace("onTimer: " + event.type) ;
 * }
 * 
 * var timeListener:EventListener = new Delegate(this, onTimer) ;
 *	
 * var myTimer:FrameTimer = new FrameTimer(24, 10) ;
 * myTimer.addEventListener(TimerEvent.START, timeListener);
 * myTimer.addEventListener(TimerEvent.STOP, timeListener);
 * myTimer.addEventListener(TimerEvent.TIMER, timeListener);
 * myTimer.start();
 *	
 * this.onKeyDown = function () 
 * {
 *    myTimer.running ? myTimer.stop() : myTimer.restart() ;
 * }
 * Key.addListener(this) ;
 * }
 * @author eKameleon
 * @see TimerEvent
 */
class vegas.util.FrameTimer extends AbstractTimer 
{

	/**
	 * Creates a new FrameTimer instance.
	 */
	public function FrameTimer(delay:Number, repeatCount:Number) 
	{
		super(delay, repeatCount) ;
	}

	/**
	 * Clear the timer interval.
	 */
	/*override*/ public function clear():Void 
	{
		FrameBeacon.removeFrameListener(this) ;
	}

	/**
	 * Returns a shallow copy of this object.
	 * @return a shallow copy of this object.
	 */
	/*override*/ public function clone() 
	{
		return new FrameTimer( getDelay(), getRepeatCount() ) ;
	}

	/**
	 * Returns a deep copy of this object.
	 * @return a deep copy of this object.
	 */
	/*override*/ public function copy() 
	{
		return new FrameTimer( getDelay(), getRepeatCount() ) ;
	}

	/**
	 * Run the timer.
	 * @see IRunnable
	 */
	/*override*/ public function run():Void 
	{
		FrameBeacon.addFrameListener(this) ;
	}

	/**
	 * The next value.
	 */
	private var _next:Number = 0 ;

	/**
	 * This method is invoqued frame by frame.
	 */
	private function onEnterFrame():Void 
	{
		if (++_next >= _delay) 
		{
			dispatchEvent( new TimerEvent(TimerEvent.TIMER, this) ) ;
			_next = 0 ;
			_count ++ ;
		}
		if (_repeatCount && _count >= _repeatCount) 
		{
			this.stop() ;
		}
	}
	
}