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
 * {@code BGrid} defines {@code Boolean} grid structure.
 * 
 * <p>Based on {@link AbstractGrid} class, this data's structure only accept 
 * {@code Boolean} element for content.
 * 
 * @author Francis Bourre
 * @version 1.0
 */
 
import com.bourre.log.PixlibDebug;
import com.bourre.log.PixlibStringifier;
import com.bourre.structures.AbstractGrid;
import com.bourre.structures.Point;

class com.bourre.structures.BGrid extends AbstractGrid
{	
	//-------------------------------------------------------------------------
	// Public API
	//-------------------------------------------------------------------------
	
	/**
	 * Constructs a new {@code BGrid} instance.
	 * 
	 * <p>Example
	 * <code>
	 *   var b : BGrid = new BGrid(10, 10);
	 * </code>
	 * 
	 * @param nX grid width
	 * @param nY grid height
	 */
	public function BGrid (nX:Number, nY:Number) 
	{
		super(nX, nY);
	}
	
	/**
	 * Returns value stored in grid cell defining by 
	 * passed-in {@link Point} coordinate.
	 * 
	 * <p>Concrete implementation of {@link AbstractGrid#getVal} method.
	 * 
	 * <p>Example
	 * <code>
	 *   var b : BGrid = new BGrid(2, 2);
	 *   var aElements : Array = new Array(false, true, false, true);
	 *   b.setContent(aElements};
	 *   
	 *   var r : Boolean = b.getVal( new Point(0,1) ); //return false
	 * </code>
	 * 
	 * @param v Cell {@link Point} position
	 * 
	 * @return {@code Boolean} value
	 */
	public function getVal(v:Point) : Boolean
	{
		checkGridCoords(v);
		return _aContent[v.x][v.y];
	}
	
	/**
	 * Defines value of grid cell defining by passed-in {@link Point} 
	 * coordinate.
	 * 
	 * <p>Concrete implementation of {@link AbstractGrid#setVal} method.
	 * 
	 * <p>Example
	 * <code>
	 *   var b : BGrid = new BGrid(2, 2);
	 *   var aElements : Array = new Array(false, true, false, true);
	 *   b.setContent(aElements};
	 *   b.setVal( new Point(0,1), true);
	 *   
	 *   var r : Boolean = b.getVal( new Point(0,1) ); //return true
	 * </code>
	 * 
	 * @param v Cell {@link Point} position
	 */
	public function setVal(v:Point, b:Boolean) : Void
	{
		checkGridCoords(v);
		_aContent[v.x][v.y] = b; 
	}
	
	/**
	 * Serializes grid content.
	 * 
	 * <p>Useful to save grid content.
	 * 
	 * <p>Use {@link #deserialize} to load content.
	 * 
	 * <p>Example
	 * <code>
	 *   var b : BGrid = new BGrid(2, 2);
	 *   var aElements : Array = new Array(false, true, false, true);
	 *   b.setContent(aElements};
	 *  
	 *  var sContent : String = b.serialize(); //return "0101";
	 * </code>
	 * 
	 * @return Serialization {@code String} 
	 */
	public function serialize() : String
	{
		var s:String = "";
		var i = getIterator();
		while(i.hasNext()) s += i.next() ? "1" : "0";
		return s;
	}
	
	/**
	 * Deserializes passed-in {@code String} content and 
	 * loads it into grid.
	 * 
	 * <p>Useful to load grid content.
	 * 
	 * <p>Use {@link #serialize} to save content.
	 * 
	 * <p>Example
	 * <code>
	 *   var b : BGrid = new BGrid(2, 2);
	 *   var sContent : String = "0101";
	 *   
	 *   b.deserialize(sContent);
	 * </code>
	 * 
	 * @param s Content {@code String} representation
	 */
	public function deserialize(s:String) : Void
	{
		var a:Array = s.split("");
		setContent(a);
	}
	
	/**
	 * Calculates and returns {@code Boolean} addition's result of 
	 * row's elements.
	 * 
	 * @param n Row {@code Number} index
	 * 
	 * @return {@code Boolean} value
	 */
	public function getRowVal(n:Number) : Boolean
	{
		var a:Array = getRow(n); 
		var l:Number = getSize().x;
		for (var i:Number = 0; i<l; i++) if (!a[i]) return false;
		return true;
	}
	
	/**
	 * Calculates and returns {@code Boolean} addition's result of 
	 * column's elements.
	 * 
	 * @param n Column {@code Number} index
	 * 
	 * @return {@code Boolean} value
	 */
	public function getColumnVal(n:Number) : Boolean
	{
		var a:Array = getColumn(n);
		var l:Number = getSize().y;
		for (var i:Number = 0; i<l; i++) if (!a[i]) return false;
		return true;
	}
	
	/**
	 * Sets content of grid with passed-in {@code Array} of String objects.
	 * 
	 * <p>Can use {@link #deserialize} method to define content directly with a 
	 * {@code String} representation content like "0101"
	 * 
	 * <p>Used by {@link deserialize} to load content after deserialization process.
	 * 
	 * <p>Example
	 * <code>
	 *   var b : BGrid = new BGrid(2, 2);
	 *   var aContent : Array = new Array("0","1","0","1");
	 *   b.setContent(aContent);
	 * </code>
	 * 
	 * @param a {@code Array} structure of {@code String} elements.
	 */
	public function setContent(a:Array) : Void
	{
		if(a.length != getArea()) PixlibDebug.ERROR( "Array size mismatches with BGrid size!" );
		
		var i = getIterator();
		while (i.hasNext())
		{
			i.next();
			setVal(i, a[i.getIndex()] == "1");
		}
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