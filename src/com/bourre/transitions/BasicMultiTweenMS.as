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
 * @author Francis Bourre
 * @version 1.0
 */

import com.bourre.events.IEvent;
import com.bourre.log.PixlibStringifier;
import com.bourre.transitions.AbstractMultiTween;
import com.bourre.transitions.IBasicTween;
import com.bourre.transitions.IFrameListener;
import com.bourre.transitions.MSBeacon;

class com.bourre.transitions.BasicMultiTweenMS 
	extends AbstractMultiTween
	implements IBasicTween, IFrameListener
{
	private var _nT:Number;
	private var _nM:Number;
	
	/**
	 * Constructs a new {@code MultiTweenMS} instance.
	 * 
	 * <p>Example
	 * <code>
	 *   var t0:BasicMultiTweenMS = new BasicMultiTweenMS( mc, ["_x", "_y", "_alpha"], [600, 500, 0], 1200 );
	 *   var t1:BasicMultiTweenMS = new BasicMultiTweenMS( [mc0, mc1, mc2], ["_x", "_y", "_alpha"], [600, 500, 0], 1200, [0, 0, 100] );
	 *   var t2:BasicMultiTweenMS = new BasicMultiTweenMS( this, "arrayProperty", [600, 500, 0], 1200 );
	 * </code>
	 * 
	 * @param t 	Object which the Tween targets.
	 * @param p 	Setter (method or property).
	 * @param e 	Ending value of property.
	 * @param n 	Length of time of the motion in frames.
	 * @param s 	(optional) Starting value of property.
	 * @param f 	(optional) Easing function.
	 */
	public function BasicMultiTweenMS(	t, 
										p, 
										e : Array, 
										n : Number, 
										s : Array, 
										f : Function )
	{
		super( t, p, e, n, s, f );
		_oBeacon = MSBeacon.getInstance();
	}
	
	/**
	 * Start tweening.
	 * 
	 * <p>{@link AbstractTween#execute} overridding.
	 * 
	 * <p>{@link com.bourre.commands.Command} polymorphism.
	 */
	public function execute( e : IEvent ) : Void
	{
		_nT = getTimer();
		super.execute();	
	}
	
	/**
	 * Plays tweening from current property's value without reinitializing.
	 * 
	 * <p>{@link AbstractTween#resume} overridding.
	 */
	public function resume() : Void
	{
		_nT = getTimer() - (_nM - _nT);
		super.resume();
	}
	
	/**
	 * Stops tweening.
	 * 
	 * <p>{@link AbstractTween#stop} overridding.
	 */
	public function stop() : Void
	{
		super.stop();
		_nM = getTimer();
	}
	
	/**
	 * Returns the string representation of this instance.
	 * @return the string representation of this instance
	 */
	public function toString() : String 
	{
		return PixlibStringifier.stringify( this );
	}
	
	//
	private function _isMotionFinished() : Boolean
	{
		return getTimer() - _nT >= _nRate;
	}

	private function _update( nS : Number, nE : Number ) : Number
	{
		return _fE( getTimer() - _nT, nS, nE - nS, _nRate );
	}
}