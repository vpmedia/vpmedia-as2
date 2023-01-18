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
import buRRRn.ASTUce.IProtectable;
import buRRRn.ASTUce.ITest;
import buRRRn.ASTUce.ITestListener;
import buRRRn.ASTUce.TestCase;
import buRRRn.ASTUce.TestFailure;

import vegas.core.CoreObject;
import vegas.util.ArrayUtil;

/**
 * A TestResult collects the results of executing a test case.
 * It is an instance of the Collecting Parameter pattern.
 * The test framework distinguishes between failures and errors.
 * A failure is anticipated and checked for with assertions.
 * Errors are unanticipated problems like an ArrayIndexOutOfBoundsException.
 * @author eKameleon
 */
class buRRRn.ASTUce.TestResult extends CoreObject 
{

	/**
	 * Creates a new TestResult instance.
	 */
	public function TestResult() 
	{
		super();
		_failures  = [] ;
        _errors    = [] ;
        _listeners = [] ;
        _runTests  = 0 ;
        _stop      = false ;
	}

    /**
     * (read-only) Returns an Array for the errors.
     */
    public function get errors():Array
	{
		return _errors;
	}

    /**
     * (read-only) Returns the number of detected errors.
     */
	public function get errorCount():Number
	{
		return _errors.length;
	}
    
    /**
     * (read-only) Returns the number of detected failures.
     */
    public function get failureCount():Number
	{
		return _failures.length;
	}
    
    /**
     * (read-only) Returns an Array for the failures.
     */
	public function get failures():Array
	{
		return _failures;
	}

    /**
     * (read-only) Returns the number of run tests.
     */
    public function get runCount():Number
	{
		return _runTests;
	}
    
    /**
     * (read-only) Checks whether the test run should stop.
     */
    public function get shouldStop():Boolean
	{
		return _stop;
	}

    /**
     * Adds an error to the list of errors.
     * The passed in exception caused the error.
     */
    public function addError( test:ITest, e:Error ):Void
	{
		_errors.push( new TestFailure( test, e ) );
        
		var listeners:Array = cloneListeners() ;
        var len:Number = listeners.length ;
        for( var i:Number = 0 ; i<len ; i++ )
		{
			listeners[i].addError( test, e );
		}
		
	}

	/**
	 * Adds a failure to the list of failures. 
	 * The passed in exception caused the failure.
	 */
	public function addFailure( test:ITest, afe:AssertionFailedError ):Void
	{
		_failures.push( new TestFailure( test, afe ) ) ;
        var listeners:Array = cloneListeners() ;
        for( var i:Number = 0 ; i<listeners.length ; i++ )
		{
			listeners[i].addFailure( test, afe );
		}
	}
	
	/**
	 * Registers a TestListener.
	 */
	public function addListener( listener:ITestListener ):Void
	{
		_listeners.push( listener );
	}

    /**
     * Returns a copy of the listeners.
     */
    public function cloneListeners():Array
	{
        return [].concat(_listeners) ;
	}

    /**
     * Informs the result that a test was completed.
     */
	public function endTest( test:ITest ):Void
	{
		var listeners:Array = cloneListeners();
		var len:Number = listeners.length ;
        for( var i:Number = 0 ; i<len ; i++ )
		{
			listeners[i].endTest( test );
		}
	}

	/**
	 * Unregisters a TestListener.
	 */
    public function removeListener( listener:ITestListener ):Void
	{
		var index:Number ;
		index = ArrayUtil.indexOf( _listeners, listener );
		if( index > -1 )
        {
			_listeners.splice( index, 1 );
		}
	}
	
	/**
	 * Runs a TestCase.
	 */
	public function run( test:TestCase ):Void
	{
		
		startTest( test ) ;

        var p:IProtectable = new IProtectable();
        p.protect = function()
		{
			return test.runBare();
		} ;
        
        runProtected( test, p );

        endTest( test );
	}

	/**
	 * Runs a TestCase.
	 */
    public function runProtected( test:ITest, p:IProtectable ):Void
	{
		try
		{
			p.protect() ;
		}
        catch( e )
        {
			if( e instanceof AssertionFailedError )
			{
				addFailure( test, e );
			}
            else if( e instanceof Error )
			{
				addError( test, e );
			}
		}    
	}

    /**
     * Informs the result that a test will be started.
     */
	public function startTest( test:ITest ):Void
	{
		
		var count:Number = test.countTestCases();
		
		_runTests += count;
        
		var listeners:Array = cloneListeners() ;
		
		for( var i:Number = 0 ; i<listeners.length ; i++ )
		{
			listeners[i].startTest( test );
		}
	}
    
	/**
	 * Marks that the test run should stop.
	 */
	public function stop():Void
	{
		_stop = true ;	
	}
	
    /**
     * Returns whether the entire test was successful or not.
     * @return whether the entire test was successful or not.
     */
  	public function wasSuccessful():Boolean
	{
		return( (failureCount == 0) && (errorCount == 0) );
	}

	private var _errors:Array;

    private var _failures:Array;
    
    private var _listeners:Array;
    
    private var _runTests:Number;
    
    private var _stop:Boolean;

}