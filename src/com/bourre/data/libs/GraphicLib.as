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

import com.bourre.core.HashCodeFactory;
import com.bourre.data.libs.AbstractLib;
import com.bourre.data.libs.GraphicLibEvent;
import com.bourre.data.libs.GraphicLibLocator;
import com.bourre.events.EventType;
import com.bourre.log.PixlibDebug;
import com.bourre.log.PixlibStringifier;

class com.bourre.data.libs.GraphicLib extends AbstractLib
{
	private var _mcContainer:MovieClip;
	private var _mcLib:MovieClip;
	private var _bAutoShow:Boolean;
	private var _bMustUnregister : Boolean;
	
	public static var onLoadInitEVENT:EventType = AbstractLib.onLoadInitEVENT;
	public static var onLoadProgressEVENT:EventType = AbstractLib.onLoadProgressEVENT;
	public static var onTimeOutEVENT:EventType = AbstractLib.onTimeOutEVENT;
	
	public function GraphicLib( mcTarget:MovieClip, nDepth:Number, bAutoShow:Boolean )
	{
		super();
		
		_mcContainer = getContainer( mcTarget, nDepth );
		
		_bAutoShow = (bAutoShow == undefined) ? true : bAutoShow;
		_bMustUnregister = false;
	}
	
	public function getContainer( mcTarget : MovieClip, nDepth : Number ) : MovieClip
	{
		if (mcTarget == undefined) PixlibDebug.ERROR( this + " MovieClip target is undefined." );
		if (nDepth == undefined) nDepth = 1;
		
		var mc : MovieClip = mcTarget.createEmptyMovieClip("__c" + HashCodeFactory.getNextName(), nDepth);
		HashCodeFactory.getKey( _mcContainer );
		return mc;
	}
	
	public function initEventSource() : Void
	{
		_e = new GraphicLibEvent(null, this);
	}
	
	public function load(sURL:String) : Void
	{
		if (sURL != undefined) setURL( sURL );
		
		release();
		setContent( _mcContainer.createEmptyMovieClip("__mc", 1) );
		getContent().loadMovie( super.getURL() );
		hide();
		
		super.load();
	}
	
	public function onLoadInit() : Void
	{
		if (_sName) 
		{
			if (!(GraphicLibLocator.getInstance().isRegistered(_sName)))
			{
				_bMustUnregister = true;
				GraphicLibLocator.getInstance().register( _sName, this );
			} else
			{
				_bMustUnregister = false;
				PixlibDebug.ERROR( 	this + " can't be registered to " + GraphicLibLocator.getInstance() 
									+ " with '" + _sName + "' name. This name already exists." );
			}
		}
		
		super.onLoadInit();
		if (_bAutoShow) show();
	}
	
	public function show() : Void
	{
		_mcContainer._visible = true;
	}
	
	public function hide() : Void
	{
		_mcContainer._visible = false;
	}
	
	public function isVisible() : Boolean
	{
		return _mcContainer._visible;
	}
	
	public function set autoShow(b:Boolean) : Void
	{
		_bAutoShow = b;
	}
	
	public function release() : Void
	{
		getContent().removeMovieClip();
		_mcContainer._visible = _bAutoShow;
		
		if ( _bMustUnregister ) 
		{
			GraphicLibLocator.getInstance().unregister(_sName);
			_bMustUnregister = false;
		}

		super.release();
	}

	public function getContent() : MovieClip
	{
		return super.getContent();
	}
	
	public function setContent(mc:MovieClip) : Void
	{
		super.setContent( mc );
	}
	
	public function getView() : MovieClip
	{
		return super.getContent();
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