import com.bourre.log.PixlibStringifier;
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
 * {@code Range} type definition.
 * 
 * <p>Allow manipulation of {@code Number} interval.
 * 
 * <p>Example
 * <code>
 *   var r1 : Range = new Range(10, 100);
 *   var r2 : Range = new Range(5, 50);
 *   var r3 : Range = new Range(60, 600);
 *   
 *   var b1 : Boolean = r1.overlap(r2); //true
 *   var b2 : Boolean = r2.overlap(r3); //false
 *   var b3 : Boolean = r1.overlap(r3); //true
 * </code>
 * 
 * @author Francis Bourre
 * @version 1.0
 */
class com.bourre.structures.Range
{
	//-------------------------------------------------------------------------
	// Public Properties
	//-------------------------------------------------------------------------
	
	public var min:Number;
	public var max:Number;
	
	
	//-------------------------------------------------------------------------
	// Public API
	//-------------------------------------------------------------------------
	
	/**
	 * Constructs a new {@code Range} instance.
	 * 
	 * <p>Warning : parameter order is important.
	 * 
	 * @param min minimum {@code Number} value
	 * @param max maximum {@code Number} value
	 */
	public function Range(min:Number, max:Number) 
	{
		this.min = min;
		this.max = max;
	}
	
	/**
	 * Indicates if passed-in {@code Range} instance overlap 
	 * current instance.
	 * 
	 * <p>Example
	 * <code>
	 *   var r1 : Range = new Range(10, 100);
	 *   var r2 : Range = new Range(5, 50);
	 *   var r3 : Range = new Range(60, 600);
	 *   
	 *   var b1 : Boolean = r1.overlap(r2); //true
	 *   var b2 : Boolean = r2.overlap(r3); //false
	 *   var b3 : Boolean = r1.overlap(r3); //true
	 * </code>
	 * 
	 * @return {@code true} if passed-in {@code Range} overload this one, 
	 * either {@code false}
	 */
	public function overlap( r:Range ) : Boolean
	{
		return (this.max > r.min && r.max > this.min);
	}
		
	/**
	 * Indicates if passed-in value {@code Number} is inside range values.
	 * 
	 * <p>Example
	 * <code>
	 *   var r : Range = new Range(10, 100);
	 *   
	 *   var b1 : Boolean = r.surround(35); //true
	 *   var b2 : Boolean = r.surround(127); //false
	 *   var b3 : Boolean = r.surround(10); //true
	 *   var b4 : Boolean = r.surround(100); //true
	 *   var b5 : Boolean = r.surround(5); //false
	 * </code>
	 * 
	 * @return {@code true} if passed-in {@code Number} is inside range,
	 * either {@code false}
	 */
	public function surround( n : Number ) : Boolean
	{
		return (max >= n && min <= n);
	}
	
	/**
	 * Returns the string representation of this instance.
	 * 
	 * @return {@code String} representation of this instance
	 */
	public function toString() : String
	{
		return PixlibStringifier.stringify( this ) + " : [" + min + ", " + max + "]";
	}
}