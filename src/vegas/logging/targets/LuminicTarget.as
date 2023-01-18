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

import vegas.logging.LogEvent;
import vegas.logging.targets.LineFormattedTarget;
import vegas.util.MathsUtil;

/**
 * Provides a logger target that uses the FlashInspector console to output log messages. 
 * Thanks Pablo Costantini and LuminicBox <a href='http://www.luminicbox.com/blog/default.aspx?page=post&id=2'>FlashInspector</a>.
 * <p><b>Example :</b></p>
 * <p>
 * {@code
 * import vegas.logging.* ;
 * import vegas.logging.targets.LuminicTarget ;
 * 
 * var target:LuminicTarget = new LuminicTarget(2, false) ;
 * target.includeLines = true ;
 * target.includeLevel = true ;
 * target.filters = ["__TEST__"] ;
 * target.level = LogEventLevel.ALL ; // level filter !
 * 
 * var logger:ILogger = Log.getLogger("__TEST__") ;
 * 
 * logger.debug("hello") ;
 * logger.warn(2) ;
 * 
 * logger.debug("------------") ;
 * target.isCollapse = true ;
 * logger.error([2, 3, ["coucou", "hello", "item"]]) ;
 * logger.debug({ prop1:"coucou" , prop2:[3, 4, 5] , prop3:true } ) ;
 * logger.debug(new XML("<item><subitem>coucou</subitem><subitem>hello</subitem></item>")) ;
 * }
 * </p>
 * @author eKameleon
 */
class vegas.logging.targets.LuminicTarget extends LineFormattedTarget 
{
	
	/**
	 * Creates a new LuminicTarget instance.
	 */
	public function LuminicTarget(depth:Number, collapse:Boolean) 
	{
		_lc = new LocalConnection() ;
		isCollapse = collapse ;
		setMaxDepth( depth || 4 ) ;
	}

	/**
	 * The id of the local connection.
	 */
    static public var CONNECTION_ID:String = "_luminicbox_log_console" ;
       
    /**
     * The name of the dispatch message.
     */
    static public var DISPATCH_MESSAGE:String = "log" ;

	/**
	 * Indicated if the console use collapse property or not.
	 */
	public var isCollapse:Boolean ;
	
	/**
	 * (read-only) Returns the max depth to collaspe the structure of an object in the console.
	 */
	public function get maxDepth():Number
	{
		return getMaxDepth() ;	
	}

	/**
	 * (read-only) Sets the max depth to collaspe the structure of an object in the console.
	 */
	public function set maxDepth( value:Number ):Void
	{
		setMaxDepth(value) ;	
	}

	/**
	 * Returns the max depth to collaspe the structure of an object in the console.
	 */
	public function getMaxDepth():Number 
	{
		return _maxDepth ;
	}
	
	/**
     * Descendants of this class should override this method to direct the specified message to the desired output.
     *
     * @param message String containing preprocessed log message which may include time, date, category, etc. 
     *        based on property settings, such as <code>includeDate</code>, <code>includeCategory</code>, etc.
	 */
	/*override*/ public function internalLog( message , level:Number ):Void
	{
		_lc.send( CONNECTION_ID , DISPATCH_MESSAGE, message ) ;
	}
	
	/**
	 * This method handles a LogEvent from an associated logger.
	 */
	/*override*/ public function logEvent(e:LogEvent) 
	{
		var message = e.message ;
        var level:String = LogEvent.getLevelString(e.level) ;
		var category:String = e.currentTarget.category ;
		var time:Date = new Date() ;

		var context:Object = 
		{
			loggerId     : null ,
			levelName    : level ,
			time : time
		} ;
	    	
		if (isCollapse) 
		{
			context.argument = _serializeObj( message , 1) ;
		} 
		else 
		{
			var data:Object = 
			{
				type  : "string" ,
				value : formatMessage( message, level, category, time)
			} ;
			context.argument = data ;
		}
		
		internalLog( context ) ;
		
	}

	/**
	 * Sets the max depth to collaspe the structure of an object in the console.
	 */
	public function setMaxDepth(value:Number) 
	{
		_maxDepth = MathsUtil.clamp(value, 1, 255) ;
	}

	/**
	 * Internal LocalConnection reference.
	 */
	private var _lc:LocalConnection ;
	
	/**
	 * Internal max depth value.
	 */
	private var _maxDepth:Number ;

	/**
	 * Returns an object with all the config of the current log content.
	 */
	private function _getType(o):Object 
	{
		var tof:String = typeof(o);
		var type = new Object();
		type.inspectable = true ;
		type.name = tof ;
		switch( tof ) 
		{
			case "string" :
			case "boolean" :
			case "number" :
			case "undefined" :
			case "null" :
			{
				type.inspectable = false ;
				break ;
			}
			default :
			{	
				if(o instanceof Date) 
				{
					type.inspectable = false ;
					type.name = "date" ;
				}
				else if(o instanceof Array) 
				{
					type.name = "array" ;
				}
				else if(o instanceof Button) 
				{
					type.name = "button";
				}
				else if(o instanceof MovieClip) 
				{
					type.name = "movieclip";
				}
				else if(o instanceof XML) 
				{
					type.name = "xml" ;
					type.stringify = true ;
				}
				else if(o instanceof XMLNode) 
				{
					type.name = "xmlnode" ;
					type.stringify = true ;
				}
				else if(o instanceof Color) 
				{
					type.name = "color" ;
				}
			}
		}
		return type ;
	}
	

	/**
	 * Serialize un object before send the message in the console.
	 */
	private function _serializeObj(o, depth:Number) : Object {
		
		var type = _getType(o) ;
		var serial:Object = {} ;
		
		if (!type.inspectable) 
		{
			serial.value = o ;
		}
		else if(type.stringify) 
		{
			serial.value = o + "" ;
		}
		else 
		{
			if (depth <= _maxDepth) 	
			{
				if(type.name == "movieclip" || type.name == "button") 
				{
					serial.id = o + "" ;
				}
				var items:Array = [] ;
				if(o instanceof Array) 
				{
					var len:Number = o.length ;
					for(var i:Number=0; i<len ; i++) 
					{
						items[i] = 
						{
							property : i ,
							value : _serializeObj( o[i], (depth+1) )
						} ;
					}
					
				}
				else 
				{
					for (var prop:String in o) 
					{
						items.push
						( 
							{
								property : prop ,
								value : _serializeObj( o[prop], (depth+1) )
							} 
						) ;
					} 
				}
				
				serial.value = items ;
				
			}
			else 
			{
				serial.reachLimit = true ;
			}
		}
		serial.type = type.name ;
		return serial ;
	}
	


}