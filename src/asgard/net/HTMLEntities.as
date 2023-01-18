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

import vegas.util.StringUtil;

/**
 * This static tool class encode or decode the HTML entities in a string.
 * @author eKameleon
 */
class asgard.net.HTMLEntities 
{

	/**
	 * Determinates all entities.
	 */
	static public var entities:Array = 
	[ 
		"&euro;", "&quot;", "&amp;", "&lt;", "&gt;", "&iexcl;", "&cent;", "&pound;", "&curren;", "&yen;",
		"&brvbar;", "&sect;", "&uml;", "&copy;", "&ordf;", "&not;", "&shy;", "&reg;", "&macr;", "&deg;",
		"&plusmn;", "&sup2;", "&sup3;", "&acute;", "&micro;", "&para;", "&middot;", "&cedil;", "&sup1;", "&ordm;",
		"&raquo;", "&frac14;", "&frac12;", "&frac34;", "&iquest;", "&Agrave;", "&Aacute;", "&Atilde;", "&Auml;", "&Aring;",
		"&AElig;", "&Ccedil;", "&Egrave;", "&Eacute;", "&Ecirc;", "&Igrave;", "&Iacute;", "&Icirc;", "&Iuml;", "&ETH;",
		"&Ntilde;", "&Ograve;", "&Oacute;", "&Ocirc;", "&Otilde;", "&Ouml;", "&times;", "&Oslash;", "&Ugrave;", "&Uacute;",
		"&Ucirc;", "&Uuml;", "&Yacute;", "&THORN;", "&szlig;", "&agrave;", "&aacute;", "&acirc;", "&atilde;", "&auml;",
		"&aring;", "&aelig;", "&ccedil;", "&egrave;", "&eacute;", "&ecirc;", "&euml;", "&igrave;", "&iacute;", "&icirc;",
		"&iuml;", "&eth;", "&ntilde;", "&ograve;", "&oacute;", "&ocirc;", "&otilde;", "&ouml;", "&divide;", "&oslash;",
		"&ugrave;", "&uacute;", "&ucirc;", "&uuml;", "&yacute;", "&thorn;", "&nbsp;" 
	];
	
	/**
	 * Determinates all special chars.
	 */
	static public var specialchars:Array = 
	[ 
		"€", "\"", "&", "<", ">", "¡", "¢", "£", "¤", "¥",
		"¦", "§", "¨", "©", "ª", "¬", "­", "®", "¯", "°",
		"±", "²", "³", "´", "µ", "¶", "·", "¸", "¹", "º",
		"»", "¼", "½", "¾", "¿", "À", "Á", "Ã", "Ä", "Å",
		"Æ", "Ç", "È", "É", "Ê", "Ì", "Í", "Î", "Ï", "Ð",
		"Ñ", "Ò", "Ó", "Ô", "Õ", "Ö", "×", "Ø", "Ù", "Ú",
		"Û", "Ü", "Ý", "Þ", "ß", "à", "á", "â", "ã", "ä",
		"å", "æ", "ç", "è", "é", "ê", "ë", "ì", "í", "î",
		"ï", "ð", "ñ", "ò", "ó", "ô", "õ", "ö", "÷", "ø",
		"ù", "ú", "û", "ü", "ý", "þ", "\u00A0" 
	];

	/**
	 * Decodes the specified string.
	 * @return the decode string.
	 */
	static function decode( text:String, removeCRLF:Boolean ):String 
	{
		var i:Number ;
		var ch:String ;
		var entity:String ;
		var len:Number = entities.length ;
		
		for( i=0; i<len ; i++ )
		{
			ch = specialchars[ i ];
			entity = entities[ i ];
			
			// trace(ch + " : " + i) ;
			
			if( text.indexOf( entity ) > -1 )
			{
				text = StringUtil.replace( text, entity, ch );
			}
		}
		
		if( removeCRLF )
		{
			text = StringUtil.replace( text, "\r\n", "" );
		}
		return text;
	}

	/**
	 * Encodes the specified text passed in argument.
	 * @return a string encode text.
	 */
	static function encode( text:String ):String
	{
		var i:Number ;
		
		var ch:String ;
		
		var entity:String ;
		
		var len:Number = entities.length ;
		
		for( i=0; i<len; i++ )
		{
			
			ch = specialchars[i];
			entity = entities[i];
			
			if( text.indexOf( ch ) > -1 )
			{
				text = StringUtil.replace( text, ch, entity );
			}
		}
		return text.toString() ;
	}

}
