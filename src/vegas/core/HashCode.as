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

/**
 * Collected methods which allow easy implementation of {@code hashCode}.
 * @author eKameleon
 */
class vegas.core.HashCode 
{
	
	/**
	 * Compares two elements by the order of the hash code of the elements.
	 * @param o1 the first object.
	 * @param o2 the second object.
	 * @return <p>
	 * <li>-1 if o1 is "lower" than (less than, before, etc.) o2 ;</li>
	 * <li> 1 if o1 is "higher" than (greater than, after, etc.) o2 ;</li>
	 * <li> 0 if o1 and o2 are equal.</li>
	 * </p>
	 */
	static public function compare( o1, o2 ):Number
	{
		var a:Number = HashCode.identify(o1) ;
		var b:Number = HashCode.identify(o2) ;
		if (a < b)
		{
			return -1 ;
		}
		if (a > b)
		{
			return 1 ;	
		}
		else
		{
			return 0 ;	
		}
	}

	/**
	 * Compare two IHashable objects.
	 * <p><b>Example :</b></p>
	 * {@code var isEquals:Boolean = HashCode.equals(o1, o2) ; }
	 * @param   o1 the first value to compare.
	 * @param   o2 the second value to compare.
	 * @return {@code true} of the two object are equals.  
	 */
	static public function equals(o1, o2):Boolean 
	{
		return HashCode.identify(o1) == HashCode.identify(o2) ;
	}

	/**
	 * Indenfity the hashcode value of an object.
	 * @return the hashcode value of an object.
	 */
	static public function identify(o):Number 
	{
		return o["hashCode"]() ; 
	}
	
	/**
	 * Returns the next hashcode value.
	 * @return the next hashcode value.
	 */
	static public function next():Number 
	{
		return HashCode._nHash++ ;
	}

	/**
	 * Returns the string representation of the next hashcode value.
	 * @return the string representation of the next hashcode value.
	 */
	static public function nextName():String 
	{
		return String( HashCode._nHash + 1 ) ;
	}
	
	
	/**
	 * Initialize the hashcode value of an object.
	 * @return {@code true} if the method is called.
	 */
	static public function initialize(o):Boolean 
	{
		o["hashCode"] = function () 
		{
			if (isNaN(this.__hashcode__)) 
			{
				this.__hashcode__ = HashCode.next() ;
				_global.ASSetPropFlags(this, ["__hashcode__"], 7, 7) ;
			}
			return this.__hashcode__ ;
		} ;
		_global.ASSetPropFlags(o, ["__hashcode__", "hashCode"], 7, 7) ;
		return true ;
	}
	
	/**
	 * The internal hashcode counter.
	 */
	static private var _nHash:Number = 0 ;
	
	/**
	 * Launch the initialize of the Object.prototype object.
	 */
	static private var _init:Boolean = HashCode.initialize( Object.prototype ) ;
	
}