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

/* ---------- Version
		

	CONSTRUCTOR
	
		new Version( major:Number, minor:Number, build:Number, revision:Number ) ;

   	PROPERY SUMMARY
	
		- build:Number [RW]
		
		- major:Number [R/W]
		
		- minor:Number [R/W]
		
		- revision:Number [R/W]

	METHOD SUMMARY

		- compareTo(o):Number
		
		- equals(o):Boolean
		
		- fromString(str:String):Version
		
		- getBuild():Number
		
		- getMajor():Number
		
		- getMinor():Number
		
		- getRevision():Number 
	
		- setBuild(value:Number):Void
		
		- setMajor(value::Number):Void
		
		- setMinor(value::Number):Void
	
		- setRevision(value::Number):Void
		
		- toSource(indent:Number, indentor:String):String
		
		- toString():String
		
		- valueOf()

	IMPLEMENTS

		IComparable
   
	NOTE


----------  */

import vegas.core.CoreObject;
import vegas.core.IComparable;
import vegas.core.IEquality;
import vegas.core.ISerializable;
import vegas.util.factory.PropertyFactory;
import vegas.util.MathsUtil;

/**
 * Represents a version number for a constructor, an environnement, a platform or other.
 * <p>Informations :</p>
 * {@code
 * 		1 5 432 10
 * 		0x  F F FFF FF
 * 		| |  |   |
 * 		| |  |   \revision (max 255)
 * 		| |  \build (max 4095)
 * 		| \minor (max 15)
 * 		\major (max 15)
 * 		
 * 		max version number is v15.15.4095.255
 * }
 * <p><b>Note : </b>value ranges are
 * <ul>
 * <li>0xF    - 0 ->    15</li>
 * <li>0xFF   - 0 ->   255</li>
 * <li>0xFFF  - 0 ->  4095</li>
 * </ul>
 * Max total value = 0xFFFFFFF
 * </p>
 * Thanks : Zwetan : http://www.zwetan.com/ in the post "[FMX] coding session 05" (FCNG.buRRRn.com)
 * @author eKameleon
 */
class asgard.system.Version extends CoreObject implements IComparable, IEquality, ISerializable 
{
	
	/**
	 * Creates a new Version instance with the specified major, minor, build, and revision numbers.
	 */
	public function Version( major:Number, minor:Number, build:Number, revision:Number ) 
	{
		this.major = _checkValue( major, 0xF ) ; // max : 15
		this.minor = _checkValue( minor, 0xF ) ; // max : 15
		this.build = _checkValue( build, 0xFFF ) ; // max : 4095
		this.revision = _checkValue( revision, 0xFF ) ;  // max : 255
		_value = major << 24 | minor << 20 | build << 8 | revision ;
	}

	/**
	 * Returns the value of the build component of the version number for the current Version object.
	 * @return the value of the build component of the version number for the current Version object.
	 */
	public function get build():Number 
	{
		return getBuild() ;
	}
	
	/**
	 * Sets the value of the build component of the version number for the current Version object.
	 */
	public function set build( n:Number ):Void
	{
		setBuild(n) ;	
	}

	/**
	 * Returns the value of the major component of the version number for the current Version object.
	 * @return the value of the major component of the version number for the current Version object.
	 */
	public function get major():Number
	{
		return getMajor() ;	
	}
	
	/**
	 * Sets the value of the major component of the version number for the current Version object.
	 */
	public function set major( n:Number ):Void
	{
		setMajor(n) ;
	}
	
	/**
	 * Returns the value of the minor component of the version number for the current Version object.
	 * @return the value of the minor component of the version number for the current Version object.
	 */
	public function get minor():Number
	{
		return getMinor() ;
	}
	
	/**
	 * Sets the value of the minor component of the version number for the current Version object.
	 */
	public function set minor( n:Number ):Void
	{
		setMinor( n ) ;	
	}
	
	/**
	 * Returns the value of the revision component of the version number for the current Version object.
	 * @return the value of the revision component of the version number for the current Version object.
	 */
	public function get revision():Number
	{
		return getRevision() ;
	}
	
	/**
	 * Sets the value of the revision component of the version number for the current Version object.
	 */
	public function set revision( n:Number ):Void
	{
		setRevision( n ) ;	
	}

	
	/**
	 * Compares the current Version object to a specified object or Version and returns an indication of their relative values.
	 * @return the compare value 1, -1 or 0
	 */
	public function compareTo(o):Number 
	{
		if( o == null ) return 1 ;
        if( equals( o )  ) return 0 ;
        else if ( valueOf() > o.valueOf() ) return 1 ; 
		return -1;
    }

	/**
	 * Returns a value indicating whether two Version object represent the same value.
	 * @return a value indicating whether two Version object represent the same value.
	 */
	public function equals(o):Boolean 
	{
		if( o == null ) return false ;
        if( !(o instanceof Version) ) return false;
		return( valueOf() == o.valueOf() );
    }

	/**
	 * Creates and returns a new Version with the specified string passed-in argument.
	 * @return a new Version with the specified string passed-in argument.
	 */
	public function fromString(str:String):Version 
	{
		var args:Array = str.split(".") ;
		var ver:Version  = new Version
		( 
			parseInt( args[0] ) ,
            parseInt( args[1] ) ,
            parseInt( args[2] ) ,
            parseInt( args[3] ) 
		) ;
		return ver ;
    }

	/**
	 * Returns the value of the build component of the version number for the current Version object.
	 * @return the value of the build component of the version number for the current Version object.
	 */
	public function getBuild():Number 
	{
		return( (_value & 0x00FFF00) >> 8 ) ;
    }

	/**
	 * Returns the value of the major component of the version number for the current Version object.
	 * @return the value of the major component of the version number for the current Version object.
	 */
	public function getMajor():Number 
	{
		return( (_value & 0xF000000) >> 24 );
    }

	/**
	 * Returns the value of the minor component of the version number for the current Version object.
	 * @return the value of the minor component of the version number for the current Version object.
	 */
	public function getMinor():Number 
	{
		return( (_value & 0x0F00000) >> 20 ) ;
    }
    
	/**
	 * Returns the value of the revision component of the version number for the current Version object.
	 * @return the value of the revision component of the version number for the current Version object.
	 */
	public function getRevision():Number 
	{
		return( _value & 0x00000FF ) ;
    }

	/**
	 * Sets the value of the build component of the version number for the current Version object.
	 */
	public function setBuild( value:Number ):Void 
	{
		var n:Number = _checkValue( value, 0xFFF );
		_value = ( (_value & 0xFF000FF) | (n << 8) );
    }

	/**
	 * Sets the value of the major component of the version number for the current Version object.
	 */
	public function setMajor( value:Number ):Void 
	{
		var n:Number = _checkValue( value, 0xF );
		_value = ( (_value & 0x0FFFFFF) | (n << 24) ) ;
    }

	/**
	 * Sets the value of the minor component of the version number for the current Version object.
	 */
	public function setMinor( value:Number ):Void 
	{
		var n:Number = _checkValue( value, 0xF );
		_value = ( (_value & 0xF0FFFFF) | (n << 20) );
    }

	/**
	 * Sets the value of the revision component of the version number for the current Version object.
	 */
	public function setRevision( value:Number ) 
	{
		var n:Number = _checkValue( value, 0xFF );
		_value = ( (_value & 0xFFFFF00) | n );
    }

	/**
	 * Returns the Eden {@code String} representation of the object.
	 * @return the Eden {@code String} representation of the object.
	 */
	public function toSource(indent:Number, indentor:String):String 
	{
		return "new asgard.system.Version(" + major + "," + minor + "," + build + "," + revision + ")" ;
	}

	/**
	 * Returns the {@code String} representation of the object.
	 * @return the {@code String} representation of the object.
	 */
	public function toString():String 
	{
		return [major, minor, build, revision].join(".") ;
    }

	/**
	 * Returns the primivite value of this object.
	 * @return the primivite value of this object.
	 */
	public function valueOf():Number 
	{
		return _value ;
    }
	
	private var _value:Number ;
	
	private function _checkValue( value:Number, max:Number) 
	{
		return MathsUtil.clamp(value, 0, max) ;
	}

}