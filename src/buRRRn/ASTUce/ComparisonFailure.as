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

import buRRRn.ASTUce.Assertion;
import buRRRn.ASTUce.AssertionFailedError;

/**
 * Thrown when an assert equals for Strings failed.
 * @author eKameleon
 */
class buRRRn.ASTUce.ComparisonFailure extends AssertionFailedError 
{

	/**
	 * Creates a new ComparisonFailure instance.
	 * @param expected the expected string value.
	 * @param actual the actual string value. 
	 * @param message the identifying message or null.
	 */	
	function ComparisonFailure( expected, actual, message:String ) 
	{
		
		super(message);
		
		_expected = String( expected );
        _actual   = String( actual );
        
        name = "ComparisonFailure" ;
        
	}

	/**
	 * Returns "..." in place of common prefix and "..." in place of common suffix between expected and actual.
	 * @return "..." in place of common prefix and "..." in place of common suffix between expected and actual.
	 */
	public function getMessage():String
	{
		
		if( (_expected == null) || (_actual == null) )
		{
			return Assertion.format( _expected, _actual, this.message );
		}
        
        var expected, actual, end, dots, i, j, k ;
        expected = "" ;
        actual   = "" ;
        end      = Math.min( _expected.length, _actual.length ) ;
        dots     = "..." ;
        
        for( i=0; i<end; i++ )
		{
			if( _expected.charAt(i) != _actual.charAt(i) )
			{
				break;
			}
		}
        
        j = _expected.length - 1 ;
        k = _actual.length - 1 ;
        
        for( ; k>=i && j>=i; k--,j-- )
		{
			if( _expected.charAt(j) != _actual.charAt(k) )
			{
				break;
			}
		}
        
		if( j<i && k<i )
		{
			expected = _expected;
			actual   = _actual;
		}
		else
		{
			expected = _expected.substring( i, j+1 );
			actual   = _actual.substring(   i, k+1 );

			if( i<=end && i>0 )
			{
				expected = dots + expected;
				actual   = dots + actual;
			}
			
			if( j < _expected.length-1 )
			{
				expected = expected + dots;
			}
            
			if( k < _actual.length-1 )
			{
				actual = actual + dots;
			}
		}
        
        return Assertion.format( expected, actual, message );
		
    }

	private var _actual:String ;
    
    private var _expected:String;
    
}