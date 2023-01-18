class com.vpmedia.text.Entities
{
	/**
	* Variables
	*/
	private static var entities:Array = ["&", "<", ">", "\"", "'", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "À", "Á", "Â", "Ã", "Ä", "Å", "Æ", "Ç", "È", "É", "Ê", "Ë", "Ì", "Í", "Î", "Ï", "Ð", "Ñ", "Ò", "Ó", "Ô", "Õ", "Ö", "Ø", "Ù", "Ú", "Û", "Ü", "Ý", "Þ", "ß", "à", "á", "â", "ã", "ä", "å", "æ", "ç", "è", "é", "ê", "ë", "ì", "í", "î", "ï", "ð", "ñ", "ò", "ó", "ô", "õ", "ö", "ø", "ù", "ú", "û", "ü", "ý", "þ", "ÿ", "¡", "¤", "¢", "£", "¥", "§", "¦", "¨", "©", "ª", "«", "¬", "­", "®", "", "¯", "°", "±", "²", "³", "´", "µ", "¶", "·", "¸", "¹", "º", "»", "¼", "½", "¾", "¿", "×", "÷", "", ""];
	private static var values:Array = ["&amp;", "&lt;", "&gt;", "&quot;", "&apos;", "&OElig;", "&oelig;", "&Scaron;", "&scaron;", "&Yuml;", "&circ;", "&tilde;", "&ndash;", "&mdash;", "&lsquo;", "&rsquo;", "&sbquo;", "&ldquo;", "&rdquo;", "&bdquo;", "&dagger;", "&Dagger;", "&hellip;", "&permil;", "&lsaquo;", "&rsaquo;", "&euro;", "&Agrave;", "&Aacute;", "&Acirc;", "&Atilde;", "&Auml;", "&Aring;", "&AElig;", "&Ccedil;", "&Egrave;", "&Eacute;", "&Ecirc;", "&Euml;", "&Igrave;", "&Iacute;", "&Icirc;", "&Iuml;", "&ETH;", "&Ntilde;", "&Ograve;", "&Oacute;", "&Ocirc;", "&Otilde;", "&Ouml;", "&Oslash;", "&Ugrave;", "&Uacute;", "&Ucirc;", "&Uuml;", "&Yacute;", "&THORN;", "&szlig;", "&agrave;", "&aacute;", "&acirc;", "&atilde;", "&auml;", "&aring;", "&aelig;", "&ccedil;", "&egrave;", "&eacute;", "&ecirc;", "&euml;", "&igrave;", "&iacute;", "&icirc;", "&iuml;", "&eth;", "&ntilde;", "&ograve;", "&oacute;", "&ocirc;", "&otilde;", "&ouml;", "&oslash;", "&ugrave;", "&uacute;", "&ucirc;", "&uuml;", "&yacute;", "&thorn;", "&yuml;", "&iexcl;", "&curren;", "&cent;", "&pound;", "&yen;", "&brvbar;", "&sect;", "&uml;", "&copy;", "&ordf;", "&laquo;", "&not;", "&shy;", "&reg;", "&trade;", "&macr;", "&deg;", "&plusmn;", "&sup2;", "&sup3;", "&acute;", "&micro;", "&para;", "&middot;", "&cedil;", "&sup1;", "&ordm;", "&raquo;", "&frac14;", "&frac12;", "&frac34;", "&iquest;", "&times;", "&divide;", "&fnof;", "&bull;"];
	/**
	* Converts entities in the text to chars.
	*/
	public static function convertToChars (str:String)
	{
		var ents:Array = values;
		var vals:Array = entities;
		for (var j:Number = 0; j < ents.length; j++)
		{
			var temp:Array = str.split (ents[j]);
			var str:String = new String ("");
			for (var i:Number = 0; i < temp.length; i++)
			{
				if (i == temp.length - 1)
				{
					str += temp[i];
				}
				else
				{
					str += temp[i] + vals[j];
				}
			}
		}
		return str;
	}
	/**
	* Converts chars in the text to entities.
	*/
	public static function convertToEntities (str:String)
	{
		var vals:Array = values;
		var ents:Array = entities;
		for (var j:Number = 0; j < ents.length; j++)
		{
			var temp:Array = str.split (ents[j]);
			var str:String = new String ("");
			for (var i:Number = 0; i < temp.length; i++)
			{
				if (i == temp.length - 1)
				{
					str += temp[i];
				}
				else
				{
					str += temp[i] + vals[j];
				}
			}
		}
		return str;
	}
	/**
	* Returns a string presentation of the entities.
	*/
	public static function toString (str:String)
	{
		var temp:String = new String ("");
		for (var i:Number = 0; i < entities.length; i++)
		{
			temp += entities[i] + " = " + values[i] + "\n";
		}
		return temp;
	}
}
