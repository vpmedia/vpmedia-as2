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
import vegas.util.ConstructorUtil;

/**
 * An object of type Char contains a single field whose type is String.
 * @author eKameleon
 */
class vegas.core.types.Char extends String implements IFormattable, IHashable, ISerializable 
{

	/**
	 * Creates a new Char instance.
	 */
	public function Char(s:String) 
	{
		_char = (s || "").substring(0, 1) ;
	}

	/**
	 * Init the hashcode representation of the class.
	 */
	static private var _initHashCode:Boolean = HashCode.initialize(Char.prototype) ;
	
	/**
	 * Returns the integer character code for the character.
	 */
	public function getCode():Number 
	{
		return _char.charCodeAt(0) ;
	}

	/**
	 * Returns a hash code value for the object.
	 */
	public function hashCode():Number 
	{
		return null ;
	}
	
	/**
	 * Returns a Eden reprensation of the object.
	 * @return a string representing the source code of the object.
	 */
	public function toSource(indent:Number, indentor:String):String
	{
		return "new " + ConstructorUtil.getPath(this) + "(" + _char + ")" ;
	}

	/**
	 * Returns the string representation of this instance.
	 * @return the string representation of this instance
	 */
	public function toString():String 
	{
		return _char.toString() ;
	}

	/**
	 * Returns the real value of the object.
	 */
	public function valueOf() 
	{
		return _char.valueOf() ;
	}
	
	/**
	 * Internal string object.
	 */
	private var _char:String ;
	
}