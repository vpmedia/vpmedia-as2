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

import vegas.events.EventDispatcher;
import vegas.logging.ILogger;
import vegas.logging.Log;
import vegas.logging.LogEvent;
import vegas.logging.LogEventLevel;
import vegas.string.StringFormatter;
import vegas.util.TypeUtil;

/**
 * The logger that is used within the logging framework. This class dispatches events for each message logged using the log() method.
 * @author eKameleon
 */
class vegas.logging.LogLogger extends EventDispatcher implements ILogger
{

	/**
	 * Creates a new LogLogger instance.
	 */
	public function LogLogger(category:String) 
	{
		_category = category || Log.DEFAULT_CATEGORY ;
	}

	/**
	 * The category this logger send messages for.
	 */	
	public function get category():String
	{
		return _category;
	}

	/**
	 * This logger is dispatching in a queue if no targets are register.
	 */
	public var isQueue:Boolean ;
	
	/**
	 * Logs the specified data using the LogEventLevel.DEBUG level.
	 * @param context The information to log. This string can contain special marker characters of the form {x}, where x is a zero based index that will be replaced with the additional parameters found at that index if specified.
 	 * @param ... Additional parameters that can be subsituted in the str parameter at each "{x}" location, where x is an integer (zero based) index value into the Array of values specified.
	 */
	public function debug(context):Void 
	{
		log.apply(this, [LogEventLevel.DEBUG].concat(arguments)) ;
	}
	
	/**
	 * Logs the specified data using the LogEventLevel.ERROR level.
	 * @param context The information to log. This string can contain special marker characters of the form {x}, where x is a zero based index that will be replaced with the additional parameters found at that index if specified.
 	 * @param ... Additional parameters that can be subsituted in the str parameter at each "{x}" location, where x is an integer (zero based) index value into the Array of values specified.
	 */
	public function error(context):Void 
	{
		log.apply(this, [LogEventLevel.ERROR].concat(arguments)) ;
	}
	
	/**
	 * Logs the specified data using the LogEventLevel.FATAL level.
	 * @param context The information to log. This string can contain special marker characters of the form {x}, where x is a zero based index that will be replaced with the additional parameters found at that index if specified.
 	 * @param ... Additional parameters that can be subsituted in the str parameter at each "{x}" location, where x is an integer (zero based) index value into the Array of values specified.	 
 	 */
	public function fatal(context):Void 
	{
		log.apply(this, [LogEventLevel.FATAL].concat(arguments)) ;
	}
	
	/**
	 * Logs the specified data using the LogEvent.INFO level.
 	 * @param context The information to log. This string can contain special marker characters of the form {x}, where x is a zero based index that will be replaced with the additional parameters found at that index if specified.
 	 * @param ... Additional parameters that can be subsituted in the str parameter at each "{x}" location, where x is an integer (zero based) index value into the Array of values specified.
	 */
	public function info(context):Void 
	{
		log.apply(this, [LogEventLevel.INFO].concat(arguments)) ;
	}
	
	/**
	 * Logs the specified data at the given level.
 	 * @param level The level this information should be logged at. Valid values are:<p>
	 * <li>LogEventLevel.FATAL designates events that are very harmful and will eventually lead to application failure</li>
	 * <li>LogEventLevel.ERROR designates error events that might still allow the application to continue running.</li>
	 * <li>LogEventLevel.WARN designates events that could be harmful to the application operation</li>
	 * <li>LogEventLevel.INFO designates informational messages that highlight the progress of the application at coarse-grained level.</li>
	 * <li>LogEventLevel.DEBUG designates informational level messages that are fine grained and most helpful when debugging an application.</li>
	 * <li>LogEventLevel.ALL intended to force a target to process all messages.</li></p>
	 * @param context The information to log. This string can contain special marker characters of the form {x}, where x is a zero based index that will be replaced with the additional parameters found at that index if specified.
  	 * @param ... Additional parameters that can be subsituted in the str parameter at each "{x}" location, where x is an integer (zero based) index value into the Array of values specified.
 	 */
	public function log(level:Number, context):Void 
	{
		var message:String ;
		if (TypeUtil.typesMatch(context, String) && arguments.length > 2) 
		{
			message = _format(context.toString(), arguments.splice(2));
		}
		else 
		{
			message = context ;
		}
		var ev:LogEvent = new LogEvent(message, level) ;
		ev.setContext(context) ;
		dispatchEvent(ev, isQueue) ;
	}
	
	/**
	 * Logs the specified data using the LogEventLevel.WARN level.
 	 * @param context The information to log. This string can contain special marker characters of the form {x}, where x is a zero based index that will be replaced with the additional parameters found at that index if specified.
 	 * 
 	 * @param ... Additional parameters that can be subsituted in the str parameter at each "{x}" location, where x is an integer (zero based) index value into the Array of values specified.
	 */
	public function warn(context):Void 
	{
		log.apply(this, [LogEventLevel.WARN].concat(arguments)) ;
	}
	
	/**
	 * Storage for the category property.
	 */
	private var _category:String ;
	
	/**
	 * Format the message with StringFormatter tool.
	 * @see StringFormatter
	 */
	private function _format(msg:String, args:Array):String 
	{
		var f:StringFormatter = new StringFormatter(msg) ;
		return f.format.apply(f, args) ;
	}

}