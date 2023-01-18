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

import pegas.geom.Point;
import pegas.geom.Trigo;

import vegas.core.CoreObject;
import vegas.core.ICloneable;
import vegas.core.IEquality;
import vegas.core.ISerializable;

/**
 * Represents a transformation matrix that determines how to map points from one coordinate space to another.
 * <p>By setting the properties of a Matrix object and applying it to a MovieClip or BitmapData object you can perform various graphical transformations on the object. These transformation functions include translation (x and y repositioning), rotation, scaling, and skewing.</p>
 * <p><b>Example :</b></p>
 * {@code
 * import pegas.geom.TransformMatrix;
 * var matrix_1:TransformMatrix = new TransformMatrix();
 * trace(matrix_1); // (a:1,b:0,c:0,d:1,tx:0,ty:0)
 * 
 * var matrix_2:TransformMatrix = new TransformMatrix(1, 2, 3, 4, 5, 6);
 * trace(matrix_2); // (a:1,b:2,c:3,d:4,tx:5,ty:6)
 * }
 * The following example creates matrix_1 by sending no parameters to the Matrix constructor and matrix_2 by sending parameters to it. The TransformMatrix object matrix_1, which is created with no parameters, is an identity Matrix with the values (a:1,b:0,c:0,d:1,tx:0,ty:0).
 * @author eKameleon
 */
class pegas.geom.TransformMatrix extends CoreObject implements ICloneable, IEquality, ISerializable 
{

	/**
	 * Creates a new TransformMatrix instance.
	 */
	public function TransformMatrix( a:Number, b:Number, c:Number, d:Number, tx:Number, ty:Number) 
	{
		if (arguments.length == 0) 
		{
			identity() ;
		}
		else 
		{
			this.a = a ;
			this.b = b ;
			this.c = c ;
			this.d = d ;
			this.tx = tx ;
			this.ty = ty ;
		}
	}

	/**
	 * The value in the first row and first column of the Matrix object, which affects the positioning of pixels along the x axis when scaling or rotating an image.
	 */
	public var a:Number ;

	/**
	 * The value in the first row and second column of the Matrix object, which affects the positioning of pixels along the y axis when rotating or skewing an image.
	 */
	public var b:Number ;

	/**
	 * The value in the second row and first column of the Matrix object, which affects the positioning of pixels along the x axis when rotating or skewing an image.
	 */
	public var c:Number ;

	/**
	 * The value in the second row and second column of the Matrix object, which affects the positioning of pixels along the y axis when scaling or rotating an image.
	 */
	public var d:Number ;

	/**
	 * The distance by which to translate each point along the x axis.
	 */
	public var tx:Number ;

	/**
	 * The distance by which to translate each point along the y axis.
	 */
	public var ty:Number ;
		
	public function clone() 
	{
		return new TransformMatrix(a, b, c, d, tx, ty) ;
	}

	/**
	 * Concatenates a matrix with the current matrix, effectively combining the geometric effects of the two.
	 */
	public function concat(m:TransformMatrix):Void 
	{
		var r_a:Number = a * m.a ;
		var r_d:Number = d * m.d ;
		var r_b:Number = 0 ;
		var r_c:Number = 0 ;
		var r_tx:Number = tx * m.a + m.tx ;
		var r_ty:Number = ty * m.d + m.ty ;
		if (b != 0 || c != 0 || m.b != 0 || m.c != 0) 
		{
			r_a = r_a + b * m.c ;
			r_d = r_d + c * m.b ;
			r_b = r_b + (a * m.b + b * m.d) ;
			r_c = r_c + (c * m.a + d * m.c) ;
			r_tx = r_tx + ty * m.c ;
			r_ty = r_ty + tx * m.b ;
		}
		a = r_a ;
		b = r_b ;
		c = r_c ;
		d = r_d ;
		tx = r_tx ;
		ty = r_ty ;
	}

	/**
	 * Includes parameters for scaling, rotation, and translation.
	 */
	public function createBox(scaleX:Number, scaleY:Number, rotation:Number, x:Number, y:Number):Void 
	{
		var rr:Number = isNaN(rotation) ? 0 : rotation ;
		var rx:Number = isNaN(x) ? 0 : x ;
		var ry:Number = isNaN(y) ? 0 : y ;
		identity() ;
		rotate(rr) ;
		scale(scaleX, scaleY) ;
		tx = rx ;
		ty = ry ;
	}
	
	/**
	 * Creates the specific style of matrix expected by the MovieClip.beginGradientFill() method.
	 */
	public function createGradientBox(width:Number, height:Number, rotation:Number, x:Number, y:Number):Void 
	{
		var rr = isNaN(rotation) ? 0 : rotation ;
		var rx:Number = isNaN(x) ? 0 : x ;
		var ry:Number = isNaN(y) ? 0 : y ;
		createBox((width / 1638.400000) , (height / 1638.400000) , rr, rx + width / 2, ry + height / 2) ;
	}
	
	/**
	 * Given a point in the pretransform coordinate space, returns the coordinates of that point after the transformation occurs.
	 */
	public function deltaTransformPoint(p:Point):Point 
	{
		return new Point(a * p.x + c * p.y , d * p.y + b * p.x) ;
	}
	
	public function equals(o):Boolean 
	{
		return ( o instanceof TransformMatrix && o.a == a && o.b == b && o.c == c && o.d == d && o.tx == tx && o.ty == ty) ;
	}
	
	/**
	 * Sets each matrix property to a value that cause a transformed movie clip or geometric construct to be identical to the original.
	 */
	public function identity():Void 
	{
		a = d = 1 ;
		b = c = 0 ;
		tx = ty = 0 ;
	}
	
	/**
	 * Performs the opposite transformation of the original matrix.
	 */
	public function invert():Void 
	{
		if (b == 0 && c == 0) 
		{
			a = 1 / a ;
			d = 1 / d ;
			b = 0 ;
			c = 0 ;
			tx = - a * tx ;
			ty = - d * ty ;
		}
		else 
		{
			var a0:Number = a ;
			var a1:Number = b ;
			var a2:Number = c ;
			var a3:Number = d ;
			var det:Number = a0 * a3 - a1 * a2;
			if (det == 0) identity() ;
			else 
			{
				det = 1 / det ;
				a = a3 * det ;
				b = -a1 * det ;
				c = -a2 * det ;
				d = a0 * det ;
				var p:Point = deltaTransformPoint( new Point(tx, ty) ) ;
				tx = - p.x ;
				ty = - p.y ;
			}
		}
	}
	
	/**
	 * Sets the values in the current matrix so that the matrix can be used to apply a rotation transformation.
	 */
	public function rotate( radians:Number ):Void 
	{
		var c:Number = Math.cos(radians);
		var s:Number = Math.sin(radians);
		concat(new TransformMatrix(c, s, -s, c, 0, 0)) ;
	}
	
	/**
	 * Sets the values in the current matrix so that the matrix can be used to apply a rotation transformation with a degrees value in argument.
	 */
	public function rotateD( degrees:Number ):Void 
	{
		rotate(Trigo.degreesToRadians(degrees)) ;
	}
	
	/**
	 * Modifies a matrix so that its effect, when applied, is to resize an image.
	 */
	public function scale(sx:Number, sy:Number):Void 
	{
		concat(new TransformMatrix(sx, 0, 0, sy, 0, 0));
	}

	/**
	 * Returns a flash.geom.Matrix reference of this TransformMatrix object.
	 * @return a flash.geom.Matrix reference of this TransformMatrix object.
	 */
	public function toFlash():flash.geom.Matrix
	{
		return new flash.geom.Matrix(a, b, c, d, tx, ty) ;
	}

	/**
	 * Returns a Eden reprensation of the object.
	 * @return a string representing the source code of the object.
	 */
	public function toSource( indent:Number, indentor:String):String 
	{
		return "new TransformMatrix(" + a + "," + b + "," + c + "," + d + "," + tx + "," + ty + ")" ;
	}

	/**
	 * Returns the string representation of the object.
	 * @return the string representation of the object.
	 */ 
	public function toString():String 
	{
		return "[a:" + a + ",b:" + b + ",c:" + c + ",d:" + d + ",tx:" + tx + ",ty:" + ty +  "]" ;
	}

	/**
	 * Applies the geometric transformation represented by the Matrix object to the specified point.
	 */
	public function transformPoint(p:Point):Point 
	{
		return new Point( (a * p.x) + (c * p.y) + tx , (d * p.y) + (b * p.x) + ty ) ;
	}
	
	/**
	 * Modifies a Matrix object so that the effect of its transformation is to move an object along the x and y axes.
	 */
	public function translate(dx:Number, dy:Number):Void 
	{
		tx += dx ;
		ty += dy ;
	}

}