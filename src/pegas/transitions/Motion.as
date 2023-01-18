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

import vegas.core.ITimer;
import vegas.events.Delegate;
import vegas.events.EventListener;
import vegas.events.TimerEvent;
import vegas.util.FrameTimer;
import vegas.util.Timer;

/**
 * The Motion class.
 * @author eKameleon
 */
class pegas.transitions.Motion extends AbstractAction 
{

	/**
	 * Creates a new Motion instance.
	 */
	function Motion() 
	{
		_oNext = new Delegate(this, nextFrame) ;
	}

	/**
	 * Returns the duration of the tweened animation in frames or seconds.
	 * @return the duration of the tweened animation in frames or seconds.
	 */
	public function get duration():Number 
	{
		return getDuration() ;
	}
	
	/**
	 * Sets the duration of the tweened animation in frames or seconds.
	 */
	public function set duration( n:Number ):Void 
	{
		setDuration(n) ;
	}
	
	/**
	 * Returns the number of frames per second of the tweened animation.
	 * @return the number of frames per second of the tweened animation.
	 */
	public function get fps():Number 
	{
		return getFPS() ;
	}
	
	/**
	 * Sets the number of frames per second of the tweened animation.
	 */
	public function set fps( n:Number ):Void 
	{
		setFPS(n) ;
	}

	/**
	 * Defined the internal prevTime value.
	 */
	public var prevTime:Number ;

	/**
	 * Returns the target reference of the object contrains by the Motion effect.
	 * @return the target reference of the object contrains by the Motion effect.
	 */
	public function get target() 
	{
		return getTarget() ;	
	}
	
	/**
	 * Sets the target reference of the object contrains by the Motion effect.
	 */
	public function set target( oT ) 
	{
		setTarget( oT ) ;	
	}

	/**
	 * Defined if the Motion used seconds or not.
	 */
	public var useSeconds:Boolean ;

	/**
	 * Returns a shallow copy of this object.
	 * @return a shallow copy of this object.
	 */
	public function clone() 
	{
		//
	}
	
	/**
	 * Forwards the tweened animation directly to the end of the animation.
	 */
	public function fforward():Void 
	{ 
		setTime (_duration) ;
		_fixTime() ;
	}
	
	/**
	 * Returns the duration of the tweened animation in frames or seconds.
	 * @return the duration of the tweened animation in frames or seconds.
	 */
	public function getDuration():Number 
	{ 
		return _duration ;
	}

	/**
	 * Returns the number of frames per second of the tweened animation.
	 * @return the number of frames per second of the tweened animation.
	 */
	public function getFPS ():Number 
	{ 
		return _fps;
	}

	/**
	 * Returns the target reference of the object contrains by the Motion effect.
	 * @return the target reference of the object contrains by the Motion effect.
	 */
	public function getTarget() 
	{
		return _target ;
	}

	/**
	 * Returns the current time within the duration of the animation.
	 * @return the current time within the duration of the animation.
	 */
	public function getTime():Number 
	{ 
		return _time ;
	}

	/**
	 * Forwards the tweened animation to the next frame.
	 */
	public function nextFrame():Void 
	{ 
		var t:Number = (useSeconds) ? ((getTimer() - _startTime) / 1000) : (_time + 1) ;
		setTime(t) ;
	}
	
	/**
	 * Directs the tweened animation to the frame previous to the current frame.
	 */
	public function prevFrame():Void 
	{
		if (!useSeconds) setTime (_time - 1)  ;
	}
	
	/**
	 * Resumes a tweened animation from its stopped point in the animation.
	 */
	public function resume():Boolean 
	{
		if (_stopping && _time != duration) 
		{
			_fixTime() ;
			startInterval() ;
			return true ;
			notifyResumed() ;
		}
		else 
		{
			return false ;
		}
	}
	
	/**
	 * Rewinds a tweened animation to the beginning of the tweened animation.
	 */
	public function rewind(t:Number):Void 
	{
		_time = t || 0 ;
		_fixTime() ;
		update() ;
	}
	
	/**
	 * Runs the object.
	 */
	public function run():Void 
	{
		notifyStarted() ;
		rewind() ;
		startInterval() ;
	}

	/**
	 * Sets the duration of the tweened animation in frames or seconds
	 */
	public function setDuration(n:Number):Void 
	{ 
		_duration = (isNaN(n) || n <= 0 ) ? _global.Infinity : n ;
	}
	
	/**
	 * Sets the number of frames per second of the tweened animation.
	 */
	public function setFPS (n:Number):Void 
	{
		var tmp:Boolean = running ;
		_timer.stop() ;
		_fps = n ;
		if (tmp) _timer.start() ;
	}
	
	/**
	 * Sets the target reference of the object contrains by the Motion effect.
	 */
	public function setTarget(o):Void 
	{
		_target = o ;
	}
	
	/**
	 * Sets the current time within the duration of the animation.
	 */
	public function setTime(t:Number):Void 
	{
		prevTime = _time ;
		if (t > _duration) {
			if (looping) {
				rewind (t - _duration);
				this.update();
				notifyLooped() ;
			} else {
				if (useSeconds) {
					_time = _duration ;
					update() ;
				}
				this.stop() ;
				notifyFinished() ;
			}
		} else if (t<0) {
			rewind() ;
			update() ;
		} else {
			_time = t ;
			update() ;
		}
	}

	/**
	 * Sets the internal timer of the tweened animation.
	 */
	public function setTimer(timer:ITimer):Void 
	{
		if (_timer) 
		{
			_timer.stop();
			_timer.removeEventListener(TimerEvent.TIMER, _oNext) ;
			_timer = null ;
		}
		_timer = timer ;
		_timer.addEventListener(TimerEvent.TIMER, _oNext ) ;
	}
	
	/**
	 * Starts the tweened animation from the beginning.
	 */
	public function start():Void 
	{
		_stopping = false ; 
		run() ;
	}
	
	/**
	 * Starts the intenral interval of the tweened animation.
	 */
	public function startInterval():Void 
	{
		if (_fps) 
		{
			setTimer(new Timer(1000 / _fps)) ;
		}
		else 
		{
			setTimer(new FrameTimer()) ;
		}
		_timer.start() ; 
		_setRunning(true) ;
	}
	
	/**
	 * Stops the tweened animation at its current position.
	 */
	public function stop():Void 
	{
		stopInterval() ;
		_stopping = true ;
		notifyStopped() ;
	}

	/**
	 * Stops the intenral interval of the tweened animation.
	 */
	public function stopInterval():Void 
	{
		_timer.stop() ;
		_setRunning(false) ;
	}
	
	/**
	 * Update the current object.
	 */
	public function update():Void 
	{
		//
	}
	
	private var _duration:Number ;
	private var _fps:Number ;
	private var _oNext:EventListener ;
	private var _startTime:Number ;
	private var _stopping:Boolean ;
	private var _target ;
	private var _time:Number ;
	private var _timer:ITimer ;
	
	private function _fixTime():Void 
	{
		if ( useSeconds) _startTime = getTimer() - _time * 1000 ;
	}
	
}