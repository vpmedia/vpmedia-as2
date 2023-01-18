
/*
  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is ASTUce: ActionScript Test Unit compact edition. 
  
  The Initial Developer of the Original Code is
  Zwetan Kjukov <zwetan@gmail.com>.
  Portions created by the Initial Developer are Copyright (C) 2004-2006
  the Initial Developer. All Rights Reserved.
  
  Contributor(s):
   
   	- Marc ALCARAZ (aka eKameleon) : adaptation to VEGAS framework.
     
*/

import buRRRn.ASTUce.AssertionFailedError;
import buRRRn.ASTUce.ComparisonFailure;
import buRRRn.ASTUce.Config;
import buRRRn.ASTUce.Strings;

import vegas.core.CoreObject;
import vegas.core.types.NullObject;
import vegas.string.StringFormatter;
import vegas.util.Comparater;
import vegas.util.ObjectUtil;
import vegas.util.serialize.Serializer;
import vegas.util.TypeUtil;

/**
 * A set of assert methods. Messages are only displayed when an assert fails.
 * Assertion is used because Assert is a reserved ECMAScript futur keyword.
 * @author eKameleon
 */
class buRRRn.ASTUce.Assertion extends CoreObject
{

	/**
	 * Asserts that two objects are equal.
	 * If they are not an <AssertionFailedError> is thrown/trace with the given message.
	 */
    static function assertEquals( expected, actual, message:String ):Void
	{
		
		if( (expected == null) && (actual == null) )
		{
			return ;
		}
		
		if ( (expected != null) && Comparater.compare(expected, actual ) )
		{
			return ;
		}
		
		if ((expected != null) && (expected == actual))
		{
			return ;	
		}
		
		if( TypeUtil.typesMatch( expected , String ) || TypeUtil.typesMatch( actual , String ) )
		{
            throw new ComparisonFailure( expected, actual, message );
		}
        else
		{
			_failNotEquals( expected, actual, message );
		}
		
	}
 	
 	/**
	 * Asserts that a condition is false. If it isn't it throws/trace an <AssertionFailedError> with the given message.
	 */
	static public function assertFalse( condition:Boolean , message:String ):Void
	{
		assertTrue( !condition, message );
	}

	/**
	 * Asserts that an object is not null.
	 * If it is an <AssertionFailedError> is thrown with the given message.
	 */
    static function assertNotNull( obj, message:String ):Void
	{
		assertTrue( obj != null, message ) ;
	}

	/**
     * Asserts that two objects refer to the same object.
     * If they are not an <AssertionFailedError> is thrown with the given message.
     */
	static function assertNotSame( expected, actual, message:String ):Void
	{
		if( expected == null )
		{
			expected = new NullObject() ;
		}
		if(  ObjectUtil.toBoolean( ObjectUtil.referenceEquals( expected, actual ) ) )
		{ 
			_failSame( expected, actual, message );
		}
	}  

    /**
     * Asserts that an object is not undefined.
     * If it is not an <AssertionFailedError> is thrown with the given message.
     */
	static function assertNotUndefined( obj, message:String ):Void
	{
		assertTrue( obj != undefined, message );
	}
	
	/**
	 * Asserts that an object is null.
	 * If it is an <AssertionFailedError> is thrown with the given message.
	 */
	static function assertNull( obj, message:String ):Void
	{
		assertTrue( obj == null, message );
	}

    /**
     * Asserts that two objects refer to the same object.
     * If they are not an <AssertionFailedError> is thrown with the given message.
     * Note : same object mean same reference so the comparison is by reference not by value.
     */
	static function assertSame( expected, actual, message:String ):Void
	{
		
		if( expected == null )
		{
			expected = new NullObject() ;
		}
        
        if( ObjectUtil.referenceEquals( expected, actual ) )
		{
			return;
		}
        
		_failNotSame( expected, actual, message );
		
	}

	/**
	 * Asserts that a condition is true. If it isn't it throws/trace an <AssertionFailedError> with the given message.
	 */
	static public function assertTrue( condition:Boolean , message:String ):Void
	{
		if ( !condition )
		{
			fail(message) ;	
		}
	}
    
    /**
     * Asserts that an object is undefined.
     * If it is not an <AssertionFailedError> is thrown with the given message.
     */
    static function assertUndefined( obj, message:String ):Void
	{
		assertTrue( obj == undefined, message );
	}
    
	/**
	 * Fails a test with the given message.
	 */
	static public function fail( message:String ):Void
	{
		throw new AssertionFailedError( message );
	}

	/**
	 * Format the message.
	 */
	static public function format( expected, actual, message )
	{
		var formatted:String = "" ;
		if ( (message != null) && (message != "") )
		{
			formatted = message + " " ;	
		}
		return (new StringFormatter( Strings.expectedButWas )).format(formatted, expected, actual) ;
	}
	
	/**
	 * Fails a test when 2 objects are not equals.
	 */
	static private function  _failNotEquals( expected, actual, message:String )
    {
    	
    	if( Config.showObjectSource && (expected != null) && (actual != null) )
        {
        	expected = Serializer.toSource(expected);
        	actual   = Serializer.toSource(actual) ;
        }
    
    	if( Config.invertExpectedActual )
	    {
        	var tmp  = expected;
        	expected = actual;
        	actual   = tmp;
        }
    
    	fail( format( expected, actual, message ) );
    }

	/**
	 * Fails a test when 2 objects are not the same.
	 */
    static function _failNotSame( expected, actual, message:String ):Void
	{
		var formatted:String = "";
		if( message != null )
		{
			formatted= message + " ";
		}
        fail( (new StringFormatter( Strings.expectedSame)).format( formatted, expected, actual ) ) ;
	}

	/**
	 * Fails a test when 2 objects are the same.
	 */
    static function _failSame( expected, actual, message:String ):Void
	{
		var formatted:String = "";
		if( message != null )
		{
			formatted = message + " ";
		}
        
		fail( (new StringFormatter( Strings.expectedNotSame )).format( formatted ) ) ;
	}

}