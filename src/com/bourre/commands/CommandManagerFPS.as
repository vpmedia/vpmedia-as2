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
 * {@code CommandManagerFPS} allows to store Command objects and to execute each one
 * at each frame displayed by the player.
 * 
 * <p>That's a singleton implementation of {@link com.bourre.commands.CommandFPS}
 * To get detailed API, check {@link com.bourre.commands.CommandFPS} documentation.
 *
 * <p>If your animation framerate is 31 fps, each added command
 * will have its {@code execute} method triggered 31 times per second.
 * 
 * <p> In the example below, {@code test} method will be called on each frame.
 * 
 * @example
 * <code>
 * import com.bourre.commands.*;
 * 
 * function test(s:String) : Void
 * {
 * 	trace("hello world");
 * }
 * 
 * CommandManagerFPS.getInstance().push( new Delegate(this, test) );
 * </code>
 * 
 * @author Francis Bourre
 * @version 1.0
 */
 
import com.bourre.commands.CommandFPS;
import com.bourre.log.PixlibStringifier;
import com.bourre.transitions.FPSBeacon;

class com.bourre.commands.CommandManagerFPS extends CommandFPS
{
	public static function getInstance() : CommandManagerFPS
	{
		return (CommandManagerFPS._oI instanceof CommandManagerFPS) ? _oI : CommandManagerFPS._init();
	}
	
	public static function release() : Void
	{
		FPSBeacon.getInstance().removeFrameListener( _oI );
		delete _oI;
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
	private static var _oI:CommandManagerFPS;
	
	private function CommandManagerFPS()
	{
		super();
	}
	
	private static function _init() : CommandManagerFPS
	{
		_oI = new CommandManagerFPS();
		return _oI;
	}
}