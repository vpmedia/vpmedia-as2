/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is Vegas Framework.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <vegas@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2007
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

/**
 * The glob module finds all the pathnames matching a specified pattern according to the rules used by the Unix shell.
 * <p><b>Example:</b>
 * {@code
 * import vegas.string.Glob ;
 * 
 * var str1:String = "<html> hello world </html>";
 * var str2:String = "function test()\n\t{\n\treturn true;\n\t}";
 * var str3:String = "<data><toto>blah</toto></data>";
 * 
 * var pat1:String = "<*>";
 * var pat2:String = "<html>*</html>";
 * var pat3:String = "function *()*{*}";
 * 
 * 	var t:Number = getTimer();
 *
 *	trace( "is < > delimited: " + Glob.stringMatch( str1, pat1 ) );
 *	trace( "is < > delimited: " + Glob.stringMatch( str3, pat1 ) );
 *	trace( "is html tag delimited: " + Glob.stringMatch( str1, pat2 ) );
 *	trace( "is html tag delimited: " + Glob.stringMatch( str3, pat2 ) );
 *	trace( "is a function: " + Glob.stringMatch( str2, pat3 ) );
 *	trace( "total time : " + (getTimer()-t) +"ms" );
 *	
 *	// Output
 *	// is < > delimited: true
 *	// is < > delimited: true
 *	// is html tag delimited: true
 *	// is html tag delimited: false
 *	// is a function: true
 *	// total time : 7ms
 * }
 * </p>
 * <p><b>THANKS : Zwetan</b> in buRRRn FCNG mailing list (12/10/2004)</p>
 * @author eKameleon
 */
class vegas.string.Glob 
{

	/**
	 * Matchs the string expression with the specified pattern.
	 */
	static public function stringMatch(str:String, pattern:String, caseSensitive:Boolean ) 
	{
		
		if (! str instanceof String) str = new String(str) ;
		if (! pattern instanceof String) pattern = new String(pattern) ;
		
		if( !caseSensitive ) 
		{
			str = str.toLowerCase();
			pattern = pattern.toLowerCase();
        }
    
    	var c:String = str.charAt(0);
		var c1:String = str.charAt(1);
		var pat:String = pattern.charAt(0);
		var pat1:String = pattern.charAt(1);
    
		switch (pat) {
			
			case "?"  :
				if( c != "" ) return stringMatch( str.substr(1), pattern.substr(1), caseSensitive ) ;
				else return false ;
				
			case "*" :
				if ( pat1 == "" ) return true ;
				if ( pattern.substr(1).indexOf( "*" ) > -1 ) {
					while( str != "" ) {
					if( pat1 == "*" ) break ;
						str = str.substr(1);
						if( pat1 == "?" ) {
							pattern = pattern.substr(1);
							break;
						}
						if ( str == "" ) return false;
						if ( str.charAt(0) == pat1 ) break;
					}
					return stringMatch( str, pattern.substr(1), caseSensitive ) ;
				} else {
					var found:Number = str.lastIndexOf( pat1 );
					if( found != -1 ) return stringMatch( str.substr(found), pattern.substr(1), caseSensitive );
					else if( pat1 == "?" ) {
						if( pattern.charAt(2) == "" ) return str.length >= 1;
						else return stringMatch( str.substr(1), pattern.substr(1), caseSensitive );
					}
					return false;
				}
				
			case "" :
				return ( c == "" ) ;
    	}
		
		
		if( c != pat ) return false;
        if( c != "" ) return stringMatch( str.substr(1), pattern.substr(1), caseSensitive );
        else return false ;
    
    }

}