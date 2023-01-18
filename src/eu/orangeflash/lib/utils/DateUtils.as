class eu.orangeflash.lib.utils.DateUtils
{
	public static function getFirstDayOfMonth(year:Number,month:Number):Number
	{
		return new Date(year,month).getDay();
	}
	
	public static function getDaysInMonth(year:Number,month:Number):Number
	{
		var date:Date = new Date(year,month);
		var result:Date = new Date (date.getTime ());
		result.setMonth (date.getMonth () + 1, 1);
		result.setDate (date.getDate () - 1);
		return result.getDate ();
	}
}