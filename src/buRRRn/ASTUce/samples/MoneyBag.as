
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
import buRRRn.ASTUce.samples.Money;

/* Class: MoneyBag
   A MoneyBag defers exchange rate conversions.
   
   For example adding 12 Swiss Francs to 14 US Dollars is
   represented as a bag  containing the two Monies 12 CHF and 14 USD.
   
   Adding another 10 Swiss francs gives a bag with 22 CHF and 14 USD.
   
   Due to the deferred exchange rate conversion we can later value a 
   MoneyBag with different exchange rates.
  
   A MoneyBag is represented as a list of Monies and provides 
   different constructors to create a MoneyBag.
   
   NOTE:
   core2 Array.as is required for some methods to work.
*/
class buRRRn.ASTUce.samples.MoneyBag implements IMoney
    {
    
    private var _monies:Array;
    
    function MoneyBag()
        {
        _monies = [];
        }
    
    /* Method: Create (Static)
    */
    static function create( m1:IMoney, m2:IMoney ):IMoney
        {
        var result;
        result = new MoneyBag();
        
        m1.appendTo( result );
        m2.appendTo( result );
        
        return result._simplify();
        }
    
    /* Method: plus
    */
    function plus( m:IMoney ):IMoney
        {
        return m.addMoneyBag( this );
        }
    
    /* Method: addMoney
    */
    function addMoney( m:Money ):IMoney
        {
        return MoneyBag.create( m, this );
        }
    
    /* Method: addMoneyBag
    */
    function addMoneyBag( mb:MoneyBag ):IMoney
        {
        return MoneyBag.create( mb, this );
        }
    
    /* Method: appendBag
    */
    function appendBag( aBag:MoneyBag ):Void
        {
        var i;
        for( i=0; i<aBag._monies.length; i++ )
            {
            appendMoney( aBag._monies[i] );
            }
        }
    
    /* Method: appendMoney
    */
    function appendMoney( aMoney:Money ):Void
        {
        var old, sum;
        
        if( aMoney.isZero() )
            {
            return;
            }
        
        old = _findMoney( aMoney.currency );
        
        if( old == null )
            {
            _monies.push( aMoney );
            return;
            }
        
        _monies.splice( _monies.indexOf( old ) , 1 );
        sum = old.plus( aMoney );
        
        if( sum.isZero() )
            {
            return;
            }
        
        _monies.push( sum );
        }
    
    /* Method: equals
    */
    function equals( /*untyped*/ obj ):Boolean
        {
        var i, aMoneyBag, m;
        if( isZero() )
            {
            if( obj instanceof IMoney )
                {
                return obj.isZero();
                }
            }
        
        if( obj instanceof MoneyBag )
            {
            aMoneyBag = obj;
            
            if( aMoneyBag._monies.length != _monies.length )
                {
                return false;
                }
            
            for( i=0; i<_monies.length; i++ )
                {
                m = _monies[i];
                if( !aMoneyBag._contains( m ) )
                    {
                    return false;
                    }
                }
            
            return true;
            }
        
        return false;
        }
    
    /* Method: _findMoney (Private)
    */
    function _findMoney( currency:String )
        {
        var i, m;
        for( i=0; i<_monies.length; i++ )
            {
            m = _monies[i];
            if( m.currency.equals( currency ) )
                {
                return m;
                }
            }
        return null;
        }
    
    /* Method: _contains (Private)
    */
    function _contains( m:Money ):Boolean
        {
        var found;
        found = _findMoney( m.currency );
        
        if( found == null )
            {
            return false;
            }
        
        return( found.amount == m.amount );
        }
    
    /* Method: isZero
    */
    function isZero():Boolean
        {
        return( _monies.length == 0 );
        }
    
    /* Method: multiply
    */
    function multiply( factor:Number ):IMoney
        {
        var result, i, m;
        result = new MoneyBag();
        
        if( factor != 0 )
            {
            for( i=0; i<_monies.length; i++ )
                {
                m = _monies[i];
                result.appendMoney( m.multiply( factor ) );
                }
            }
        
        return result;
        }
    
    /* Method: negate
    */
    function negate():IMoney
        {
        var result, i, m;
        result = new MoneyBag();
        
        for( i=0; i<_monies.length; i++ )
            {
            m = _monies[i];
            result.appendMoney( m.negate() );
            }
        
        return result;
        }
    
    /* Method: _simplify (Private)
    */
    private function _simplify():IMoney
        {
        if( _monies.length == 1 )
            {
            return _monies[0];
            }
        
        return this;
        }
    
    /* Method: minus
    */
    function minus( m:IMoney ):IMoney
        {
        return plus( m.negate() );
        }
    
    /* Method: toString
    */
    function toString():String
        {
        var str, i;
        str = "{";
        for( i=0; i<_monies.length; i++ )
            {
            str += _monies[i].toString() ;
            }
        return str + "}";
        }
    
    /* Method: appendTo
    */
    function appendTo( mb:MoneyBag ):Void
        {
        mb.appendBag( this );
        }
    
    }

