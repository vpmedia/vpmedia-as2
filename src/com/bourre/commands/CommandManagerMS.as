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
 * {@code CommandManagerMS} allows to store Command objects and to loop 
 * their execution at a specified speed in milliseconds.
 * 
 * <p>That's a singleton implementation of {@link com.bourre.commands.CommandMS}
 * To get detailed API, check {@link com.bourre.commands.CommandMS} documentation.
 *
 * <p>In the example below, the specified command will be runned each second :
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
 * CommandManagerMS.getInstance().push( new Delegate(this, test), 1000 );
 * </code>
 * 
 * @author Francis Bourre
 * @version 1.0
 */
 
import com.bourre.commands.CommandMS;
import com.bourre.log.PixlibStringifier;

class com.bourre.commands.CommandManagerMS extends CommandMS
{

	public static function getInstance() : CommandManagerMS
	{
		return (CommandManagerMS._oI instanceof CommandManagerMS) ? _oI : CommandManagerMS._init();
	}
	
	public static function release() : Void
	{
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
	private static var _oI:CommandManagerMS;
	
	private function CommandManagerMS()
	{
		super();
	}
	
	private static function _init() : CommandManagerMS
	{
		_oI = new CommandManagerMS();
		return _oI;
	}
}