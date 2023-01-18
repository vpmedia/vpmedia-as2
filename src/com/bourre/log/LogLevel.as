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
 * {@code LogLevel} defines first way for log message filtering.
 * 
 * <p>All listed values for level are available : 
 * <ul>
 *   <li>{@link LogLevel.DEBUG}</li>
 *   <li>{@link LogLevel.INFO}</li>
 *   <li>{@link LogLevel.WARN}</li>
 *   <li>{@link LogLevel.ERROR}</li>
 *   <li>{@link LogLevel.FATAL}</li>
 * </ul>
 * 
 * @author Francis Bourre
 * @version 1.0
 */

import com.bourre.log.Logger;
import com.bourre.log.PixlibStringifier;

class com.bourre.log.LogLevel extends Number
{
	//-------------------------------------------------------------------------
	// Private properties
	//-------------------------------------------------------------------------
	
	private var _sName:String;
	private var _nLevel:Number;
	
	
	//-------------------------------------------------------------------------
	// Public Properties
	//-------------------------------------------------------------------------
	
	/** Level for debugging mode **/
	public static var DEBUG:LogLevel = new LogLevel("DEBUG", 0);
	
	/** Level for informations mode **/
	public static var INFO:LogLevel = new LogLevel("INFO", 1);
	
	/** Level for warning mode **/
	public static var WARN:LogLevel = new LogLevel("WARN", 2);
	
	/** Level for error mode **/
	public static var ERROR:LogLevel = new LogLevel("ERROR", 3);
	
	/** Level for fatal error mode **/
	public static var FATAL:LogLevel = new LogLevel("FATAL", 4);
	
	
	//-------------------------------------------------------------------------
	// Public API
	//-------------------------------------------------------------------------
	
	/**
	 * Constructs a new {@code LogLevel} instance.
	 * 
	 * @param sName Level's name
	 * @param nLevel Level's id
	 */
	public function LogLevel(sName:String, nLevel:Number)
	{
		super(nLevel);
		_sName = sName;
		_nLevel = nLevel;
	}
	
	/**
	 * Returns level's name.
	 * 
	 * @return {@code String@ level name
	 */
	public function getName() : String
	{
		return _sName;
	}
	
	/**
	 * Returns level's id.
	 * 
	 * @return {@code Number} level id
	 */
	public function getLevel() : Number
	{
		return _nLevel;
	}
	
	/**
	 * Indicates if current level is enabled or not,
	 * according {@link Logger.SETLEVEL} level definition.
	 * 
	 * <p>Allow to filter some level in Logging API.
	 * 
	 * @return {@code true} if level is allowing in current
	 * context, either {@code false}
	 */
	public function isEnabled() : Boolean
	{
		return _nLevel >= Logger.GETLEVEL();
	}
	
	/**
	 * Returns the string representation of this instance.
	 * @return {@code String} representation of this instance
	 */
	public function toString() : String
	{
		return PixlibStringifier.stringify( this ) + "[" + getName() + ":" + this + "]";
	}
}