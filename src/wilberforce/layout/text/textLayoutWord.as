class wilberforce.layout.text.textLayoutWord
{
	var text:String;
	var textFormat:TextFormat;
	var rollOverTextFormat:TextFormat
	var pressFunction:Function
	var rollOverFunction:Function
	var rollOutFunction:Function;
	// The following are mild hacks for now
	var assignedMovieClip:MovieClip;
	var assignedTextField:TextField;
	function textLayoutWord(tText:String,tTextFormat:TextFormat,tPressFunction:Function,tRollOverFunction:Function,tRollOutFunction:Function,tRollOverTextFormat:TextFormat)
	{
		text=tText;
		textFormat=tTextFormat;
		pressFunction=tPressFunction;
		rollOverFunction=tRollOverFunction;
		rollOutFunction=tRollOutFunction;
		rollOverTextFormat=tRollOverTextFormat;
		if (!tTextFormat.leading) tTextFormat.leading=2;
	}
}