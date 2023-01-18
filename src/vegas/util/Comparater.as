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

import vegas.core.IEquality;
import vegas.util.StringUtil;
import vegas.util.TypeUtil;

/**
 * The {@code Comparater} utility class is an all-static class with a method to returns {@true} if two object are equals.
 * @author eKameleon
 */
class vegas.util.Comparater
{

	/**
	 * Compares if two objects are equal by value. 
	 * @param o1 the first object to compare.
	 * @param o2 the second object to compare.
	 * @return {@code true} if the 2 objects are equals.
	 */	
	static public function compare( o1, o2 ) 
	{
		if (o1 === undefined && o2 === undefined) 
		{
			return true ;
		}
		if (o1 === null && o2 === null)
		{
			return true ;
		}
		if (o1 instanceof IEquality) 
		{
			return o1.equals(o2) ;
		}
		else if (TypeUtil.typesMatch(o1, Array)) 
		{
			return arrayCompare(o1, o2) ;
		}
		else if (TypeUtil.typesMatch(o1, Boolean)) 
		{
			return booleanCompare(o1, o2);
		}
		else if (TypeUtil.typesMatch(o1, Date))
		{
			return dateCompare(o1, o2) ;
		}
		else if (TypeUtil.typesMatch(o1, Error))
		{
			return errorCompare(o1, o2) ;	
		}
		else if (TypeUtil.typesMatch(o1, Function))
		{
			return functionCompare(o1, o2) ;
		}
		else if (TypeUtil.typesMatch(o1, Number))
		{
			return numberCompare(o1, o2) ;
		}
		else if (TypeUtil.typesMatch(o1, String))
		{
			return stringCompare(o1, o2) ;
		}
		else if (typeof(o1) === "object")
		{
			return objectCompare(o1, o2) ;
		}
		else
		{
			return o1 == o2 ;
		}
	}	

	/**
	 * Compares if two Arrays are equal by value. 
	 * @return {@code true} if the 2 objects are equals.
	 */
	static public function arrayCompare( ar1, ar2 ):Boolean
    {
	    
	    if(ar1 == null || !TypeUtil.typesMatch(ar1, Array))
	    {
	    	return false ;	
	    }
	    
    	if(ar2 == null || !TypeUtil.typesMatch(ar2, Array)) 
        {
        	return false ;
        }
    
    	if( ar1 == ar2 )
        {
        	return true ;
        }
    
    	if( ar1.length != ar2.length )
        {
        	return false ;
        }
    
    	var len:Number = ar1.length ;
    	for( var i:Number = 0 ; i < len ; i++ )
        {
        	if( ar1[i] == null )
            {
            	if( ar1[i] != ar2[i] )
                {
                	return false;
                }
            	continue ;
            }
        
        	if( ! compare(ar1[i], ar2[i] ) )
            {
            	return false ;
            }
        }
    
    	return true ;
    }

	/**
	 * Compares if two Booleans are equal by value. 
	 * @return {@code true} if the 2 objects are equals.
	 */
	static public function booleanCompare( b1 , b2 ):Boolean
    {
    	if(b1 == null || !TypeUtil.typesMatch(b1, Boolean))
        {
        	return false ;
        }
    	if(b2 == null || !TypeUtil.typesMatch(b2, Boolean))
        {
        	return false ;
        }
    	return b1.valueOf() == b2.valueOf() ;
    }

	/**
	 * Compares if two Dates are equal by value.
	 * @return {@code true} if the 2 objects are equals.
	 */
	static public function dateCompare( d1 , d2 ):Boolean
	{
    	if(d1 == null || !TypeUtil.typesMatch(d1, Date))
        {
        	return false ;
        }
    	if(d2 == null || !TypeUtil.typesMatch(d2, Date))
        {
        	return false ;
        }
		return d1.toString() == d2.toString() ;
	}
	
	/**
	 * Compares if two Errors are equal by value.
	 * @return {@code true} if the 2 objects are equals.
	 */
	static public function errorCompare( e1 , e2 ):Boolean
	{
    	if(e1 == null || !TypeUtil.typesMatch(e1, Error))
        {
        	return false ;
        }
    	if(e2 == null || !TypeUtil.typesMatch(e2, Error))
        {
        	return false ;
        }
		return e1.toString() == e2.toString() ;
	}
	
	/**
	 * Compares if two Functions are equal by value.
	 * @return {@code true} if the 2 objects are equals.
	 */
	static public function functionCompare( f1 , f2:Function ):Boolean
	{
    	if(f1 == null || !TypeUtil.typesMatch(f1, Function))
        {
        	return false ;
        }
    	if(f2 == null || !TypeUtil.typesMatch(f2, Function))
        {
        	return false ;
        }
		return f1.valueOf() == f2.valueOf() ;
	}

	/**
	 * Compares if two Numbers are equal by value.
	 * @return {@code true} if the 2 objects are equals.
	 */
	static public function numberCompare( n1 , n2 ):Boolean
	{
    	
    	if(n1 == null || !TypeUtil.typesMatch(n1, Number))
        {
        	return false ;
        }
    	if(n2 == null || !TypeUtil.typesMatch(n2, Number))
        {
        	return false ;
        }

		if ( n1.valueOf() == n2.valueOf() )
		{
			return true ;
		}

		// Test if the 2 objects are NaN
        if ( isNaN(n1) && isNaN(n2) )
        {
        	return true ;	
        }

		if ( n1.toString() == n2.toString() ) 
		{
			return true ;	
		}

		return false ;
	}
	
	/**
	 * Compares if two Objects are equal by value.
	 * @return {@code true} if the 2 objects are equals.
	 */
	static public function objectCompare( o1 , o2 ):Boolean
	{
		if ( TypeUtil.typesMatch(o2, Function ) )
		{
			return functionCompare( o2, o1 ) ;	
		}
		if ( o1.valueOf() == null && o2 == null )
		{
			return true ;
		}
		if (o2 == null || !TypeUtil.typesMatch(o2, Object))
		{
			return false ;	
		}
		if ( o1 == o2 )
		{
			return true ;
		}
		
		for (var member:String in o1)
		{
			/* Note: by convention we consider members starting with __
           		to be internal properties which should not be compared.
        	*/
			if ( StringUtil.startsWith(member, "__") ) 
			{
				continue ;	
			}
			if( !Comparater.compare(o1[member], o2[member] ) )
            {
            	return false;
            }
        }	
        
		return true ;		
	}
	
	/**
	 * Compares if two Strings are equal by value.
	 * @return {@code true} if the 2 objects are equals.
	 */
	static public function stringCompare( s1 , s2 ):Boolean
    {
    	if( (s1 == null) || !TypeUtil.typesMatch( s2 , String ) )
        {
        	return false ;
        }
        
    	if( (s2 == null) || !TypeUtil.typesMatch( s2 , String ) )
        {
        	return false ;
        }
    
    	if( s1.toString() == s2.toString() )
        {
        	return true;
        }
    
	    return false;

    }

}