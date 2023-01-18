
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

import buRRRn.ASTUce.samples.IMoney;
import buRRRn.ASTUce.samples.MoneyBag;

import vegas.util.Comparater;

/* Class: Money
   A simple Money.
*/
class buRRRn.ASTUce.samples.Money implements IMoney
    {
    
    private var _amount:Number;
    private var _currency:String;
    
    /* Constructs a money from the given amount and currency. */
    function Money( amount:Number, currency:String )
        {
        _amount   = amount;
        _currency = currency;
        }
    
    /* Method: toString
    */
    function toString():String
        {
        return "[" + amount + currency + "]";
        }
    
    /* Method: equals
    */
    function equals( /*untyped*/ obj ):Boolean
        {
        if( isZero() )
            {
            /* CHECK if we can have instanceof Interface
               if that does not work we will have to cast to
               IMoney and check if its equals null
            */
            if( obj instanceof IMoney )
                {
                return obj.isZero();
                }
            }
        
        if( obj instanceof Money )
            {
            return( Comparater.compare( currency, obj.currency) && Comparater.compare( amount, obj.amount) );
            }
        
        return false;
        }
    
    /* Method: plus
       Adds a money to this money.
    */
    function plus( m:IMoney ):IMoney
        {
        return m.addMoney( this );
        }
    
    /* Method: addMoney
       Adds a simple Money to this money.
       
       This is a helper method for implementing double dispatch.
    */
    function addMoney( m:Money ):IMoney
        {
        if( Comparater.compare( m.currency, currency) )
            {
            return new Money( amount + m.amount , currency );
            }
        
        return MoneyBag.create( this, m );
        }
    
    /* Method: addMoneyBag
       Adds a MoneyBag to this money.
       
       This is a helper method for implementing double dispatch
    */
    function addMoneyBag( mb:MoneyBag ):IMoney
        {
        return mb.addMoney( this );
        }
    
    /* Getter: currency
    */
    function get currency():String
        {
        return _currency;
        }
    
    /* Getter: amount
    */
    function get amount():Number
        {
        return _amount;
        }
    
    /* Method: isZero
       Tests whether this money is zero.
    */
    function isZero():Boolean
        {
        return( amount == 0 );
        }
    
    /* Method: multiply
       Multiplies a money by the given factor.
    */
    function multiply( factor:Number ):IMoney
        {
        return( new Money( (amount * factor), currency ) );
        }
    
    /* Method: negate
       Negates this money.
    */
    function negate():IMoney
        {
        return( new Money( -amount, currency ) );
        }
    
    /* Method: minus
       Subtracts a money from this money.
    */
    function minus( m:IMoney ):IMoney
        {
        return( plus( m.negate() ) );
        }
    
    /* Method: appendTo
       Append this to a MoneyBag.
    */
    function appendTo( mb:MoneyBag ):Void
        {
        mb.appendMoney( this );
        }
        
    }


