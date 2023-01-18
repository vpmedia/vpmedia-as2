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
import com.bourre.events.IEvent;
import com.bourre.log.PixlibDebug;
import com.bourre.log.PixlibStringifier;
import com.bourre.mvc.IModel;

class com.bourre.core.Model
	implements IModel
{
	private var _sID : String;
	private var _oEB : EventBroadcaster;

	private function Model( s : String ) 
	{
		if ( !s )
		{
			PixlibDebug.FATAL( "Invalid arguments for " + this + " constructor." );
		} else
		{
			if ( Model._registerModel( s, this ) )
			{
				_oEB = new EventBroadcaster( this );
				_sID = s;
			}
		}
	}
	
	public function notifyChanged( e : IEvent ) : Void
	{
		_oEB.broadcastEvent( e );
	}
	
	public function getID() : String
	{
		return _sID;
	}
	
	public function release() : Void
	{
		_oEB.removeAllListeners();
		Model._unregister( _sID );
		_sID = null;
	}

	public function addListener( oL ) : Void
	{
		_oEB.addListener(oL);
	}
	
	public function removeListener( oL ) : Void
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
	
	/*
	 * static methods
	 */
	public static function getModel( s : String ) : Model
	{
		if ( !(Model.isRegistered( s )) ) PixlibDebug.ERROR( "Can't find Model instance with '" + s + "' name." );
		return Model._M.get( s );
	}
	
	public static function isRegistered( s : String ) : Boolean
	{
		return Model._M.containsKey( s );
	}
	 
	private static var _M : Map = new Map();
	
	private static function _registerModel( s : String, o : Model ) : Boolean
	{
		if ( Model.isRegistered( s ) )
		{
			PixlibDebug.FATAL( "Model instance is already registered with '" + s + "' name." );
			return false;
		} else
		{
			Model._M.put( s, o );
			return true;
		}
	}
	
	private static  function _unregister( s : String ) : Void
	{
		Model._M.remove( s );
	}
}