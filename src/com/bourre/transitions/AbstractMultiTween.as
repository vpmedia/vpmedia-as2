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
 * {@code AbstractMultiTween} is the base class for all concrete multitween classes implementation.
 * 
 * <p>{@code AbstractMultiTween} is an abstract class.
 * Take a look at {@link com.bourre.transitions} package to see all concrete
 * implementation.
 * 
 * @author Francis Bourre
 * @version 1.0
 */
 
import com.bourre.core.AccessorFactory;
import com.bourre.core.IAccessor;
import com.bourre.events.IEvent;
import com.bourre.log.PixlibDebug;
import com.bourre.log.PixlibStringifier;
import com.bourre.transitions.AbstractTween;
import com.bourre.transitions.IBasicTween;
import com.bourre.transitions.IFrameBeacon;
import com.bourre.transitions.IFrameListener;

class com.bourre.transitions.AbstractMultiTween 
	implements IBasicTween, IFrameListener
{
	private var _nCurrentFPS:Number;
	private var _aS : Array, _aE : Array, _aRS:Array, _aRE:Array;
	private var _nRate:Number;
	private var _fE:Function;
	private var _bP:Boolean;
	private var _oSetter:IAccessor;
	
	// virtual members
	private var _isMotionFinished:Function;
	private var _update:Function;
	private var _oBeacon:IFrameBeacon;
	
	/**
	 * Constructs a new {@code AbstractMultiTween} instance.
	 * 
	 * <p>Constructor is private, use concrete implementation classes
	 * to build new MultiTween.
	 * 
	 * @param t 	Object or Array of Objects targeted by the Tween.
	 * @param p 	Method, property or Array of methods or properties to use as a setter.
	 * @param e 	Array of ending values.
	 * @param n 	Length of time of the motion.
	 * @param s 	(optional) Array of starting values.
	 * @param f 	(optional) Easing function.
	 */
	private function AbstractMultiTween(	t,
											p, 
											e : Array, 
											n : Number, 
											s : Array, 
											f : Function )
	{
		_buildAccessor( t, p, s );
		
		_aRE = e.concat();
		_nRate = n;
		setEasing( f );
		_bP = false;
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
		if ( _aRS.length > 0 ) 
		{
			_aS = _aRS.concat();
			_oSetter.setValue( _aS );
			_aE = _aRE.concat();
			_bP = true;
			_oBeacon.addFrameListener(this);
		} else
		{
			PixlibDebug.FATAL( this + " has no start value." );
		}		
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
	 * Starts tweening.
	 */
	public function start() : Void
	{
		execute();
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
	 * Don't use, overwrite or override this method.
	 * 
	 * <p>That's the public callback of {@link com.bourre.transitions.FBeacon} used
	 * internally to calculate tween progression.
	 */
	public function onEnterFrame() : Void
	{
		if ( _isMotionFinished() )
		{
			_onMotionEnd();
		} else
		{
			_onUpdate();
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
	
	public function yoyo() : Void
	{
		stop();
		
		_aRE = _aRS;
		_buildAccessor( getTarget(), _oSetter.getSetterHelper(), _oSetter.getValue() );
		
		start();
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
	private function _buildAccessor( o, p, aS : Array ) : Void
	{
		_oSetter = AccessorFactory.getInstance( o, p );
		_aRS = new Array();
		var aV : Array;
		
		var isMultiAccessor : Boolean = ( p instanceof Array && isNaN(p[0]) );
		if ( isMultiAccessor )
		{
			aV = _oSetter.getValue();
			
			var l : Number = aV.length; 
			for (var i : Number = 0; i < l; i++ ) 
			{
				var v = aS[i];
				
				if ( v != null )
				{
					_aRS[i] = v;
					
				} else
				{
					v = aV[i];
					if ( v != null )
					{
						_aRS[i] = v;
					} else
					{
						PixlibDebug.FATAL( this + " has no start value at index " + i );
					}
				}
				
			}
		} else
		{
			if ( o[p].length > 0 )
			{
				_aRS = o[p].concat();

			}else if ( aS.length > 0 )
			{
				_aRS = aS.concat();
			}
		}

	}
	
	private function _onMotionEnd() : Void
	{
		_oBeacon.removeFrameListener( this );
		_oSetter.setValue( _aE );
	}
	
	private function _onUpdate() : Void
	{
		var a : Array = new Array();
		var l : Number = _aE.length;
		for ( var i : Number= 0; i < l; i++ ) a.push( _update( _aS[i], _aE[i] ) );
		_oSetter.setValue( a );
	}
}