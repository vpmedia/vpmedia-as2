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

import vegas.data.map.HashMap;
import vegas.errors.ArgumentsError;
import vegas.errors.Warning;
import vegas.logging.errors.InvalidCategoryError;
import vegas.logging.ILogger;
import vegas.logging.ITarget;
import vegas.logging.LogLogger;
import vegas.util.StringUtil;

/**
 * Provides pseudo-hierarchical logging capabilities with multiple format and output options.
 * @author eKameleon
 */
class vegas.logging.Log 
{

	/**
	 * const The default categoty of the {@code ILogger} instances returns with the {@code getLogger} method.
	 */
	static public var DEFAULT_CATEGORY:String = "" ;
	
	/**
	 * const The string representation of all the illegal characters.
	 */
	static public var ILLEGALCHARACTERS:String = "[]~$^&/\\(){}<>+=`!#%?,:;'\"@" ;

	/**
	 * The static field used when throws an Error when a character is invalid.
	 */     
	static public var INVALID_CHARS:String = "Categories can not contain any of the following characters : []~$^&/\\(){}<>+=`!#%?,:;'\"@" ;
      
	/**
	 * The static field used when throws an Error when the length of one character is invalid.
	 */     
    static public var INVALID_LENGTH:String = "Categories must be at least one character in length." ;

    /**
	 * The static field used when throws an Error when the specified target is invalid.
	 */     
    static public var INVALID_TARGET:String = "Log, Invalid target specified." ;

	/**
	 * The static field used when throws a Warning when the specified target is invalid.
	 */
	static public var REMOVE_TARGET_FAILED:String = "The target is invalid, isn't register for the moment, you can't remove it" ;

	/**
	 * Allows the specified target to begin receiving notification of log events.
	 * @param target specific target that should capture log events.
	 */
	static public function addTarget( target:ITarget ):Void 
	{
		if (target != null)
		{
			target.addLogger( _logger ) ;
		}
		else
		{
			throw new ArgumentsError( INVALID_TARGET );
		}
	}

	/**
	 * This method removes all of the current loggers from the cache.
	 */
	static public function flush():Void 
	{
		_categories.clear() ;
	}
	
	/**
	 * Returns the logger associated with the specified category.
	 * If the category given doesn't exist a new instance of a logger will be returned and associated with that category. Categories must be at least one character in length and may not contain any blanks or any of the following characters: []~$^&\/(){}<>+=`!#%?,:;'"@
	 * @param The String to check for illegal characters. The following characters are not valid: []~$^&\/(){}<>+=`!#%?,:;'"@ 
	 * @return An instance of a logger object for the specified name. If the name doesn't exist, a new instance with the specified name is returned.
	 * @throws InvalidCategoryError if the category specified is malformed.
	 */
	static public function getLogger(category:String, isQueue:Boolean):ILogger 
	{
		
		checkCategory( category ) ;
		
		if( !_categories.containsKey(category) )
		{
			var logger:LogLogger = new LogLogger(category) ;
			logger.isQueue = isQueue ;
			logger.parent = _logger ; // bubbling event.
			_categories.put(category, logger) ;
		}
		return _categories.get(category) ;
	}

	/**
	 * This method checks the specified string value for illegal characters.
	 * @param value The String to check for illegal characters. The following characters are not valid: []~$^&\/(){}<>+=`!#%?,:;'"@
	 * @return {@code true} if there are any illegal characters found, false otherwise.
	 */
	static public function hasIllegalCharacters(value:String):Boolean 
	{
		return StringUtil.indexOfAny( value, ILLEGALCHARACTERS.split("") ) != -1 ;
	}

	/**
	 * Stops the specified target from receiving notification of log events.
	 * @param specific target that should capture log events.
	 */
	static public function removeTarget(target:ITarget):Void 
	{
		if( target != null )
		{
			target.removeLogger( _logger ) ;
		}
		else
		{
			throw new Warning( REMOVE_TARGET_FAILED ) ;	
		}
	}
	
	/**
	 * Returns the string representation of this instance.
	 * @return the string representation of this instance
	 */
	static public function toString():String 
	{
		return "[Log]" ;
	}

	/**
	 * The internal categories HashMap.
	 */
	static private var _categories:HashMap = new HashMap() ;

	/**
	 * The internal logger.
	 */
	static private var _logger:LogLogger = new LogLogger() ;

	/**
	 * Sentinal value for the target log level to indicate no logging.
	 */
	static private var NONE:Number = Number.MAX_VALUE;
        
	/**
	 * The most verbose supported log level among registered targets.
	 */
    static private var _targetLevel:Number = Number.MAX_VALUE ;

    /**
	 * This method will ensure that a valid category string has been specified.
	 * If the category is not valid an <code>InvalidCategoryError</code> will be thrown.
	 * Categories can not contain any blanks or any of the following characters: []`*~,!#$%^&amp;()]{}+=\|'";?&gt;&lt;./&#64; 
	 * or be less than 1 character in length.
	 */
    static private function checkCategory(category:String):Void
	{
            
		if(category == null || category.length == 0)
		{
			throw new InvalidCategoryError( INVALID_LENGTH ) ;
		}
		
		if( hasIllegalCharacters(category) || (category.indexOf("*") != -1))
        {
        	throw new InvalidCategoryError( INVALID_CHARS ) ;
		}
            
	}


}