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

import pegas.process.AbstractAction;

import vegas.events.Delegate;
import vegas.events.TimerEvent;
import vegas.util.serialize.Serializer;
import vegas.util.Timer;

/**
 * This {@code Action} object create a pause in the process.
 * @author eKameleon
 */
class pegas.process.Pause extends AbstractAction 
{

	/**
	 * Creates a new Pause instance.
	 * @param duration the duration of the pause.
	 * @param seconds the flag to indicates if the duration is in second or not.
	 */
	public function Pause(duration:Number, seconds:Boolean) 
	{
		setDuration(duration) ;
		useSeconds = seconds ;
		_timer = new Timer() ;
		_timer.setRepeatCount(1) ;
		_timer.addEventListener(TimerEvent.TIMER, new Delegate(this, notifyFinished)) ;
	}

	/**
	 * (read-write) Returns the duration of the process.
	 * @return the duration of the process.
	 */
	public function get duration():Number 
	{
		return getDuration() ;	
	}
	
	/**
	 * (read-write) Sets the duration of the process.
	 */
	public function set duration( n:Number ):Void 
	{
		setDuration(n) ;	
	}

	/**
	 * Indicates if the process use seconds or not.
	 */
	public var useSeconds:Boolean ;
	
	/**
	 * Returns a shallow copy of this object.
	 * @return a shallow copy of this object.
	 */
	public function clone() 
	{
		return new Pause(_duration, useSeconds) ;
	}
	
	/**
	 * Returns the duration of the process.
	 * @return the duration of the process.
	 */
	public function getDuration():Number 
	{
		var d:Number = _duration ;
		if (useSeconds) d = Math.round(d * 1000) ;
		return d ;
	}

	/**
	 * Runs the process.
	 */
	public function run():Void 
	{
		if (_timer.running) return ;
		notifyStarted() ;
		_setRunning(true) ;
		_timer.setDelay(getDuration()) ;
		_timer.start() ;
	}

	/**
	 * Sets the duration of the process.
	 */
	public function setDuration(duration:Number):Void 
	{
		_duration = (isNaN(duration) && duration < 0) ? 0 : duration ;
	}
	
	/**
	 * Start the pause process.
	 */
	public function start():Void 
	{
		run() ;
	}

	/**
	 * Stop the pause process.
	 */
	public function stop():Void 
	{
		if (_timer.running) 
		{
			_setRunning(false) ;
			_timer.stop() ;
			notifyStopped() ;	
			notifyFinished() ;	
		}
	}

	/**
	 * Returns a Eden reprensation of the object.
	 * @return a string representing the source code of the object.
	 */
	/*override*/ public function toSource(indent:Number, indentor:String):String 
	{
		var sourceA:String = Serializer.toSource(_duration) ;
		var sourceB:String = Serializer.toSource(useSeconds) ;
		return Serializer.getSourceOf(this, [sourceA, sourceB]) ;
	}

	/**
	 * Returns the string representation of this instance.
	 * @return the string representation of this instance.
	 */
	public function toString():String 
	{
		return "[Pause : " + getDuration() + (useSeconds ? "s" : "ms") + "]" ;
	}

	private var _duration:Number ;
	private var _timer:Timer ;

}
