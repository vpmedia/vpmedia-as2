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
import vegas.errors.NumberFormatError;
import vegas.util.serialize.Serializer;

/**
 * {@code Integer} represents an integer value.
 * <p>A integer is a positive or negative natural number including 0.</p>
 * @author eKameleon
 */
class vegas.core.types.Int extends Number implements IFormattable, IHashable, ISerializable {

	/**
	 * Creates a new Int instance.
	 * @param n the number to convert to an Int.
	 * @throws NumberFormatError if the value passed in argument is Infinity or -Infinity
	 */
	public function Int(n:Number) 
	{
		if (n == Infinity || n == -Infinity) 
		{
			throw new NumberFormatError("Int constructor failed, the value of this Int can't be Infinity of -Infinity.") ;
		}
		else 
		{
			_int = n - n%1 ;
		}
	}
	
	/**
	 * Returns a hash code value for the object.
	 */
	public function hashCode():Number 
	{
		return null ;
	}

	/**
	 * Returns a Eden representation of the object.
	 * @return a string representing the source code of the object.
	 */
	public function toSource(indent : Number, indentor : String) : String 
	{
		return Serializer.getSourceOf(this, _getParams()) ;
	}	

	/**
	 * Returns a string representation of the object.
	 */
	public function toString():String 
	{
		return _int.toString() ;
	}

	/**
	 * Returns the real value of the object.
	 */
	public function valueOf() 
	{
		return _int ;
	}
	
	/**
	 * The internal value of the object.
	 */	
	private var _int:Number ;

	/**
	 * Init the hashcode representation of the class.
	 */
	static private var _initHashCode:Boolean = HashCode.initialize(Int.prototype) ;

	/**
	 * Returns a array of all values used by the toSource method. 
	 */
	/*protected*/ private function _getParams():Array 
	{
		return [ Serializer.toSource(_int) ] ;
	}

}