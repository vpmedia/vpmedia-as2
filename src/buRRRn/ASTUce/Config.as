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

/**
 * Configure the ASTUce framework.
 * @author eKameleon
 */
class buRRRn.ASTUce.Config 
{

    /**
     * Boolean configuring the getInfo method behaviour, true for more verbose and false for less verbose.
     */
    static public var verbose:Boolean = true;

    /**
     * Boolean option to display all the constructors being tested.
     */
    static public var showConstructorList:Boolean = true;
    
    /**
     * Boolean option to display the source of objects being compared.
     * Note : It help you to debug to see 
     * {@code
     * ## AssertionFailedError : expected:<{a:1,b:2,c:3}> but was:<{a:1,b:2,c:4}> ##
     * }
     * instead of
     * {@code
     * ## AssertionFailedError : expected:<[object Object]> but was:<[object Object]> ##
     * }
     */
    static public var showObjectSource:Boolean = true;
    
    /**
     * Boolean option to invert the order of the arguments: expected, actual in buRRRn.ASTUce.Assertion.
     * <p>true  - the argument order is: actual, expected. (inverted)</p>
     * <p>false - the argument order is: expected, actual. (default)</p>
     */
    static public var invertExpectedActual:Boolean = false;
    
    /**
     * Boolean configuring the behaviour of ASTUce regarding private methods.
     * <p>true  - test private methods</p>
     * <p>false - don't test private methods</p>
     * <p>Note : By default in ECMAScript all methods are public, but by convention we use an underscore before the name
     * of a method to indicate its private nature.</p>
     * <p>ASTUce will not test methods starting with an underscore except if you force testPrivateMethods = true, 
     * then methods as _testSomething will be tested by the framework.</p>
     */
    static public var testPrivateMethods:Boolean = false;
    
    /**
     * Boolean option allowing to iterate or not trough inherited tests.
     * <p>true iterate inherited tests</p>
     * <p>false does NOT iterate inherited tests</p>
     * <p>Note : If you set this option to false the following test SuiteTest( testInheritedTests ) will fail.</p>
     */
    static public var testInheritedTests:Boolean = true;
    
    /**
     * Boolean option allowing the ASTUce framework to test itself.
     * <p>true  - add to tests *buRRRn.Tests.AllTests.suite()*.</p>
     * <p>false - add nothing</p>
	 */
	static public var testMyself:Boolean = false;

}