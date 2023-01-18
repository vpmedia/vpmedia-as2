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
 * {@code TweenFPS} extends {@link BasicTweenFPS} class implementing
 * Pixlib Event API.
 * 
 * <p>Can use these methods to control Tween event :
 * <ul>
 *   <li>{link #addListener}</li> *   <li>{link #removeListener}</li> *   <li>{link #addEventListener}</li> *   <li>{link #removeEventListener}</li>
 * </ul>
 * 
 * <p>Example
 * <code>
 *   var t : TweenFPS = new TweenFPS(mc, '_alpha', 0, 30, 100);
 *   t.addListener(this);
 *   t.addEventListener(TweenFPS.onMotionFinishedEVENT, this, __onFinish);
 *   t.start();
 * </code>
 * 
 * @author Francis Bourre
 * @version 1.0
 */

import com.bourre.events.EventBroadcaster;
import com.bourre.events.IEvent;
import com.bourre.log.PixlibStringifier;
import com.bourre.transitions.BasicTweenFPS;
import com.bourre.transitions.ITween;
import com.bourre.transitions.ITweenListener;
import com.bourre.transitions.TweenEvent;
import com.bourre.transitions.TweenEventType;

class com.bourre.transitions.TweenFPS extends BasicTweenFPS 
	implements ITween
{
	//-------------------------------------------------------------------------
	// Events definition
	//-------------------------------------------------------------------------
	
	/**
	 * Broadcasted to listeners when tween starts.<br>
	 */
	[Event("onStart")]
	public static var onStartEVENT:TweenEventType = TweenEventType.onStartEVENT;
	
	/**
	 * Broadcasted to listeners when tween stops.<br>
	 */
	[Event("onStop")]
	public static var onStopEVENT:TweenEventType = TweenEventType.onStopEVENT;
	
	/**
	 * Broadcasted to listeners when tween is finished.<br>
	 */
	[Event("onMotionFinished")]
	public static var onMotionFinishedEVENT:TweenEventType = TweenEventType.onMotionFinishedEVENT;
	
	/**
	 * Broadcasted to listeners when property value is updated.<br>
	 */
	[Event("onMotionChanged")]
	public static var onMotionChangedEVENT:TweenEventType = TweenEventType.onMotionChangedEVENT;
	
	
	//-------------------------------------------------------------------------
	// Private properties
	//-------------------------------------------------------------------------
	
	private var _oEB:EventBroadcaster;
	
	private var _eOnMotionChangedEvent : TweenEvent;
	private var _eOnMotionFinishedEvent : TweenEvent;
	private var _eOnMotionStartEvent : TweenEvent;
	private var _eOnMotionStopEvent : TweenEvent;
	
	
	//-------------------------------------------------------------------------
	// Public API
	//-------------------------------------------------------------------------
	
	/**
	 * Constructs a new {@code TweenFPS} instance.
	 * 
	 * <p>Example
	 * <code>
	 *   var t:TweenFPS = new TweenFPS(mc, '_alpha', 0, 30, 100);
	 * </code>
	 * 
	 * @param oT 	Object which the Tween targets.
	 * @param sP 	Setter (method or property).
	 * @param nE 	Ending value of property.
	 * @param nFps 	Length of time of the motion in frames.
	 * @param nS 	(optional) Starting value of property.
	 * @param fE 	(optional) Easing function.
	*/
	public function TweenFPS(oT, sP, nE:Number, nMs:Number, nS:Number, fE:Function)
	{
		super(oT, sP, nE, nMs, nS, fE);
		_oEB = new EventBroadcaster( this );
		
		_eOnMotionStartEvent = new TweenEvent(onStartEVENT, this);		_eOnMotionStopEvent = new TweenEvent(onStopEVENT, this);
		_eOnMotionChangedEvent = new TweenEvent(onMotionChangedEVENT, this);
		_eOnMotionFinishedEvent = new TweenEvent(onMotionFinishedEVENT, this);
	}

	/**
	 * Adds listener for receiving all events.
	 * 
	 * <p>Example
	 * <code>
	 *   t.addListener(myListener);
	 * </code>
	 * 
	 * @param oL Listener object which implements {@link ITweenListener} interface.
	 */
	public function addListener(oL:ITweenListener) : Void
	{
		_oEB.addListener(oL);
	}
	
	/**
	 * Removes listener for receiving all events.
	 * 
	 * <p>Example
	 * <code>
	 *   t.removeListener(myListener);
	 * </code>
	 * 
	 * @param oL Listener object which implements {@link ITweenListener} interface.
	 */
	public function removeListener(oL:ITweenListener) : Void
	{
		_oEB.removeListener(oL);
	}
	
	/**
	 * Adds listener for specifical event.
	 * 
	 * <p>Example
	 * <code>
	 *   t.addEventListener( TweenFPS.onMotionFinishedEVENT, myListener );
	 * </code>
	 * 
	 * @param t Name of the Event.
	 * @param oL Listener object.
	 */
	public function addEventListener(e:TweenEventType, oL) : Void
	{
		_oEB.addEventListener.apply(_oEB, arguments);
	}
	
	/**
	 * Removes listener for specifical event.
	 * 
	 * <p>Example
	 * <code>
	 *   t.removeEventListener( TweenFPS.onMotionFinishedEVENT, myListener );
	 * </code>
	 * 
	 * @param t Name of the Event.
	 * @param oL Listener object.
	 */
	public function removeEventListener(e:TweenEventType, oL) : Void
	{
		_oEB.removeEventListener(e, oL);
	}
	
	/**
	 * Starts tweening.
	 * 
	 * <p>{@link AbstractTween#start} overridding
	 */
	public function start() : Void
	{
		execute();
	}
	
	/**
	 * Stops tweening.
	 * 
	 * <p>{@link AbstractTween#stop} overridding
	 */
	public function stop() : Void
	{
		super.stop();
		_oEB.broadcastEvent( _eOnMotionStopEvent );
	}
	
	/**
	 * Starts tweening
	 * 
	 * <p>{@link com.bourre.commands.Command} polymorphism.
	 * 
	 * @see com.bourre.commands.Command
	 */
	public function execute( e : IEvent ) : Void
	{
		super.execute();
		_oEB.broadcastEvent( _eOnMotionStartEvent );
	}
	
	/**
	 * Returns the string representation of this instance.
	 * @return the string representation of this instance
	 */
	public function toString() : String 
	{
		return PixlibStringifier.stringify( this );
	}
	
	
	/**
	 *	Implemented to add tween as listener to another tween.
	 */
	public function onMotionFinished() : Void
	{
		execute();
	}

	
	//-------------------------------------------------------------------------
	// Private implementation
	//-------------------------------------------------------------------------
	
	private function _onMotionEnd() : Void
	{
		super._onMotionEnd();
		_oEB.broadcastEvent( _eOnMotionChangedEvent );
		_oEB.broadcastEvent( _eOnMotionFinishedEvent );
	}
	
	private function _onUpdate() : Void
	{
		super._onUpdate();
		_oEB.broadcastEvent( _eOnMotionChangedEvent );
	}
}