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

import vegas.core.CoreObject;
import vegas.core.ICloneable;
import vegas.core.IEquality;
import vegas.errors.ArgumentOutOfBoundsError;
import vegas.errors.IllegalArgumentError;
import vegas.util.MathsUtil;

/**
 * Represents an immutable range of values.
 * <p><b>Example :</b></p>
 * {@code
 * import pegas.maths.Range ;
 * 
 * var r1:Range = new Range(10, 120) ;
 * var r2:Range = new Range(100, 150) ;
 * 
 * trace ("r1 : " + r1) ; // r1 : [Range<10,120>]
 * trace ("r2 : " + r2) ; // r2 : [Range<100,150>]
 * 
 * trace ("r2.toSource() : " + r2.toSource()) ; // r2.toSource() : new pegas.maths.Range(100,150)
 * trace ("r1 contains 50 : " + r1.contains(50)) ; // r1 contains 50 : true
 * trace ("r1 isOutOfRange 5 : " + r1.isOutOfRange(5)) ; // r1 isOutOfRange 5 : true
 * trace ("r1 overlap r2 : " + r1.overlap(r2)) ; // r1 overlap r2 : true
 * trace ("r1 clamp 5 : " + r1.clamp(5)) ; // r1 clamp 5 : 10
 * trace ("r1 clamp 121 : " + r1.clamp(121)) ; // r1 clamp 121 : 120
 * }
 * @author eKameleon
 */
class pegas.maths.Range extends CoreObject implements ICloneable, IEquality
{

	/**
	 * Creates a new Range instance.
	 * use <pre>var r:Range = new Range(p_min:Number, p_max:Number) ;</pre>
	 */ 
	public function Range(p_min:Number, p_max:Number) 
	{
		if (p_max < p_min) 
		{
			throw new ArgumentOutOfBoundsError("Range constructor : 'max' argument is < of 'min' argument") ;
		}
		min = p_min ;
		max = p_max ;
	}

	/**
	 * Range between 0 and 100.
	 */
	static public var PERCENT_RANGE:Range = new Range(0, 100) ;
	
	/**
	 * Range between -255 and 255.
	 */
	static public var COLOR_RANGE:Range = new Range(-255, 255) ;

	/**
	 * Range reference between 0 and 1.
	 */
    static public var UNITY_RANGE:Range = new Range(0, 1) ;


	static private var __ASPF__ = _global.ASSetPropFlags(Range, null , 7, 7) ;
	
	/**
	 * The max value of the range.
	 */	
	public var max:Number ;
	
	/**
	 * The min value of the range.
	 */
	public var min:Number ;
		
	/**
	 * Clamp a value in the current range.
	 */	
	public function clamp(value:Number):Number 
	{
		return MathsUtil.clamp(value, min, max) ;
	}
	
	/**
	 * Returns a shallow copy of the object.
	 * @return a shallow copy of the object.
	 */
	public function clone() 
	{
		return new Range(min, max) ;
	}

	/**
	 * Creates a new range by combining two existing ranges.
	 * <li>either range can be {@code null}, in which case the other range is returned.</li>
     * <li>if both ranges are {@code null} the return value is {@code null}.</li>
	 * 
	 * @param range1 the first range, {@code null} permitted.
	 * @param range2 the second range, {@code null} permitted.
	 */
	static public function combine( range1:Range, range2:Range ):Range
	{
		if (range1 == null)
		{
			return range2 ;	
		}
		else
		{
			if (range2 == null)
			{
				return range1 ;	
			}	
			else
			{
				var lower:Number = Math.min( range1.min , range2.min ) ;
				var upper:Number = Math.max( range1.max , range2.max ) ;
				return new Range(lower, upper) ;	
			}
		}
	}
	
	/**
	 * Returns {@code true} if the Range instance contains the value passed in argument.
	 * @return {@code true} if the Range instance contains the value passed in argument.
	 */
	public function contains(value:Number):Boolean 
	{
		return !isOutOfRange(value) ;
	}
	
	/**
	 * Returns a deep copy of the object.
	 * @return a deep copy of the object.
	 */
	public function copy() 
	{
		return new Range(min, max) ;
	}
	
	/**
	 * Indicates whether some other object is "equal to" this one.
	 */
	public function equals(o):Boolean 
	{
		return (o instanceof Range) && (o.min == min) && (o.max == o.max) ;
	}
	
	/**
	 * Creates a new range by adding margins to an existing range.
	 * @param range the range {@code null} not permitted.
	 * @param lowerMargin the lower margin (expressed as a percentage of the range length).
	 * @param upperMargin the upper margin (expressed as a percentage of the range length).
	 * @return The expanded range.
	 * @throws IllegalArgumentError if the range argument is {@code null}
	 */
	static public function expand(range:Range, lowerMargin:Number, upperMargin:Number):Range
	{
		if (range == null)
		{
			throw new IllegalArgumentError("Range.expand method failed, the range argument not must be 'null' or 'undefined'.");  
		}
		var size:Number = range.size() ;
		var lower:Number = size * lowerMargin ;
		var upper:Number = size * upperMargin ;
		return new Range( range.min , range.max ) ;
	}
	
	/**
	 * Returns the central value for the range.
	 * @return The central value.
	 */
	public function getCentralValue():Number
	{
		return (min + max) / 2 ;
	}
	
	/**
	 * Returns {@code true} if the value is out of the range.
	 * @return {@code true} if the value is out of the range.
	 */
	public function isOutOfRange(value:Number):Boolean 
	{
		return (value > max ) || (value < min) ;
	}

	/**
	 * Returns {@code true} if the range in argument overlap the current range.
	 * @return {@code true} if the range in argument overlap the current range.
	 */
	public function overlap(r:Range):Boolean 
	{
		return max > r.min && r.max > min ;
	}

	/**
	 * Returns the length of the range.
	 * @return the length of the range.
	 */
	public function size():Number
	{
		return max - min ;	
	}

	/**
	 * Returns the Eden reprensation of the object.
	 * @return a string representing the source code of the object.
	 */
	public function toSource(indent:Number, indentor:String):String 
	{
		return "new pegas.maths.Range(" + min + "," + max + ")";
	}

	/**
	 * Returns the string representation of this instance.
	 * @return the string representation of this instance.
	 */
	public function toString():String 
	{
		return "[Range<" + min + "," + max + ">]";
	}
	
}