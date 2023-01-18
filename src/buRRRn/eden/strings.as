
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
 * Configure the eden library messages.
 * exemple:
 * {@code
 * trace( new StringFormatter( buRRRn.eden.strings.pairIsIgnored).format("toto", 5, 10 ) );
 * }
 * <p><b>Attention :</b> Don't use eden to load its own resources message this will cause an infinite loop.</p>
 */
class buRRRn.eden.strings extends Object
    {
    
    /**
     * multiSerialize require pairs of values.
     */
    static var requirePairValue:String = "multiSerialize require pairs of values";
    
    /**
     * name "{0}" is not a string, pair[{1},{2}] is ignored
     */
    static var pairIsIgnored:String = "name \"{0}\" is not a string, pair[{1},{2}] is ignored";
    
    /**
     * "{0}" is a reserved keyword
     */
    static var reservedKeyword:String = "\"{0}\" is a reserved keyword";
    
    /**
     * "{0}" is a future reserved keyword
     */
    static var futurReservedKeyword:String = "\"{0}\" is a future reserved keyword";
    
    /**
     * "{0} is not a valid path
     */
    static var notValidPath:String = "\"{0}\" is not a valid path";
    
    /**
     * unterminated comment
     */
    static var unterminatedComment:String = "unterminated comment";
    
    /**
     * syntax error (comment)
     */
    static var errorComment:String = "syntax error (comment)";
    
    /**
     * bad identifier
	 */
    static var errorIdentifier:String = "bad identifier";
    
    /**
     * "{0}" is not a valid constructor
     */
    static var notValidConstructor:String = "\"{0}\" is not a valid constructor";
    
    /**
     * "{0}" does not exists
     */
    static var doesNotExist:String = "\"{0}\" does not exists";
    
    /**
     * bad constructor.
     */
    static var errorConstructor:String = "bad constructor";
    
    /**
     * bad string (found line terminator in string)
     */
    static var errorLineTerminator:String = "bad string (found line terminator in string)";
    
    /**
     * bad string (unterminated string)
     */
    static var errorString:String = "bad string (unterminated string)";
    
    /**
     * bad array (unterminated array)
     */
    static var errorArray:String = "bad array (unterminated array)";
    
    /**
     * bad object (unterminated object)
     */
    static var errorObject:String = "bad object (unterminated object)";
    
    /**
     * bad number (malformed hexadecimal)
     */
    static var malformedHexadecimal:String = "bad number (malformed hexadecimal)";
    
    /**
     * bad number (not finite)
     */
    static var errorNumber:String = "bad number (not finite)";
    
    /**
     * external reference "{0}" does not exists
     */
    static var extRefDoesNotExist:String = "external reference \"{0}\" does not exists";
    
    /**
     * syntax error
     */
    static var errorKeyword:String = "syntax error";
    
    /**
     * "{0}" is not an authorized constructor
     */
    static var notAuthorizedConstructor:String = "\"{0}\" is not an authorized constructor";
    
    /**
     * "{0}" is not an authorized external reference
     */
    static var notAuthorizedExternalReference:String = "\"{0}\" is not an authorized external reference";
    
    /**
     * "{0}" is not an authorized path
     */
    static var notAuthorizedPath:String = "\"{0}\" is not an authorized path";
    
    /**
     * "{0}" is not a valid function
     */
    static var notValidFunction:String = "\"{0}\" is not a valid function";
    
    /**
     * bad function
     */
    static var errorFunction:String = "bad function";
    
    /**
     * function call "{0}( {1} )"is not allowed
	 */
    static var notFunctionCallAllowed:String = "function call \"{0}( {1} )\"is not allowed";
    
    /**
     * "{0}" is not an authorized function
     */
    static var notAuthorizedFunction:String = "\"{0}\" is not an authorized function";
    
}

