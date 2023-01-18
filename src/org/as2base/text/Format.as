class org.as2base.text.Format
{
	static function fillZero( num: Number, digits: Number ): String
	{
		return new String( '00000000000000000000000000000000' + num ).substr( -digits );
	}
	
	/*
	* ignore the last 2 parameters, just performance boost
	* returns Array with 0: MM, 1: SS, 2: MMM
	*/

	static function milli2MmSsMmm( totalMillis: Number, ms: Number, rest: Number ): Array
	{
		var sec = ( rest = ( totalMillis - ( ms = totalMillis % 1000 ) ) / 1000 ) % 60;
		
		return [ new String( '0' + ( ( rest - sec ) / 60 ) ).substr( -2 ) , new String( '0' + sec ).substr( -2 ) , new String( '00' + ms ).substr( -3 ) ];
	}
}