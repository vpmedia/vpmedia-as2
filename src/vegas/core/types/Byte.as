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

import vegas.core.types.Bit;
import vegas.util.ConstructorUtil;

/**
 * {@code Byte} is represents a byte value.
 * <p>{@code Byte} can be used for a different kind of formatting of a byte value.
 * It allows to access the value as bit, kilo-bit, mega-bit, giga-bit, tera-bit, byte, kilo-byte, mega-byte, giga-byte and tera-byte.
 * </p>
 * <p><b>Examples:</b></p>
 * {@code 
 *   import vegas.core.types.Byte ;
 *   trace(new Byte(1).toString()) ; // 1B
 *   trace(new Byte(1234).toString()) ; // 1.21KB
 *   trace(new Byte(15002344).toString()) ; // 14.31MB
 * }
 * @author eKameleon
 */
class vegas.core.types.Byte extends Bit
{

	/**
	 * Creates a new Byte instance.
	 * @param bytes value in byte
	 */
	public function Byte( bytes:Number ) 
	{
		super( bytes * BYTE );
	}

	/**
	 * Shortname of byte.
	 */
	static public var SHORT_BYTE:String = "B" ;

	/**
	 * Shortname of kilo-byte.
	 */
	static public var SHORT_KILO_BYTE:String = "KB";

	/**
	 * Shortname of mega-byte.
	 */
	static public var SHORT_MEGA_BYTE:String = "MB";

	/**
	 * Shortname of giga-byte.
	 */
	static public var SHORT_GIGA_BYTE:String = "GB";

	/**
	 * Shortname of tera-byte.
	 */
	static public var SHORT_TERA_BYTE:String = "TB";	

	/**
	 * Returns a Eden reprensation of the object.
	 * @return a string representing the source code of the object.
	 */
	public function toSource(indent:Number, indentor:String):String
	{
		return "new " + ConstructorUtil.getPath(this) + "(" + (_bit  / BYTE) + "," + _comma  + ")" ;
	}

	/**
	 * Returns a string representation of the object.
	 */
	public function toString(indent:Number, indentor:String):String 
	{
		if (_bit < Bit.KBYTE) 
		{
			return getBytes() + Byte.SHORT_BYTE ;
		}
		else if(_bit < Bit.MBYTE) 
		{
			return getKBytes() + Byte.SHORT_KILO_BYTE ;
		}
		else if(_bit < Bit.GBYTE) 
		{
			return getMegaBytes() + Byte.SHORT_MEGA_BYTE ;
		}
		else if(_bit < Bit.TBYTE) 
		{
			return getGigaBytes() + Byte.SHORT_GIGA_BYTE ;
		}
		else 
		{
			return getTeraBytes() + Byte.SHORT_TERA_BYTE ;
		}
	}
	
}
