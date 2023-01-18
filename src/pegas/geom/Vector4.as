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

import pegas.geom.Vector3;

import vegas.util.ConstructorUtil;
import vegas.util.serialize.Serializer;

/**
 * Represents a vector in a 3D world with the coordinates x, y, z and w.
 * @author eKameleon
 */
class pegas.geom.Vector4 extends Vector3
{
	
	/**
	 * Creates a new {@code Vector4} instance.
	 * @param x the x coordinate.
	 * @param y the y coordinate.
	 * @param z the z coordinate.
	 * @param z the w coordinate.
	 */ 	
	public function Vector4( x:Number, y:Number, z:Number , w:Number ) 
	{
		super(x, y , z);
		this.w = isNaN(w) ? 0 : w ;
	}

	/**
	 * Defined the w coordinate.
	 */
	public var w:Number;

	/**
	 * Returns a shallow copy of this instance.
	 * @return a shallow copy of this instance.
	 */
	public function clone()
	{
		return new Vector4(x, y, z, w) ;	
	}

	/**
	 * Returns a deep copy of this instance.
	 * @return a deep copy of this instance.
	 */
	public function copy()
	{
		return new Vector4(x, y, z, w) ;	
	}
	
	/**
	 * Compares the specified object with this object for equality.
	 * @return {@code true} if the the specified object is equal with this object.
	 */
	public function equals(o):Boolean 
	{
		if ( o instanceof Vector4)
		{
			return (o.x == x) && (o.y == y) && (o.z == z) && (o.w == w) ;
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
		return Serializer.getSourceOf(this, [x, y, z, w]) ;
	}

	/**
	 * Returns the string representation of the object.
	 * @return the string representation of the object.
	 */ 	
	public function toString():String
	{
		return "[" + ConstructorUtil.getName(this) + ":{" + x + "," + y + "," + z + "," + w + "}]" ;
	}

}