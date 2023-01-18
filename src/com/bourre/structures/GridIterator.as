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
 * {@code GridIterator} iterates over an {@link AbstractGrid} data structure.
 * 
 * <p>Example
 * <code>
 *   var g : NGrid : NGrid = new NGrid(2,2);
 *   var myIterator : Iterator = new GridIterator( g );
 *   
 *   while( myIterator.hasNext() ) {
 *     var e : Number = myIterator.next();
 *   }
 * </code>
 * 
 * @author Francis Bourre
 * @version 1.0
 */
 
import com.bourre.data.iterator.Iterator;
import com.bourre.log.PixlibStringifier;
import com.bourre.structures.AbstractGrid;
import com.bourre.structures.Point;

class com.bourre.structures.GridIterator 
	extends Point
	implements Iterator
{
	//-------------------------------------------------------------------------
	// Private properties
	//-------------------------------------------------------------------------
	
	private var _g:AbstractGrid;
	private var _n:Number;
	private var _l:Number;
	
	
	//-------------------------------------------------------------------------
	// Public API
	//-------------------------------------------------------------------------
	
	/**
	 * Usage : <em>var i:GridIterator = new GridIterator(myGrid);</em>
	 * @param g 				target Grid for the iterator.
	 */
	
	/**
	 * Constructs a new {@code GridIterator} instance to iterate 
	 * over passed-in {@link AbstractGrid} data structure.
	 * 
	 * <p>Example
	 * <code>
	 *   var g : NGrid : NGrid = new NGrid(2,2);
	 *   var myIterator : Iterator = new GridIterator( g );
	 * </code>
	 * 
	 * @param g an {@link AbstractGrid} instance.
	 */
	public function GridIterator(g:AbstractGrid)
	{
		super(undefined, undefined);
		_g = g;
		_n = -1;
		_l = _g.getArea() - 1;
	}
	
	/**
	 * Indicates if the next iterator position exists.
	 * 
	 * <p>Example
	 * <code>
	 *   var g : NGrid : NGrid = new NGrid(2,2);
	 *   var myIterator : Iterator = new GridIterator( g );
	 *   
	 *   while( myIterator.hasNext() ) {
	 *     //
	 *   }
	 * </code>
	 * 
	 * @return {@code true} if next position exist, either {@code false}
	 */
	public function hasNext() : Boolean 
	{
		return _n < _l; 
	}

	/**
	 * Increments iterator position and returns next object value.
	 * 
	 * <p>Example
	 * <code>
	 *   var g : NGrid : NGrid = new NGrid(2,2);
	 *   var myIterator : Iterator = new GridIterator( g );
	 *   
	 *   while( myIterator.hasNext() ) {
	 *     var e : Number = myIterator.next();
	 *   }
	 * </code>
	 * 
	 * @return Grid element (relaxed type for Grid polymorphism)
	 */
	public function next()
	{
		reset(_g.getCoordinates(++_n));
		return  _g.getVal(this);
	}
	
	/**
	 * Returns current iterator position in grid structure.
	 * 
	 * <p>Example
	 * <code>
	 *   var g : NGrid : NGrid = new NGrid(2,2);
	 *   var myIterator : Iterator = new GridIterator( g );
	 *   
	 *   while( myIterator.hasNext() ) {
	 *     var e : Number = myIterator.next();
	 *     PixlibDebug.INFO( "Iterator index = " + myIterator.getIndex() );
	 *   }
	 * </code>

	 * @return {@code Number} index
	 */
	public function getIndex() : Number 
	{ 
		return _n; 
	}
	
	/**
	 * Returns the string representation of this instance.
	 * @return the string representation of this instance
	 */
	public function toString() : String 
	{
		return PixlibStringifier.stringify( this );
	}
}