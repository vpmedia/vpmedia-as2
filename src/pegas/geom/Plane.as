/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is PEGAS Framework.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <vegas@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2007
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

import vegas.core.CoreObject;
import vegas.core.ICloneable;
import vegas.core.ICopyable;
import vegas.core.IEquality;
import vegas.util.ConstructorUtil;
import vegas.util.serialize.Serializer;

/**
 * Plane representation is a two-dimensional doubly ruled surface in a 3D space. 
 * Used maily to represent the frustrum planes of the camera.
 * @author eKameleon
 */
class pegas.geom.Plane extends CoreObject implements ICloneable, ICopyable, IEquality
{
	
	/**
	 * Creates a new {@code Plane} instance.
	 * @param a the first plane coordinate.
	 * @param b the second plane coordinate.
	 * @param c the third plane coordinate.
	 * @param d the forth plane coordinate.
	 */ 
	public function Plane( a:Number, b:Number, c:Number, d:Number ) 
	{
		this.a = isNaN(a) ? 0 : a ;
		this.b = isNaN(a) ? 0 : b ;
		this.c = isNaN(a) ? 0 : c ;
		this.d = isNaN(a) ? 0 : d ;
	}

	/**
	 * Defined the first plane coordinate.
	 */
	public var a:Number ;

	/**
	 * Defined the second plane coordinate.
	 */
	public var b:Number ;
	
	/**
	 * Defined the third plane coordinate.
	 */
	public var c:Number ;

	/**
	 * Defined the forth plane coordinate.
	 */
	public var d:Number ;

	/**
	 * Returns a shallow copy of this instance.
	 * @return a shallow copy of this instance.
	 */
	public function clone()
	{
		return new Plane(a, b, c, d) ;	
	}

	/**
	 * Returns a deep copy of this instance.
	 * @return a deep copy of this instance.
	 */
	public function copy()
	{
		return new Plane(a, b, c, d) ;	
	}
	
	/**
	 * Compares the specified object with this object for equality.
	 * @return {@code true} if the the specified object is equal with this object.
	 */
	public function equals(o):Boolean 
	{
		if ( o instanceof Plane)
		{
			return (o.a == a) && (o.b == b) && (o.c == c) && (o.d == d) ;
		}
		else
		{
			return false ;	
		} 	
	}

	/**
	 * Returns a Eden reprensation of the object.
	 * @return a string representing the source code of the object.
	 */
	public function toSource(indent : Number, indentor : String):String 
	{
		return Serializer.getSourceOf(this, [a, b, c, d]) ;
	}

	/**
	 * Returns the string representation of the object.
	 * @return the string representation of the object.
	 */ 	
	public function toString():String
	{
		return "[" + ConstructorUtil.getName(this) + ":{" + a + "," + b + "," + c + "," + d + "}]" ;
	}

}