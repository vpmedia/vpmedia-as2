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
 * {@code NGrid} defines {@code Number} grid structure.
 * 
 * <p>Based on {@link AbstractGrid} class, this data's structure only accept 
 * {@code Number} element for content.
 * 
 * @author Francis Bourre
 * @version 1.0
 */
 
import com.bourre.log.PixlibDebug;
import com.bourre.log.PixlibStringifier;
import com.bourre.structures.AbstractGrid;
import com.bourre.structures.Point;

class com.bourre.structures.NGrid extends AbstractGrid
{
	
	//-------------------------------------------------------------------------
	// Public API
	//-------------------------------------------------------------------------
	
	/**
	 * Constructs a new {@code NGrid} instance.
	 * 
	 * <p>Example
	 * <code>
	 *   var g : NGrid = new NGrid(10, 10);
	 * </code>
	 * 
	 * @param nX grid width
	 * @param nY grid height
	 */
	public function NGrid (nX:Number, nY:Number) 
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
	 *   var g : NGrid = new NGrid(2, 2);
	 *   var aElements : Array = new Array(0, 20, -30, 20);
	 *   g.setContent(aElements};
	 *   
	 *   var r : Number = g.getVal( new Point(0,1) ); //return -30
	 * </code>
	 * 
	 * @param v Cell {@link Point} position
	 * 
	 * @return {@code Number} value
	 */
	public function getVal(v:Point) : Number
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
	 *   var g : NGrid = new NGrid(2, 2);
	 *   var aElements : Array = new Array(0, 20, -30, 20);
	 *   g.setContent(aElements};
	 *   g.setVal( new Point(0,1), 50);
	 *   
	 *   var r : Number = b.getVal( new Point(0,1) ); //return 50
	 * </code>
	 * 
	 * @param v Cell {@link Point} position
	 */
	public function setVal(v:Point, n:Number) : Void
	{
		checkGridCoords(v);
		_aContent[v.x][v.y] = n; 
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
	 *   var g : NGrid = new NGrid(2, 2);
	 *   var aElements : Array = new Array(0, 20, -30);
	 *   g.setContent(aElements); 
	 *   
	 *   PixlibDebug.DEBUG( g.serialize() ); //return "0,20,-30,_"
	 *   PixlibDebug.DEBUG( g.serialize("|", "__") ); //return "0|20|-30|__"
	 * </code>  
	 * 
	 * @param sCharSep {@code String} separator value (default ",");
	 * @param sUndefined {@code String} used for {@code undefined} or {@code null} 
	 * value in grid. (default "_")
	 * 
	 * @return Serialization {@code String} 
	 */
	public function serialize(sCharSep:String, sUndefined:String) : String
	{
		sCharSep = (sCharSep == undefined) ? "," : sCharSep;
		sUndefined = (sUndefined == undefined) ? "_" : sUndefined;
		var s:String = "";
		
		var i = getIterator();
		while(i.hasNext())
		{
			var n:Number = i.next();
			s += ( n == undefined ) ? sUndefined + sCharSep : String(n) + sCharSep;
		}
		return s.substr(0, s.length - sCharSep.length);
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
	 *   var b : NGrid = new NGrid(2, 2);
	 *   var sContent : String = "0|20|-30|__";
	 *   
	 *   b.deserialize(sContent, "|", "__");
	 * </code>
	 * 
	 * @param s Content {@code String} representation
	 * @param sCharSep {@code String} separator value (default ",");
	 * @param sUndefined {@code String} used for {@code undefined} or {@code null} 
	 * value in grid. (default "_")
	 */
	public function deserialize(s:String, sCharSep:String, sUndefined:String) : Void
	{
		sCharSep = (sCharSep == undefined) ? "," : sCharSep;
		sUndefined = (sUndefined == undefined) ? "_" : sUndefined;
		
		var a:Array = s.split(sCharSep);
		setContent(a, sUndefined);
	}
	
	/**
	 * Sets content of grid with passed-in {@code Array} of String objects.
	 * 
	 * <p>Can use {@link #deserialize} method to define content directly with a 
	 * {@code String} representation content like "0,20,-30,_"
	 * 
	 * <p>Used by {@link deserialize} to load content after deserialization process.
	 * 
	 * <p>Example
	 * <code>
	 *   var g : NGrid = new NGrid(2, 2);
	 *   var aContent : Array = new Array("0","20","-30","_");
	 *   g.setContent(aContent);
	 * </code>
	 * 
	 * @param a {@code Array} structure of {@code String} elements.
	 * @param sUndefined {@code String} used for {@code undefined} or {@code null} 
	 * value in grid.
	 */
	public function setContent(a:Array, sUndefined:String) : Void
	{
		if(a.length != getArea()) PixlibDebug.ERROR( "Array size mismatches with NGrid size!" );
		
		var n:Number;
		var s:String;
		var i = getIterator();
		
		while (i.hasNext())
		{
			i.next();
			s = a[i.getIndex()];
			n = Number(s);
			if (s != sUndefined && !isNaN(n)) setVal(i, n);
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