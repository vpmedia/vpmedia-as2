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

import vegas.core.CoreObject;
import vegas.data.set.HashSet;
import vegas.events.Event;
import vegas.events.EventListener;
import vegas.logging.errors.InvalidFilterError;
import vegas.logging.ILogger;
import vegas.logging.ITarget;
import vegas.logging.Log;
import vegas.logging.LogEvent;
import vegas.logging.LogEventLevel;
import vegas.logging.LogLogger;
import vegas.string.StringFormatter;
import vegas.string.WildExp;
import vegas.util.ArrayUtil;

/**
 * This class provides the basic functionality required by the logging framework for a target implementation. It handles the validation of filter expressions and provides a default level property. No implementation of the logEvent() method is provided.
 * @author eKameleon
 */
class vegas.logging.AbstractTarget extends CoreObject implements EventListener, ITarget 
{

	/**
	 * Creates a new AbstractTarget instance.
	 */
	private function AbstractTarget()
	{
		_level = LogEventLevel.ALL ;
		_filters = [ "*" ] ;
		_set = new HashSet() ;
	}

	/**
	 * The static field used when throws an Error when a character is invalid.
	 */        
	static public var CHARS_INVALID:String = "The following characters are not valid : []~$^&/\\(){}<>+=`!#%?,:;'\"@" ;

	/**
	 * The static field used when throws an Error when filter failed.
	 */        
	static public var ERROR_FILTER:String = "Error for filter \''{0}'" ;
        
	/**
	 * The static field used when throws an Error when the character placement failed.
	 */        
	static public var CHAR_PLACEMENT:String = "'*' must be the right most character." ;

	/**
	 * In addition to the level setting, filters are used to provide a pseudo hierarchical mapping for processing only those events for a given category.
	 */
	public function get filters():Array 
	{
		return _filters ;	
	}
	
	/**
	 * (read-write) Sets the filters array of this target.
	 * If you use this virtual property the target is register in the {@code Log} singleton automatically.
	 */
	public function set filters( value:Array ):Void
	{
		
		if ( value != null && value.length > 0 )
		{
			var filter:String ;
			var index:Number ;
			var len:Number = value.length ;
			for (var i:Number = 0; i<len ; i++)
			{
				
				filter = value[i] ;
				// check for invalid characters
				if ( Log.hasIllegalCharacters(filter) )
				{
					throw new InvalidFilterError( (new StringFormatter(ERROR_FILTER)).format(filter) + CHARS_INVALID ) ;
				}
				index = filter.indexOf("*") ;
 				if ((index >= 0) && (index != (filter.length -1)))
                {                        
					throw new InvalidFilterError( (new StringFormatter(ERROR_FILTER)).format( filter) + CHAR_PLACEMENT ) ;
				}
			}
		}
		else
		{
			value = ["*"] ; // if null was specified then default to all
		}

		if ( _set.size() > 0 )
		{
			Log.removeTarget(this);
			_filters = value;
			Log.addTarget(this);
		}
		else
		{
			_filters = value;
		}
	}
        
	/**
	 * Provides access to the level this target is currently set at.
	 */
	public function get level():Number
	{
		return _level ;	
	}

	/**
	 * (read-write) Sets the level of this target.
	 * If you use this virtual property the target is register in the {@code Log} singleton automatically.
	 */
	public function set level( value:Number ):Void
	{
		Log.removeTarget(this) ;
		_level = value ;
		Log.addTarget(this) ;     
	} 

	/**
	 * Inserts a category in the fllters if this category don't exist.
	 * Returns a boolean if the category is add in the list.
	 */
	public function addCategory( category:String ):Boolean 
	{
		if ( _filters.indexOf( category ) == -1 ) 
		{
			return false ;
		}
		_filters.push( category ) ;
		return true ;
	}

	/**
	 * Sets up this target with the specified logger.
	 * Note : this method is called by the framework and should not be called by the developer.
	 */
	public function addLogger( logger:ILogger ):Void 
	{
		if ( !_set.contains(logger) )
		{
			_set.insert(logger) ;
			logger.addEventListener( LogEvent.LOG, this ) ;
		}
	}

	/**
	 * Add a new namespace in the filters array.
	 */
	public function addNamespace(namespace:String):Boolean 
	{
		if (filters == undefined) 
		{
			filters = [] ;
		}
		if ( ArrayUtil.contains(filters, namespace) ) 
		{
			return false ;
		}
		else
		{
			filters.push(namespace) ;
			return true ;
		}
	}

	/**
	 * This method is called whenever an event occurs of the type for which the EventListener interface was registered.
	 */
	public function handleEvent(e:Event) 
	{
		var event:LogEvent = LogEvent(e) ; 
		if (  event.level >= level )
		{
			var category:String = LogLogger(event.getTarget()).category ;
			var isValid:Boolean = _isValidCategory( category ) ;
			if (isValid)
			{
				logEvent( event ) ;
			}
		}
	}

    /**
     *  This method handles a <code>LogEvent</code> from an associated logger.
     *  <p>A target uses this method to translate the event into the appropriate format for transmission, storage, or display.</p>
     *  <p>This method will be called only if the event's level is in range of the target's level.</p>
     *  <p><b><i>Descendants need to override this method to make it useful.</i></b></p>
     */		
	public function logEvent(e:LogEvent):Void 
	{
		//
	}

	/**
	 * Removes a category in the fllters if this category exist.
	 * Returns a boolean if the category is remove.
	 */
	public function removeCategory( category:String ):Boolean
	{
		var pos:Number = _filters.indexOf( category ) ;
		if ( pos > -1) 
		{
			_filters.splice(pos, 1) ;
			return true ;
		}
		else 
		{
			return false ;
		}
	}

	/**
	 * Stops this target from receiving events from the specified logger.
	 * Note : this method is called by the framework and should not be called by the developer.
	 */
	public function removeLogger(logger:ILogger):Void 
	{
		if (_set.contains(logger))
		{
			_set.remove( logger ) ;
			logger.removeEventListener(LogEvent.LOG, this) ;
		}
	}

	/**
	 * Removes an existing namespace in the filters array.
	 */
	public function removeNamespace(namespace:String):Boolean 
	{
		var pos:Number = ArrayUtil.indexOf(filters, namespace) ;
		if ( pos > -1) 
		{
			filters.splice(pos, 1) ;
			return true ;
		} 
		else 
		{
			return false ;
		}
	}
	
	/**
	 * Returns 'true' is the passed argument is a valid category.
	 */
	private function _isValidCategory(category:String):Boolean 
	{
		
		if ( category == Log.DEFAULT_CATEGORY ) 
		{
			return true ;
		}
		
		var l:Number = filters.length ;
		if (l > 0) 
		{
			for (var i:Number = 0 ; i<l ; i++) 
			{
				var pattern:String = filters[i] ;
				var we:WildExp = new WildExp( pattern, WildExp.IGNORECASE | WildExp.MULTIWORD );
				var result = we.test( category ) ;
				if (result == true || pattern == category) 
				{
					return true ;
				}
			}
			return false ;
		} 
		else 
		{
			return true ;
		}
	}
		
	/**
	 * Storage for the filters property.
	 */
	private var _filters:Array ;
	
	/**
	 * Storage for the filters property.
	 */
	private var _level:Number ;
	
	private var _set:HashSet ;

}