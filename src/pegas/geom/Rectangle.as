/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is Vegas Framework.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <vegas@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2007
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

import pegas.geom.Point;

import vegas.core.CoreObject;
import vegas.core.ICloneable;
import vegas.core.IComparator;
import vegas.core.ICopyable;
import vegas.core.IEquality;

// TODO creates unit tests.

/**
 * The Rectangle class is used to create and modify Rectangle objects. 
 * <p>A Rectangle object is an area defined by its position, as indicated by its top-left corner point (x, y), and by its width and its height.</p>
 * <p>The x, y, width, and height properties of the Rectangle class are independent of each other; changing the value of one property has no effect on the others.</p>
 * <p>To used this class with a FP8 and > with flash.display.BitmapData class and other flash.* classes you can use the method toFlash() to return a compatible reference of this object.</p> 
 * @author eKameleon
 */
class pegas.geom.Rectangle extends CoreObject implements ICloneable, IComparator, ICopyable, IEquality
{

	/**
	 * Creates a new Rectangle instance whose top-left corner is specified by the x and y parameters.
	 * <p><b>Example :</b></p>
	 * {@code
	 * import pegas.geom.Rectangle;
	 * var rec:Rectangle = new Rectangle(5, 10, 50, 100);
	 * trace( "output : " + rec.toString() ); // output : (x:5,y:10,width:50,height:100)
	 * }
	 * @param x The {@code x} coordinate of the top-left corner of the rectangle.
	 * @param y The {@code y} coordinate of the top-left corner of the rectangle.
	 * @param w The width of the rectangle in pixels.
	 * @param h The height of the rectangle in pixels.
	 */
	public function Rectangle( x:Number, y:Number, w:Number, h:Number ) 
	{
		if (arguments.length > 0) 
		{
			this.x = x ;
			this.y = y ;
			this.width = w ;
			this.height = h ;
		}
		else 
		{
			setEmpty() ;
		}
	}

	/**
	 * Returns the sum of the y and height properties.
	 * @return the sum of the y and height properties.
	 */
	public function get bottom():Number 
	{
		return getBottom() ;
	}

	/**
	 * Sets the sum of the y and height properties.
	 */
	public function set bottom( n:Number ):Void 
	{
		setBottom(n) ;	
	}	

	/**
	 * Returns the location of the Rectangle object's bottom-left corner, determined by the values of the x and y properties.
	 * @return the location of the Rectangle object's bottom-left corner, determined by the values of the x and y properties.
	 */
	public function get bottomLeft():Point 
	{
		return getBottomLeft() ;
	}

	/**
	 * Sets the location of the Rectangle object's bottom-left corner, determined by the values of the x and y properties.
	 */
	public function set bottomLeft( p:Point ):Void 
	{
		setBottomLeft(p) ;	
	}	

	/**
	 * Returns the location of the Rectangle object's bottom-right corner, determined by the values of the x and y properties.
	 * @return the location of the Rectangle object's bottom-right corner, determined by the values of the x and y properties.
	 */
	public function get bottomRight():Point 
	{
		return getBottomRight() ;
	}

	/**
	 * Sets the location of the Rectangle object's bottom-right corner, determined by the values of the x and y properties.
	 */
	public function set bottomRight( p:Point ):Void 
	{
		setBottomRight(p) ;	
	}	

	/**
	 * Returns the location of the Rectangle object's center, determined by the values of the x and y properties.
	 * @return the location of the Rectangle object's center, determined by the values of the x and y properties.
	 */
	public function get center():Point 
	{
		return getCenter() ;
	}

	/**
	 * Returns the x coordinate of the top-left corner of the rectangle.
	 * @return the x coordinate of the top-left corner of the rectangle.
	 */
	public function get left():Number 
	{
		return getLeft() ;
	}
	
	/**
	 * Sets the x coordinate of the top-left corner of the rectangle.
	 */
	public function set left( n:Number ):Void 
	{
		setLeft(n) ;	
	}
	
	/**
	 * The height of the rectangle in pixels.
	 */
	public var height:Number ;

	/**
	 * Returns the sum of the x and width properties.
	 * @return the sum of the x and width properties.
	 */
	public function get right():Number 
	{
		return getRight() ;
	}

	/**
	 * Sets the sum of the x and width properties.
	 */
	public function set right( n:Number ):Void 
	{
		setRight(n) ;	
	}
	
	/**
	 * Returns the size of the Rectangle object, expressed as a Point object with the values of the width and height properties.
	 * @return the size of the Rectangle object, expressed as a Point object with the values of the width and height properties.
	 */
	public function get size():Point 
	{
		return getSize() ;	
	}
	
	/**
	 * Sets the size of the Rectangle object, expressed as a Point object with the values of the width and height properties.
	 */
	public function set size( o ):Void 
	{
		setSize(o) ;	
	}

	/**
	 * Returns the y coordinate of the top-left corner of the rectangle.
	 * @return the y coordinate of the top-left corner of the rectangle.
	 */
	public function get top():Number 
	{
		return getTop() ;
	}

	/**
	 * Sets the y coordinate of the top-left corner of the rectangle.
	 */
	public function set top( n:Number ):Void 
	{
		setTop(n) ;	
	}

	/**
	 * Returns the location of the Rectangle object's top-left corner determined by the x and y values of the point.
	 * @return the location of the Rectangle object's top-left corner determined by the x and y values of the point.
	 */
	public function get topLeft():Point 
	{
		return getTopLeft() ;
	}

	/**
	 * Sets the location of the Rectangle object's top-left corner determined by the x and y values of the point.
	 */
	public function set topLeft( p:Point ):Void 
	{
		setTopLeft(p) ;	
	}	

	/**
	 * Returns the location of the Rectangle object's top-right corner determined by the x and y values of the point.
	 * @return the location of the Rectangle object's top-right corner determined by the x and y values of the point.
	 */
	public function get topRight():Point 
	{
		return getTopRight() ;
	}

	/**
	 * Sets the location of the Rectangle object's top-right corner determined by the x and y values of the point.
	 */
	public function set topRight( p:Point ):Void 
	{
		setTopRight(p) ;	
	}	

	/**
	 * The width of the rectangle in pixels.
	 */
	public var width:Number ;
	
	/**
	 * The x coordinate of the top-left corner of the rectangle.
	 */
	public var x:Number ;
	
	/**
	 * The y coordinate of the top-left corner of the rectangle.
	 */
	public var y:Number ;
	
	/**
	 * Returns a new Rectangle object with the same values for the x, y, width, and height properties as the original Rectangle object.
	 * @return a new Rectangle object with the same values for the x, y, width, and height properties as the original Rectangle object.
	 */
	public function clone() 
	{
		return new Rectangle(x, y, width, height) ;
	}

	/**
	 * Returns a new Rectangle object with the same values for the x, y, width, and height properties as the original Rectangle object.
	 * @return a new Rectangle object with the same values for the x, y, width, and height properties as the original Rectangle object.
	 */
	public function copy() 
	{
		return new Rectangle(x, y, width, height) ;
	}

	/**
	 * Determines whether the specified coordinates is contained within the rectangular region defined by this Rectangle object.
	 * @return {@code true} if the specified coordinates is contained within the rectangular region defined by this Rectangle object.
	 */
	public function contains( p_x:Number, p_y:Number):Boolean 
	{
		return (this.x <= p_x && this.x + this.width > p_x && this.y <= p_y && this.y + this.height > p_y) ;
	}

	/**
	 * Determines whether the specified point is contained within the rectangular region defined by this Rectangle object.
	 * @return {@code true} if the specified point is contained within the rectangular region defined by this Rectangle object.
	 */
	public function containsPoint(pt:Point):Boolean 
	{
		return (pt.x >= x && pt.x < x + width && pt.y >= y && pt.y < y + height);
	}
	
	/**
	 * Determines whether the Rectangle object specified by the rect parameter is contained within this Rectangle object.
	 * @return {@code true} if the specified Rectangle is contained within this Rectangle object. 
	 */
	public function containsRectangle(rec:Rectangle):Boolean 
	{
		var a:Number = rec.x + rec.width ;
		var b:Number = rec.y + rec.height ;
		var c:Number = x + width ;
		var d:Number = y + height ;
		return (rec.x >= x && rec.x < c && rec.y >= y && rec.y < d && a > this.x && a <= c && b > y && b <= d) ;
	}

	/**
	 * Compares its two arguments for order.
	 * @param o1 the first object to compare.
	 * @param o2 the second object to compare.
	 * @return <p>
	 * <li>-1 if o1 is "lower" than (less than, before, etc.) o2 ;</li>
	 * <li> 1 if o1 is "higher" than (greater than, after, etc.) o2 ;</li>
	 * <li> 0 if o1 and o2 are equal.</li>
	 * </p>
	 */
	public function compare(o1, o2):Number 
	{
		var s1:Point = o1.getSize() ;
		var s2:Point = o2.getSize() ;
		var a1:Number = s1.x * s1.y ;
		var a2:Number = s2.x * s2.y ;
		if (a1 == a2) return 0 ;
		else if(a1 > a2) return 1 ;
		else return -1 ;
	}

	/**
	 * Compares the specified object with this object for equality.
	 * @return {@code true} if the the specified object is equal with this object.
	 */
	public function equals(o):Boolean 
	{
		return ( (o instanceof Rectangle) && (o.x == x) && (o.y == y) && (o.width == width) && (o.height == height)) ;
	}
	
	/**
	 * Returns the sum of the y and height properties.
	 * @return the sum of the y and height properties.
	 */
	public function getBottom():Number 
	{
		return y + height ;
	}

	/**
	 * Returns the location of the Rectangle object's bottom-left corner, determined by the values of the x and y properties.
	 * @return the location of the Rectangle object's bottom-left corner, determined by the values of the x and y properties.
	 */
	public function getBottomLeft():Point 
	{
		return new Point(x, y + height) ;
	}

	/**
	 * Returns the location of the Rectangle object's bottom-right corner, determined by the values of the x and y properties.
	 * @return the location of the Rectangle object's bottom-right corner, determined by the values of the x and y properties.
	 */
	public function getBottomRight():Point 
	{
		return new Point(x + width, y + height) ;
	}

	/**
	 * Returns the location of the Rectangle object's center, determined by the values of the x and y properties.
	 * @return the location of the Rectangle object's center, determined by the values of the x and y properties.
	 */
	public function getCenter():Point 
	{
		return new Point(x + width/2, y + height/2);
	}

	/**
	 * Returns the x coordinate of the top-left corner of the rectangle.
	 * @return the x coordinate of the top-left corner of the rectangle.
	 */
	public function getLeft():Number 
	{
		return x ;
	}
	
	/**
	 * Returns the sum of the x and width properties.
	 * @return the sum of the x and width properties.
	 */
	public function getRight():Number 
	{
		return x + width ;
	}
	
	/**
	 * Returns the size of the Rectangle object, expressed as a Point object with the values of the width and height properties.
	 * @return the size of the Rectangle object, expressed as a Point object with the values of the width and height properties.
	 */
	public function getSize():Point 
	{
		return new Point(width, height) ;
	}
	
	/**
	 * Returns the y coordinate of the top-left corner of the rectangle.
	 * @return the y coordinate of the top-left corner of the rectangle.
	 */
	public function getTop():Number 
	{
		return y ;
	}	
	
	/**
	 * Returns the location of the Rectangle object's top-left corner determined by the x and y values of the point.
	 * @return the location of the Rectangle object's top-left corner determined by the x and y values of the point.
	 */
	public function getTopLeft():Point 
	{
		return new Point(x, y) ;
	}

	/**
	 * Returns the location of the Rectangle object's top-right corner determined by the x and y values of the point.
	 * @return the location of the Rectangle object's top-right corner determined by the x and y values of the point.
	 */
	public function getTopRight():Point 
	{
		return new Point(x + width, y) ;
	}

	/**
	 * Increases the size of the Rectangle object by the specified amounts.
	 */
	public function inflate(dx:Number, dy:Number):Void 
	{
		x = x - dx;
		width = width + 2 * dx;
		y = y - dy;
		height = height + 2 * dy;
	}
	
	/**
	 * Increases the size of the Rectangle object.
	 */
	public function inflatePoint(pt:Point):Void 
	{
		x = x - pt.x;
		width = width + 2 * pt.x;
		y = y - pt.y;
		height = height + 2 * pt.y;
	}
	
	/**
	 * If the Rectangle object specified in the toIntersect parameter intersects with this Rectangle object, 
	 * the intersection() method returns the area of intersection as a Rectangle object.
	 */
	public function intersection(toIntersect:Rectangle):Rectangle 
	{
		var rec:Rectangle = new Rectangle() ;
		if (isEmpty() || toIntersect.isEmpty()) {
			rec.setEmpty();
			return rec ;
		}
		rec.x = Math.max(x, toIntersect.x);
		rec.y = Math.max(y, toIntersect.y);
		rec.width = Math.min( x + width, toIntersect.x + toIntersect.width) - rec.x ;
		rec.height = Math.min(y + height, toIntersect.y + toIntersect.height) - rec.y ;
		if ( rec.width <= 0 || rec.height <= 0 ) rec.setEmpty();
		return rec ;
	}
	
	/**
	 * Determines whether the object specified in the toIntersect parameter intersects with this Rectangle object.
	 */
	public function intersects(toIntersect:Rectangle):Boolean 
	{
		return !intersection(toIntersect).isEmpty() ;
	}
	
	/**
	 * Determines whether or not this Rectangle object is empty.
	 */
	public function isEmpty():Boolean 
	{
		return !(width > 0 || height > 0) ;
	}
	
	/**
	 * Adjusts the location of the Rectangle object, as determined by its top-left corner, by the specified amounts.
	 */
	public function offset(dx:Number, dy:Number):Void 
	{
		x = x + dx ;
		y = y + dy ;
	}
	
	/**
	 * Adjusts the location of the Rectangle object using a Point object as a parameter.
	 */
	public function offsetPoint(pt:Point):Void 
	{
		x = x + pt.x ;
		y = y + pt.y ;
	}

	/**
	 * Sets the sum of the y and height properties.
	 */
	public function setBottom(n:Number):Void 
	{
		height = n - y ;
	}

	/**
	 * Sets the location of the Rectangle object's bottom-left corner, determined by the values of the x and y properties.
	 */
	public function setBottomLeft(value):Void 
	{
		width = width + (x - value.x) ;
		height = value.y - y ;
		x = value.x ;
	}

	/**
	 * Sets the location of the Rectangle object's bottom-right corner, determined by the values of the x and y properties.
	 */
	public function setBottomRight(value):Void 
	{
		width = value.x - x;
		height = value.y - y;
	}

	/**
	 * Sets the x and y coordinates of the top-left corner of the rectangle if the specified value in argument is the middle of the Rectangle.
	 */
	public function setCenter( value ):Void 
	{
		x = value.x - ( width / 2 )  ;
		y = value.y - ( height / 2 ) ;
	}

	/**
	 * Sets all of the Rectangle object's properties to 0.
	 */
	public function setEmpty():Void 
	{
		x = y = width = height = 0 ;
	}

	/**
	 * Sets the x coordinate of the top-left corner of the rectangle.
	 */
	public function setLeft(n:Number):Void 
	{
		width = width + (x - n) ;
		x = n ;
	}

	/**
	 * Sets the sum of the x and width properties.
	 */
	public function setRight(n:Number):Void 
	{
		width = n - x ;
	}
	
	/**
	 * Sets the y coordinate of the top-left corner of the rectangle.
	 */
	public function setTop(n:Number):Void
	{
		height = height + (y - n);
		y = n ;
	}

	/**
	 * Sets the location of the Rectangle object's top-left corner determined by the x and y values of the point.
	 */
	public function setTopLeft(value):Void 
	{
		width = width + (x - value.x) ;
		height = height + (y - value.y) ;
		x = value.x ;
		y = value.y ;
	}

	/**
	 * Sets the location of the Rectangle object's top-right corner determined by the x and y values of the point.
	 */
	public function setTopRight(value):Void 
	{
		width = value.x - x;
		height = height + (y - value.y) ;
		y = value.y ;
	}
	
	/**
	 * Sets the size of this Rectangle object.
	 */
	public function setSize( value ):Void 
	{
		width = value.x ;
		height = value.y ;
	}
	
	/**
	 * Returns a flash.geom.Rectangle reference of this Rectangle object.
	 * @return a flash.geom.Rectangle reference of this Rectangle object.
	 */
	public function toFlash():flash.geom.Rectangle
	{
		if (flash.geom.Rectangle != null)
		{
			return new flash.geom.Rectangle(x, y, width, height) ;
		}
		else
		{
			return null ;	
		}
	}

	/**
	 * Returns a Eden reprensation of the object.
	 * @return a string representing the source code of the object.
	 */
	public function toSource( indent:Number, indentor:String):String 
	{
		return "new Rectangle(" + x + "," + y + "," + width + "," + height + ")" ;
	}

	/**
	 * Returns the string representation of the object.
	 * @return the string representation of the object.
	 */ 
	public function toString():String 
	{
		return "{x:" + (x||0) + ",y:" + (y||0) + ",width:" + (width||0) + ",height:" + (height||0) + "}" ;
	}
	
	/**
	 * Adds two rectangles together to create a new Rectangle object, by filling in the horizontal and vertical space between the two rectangles.
	 */
	public function union(toUnion):Rectangle 
	{
		if (isEmpty()) 
		{
			return toUnion.clone() ;
		}
		else if (toUnion.isEmpty()) 
		{
			return clone() ;
		}
		else 
		{
			var rec:Rectangle = new Rectangle();
			rec.x = Math.min(x, toUnion.x);
			rec.y = Math.min(y, toUnion.y);
			rec.width = Math.max(x + width, toUnion.x + toUnion.width) - rec.x;
			rec.height = Math.max(y + height, toUnion.y + toUnion.height) - rec.y;
			return rec ;
		}
	}
	
}