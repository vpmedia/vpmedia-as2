// TitleCase.as
class com.vpmedia.text.TitleCase extends MovieClip
{
	function TitleCase ()
	{
	}
	public function changeCase (dispTxt:String):String
	{
		//
		var sWord:String;
		var aNewText:Array;
		// remove any html <br> Tags
		aText = new Array ();
		var aText:Array = dispTxt.toLowerCase ().split ("<br>");
		sWord = aText.join (" ");
		//
		// Start changing the case
		var aText:Array = sWord.split (" ");
		//
		aNewText = new Array ();
		for (var i = 0; i < aText.length; i++)
		{
			sWord = aText[i].substr (0, 1).toUpperCase () + aText[i].substr (1, (aText[i].length)).toLowerCase ();
			aNewText.push (sWord);
		}
		sWord = aNewText.join (" ");
		//
		return (sWord);
		//
	}
}
