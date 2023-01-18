/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is Vegas Framework.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <vegas@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2007
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

import vegas.data.iterator.Iterator;
import vegas.data.queue.LinearQueue;
import vegas.errors.Warning;
import vegas.events.Delegate;
import vegas.logging.LogEvent;
import vegas.logging.LogEventLevel;
import vegas.logging.targets.LineFormattedTarget;
import vegas.logging.targets.SOSType;

/**
 * Provides a logger target that uses the SOS console to output log messages. 
 * Thanks PowerFlasher and the <a href='http://sos.powerflasher.de/english/english.html'>SOS Console</a>
 * <p><b>Example :</b></p>
 * <p>
 * {@code
 * import vegas.logging.* ;
 * import vegas.logging.targets.SOSTarget ;
 *  
 * import vegas.errors.* ;
 * 
 * // setup target
 * var target:SOSTarget = new SOSTarget(0xD8F394) ;
 * target.filters = ["monApplication", "vegas.errors.*"] ; // use a empty array to receive all logs.
 * target.includeLines = true ;
 * target.includeCategory = true ;
 * target.includeDate = true ;
 * target.includeTime = true ;
 * target.includeLevel = true ;
 * target.level = LogEventLevel.ALL ; 
 * //target.setLevelColor(LogEventLevel.DEBUG, 0xFF0000) ;
 * //target.levelPolicy = SOSType.DISABLE ; // SOSType.ENABLE default value
 * target.sendFoldLevelMessage(LogEventLevel.DEBUG, "Init SOS console", "test a fold message") ;
 * target.sendMessage("Init SOS console....") ;
 * 
 * // create a log writer
 * var logger:ILogger = Log.getLogger("monApplication") ;
 * 
 * logger.log(LogEventLevel.DEBUG, "here is some myDebug info : {0} and {1}", 2.25 , true) ;
 * logger.debug("DEBUG !!") ;
 * logger.error("ERROR !!") ;
 * logger.fatal("FATAL !!") ;
 * logger.info("INFO !!") ;
 * logger.warn("WARNING !!") ;
 * logger.warn([3, 2, 4]) ;
 * throw new FatalError("a fatal error") ;
 * }
 * </p>
 * @author eKameleon
 */
class vegas.logging.targets.SOSTarget extends LineFormattedTarget 
{

	/**
	 * Creates a new SOSTarget instance.
	 */
	public function SOSTarget(color:Number) 
	{
		
		// Init Buffer queue object
		
		_queue = new LinearQueue() ;
		
		// Init Application Color
		
		setAppColor(isNaN(color) ? SOSType.DEFAULT_COLOR : color) ;
		
		// Init XMLSocket object
		
		_xs = new XMLSocket() ;
		_xs.onConnect = Delegate.create(this, _connect) ;
		
		// Init Colors
		
		setLevelColor( LogEventLevel.ALL ) ;
		setLevelColor( LogEventLevel.DEBUG ) ;
		setLevelColor( LogEventLevel.ERROR ) ;
		setLevelColor( LogEventLevel.FATAL ) ;
		setLevelColor( LogEventLevel.INFO ) ;
		setLevelColor( LogEventLevel.WARN ) ;
		
		levelPolicy = SOSType.ENABLE ;
		
		// Connect Console
		
		connect() ;
		
	}
	
	/**
	 * (read-only) Returns 'true' if the socket is connected with the console.
	 */
	public function get isConnected():Boolean 
	{
		return getIsConnected() ;	
	}
	
	/**
	 * Show the level colors. Use SOSType.ENABLE or SOSType.DISABLE
	 */	
	public var levelPolicy:Number ;

	/**
	 * Clear the console.
	 */	
	public function clear():Void 
	{
		sendMessage(SOSType.CLEAR) ;
	}

	/**
	 * Close the console socket connection.
	 */
	public function close():Void 
	{
		_isConnected = false ;
		_xs.close() ;
	}

	/**
	 * Connect to the SOS console. 
	 */
	public function connect() 
	{
		if (_isConnected) close() ;
		_xs.connect(SOSType.HOST, SOSType.PORT) ;
	}

	/**
	 * Exit and close the SOS console.
	 */
	public function exit():Void 
	{
		sendMessage(SOSType.EXIT) ;
	}

	/**
	 * Returns the string socket representation to send a fold message in the SOSConsole.
	 */
	public function getFoldMessage( title:String, message:String, level:Number ):String
	{
		var msg:String = "";
		var levelName:String = LogEvent.getLevelString(level) ;
		msg += '!SOS<showFoldMessage key="' + levelName + '">';
		msg += '<title>' + title + '</title>';
		msg += '<message><![CDATA[' + message + ']]></message>' ;
		msg += '</showFoldMessage>' ;
		return msg ;	
	} 

	/**
	 * Shows some Information about the Connection. This time it is : HostName, HostAddress and Color.
	 */
	public function getIdentify():Void 
	{
		sendMessage( SOSType.IDENTIFY ) ;
	}

	/**
	 * Returns the string socket representation to send a simple message in the SOSConsole.
	 */
	public function getMessage( msg:String , level:Number ):String
	{
		var levelName:String = LogEvent.getLevelString(level) ;
		return  "!SOS<showMessage key='" + levelName + "'>" + msg + "</showMessage>\n"  ;	
	}

	/**
	 * Returns 'true' if the socket is connected with the console.
	 */
	public function getIsConnected():Boolean 
	{
		return _isConnected ;
	}
	
	/**
     * Descendants of this class should override this method to direct the specified message to the desired output.
     * @param message String containing preprocessed log message which may include time, date, category, etc. 
	 */
	/*override*/ public function internalLog( message , level:Number ):Void
	{
		sendLevelMessage( level , message ) ;
	}

	/**
	 * Send a fold message with a specific level.
	 */
	public function sendFoldLevelMessage(level:Number, title:String, message:String):Void
	{
		if (levelPolicy == SOSType.ENABLE) 
		{
			message = getFoldMessage( title, message, level) ;
		}
		sendMessage( message ) ;
	}

	/**
	 * Send a message with a specific level.
	 */
	public function sendLevelMessage(level:Number, message:String):Void 
	{
		if ( levelPolicy == SOSType.ENABLE ) 
		{
			message = getMessage(message, level) ;
		}
		sendMessage( message ) ;
	}

	/**
	 * Send message or bufferize message if the SOS console is disconnected.
	 */
	public function sendMessage(msg:String):Void 
	{
		if (_isConnected) 
		{
			_xs.send( msg ) ;
		}
		else 
		{
			_queue.enqueue(msg) ;
		}
	}

	/**
	 * Sets the name of the application.
	 */
	public function setAppName(name:String):Void 
	{
		sendMessage("!SOS<appName>" + name + "</appName>") ;
	}
	
	/**
	 * Sets the color of the application, the Color must be set as Integer Value. So 16768477 equals 0xffdddd.
	 */
	public function setAppColor(color:Number):Void 
	{
		sendMessage("!SOS<appColor>" + color + "</appColor>") ;
	}
	
	/**
	 * Sets the color for a specific level.
	 * @see LogEventLevel
	 */
	public function setLevelColor( level:Number, color:Number ):Void 
	{
		if (!LogEventLevel.isValidLevel(level)) 
		{
			return ;
		}
		var levelName:String = LogEvent.getLevelString(level) ;
		var msg:String = "!SOS<setKey>" ;
		msg += "<name>" + levelName + "</name>" ;
		msg += "<color>"+ (color || SOSType[ levelName + "_COLOR" ]) + "</color>" ;
		msg += "</setKey>\n" ;
		sendMessage(msg) ;
	}
	
	/**
	 * The internal color value.
	 */	
	private var _color:Number ;
	
	/**
	 * The internal value to indicated if the target is connected.
	 */
	private var _isConnected:Boolean ;
	
	/**
	 * The internal buffer.
	 */
	private var _queue:LinearQueue ;
	
	/**
	 * The internal socket reference.
	 */
	private var _xs:XMLSocket ;
	
	/**
	 * Invoqued if the xml socket try to connect the console.
	 */
	private function _connect(success:Boolean):Void 
	{
		if (success) 
		{
			_flush() ;
			_isConnected = true ;
		}
		else 
		{
			throw new Warning("SOSTarget failed the connection with the console, the socket connection is failed.") ;
		}
	}
	
	/**
	 * Flush the internal buffer.
	 */
	private function _flush() 
	{
		if (_queue.size() > 0) 
		{
			var it:Iterator = _queue.iterator() ;
			while (it.hasNext())
			{
				 _xs.send(it.next()) ;
			}
		}
	}
	
}