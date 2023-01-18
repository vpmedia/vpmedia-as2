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

import vegas.core.HashCode;
import vegas.core.IFormattable;
import vegas.core.IHashable;
import vegas.errors.ErrorElement;
import vegas.errors.ErrorFormat;
import vegas.logging.ILogable;
import vegas.logging.ILogger;
import vegas.logging.Log;
import vegas.logging.LogEventLevel;
import vegas.util.ConstructorUtil;

/**
 * This class provides a Abstract implementation to creates Error classes with an internal logging model. 
 * @author eKameleon
 */
class vegas.errors.AbstractError extends Error implements IFormattable, IHashable, ILogable
{
    
	/**
	 * Creates a new AbstractError only if you inherit this class.
	 */
	private function AbstractError(message:String, e:ErrorElement) 
	{
		this.message = message ;
		this.errorElement = e ;
		this.name = ConstructorUtil.getName(this) ;
		this._logger = Log.getLogger( ConstructorUtil.getPath(this) ) ;
	}

	/**
	 * Launch HashCode 'initialize' method.
	 */	
	static private var _initHashCode:Boolean = HashCode.initialize(AbstractError.prototype) ;

	/**
	 * The internal ErrorElement reference.
	 */
	public var errorElement:ErrorElement ;
	
	/**
	 * Launch the external log of this error.
	 */
	public function log():Void
	{
		getLogger().log( getLevel() , "# " + name + " : " + message + " #" ) ;
	}
	
	/**
	 * Returns the internal ILogger of the current Error.
	 * @return the internal ILogger of the current Error.
	 */
	public function getLogger():ILogger
	{
		return _logger ; 	
	}
	
	/**
	 * Returns the internal LogEventLevel used in the constructor of this instance.
	 * You can overrides this method if you want change the internal LogEventLevel of the error.
	 */
	public function getLevel():Number
	{
		return LogEventLevel.ERROR ;	
	}
	
	/**
	 * Returns a hashcode value for the object.
	 * @return a hashcode value for the object.
	 */
	public function hashCode():Number 
	{
		return null ;
	}
	
	/**
	 * Sets the internal {@code ILogger} reference of this {@code ILogable} object.
	 */
	public function setLogger( log:ILogger ):Void 
	{
		_logger = log ;
	}

	/**
	 * Returns the string representation of this instance.
	 * @return the string representation of this instance
	 */
	public function toString():String 
	{
		if ( arguments.caller == null)
		{
			log() ;
		}
		return (new ErrorFormat()).formatToString(this) ;
	}

	private var _logger:ILogger ;

}
