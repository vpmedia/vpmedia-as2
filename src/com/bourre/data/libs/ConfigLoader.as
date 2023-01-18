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

import com.bourre.commands.CommandManagerMS;
import com.bourre.commands.Delegate;
import com.bourre.data.libs.AbstractLib;
import com.bourre.data.libs.Config;
import com.bourre.data.libs.ConfigLoaderEvent;
import com.bourre.data.libs.ILib;
import com.bourre.data.libs.ILibListener;
import com.bourre.data.libs.IXMLToObjectDeserializer;
import com.bourre.data.libs.LibEvent;
import com.bourre.data.libs.XMLToObject;
import com.bourre.data.libs.XMLToObjectEvent;
import com.bourre.events.EventType;
import com.bourre.log.PixlibDebug;
import com.bourre.log.PixlibStringifier;

class com.bourre.data.libs.ConfigLoader 
	extends AbstractLib 
	implements ILibListener
{
	private var _oConfig : Object;
	
	public static var onLoadInitEVENT:EventType = AbstractLib.onLoadInitEVENT;
	public static var onLoadProgressEVENT:EventType = AbstractLib.onLoadProgressEVENT;
	public static var onTimeOutEVENT:EventType = AbstractLib.onTimeOutEVENT;
	
	public static var DEBUG_IS_ON : Boolean = true;
	public static var INIT_TIME_DELAY : Number = 0;
	
	public function ConfigLoader( config : Object, deserializer:IXMLToObjectDeserializer ) 
	{
		super();
		
		_oConfig = config? config : Config.getInstance();
		setContent( new XMLToObject( _oConfig, deserializer ) );
		
		setURL( "config.xml" );
	}
	
	public function setDeserializer ( deserializer:IXMLToObjectDeserializer ) : Void
	{
		XMLToObject(getContent()).setDeserializer( deserializer );
	}
	
	public function getDeserializer () : IXMLToObjectDeserializer 
	{
		return XMLToObject(getContent()).getDeserializer();
	}
	
	public function initEventSource() : Void
	{
		_e = new ConfigLoaderEvent( null, this );
	}
	
	public function prefixURL( sURL : String ) : Void
	{
		ILib( getContent() ).prefixURL( sURL );
	}
	
	public function setURL( sURL : String ) : Void
	{
		getContent().setURL( sURL );
	}
	
	public function getURL() : String
	{
		return getContent().getURL();
	}
	
	public function getConfig() : Object
	{
		return _oConfig;
	}
	
	public function load( sURL:String ) : Void
	{
		if (sURL) setURL(sURL);
		
		getContent().addListener( this );
		getContent().load( sURL );
	}
	
	/**
	 * Returns the string representation of this instance.
	 * @return the string representation of this instance
	 */
	public function toString() : String 
	{
		return PixlibStringifier.stringify( this );
	}
	
	/*
	 * ILibListener callbacks
	 */
	public function onLoadInit( e:LibEvent ) : Void
	{
		PixlibDebug.INFO( "Config has been loaded" );
		
		if ( ConfigLoader.DEBUG_IS_ON ) ConfigLoader.protectConfigObject( XMLToObjectEvent(e).getObject() );
		
		if ( ConfigLoader.INIT_TIME_DELAY > 0 )
		{
			CommandManagerMS.getInstance().delay( new Delegate(this, fireEventType, ConfigLoader.onLoadInitEVENT), ConfigLoader.INIT_TIME_DELAY );
		} else
		{
			fireEventType( ConfigLoader.onLoadInitEVENT );
		}
	}
	
	public function onLoadProgress( e:LibEvent ) : Void
	{
		fireEventType( ConfigLoader.onLoadProgressEVENT );
	}

	public function onTimeOut( e:LibEvent ) : Void
	{
		if ( ConfigLoader.DEBUG_IS_ON ) ConfigLoader.protectConfigObject( XMLToObjectEvent(e).getObject() );
		fireEventType( ConfigLoader.onTimeOutEVENT );
	}
	
	/**
	 * 
	 */
	public static function protectConfigObject( o ) : Void
	{
		if (o == undefined) o = Config.getInstance();
		if ( !(o.hasOwnProperty("__KEY")) ) o.__KEY = null;		if ( !(o.hasOwnProperty("__fullyQualifiedClassName")) ) o.__fullyQualifiedClassName = null;
		
		o.__resolve = function( s : String ) : String
		{
			PixlibDebug.ERROR( s + "' property is undefined in " + PixlibStringifier.stringify(o) );
			return "";
		};
		_global.ASSetPropFlags(o, "__resolve", 7, 1);
	}
	
	public static function unprotectConfigObject( o ) : Void
	{
		if (o == undefined) o = Config.getInstance();
		_global.ASSetPropFlags(o, "__resolve", 0, 7);
		delete o.__resolve;
	}
}