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
 
import com.bourre.log.PixlibStringifier;
import com.bourre.medias.video.VideoDisplay;
import com.bourre.transitions.AbstractTween;
import com.bourre.transitions.FLVBeacon;
import com.bourre.transitions.IFrameListener;

class com.bourre.transitions.BasicTweenFLV 
	extends AbstractTween
	implements IFrameListener
{

	private var _nT : Number;
	private var _nVO : Number;
	private var _vd : VideoDisplay;

	public function BasicTweenFLV( vd : VideoDisplay, offset : Number, oT, sP, nE:Number, nRate:Number, nS:Number, fE:Function)
	{
		super( oT, sP, nE, nRate, nS, fE );
		
		setVideoDisplay( vd );
		setStartVideoOffset( offset );
	}

	/**
	 * Returns the string representation of this instance.
	 * @return the string representation of this instance
	 */
	public function toString() : String 
	{
		return PixlibStringifier.stringify( this );
	}

	public function execute() : Void
	{
		_nT = _nT ? _nT : FLVBeacon( _oBeacon ).getVideoDisplay().getPlayheadTime() || 0;
		super.execute();
	}
	
	public function setVideoDisplay( vd : VideoDisplay ) : FLVBeacon
	{
		var flvBeacon : FLVBeacon = new FLVBeacon( vd );
		setFLVBeacon( flvBeacon );
		return flvBeacon;
	}
	
	public function getFLVBeacon() : FLVBeacon
	{
		return FLVBeacon(_oBeacon);
	}
	
	public function setFLVBeacon( flvBeacon : FLVBeacon ) : Void
	{
		_oBeacon = flvBeacon;
		onChangeVideoDisplay();
	}
	
	public function setStartVideoOffset( n : Number ) : Void
	{
		_nT = n;
	}
	
	public function onChangeVideoDisplay() : Void
	{
		_vd = getFLVBeacon().getVideoDisplay();
	}

	private function _isMotionFinished() : Boolean
	{
		return  _vd.getPlayheadTime() - _nT >= _nRate;
	}
	
	private function _onUpdate() : Void
	{
		var time : Number = _vd.getPlayheadTime();
		if(time>_nT) _oSetter.setValue( _fE( time - _nT, _nS, _nE - _nS, _nRate) );
	}
}