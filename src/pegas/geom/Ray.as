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
import pegas.util.Vector3Util;

import vegas.core.CoreObject;
import vegas.core.ICloneable;
import vegas.core.ICopyable;
import vegas.core.IEquality;
import vegas.util.ConstructorUtil;
import vegas.util.serialize.Serializer;

/**
 * This means half of a line, it is infinite in one direction, but ends at a certain point in the other direction.
 * In Euclidean geometry, a ray (or half-line) given two distinct points A (the origin) and B on the ray, is the set of points C on the line containing points A and B such that A is not strictly between C and B. 
 * In geometry, a ray starts at one point, then goes on forever in one direction : (A) -- (B) -- ((C)) -->
 * @author eKameleon
 */
class pegas.geom.Ray extends CoreObject implements ICloneable, ICopyable, IEquality
{
	
	/**
	 * Creates a new Ray instance.
	 * <p><b>Usage :</b></p>
	 * <p>With a Ray object passed in the argument of the constructor :</p>
	 * {@code
	 * var r:Ray = new Ray( r:Ray) ;
	 * }
	 * <p>With 2 Vector3 objects passed in the arguments of the constuctor : </p>
	 * {@code
	 * var r:Ray = new Ray( r:Vector3 , p:Vector3 ) ;
	 * }
	 */
	public function Ray() 
	{
		p = new Vector3() ;
		v = new Vector3() ;
		if ( arguments[0] instanceof Ray )
		{
			var r:Ray = arguments[0] ;
			p = r.p ;
			v = r.v ;
		}
		else if ( arguments.length == 2)
		{
			if (arguments[0] instanceof Vector3)
			{
				p = arguments[0].clone() ;
			}			
			if (arguments[1] instanceof Vector3)
			{
				v = arguments[1].clone() ;
			}
		}
		update() ;
	}

	/**
	 * Determinates the p {@code Vector3} of the Ray object.
	 */
	public var p:Vector3 ;

	/**
	 * Determinates the q {@code Vector3} of the Ray object.
	 */
	public var q:Vector3 ;	
	
	/**
	 * Determinates the v {@code Vector3} of the Ray object.
	 */	
	public var v:Vector3 ;
	
	/**
	 * Returns a shallow copy of this instance.
	 * @return a shallow copy of this instance.
	 */
	public function clone()
	{
		return new Ray( this ) ;
	}

	/**
	 * Returns a deep copy of this instance.
	 * @return a deep copy of this instance.
	 */
	public function copy()
	{
		var r:Ray = new Ray() ;
		r.p = p.clone() ;
		r.q = q.clone() ;
		r.v = v.clone() ;
		return r ;
	}

	/**
	 * Compares the specified object with this object for equality.
	 * @return {@code true} if the the specified object is equal with this object.
	 */
	public function equals(o):Boolean 
	{
		if (o instanceof Ray)
		{
			return p.equals(o.p) && v.equals(o.v) && q.equals(o.q) ;  
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
		return Serializer.getSourceOf(this, [p.toSource(), v.toSource()]) ;
	}

	/**
	 * Returns the string representation of the object.
	 * @return the string representation of the object.
	 */ 	
	public function toString():String
	{
		return "[" + ConstructorUtil.getName(this) + ":" + p + " + t * " + v + "]" ;
	}

	/**
	 * Updates the Ray object.
	 */
	public function update():Void
	{
		if (q != null)
		{
			Vector3Util.setByVector3(q, p) ;
			Vector3Util.addition(q, v) ;
		}
		else
		{
			q = Vector3Util.getAddition(p, v) ;	
		}
	}

}