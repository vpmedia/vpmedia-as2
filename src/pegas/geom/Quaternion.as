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
 * Quaternions are hypercomplex numbers used to represent spatial rotations in three dimensions.
 * @author eKameleon
 */
class pegas.geom.Quaternion extends Vector3
{
	
	/**
	 * Creates a new {@code Vector3} instance.
	 * @param x the x coordinate.
	 * @param y the y coordinate.
	 * @param z the z coordinate.
	 * @param w the transform component of the quaternion.
	 */ 
	public function Quaternion( x:Number, y:Number, z:Number, w:Number ) 
	{
		super(x, y, z);
		this.w = isNaN(w) ? 0 : w ;
	}
	
	/**
	 * Represents the w component of the quaternion.
	 */
	public var w:Number ;

	/**
	 * Returns a shallow copy of this instance.
	 * @return a shallow copy of this instance.
	 */
	public function clone()
	{
		return new Quaternion(x, y, z, w) ;	
	}

	/**
	 * Returns a deep copy of this instance.
	 * @return a deep copy of this instance.
	 */
	public function copy()
	{
		return new Quaternion(x, y, z, w) ;	
	}
	
	/**
	 * Compares the specified object with this object for equality.
	 * @return {@code true} if the the specified object is equal with this object.
	 */
	public function equals( o ):Boolean
	{
		if ( o instanceof Quaternion)
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

	// Inspired by the MSDN documentation : <http://msdn2.microsoft.com/en-us/library/microsoft.windowsmobile.directx.quaternion_methods.aspx>
	// TODO static adds() : Adds two quaternions.
	// OK conjugate() : Returns the conjugate of a quaternion.
	// TODO dot() : Returns the dot product of two quaternions.
	// TODO exp() : Calculates the exponential of a quaternion.
	// TODO invert() : Conjugates and renormalizes a quaternion.
	// TODO ln() : Calculates the natural logarithm of a quaternion.
	// ok multiply() : Determines the product of two quaternions.
	// OK normalize() : Creates the norm of a quaternion.
	// TODO substraction() : Substracts two quaternions.
	// TODO unaryNegation() : Returns the negation of the specified quaternion.
	// ok rotationAxis() : Builds a quaternion is rotated around an arbitary axis.
	// TODO rotationMatrix : Builds a quaternion from a rotation matrix.
	// TODO rotationYawPicthRoll : Builds a quaternion with the given yaw, pitch and roll. ??
	// TODO slerp() : Interpolates between two quaternions, using spherical linear interpolation.
	// TODO size() : Returns the length of a quaternion.
	// TODO sizeSquare() : Returns the square of the length of a quaternion.
	// TODO squad() : Interpolates between quaternions, using spherical quadrangle interpolation.
	// TODO squadSetup() : Sets up control points for spherical quadrange interpolation.
	// TODO static substract() : Substracts two quaternion instances.
	

}