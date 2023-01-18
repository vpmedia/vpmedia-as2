class com.vpmedia.text.ScrambleText extends MovieClip
{
	//
	private var nScrambleInterval:Number;
	private var sText:String;
	private var dText:String;
	private var aFirstString:Array;
	private var aEndString:Array;
	private var aJoinString:Array;
	private var nStringCount:Number;
	//
	private var tfTarget:TextField;
	//
	function ScrambleText ()
	{
	}
	//	========================================================================
	//								PRIVATE FUNCTIONS
	//	========================================================================
	//
	private function shuffle (a:Number, b:Number):Number
	{
		return (Math.floor (Math.random () * 2));
	}
	private function encode ():Void
	{
		if (nStringCount < aFirstString.length)
		{
			returnText (dText + aJoinString[nStringCount]);
			nStringCount++;
		}
		else
		{
			//
			clearInterval (nScrambleInterval);
			nStringCount = 0;
			nScrambleInterval = setInterval (this, "decode", 30);
		}
	}
	private function decode ():Void
	{
		var sBeginText:String;
		var sEndText:String;
		if (nStringCount < aFirstString.length)
		{
			var sCurrString:String = dText;
			sBeginText = sCurrString.substring (0, nStringCount);
			sEndText = sCurrString.substring (nStringCount + 1, sCurrString.length);
			//
			returnText ((sBeginText + aEndString[nStringCount]) + sEndText);
			//
			nStringCount++;
		}
		else
		{
			//
			clearInterval (nScrambleInterval);
		}
	}
	private function returnText (dTxt:String):Void
	{
		// trace("returnText("+dTxt+")");
		dText = dTxt;
		//
		tfTarget.text = dText;
		//return (tfTarget.text = dText);
	}
	//	========================================================================
	//								PUBLIC FUNCTIONS
	//	========================================================================
	public function scramble (tfTrgt:TextField, dispTxt:String):Void
	{
		// trace("scramble("+dispTxt+")");
		tfTarget = tfTrgt;
		dText = dispTxt;
		sText = dText;
		aFirstString = sText.split ("");
		aEndString = sText.split ("");
		aJoinString = aFirstString.sort (shuffle);
		nStringCount = 0;
		//
		clearInterval (nScrambleInterval);
		nScrambleInterval = setInterval (this, "encode", 10);
		//
		returnText ("");
		//
	}
	// END CLASS	
}
