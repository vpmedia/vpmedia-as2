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
 * {@code FrontController} class.
 * 
 * TODO FrontController documentation
 * 
 * @author Francis Bourre
 * @version 1.0
 */
 
import com.bourre.commands.Command;
import com.bourre.data.collections.Map;
import com.bourre.events.EventBroadcaster;
import com.bourre.events.IEvent;
import com.bourre.events.IEventDispatcher;
import com.bourre.log.PixlibDebug;
import com.bourre.log.PixlibStringifier;

class com.bourre.events.FrontController
{
	//-------------------------------------------------------------------------
	// Private properties
	//-------------------------------------------------------------------------
	
	private var _a:Map;
	
	
	//-------------------------------------------------------------------------
	// Public Properties
	//-------------------------------------------------------------------------
	
	public var _oEB:IEventDispatcher;
	
	
	//-------------------------------------------------------------------------
	// Public API
	//-------------------------------------------------------------------------
	
	public function FrontController(oEB:IEventDispatcher)
	{
		_a = new Map();
		_oEB = oEB;
		if (_oEB == undefined) _oEB = EventBroadcaster.getInstance();
	}
	
	public function push(s:String, oC:Command) : Void
	{
		_a.put( s.toString(), oC );
		_oEB.addEventListener(s, this, _handleEvent);
	}
	
	public function remove(s:String) : Void
	{
		_a.remove( s.toString() );
		_oEB.removeEventListener(s, this);
	}
	
	/**
	 * Returns the string representation of this instance.
	 * @return the string representation of this instance
	 */
	public function toString() : String 
	{
		return PixlibStringifier.stringify( this );
	}
	
	
	//-------------------------------------------------------------------------
	// Private implementation
	//-------------------------------------------------------------------------
	
	private function _handleEvent(e:IEvent) : Void
	{
		_executeCommand(e);
	}
	
	private function _getCommand(s:String) : Command
	{
		if (!_a.containsKey( s )) PixlibDebug.ERROR( this + ".getCommand() can't retrieve '" + s + "' command." );
		return _a.get( s );
	}

	private function _executeCommand(e:IEvent) : Void
	{
		var t:String = (e.getType() == undefined) ? Object(e).type.toString() : e.getType().toString();
		_getCommand( t ).execute( e );
	}
}