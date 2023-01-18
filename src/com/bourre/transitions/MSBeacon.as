/*
 * Copyright the original author or authors.
 * 
 * Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.mozilla.org/MPL/MPL-1.1.html
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
 
/**
 * {@code MSBeacon} acts as a Time synchronizer.
 * 
 * <p>Dispatchs onEnterFrame event at each frame defined by 
 * defined instance framerate. 
 * 
 * @author Francis Bourre
 * @version 1.0
 */

import com.bourre.events.EventType;
import com.bourre.log.PixlibStringifier;
import com.bourre.transitions.IFrameBeacon;
import com.bourre.transitions.IFrameListener;

class com.bourre.transitions.MSBeacon
	implements IFrameBeacon
{
	//-------------------------------------------------------------------------
	// Private properties
	//-------------------------------------------------------------------------
	
	private static var _oB:MSBeacon;
	
	private var addListener:Function;
	private var removeListener:Function;
	private var broadcastMessage:Function;
	private var _listeners:Array;
	
	private var _nID:Number;
	private var _bIsP:Boolean;
	private var _nFrameRate:Number;
	
	
	//-------------------------------------------------------------------------
	// Public Properties
	//-------------------------------------------------------------------------
	
	/** default framerate using by {@code MSBeacon} instance **/
	public static var DEFAULTFRAMERATE:Number = 10;
	
	/** Broadcasts at each frame (based on defined framerate). **/
	public static var onEnterFrameEVENT:EventType = new EventType('onEnterFrame');
	
	
	//-------------------------------------------------------------------------
	// Public API
	//-------------------------------------------------------------------------
	
	/**
	 * Returns {@code MSBeacon} instance.
	 * 
	 * <p>Always return the same instance.
	 * 
	 * @return {@code MSBeacon} instance
	 */
	public static function getInstance() : MSBeacon
	{
		if (!_oB) _oB = new MSBeacon();
		return _oB;
	}
	
	/**
	 * Constructs a new {@code MSBeacon} instance.
	 */
	public function MSBeacon( nFrameRate:Number )
	{
		AsBroadcaster.initialize(this);
		_bIsP = false;
		_nFrameRate = nFrameRate;
	}
	
	/**
	 * Broadcasts {@link #onEnterFrameEVENT} event.
	 * 
	 * <p>Can use it to force frame updating. 
	 */
	public function fireFrameEvent()
	{
		this.broadcastMessage(onEnterFrameEVENT);
		updateAfterEvent();
	}
	
	/**
	 * Returns current framerate used by instance.
	 * 
	 * @return {@code Number} framerate
	 */
	public function getFrameRate() : Number
	{
		return _nFrameRate;
	}
	
	/**
	 * Defines {@code MSBeacon} framerate.
	 * 
	 * @param n new framerate
	 */
	public function setFrameRate(n:Number) : Void
	{
		_nFrameRate = n;
	}
	
	/**
	 * Defines {@code MSBeacon} framerate based on 
	 * a FPS {@code Number} value.
	 * 
	 * @param n new FPS value
	 */
	public function setFPS( fps:Number ) : Void
	{
		_nFrameRate = Math.round( 1000/fps );
	}
	
	/**
	 * Returns current framerate used by instance 
	 * based on FPS value.
	 * 
	 * @return {@code Number} FPS value
	 */
	public function getFPS() : Number
	{
		return Math.round(1000/_nFrameRate);
	}
	
	/**
	 * Destroy {@code MSBeacon} instance.
	 * 
	 * <p>Warning {@code onEnterFrame} event will never be
	 * broadcasted.
	 */
	public static function release() : Void
	{
		_oB.stop();
		delete _oB;
	}
	
	/**
	 * Starts the process.
	 * 
	 * <p>Example
	 * <code>
	 *  MSBeacon.getInstance().start();
	 * </code>
	 */
	public function start() : Void
	{
		clearInterval( _nID ); // security
		if (_nFrameRate == undefined) _nFrameRate = MSBeacon.DEFAULTFRAMERATE;
		_nID = setInterval(this, 'fireFrameEvent', _nFrameRate);
		_bIsP = true;
	}
	
	/**
	 * Stops the process.
	 * 
	 * <p>Example
	 * <code>
	 *   MSBeacon.getInstance().stop();
	 * </code>
	 */
	public function stop() : Void
	{
		clearInterval( _nID );
		_bIsP = false;
	}
	
	/**
	 * Indicates if FPSBeacon's running.
	 * 
	 * <p>Example
	 * <code>
	 *   var b:Boolean = FPSBeacon.getInstance().isPlaying();</em>
	 * </code>
	 * 
	 * @return {@code true} if {@code FPSBeacon} is running, either {@code false}
	 */
	public function isPlaying() : Boolean
	{
		return _bIsP;
	}
	
	/**
	 * Adds listener for receiving all {@code FPSBeacon} events.
	 * 
	 * <p>Example
	 * <code>
	 *   var b : MSBeacon = MSBeacon.getInstance();
	 *   b.addFrameListener( myListener );
	 * </code>
	 * 
	 * @param oL Listener object which implements {@link IFrameListener} interface.
	 */
	public function addFrameListener(oL:IFrameListener) : Void
	{
		if (_listeners.length < 1) start();
		addListener(oL);
	}
	
	/**
	 * Removes passed-in listener for receiving all {@code FPSBeacon} events.
	 * 
	 *  <p>Example
	 * <code>
	 *   var b : MSBeacon = MSBeacon.getInstance();
	 *   b.removeFrameListener( myListener );
	 * </code>
	 * 
	 * @param oL Listener object which implements {@link IFrameListener} interface.
	 */
	public function removeFrameListener(oL:IFrameListener) : Void
	{
		removeListener(oL);
		if (_listeners.length < 1) this.stop();
	}
	
	/**
	 * Returns the string representation of this instance.
	 * @return the string representation of this instance
	 */
	public function toString() : String 
	{
		return PixlibStringifier.stringify( this );
	}
}