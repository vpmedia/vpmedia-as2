/*
 * Copyright the original author or authors.
 * 
 * Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.mozilla.org/MPL/MPL-1.1.html
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
 
/**
 * {@code Point} data structure.
 * 
 * <p>Can use this data structure in many case : 
 * <ul>
 *   <li>Geometrical operation on vector entities</li>
 *   <li>Object's position representation</li>
 *   <li>2D array dimension</li>
 *   <li>...</li>
 * </ul>
 * 
 * <p>Take a look  at {@link Rectangle} class to see a concrete {@code Point} 
 * example.
 * 
 * @author Francis Bourre
 * @version 1.0
 */

import com.bourre.log.PixlibDebug;
import com.bourre.log.PixlibStringifier;

class com.bourre.structures.Point
{
	//-------------------------------------------------------------------------
	// Public Properties
	//-------------------------------------------------------------------------
	
	/** x property. **/
	public var x : Number;
	
	/** y property. **/
	public var y : Number;


	//-------------------------------------------------------------------------
	// Public API
	//-------------------------------------------------------------------------
	
	/**
	 * Constructs a new {@code Point} instance.
	 * 
	 * <p>Example
	 * <code>
	 *   var p:Point = new Point(4, 2);
	 * </code>
	 * 
	 * @param nX {code Number} x property value.
	 * @param nY {code Number} y property value.
	 */
	public function Point (nX:Number, nY:Number) 
	{
		init(nX, nY);
	}


	/**
	 * Defines {@code x} and {@code y} properties using
	 * passed-in {@code Number, Number} parameters.
	 * 
	 * <p>Example
	 * <code>
	 *   p.init(10,4);
	 * </code>
	 * 
	 * @param nX {code Number} x property value.
	 * @param nY {code Number} y property value.
	 */
	public function init (nX:Number, nY:Number) : Void 
	{ 
		x = nX;
		y = nY;
	}

	/**
	 * Defines {@code x} and {@code y} properties using
	 * passed-in {@code Point} instance.
	 * 
	 * <p>Example
	 * <code>
	 *   var p1 : Point = new Point(5,5);
	 *   var p2 : Point = new Point(10,2);
	 *   
	 *   p1.reset( p2 );
	 * </code>
	 * 
	 * @param v a {@code Point} instance
	 */
	public function reset(p:Point) : Void
	{
		init(p.x, p.y);
	}

	/**
	 * Indicates if passed-in {@code Point} parameter and instance have equal
	 * properties.
	 * 
	 * <p>Example
	 * <code>
	 * 	 var p1 : Point = new Point(5,5);
	 *   var p2 : Point = new Point(10,2);
	 *   
	 *   var b : Boolean = p1.equals(p2); //return false
	 * </code>
	 * 
	 * @param p {@code Point} instance to test
	 * 
	 * @return {@code true} if {@code x} and {@code y} from instance are equal to
	 * passed-in {@code Point} instance
	 */
	public function equals(p:Point) : Boolean 
	{ 
		return (x == p.x && y == p.y); 
	}
	
	/**
	 * Indicates if passed-in {@code nX} and {@code nY} parameters and instance properties 
	 * are equal.
	 * 
	 * <p>Example
	 * <code>
	 * 	 var p1 : Point = new Point(5,5);
	 *   
	 *   var b : Boolean = p1.equals(5,5); //return true
	 * </code>
	 * 
	 * @param nX {code Number} x property value.
	 * @param nY {code Number} y property value.
	 * 
	 * @return {@code true} if {@code x} and {@code y} from instance are equal to
	 * passed-in {@code nX} and {@code nY} parameters
	 */
	public function compare(nX:Number, nY:Number) : Boolean 
	{ 
		return (x == nX && y == nY); 
	}
	
	/**
	 * Builds and returns a copy of instance.
	 * 
	 * <p>New returned instance have same properties as current instance.
	 * 
	 * <p>Example
	 * <code>
	 *   var p1 : Point = new Point(10,2);
	 *   var p2 : Point = p1.clone();
	 * </code>
	 * 
	 * 
	 * @return a new {@code Point} instance
	 */
	public function clone() : Point 
	{ 
		return new Point(x, y); 
	}

	/*
	 * Arithmetical operations
	 */
	
	/**
	 * Substracts passed-in {@code Point} properties to instance
	 * properties.
	 * 
	 * <p>Warning : Instance is directly modified.
	 * 
	 * <p>Example
	 * <code>
	 *   var p1 : Point = new Point(10,2);
	 *   var p2 : Point = new Point(5,1);
	 *   p1.minus(p2);
	 * </code>
	 * 
	 * @param p a {@code Point} instance
	 */
	public function minus(p:Point) : Void 
	{ 
		init(x - p.x, y - p.y); 
	}
	
	/**
	 * Adds passed-in {@code Point} properties to instance
	 * properties.
	 * 
	 * <p>Warning : Instance is directly modified.
	 * 
	 * <p>Example
	 * <code>
	 *   var p1 : Point = new Point(10,2);
	 *   var p2 : Point = new Point(5,1);
	 *   p1.plus(p2);
	 * </code>
	 * 
	 * @param p a {@code Point} instance
	 */
	public function plus(p:Point) : Void 
	{ 
		init(x + p.x, y + p.y); 
	}
	
	/**
	 * Sets to negative all instance properties.
	 * 
	 * <p>Warning : Instance is directly modified.
	 * 
	 * <p>Example
	 * <code>
	 *   var p1 : Point = new Point(10,2);
	 *   p1.neg();
	 * </code>
	 * 
	 * @param p a {@code Point} instance
	 */
	public function neg() : Void 
	{ 
		init(-x, -y); 
	}
	
	/**
	 * Sets to absolute all instance properties.
	 * 
	 * <p>Warning : Instance is directly modified.
	 * 
	 * <p>Example
	 * <code>
	 *   var p1 : Point = new Point(10,2);
	 *   p1.abs();
	 * </code>
	 * 
	 * @param p a {@code Point} instance
	 */
	public function abs() : Void 
	{ 
		init(Math.abs(x), Math.abs(y)); 
	}
	
	/**
	 * Get length of the vector defined by instance properties.
	 * 
	 * <p>Example
	 * <code>
	 *   var p : Point = new Point(10,2);
	 *   var l : Number = p.getLength();
	 * </code>
	 * 
	 * @return {@code Number} vector length
	 */
	public function getLength() : Number
	{
		return Math.sqrt( (x*x) + (y*y) );
	}
	
	/**
	 * Transforms vector in  direction.
	 * 
	 * <p>Warning : Instance is directly modified.
	 * 
	 * <p>Example
	 * <code>
	 *   var p : Point = new Point(10,2);
	 *   p.normalize();
	 * </code>
	 */
	public function normalize() : Void
	{
		var l:Number = getLength();
		if (l/0)
		{
			x /= l;
			y /= l;
		} else
		{
			PixlibDebug.WARN( this + ".normalize() was called on a zero-length vector!" );
		}
	}
	
	/**
	 * Returns Vector direction defined by instance propreties.
	 * 
	 * <p>Example
	 * <code>
	 *   var p1 : Point = new Point(10,2);
	 *   var p2 : Point = p1.getDirection();
	 * </code>
	 * 
	 * @return a new {@code Point} instance.
	 */
	public function getDirection() : Point
	{
		var p:Point = clone();
		p.normalize();
		return p;
	}
	
	/**
	 * Calculates and returns dot product between this instance
	 * and passed-in {@code Point} instance.
	 * 
	 * <p>Example
	 * <code>
	 *   var p0 : Point = new Point(10,2);
	 *   var p1 : Point = new Point(5,6);
	 *   
	 *   var nDotP : Number = p0.getDotProduct( p1 );
	 * </code>
	 * 
	 * @param 	a {@code Point} instance
	 * @return 	dot product result {@code Number}
	 */
	public function getDotProduct( p:Point ) : Number
	{
		return (x * p.x) + (y * p.y);
	}
	
	/**
	 * Calculates and returns cross product between this instance
	 * and passed-in {@code Point} instance.
	 * 
	 * <p>Example
	 * <code>
	 *   var p0 : Point = new Point(10,2);
	 *   var p1 : Point = new Point(5,6);
	 *   
	 *   var nDotP : Number = p0.getCrossProduct( p1 );
	 * </code>
	 * 
	 * @param 	a {@code Point} instance
	 * @return 	cross product result {@code Number}
	 */
	public function getCrossProduct( p:Point ) : Number
	{
		return (x * p.y) - (y * p.x);
	}
	
	/**
	 * Multiplies each instance property by passed-in {@code scalar} value.
	 * 
	 * <p>Warning : Instance is directly modified.
	 * 
	 * <p>Example
	 * <code>
	 *   var p : Point = new Point(10,2);
	 *   p.scalarMultiply(5);
	 * </code>
	 * 
	 * @param a {@code Number} value
	 */
	public function scalarMultiply( n:Number ) : Void
	{
		x *= n;
		y *= n;
	}
	
	/**
	 * Returns a new {@code Point} instance, result of projection of this instance 
	 * on passed-in {@code Point} instance.
	 * 
	 * <p>Example
	 * <code>
	 *   var p1 : Point = new Point(10,2);
	 *   var p2 : Point = new Point(5,5);
	 *   
	 *   var p3 : Point = p1.project( p2 ); //Projection Point result
	 * </code>
	 *  
	 * @param p1 a {@code Point} instance
	 * 
	 * @return new {@code Point} instance (instance projected on passed-in p1 Point).
	 */
	public function project( p1:Point ) : Point
	{
		var n:Number = p1.getDotProduct(p1);
		if( n == 0)
		{
			//zero-length
			PixlibDebug.WARN( this + ".project() was given a zero-length projection vector!" );
			return clone();
		}
		else
		{
			var p0:Point = p1.clone();
			p0.scalarMultiply( getDotProduct(p1)/n );
			return p0;
		}
	}
	
	/**
	 * TODO method documentation
	 */
	public function getProjectionLength( p1:Point ) : Number
	{
		var n:Number = p1.getDotProduct(p1);
		if( n == 0)
		{
			//zero-length
			PixlibDebug.WARN( this + ".getProjectionLength() was given a zero-length projection vector!" );
			return 0;
		}
		else
		{
			var p0:Point = p1.clone();
			return Math.abs(getDotProduct(p1)/n);
		}
	}
	
	/**
	 * Returns the string representation of this instance.
	 * 
	 * @return {@code String} representation of this instance
	 */
	public function toString(): String
	{
		return PixlibStringifier.stringify( this ) + ' : [' + String(x) + ', ' + String(y) + ']';
	}
	
	/*
	 * Static methods
	 */
	 
	/**
	 * Calculates and returns new {@code Point} instance, resulting of 
	 * substraction between 2 passed-in {@code Point} instances.
	 * 
	 * <p>Example
	 * <code>
	 *   var p1 : Point = new Point(10,2);
	 *   var p2 : Point = new Point(5,1);
	 *   
	 *   var p3 : Point = Point.minusNew(p1, p2);
	 * </code>
	 * 
	 * @param p a {@code Point} instance
	 */
	public static function minusNew(p1:Point, p2:Point) : Point
	{ 
		return new Point(p1.x - p2.x, p1.y - p2.y); 
	}
	
	/**
	 * Calculates and returns new {@code Point} instance, resulting of 
	 * addition between 2 passed-in {@code Point} instances.
	 * 
	 * <p>Example
	 * <code>
	 *   var p1 : Point = new Point(10,2);
	 *   var p2 : Point = new Point(5,1);
	 *   
	 *   var p3 : Point = Point.plusNew(p1, p2);
	 * </code>
	 * 
	 * @param p a {@code Point} instance
	 */
	public static function plusNew(p1:Point, p2:Point) : Point 
	{ 
		return new Point(p1.x + p2.x, p1.y + p2.y); 
	}

	/**
	 * Returns a new {@code Point} with passed-in {@code Point} 
	 * negative properties.
	 * 
	 * <p>Example
	 * <code>
	 *   var p1 : Point = new Point(10,2);
	 *   var p2 : Point = Point.negNew( p1 ); //equal to new Point(-10, -2);
	 * </code>
	 * 
	 * @param p a {@code Point} instance
	 */
	public static function negNew(p:Point) : Point 
	{ 
		return new Point( -p.x, -p.y); 
	}
	
	/**
	 * Returns a new {@code Point} with passed-in {@code Point} 
	 * absolute properties.
	 * 
	 * <p>Example
	 * <code>
	 *   var p1 : Point = new Point(10, -2);
	 *   var p2 : Point = Point.absNew( p1 ); //equal to new Point(10, 2);
	 * </code>
	 * 
	 * @param p a {@code Point} instance
	 */
	public static function absNew(p:Point) : Point 
	{ 
		return new Point( Math.abs(p.x), Math.abs(p.y) ); 
	}
	
	/**
	 * Returns distance between 2 passed-in {@code Point} instance.
	 * 
	 * @param p1 {@code Point} instance
	 * @param p2 {@code Point} instance
	 * 
	 * @return {@code Number} distance value
	 */
	public static function getDistance(p1:Point, p2:Point) : Number
	{
		return Point.minusNew(p1, p2).getLength();
	}
}