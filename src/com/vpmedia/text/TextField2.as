// TextField2.as
class com.vpmedia.text.TextField2 extends TextField
{
	//
	public var className:String = "TextField2";
	private var tfDefaultFormat:TextFormat;
	private var sFontFace:String;
	function TextField2 (defaultFont:String)
	{
		//
		if (defaultFont != "")
		{
			defaultFormat (defaultFont);
		}
		//  
	}
	public function createTextField2 (trgtMc:MovieClip, chosenName:String, words_str:String, xPos:Number, yPos:Number, txtWidth:Number, txtHeight:Number, optParams:Object):TextField
	{
		// optParams = {depth:Numeric, autoSize: "none"/"left"/"center"/"right", border:true/false, borderColor:hexValue, background:true/false, backgroundColor:hexValue, embedFonts:true/false, html:true/false, selectable:true/false, textFormat:myTextFormat, type:"dynamic"/"input", wordWrap: true/false, maxChars:numericValue}
		if (optParams.depth == undefined)
		{
			var depth:Number = trgtMc.getNextDepth ();
		}
		else
		{
			var depth:Number = optParams.depth;
		}
		trgtMc.createTextField (chosenName, depth, xPos, yPos, txtWidth, txtHeight);
		var instanceName:TextField = trgtMc[chosenName];
		if (optParams.maxChars != undefined)
		{
			instanceName.maxChars = optParams.maxChars;
		}
		if (optParams.autoSize == undefined)
		{
			instanceName.autoSize = "none";
		}
		else
		{
			instanceName.autoSize = optParams.autoSize;
		}
		if (optParams.border == undefined)
		{
			instanceName.border = false;
		}
		else
		{
			instanceName.border = optParams.border;
		}
		if (optParams.borderColor == undefined)
		{
			instanceName.borderColor = undefined;
		}
		else
		{
			instanceName.borderColor = optParams.borderColor;
		}
		if (optParams.background == undefined)
		{
			instanceName.background = false;
		}
		else
		{
			instanceName.background = optParams.background;
		}
		if (optParams.backgroundColor == undefined)
		{
			instanceName.backgroundColor = undefined;
		}
		else
		{
			instanceName.backgroundColor = optParams.backgroundColor;
		}
		if (optParams.embedFonts == undefined)
		{
			instanceName.embedFonts = true;
		}
		else
		{
			instanceName.embedFonts = optParams.embedFonts;
		}
		if (optParams.html == false)
		{
			instanceName.html = false;
			instanceName.text = words_str;
		}
		else
		{
			instanceName.html = true;
			instanceName.htmlText = words_str;
		}
		if (optParams.type == undefined)
		{
			instanceName.type = "dynamic";
		}
		else
		{
			instanceName.type = optParams.type;
		}
		if (optParams.selectable == undefined)
		{
			instanceName.selectable = false;
		}
		else
		{
			instanceName.selectable = optParams.selectable;
		}
		if (optParams.wordWrap == undefined)
		{
			instanceName.wordWrap = false;
			instanceName.multiline = false;
		}
		else
		{
			instanceName.wordWrap = optParams.wordWrap;
			instanceName.multiline = optParams.wordWrap;
		}
		if (optParams.type == "input")
		{
			if (optParams.textFormat == undefined)
			{
				instanceName.setNewTextFormat (tfDefaultFormat);
			}
			else
			{
				instanceName.setNewTextFormat (optParams.textFormat);
			}
		}
		else
		{
			if (optParams.textFormat == undefined)
			{
				instanceName.setTextFormat (tfDefaultFormat);
			}
			else
			{
				instanceName.setTextFormat (optParams.textFormat);
			}
		}
		return (instanceName);
	}
	public function defaultFormat (font:String)
	{
		tfDefaultFormat = new TextFormat ();
		if (font == "")
		{
			tfDefaultFormat.font = sFontFace;
		}
		else
		{
			tfDefaultFormat.font = font;
			fontFace = font;
		}
	}
	public function set fontFace (val:String):Void
	{
		sFontFace = val;
		// trace("sFontFace: "+sFontFace)
	}
	public function get fontFace ():String
	{
		tfDefaultFormat.font = sFontFace;
		return (sFontFace);
	}
	public function toString ():String
	{
		return ("[" + className + "]");
	}
}
