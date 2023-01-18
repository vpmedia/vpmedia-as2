/**
 * com.sekati.geom.Sort
 * @version 1.0.7
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */

import com.sekati.core.CoreObject;
import com.sekati.geom.Point;
import com.sekati.math.MathBase;
/**
 * Sort an array of Objects positions into various shapes and patterns.
 */
class com.sekati.geom.Sort extends CoreObject {
	private var _items:Array;
	private var _sort:Array;
	/**
	 * Sort Constructor
	 * @param items (Array)
	 * @throws Error on invalid items argument array
	 * {@code Usage:
	 * 	var sort:Sort = new Sort([mc0, mc1, mc2, mc3]);
	 * }
	 */
	public function Sort(items:Array) {
		// verify that each item in the array has an _x,_y or x,y property to be sorted.
		for (var i:Number = 0; i < items.length ; i++) {
			if((!items[i]._x && !items[i]._y) && (!items[i].x && !items[i].y)) {
				throw new Error( "@@@ " + this.toString( ) + " Error: constructor expects 'items' argument array to contain objects with '_x',_y' or 'x','y' properties." );
				return;
			}
		}
		_items = items;
		_sort = new Array( );
	}
	/**
	 * Sort items in grid.
	 * @param start (Point)
	 * @param numPerRow (Number)
	 * @param offset (Number)
	 * @return Array
	 * {@code Usage:
	 * 	var positions:Array = new Sort(itemArr).grid(new Point(100,100), 10, 1);
	 * }
	 */	
	public function grid(start:Point, numPerRow:Number, offset:Number):Array {
		var _xpos:Number = 0;
		var _ypos:Number = 0;
		var _offset:Number = (!offset) ? 0 : offset;
		
		// if there is no _width,_height lets assume the items are Points and count them as one pixel.
		var _w:Number = (!_items[0]._width) ? 1 : _items[0]._width;
		var _h:Number = (!_items[0]._height) ? 1 : _items[0]._height;
		var _numPerRow:Number = (!numPerRow) ? Math.ceil( (Stage.width - start.x) / (_w + _offset) ) : numPerRow;
		
		for (var i:Number = 0; i < _items.length ; i++) {
			if ((i % _numPerRow) == 0) {
				_xpos = _offset;
				_ypos += _h + _offset;
			} else {
				_xpos += _w + _offset;
				_ypos += 0;
			}
			_sort[i] = new Point( Math.round( _xpos ) + start.x, Math.round( _ypos ) + start.y );
		}
		return _sort;		
	}
	/**
	 * Sort items in circle.
	 * @param center (Point)
	 * @param radius (Number)
	 * @return Array
	 * {@code Usage:
	 * 	var positions:Array = new Sort(itemArr).circle(new Point(250,250), 255);
	 * }
	 */
	public function circle(center:Point, radius:Number):Array {
		for (var i:Number = 0; i < _items.length ; i++) {
			var angle:Number = i * (360 / _items.length);
			var x:Number = Math.round( (center.x + (radius * Math.cos( (angle - 180) * Math.PI / 180 ))) );
			var y:Number = Math.round( (center.y + (radius * Math.sin( (angle - 180) * Math.PI / 180 ))) );
			_sort[i] = new Point( x, y );
		}
		return _sort;
	}
	/**
	 * Sort items in sine wave.
	 * @param waves (Number)
	 * @param width (Number) sine wave width
	 * @param width (Number) sine wave y position 
	 * @param widthCap (Number) use max 90% of the width
	 * @param heightCap (Number) use max 60% of the height
	 * @return Array
	 * {@code Usage:
	 * 	var positions:Array = new Sort(itemArr).sine(1.5, Stage.width, Stage.height/2, 0.95, 0.5);
	 * }
	 */
	public function sine(waves:Number, width:Number, yPos:Number, widthCap:Number, heightCap:Number):Array {
		var _degStep:Number = (waves * 2 * Math.PI) / (_items.length - 1);
		var _xStep:Number = (width * widthCap) / _items.length;
		for (var i:Number = 0; i < _items.length ; i++) {
			var x:Number = Math.round( (width - width * widthCap) / 2 + _xStep * i );
			var y:Number = Math.round( Math.sin( _degStep * i ) * yPos * heightCap + yPos );
			_sort[i] = new Point( x, y );
		}
		return _sort;
	}
	/**
	 * Sort items in triangle.
	 * @param center (Point)
	 * @param sideLength (Number)
	 * @return Array
	 * {@code Usage:
	 * 	var positions:Array = new Sort(itemArr).triangle(new Point(250,250), 500);
	 * }
	 */
	public function triangle(center:Point, sideLength:Number):Array {
		var cY:Number = center.y - (sideLength / 2);
		//var perimeter:Number = sideLength*3;
		var objBySide:Number = Math.floor( _items.length / 3 );
		var leftObj:Number = _items.length - objBySide * 3;
		var posArray:Array = new Array( );
		var radAngle:Number = Math.PI / 3;
	    
		var spacing:Number;
		for (var i:Number = 0; i < _items.length ; i++) {
			posArray[i] = new Point( );
			if (i < objBySide) {
				spacing = sideLength / objBySide;
				posArray[i].x = (spacing * i) * Math.cos( radAngle );
				posArray[i].y = (spacing * i) * Math.sin( radAngle );
			}
			if (i >= objBySide && i < objBySide * 2 + Math.ceil( leftObj / 2 )) {
				spacing = (leftObj != 0) ? sideLength / (objBySide + 1) : sideLength / objBySide;
				posArray[i].x = (sideLength * Math.cos( radAngle )) - (spacing * (i - objBySide));
				posArray[i].y = sideLength * Math.sin( radAngle );
			}
			if (i >= objBySide * 2 + Math.ceil( leftObj / 2 )) {
				spacing = (leftObj == 2) ? sideLength / (objBySide + 1) : sideLength / objBySide;
				posArray[i].x = -sideLength * Math.cos( radAngle ) + (spacing * (i - (objBySide * 2 + Math.ceil( leftObj / 2 )))) * Math.cos( radAngle );
				posArray[i].y = sideLength * Math.sin( radAngle ) - (spacing * (i - (objBySide * 2 + Math.ceil( leftObj / 2 )))) * Math.sin( radAngle );
			}
			var x:Number = Math.round( center.x + posArray[i].x );
			var y:Number = Math.round( cY + posArray[i].y );
			_sort[i] = new Point( x, y );
		}
		return _sort;
	}
	/**
	 * Sort items in flower.
	 * @param center (Point)
	 * @param radius (Number)
	 * @return Array
	 * {@code Usage:
	 * 	var positions:Array = new Sort(itemArr).flower(new Point(250,250), 250);
	 * }
	 */		public function flower(center:Point, radius:Number):Array {
		var posArray:Array = new Array( );
		var step:Number = (2 * Math.PI) / _items.length;
		var b:Number = 1;
		var k:Number = 2;
		for (var i:Number = 0; i < _items.length ; i++) {
			var r:Number = b * Math.cos( k * i * step );
			posArray[i] = new Point( );
			posArray[i].x = (r * Math.cos( i * step )) * radius;
			posArray[i].y = (r * Math.sin( i * step )) * radius;
			var x:Number = Math.round( center.x + posArray[i].x );
			var y:Number = Math.round( center.y + posArray[i].y );
			_sort[i] = new Point( x, y );
		}
		return _sort;
	}
	/**
	 * Sort items in hedron (star,square,triangle,hexagon,octagon,etc)
	 * @param center (Point)
	 * @param heightCap (Number) use max 90% of the height [default: 0.8]
	 * @param corners (Number)
	 * @param rotate  (Number)
	 * @param isIntraRadial (Boolean) if true star shapes will be drawn else closed hedrons [default: false]
	 * @return Array
	 * {@code Usage:
	 * 	var positions:Array = new Sort(itemArr).hedron(new Point(250,250), 0.6, 8, 90); // create a octagon and rotate 90 degrees.
	 * }
	 */
	public function hedron(center:Point, heightCap:Number, corners:Number, rotate:Number, isIntraRadial:Boolean):Array {
		heightCap = (!heightCap) ? 0.8 : heightCap;
		var outerRadius:Number = center.y * heightCap;
		var innerRadius:Number = (!isIntraRadial) ? outerRadius * Math.sqrt( (1 + Math.cos( (2 * Math.PI) / corners )) / 2 ) : outerRadius / 2;
		var cursors:Number = _items.length;
		var lines:Number = corners * 2;
		var cursorsPerLine:Number = Math.floor( cursors / lines );
		var cursorsLeftOver:Number = cursors - cursorsPerLine * lines; 		// cursors for adoption...
		var alphaStep:Number = (2 * Math.PI) / corners;
		rotate = (Math.PI / 180) * rotate;
		var alpha:Number = rotate;
		var actualCursor:Number = 0;
		var cursorsOnActualLine:Number;
		var xStep:Number;
		var yStep:Number;
		var xAct:Number;
		var yAct:Number;	    
		for (var i:Number = 0; i < corners ; i++) {
			var xOuter1:Number = Math.sin( alpha ) * outerRadius;
			var yOuter1:Number = Math.cos( alpha ) * outerRadius;
			var xInner:Number = Math.sin( alpha - alphaStep / 2 ) * innerRadius;
			var yInner:Number = Math.cos( alpha - alphaStep / 2 ) * innerRadius;
			var xOuter2:Number = Math.sin( alpha - alphaStep ) * outerRadius;
			var yOuter2:Number = Math.cos( alpha - alphaStep ) * outerRadius;
			// plot first line
			cursorsOnActualLine = cursorsPerLine;
			if (cursorsLeftOver > 0) {
				cursorsOnActualLine++; 				// add one of the left over cursors on the line
				cursorsLeftOver--; // one was adopted!
			}
			xStep = (xInner - xOuter1) / cursorsOnActualLine;
			yStep = (yInner - yOuter1) / cursorsOnActualLine;
			xAct = center.x + xOuter1;
			yAct = center.y + yOuter1;
			for (var j:Number = 0; j < cursorsOnActualLine ; j++) {
				_sort[actualCursor] = new Point( int( xAct ), int( yAct ) );
				xAct += xStep;
				yAct += yStep;
				actualCursor++;
			}
			// plot second line
			cursorsOnActualLine = cursorsPerLine;
			if (cursorsLeftOver > 0) {
				cursorsOnActualLine++; 				// add one of the left over cursors on the line
				cursorsLeftOver--; // another one was adopted!
			}
			xStep = (xOuter2 - xInner) / cursorsOnActualLine;
			yStep = (yOuter2 - yInner) / cursorsOnActualLine;
			xAct = center.x + xInner;
			yAct = center.y + yInner;
			for (var k:Number = 0; k < cursorsOnActualLine ; k++) {
				_sort[actualCursor] = new Point( int( xAct ), int( yAct ) );
				xAct += xStep;
				yAct += yStep;
				actualCursor++;
			}
			alpha -= alphaStep;
		}
		return _sort;
	}
	/**
	 * Sort items in Star shapes, special {@link com.sekati.geom.Sort.hedon} wrapper.
	 * @param center (Point)
	 * @param heightCap (Number) use max 90% of the height [default: 0.8]
	 * @param corners (Number) of start points
	 * @param rotate (Number)
	 * @return Array
	 * {@code Usage:
	 * 	var positions:Array = new Sort(itemArr).star(new Point(250,250), 0.6, 5, 180);
	 * }
	 */
	public function star(center:Point, heightCap:Number, corners:Number, rotate:Number):Array {
		return hedron( center, heightCap, corners, rotate, true );
	}
	/**
	 * Sort items in square, {@link com.sekati.geom.Sort.hedon} wrapper.
	 * @param center (Point)
	 * @param heightCap (Number) use max 90% of the height [default: 0.8]
	 * @return Array
	 * {@code Usage:
	 * 	var positions:Array = new Sort(itemArr).square(new Point(250,250), 0.8);
	 * }
	 */
	public function square(center:Point, heightCap:Number):Array { 
		return hedron( center, heightCap, 4, 225 ); 
	}
	/**
	 * Sort items in hexagon, {@link com.sekati.geom.Sort.hedon} wrapper.
	 * @param center (Point)
	 * @param heightCap (Number) use max 90% of the height [default: 0.8]
	 * @return Array
	 * {@code Usage:
	 * 	var positions:Array = new Sort(itemArr).hexagon(new Point(250,250));
	 * }
	 */
	public function hexagon(center:Point, heightCap:Number):Array { 
		return hedron( center, heightCap, 6, 90 );
	}
	/**
	 * Unsort items in random arrangement.
	 * @param topLeft (Point)
	 * @param bottomLeft (Point)
	 * @return Array
	 * {@code Usage:
	 * 	var positions:Array = new Sort(itemArr).unsort(new Point(0,0), new Point(Stage.width, Stage.height));
	 * }
	 */
	public function unsort(topLeft:Point, bottomRight:Point):Array {
		for (var i:Number = 0; i < _items.length ; i++) {
			_sort[i] = new Point( MathBase.rnd( topLeft.x, bottomRight.x ), MathBase.rnd( topLeft.y, bottomRight.y ) );
		}
		return _sort;
	}	
}