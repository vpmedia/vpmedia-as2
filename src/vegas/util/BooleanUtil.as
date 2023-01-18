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

/**
 * The {@code BooleanUtil} utility class is an all-static class with methods for working with boolean objects.
 * @author eKameleon
 */
class vegas.util.BooleanUtil 
{

    /**
     * Returns a copy by reference of this boolean.
     */
	static public function clone(b:Boolean):Boolean 
	{
		return b ;
	}
    
    /**
     * Returns a copy by value of this object.
     */
	static public function copy(b:Boolean):Boolean 
	{
		return b.valueOf() ;
	}

    /**
     * compare if two Booleans are equal by value.
     */
	static public function equals( b1:Boolean, b2:Boolean ):Boolean 
	{
		if ( b1 == null ) 
		{
			return false ;
		}
		if ( b2 == null ) 
		{
			return false ;
		}
		return (b1.valueOf() == b2.valueOf()) ;
    }

	/**
	 * Converts to an equivalent Boolean value.
	 */
	static public function toBoolean(b:Boolean):Boolean 
	{
		return b.valueOf() ;
	}

	/**
 	 * Converts to an equivalent Number value.
 	 */
	static public function toNumber(b:Boolean):Number 
	{
		return  b.valueOf() == true ? 1 : 0 ;
    }

	/**
	 * Converts to an equivalent Object value.
	 */
	static public function toObject(b:Boolean):Object 
	{
		return new Boolean( b.valueOf() ) ;
    }

    /**
     * Returns a string representing the source code of the boolean.
     */
    static public function toSource( b:Boolean ):String 
    {
		return BooleanUtil.equals(arguments[0], true) ? "true" : "false" ;
    }

}