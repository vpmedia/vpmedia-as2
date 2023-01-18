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
  
  Andy Herrman (aherrman@gmail.com) - Added the option to display milliseconds in the Time format.
   
*/

import vegas.logging.AbstractTarget;
import vegas.logging.LogEvent;
import vegas.logging.LogLogger;

/**
 * All logger target implementations that have a formatted line style output should extend this class. It provides default behavior for including date, time, category, and level within the output.
 * @author eKameleon
 */
class vegas.logging.targets.LineFormattedTarget extends AbstractTarget 
{
	
	/**
	 * Creates a new LineFormattedTarget instance.
	 */
	public function LineFormattedTarget() 
	{
		//
	}

	/**
	 * Indicates if the category for this target should added to the trace.
	 */
	public var includeCategory:Boolean = false ;
	
	/**
	 * Indicates if the date should be added to the trace.
	 */
	public var includeDate:Boolean = false ;
	
	/**
	 * Indicates if the level for the event should added to the trace.
	 */
	public var includeLevel:Boolean = false ;
	
	/**
	 * Indicates if a line number should be added to the trace.
	 */
	public var includeLines:Boolean = false ; 

  	/**
	 * Indicates if the milliseconds should be added to the trace. Only relevant when includeTime is {@code true}.
     */
  	public var includeMilliseconds:Boolean = false ;

	/**
	 * Indicates if the time should be added to the trace.
	 */
	public var includeTime:Boolean = false ;

   	/**
     * The separator string.
     */
   	public var separator:String = " " ;

	/**
     * Descendants of this class should override this method to direct the specified message to the desired output.
     * @param message String containing preprocessed log message which may include time, date, category, etc. based on property settings, such as <code>includeDate</code>, <code>includeCategory</code>, etc.
     * @param level the LogEventLevel of the message.
	 */
	public function internalLog( message , level:Number ):Void
	{
    	// override this method.
	}

	/**
	 * This method handles a LogEvent from an associated logger.
	 */
	/*override*/ public function logEvent( e:LogEvent ) 
	{
		var message = e.message ;
		var level:String = LogEvent.getLevelString( e.level ) ;
		var category:String = LogLogger(e.getTarget()).category ;
		message = formatMessage( message, level, category, new Date() ) ;
		internalLog( message, e.level ) ;
	}

	/**
	 * The current line number.
	 */
	private var __lineNumber:Number = 1 ;
	
	/**
	 * This method format the passed Date in arguments.
	 */
	private function _formatDate(d:Date):String 
	{
		var date:String = "" ;
		date += _getDigit(d.getDate()) ;
		date += "/" + _getDigit(d.getMonth() + 1) ;
		date += "/" + d.getFullYear();
		return date ;
	}

	/**
	 * This method format the passed level in arguments.
	 */
	private function _formatLevel(level:String):String 
	{
		return '[' + level + ']' ;
	}	

	/**
	 * This method format the current line value.
	 */
	private function _formatLines():String 
	{
		return "[" + __lineNumber++ + "]" ; 
	}	
	
	/**
	 * This method format the log message.
	 * @return the format log message.
	 */
    private function formatMessage(message, level:String, category:String, date:Date):String 
    {
	    	
	    var msg:String = "" ;
       		
       	var d:Date = date || new Date ;
    	
    	if (includeLines) 
    	{
    	    msg += _formatLines() + separator ; // lines
    	}
    	
    	if (includeDate) 
    	{
    	    msg += _formatDate(d) + separator ; // date
    	}
    	
    	if (includeTime) 
    	{
    	    msg += _formatTime(d) + separator ; // time
    	}
    	
    	if (includeLevel)
    	{
    	    msg += _formatLevel(level || "" ) + separator ; // level  
    	} 
    	
    	if (includeCategory) 
    	{
        	msg += (category || "") + separator ; // category
    	}
    	
    	msg += message.toString() ;
	    
	    return msg ;
	    	
    }
    
	/**
	 * This method format the current Date passed in argument.
	 * @param d the Date object to format.
	 * @return the format time in the message.
	 */
	private function _formatTime(d:Date):String 
	{
		var time:String = "" ;
		time += _getDigit(d.getHours()) ;
		time += ":" + _getDigit(d.getMinutes()) ;
		time += ":" + _getDigit(d.getSeconds()) ;
		if( includeMilliseconds ) 
		{
      		time += ":" + _getDigit(d.getMilliseconds()) ;
    	}
		return time ;
	}
	
	/**
	 * Returns the string representation of a number and use digit conversion.
	 * @return the string representation of a number and use digit conversion.
	 */
	private function _getDigit(n:Number):String 
	{
		if (isNaN(n)) return "00" ;
		return ((n < 10) ? "0" : "") + n ;
	}

}