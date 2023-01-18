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

import pegas.geom.Vector4;

/**
 * Static tool class to manipulate and transform {@code Vector4} references.
 * @author eKameleon
 */
class pegas.util.Vector4Util 
{

	/**
	 * Computes the addition of two Vector4 and returns the first vector.
	 * @param v1 the first Vector4.
	 * @param v2 the second Vector4.
	 * @return the addition result of two Vector4.
	 */
	static public function addition( v1:Vector4, v2:Vector4 ):Vector4
	{
		 v1.x += v2.x ;
		 v1.y += v2.y ;
		 v1.z += v2.z ;
		 v1.w += v2.w ;
		 return v1 ;	
	}

	/**
	 * Returns the cross product of two Vector4.
	 * The returned Vector4 is orthogonal to the other two Vector4 and when ignoring the fourth 
	 * component the resulting Vector3 is also orthogonal.
	 */
	static public function cross(v1:Vector4, v2:Vector4):Vector4
	{
		v1.x = (v2.y * v1.z) - (v2.z * v1.y) ;
		v1.y = (v2.z * v1.x) - (v2.x * v1.z) ;
		v1.z = (v2.x * v1.y) - (v2.y * v1.x) ;
		v1.w = 0 ;
		return v1 ;
	}

	/**
	 * Computes the addition of two Vector4.
	 * @param v1 a Vector4 to concat.
	 * @param v2 a Vector4 to concat.
	 * @return the addition result of two Vector4.
	 */
	static public function getAddition( v1:Vector4, v2:Vector4 ):Vector4
	{
		return new Vector4( (v1.x + v2.x) , (v1.y + v2.y) , (v1.z + v2.z) , (v1.w + v2.w)) ;	
	}

	/**
	* Returns the angle in radian between the two 3D vectors. The formula used here is very simple.
	* It comes from the definition of the dot product between two vectors.
	* @param v1	Vector4 The first Vector4.
	* @param v2	Vector4 The second Vector4.
	* @return the angle in radian between the two vectors.
	*/
	static public function getAngle ( v1:Vector4, v2:Vector4 ):Number
	{
		var ncos:Number = ( Vector4Util.getDot( v1, v2 ) ) / ( getNorm(v1) * getNorm(v2) );
		var sin2:Number = 1 - (ncos * ncos) ;
		if (sin2<0)
		{
			trace(" wrong "+ ncos ) ;
			sin2 = 0 ;
		}
		// I took long time to find this bug. Who can guess that (1-cos*cos) is negative ? !
		// sqrt returns a NaN for a negative value !
		return  Math.atan2( Math.sqrt(sin2), ncos );
	}

	/**
	 * Computes the cross product of the two Vector4s.
	 * @param v1 a {@code Vector4}.
	 * @param v2 a {@code Vector4}.
	 * @return the {@code Vector4} resulting of the cross product.
	 */
	static public function getCross( v1:Vector4, v2:Vector4 ):Vector4
	{
		return new Vector4
		( 	
			(v2.y * v1.z) - (v2.z * v1.y) ,
			(v2.z * v1.x) - (v2.x * v1.z) ,
			(v2.x * v1.y) - (v2.y * v1.x) ,
			0
		);
	}

	/**
	 * Computes the dot product of the two Vector4s.
	 * @param v1 a {@code Vector4}.
	 * @param v2 a {@code Vector4}.
	 * @return the dot product of the 2 Vector4.
	 */
	static public function getDot( v1:Vector4, v2:Vector4 ):Number
	{
		return (v1.x * v2.x) + (v1.y * v2.y) + (v1.z * v2.z) + (v1.w * v2.w) ;	
	}

	/**
	 * Returns the length of the vector.
	 * @param v the vector.
	 * @return the length of the vector.
	 */
	static public function getLength( v:Vector4 ):Number
	{
		return Math.sqrt( (v.x * v.x) + (v.y * v.y) + (v.z * v.z) + (v.w * v.w) ) ;
	}

	/**
	 * Computes the oposite Vector4 of the {@code Vector4}.
	 * @param v the Vector4 reference to negate.
	 * @return a new negate {@code Vector4} reference.
	 */
	public static function getNegate( v:Vector4 ):Vector4
	{
		return new Vector4( - v.x, - v.y, - v.z , - v.w );
	}	

	/**
	 * Computes the norm of the {@code Vector4}.
	 * @param v a Vector4 reference.
	 * @return the norm of the specified {@code Vector4}.
	 */
	static public function getNorm( v:Vector4 ):Number
	{
		return Math.sqrt( (v.x * v.x) + (v.y * v.y) + (v.z * v.z) + (v.w * v.w) );
	}

	/**
	 * Computes the power of the specified Vector4.
	 * @param v the Vector4 reference.
	 * @param value the value of the pow..
	 * @return A new Vector4 powered by the method.
	 */
	static public function getPow( v:Vector4, value:Number ):Vector4
	{
		return new Vector4( Math.pow( v.x, value ) , Math.pow( v.y, value ) ,  Math.pow( v.z, value ) , Math.pow( v.w, value ) ) ;
	}

	/**
	 * Scales the specified Vector4 with the input value.
	 * @param vector the Vector4 reference to transform.
	 * @param value a real number to scale the current Vector4.
	 * @return A new Vector4 scaled by the value passed in second argument in this method.
	 */
	static public function getScale( v:Vector4, value:Number ):Vector4
	{
		return new Vector4 ( v.x * value , v.y * value , v.z * value , v.w * value ) ;
	}

	/**
	 * Returns the squared length of this vector.
	 * @param v the vector.
	 * @return the squared length of this vector.
	 */
	static public function getSquaredLength( v:Vector4 ):Number
	{
		return (v.x * v.x) + (v.y * v.y) + (v.z * v.z) + + (v.w * v.w) ;
	}

	/**
	 * Computes the substraction of two Vector4.
	 * @param v1 a Vector4 to substract.
	 * @param v2 a Vector4 to substract.
	 * @return the substraction result of two Vector4.
	 */
	static public function getSubstraction( v1:Vector4 , v2:Vector4 ):Vector4
	{
		return new Vector4( (v1.x - v2.x) , (v1.y - v2.y) , (v1.z - v2.z) , (v1.w - v2.w) ) ;
	}

	/**
	 * Normalize the specified {@code Vector4} in parameter.
	 * @param v a Vector4 reference.
	 * @return {@code true} of the normalize method is success else false for mistake.
	 */	
	static public function normalize( v:Vector4 ):Boolean
	{
		var norm:Number = getNorm( v );
		if( norm == 0 || norm == 1) 
		{
			return false ;
		}
		v.x /= norm ;
		v.y /= norm ;
		v.z /= norm ;
		v.w /= norm ;
		return true ;
	}
	
	/**
	 * Sets the specified {@code Vector4} object with the second {@code Vector4} object passed in argument.
	 * @param v1 the first {@code Vector4}.
	 * @param v2 the second {@code Vector4}.
	 * @return the first {@code Vector4} transformed.
	 */
	static public function setByVector4( v1:Vector4, v2:Vector4):Vector4
	{
		v1.x = v2.x ;
		v1.y = v2.y ;
		v1.z = v2.z ;
		v1.w = v2.w ;
		return v1 ;
	}

	/**
	 * Scales the specified Vector4 with the input value.
	 * @param vector the Vector4 reference to transform.
	 * @param value a real number to scale the current Vector4.
	 */
	static public function scale( v:Vector4, value:Number ):Void
	{
		v.x *= value ;
		v.y *= value ;
		v.z *= value ;
		v.w *= value ;
	}
	
	/**
	 * Computes the substraction of two Vector4.
	 * @param v1 the first Vector3.
	 * @param v2 the second Vector3.
	 * @return the substraction result of two Vector3.
	 */
	static public function substraction( v1:Vector4 , v2:Vector4 ):Vector4
	{
		 v1.x -= v2.x ;
		 v1.y -= v2.y ;
		 v1.z -= v2.z ;
		 v1.w -= v2.w ;
		 return v1 ;	
	}

}