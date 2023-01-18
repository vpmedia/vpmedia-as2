/*
Class	Timer
Package	ch.util
Project	MainAPI

Created by :	Tabin Cedric - thecaptain
Created at :	28 janv. 2006
*/

/**
 * Manage a delayed repetitive action.
 * 
 * @author		Tabin Cedric - thecaptain
 * @since		28 déc. 2005
 * @version		1.0
 */
class ch.util.Timer
{
	//---------//
	//Variables//
	//---------//
	private var			_interval:Number;
	private var			_lastTime:Number;
	private var			_loop:Number;
	private var			_loopResume:Number;
	private var			_paused:Boolean;
	private var			_started:Boolean;
	private var			_waiting:Boolean;
	
	/**
	 * Called each time the interval time
	 * expired.
	 * <p>Prototype :<br /><code>
	 * myTimer.onLoop = function(Void):Void { }</code></p>
	 */
	public var			onLoop:Function;
	
	/**
	 * Called when the timer starts.
	 * <p>Prototype :<br /><code>
	 * myTimer.onStart = function(Void):Void { }</code></p>
	 */
	public var			onStart:Function;
	
	/**
	 * Called when the timer stops.
	 * <p>Prototype :<br /><code>
	 * myTimer.onStop = function(Void):Void { }</code></p>
	 */
	public var			onStop:Function;
	
	/**
	 * Called when the timer pauses.
	 * <p>Prototype :<br /><code>
	 * myTimer.onPause = function(Void):Void { }</code></p>
	 */
	public var			onPause:Function;
	
	/**
	 * Called when the timer resumes.
	 * <p>Prototype :<br /><code>
	 * myTimer.onResume = function(Void):Void { }</code></p>
	 */
	public var			onResume:Function;
	
	//-----------//
	//Constructor//
	//-----------//
	
	/**
	 * Create a new Timer.
	 * 
	 * @param	interval	The interval time.
	 */
	public function Timer(interval:Number)
	{
		if (isNaN(interval))
		{
			throw new Error(this+".<init> : interval is not a number");
		}
		
		_interval = interval;
		_lastTime = 0;
		_loop = null;
		_loopResume = null;
		_paused = false;
		_started = false;
		_waiting = false;
		
		onLoop = null;
		onStop = null;
		onStart = null;
		onPause = null;
		onResume = null;
	}
	
	//--------------//
	//Public methods//
	//--------------//
	
	/**
	 * Get if the Timer is paused.
	 * 
	 * @return	{@code true} if the Timer is paused.
	 */
	public function isPaused(Void):Boolean
	{
		return _paused;
	}
	
	/**
	 * Get if the Timer is started.
	 * 
	 * @return	{@code true} if the Timer is started.
	 */
	public function isStarted(Void):Boolean
	{
		return _started;
	}
	
	/**
	 * Get if the Timer is waiting for an action.
	 * <p>This method may return {@code true} if a delayed
	 * method like {@link #startAfter()}, {@link #stopAfter()}, {@link #pauseAfter()}
	 * or {@link #resumeAfter()} method has been called.</p>
	 * 
	 * @return	{@code true} if the timer is pending.
	 */
	public function isWaiting(Void):Boolean
	{
		return _waiting;
	}
	
	/**
	 * Get the interval time.
	 * 
	 * @return	The interval time.
	 */
	public function getInterval(Void):Number
	{
		return _interval;
	}
	
	/**
	 * Start the timer.
	 */
	public function start(Void):Void
	{
		if (_loop != null || _paused)
		{
			return;
		}
		
		_waiting = false;
		_started = true;
		_loop = setInterval(this, "update", _interval);
		
		onStart();
	}
	
	/**
	 * Start the timer after a specified time.
	 * 
	 * @param	wait	The number of ms to wait.
	 */
	public function startAfter(wait:Number):Void
	{
		if (_waiting || _started)
		{
			return;
		}
		
		_waiting = true;
		_global.setTimeout(this, "start", wait);
	}
	
	/**
	 * Pause the timer.
	 */
	public function pause(Void):Void
	{
		if (_loop == null || !_started)
		{
			return;
		}
		
		clearInterval(_loop);
		_paused = true;
		_loop = null;
		_lastTime = getTimer();
		
		onPause();
	}
	
	/**
	 * Pause the timer after a specified time.
	 * 
	 * @param	wait	The number of ms to wait.
	 */
	public function pauseAfter(wait:Number):Void
	{
		if (_loop == null || !_started || _waiting)
		{
			return;
		}
		
		_waiting = true;
		_global.setTimeout(this, "pause", wait);
	}
	
	/**
	 * Resume the timer.
	 */
	public function resume(Void):Void
	{
		if (!_started || _loop != null || _loopResume != null)
		{
			return;
		}
		
		_waiting = false;
		_paused = false;
		_loopResume = setInterval(this, "updateResume", _lastTime%_interval);
		
		onResume();
	}
	
	/**
	 * Resume the timer after a specified time.
	 * 
	 * @param	wait	The number of ms to wait.
	 */
	public function resumeAfter(wait:Number):Void
	{
		if (!_started || _loop != null || _loopResume != null || _waiting)
		{
			return;
		}
		
		_waiting = true;
		_global.setTimeout(this, "resume", wait);
	}
	
	/**
	 * Stop the timer.
	 */
	public function stop(Void):Void
	{
		if (_loop == null)
		{
			return;
		}
		
		clearInterval(_loop);
		_loop = null;
		_waiting = false;
		_started = false;
		
		onStop();
	}
	
	/**
	 * Stop the timer after a specified time.
	 * 
	 * @param	wait	The number of ms to wait.
	 */
	public function stopAfter(wait:Number):Void
	{
		if (_loop == null || _waiting)
		{
			return;
		}

		_waiting = true;
		_global.setTimeout(this, "stop", wait);
	}
	
	/**
	 * Represent the current instance into a String.
	 *
	 * @return	A String representing the Timer instance.
	 */
	public function toString(Void):String
	{
		return "ch.util.Timer";
	}
	
	//---------------//
	//Private methods//
	//---------------//
	
	private function update(Void):Void
	{
		onLoop();
	}
	
	private function updateResume(Void):Void
	{
		clearInterval(_loopResume);
		
		_loopResume = null;
		_waiting = false;
		_started = true;
		_loop = setInterval(this, "update", _interval);
		
		update();
	}
}