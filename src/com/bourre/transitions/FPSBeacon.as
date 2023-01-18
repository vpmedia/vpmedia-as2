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
 * {@code FPSBeacon} acts as a FPS synchronizer.
 * 
 * <p>Dispatchs onEnterFrame event at each displayed frame by the player. 
 * 
 * @author Francis Bourre
 * @version 1.0
 */

import com.bourre.commands.Delegate;
import com.bourre.events.EventType;
import com.bourre.log.PixlibStringifier;
import com.bourre.transitions.IFrameBeacon;
import com.bourre.transitions.IFrameListener;

class com.bourre.transitions.FPSBeacon
	implements IFrameBeacon
{
	//-------------------------------------------------------------------------
	// Private properties
	//-------------------------------------------------------------------------
	
	private static var _oB:FPSBeacon;
	
	private var addListener:Function;
	private var removeListener:Function;
	private var broadcastMessage:Function;
	private var _listeners:Array;
	
	private var _mc:MovieClip;
	private var _f:Function;
	
	
	//-------------------------------------------------------------------------
	// Public Properties
	//-------------------------------------------------------------------------
	
	/** Broadcasts at each frame displayed by the player. **/
	public static var onEnterFrameEVENT:EventType = new EventType('onEnterFrame');
	
	
	//-------------------------------------------------------------------------
	// Public API
	//-------------------------------------------------------------------------
	
	/**
	 * Returns {@code FPSBeacon} instance.
	 * 
	 * <p>Always return the same instance.
	 * 
	 * @return {@code FPSBeacon} instance
	 */
	public static function getInstance() : FPSBeacon
	{
		if (!_oB) _oB = new FPSBeacon();
		return _oB;
	}
	
	/**
	 * Destroy {@code FPSBeacon} instance.
	 * 
	 * <p>Warning {@code onEnterFrame} event will never be 
	 * broadcasted.
	 */
	public static function release() : Void
	{
		_oB.stop();
		_oB._mc.removeMovieClip();
		delete _oB;
	}
	
	/**
	 * Starts the process.
	 * 
	 * <p>Example
	 * <code>
	 *  FPSBeacon.getInstance().start();
	 * </code>
	 */
	public function start() : Void
	{
		_mc.onEnterFrame = _f;
	}
	
	/**
	 * Stops the process.
	 * 
	 * <p>Example
	 * <code>
	 *   FPSBeacon.getInstance().stop();
	 * </code>
	 */
	public function stop() : Void
	{
		delete _mc.onEnterFrame;
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
		return _mc.onEnterFrame == _f;
	}
	
	/**
	 * Adds listener for receiving all {@code FPSBeacon} events.
	 * 
	 * <p>Example
	 * <code>
	 *   var b : FPSBeacon = FPSBeacon.getInstance();
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
	 *   var b : FPSBeacon = FPSBeacon.getInstance();
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
	
	
	//-------------------------------------------------------------------------
	// Private implementation
	//-------------------------------------------------------------------------
	
	private function FPSBeacon()
	{
		AsBroadcaster.initialize(this);
		_mc = _level0.createEmptyMovieClip ("__mcBeacon", 9997);
		_f = Delegate.create(this, broadcastMessage, onEnterFrameEVENT);
	}
	
}