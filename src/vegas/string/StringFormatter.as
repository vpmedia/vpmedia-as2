/*

  The contents of this file are subject to the Mozilla Public License Version 1.1 (the "License") ;
  you may not use this file except in compliance with the License. You may obtain a copy of the License at :
  
	- http://www.mozilla.org/MPL/

  Software distributed under the License is distributed on an "AS IS" basis, WITHOUT WARRANTY OF ANY KIND,
  either express or implied. See the License for the specific language governing rights and limitations 
  under the License.

  The Original Code is core2: ECMAScript core objects 2nd gig.

  The Initial Developer of the Original Code is Zwetan Kjukov <zwetan@gmail.com>.
  Portions created by the Initial Developer are Copyright (C) 2003-2005
  the Initial Developer. All Rights Reserved.

  Contributor(s) : 
	
	- ekameleon <vegas@ekameleon.net>

*/

import vegas.util.format.AbstractFormatter;
import vegas.util.StringUtil;

/**
 * Replaces the pattern item in a specified String with the text equivalent of the value of a specified Object instance.
 * <p><b>Usage :</b>
 * {@code
 * import vegas.string.StringFormatter ;
 * 
 * var f:StringFormatter ;
 * var result:String ;
 * 
 * f = new StringFormatter() ;
 * f.pattern = "Brad's dog has {0,-4:_} fleas." ;
 * result = f.format(42) ;
 * trace (">> " + result) ;
 * 
 * f.pattern = "Brad's dog has {0,6:#} fleas.";
 * result = f.format(41) ;
 * trace (">> " + result) ;
 * 
 * f.pattern = "Brad's dog has {0,-8} fleas." ;
 * result = f.format(12) ;
 * trace (">> " + result) ;
 * 
 * f.pattern = "{3} {2} {1} {0}" ;
 * result = f.format("a", "b", "c", "d") ;
 * trace (">> " + result) ;
 * }
 * </p>
 * @author eKameleon
 */
class vegas.string.StringFormatter extends AbstractFormatter 
{

	/**
	 * Creates a new StringFormatter instance.
	 * @param pattern the format pattern.
	 */
	public function StringFormatter(pattern:String) 
	{
		super(pattern) ;
	}
	
	/**
	 * const The space expression.
	 */	
	static public var SPC:String = " " ; // SPACE
	
	static private var __ASPF__ = _global.ASSetPropFlags(StringFormatter, null, 7, 7) ;
	
	/**
	 * Format the pattern with all the arguments passed in this method.
	 * @return the new string representation of the pattern. 
	 */
	public function format( /* arg1, arg2, ... argN */ ):String 
	{

		if( !_pattern ) return "" ;
		
		var str:String = "" ;
		var args:Array  = [].concat(arguments) ;
		
		var format:String = new String(_pattern) ;
		
		if ( format.indexOf( "{" ) == -1 ) 
		{
			return format ;
		}	
		
		var ch:String = "" ;
		var pos:Number = 0 ;
		
		var next = function() 
		{
			ch = format.charAt( pos );
			pos++ ;
			return ch ;
		};
		
		var getIndexValue = function( index:Number ):String 
		{
			var cur = args[index] ;
			if( cur ) 
			{
				return cur.toString() ;
			}
			if (cur == undefined ) 
			{
				return "" ;
			}
			else if (cur == null) 
			{
				return null ;
			}
			else 
			{
				return cur.toString() ;
			}
		};
		
		var expression:String ; 
		var run:Boolean ;
		var index:Number ;
		var expValue:String ; 
		var paddingChar:String ;
		var spaceAlign:Number ;
		
		var l:Number = format.length ;
		while( pos < l ) 
		{
			next() ; 
			if( ch == "{" ) 
			{
				expression = next() ;
				run = true ;
				while( run ) 
				{
					next() ;
					if( ch != "}" ) 
					{
						expression = expression + ch ;
					}
					else 
					{
						run = false ;
					}
				}
				index = null ;
				paddingChar = SPC ;
				expValue = "" ;
				if( StringUtil.indexOfAny( expression, [ ",", ":" ] ) == -1 ) 
				{
					index = parseInt( expression.toString() ) ;
					expValue = getIndexValue( index ) ;
					str += expValue ;
				}
				else 
				{
					var vPos:Number = expression.indexOf( "," ) ;
					var fPos:Number = expression.indexOf( ":" ) ;
					if( vPos == -1 ) 
					{
						vPos = fPos ;
						fPos = -1 ;
					}
					index = parseInt( expression.substring( 0, vPos ) ) ;
					expValue = getIndexValue( index ) ;
					if( fPos == -1 )
					{
						spaceAlign = parseInt( expression.substr( vPos+1 ) ) ;
					}
					else 
					{
						spaceAlign  = parseInt( expression.substring( vPos+1, fPos ) ) ;
						paddingChar = expression.substr( fPos+1 ) ;
					}
					if ( isNaN( spaceAlign ) ) 
					{
						// 
					}
					else if( spaceAlign > 0 ) 
					{
						expValue = StringUtil.padLeft( expValue, spaceAlign, paddingChar ) ;
					}
					else 
					{
						expValue = StringUtil.padRight( expValue, -spaceAlign, paddingChar ) ;
					}
					str += expValue ;
				}
			}
			else 
			{
				str += ch ;
			}
		}
		return str ;		
	}
	
	/**
	 * Returns a singleton reference of the StringFormatter class.
	 * @return a singleton reference of the StringFormatter class.
	 */
	static public function getInstance():StringFormatter
	{
		if (_instance == null)
		{
			_instance = new StringFormatter() ;	
		}
		return _instance ;
	}
	
	/**
	 * The internal singleton reference of this class.
	 */
	static private var _instance:StringFormatter ;
	
}