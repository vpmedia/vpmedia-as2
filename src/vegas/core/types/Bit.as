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

import vegas.core.HashCode;
import vegas.core.IFormattable;
import vegas.core.IHashable;
import vegas.core.ISerializable;
import vegas.util.ConstructorUtil;
import vegas.util.MathsUtil;

/**
 * Bit represents a bit value.
 * This class is too an enumeration of all bit and bytes values. 
 * <p>{@code Bit} can be used for a different kind of formatting of a bit value. 
 * It allows to access the value as bit, kilo-bit, mega-bit, giga-bit, tera-bit, byte, kilo-byte, mega-byte, giga-byte and tera-byte.
 * </p>
 * <p><b>Examples:</b></p>
 * {@code 
 *   import vegas.core.types.Bit ;
 *   trace(new Bit(1).toString()) ; // 1b
 *   trace(new Bit(1234).toString()) ; // 1.21Kb
 *   trace(new Bit(15002344).toString()) ; // 14.31Mb
 * }
 * @author eKameleon
 */
class vegas.core.types.Bit extends Number implements IFormattable, IHashable, ISerializable  
{

	/**
	 * Creates a new Bit instance.
	 * @param b value in bit
	 */
	public function Bit(n:Number, floatingPoints:Number ) 
	{
		_bit = n ;
		if (isNaN(floatingPoints))
		{
			_comma = DEFAULT_FLOATING_POINTS ;
		}
		else
		{
			setFloatingPoints(floatingPoints) ;	
		}
	}

	/**
	 * Default floating points used.
	 */
	static public var DEFAULT_FLOATING_POINTS:Number = 2 ;

	/**
	 * Size of a byte.
	 */
	static public var BYTE:Number = 8 ; // BYTE

	/**
	 * Size of a kilo.
	 */
	static public var KBIT:Number = 1024 ;

	/**
	 * Size of a kilobyte.
	 */
	static public var KBYTE:Number = KBIT * BYTE ;

	/**
	 * Size of a megabit.
	 */
	static public var MBIT:Number = KBIT * KBIT ;

	/**
	 * Size of a megabyte
	 */
	static public var MBYTE:Number = KBYTE * KBIT ;
	
	/**
	 * Size of a gigabit.
	 */
	static public var GBIT:Number = MBIT * KBIT ;
	
	/**
	 * Size of a gigabyte.
	 */
	static public var GBYTE:Number = MBYTE * KBIT ;
	
	/**
	 * Size of a terabit.
	 */
	static public var TBIT:Number = GBIT * KBIT ;

	/**
	 * Size of a terabyte.
	 */	
	static public var TBYTE:Number = GBYTE * KBIT ;
	
	/**
	 * Shortname of bit.
	 */
	static public var SB:String = "b" ;

	/**
	 * Shortname of kilobit.
	 */
	static public var SKB:String = "Kb" ;
	
	/**
	 * Shortname of megabit.
	 */
	static public var SMB:String = "Mb" ;

	/**
	 * Shortname of gigabit.
	 */
	static public var SGB:String = "Gb" ;

	/**
	 * Shortname of terabit.
	 */
	static public var STB:String = "Tb" ;

	/**
	 * Returns the value in bit.
	 * @return value in bit
	 */
	public function getBit():Number 
	{
		return _bit ;
	}

	/**
	 * Returns the value in bytes.
	 * @return value in bytes
	 */
	public function getBytes():Number 
	{
		return MathsUtil.round( _bit / BYTE, _comma) ;
	}

	/**
	 * Returns the value in kilobit.
	 * @return value in kilobit
	 */
	public function getKBit():Number 
	{
		return MathsUtil.round( _bit / KBIT, _comma) ;
	}

	/**
	 * Returns the value in kilobytes.
	 * @return value in kilobytes
	 */
	public function getKBytes():Number 
	{
		return MathsUtil.round( _bit / KBYTE, _comma) ;
	}

	/**
	 * Returns the value in megabit.
	 * @return value in megabit
	 */
	public function getMegaBit():Number 
	{
		return MathsUtil.round( _bit / MBIT, _comma) ;
	}

	/**
	 * Returns the value in megabytes.
	 * @return value in megabytes
	 */
	public function getMegaBytes():Number 
	{
		return MathsUtil.round( _bit / MBYTE, _comma) ;
	}

	/**
	 * Returns the value in gigabit.
	 * @return value in gigabit
	 */
	public function getGigaBit():Number 
	{
		return MathsUtil.round( _bit / GBIT, _comma) ;
	}

	/**
	 * Returns the value in gigabytes.
	 * @return value in gigabytes
	 */
	public function getGigaBytes():Number 
	{
		return MathsUtil.round( _bit / GBYTE, _comma) ;
	}
	
	/**
	 * Returns the value in terabit.
	 * @return value in terabit
	 */
	public function getTeraBit():Number 
	{
		return MathsUtil.round( _bit / TBIT, _comma);
	}

	/**
	 * Returns the value in terabytes.
	 * @return value in terabytes
	 */
	public function getTeraBytes():Number 
	{
		return MathsUtil.round(_bit / TBYTE, _comma);
	}

	/**
	 * Returns a hash code value for the object.
	 */
	public function hashCode():Number 
	{
		return null ;
	}
	
	/**
	 * Sets the used amount of values after the comma.
	 * <p>This method does not change anything if {@code fp} is smaller than 0 or not passed-in.</p>
	 * @param n amount of characters after the floating point
	 * @return the current instance
	 */
	public function setFloatingPoints(n:Number):Bit 
	{
		_comma = (n > 0) ? n : 0 ;
		return this ;
	}
	
	/**
	 * Returns a Eden reprensation of the object.
	 * @return a string representing the source code of the object.
	 */
	public function toSource(indent:Number, indentor:String):String
	{
		return "new " + ConstructorUtil.getPath(this) + "(" + _bit + "," + _comma  + ")" ;
	}

	/**
	 * Returns a string representation of the object.
	 * @return a string representation of the object.
	 */
	public function toString():String 
	{
		if (_bit < KBIT) 
		{
			return getBit() + SB ;
		}
		else if(_bit < MBIT)
		{
			return getKBit() + SKB ;
		}
		else if(_bit < GBIT) 
		{
			return getMegaBit() + SMB ;
		}
		else if(_bit < TBIT) 
		{
			return getGigaBit() + SGB ;
		}
		else 
		{
			return getTeraBit() + STB ;
		}
	}
	
	/**
	 * Returns the real value of the object.
	 */
	public function valueOf() 
	{
		return getBytes().valueOf();
	}
	
	/**
	 * Internal amout value of bits.
	 */
	private var _bit:Number ;
	
	/**
	 * Internal value for the comma seperation.
	 */
	private var _comma:Number ;
	
	static private var _initHashCode:Boolean = HashCode.initialize(Bit.prototype) ;	
	

}
