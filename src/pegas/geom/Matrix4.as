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
import pegas.util.Matrix4Util;

import vegas.core.CoreObject;
import vegas.core.ICloneable;
import vegas.core.ICopyable;
import vegas.core.IEquality;
import vegas.util.Comparater;
import vegas.util.ConstructorUtil;
import vegas.util.MathsUtil;
import vegas.util.serialize.Serializer;

/**
 * Matrix with 4 rows and 4 columns.
 * @author eKameleon
 */
class pegas.geom.Matrix4 extends CoreObject implements ICloneable, ICopyable, IEquality
{
	
	/**
	 * Creates a new Matrix4 instance.
	 * <p>If 16 arguments are passed to the constructor, it will create a {@code Matrix4} with the values.</p> 
	 * <p>In the other case, a identity {@code Matrix4} is created.</p>
	 * <p><b>Example 1 - Matrix4 identity :</b></p>
	 * {@code
	 * import pegas.geom.Matrix4 ;
	 * var m:Matrix4 = new Matrix4() ;
	 * // 1 0 0 0
	 * // 0 1 0 0
	 * // 0 0 1 0
	 * // 0 0 0 1
	 * }
	 * <p><b>Example 2 - Matrix4 with 16 arguments :</b></p>
	 * {@code
	 * import pegas.geom.Matrix4 ;
	 * var m:Matrix4 = new Matrix4(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16) ;
	 * //  1  2  3  4
	 * //  5  6  7  8
	 * //  9 10 11 12
	 * // 13 14 15 16
	 * }
	 */
	public function Matrix4() 
	{
		if (arguments.length == 16)
		{
			n11 = arguments[0]  ; n12 = arguments[1]  ; n13 = arguments[2]  ; n14 = arguments[3] ;
			n21 = arguments[4]  ; n22 = arguments[5]  ; n23 = arguments[6]  ; n24 = arguments[7] ;
			n31 = arguments[8]  ; n32 = arguments[9]  ; n33 = arguments[10] ; n34 = arguments[11];
			n41 = arguments[12] ; n42 = arguments[13] ; n43 = arguments[14] ; n44 = arguments[15];
		}
		else if (arguments[0] instanceof Matrix4)
		{
			Matrix4Util.setByMatrix(this, arguments[0]) ;	
		}
		else if (arguments[0] instanceof Quaternion)
		{
			Matrix4Util.setByQuaternion(this, arguments[0]) ;
		}
		else
		{
			identity() ;
		}
	}

	/**
	 * Defines a {@code Matrix4} cell.
	 * {@code 
	 * 1 0 0 0
	 * 0 0 0 0
	 * 0 0 0 0
	 * 0 0 0 0 
	 * }
	 */
	public var n11:Number;
	
	/**
	 * Defines a {@code Matrix4} cell.
	 * {@code 
	 *  0 1 0 0
	 *  0 0 0 0
	 *  0 0 0 0
	 *  0 0 0 0
	 *  }
	 */
	public var n12:Number;
	
	/**
	 * Defines a {@code Matrix4} cell.
	 * {@code
	 * 0 0 1 0
	 * 0 0 0 0
	 * 0 0 0 0
	 * 0 0 0 0
	 * }
	 */
	public var n13:Number;
	
	/**
	 * Defines a {@code Matrix4} cell.
	 * {@code
	 * 0 0 0 1
	 * 0 0 0 0
	 * 0 0 0 0
	 * 0 0 0 0
	 * }
	 */
	public var n14:Number;
	
	/**
	 * Defines a {@code Matrix4} cell.
	 * {@code 
	 * 0 0 0 0
	 * 1 0 0 0
	 * 0 0 0 0
	 * 0 0 0 0
	 * }
	 */
	public var n21:Number;
	
	/**
	 * Defines a {@code Matrix4} cell.
	 * {@code 
	 * 0 0 0 0
	 * 0 1 0 0
	 * 0 0 0 0
	 * 0 0 0 0
	 * }
	 */
	public var n22:Number;
	
	/**
	 * Defines a {@code Matrix4} cell.
	 * {@code 
	 * 0 0 0 0
	 * 0 0 1 0
	 * 0 0 0 0
	 * 0 0 0 0
	 * }
	 */
	public var n23:Number;
	
	/**
	 * Defines a {@code Matrix4} cell.
	 * {@code 
	 * 0 0 0 0
	 * 0 0 0 1
	 * 0 0 0 0
	 * 0 0 0 0
	 * }
	 */
	public var n24:Number;
	
	/**
	 * Defines a {@code Matrix4} cell.
	 * {@code 
	 * 0 0 0 0
	 * 0 0 0 0
	 * 1 0 0 0
	 * 0 0 0 0
	 * }
	 */
	public var n31:Number;
	
	/**
	 * Defines a {@code Matrix4} cell.
	 * {@code 
	 * 0 0 0 0
	 * 0 0 0 0
	 * 0 1 0 0
	 * 0 0 0 0
	 * }
	 */
	public var n32:Number;
	
	/**
	 * Defines a {@code Matrix4} cell.
	 * {@code 
	 * 0 0 0 0
	 * 0 0 0 0
	 * 0 0 1 0
	 * 0 0 0 0
	 * }
	 */
	public var n33:Number;
	
	/**
	 * Defines a {@code Matrix4} cell.
	 * {@code 
	 * 0 0 0 0
	 * 0 0 0 0
	 * 0 0 0 1
	 * 0 0 0 0
	 * }
	 */
	public var n34:Number;
	
	/**
	 * Defines a {@code Matrix4} cell.
	 * {@code 
	 * 0 0 0 0
	 * 0 0 0 0
	 * 0 0 0 0
	 * 1 0 0 0
	 * }
	 */
	public var n41:Number;
	
	/**
	 * Defines a {@code Matrix4} cell.
	 * {@code 
	 * 0 0 0 0
	 * 0 0 0 0
	 * 0 0 0 0
	 * 0 1 0 0
	 * }
	 */
	public var n42:Number;
	
	/**
	 * Defines a {@code Matrix4} cell.
	 * {@code 
	 * 0 0 0 0
	 * 0 0 0 0
	 * 0 0 0 0
	 * 0 0 1 0
	 * }
	 */
	public var n43:Number;
	
	/**
	 * Defines a {@code Matrix4} cell.
	 * {@code 
	 * 0 0 0 0
	 * 0 0 0 0
	 * 0 0 0 0
	 * 0 0 0 1
	 * }
	 */
	public var n44:Number;

	/**
	 * Returns a shallow copy of this instance.
	 * @return a shallow copy of this instance.
	 */
	public function clone()
	{
		return new Matrix4( this ) ;
	}

	/**
	 * Returns a deep copy of this instance.
	 * @return a deep copy of this instance.
	 */
	public function copy()
	{
		return new Matrix4( this ) ;
	}
	
	/**
	 * Compares the specified object with this object for equality.
	 * @return {@code true} if the the specified object is equal with this object.
	 */
	public function equals(o):Boolean 
	{
		if (o instanceof Matrix4)
		{
			return Comparater.arrayCompare( Matrix4(o).toArray(), toArray() ) ;
		}
		else
		{
			return false ;	
		}
	}

	/**
	 * Returns the matrix[x][y] value.
	 * @return the matrix[x][y] value.
	 */
	public function getEntry( x:Number, y:Number )
	{
		var m:Array = toArray() ;
		return m[x][y] ;
	}

	/**
	 * Sets matrix[x][y] with the specified value.
	 * @throws IllegalArgumentError if the x or y value are {@code null} or {@code undefined}.
	 */
	public function setEntry( x:Number , y:Number , value ):Void
	{
		x = MathsUtil.clamp(0, 3) ;
		y = MathsUtil.clamp(0, 3) ;
		var m:Array = toArray() ;
		m[x][y] = value ;
	}

	/**
	 * Transforms the specified Matrix4 in argument in the identity Matrix4.
	 */
	public function identity():Void
	{
		n11 = 1 ; n12 = 0 ; n13 = 0 ; n14 = 0 ;
		n21 = 0 ; n22 = 1 ; n23 = 0 ; n24 = 0 ;
		n31 = 0 ; n32 = 0 ; n33 = 1 ; n34 = 0 ;
		n41 = 0 ; n42 = 0 ; n43 = 0 ; n44 = 1 ;
	}

	/**
	 * Returns the Array representation of this instance.
	 * @return the Array representation of this instance.
	 */
	public function toArray():Array
	{
		var m:Array = 
		[
			[n11, n12, n13, n14] ,
			[n21, n22, n23, n24] ,
			[n31, n32, n33, n34] ,
			[n41, n42, n43, n44]
		] ;
		return m ;
	}

	/**
	 * Returns a Eden reprensation of the object.
	 * @return a string representing the source code of the object.
	 */
	public function toSource(indent : Number, indentor : String):String 
	{
		var params:Array = [n11,n12,n13,n14,n21,n22,n23,n24,n31,n32,n33,n34,n41,n42,n43,n44] ;
		return Serializer.getSourceOf(this, params) ;
	}

	/**
	 * Returns the string representation of the object.
	 * @return the string representation of the object.
	 */ 	
	public function toString():String
	{
		var s:String = "[" + ConstructorUtil.getName(this) + ":" ;
		s += "[" + n11 + "," + n12 + "," + n13 + "," + n14 + "]" ;
		s += "," ;
		s += "[" + n21 + "," + n22 + "," + n23 + "," + n24 + "]" ;
		s += "," ;
		s += "[" + n31 + "," + n32 + "," + n33 + "," + n34 + "]" ;
		s += "," ;
		s += "[" + n41 + "," + n42 + "," + n43 + "," + n44 + "]" ;
		s += "]" ;
		return s ;
	}

}