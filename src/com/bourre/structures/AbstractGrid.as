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
 * {@code AbstractGrid} represents base class for all grid operations
 * 
 * <p>{@code AbstractGrid} is an abstract class and can be directly use.
 * 
 * <p>Concrete implementations are : 
 * <ul>
 *   <li>{@link BGrid}</li> *   <li>{@link NGrid}</li> *   <li>{@link SGrid}</li>
 * </ul>
 * 
 * @author Francis Bourre
 * @version 1.0
 */ 
import com.bourre.data.iterator.Iterable;
import com.bourre.data.iterator.Iterator;
import com.bourre.log.PixlibDebug;
import com.bourre.log.PixlibStringifier;
import com.bourre.structures.GridIterator;
import com.bourre.structures.Point;

class com.bourre.structures.AbstractGrid 
	implements Iterable
{
	//-------------------------------------------------------------------------
	// Private properties
	//-------------------------------------------------------------------------
	
	private var _aContent : Array;
	private var _vSize:Point;
	
	
	//-------------------------------------------------------------------------
	// Public Properties
	//-------------------------------------------------------------------------
	
	/**
	 * Virtual method for retreiving cell value.
	 * 
	 * <p>Must be implements in subclass
	 */
	public var getVal:Function;
	
	/**
	 * Virtual method for setting cell value.
	 * 
	 * <p>Must be implements in subclass
	 */
	public var setVal:Function;
	
	
	//-------------------------------------------------------------------------
	// Public API
	//-------------------------------------------------------------------------
	
	/**
	 * Builds (or resets) an empty 2D Array structure.
	 * 
	 * <p>Automatically call by {@link #Constructor}
	 */
	public function initContent() : Void 
	{
		_aContent  = new Array(_vSize.x);
		for (var x = 0; x < _vSize.x; x++) _aContent[x] = new Array(_vSize.y);
	}
	
	/**
	 * Checks if passed-in coordinates can be inside
	 * current grid.
	 * 
	 * <p>Example
	 * <code>
	 *   var g : BGrid = new BGrid(10,10);
	 *   var b : Boolean = g.isGridCoords( new Point(20,20) ); //return false
	 * </code>
	 * 
	 * @param v a {link Point} instance defining grid access point.
	 * 
	 * @return {@code true} is passed-in coordinates are valid for 
	 * current grid, either {@code false}
	 */
	public function isGridCoords(v:Point) : Boolean
	{
		return (v.x >= 0 && v.y >= 0 && v.x < _vSize.x && v.y < _vSize.y);
	}
	
	/**
	 * Indicates if passed-in coordinates can be inside
	 * current grid.
	 * 
	 * <p>Nothing is returned, result is send to logging API if
	 * passed-in coordinates are not available for current grid.
	 * 
	 * <p>Example
	 * <code>
	 *   var g : BGrid = new BGrid(10,10);
	 *   
	 *   //log message "**Error** invalid grid coordinates....
	 *   g.checkGridCoords( new Point(20,20) ); 
	 * </code>
	 * 
	 * @param v a {link Point} instance defining grid access point.
	 */
	public function checkGridCoords(v) : Void
	{
		if (!isGridCoords(v)) PixlibDebug.ERROR( "invalid grid coordinates : " + v );
	}
	
	/**
	 * Returns grid area.
	 * 
	 * @return {@code Number} area value
	 */
	public function getArea() : Number 
	{
		return _vSize.x * _vSize.y; 
	}
	
	/**
	 * Returns grid dimension.
	 * 
	 * @return a {@link Point} instance
	 */
	public function getSize() : Point 
	{ 
		return _vSize; 
	}
	
	/**
	 * TODO getCoordinates documentation
	 */
	public function getCoordinates (n:Number) : Point 
	{
		var nY:Number = Math.floor(n / _vSize.x);
		return new Point(n - (nY * _vSize.x), nY);
	}
	
	/**
	 * TODO getIntFromVector documentation
	 */
	public function getIntFromVector (v:Point) : Number 
	{ 
		return v.x + ( v.y * _vSize.x ); 
	}
	
	/**
	 * Returns all elements contained in a specific grid's row.
	 * 
	 * <p>Example
	 * <code>
	 *   var g : BGrid = new BGrid(10,10);
	 *   var aRow : Array = g.getRow(2);
	 * </code>
	 * 
	 * @param n row index in grid.
	 * 
	 * @return a {@code Array} instance with all row's elements (if any)
	 */
	public function getRow(n:Number) : Array
	{
		checkGridCoords( new Point(0, n) );
		var a:Array = new Array();
		var l:Number = getSize().x;
		for (var i:Number = 0; i<l; i++)
		{
			a.push( getVal( new Point(i, n)) );
		}
		return a;
	}
	
	/**
	 * Returns all elements contained in a specific grid's column.
	 * 
	 * <p>Example
	 * <code>
	 *   var g : BGrid = new BGrid(10,10);
	 *   var aColumn : Array = g.getColumn(0);
	 * </code>
	 * 
	 * @param n row index in grid.
	 * 
	 * @return a {@code Array} instance with all column's elements (if any)
	 */
	public function getColumn(n:Number) : Array
	{
		checkGridCoords( new Point(n, 0) );
		return _aContent[n].concat();
	}
	
	/**
	 * Returns a random grid cell.
	 * 
	 * <p>Example
	 * <code>
	 *   var g : BGrid = new BGrid(10,10);
	 *   var p : Point = g.getRandomCoords();
	 * </code>
	 * 
	 * @return {@link Point} instance with random cell coordinates
	 */
	public function getRandomCoords() : Point
	{
		return new Point(
					Math.round(Math.random() * (getSize().x - 1) ),
					Math.round(Math.random() * (getSize().y - 1) )
					);
	}
	
	/**
	 * Returns passed-in {@code Object} position in grid.
	 * 
	 * @param v Element to search
	 * 
	 * @return {@code Point} instance representing element's position
	 * in grid.
	 */
	public function searchForOne(v) : Point
	{ 
		var i = getIterator();
		while(i.hasNext()) if (i.next() == v) return(i.clone());
	}
	
	/**
	 * Returns all positions of passed-in {@code Object} in grid.
	 * 
	 * @param v Element to search
	 * 
	 * @return {@code Array} structure representing all element's positions
	 * in grid.
	 */
	public function searchForAll(v) : Array
	{
		var a:Array = new Array();
		var i = getIterator();
		while(i.hasNext()) if (i.next() == v) a.push(i.clone());
		return a;
	}
	
	/**
	 * Returns an {@link com.bourre.data.Iterator} instance to iterates
	 * over grid elements.
	 * 
	 * <p>Use {@link GridIterator} class for concrete implementation.
	 * 
	 * @return an {@code Iterator} instance
	 * 
	 */
	public function getIterator() : Iterator
	{
		return new GridIterator(this);
	}
	
	/**
	 * Returns the string representation of this instance.
	 * @return the string representation of this instance
	 */
	public function toString() : String 
	{
		return PixlibStringifier.stringify( this );
	}
	
	//-------------------------------------------------------------------------
	// Private implementation
	//-------------------------------------------------------------------------
	
	/**
	 * Constructs a new {@code AbstractGrid} instance.
	 * 
	 * <p>Builds an empty 2D array structure calling {@link #initContent} method.
	 * 
	 * <p>{@code AbstractGrid} class is an abstract class, use concrete 
	 * implementation to build instance.
	 * 
	 * @param nX {@code Number} of line in grid
	 * @param nY {@code Number} of column in grid
	 */
	private function AbstractGrid (nX:Number, nY:Number) 
	{
		if (nX <0 || nY <0 || nX == undefined || nY == undefined) 
		{
			PixlibDebug.ERROR( 'Invalid parameters for building Grid : [' + nX + ', ' + nY + ']' );
		}

		_vSize = new Point(nX, nY);
		initContent();
	}
	
	/**
	 * Fills grid with passed-in {@code Object} value.
	 * 
	 * @param o Elements to put into all cell's grid.
	 */
	private function _fillWith(o) : Void
	{
		var i = getIterator();
		while(i.hasNext()) 
		{
			i.next();
			_aContent[i.x][i.y] = o;
		}
	}
	
	
}