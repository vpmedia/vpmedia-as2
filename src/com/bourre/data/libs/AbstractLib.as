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

import com.bourre.commands.CommandManagerFPS;
import com.bourre.commands.CommandManagerMS;
import com.bourre.commands.Delegate;
import com.bourre.data.libs.ILib;
import com.bourre.data.libs.ILibListener;
import com.bourre.data.libs.LibEvent;
import com.bourre.events.EventBroadcaster;
import com.bourre.events.EventType;
import com.bourre.events.IEvent;
import com.bourre.log.PixlibDebug;
import com.bourre.log.PixlibStringifier;

class com.bourre.data.libs.AbstractLib
	implements ILib
{
	private var _oEB:EventBroadcaster;
	private var _e:LibEvent;
	private var _sURL:String;
	private var _sName:String;
	private var _oContent;
	private var _nTimeOut:Number;
	private var _bAntiCache : Boolean;
	private var _sPrefixURL : String;
	
	private var _dOnLoadProgress:Delegate;
	private var _dOnLoadInit:Delegate;
	
	public static var onLoadInitEVENT:EventType = new EventType("onLoadInit");
	public static var onLoadProgressEVENT:EventType = new EventType("onLoadProgress");
	public static var onTimeOutEVENT:EventType = new EventType("onTimeOut");	public static var onErrorEVENT:EventType = new EventType("onError");
	
	private var _nLastBytesLoaded : Number;
	private var _nTime : Number;

	private function AbstractLib()
	{
		_oEB = new EventBroadcaster( this );
		_nTimeOut = 10000;
		
		_dOnLoadProgress = new Delegate(this, _onLoadProgress);
		_dOnLoadInit = new Delegate( this, onLoadInit );
		_sPrefixURL = "";

		initEventSource();
	}
	
	public function initEventSource() : Void
	{
		_e = new LibEvent(null, this);
	}
	
	public function getName() : String
	{
		return _sName;
	}

	public function setName(sName:String) : Void
	{
		_sName = sName;
	}
	
	public function getURL() : String
	{
		return _bAntiCache? _sPrefixURL + _sURL + "?nocache=" + _getTimeStamp() : _sPrefixURL + _sURL;
	}
	
	private function _getTimeStamp() : String
	{
		var d : Date = new Date();
		return String( d.getTime() );
	}
	
	public function setURL(sURL:String) : Void
	{
		_sURL = sURL;
	}
	
	public function getTimeOut() : Number
	{
		return _nTimeOut;
	}
	
	public function setTimeOut( n : Number ) : Void
	{
		_nTimeOut = Math.max( 1000, n );
	}
	
	public function load() : Void
	{
		if (this.getURL())
		{
			_nLastBytesLoaded = 0;
			_nTime = getTimer();
			CommandManagerMS.getInstance().remove(_dOnLoadProgress);
			CommandManagerMS.getInstance().push( _dOnLoadProgress, 50);
		} else
		{
			PixlibDebug.ERROR( this + ".load() can't retrieve file url." );
		}
	}
	
	public function execute( e : IEvent ) : Void
	{
		load();
	}
	
	private function _onLoadProgress() : Void
	{
		_checkTimeOut( getBytesLoaded(), getTimer() );
		
		if ( getBytesLoaded() > 4 && getBytesLoaded() == getBytesTotal())
		{
			CommandManagerMS.getInstance().remove(_dOnLoadProgress);
			CommandManagerFPS.getInstance().delay(_dOnLoadInit);
		} else
		{
			fireEventType(onLoadProgressEVENT);
		}
	}
	
	private function _checkTimeOut( nLastBytesLoaded:Number, nTime : Number ) : Void 
	{
		if ( nLastBytesLoaded != _nLastBytesLoaded)
		{
			_nLastBytesLoaded = nLastBytesLoaded;
			_nTime = nTime;
		}
		else if ( nTime - _nTime  > _nTimeOut)
		{
			fireEventType( AbstractLib.onTimeOutEVENT );
			release();
			PixlibDebug.ERROR( this + " load timeout with url : '" + this.getURL() + "'." );
		}
	}
	
	public function fireEvent(e:LibEvent) : Void
	{
		_oEB.broadcastEvent(e);
	}
	
	public function fireEventType(e:EventType) : Void
	{
		_e.setType(e);
		_oEB.broadcastEvent(_e);
	}
	
	public function onLoadInit() : Void
	{
		fireEventType(onLoadProgressEVENT);
		fireEventType(onLoadInitEVENT);
	}
	
	public function getBytesLoaded() : Number
	{
		return _oContent.getBytesLoaded();
	}
	
	public function getBytesTotal() : Number
	{
		return _oContent.getBytesTotal();
	}
	
	public function getPerCent() : Number
	{
		var n:Number = Math.min(100, Math.ceil( getBytesLoaded() / ( getBytesTotal() / 100 ) ));
		return (isNaN(n)) ? 0 : n;
	}
	
	public function getContent()
	{
		return _oContent;
	}
	
	public function setContent(o) : Void
	{
		_oContent = o;
	}
	
	public function addListener(oL:ILibListener) : Void
	{
		_oEB.addListener(oL);
	}
	
	public function removeListener(oL:ILibListener) : Void
	{
		_oEB.removeListener(oL);
	}
	
	public function addEventListener(e:EventType, oL, f:Function) : Void
	{
		_oEB.addEventListener.apply(_oEB, arguments);
	}
	
	public function removeEventListener(e:EventType, oL) : Void
	{
		_oEB.removeEventListener(e, oL);
	}
	
	public function release() : Void
	{
		CommandManagerMS.getInstance().remove(_dOnLoadProgress);
		CommandManagerFPS.getInstance().remove(_dOnLoadInit);
	}
	
	public function setAntiCache( b : Boolean ) : Void
	{
		_bAntiCache = b;
	}
	
	public function prefixURL( sURL : String ) : Void
	{
		_sPrefixURL = sURL;
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