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
 * {@code BasicTweenMS} is the basic class for time synchronisation tweening.
 * 
 * <p>Concrete implementation of {@link AbstractTween} class.
 * 
 * <p>Example
 * <code>
 *   var t : BasicTweenFPS = new BasicTweenMS(mc, '_alpha', 0, 2000, 100);
 *   t.start();
 * </code>
 * 
 * @author Francis Bourre
 * @version 1.0
 */
import com.bourre.log.PixlibStringifier;
import com.bourre.transitions.AbstractTween;
import com.bourre.transitions.IFrameListener;
import com.bourre.transitions.MSBeacon;

class com.bourre.transitions.BasicTweenMS extends AbstractTween
	implements IFrameListener
{
	//-------------------------------------------------------------------------
	// Private properties
	//-------------------------------------------------------------------------
	
	private var _nT:Number;
	private var _nM:Number;
	
	
	//-------------------------------------------------------------------------
	// Public API
	//-------------------------------------------------------------------------
	
	/**
	 * Constructs a new {@code BasicTweenMS} instance.
	 * 
	 * @param oT 	Object which the Tween targets.
	 * @param sP 	Setter (method or property).
	 * @param nE 	Ending value of property.
	 * @param nRate Length of time of the motion in milliseconds.
	 * @param nS 	Starting value of property (optional).
	 * @param fE 	Easing function (optional).
	*/
	public function BasicTweenMS(oT, sP, nE:Number, nRate:Number, nS:Number, fE:Function)
	{
		super( oT, sP, nE, nRate, nS, fE );
		_oBeacon = MSBeacon.getInstance();
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
	 * Start tweening.
	 * 
	 * <p>{@link AbstractTween#execute} overridding.
	 * 
	 * <p>{@link com.bourre.commands.Command} polymorphism.
	 */
	public function execute() : Void
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
	
	
	//-------------------------------------------------------------------------
	// Private implementation
	//-------------------------------------------------------------------------
	
	private function _isMotionFinished() : Boolean
	{
		return getTimer() - _nT >= _nRate;
	}
	
	private function _onUpdate() : Void
	{
		_oSetter.setValue( _fE(getTimer() - _nT, _nS, _nE - _nS, _nRate) );
	}
}