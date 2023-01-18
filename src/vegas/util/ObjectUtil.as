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

import vegas.util.Copier;
import vegas.util.TypeUtil;

/**
 * The {@code ObjectUtil} utility class is an all-static class with methods for working with object.
 * @author eKameleon
 */
class vegas.util.ObjectUtil 
{

	/**
	 * Returns the shallow copy of the object.
	 * @return the shallow copy of the object.
	 */
	static public function clone(o) 
	{
		return o ;	
	}

	/**
	 * Returns the deep copy of the object.
	 * @return the deep copy of the object.
	 */
	static public function copy(o) 
	{
		var obj:Object = {} ;
		var prop:String ;
		for (prop in o) 
		{
			if( ! o.hasOwnProperty( prop ) ) 
			{
			  	continue ;
		  	}
		  	else if ( o[prop] == undefined ) 
		  	{
		  		obj[prop] = undefined ;
		  	}
		  	else if ( o[prop] == null ) 
		  	{
		  		obj[prop] = null ;
			}
			else 
			{
		  		obj[prop] = Copier.copy( o[prop] ) ; 
		  	}
		}
		return obj ;
	}

	/**
	 * Returns a Boolean value indicating whether an object has a property with the specified name (*ECMA-262*). 
	 * @return {@code true} whether the property is in the prototype chain or not.
	 */
	static public function hasProperty(o, prop:String):Boolean 
	{
		return ( o[prop] != undefined );
	}

	/**
	 * Returns {@code true} if the passed object is empty of enumerable property.
	 */
	static public function isEmpty(o):Boolean 
	{
		for (var each:String in o) 
		{
			return false ;	
		}
		return true ;
	}

	/**
	 * Creates a shallow copy of the current Object.
	 */
	static public function memberwiseClone( o ) 
	{
    	var obj = {} ;
    	for( var prop:String in o ) 
    	{
        	obj[prop] = o[prop];
        }
		return obj;
    }

	/**
	 * Determines whether the specified Object instance is the same instance as the current object.
	 */
	static public function referenceEquals( o1, o2):Boolean
	{
		if( ( o1.valueOf() === null) && (o2 === null) )
		{
			return true;
		}

    	if( o1 === o2 )
        {
        	return true ;
        }
    
    	if( ( o1 == null) || TypeUtil.typesMatch(o2, Object) )
        {
        	return false ;
        }
    
		if( o1 !== o2 )
		{
        	return false;
		}

		return true;	
	}

	/**
	 * Converts an object to an equivalent Boolean value.
	 */
	static public function toBoolean(o):Boolean 
	{
		return (new Boolean( o.valueOf() )).valueOf() ;
	}

	/**
	 * Converts an object to an equivalent Number value.
	 */
	static public function toNumber(o):Number 
	{
		return (new Number( o.valueOf() )).valueOf() ;
	}

	/**
	 * Converts an object to an equivalent Object value.
	 */
	static public function toObject(o):Object 
	{
		return new Object( o.valueOf() ) ;
	}

}
