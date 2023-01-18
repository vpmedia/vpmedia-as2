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
import com.bourre.events.DefaultChannel;
import com.bourre.events.EventBroadcaster;
import com.bourre.events.IEvent;
import com.bourre.log.PixlibStringifier;

class com.bourre.events.ChannelBroadcaster 
{
	private var _oDefaultChannel :String;
	private var _mChannel : Map;
	
	public function ChannelBroadcaster( oChannel : String )
	{
		empty();
		setDefaultChannel( oChannel );
	}
	
	public function getDefaultDispatcher() : EventBroadcaster
	{
		return _mChannel.get( _oDefaultChannel );
	}
	
	public function getDefaultChannel() : String
	{
		return _oDefaultChannel;
	}
	
	public function setDefaultChannel( oChannel : String ) : Void
	{
		_oDefaultChannel = oChannel ? oChannel : DefaultChannel.CHANNEL;
		getChannelDispatcher( getDefaultChannel() );
	}
	
	public function empty() : Void
	{
		_mChannel = new Map();
		
		var channel : String = getDefaultChannel();
		if ( channel ) getChannelDispatcher( channel );
	}
	
	public function isRegistered( listener : Object, type : String, oChannel : String ) : Boolean
	{
		return getChannelDispatcher( oChannel ).getListenerArray( type ).listenerExists( listener );
	}
	
	public function hasChannelDispatcher( oChannel : String ) : Boolean
	{
		return oChannel ? _mChannel.containsKey( oChannel ) : _mChannel.containsKey( _oDefaultChannel );
	}
	
	public function hasChannelListener( type : String, oChannel : String ) : Boolean
	{
		if ( hasChannelDispatcher( oChannel ) )
		{
			return getChannelDispatcher( oChannel ).listenerArrayExists( type );
			
		} else
		{
			return false;
		}
	}
	
	public function getChannelDispatcher( oChannel : String ) : EventBroadcaster
	{
		if ( hasChannelDispatcher( oChannel ) )
		{
			return oChannel ? _mChannel.get( oChannel ) : _mChannel.get( _oDefaultChannel );
			
		} else
		{
			var eb : EventBroadcaster = new EventBroadcaster();
			_mChannel.put( oChannel, eb );
			return eb;
		}
	}
	
	public function addListener( o : Object, oChannel : String ) : Void
	{
		getChannelDispatcher( oChannel ).addListener( o );
	}
	
	public function removeListener( o : Object, oChannel : String ) : Void
	{
		getChannelDispatcher( oChannel ).removeListener( o );
	}
	
	public function addEventListener( type : String, o : Object, oChannel : String ) : Void
	{
		var eb : EventBroadcaster = getChannelDispatcher( oChannel );
		var args : Array = arguments.splice( 0, 2 ).concat( arguments.splice( 3 ) );
		eb.addEventListener.apply( eb, args );
	}
	
	public function removeEventListener( type : String, o : Object, oChannel : String ) : Void
	{
		getChannelDispatcher( oChannel ).removeEventListener( type, o );
	}
	
	public function broadcastEvent( e : IEvent, channel : String ) : Void
	{
		getChannelDispatcher( channel ).broadcastEvent( e );
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