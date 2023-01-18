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
 
import com.bourre.core.ILocator;
import com.bourre.data.collections.Map;
import com.bourre.data.libs.GraphicLib;
import com.bourre.data.libs.GraphicLibLocatorEvent;
import com.bourre.data.libs.IGraphicLibLocatorListener;
import com.bourre.events.EventBroadcaster;
import com.bourre.events.EventType;
import com.bourre.log.PixlibDebug;
import com.bourre.log.PixlibStringifier;

class com.bourre.data.libs.GraphicLibLocator 
	implements ILocator
{
	private static var _oI : GraphicLibLocator;
	private var _a : Map;
	private var _oEB : EventBroadcaster;
	
	public static var onRegisterGraphicLib : EventType = new EventType("onRegisterGraphicLib");	public static var onUnregisterGraphicLib : EventType = new EventType("onUnregisterGraphicLib");
	
	private function GraphicLibLocator( )
	{
		_a = new Map();
		_oEB = new EventBroadcaster( this );
	}
	
	private static function _init() : GraphicLibLocator
	{
		_oI = new GraphicLibLocator();
		return _oI;
	}
	
	public static function getInstance() : GraphicLibLocator
	{
		return (_oI != undefined) ? _oI : GraphicLibLocator._init();
	}
	
	public function isRegistered( sName : String ) : Boolean
	{
		return _a.containsKey( sName );
	}
	
	public function register( sName : String, gl:GraphicLib ) : Boolean
	{
		if (_a.containsKey( sName ))
		{
			PixlibDebug.ERROR( "GraphicLib instance is already registered with '" + sName + "' name in " + this );
			return false;
		} else
		{
			_a.put(sName, gl);
			_oEB.broadcastEvent( new GraphicLibLocatorEvent( GraphicLibLocator.onRegisterGraphicLib, sName, gl ) );
			return true;
		}
	}
	
	public function unregister( sName : String ) : Boolean
	{
		if (_a.containsKey( sName ))
		{
			_a.remove( sName );
			_oEB.broadcastEvent( new GraphicLibLocatorEvent( GraphicLibLocator.onUnregisterGraphicLib, sName, null ) );
			return true;
			
		} else
		{
			return false;
		}
	}
	
	public function locate( sName : String )
	{
		if (!_a.containsKey( sName )) 
		{
			PixlibDebug.ERROR( "Can't find GraphicLib instance with '" + sName + "' name in " + this );
		}
		return _a.get( sName );
	}
	
	public function getGraphicLib( sName : String ) : GraphicLib
	{
		return GraphicLib( locate(sName) );
	}
	
	public function addListener( oL : IGraphicLibLocatorListener ) : Void
	{
		_oEB.addListener( oL );
	}
	
	public function removeListener( oL : IGraphicLibLocatorListener ) : Void
	{
		_oEB.removeListener( oL );
	}
	
	public function addEventListener( e : EventType, oL, f : Function ) : Void
	{
		_oEB.addEventListener.apply( _oEB, arguments );
	}
	
	public function removeEventListener( e : EventType, oL ) : Void
	{
		_oEB.removeEventListener( e, oL );
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