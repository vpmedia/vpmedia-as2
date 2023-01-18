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
 * {@code AbstractTween} is the base class for all concrete tween class implementations.
 * 
 * <p>{@code AbstractTween} is an abstract class.
 * Take a look at {@link com.bourre.transitions} package to see all concrete
 * implementations.
 * 
 * <p>Example
 * <code>
 *   var t : BasicTweenFPS = new BasicTweenFPS(mc, '_alpha', 0, 30, 100);
 * </code>
 * 
 * @author Francis Bourre
 * @version 1.0
 */
 
import com.bourre.core.AccessorFactory;
import com.bourre.core.IAccessor;
import com.bourre.core.PropertyAccessor;
import com.bourre.events.IEvent;
import com.bourre.log.PixlibDebug;
import com.bourre.log.PixlibStringifier;
import com.bourre.transitions.IBasicTween;
import com.bourre.transitions.IFrameBeacon;
import com.bourre.transitions.IFrameListener;

class com.bourre.transitions.AbstractTween
	implements IBasicTween, IFrameListener
{	
	//-------------------------------------------------------------------------
	// Private properties
	//-------------------------------------------------------------------------
	
	private var _nS:Number, _nE:Number, _nRS:Number, _nRE:Number;
	private var _nRate:Number;
	private var _fE:Function;
	private var _bP:Boolean;
	
	private var _oSetter:IAccessor;
	
	// virtual members
	private var _isMotionFinished:Function;
	private var _onUpdate:Function;
	private var _oBeacon:IFrameBeacon;
	
	
	//-------------------------------------------------------------------------
	// Private implementation
	//-------------------------------------------------------------------------
	
	/**
	 * Constructs a new {@code AbstractTween} instance.
	 * 
	 * <p>Constructor is private, use concrete implementation classes
	 * to build new Tween.
	 * 
	 * @param oT 	Object which the Tween targets.
	 * @param sP 	Setter (method or property).
	 * @param nE 	Ending value of property.
	 * @param nRate Length of time of the motion in frames.
	 * @param nS 	Starting value of property (optional).
	 * @param fE 	Easing function (optional).
	*/
	private function AbstractTween(oT, sP, nE:Number, nRate:Number, nS:Number, fE:Function)
	{
		_buildAccessor( oT, sP, (nS!=undefined)? nS : oT[sP] );
		
		_nRE = nE;
		_nRate = nRate;
		setEasing(fE);
		_bP = false;
	}
	
	/**
	 * Calculates and returns a new value without easing effect.
	 * 
	 * @return {@code Number} result
	 */
	public static function noEasing(t:Number, b:Number, c:Number, d:Number) : Number 
	{
		return c*t/d + b;
	}
	
	/**
	 * Don't use, overwrite or override this method.
	 * 
	 * <p>That's the public callback of {@link com.bourre.transitions.FBeacon} used
	 * internally to calculate tween progression.
	 */
	public function onEnterFrame() : Void
	{
		if (_isMotionFinished() )
		{
			_onMotionEnd();
		} else
		{
			_onUpdate();
		}
	}
		
	/**
	 * Defines easing function for tween effect.
	 * 
	 * <p>Example
	 * <code>
	 *   var t.setEasing(mx.transitions.easing.Elastic.easeOut);</em>
	 * </code>
	 * 
	 * @param f Easing {@code Function}
	 */
	public function setEasing(f:Function) : Void
	{
		_fE = (f != undefined) ?  f : AbstractTween.noEasing;
	}
	
	/**
	 * Returns easing function.
	 * 
	 * @return Easing {@code Function}
	 */
	public function getEasing() : Function
	{
		return _fE;
	}
	
	/**
	 * Returns tween duration.
	 * 
	 * @return Number
	 */
	public function getDuration() : Number
	{
		return _nRate;
	}
	
	/**
	 * Starts tweening.
	 */
	public function start() : Void
	{
		execute();
	}
	
	public function yoyo() : Void
	{
		stop();
		
		setEndValue( _nRS );
		setStartValue( _oSetter.getValue() );
		
		start();
	}
	
	/**
	 * Stops tweening.
	 */
	public function stop() : Void
	{
		_oBeacon.removeFrameListener(this);
		_bP = false;
	}
	
	/**
	 * Plays tweening from current property's value without reinitializing.
	 */
	public function resume() : Void
	{
		_bP = true;
		_oBeacon.addFrameListener(this);
	}
	
	/**
	 * Start tweening.
	 * 
	 * <p>{@link com.bourre.commands.Command} polymorphism.
	 * 
	 * @see com.bourre.commands.Command
	 */
	public function execute( e : IEvent ) : Void
	{
		if ( isNaN(_nRS) ) 
		{
			PixlibDebug.FATAL( this + " has no start value." );
			
		} else
		{
			_nS = _nRS;
			_oSetter.setValue( _nS );
			_nE = _nRE;
			_bP = true;
			_oBeacon.addFrameListener(this);
		}
	}
	
	/**
	 * Returns tweening target.
	 * 
	 * @return tweening target
	 */
	public function getTarget()
	{
		return _oSetter.getTarget();
	}
	
	/**
	 * @param o Object which the Tween targets.
	 */
	public function setTarget( o ) : Void
	{
		if ( isPlaying() )
		{
			PixlibDebug.WARN( this + ".setTarget() invalid call while playing." );
		} else
		{
			_buildAccessor( o, _oSetter.getSetterHelper(), o[PropertyAccessor(_oSetter).getProperty()] );
		}
	}
	
	/**
	 * Returns property affected by the tween
	 * 
	 * @return {@code String} property name
	 */
	public function getProperty() : String
	{
		return PropertyAccessor(_oSetter).getProperty();
	}
	
	/**
	 * @param p Setter (method or property).
	 */
	public function setProperty( p ) : Void
	{
		if ( isPlaying() )
		{
			PixlibDebug.WARN( this + ".setProperty() invalid call while playing." );
		} else
		{
			var target = _oSetter.getTarget();
			_buildAccessor( target, p,  target[p] );
		}
	}		
	
	/**
	 * Set start value to tween from.
	 * 
	 * <p>Example
	 * <code>
	 *   t.setStartValue( 0 );</em>
	 * </code>
	 * 
	 * @param n Number
	 */
	public function setStartValue( n : Number ) : Void
	{
		_nRS = n;
	}
	
	/**
	 * Set end value to tween to.
	 * 
	 * <p>Example
	 * <code>
	 *   t.setEndValue( 100 );</em>
	 * </code>
	 * 
	 * @param n Number
	 */
	public function setEndValue( n : Number ) : Void
	{
		_nRE = n;
	}
	
	/**
	 * Returns true if the tween is currently playing.
	 * 
	 * @return {@code Boolean}
	 */
	public function isPlaying() : Boolean
	{
		return _bP;	
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
	 * Set tween duration.
	 * 
	 * <p>Example
	 * <code>
	 *   t.setDuration( 31 );</em>
	 * </code>
	 * 
	 * @param n Number
	 */
	public function setDuration( n : Number ) : Void
	{
		_nRate = n;
	}
	
	
	//-------------------------------------------------------------------------
	// Private implementation
	//-------------------------------------------------------------------------
	
	private function _buildAccessor( o, p, nS : Number ) : Void
	{
		_oSetter = AccessorFactory.getInstance(o, p);
		if (!isNaN(nS)) _nRS = nS;
	}
	
	private function _onMotionEnd() : Void
	{
		_oBeacon.removeFrameListener(this);
		_oSetter.setValue( _nE );
	}
}