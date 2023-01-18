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
 * {@code BasicTweenFPS} is the basic class for FPS synchronisation tweening.
 * 
 * <p>Concrete implementation of {@link AbstractTween} class.
 * 
 * <p>If your animation framerate is 31 fps, tweening progression is calculatated
 * 31 times per second.
 * 
 * <p>Example
 * <code>
 *   var t : BasicTweenFPS = new BasicTweenFPS(mc, '_alpha', 0, 30, 100);
 *   t.start();
 * </code>
 * 
 * @author Francis Bourre
 * @version 1.0
 */
 
import com.bourre.log.PixlibStringifier;
import com.bourre.transitions.AbstractTween;
import com.bourre.transitions.FPSBeacon;
import com.bourre.transitions.IFrameListener;

class com.bourre.transitions.BasicTweenFPS extends AbstractTween
	implements IFrameListener
{
	//-------------------------------------------------------------------------
	// Private properties
	//-------------------------------------------------------------------------
	
	private var _nCurrentFPS:Number;

	
	//-------------------------------------------------------------------------
	// Public API
	//-------------------------------------------------------------------------
	
	/**
	 * Constructs a new {@code BasicTweenFPS} instance.
	 * 
	 * @param oT 	Object which the Tween targets.
	 * @param sP 	Setter (method or property).
	 * @param nE 	Ending value of property.
	 * @param nRate Length of time of the motion in frames.
	 * @param nS 	(optional) Starting value of property.
	 * @param fE 	(optional) Easing function .
	*/
	public function BasicTweenFPS(oT, sP, nE:Number, nRate:Number, nS:Number, fE:Function)
	{
		super( oT, sP, nE, nRate, nS, fE );
		_oBeacon = FPSBeacon.getInstance();
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
		_nCurrentFPS = 0;
		super.execute();		
	}
	
	//-------------------------------------------------------------------------
	// Private implementation
	//-------------------------------------------------------------------------
	
	private function _isMotionFinished() : Boolean
	{
		return ++_nCurrentFPS >= _nRate;
	}
	
	private function _onUpdate() : Void
	{
		_oSetter.setValue( _fE(_nCurrentFPS, _nS, _nE - _nS, _nRate) );
	}
}