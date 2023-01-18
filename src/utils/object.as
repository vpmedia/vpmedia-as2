class utils.object
{
	static function copyTextFormat(from):TextFormat
	{
		var tempObj = new TextFormat();
		for (var i in from)
		{
			tempObj[i] = from[i];
		}
		return tempObj;
	}
}