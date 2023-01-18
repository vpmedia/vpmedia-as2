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
import vegas.core.ICopyable;
import vegas.core.IFormattable;
import vegas.core.IRunnable;
import vegas.core.ITimer;
import vegas.events.EventDispatcher;
import vegas.events.TimerEvent;

/**
 * This abstract class is used to create concrete {@code ITimer} implementations.
 * @author eKameleon
 * @see EventDispatcher
 * @see TimerEvent
 */
class vegas.util.AbstractTimer extends EventDispatcher implements ICloneable, ICopyable, ITimer, IFormattable, IRunnable 
{

	/**
	 * Creates a new ITimer instance if you extend this class.
	 * @param delay the delay between two intervals in this timer.
	 * @param count the number of repetitions of this timer.
	 */
	private function AbstractTimer( nDelay :Number, nCount:Number) 
	{
		setDelay( nDelay ) ;
		setRepeatCount( nCount ) ;
	}

	/**
	 * (read-write) Returns the delay between timer events, in milliseconds.
	 * @return the delay between timer events, in milliseconds.
	 */
	public function  get delay():Number 
	{
		return getDelay() ;
	}

	/**
	 * (read-write) Sets the delay between timer events, in milliseconds.
	 */
	public function set delay( n:Number ):Void 
	{
		setDelay(n) ;	
	}

	/**
	 * (read-write) Returns the number of repetitions. If zero, the timer repeats infinitely. If nonzero, the timer runs the specified number of times and then stops.
	 * @return  the number of repetitions. If zero, the timer repeats infinitely. If nonzero, the timer runs the specified number of times and then stops.
	 */
	public function  get repeatCount():Number 
	{
		return getRepeatCount() ;
	}

	/**
	 * (read-write) Sets the number of repetitions. If zero, the timer repeats infinitely. If nonzero, the timer runs the specified number of times and then stops.
	 */
	public function set repeatCount ( n:Number ):Void 
	{
		setRepeatCount(n) ;	
	}
	
	/**
	 * (read-only) Returns {@code true} if the timer is in progress.
	 * @return {@code true} if the timer is in progress.
	 */
	public function get running():Boolean 
	{
		return getRunning() ;
	}	

	/**
	 * Clear the timer.
	 */
	public function clear():Void 
	{
		// override this method
	}

	/**
	 * Returns a shallow copy of this object.
	 * @return a shallow copy of this object.
	 */
	public function clone() 
	{
		return null ;
	}
	
	/**
	 * Returns a deep copy of this object.
	 * @return a deep copy of this object.
	 */
	/*override*/ public function copy() 
	{
		return null ;
	}

	/**
	 * Returns the delay between timer events, in milliseconds.
	 * @return the delay between timer events, in milliseconds.
	 */
	public function getDelay():Number 
	{
		return _delay ;
	}

	/**
	 * Returns the current counter value of the timer.
	 * @return the current counter value of the timer.
	 */
	public function getCount():Number
	{
		return _count ;	
	}

	/**
	 * Returns the number of repetitions. If zero, the timer repeats infinitely. If nonzero, the timer runs the specified number of times and then stops.
	 * @return the number of repetitions. If zero, the timer repeats infinitely. If nonzero, the timer runs the specified number of times and then stops.
	 */
	public function getRepeatCount():Number 
	{
		return _repeatCount ;
	}

	/**
	 * Returns {@code true} if the timer is in progress.
	 * @return {@code true} if the timer is in progress.
	 */
	public function getRunning():Boolean 
	{
		return _running ;	
	}

	/**
	 * Restarts the timer. The timer is stopped, and then started.
	 */
	public function restart(noEvent:Boolean):Void 
	{
		if (getRunning()) 
		{
			this.stop() ;
		}
		_setRunning(true) ;
		run() ;
		if (!noEvent) 
		{
			dispatchEvent( new TimerEvent( TimerEvent.RESTART, this) ) ;
		}
	}

	/**
	 * Run the timer. Overrides this method.
	 * @see IRunnable
	 */
	public function run():Void 
	{
		// override this method
	}
	
	/**
	 * Sets the delay between timer events, in milliseconds.
	 */
	public function setDelay(n:Number):Void 
	{
		_delay = (n > 0) ? n : 0 ;
		if (getRunning()) 
		{
			restart() ;
		}
	}

	/**
	 * Sets the number of repetitions. If zero, the timer repeats infinitely. If nonzero, the timer runs the specified number of times and then stops.
	 */
	public function setRepeatCount(n:Number):Void
	{
		_repeatCount = (n > 0) ? n : 0 ;
	}

	/**
	 * Starts the timer, if it is not already running.
	 */
	public function start():Void 
	{
		if (getRunning()) return ;
		_count = 0 ;
		dispatchEvent( new TimerEvent(TimerEvent.START, this) ) ;
		restart(true) ;
	}
	
	/**
	 * Stops the timer.
	 */
	public function stop():Void 
	{
		_setRunning(false) ;
		clear() ;
		dispatchEvent( new TimerEvent(TimerEvent.STOP, this) ) ;
	}
	
	/**
	 * The internal counter of the timer.
	 */
	private var _count:Number ;
	
	/**
	 * The internal delay of the timer.
	 */
	private var _delay:Number ;
	
	/**
	 * The internal repeat counter of the timer.
	 */
	private var _repeatCount:Number ;
	
	/**
	 * Determintates if the timer is in progress or not.
	 */
	private var _running:Boolean ;
	
	/**
	 * Protected methods to defined the running property when the timer is in progress.
	 */
	private function _setRunning(b:Boolean):Void 
	{
		_running = b ;
	}

}