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
 
import com.bourre.data.collections.Map;
import com.bourre.events.EventBroadcaster;
import com.bourre.events.EventType;
import com.bourre.log.PixlibDebug;
import com.bourre.log.PixlibStringifier;

class com.bourre.visual.ViewHelper
{
	private static var _a : Map = new Map();
	
	public var view;
	private var _sName:String;
	private var _oEB:EventBroadcaster;
	
	public static function getViewHelper( sName:String ) : ViewHelper
	{
		if (!ViewHelper._a.containsKey( sName ) ) 
		{
			PixlibDebug.ERROR( "Can't find ViewHelper instance with '" + sName + "' name." );
		}
		return _a.get( sName );
	}
	
	public static function isRegistered( sName:String ) : Boolean
	{
		return ViewHelper._a.containsKey( sName );
	}
	
	private function ViewHelper( view, name : String ) 
	{
		_oEB = new EventBroadcaster( this );
		
		if (view && name.length > 0 )
		{
			this.view = view;
			_setName( name );
		} else
		{
			PixlibDebug.ERROR( "Invalid arguments for " + this + " constructor." );
		}
	}

	private function _setName( name:String ) : Void
	{
		ViewHelper._unregister( name );
		
		_sName = name;
		ViewHelper._register( name, this );
	}
	
	public function getName() : String
	{
		return _sName;
	}
	
	public function release() : Void
	{
		ViewHelper._unregister( _sName );
		delete _sName;
	}
	
	//
	private static function _register( sName:String, oHelper:ViewHelper ) : Void
	{
		if ( ViewHelper._a.containsKey( sName ) )
		{
			PixlibDebug.ERROR( "ViewHelper instance is already registered with '" + sName + "' name." );
			return;
		}
		
		ViewHelper._a.put( sName, oHelper );
	}
	
	private static function _unregister( sName:String ) : Void
	{
		ViewHelper._a.remove( sName );
	}
	
	//
	public function addListener( oL ) : Void
	{
		_oEB.addListener(oL);
	}
	
	public function removeListener( oL ) : Void
	{
		_oEB.removeListener(oL);
	}
	
	public function addEventListener(e:EventType, oL, f:Function)
	{
		_oEB.addEventListener.apply(_oEB, arguments);
	}
	
	public function removeEventListener(e:EventType, oL)
	{
		_oEB.removeEventListener(e, oL);
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