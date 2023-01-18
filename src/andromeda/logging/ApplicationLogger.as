/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is Andromeda Framework based on VEGAS.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <vegas@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2007
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

import vegas.logging.ILogger;
import vegas.logging.Log;
import vegas.logging.LogEventLevel;
import vegas.logging.targets.LuminicTarget;
import vegas.logging.targets.SOSTarget;
import vegas.util.ResolverProxy;

/**
 * This static tool class initialize the global ILogger singleton of the application and create a link with all the ILogable CoreObject.
 * @author eKameleon
 */
class andromeda.logging.ApplicationLogger 
{
	
	/**
	 * The application global logger id.
	 */
	static public var APPLICATION_CHANNEL:String = "application" ;

	/**
	 * The vegas errors logger id.
	 */
	static public var VEGAS_ERRORS_CHANNEL:String = "vegas.errors.*" ;

	/**
	 * Logs the specified data using the LogEventLevel.DEBUG level.
	 * @param message:String The information to log. This string can contain special marker characters of the form {x}, where x is a zero based index that will be replaced with the additional parameters found at that index if specified.
 	 * @param ... rest Additional parameters that can be subsituted in the str parameter at each "{x}" location, where x is an integer (zero based) index value into the Array of values specified.
	 */
	static var debug:Function ; 
	
	/**
	 * Logs the specified data using the LogEventLevel.ERROR level.
	 * @param message:String The information to log. This string can contain special marker characters of the form {x}, where x is a zero based index that will be replaced with the additional parameters found at that index if specified.
 	 * @param ... rest Additional parameters that can be subsituted in the str parameter at each "{x}" location, where x is an integer (zero based) index value into the Array of values specified.
	 */
	static var error:Function ; 
	
	/**
	 * Logs the specified data using the LogEventLevel.FATAL level.
	 * @param message:String The information to log. This string can contain special marker characters of the form {x}, where x is a zero based index that will be replaced with the additional parameters found at that index if specified.
 	 * @param ... rest Additional parameters that can be subsituted in the str parameter at each "{x}" location, where x is an integer (zero based) index value into the Array of values specified.	 
 	 */
	static var fatal:Function ; 
	
	/**
	 * Logs the specified data using the LogEvent.INFO level.
 	 * @param message:String The information to log. This string can contain special marker characters of the form {x}, where x is a zero based index that will be replaced with the additional parameters found at that index if specified.
 	 * @param ... rest Additional parameters that can be subsituted in the str parameter at each "{x}" location, where x is an integer (zero based) index value into the Array of values specified.
	 */
	static var info:Function ;

	/**
	 * Logs the specified data at the given level.
	 * @param level:int The level this information should be logged at. Valid values are:
	 * <li>LogEventLevel.FATAL designates events that are very harmful and will eventually lead to application failure</li>
	 * <li>LogEventLevel.ERROR designates error events that might still allow the application to continue running.</li>
	 * <li>LogEventLevel.WARN designates events that could be harmful to the application operation</li>
	 * <li>LogEventLevel.INFO designates informational messages that highlight the progress of the application at coarse-grained level.</li>
	 * <li>LogEventLevel.DEBUG designates informational level messages that are fine grained and most helpful when debugging an application.</li>
	 * <li>LogEventLevel.ALL intended to force a target to process all messages.</li>
	 * @param message:String The information to log. This string can contain special marker characters of the form {x}, where x is a zero based index that will be replaced with the additional parameters found at that index if specified.
 	 * @param ... rest Additional parameters that can be subsituted in the str parameter at each "{x}" location, where x is an integer (zero based) index value into the Array of values specified.
 	 */
	static var log:Function ; 
	
	/**
	 * Logs the specified data using the LogEventLevel.WARN level.
 	 * @param message:String The information to log. This string can contain special marker characters of the form {x}, where x is a zero based index that will be replaced with the additional parameters found at that index if specified.
 	 * @param ... rest Additional parameters that can be subsituted in the str parameter at each "{x}" location, where x is an integer (zero based) index value into the Array of values specified.
	 */
	static var warn:Function ; 

	/**
	 * Returns the ILogger of the application.
	 * @return the ILogger of the application.
	 */
	static public function getLogger():ILogger
	{
		if( _logger == null )
		{
			_logger = Log.getLogger(APPLICATION_CHANNEL)  ;
		}
		return _logger ;	
	}

	/**
	 * Initialize the global Logger singleton.
	 */
	static public function initialize():Void
	{
		
		// initialize the ITargets of the application.
		
		var filters:Array = [ APPLICATION_CHANNEL , VEGAS_ERRORS_CHANNEL ] ;
		
		var sosTarget:SOSTarget = new SOSTarget() ;
		sosTarget.filters = filters ;
		sosTarget.includeLines = true ;
		sosTarget.level = LogEventLevel.ALL ;
		
		Log.addTarget(sosTarget) ;

		var luminicTarget:LuminicTarget = new LuminicTarget() ;
		luminicTarget.filters = filters ;
		luminicTarget.isCollapse = false ;
		luminicTarget.includeTime = true ;
		luminicTarget.level = LogEventLevel.ALL ;
		
		Log.addTarget(luminicTarget) ;

		// Initialize the proxy between the static class and the internal getLogger() reference.
		
		initProxy() ;

		// This hack change the getLogger method in all CoreObject objects. (All object in VEGAS extends the CoreObject class)		
		
		vegas.core.CoreObject.prototype.getLogger = getLogger ;
		
		ApplicationLogger.debug( "[ApplicationLogger] initialize." ) ;
		
	}
	
	/**
	 * Creates a proxy link between the static class ApplicationLogger and the getLogger() reference.
	 * For example, when we call the method {@code Logger.debug()} the internal resolver proxy call the {@code Logger.getLogger().debug()} method.
	 * @see ResolverProxy
	 * @see __resolve  
	 */
	static public function initProxy():Void
	{
		ResolverProxy.initialize( ApplicationLogger ) ;
		ApplicationLogger["setProxy"]( getLogger() ) ;	
	}

	/**
	 * The internal global logger of the application.
	 */
	static private var _logger:ILogger ;

}