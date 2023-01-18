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

import pegas.geom.Quaternion;
import pegas.geom.Vector3;
import pegas.util.Vector3Util;

/**
 * Static tool class to manipulate and transform {@code Quaternion} references.
 * @author eKameleon
 */
class pegas.util.QuaternionUtil 
{
	
	/**
	 * Change the specified Quaterion in this conjugate.
	 */
	static public function conjugate( q:Quaternion ):Void
	{
		q.x = -q.x ;
		q.y = -q.y ;
		q.z = -q.z ;
	}

	/**
	 * Returns a new Quaternion conjugate of the specified Quaternion.
	 * @return a new Quaternion conjugate of the specified Quaternion.
	 */
	static public function getConjugate( q:Quaternion ):Quaternion
	{
		return new Quaternion( -q.x, -q.y, -q.z, q.w );
	}

	/**
	 * Returns the magnitude of the Quaternion, measured in the Euclidean norm.
	 * @return the magnitude of the Quaternion, measured in the Euclidean norm.
	 */
	static public function getMagnitude( q:Quaternion ):Number
	{
		var w:Number = q.w ;
		var x:Number = q.x ;
		var y:Number = q.y ;
		var z:Number = q.z ;
		return Math.sqrt( w*w + x*x + y*y + z*z ) ;
	}

	/**
	 * Returns the multiplication of two Quaternions.
	 * @return the multiplication of two Quaternions.
	 */
	static public function getMultiply( q1:Quaternion , q2:Quaternion ):Quaternion
	{
		var x1:Number = q1.x ; var y1:Number = q1.y ;
		var z1:Number = q1.z ; var w1:Number = q1.w ;
		
		var x2:Number = q2.x ; var y2:Number = q2.y ;
		var z2:Number = q2.z ; var w2:Number = q2.w ;
		
		return new Quaternion
		(
			( w1 * x2 ) + ( x1 * w2 ) + ( y1 * z2 ) - ( z1 * y2 ) ,
			( w1 * y2 ) + ( y1 * w2 ) + ( z1 * x2 ) - ( x1 * z2 ) ,
			( w1 * z2 ) + ( z1 * w2 ) + ( x1 * y2 ) - ( y1 * x2 ) ,
			( w1 * w2 ) - ( x1 * x2 ) - ( y1 * y2 ) - ( z1 * z2 )
		) ;
	}

	/**
	 * Returns the multiplication of one Quaternions with a Vector3.
	 * @return the multiplication of one Quaternions with a Vector3.
	 */
	static public function getMultiplyVector3( q:Quaternion , v:Vector3 ):Quaternion
	{
		var x1:Number = q.x ; var y1:Number = q.y ;
		var z1:Number = q.z ; var w1:Number = q.w ;
		
		var x2:Number = v.x ; var y2:Number = v.y ;
		var z2:Number = v.z ; var w2:Number = 0   ;
		
		return new Quaternion
		(
			( w1 * x2 ) + ( x1 * w2 ) + ( y1 * z2 ) - ( z1 * y2 ) ,
			( w1 * y2 ) + ( y1 * w2 ) + ( z1 * x2 ) - ( x1 * z2 ) ,
			( w1 * z2 ) + ( z1 * w2 ) + ( x1 * y2 ) - ( y1 * x2 ) ,
			( w1 * w2 ) - ( x1 * x2 ) - ( y1 * y2 ) - ( z1 * z2 )
		) ;
	}

	/**
	 * Normalizes the Quaternion instance.
	 * @param q the Quaternion to normalize.
	 */
	static public function normalize( q:Quaternion ):Void
	{
		var magnitude:Number = QuaternionUtil.getMagnitude() ;
        q.w /= magnitude ;
        Vector3Util.scale ( q , (1.0 / magnitude) );
	}
	
	/**
	 * Sets the elements of a Quaternion to represent the rotation around an arbitary axis.
	 * @param q the Quaternion to set.
	 * @param theta a real number representing angle input.
	 * @param axis the {@code Vector3} direction instance.
	 */
	static public function rotationAxis( q:Quaternion, theta:Number, axis:Vector3 ):Void
	{
		q.w = Math.cos( theta / 2.0 ) ;
		q.x = axis.x ;
		q.y = axis.y ;
		q.z = axis.z ;
		Vector3Util.scale( q , Math.sin(theta / 2.0) ) ;
	}
	
}