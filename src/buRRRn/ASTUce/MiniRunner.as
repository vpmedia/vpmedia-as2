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

import buRRRn.ASTUce.ResultPrinter;
import buRRRn.ASTUce.TestResult;
import buRRRn.ASTUce.TestSuite;

import vegas.core.CoreObject;
import vegas.core.IRunnable;

/**
 * A trace based tool to run tests.
 * @author eKameleon
 */
class buRRRn.ASTUce.MiniRunner extends CoreObject implements IRunnable 
{
	
	/**
	 * Creates a new MiniRunner instance.
	 */
	public function MiniRunner( suiteName:String ) 
	{
		super();
		
		if( suiteName == null )
        {
        	suiteName = "MAIN" ;
		}
        
        suite   = new TestSuite( suiteName ) ;
        result  = new TestResult();
        printer = new ResultPrinter();
        
	}

	/**
	 * The TestSuite reference of this test tracer.
	 */
    public var suite:TestSuite;
    
    /**
     * The TestResult reference of this test tracer.
     */
    public var result:TestResult;
    
    /**
     * The ResultPrinter reference of this test tracer.
     */
    public var printer:ResultPrinter;

	/**
	 * Run the tracer.
	 */
	public function run():Void 
	{
		
		setUp();
        
        var time:Number = (new Date()).valueOf() ;
        
        suite.run( result );
        
        var runtime:Number = (new Date()).valueOf() - time ;
        
        printer.print( result, runtime );
        
	}

	/**
	 * Overrides this method to setup the Runner.
	 */
    public function setUp():Void
    {
        
    }

}