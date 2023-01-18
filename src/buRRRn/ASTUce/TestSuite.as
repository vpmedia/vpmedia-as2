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
import buRRRn.ASTUce.Config;
import buRRRn.ASTUce.ITest;
import buRRRn.ASTUce.Strings;
import buRRRn.ASTUce.TestCase;
import buRRRn.ASTUce.TestResult;

import vegas.string.StringFormatter;
import vegas.util.Attribute;
import vegas.util.AttributeType;
import vegas.util.ConstructorUtil;
import vegas.util.StringUtil;
import vegas.util.TypeUtil;

/**
 * A TestSuite is a Composite of Tests (implements ITest).
 * It runs a collection of test cases.
 * @author eKameleon
 */
class buRRRn.ASTUce.TestSuite implements ITest 
{

	/**
	 * Creates a new TestSuite instance.
	 * @param theConstructor optionnal, can be either an object or a string, if a string he takes precedence over the name argument.
	 * @param name optionnal, the name of the test suite.
	 * @param simpleTrace optionnal, allows you to reduce the amount of tracing in the output to 1 line.
	 */	
	public function TestSuite( theConstructor , name:String, simpleTrace:Boolean ) 
	{
		super();
       
		if( simpleTrace == null )
		{
			simpleTrace = false;
		}
        
		this.simpleTrace = simpleTrace ;
		this._tests      = [] ;
		this._name       = "Unknown" ;
        
        // Constructs an empty TestSuite
        if( (theConstructor == null) && (name == null) )
		{
			return ;
		}
        
		// theConstructor is a string
        if( TypeUtil.typesMatch( theConstructor , String ) )
		{
			_name = theConstructor ;
			return ;
		}
        
        var ctorName:String ;
        
        if( theConstructor["prototype"] == null )
		{

            addTest( _warning( (new StringFormatter( Strings.objectNotCtor )).format( ConstructorUtil.getPath( theConstructor ) ) ) ) ;
            return;
		}
        else
		{
            ctorName = ConstructorUtil.getName( new Object(theConstructor) ) ;
		}
        
        /* attention:
           Due to ECMAscript limitation all custom constructors
           are public, but by convention constructors starting
           with "_" are considered private.
        */
        
        if( StringUtil.startsWith( ctorName, "_" ) )
		{
            addTest( _warning( (new StringFormatter( Strings.ctorNotPublic )).format( ctorName ) ) );
            return;
		}
        
        if( name == null )
		{
            _name = ctorName;
		}
        else
		{
			_name = name;
		}
        
        /* attention:
           by default every AS2 class has its prototype flag DONTENUM
           set to true, so we set it to false to allow properties enumeration.
        */
        
        var parentAttribute:Attribute ;
        var originalAttribute:Attribute = Attribute.getAttribute( theConstructor["prototype"], null );
        
        Attribute.setAttribute( theConstructor["prototype"] , null, AttributeType.NONE , AttributeType.LOCKED );
        
        if
        ( 
        	Config.testInheritedTests && 
			( theConstructor["prototype"].__proto__ != Function(TestCase).prototype ) &&
            ( theConstructor["prototype"].__proto__ != Object.prototype ) &&
            ( theConstructor["prototype"].__proto__ != null ) )
		{
            parentAttribute = Attribute.getAttribute( theConstructor["prototype"].__proto__, null );
            Attribute.setAttribute( theConstructor["prototype"].__proto__, null, AttributeType.NONE, AttributeType.LOCKED );
		}
        
        for( var member:String in theConstructor["prototype"] )
		{
            /* attention:
               if we use
               if( theConstructor.prototype.hasOwnProperty( member ) )
               we can't inherits testCase
            */
            if( typeof( theConstructor["prototype"][member] ) == "function" )
			{
                _addTestMethod( member, theConstructor );
			}
		}
        
        //trace( Object.prototype.toSource.call( theConstructor.prototype, 0 ) );
        Attribute.setAttribute( theConstructor["prototype"], null, originalAttribute, originalAttribute );
        
		if( Config.testInheritedTests && (parentAttribute != undefined) )
		{
			Attribute.setAttribute( theConstructor["prototype"].__proto__, null, parentAttribute, parentAttribute );
		}
		
		if( testCount == 0 )
		{
			addTest( _warning( (new StringFormatter( Strings.noTestsFound )).format( ctorName ) ) ) ;
		}
	}


    /**
     * (read-write) Returns the name of the suite.
     * Not all test suites have a name and this method can return null.
     */
    public function get name():String
	{
		return _name;
	}

    /**
     * (read-write) Sets the name of the suite.
     */
    public function set name( value:String ):Void
	{
		_name = value;
	}

	/**
	 * Defined if the tracer is a simple trace method or not.
	 */
	public var simpleTrace:Boolean ;

    /**
     * (read only) Returns the number of tests in this suite.
     */
    public function get testCount():Number
	{
		return _tests.length;
	}

    /**
     * (read-only) Returns the tests as an Array.
     */
    public function get tests():Array
	{
		return _tests ;
	}

    /**
     * Adds a test to the suite.
     */
    public function addTest( test:ITest ):Void
	{
        /* attention:
           If you try to test something that has not been included
           then off course you obtain a warning.
        */
        
        if( test === undefined )
		{
			addTest( _warning( Strings.argTestDoesNotExist ) ) ;
		}
        
        /* Note : as we don't have native interface in ECMAScript we can't test if a particular object implements an interface,
           but we can test if a constructor inherits from another constructor.
           Here the design choice is to check if the argument "test" inherits from TestCase or from TestSuite, the only constructors
           "virtually implementing" ITest.
        */
        if( test instanceof ITest || (test instanceof TestCase) || (test instanceof TestSuite) )
		{
			_tests.push( test );
		}
        else
		{
			addTest( _warning( Strings.argTestNotATest ) );
		}
	}

	/** 
	 * Adds the tests from the given constructor to the suite.
	 */
    public function addTestSuite( testConstructor:Function ):Void
	{
		addTest( new TestSuite( testConstructor ) );
	}

	/**
	 * Counts the number of test cases that will be run by this test.
	 */
	public function countTestCases() : Number 
	{
		var count:Number = 0;
		var l:Number = _tests.length ;
		for( var i:Number = 0 ; i < l ; i++ )
		{
			count += tests[i].countTestCases();
		}
        return count;
	}

 	/**
 	 * Creates a new ITest reference.
	 */
    static function createTest( theConstructor , name:String ):ITest
	{
		var test:ITest ;
        if( theConstructor == null )
		{
			return( _warning( (new StringFormatter( Strings.canNotCreateTest )).format(name ) ) );
		}
        
        if( theConstructor["prototype"] == null )
		{
			return( _warning( (new StringFormatter( Strings.objectNotCtor )).format( ConstructorUtil.getPath( theConstructor ) ) ) ) ;
		}
        
        
        
        /*!## TODO: add error checking if path could not be found ? */
        var path:String = ConstructorUtil.getPath( theConstructor );
        
        /* attention:
           Dynamic instanciation hack using ECMAscript eval().
           
           Should work with any ECMA-262 hosts.
        */

        var tmp  = eval( path );
        test = new tmp( name );
        
        /*!## TODO:
              use try/catch statement ?
              ex:
        try
            {
            var tmp  = eval( path );
            var test = new tmp( name );
            
            if( ITest(test) == null )
                {
                return( _warning( "Object " + test.getConstructorName() + " does not implements ITest interface" ) );
                }
            
            }
        catch( e )
            {
            return( _warning( "Cannot instantiate test case: " + name ) );
            }
        */
        
        return test ;
	}
    

	/**
	 * Runs the tests and collects their result in a TestResult.
	 */
	public function run(result:TestResult) : Void 
	{
		var l:Number = tests.length ;
		var b:Boolean ;
		for( var i:Number = 0 ; i < l ; i++ )
		{
			if ( result.shouldStop )
			{
				break ;
			}
            runTest( ITest(tests[i]) , result );
		}
	}

    /**
     * Run a specific ITest instance.
	 */
    public function runTest( test:ITest, result:TestResult ):Void
	{
		test.run( result ) ;
	}

    /**
     * Returns the test at the given index.
     */
    public function testAt( /*Int*/ index:Number ):ITest
    {
    	return _tests[index];
	}

    /**
     * Returns the string representation of this instance.
     * @return the string representation of this instance.
     */
    public function toString( /*int*/ increment:Number ):String
	{
        var str:String   = "";
        var CRLF:String  = "\n";
        var TAB:String   = "\t";
        var SPC:String = TAB ;
		
		if( isNaN(increment) )
		{
			increment = 0;
		}
        else
		{
			for( var j:Number = 0 ; j < increment ; j++ )
			{
				SPC += TAB;
			}
            
            TAB = SPC ;
		}
        
        var count:Number = testCount ;
        str += name ;
		if( count > 0 )
		{
			str += CRLF + TAB + "{" + CRLF;
			if( simpleTrace )
			{
				str += TAB + countTestCases() + " Tests ..." + CRLF;
			}
			else
			{
				for( var i:Number =0 ; i<count ; i++ )
				{
					if( tests[i] instanceof TestSuite )
					{
						increment++;
					}
					str += TAB + tests[i].toString( increment ) + CRLF ;
					if( tests[i] instanceof TestSuite )
					{
						increment--;
					}
				}
			}
            str += TAB + "}";
		}
        return str;
	}	

	private var _name:String;

    private var _tests:Array;
 
    private function _addTestMethod( method:String, theConstructor ):Void
	{
		var test;
		if( !_isTestMethod( method ) )
		{
			return ;
		}
		if( !_isPublicTestMethod( method ) && ( Config.testPrivateMethods != true) )
		{
			addTest( _warning( (new StringFormatter( Strings.testMethNotPublic )).format( method ) ) ) ;
			return;
		}
        addTest( createTest( theConstructor, method ) );
	}
 
	private function _isPublicTestMethod( method:String ):Boolean
	{
		return( _isTestMethod( method ) && !StringUtil.startsWith( method, "_" ) ) ;
	}
    
	private function _isTestMethod( method:String ):Boolean
	{
		/* Attention : some differences with Junit here, we do not differenciate "Test" and "test"
           and also by convention "_Test" and "_test" are considered valid private test methods.
        */
        method = method.toLowerCase();
        return( StringUtil.startsWith( method, "test" ) || StringUtil.startsWith( method, "_test" ) ) ;
	}
     

    /**
     * Returns a test which will fail and log a warning message.
     */
    static private function _warning( message:String ):ITest
	{
		var TC:TestCase = new TestCase( "warning" );
		TC.runTest = function()
		{
            /* ATTN : don't use this.fail() the error is not thrown in AS2 */
            //this.fail( message );
            throw new AssertionFailedError( message );
		} ;
        return TC ;
	}
    


}