class com.jxl.shuriken.factories.FactoryTemplate
{
	public static function getParsedXML(pXMLorString):XML
	{
		var theXML:XML;
		
		if(pXMLorString instanceof XML)
		{
			theXML = pXMLorString;
		}
		else
		{
			theXML = new XML();
			theXML.ignoreWhite = true;
			theXML.parseXML(pXMLorString);
		}
		
		return theXML;
	}
	
	public static function parseBoolean(p_str:String):Boolean
	{
		p_str = p_str.toLowerCase();
		
		switch(p_str)
		{
			case "true":
				return true;
			
			case "false":
				return false;
			
			case "1":
				return true;
			
			case "0":
				return false;
			
		}
	}
	
	public static function convertEscapeToHTML(pStr:String):String
	{
		pStr = pStr.split("&lt;").join("<");
		pStr = pStr.split("&gt;").join(">");
		pStr = pStr.split("&quot;").join("\"");
		return pStr;
	}
	
	// WARNING: uses recursion; may not scale
	// hyperlinks are not underlined by default in Flash TextFields
	// this inserts <u> tags whereever a hyperlink is detected
	public static function underlineHyperlinks(pStr:String, pCurrentIndex:Number):String
	{
		if(pCurrentIndex == null) pCurrentIndex = 0;
		var aTagIndex:Number = pStr.indexOf("<a", pCurrentIndex);
		if(aTagIndex != -1)
		{
			// where is end gt?
			var aGtIndex:Number = pStr.indexOf(">", aTagIndex);
			// where is closing tag?
			var closingTagIndex:Number = pStr.indexOf("</a>", aGtIndex);
			if(aGtIndex != -1 && closingTagIndex != -1)
			{
				// re-assemble string with u tags in the middle
				var startStr:String = pStr.substring(0, aGtIndex + 1);
				var midStr:String = pStr.substring(aGtIndex + 1, closingTagIndex);
				var endStr:String = pStr.substring(closingTagIndex, pStr.length);
				pStr = startStr + "<u>" + midStr + "</u>" + endStr;
				var nextIndex:Number = closingTagIndex + 4;
				if(nextIndex < pStr.length)
				{
					pStr = underlineHyperlinks(pStr, nextIndex);
				}
			}
		}
		return pStr;
	}
	
	public static function doubleQuotesToSingleQuotes(pStr:String):String
	{
		pStr = pStr.split("\"").join("'");
		return pStr;
	}
}