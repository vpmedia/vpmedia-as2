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
 * {@code Rectangle} data structure.
 * 
 * <p>{@code Rectangle} structure manage many informations like : 
 * <ul>
 *   <li>Center point</li>
 *   <li>Top left corner</li> *   <li>Top Right corner</li> *   <li>Bottom left corner</li> *   <li>Bottom Right corner</li>
 *   <li>and position</li>
 * </ul>
 * 
 * @author Francis Bourre
 * @version 1.0
 */
 
import com.bourre.log.PixlibStringifier;
import com.bourre.structures.Point;

class com.bourre.structures.Rectangle
{
	//-------------------------------------------------------------------------
	// Public Properties
	//-------------------------------------------------------------------------
	
	/** width of {@code Rectangle}. **/
	public var width : Number;
	
	/** height of {@code Rectangle}. **/
	public var height : Number;
	
	/** x coordinate of {@code Rectangle}. **/
	public var x : Number;
	
	/** y coordinate of {@code Rectangle}. **/
	public var y : Number;
	
	/** Center point of {@code Rectangle}. **/
	public var center:Point;
	
	/** Top left vorner of {@code Rectangle}. **/
	public var topLeft:Point;
	
	/** Top right corner of {@code Rectangle}. **/
	public var topRight:Point;
	
	/** Bootom left corner of {@code Rectangle}. **/
	public var bottomLeft:Point;
	
	/** Bottom right corner of {@code Rectangle}. **/
	public var bottomRight:Point;
	
	
	//-------------------------------------------------------------------------
	// Public API
	//-------------------------------------------------------------------------
	
	/**
	 * Constructs a new {@code Rectangle} instance.
	 * 
	 * @param w width
	 * @param h height
	 * @param x x position
	 * @param y position
	 */
	public function Rectangle(w:Number, h:Number, x:Number, y:Number) 
	{
		width = w;
		height = h;
		this.x = x? x : 0;
		this.y = y? y : 0;
	}
	
	/**
	 * Returns top left corner.
	 * 
	 * @return {@link Point} instance with top left position
	 */
	public function getTopLeft() : Point
	{
		return new Point(x, y);
	}
	
	/**
	 * Returns top right corner.
	 * 
	 * @return {@link Point} instance with top right position
	 */
	public function getTopRight() : Point
	{
		return new Point(x + width, y);
	}
	
	/**
	 * Returns bottom left corner.
	 * 
	 * @return {@link Point} instance with bottom left position
	 */
	public function getBottomLeft() : Point
	{
		return new Point(x, y + height);
	}
	
	/**
	 * Returns bottom right corner.
	 * 
	 * @return {@link Point} instance with bottom right position
	 */
	public function getBottomRight() : Point
	{
		return new Point( x+width, y+height);
	}
	
	/**
	 * Returns center point
	 * 
	 * @return {@link Point} instance with center position
	 */
	public function getCenter() : Point
	{
		return new Point(x + width/2, y + height/2);
	}
	
	/**
	 * Returns the string representation of this instance.
	 * 
	 * @return {@code String} representation of this instance
	 */
	public function toString() : String
	{
		return PixlibStringifier.stringify( this ) + " : [" + width + ", " + height + ", " + x + ", " + y + "]";
	}
}