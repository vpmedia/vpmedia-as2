/**
 * com.sekati.time.StopWatch
 * @version 1.0.7
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 
import com.sekati.core.CoreObject;

/**
 * Simple stopwatch class
 */
class com.sekati.time.StopWatch extends CoreObject {

	private var _initTime:Number;
	private var _endTime:Number;
	private var _lastLap:Number;
	private var _ms:Number;

	/**
	 * constructor
	 * @param startNow (Boolean)
	 */
	public function StopWatch(startNow:Boolean) {
		super( );
		if(startNow) start( );
	}

	/**
	 * start timer
	 * @return Number ms since start (0)
	 */
	public function start():Number {
		_initTime = getTimer( );
		_lastLap = _initTime;
		return read( );
	}

	/**
	 * stop timer
	 * @return (Number) ms since start
	 */
	public function stop():Number {
		_endTime = getTimer( );
		_ms = _endTime - _initTime;
		return _ms;
	}

	/**
	 * record and return lap
	 * @return (Number) ms since last lap
	 */
	public function lap():Number {
		var now:Number = getTimer( );
		_ms = now - _lastLap;
		_lastLap = now;
		return _ms;
	}

	/**
	 * read total time
	 * @return (Number) ms since stopwatch was initialized
	 */
	public function read():Number {
		var now:Number = getTimer( );
		return now - _initTime;
	}

	/**
	 * Destroy instance.
	 */
	public function destroy():Void {
		stop( );
		super.destroy( );
	}			
}