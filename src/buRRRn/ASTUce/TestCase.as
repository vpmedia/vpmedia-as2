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
import buRRRn.ASTUce.Config;
import buRRRn.ASTUce.ITest;
import buRRRn.ASTUce.Strings;
import buRRRn.ASTUce.TestResult;

import vegas.string.StringFormatter;
import vegas.util.ConstructorUtil;
import vegas.util.ObjectUtil;
import vegas.util.StringUtil;

/**
 * A test case defines the fixture to run multiple tests. To define a test case :
 * <ul>
 * <li>implement a subclass of TestCase.</li>
 * <li>define instance variables that store the state of the fixture.</li>
 * <li>initialize the fixture state by overriding setUp</li>
 * <li>clean-up after a test by overriding tearDown.</li>
 * </ul>
 * <p>Each test runs in its own fixture so there can be no side effects among test runs.</p>
 * @author eKameleon
 */
class buRRRn.ASTUce.TestCase extends Assertion implements ITest 
{
	
	/**
	 * Constructs a test case with the given name or null if name is not provided.
	 * @param name the name of the test case.
	 */
	function TestCase( name:String ) 
	{
		_name = name ;
	}

    /**
     * (read-only) Returns the name of a TestCase.
     */
    public function get name():String
	{
		return _name;
	}
    
	/**
	 * (read-only) Sets the name of a TestCase.
	 */
    public function set name( value:String ):Void
	{
		_name = value;
	}

	/**
	 * Counts the number of test cases executed by run (TestResult result).
	 */
	public function countTestCases():Number 
	{
		return 1 ;
	}

    /** 
     * Creates a default TestResult object.
     */
	public function createResult():TestResult
	{
		return new TestResult();
	}

	/**
	 * Runs the test case and collects the results in TestResult.
	 */
	public function run( result:TestResult ):Void 
	{
		if( result == null )
		{
			result = createResult();
		}
        result.run( this );
	}

    /**
     * Runs the bare test sequence.
     */
	public function runBare():Void
	{
        
        setUp();
        try
		{
            runTest() ;
		}
		/*catch( e )
		{
            //trace( e ); // debug only.
		}
		*/
		finally
		{
			tearDown() ;
		}
        
	}

    /**
     * A convenience method to run this test, collecting the results with a default TestResult object.
     * @see TestResult
     */
	public function runEmpty():TestResult
	{
		var result:TestResult = createResult();
		run( result );
		return result;
	}

    /**
     * Override to run the test and assert its state.
     */
    public function runTest():Void
	{

		var runMethod:Function ;
        
		assertNotNull( _name, Strings.methodNameNull ) ;
        
		assertNotUndefined( _name, Strings.methodNameUndef ) ;
        
		try
		{
			
            if( ! ObjectUtil.hasProperty( this, _name ) )
			{
				throw new Error();
			}
            
			runMethod = this[_name];
		}
        catch( e )
		{
			fail( (new StringFormatter( Strings.methodNotFound )).format(_name) ) ;
		}
        
        if( StringUtil.startsWith(_name, "_" ) && ( Config.testPrivateMethods != true) ) 
		{
			fail( (new StringFormatter( Strings.methodshouldBePublic)).format( _name ) ) ; 
		}
        
        try
		{
			runMethod.call( this ) ;
		}
		catch( e:Error )
		{
			throw e ;
		}
	}

    /**
     * Sets up the fixture, for example, open a network connection.
     * This method is called before a test is executed.
     */
    public function setUp():Void
	{
    	//    
	}

    /**
     * Tears down the fixture, for example close a network connection. 
     * This method is called after a test is executed.
	 */
	public function tearDown():Void
	{
		//    
	}
	
	/**
	 * Returns the string representation of this object.
	 * @return the string representation of this object.
	 */
    public function toString():String
	{
        var className = ConstructorUtil.getName( this["__constructor__"] ) ;
        return className + "(" + _name + ")" ;
	}

	private var _name:String ;

}