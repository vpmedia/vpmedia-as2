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
import com.bourre.transitions.FPSBeacon;
import com.bourre.transitions.IBasicTween;
import com.bourre.transitions.IFrameListener;

class com.bourre.transitions.BasicMultiTweenFPS 
	extends AbstractMultiTween
	implements IBasicTween, IFrameListener
{
	private var _nCurrentFPS:Number;
	
	public function BasicMultiTweenFPS( t, 
										p, 
										e : Array, 
										n : Number, 
										s : Array, 
										f : Function )
	{
		super( t, p, e, n, s, f );
		_oBeacon = FPSBeacon.getInstance();
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
		_nCurrentFPS = 0;
		super.execute();
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
		return ++_nCurrentFPS >= _nRate;
	}

	private function _update( nS : Number, nE : Number ) : Number
	{
		return _fE( _nCurrentFPS, nS, nE - nS, _nRate );
	}
}