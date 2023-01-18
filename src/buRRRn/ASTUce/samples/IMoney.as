
/*
  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is ASTUce: ActionScript Test Unit compact edition AS2. 
  
  The Initial Developer of the Original Code is
  Zwetan Kjukov <zwetan@gmail.com>.
  Portions created by the Initial Developer are Copyright (C) 2004-2006
  the Initial Developer. All Rights Reserved.
  
  Contributor(s):
*/

import buRRRn.ASTUce.samples.Money;
import buRRRn.ASTUce.samples.MoneyBag;

/* Interface: IMoney
   The common interface for simple Monies and MoneyBags.
*/
interface buRRRn.ASTUce.samples.IMoney
{
    
    
    /* Method: plus
       Adds a money to this money.
    */
    function plus( m:IMoney ):IMoney;
    
    /* Method: addMoney
       Adds a simple Money to this money.
       
       This is a helper method for implementing double dispatch.
    */
    function addMoney( m:Money ):IMoney;

    /* Method: equals
    */
    function equals( /*untyped*/ obj ):Boolean ;

    
    /* Method: addMoneyBag
       Adds a MoneyBag to this money.
       
       This is a helper method for implementing double dispatch
    */
    function addMoneyBag( mb:MoneyBag ):IMoney;
    
    /* Method: isZero
       Tests whether this money is zero.
    */
    function isZero():Boolean;
    
    /* Method: multiply
       Multiplies a money by the given factor.
    */
    function multiply( factor:Number ):IMoney;
    
    /* Method: negate
       Negates this money.
    */
    function negate():IMoney;
    
    /* Method: minus
       Subtracts a money from this money.
    */
    function minus( m:IMoney ):IMoney;
    
    /* Method: appendTo
       Append this to a MoneyBag.
    */
    function appendTo( mb:MoneyBag ):Void;
    
}

