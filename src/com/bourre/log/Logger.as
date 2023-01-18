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
 * {@code Logger} defines based class/method for Logging API.
 * 
 * <p>Use {@link Logger.LOG} / {@link #log} methods to log messages
 * throw all registred {@link LogListener} listeners.
 * 
 * <p>{@link #addLogListener} and {@link #removeLogListener} allow to add / remove
 * log listeners (tracer) from logger repository.
 * 
 * <p>Messages can be filtered by differents {@link LogLevel} level and using some
 * {@link LogChannel} definition.
 * 
 * <p>Take a look at {@link com.bourre.utils} to see all available {@link LogListener}
 * concrete implementation. (cf SosTracer & LuminicTracer)  
 *   
 * <p>Example
 * <code>
 * 	 //Log all internal messages from Pixlib framework
 *   var oLogger : Logger = Logger.getInstance();
 *   oLogger.addLogListener( SosTracer.getInstance(), PixlibDebug.channel );
 *   
 *   oLogger.log("Logging API ready", LogLevel.INFO);
 * </code>
 * 
 * @author Francis Bourre
 * @version 1.0
 */

import com.bourre.events.EventBroadcaster;
import com.bourre.log.LogChannel;
import com.bourre.log.LogEvent;
import com.bourre.log.LogLevel;
import com.bourre.log.LogListener;
import com.bourre.log.PixlibStringifier;

class com.bourre.log.Logger
{
	//-------------------------------------------------------------------------
	// Private properties
	//-------------------------------------------------------------------------
	
	private static var _oI:Logger;
	private var _oLevel:LogLevel;
	private var _oEB : EventBroadcaster;
	
	
	//-------------------------------------------------------------------------
	// Public API
	//-------------------------------------------------------------------------
	
	public static function getInstance() : Logger
	{
		return (_oI != undefined) ? _oI : Logger._init();
	}
	
	
	/**
	 * Sends message to logging API.
	 * 
	 * <p>Messages are send to all {@link LogListener} instances added 
	 * with {@code #addLogListener} method.
	 * 
	 * <p>Level filter can be defined with {@link #SETLEVEL} / {@link #GETLEVEL}
	 * methods
	 * 
	 * @param o Log message
	 * @param oLevel (optional) A {@link LogLevel} instance (log level)
	 * @param channel (optional) A {@link LogChannel} instance (log filter)
	 */
	public static function LOG( o, oLevel:LogLevel, channel:LogChannel ) : Void
	{
		getInstance().log( o, oLevel, channel );
	}
	
	/**
	 * Defines log level filter.
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
	 *  @param oLevel A {@link LogLevel} instance
	 */
	public static function SETLEVEL( oLevel:LogLevel ) : Void
	{
		getInstance()._oLevel =  oLevel;
	}
	
	/**
	 * Returns current log level filter.
	 * 
	 * @return A {@link LogLevel} instance
	 */
	public static function GETLEVEL() : LogLevel
	{
		return getInstance()._oLevel;
	}
	
	/**
	 * Adds passed-in {@code listener} to {@code Logger} event.
	 * 
	 * <p>Uses passed-in {@code channel} to filter message.
	 * 
	 * @param listener A {@code LogListener} instance
	 * @param channel (optional) log channel filter
	 */
	public function addLogListener( listener : LogListener, channel:LogChannel ) : Void
	{
		if ( !channel )
		{
			_oEB.addListener( listener, listener.onLog );
		} else
		{
			_oEB.addEventListener( channel, listener, listener.onLog );
		}
	}
	
	/**
	 * Removes passed-in {@code listener} for receiving {@code Logger} events.
	 * 
	 * @param listener A {@code LogListener} instance
	 * @param channel (optional) log channel filter
	 */
	public function removeLogListener( listener : LogListener, channel : LogChannel ) : Void
	{
		if ( !channel )
		{
			_oEB.removeListener( listener );
		} else
		{
			_oEB.removeEventListener( channel, listener );
		}
	}
	
	/**
	 * Sends message to logging API.
	 * 
	 * <p>Messages are send to all {@link LogListener} instances added 
	 * with {@code #addLogListener} method.
	 * 
	 * <p>Level filter can be defined with {@link #SETLEVEL} / {@link #GETLEVEL}
	 * methods
	 * 
	 * @param o Log message
	 * @param oLevel (optional) A{@link LogLevel} instance (log level)
	 * @param channel (optional) A {@link LogChannel} instance (log filter)
	 */
	public function log( logContent, oLevel:LogLevel, channel:LogChannel ) : Void
	{	
		if (oLevel == undefined) oLevel = LogLevel.DEBUG;
		if (oLevel.isEnabled()) _oEB.broadcastEvent( new LogEvent( oLevel, logContent, channel ) );
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
	
	/**
	 * Inits a new {@code Logger} instance and properties.
	 * 
	 * <p>Used by {@link #getInstance} method to build
	 * a new {@code Logger} instance.
	 * 
	 * @return A {@code Logger} instance
	 */
	private static function _init() : Logger
	{
		_oI = new Logger();
		return _oI;
	}
	
	/**
	 * Constructs a new {@code Logger} instance.
	 * 
	 * <p>Constructor is private, uses {@link #getInstance) method
	 * for {@code Logger} instanciation.
	 */
	private function Logger()
	{
		_oEB = new EventBroadcaster( this );
		_oLevel = LogLevel.DEBUG;
	}
}