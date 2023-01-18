
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
 * A Listener for test progress
 * @author eKameleon
 */
interface buRRRn.ASTUce.ITestListener 
{

    /**
     * An error occurred.
     */
    function addError( test:ITest, e:Error ):Void;
    
    /**
     * A failure occurred.
     */
    function addFailure( test:ITest, afe:AssertionFailedError ):Void;
    
    /**
     * A test ended.
     */
    function endTest( test:ITest ):Void;

    /**
     * A test started.
     */
    function startTest( test:ITest ):Void;

}