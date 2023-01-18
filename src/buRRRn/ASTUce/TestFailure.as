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
import buRRRn.ASTUce.ITest;

/**
 * A TestFailure collects a failed test together with the caught exception.
 * @author eKameleon
 */
class buRRRn.ASTUce.TestFailure
{
	
	/**
	 * Creates a new TestFailure instance.
	 */
	public function TestFailure( failedTest:ITest, thrownException:Error ) 
	{
		_failedTest      = failedTest ;
        _thrownException = thrownException ;
	}

	/**
	 * Returns the exception message.
	 */
    public function get exceptionMessage():String
	{
		 var ret:String = thrownException.getMessage() || thrownException.message ;
		 return ret ;
	}

    /**
     * Returns the failed test.
     */
    public function get failedTest()
	{
        return _failedTest;
	}
    
   	/**
	 * Returns the thrown exception.
	 */
	public function get thrownException()
	{
		return _thrownException;
	}

    /**
     * Returns a Boolean indicating if the failure was an AssertionFailedError.
     */
    public function isFailure():Boolean
	{
		return( thrownException instanceof AssertionFailedError );
	}
	
	/**
	 * Returns the string representation of this object.
	 * @return the string representation of this object.
	 */
	public function toString():String
	{
		return ( failedTest + " : " + exceptionMessage ) ;
	}

    private var _failedTest:ITest ;
    
    private var _thrownException:Error;

}