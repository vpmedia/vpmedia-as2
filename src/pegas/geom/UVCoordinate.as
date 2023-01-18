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
import vegas.util.ConstructorUtil;
import vegas.util.serialize.Serializer;

/**
 * Coordinate system for bitmaps. It represents the position of a vertex in the Bitmap.
 * @author eKameleon
 */
class pegas.geom.UVCoordinate extends CoreObject 
{
	
	/**
	 * Creates a new UVCoordinate instance.
	 */
	public function UVCoordinate( u:Number, v:Number ) 
	{
		super();
		this.u = u ;
		this.v = v ;
	}

	/**
	 * Defined the u coordinate.
	 */
	public var u:Number ;
	
	/**
	 * Defined the v coordinate.
	 */
	public var v:Number ;

	/**
	 * Returns a shallow copy of this instance.
	 * @return a shallow copy of this instance.
	 */
	public function clone()
	{
		return new UVCoordinate(u,v) ;	
	}

	/**
	 * Returns a deep copy of this instance.
	 * @return a deep copy of this instance.
	 */
	public function copy()
	{
		return new UVCoordinate(u,v) ;	
	}
	
	/**
	 * Compares the specified object with this object for equality.
	 * @return {@code true} if the the specified object is equal with this object.
	 */
	public function equals(o):Boolean 
	{
		if ( o instanceof UVCoordinate)
		{
			return (o.u == u) && (o.v == v) ;
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
		return Serializer.getSourceOf(this, [u, v]) ;
	}

	/**
	 * Returns the string representation of the object.
	 * @return the string representation of the object.
	 */ 	
	public function toString(Void):String
	{
		return "[" + ConstructorUtil.getName(this) + ":{" + u + "," + v + "}]" ;
	}

}