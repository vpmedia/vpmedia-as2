
/*
  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is eden: ECMAScript data exchange notation AS2. 
  
  The Initial Developer of the Original Code is
  Zwetan Kjukov <zwetan@gmail.com>.
  Portions created by the Initial Developer are Copyright (C) 2004-2006
  the Initial Developer. All Rights Reserved.
  
  Contributor(s):

   		- ALCARAZ Marc (aka eKameleon) <vegas@ekameleon.net>   		 
   		Eden for VEGAS, use this version only with Vegas AS2 Framework Please.
  
*/

/**
 *	Constructor: GenericParser
 */
class buRRRn.eden.GenericParser
    {
    
    var source:String;
    var pos:Number;
    var ch:String;
    
    var log:Function;
    var onParsed:Function;
    var isAuthorized:Function;
    var addAuthorized:Function;
    var removeAuthorized:Function;
    
    function GenericParser( source:String, callback )
        {
        if( callback == null )
            {
            callback = buRRRn.eden.Application;
            }
        
        //delegates
        this.log = function( message )
            {
            callback.log( message );
            } ;
        
        this.onParsed = function( value )
            {
            return callback.onParsed( value );
            } ;
        
        this.isAuthorized = function( value )
            {
            return callback.isAuthorized( value );
            } ;
        
        this.addAuthorized = function()
            {
            callback.addAuthorized.apply( callback, arguments );
            } ;
        
        this.removeAuthorized = function()
            {
            callback.removeAuthorized.apply( callback, arguments );
            } ;
        
        this.source = source;
        this.pos    = 0;
        this.ch     = "";
        }
    
    /* Method: getCharAt
    */
    function getCharAt( pos:Number ):String
        {
        if( pos == null )
            {
            pos = this.pos;
            }
        
        return source.charAt( pos );
        }
    
    /* Method: getChar
    */
    function getChar():String
        {
        return source.charAt( pos );
        }
    
    /* Method: next
    */
    function next():String
        {
        ch = getChar();
        pos++;
        return ch;
        }
    
    /* Method: hasMoreChar
    */
    function hasMoreChar():Boolean
        {
        return( pos <= (source.length-1) );
        }
    
    /* Method: eval
       To override.
    */
    function eval()
        {
        
        }
    
    /* StaticMethod: evaluate
       To override.
    */
    static function evaluate( source:String, callback )
        {
        var parser = new buRRRn.eden.GenericParser( source, callback );
        return parser.eval();
        }
    
    /* Method: isAlpha
    */
    function isAlpha( /*char*/ c:String ):Boolean
        {
        return( (("A" <= c) && (c <= "Z")) || (("a" <= c) && (c <= "z")) );
        }

    /* Method: isASCII
    */
    function isASCII( /*char*/ c:String ):Boolean
        {
        return( c.charCodeAt( 0 ) <= 255 );
        }
    
    /* Method: isDigit
    */
    function isDigit( /*char*/ c:String ):Boolean
        {
        return( ("0" <= c) && (c <= "9") );
        }
    
    /* Method: isHexDigit
    */
    function isHexDigit( /*char*/ c:String ):Boolean
        {
        return( isDigit( c ) || (("A" <= c) && (c <= "F")) || (("a" <= c) && (c <= "f")) );
        }
    
    /* Method: isOctalDigit
    */
    function isOctalDigit( /*char*/ c:String ):Boolean
        {
        return( ("0" <= c) && (c <= "7") );
        }
    
    /* Method: isUnicode
    */
    function isUnicode( /*char*/ c:String ):Boolean
        {
        return( c.charCodeAt( 0 ) > 255 );
        }
    
    }

