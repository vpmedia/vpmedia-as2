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
import vegas.core.ISerializable;
import vegas.logging.ILogable;
import vegas.logging.ILogger;
import vegas.util.ConstructorUtil;

/**
 * CoreObject offers a default implementation of the IFormattable, IHashable and ISerializable interfaces.
 * <p>
 * {@code
 * import vegas.core.CoreObject ;
 *  
 * var core:CoreObject = new CoreObject() ;
 * trace("> core : " + core) ;
 * trace("> hashcode : " + core.hashCode()) ;
 * trace("> toSource : " + core.toSource()) ;
 * }
 * </p>
 * @author eKameleon
 */
class vegas.core.CoreObject implements IFormattable, IHashable, ILogable, ISerializable 
{

	/**
	 * Creates a new CoreObject instance.
	 */
	public function CoreObject() 
	{
		//
	}

	/**
	 * Returns the internal {@code ILogger} reference of this {@code ILogable} object.
	 * @return the internal {@code ILogger} reference of this {@code ILogable} object.
	 */
	public function getLogger():ILogger
	{
		return _logger ; 	
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
	 * Returns a Eden reprensation of the object.
	 * @return a string representing the source code of the object.
	 */
	public function toSource(indent : Number, indentor : String):String 
	{
		return "new " + ConstructorUtil.getPath(this) + "()" ;
	}
	
	/**
	 * Returns the string representation of this instance.
	 * @return the string representation of this instance.
	 */
	public function toString():String 
	{
		return "[" + ConstructorUtil.getName(this) + "]" ;
	}

	/**
	 * The internal ILogger reference of this object.
	 */
	private var _logger:ILogger ;

	static private var _initHashCode:Boolean = HashCode.initialize(CoreObject.prototype) ;
	
}