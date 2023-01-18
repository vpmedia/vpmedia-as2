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
 * Represents a vector in a 2D world with the coordinates x, y.
 * @author eKameleon
 */
class pegas.geom.Vector2 extends CoreObject implements ICloneable, ICopyable, IEquality
{
	
	/**
	 * Creates a new {@code Vector2} instance.
	 * @param x the x coordinate.
	 * @param y the y coordinate.
	 */ 	
	public function Vector2( x:Number, y:Number ) 
	{
		super();
		this.x = isNaN(x) ? 0 : x ;
		this.y = isNaN(y) ? 0 : y ;
	}

	/**
	 * Defined the x coordinate.
	 */
	public var x:Number;

	/**
	 * Defined the y coordinate.
	 */
	public var y:Number;

	/**
	 * Returns a shallow copy of this instance.
	 * @return a shallow copy of this instance.
	 */
	public function clone()
	{
		return new Vector2(x, y) ;	
	}

	/**
	 * Returns a deep copy of this instance.
	 * @return a deep copy of this instance.
	 */
	public function copy()
	{
		return new Vector2(x, y) ;	
	}
	
	/**
	 * Compares the specified object with this object for equality.
	 * @return {@code true} if the the specified object is equal with this object.
	 */
	public function equals(o):Boolean 
	{
		if ( o instanceof Vector2)
		{
			return (o.x == x) && (o.y == y) ;
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
		return Serializer.getSourceOf(this, [x, y]) ;
	}

	/**
	 * Returns the string representation of the object.
	 * @return the string representation of the object.
	 */ 	
	public function toString():String
	{
		return "[" + ConstructorUtil.getName(this) + ":{" + x + "," + y + "}]" ;
	}

}