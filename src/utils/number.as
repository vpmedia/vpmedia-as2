class utils.number
{
	static function addCents(num:Number):String
	{
		var a = (String((Math.round(num*100)/100))).split(".");
		if(a[1] == undefined)
		{
			a[1] = 0;
		}
		a[1] = (String(a[1]) + "00").substr(0, 2);
		return a.join(".");
	}
}