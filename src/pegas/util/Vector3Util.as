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

/**
 * Static tool class to manipulate and transform {@code Vector3} references.
 * @author eKameleon
 */
class pegas.util.Vector3Util 
{

	/**
	 * Computes the addition of two Vector3 and returns the first vector.
	 * @param v1 the first Vector3.
	 * @param v2 the second Vector3.
	 * @return the addition result of two Vector3.
	 */
	static public function addition( v1:Vector3, v2:Vector3 ):Vector3
	{
		 v1.x += v2.x ;
		 v1.y += v2.y ;
		 v1.z += v2.z ;
		 return v1 ;	
	}

	/**
	 * Computes the addition of two Vector3.
	 * @param v1 a Vector3 to concat.
	 * @param v2 a Vector3 to concat.
	 * @return the addition result of two Vector3.
	 */
	static public function getAddition( v1:Vector3, v2:Vector3 ):Vector3
	{
		return new Vector3( (v1.x + v2.x) , (v1.y + v2.y) , (v1.z + v2.z) ) ;	
	}

	/**
	* Returns the angle in radian between the two 3D vectors. The formula used here is very simple.
	* It comes from the definition of the dot product between two vectors.
	* @param v1	Vector3 The first Vector3.
	* @param v2	Vector3 The second Vector3.
	* @return the angle in radian between the two vectors.
	*/
	static public function getAngle ( v1:Vector3, v2:Vector3 ):Number
	{
		var ncos:Number = ( Vector3Util.getDot( v1, v2 ) ) / ( getNorm(v1) * getNorm(v2) );
		var sin2:Number = 1 - (ncos * ncos) ;
		if (sin2<0)
		{
			// trace(" wrong "+ ncos ) ;
			sin2 = 0 ;
		}
		// I took long time to find this bug. Who can guess that (1-cos*cos) is negative ? !
		// sqrt returns a NaN for a negative value !
		return  Math.atan2( Math.sqrt(sin2), ncos );
	}

	/**
	 * Computes the cross product of the two Vector3s.
	 * @param v1 a {@code Vector3}.
	 * @param v2 a {@code Vector3}.
	 * @return the {@code Vector3} resulting of the cross product.
	 */
	static public function getCross( v1:Vector3, v2:Vector3 ):Vector3
	{
		return new Vector3
		( 	
			(v2.y * v1.z) - (v2.z * v1.y) ,
			(v2.z * v1.x) - (v2.x * v1.z) ,
			(v2.x * v1.y) - (v2.y * v1.x)
		);
	}
	
	/**
	 * Computes the dot product of the two Vector3s.
	 * @param v1 a {@code Vector3}.
	 * @param v2 a {@code Vector3}.
	 * @return the dot product of the 2 Vector3.
	 */
	static public function getDot( v1:Vector3, v2:Vector3 ):Number
	{
		return (v1.x * v2.x) + (v1.y * v2.y) + (v1.z * v2.z) ;	
	}

	/**
	 * Returns the length of the vector.
	 * @param v the vector.
	 * @return the length of the vector.
	 */
	static public function getLength( v:Vector3 ):Number
	{
		return Math.sqrt( (v.x * v.x) + (v.y * v.y) + (v.z * v.z) ) ;
	}

	/**
	 * Computes the oposite Vector3 of the {@code Vector3}.
	 * @param v the Vector3 reference to negate.
	 * @return a new negate {@code Vector3} reference.
	 */
	public static function getNegate( v:Vector3 ):Vector3
	{
		return new Vector3( - v.x, - v.y, - v.z );
	}	

	/**
	 * Computes the norm of the {@code Vector3}.
	 * @param v a Vector3 reference.
	 * @return the norm of the specified {@code Vector3}.
	 */
	static public function getNorm( v:Vector3 ):Number
	{
		return Math.sqrt( (v.x * v.x) + (v.y * v.y) + (v.z * v.z) );
	}

	/**
	 * Computes the power of the specified Vector3.
	 * @param v the Vector3 reference.
	 * @param value the value of the pow..
	 * @return A new Vector3 powered by the method.
	 */
	static public function getPow( v:Vector3, value:Number ):Vector3
	{
		return new Vector3( Math.pow( v.x, value ) , Math.pow( v.y, value ) ,  Math.pow( v.z, value ) ) ;
	}

	/**
	 * Scales the specified Vector3 with the input value.
	 * @param vector the Vector3 reference to transform.
	 * @param value a real number to scale the current Vector3.
	 * @return A new Vector3 scaled by the value passed in second argument in this method.
	 */
	static public function getScale( v:Vector3, value:Number ):Vector3
	{
		return new Vector3 ( v.x * value , v.y * value , v.z * value ) ;
	}

	/**
	 * Returns the squared length of this vector.
	 * @param v the vector.
	 * @return the squared length of this vector.
	 */
	static public function getSquaredLength( v:Vector3 ):Number
	{
		return (v.x * v.x) + (v.y * v.y) + (v.z * v.z) ;
	}

	/**
	 * Computes the substraction of two Vector3.
	 * @param v1 a Vector3 to substract.
	 * @param v2 a Vector3 to substract.
	 * @return the substraction result of two Vector3.
	 */
	static public function getSubstraction( v1:Vector3 , v2:Vector3 ):Vector3
	{
		return new Vector3( (v1.x - v2.x) , (v1.y - v2.y) , (v1.z - v2.z) ) ;
	}

	/**
	 * Normalize the specified {@code Vector3} in parameter.
	 * @param v a Vector3 reference.
	 * @return {@code true} of the normalize method is success else false for mistake.
	 */	
	static public function normalize( v:Vector3 ):Boolean
	{
		var norm:Number = getNorm( v );
		if( norm == 0 || norm == 1) 
		{
			return false ;
		}
		v.x /= norm ;
		v.y /= norm ;
		v.z /= norm ;
		return true ;
	}

	/**
	 * Sets the specified {@code Vector3} object with the second {@code Vector3} object passed in argument.
	 * @param v1 the first {@code Vector3}.
	 * @param v2 the second {@code Vector3}.
	 * @return the first {@code Vector3} transformed.
	 */
	static public function setByVector3( v1:Vector3, v2:Vector3):Vector3
	{
		v1.x = v2.x ;
		v1.y = v2.y ;
		v1.z = v2.z ;
		return v1 ;
	}

	/**
	 * Scales the specified Vector3 with the input value.
	 * @param vector the Vector3 reference to transform.
	 * @param value a real number to scale the current Vector3.
	 */
	static public function scale( v:Vector3, value:Number ):Void
	{
		v.x *= value ;
		v.y *= value ;
		v.z *= value ;
	}

	/**
	 * Computes the substraction of two Vector3.
	 * @param v1 the first Vector3.
	 * @param v2 the second Vector3.
	 * @return the substraction result of two Vector3.
	 */
	static public function substraction( v1:Vector3 , v2:Vector3 ):Vector3
	{
		 v1.x -= v2.x ;
		 v1.y -= v2.y ;
		 v1.z -= v2.z ;
		 return v1 ;	
	}

}