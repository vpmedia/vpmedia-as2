/**
 * LZWCompressedXML Class
 * Loads and processes compressed and uncompressed map XML files.
 * @version		1.0.0 - 07.12.2005
 * @author			S. Balkau
 */
class com.tPS.xml.LZWCompressedXML extends XML
{
	
	/**
	 * onData()
	 * Overridden onData that can handle LZ77 compressed XML.
	 * @param	src	The file that contains the map XML data.
	 */
	private function onData(src:String):Void
	{
		
		// If the data start with 'XCPR' it is compressed, so execute decompression routine:
		if (src.substr(0, 4) == "XCPR")
		{
			var ecPos:Number = src.indexOf("R") + 1;
			var eChar:String = src.charAt(ecPos);
			src = src.substr(ecPos + 1);
			var srcLen:Number = src.length;
			var out:String = "";
			
			for (var i:Number = 0; i < srcLen; i++)
			{
				if (src.charAt(i) == eChar)
				{
					var p:Number = src.charCodeAt(i + 1) * 114 + src.charCodeAt(i + 2) - 1610;
					var l:Number = src.charCodeAt(i + 3) - 14;
					out += out.substr(-p, l);
					i += 3;
				}
				else
				{
					out += src.charAt(i);
				}
			}
			this.parseXML(out);
		}
		// Uncompressed XML can be parsed immediately:
		else
		{
			this.parseXML(src);
		}
		
		this.loaded = (src != undefined);
		this.onLoad(src != undefined);

	}
}