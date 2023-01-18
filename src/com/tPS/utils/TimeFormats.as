/**
 * TimeFormats
 * performs calculations between 
 * ms and sec, min and Hours,
 * 
 * returns preformatted strings
 * 
 * 
 * @author tPS
 * @version 1
 */
 
 
class com.tPS.utils.TimeFormats {
	
	public static function getString( $t:Number, $base:String, $digits:Array, $seperator:String ) : String {
		var time:String = "";
		
		var s:Number = -1;
		
		switch($base){
			case "ms":					while(++s < $digits.length){
															
											switch(s){
												case 0:		//ms
															time += formatT($t, 1000, $digits[s]);
															break;
												case 1:		//sec
															time = formatT($t/1000, 60, $digits[s]) + time;
															break;
												case 2:		//min
															time = formatT($t/60000, 60, $digits[s]) + time;
															break;
												case 3:		//hours
															time = formatT($t/(60000*60), 24, $digits[s]) + time;
															break;
											}
											
											time = (($seperator) ? $seperator : ":") + time;
										}
										 
										break;
										
			case "sec":					while(++s < $digits.length){
															
											switch(s){
												case 0:		//sec
															time = formatT($t, 60, $digits[s]) + time;
															break;
												case 1:		//min
															time = formatT($t/60, 60, $digits[s]) + time;
															break;
												case 2:		//hours
															time = formatT($t/(60*60), 24, $digits[s]) + time;
															break;
											}
											
											time = (($seperator) ? $seperator : ":") + time;
										}
										break;		
		}
		time = time.substr(1);
		return time;
	}
	
	
	private static function formatT( t:Number, $base:Number, $digits:Number ) : String {
		//init
		var time:String = "";
				
		//calc modulo offset
		time = String( Math.floor(t)%$base );
		
		//add zero digits
		if(time.length < $digits){
			var zeros:String = "";
			var i:Number = $digits - time.length;
			while(--i > -1){
				zeros += "0";
			}
			time = zeros + time;
		}else if(time.length > $digits) {
			//truncate & round
			var i:Number = time.length - $digits;
			time = String( Math.floor( Number(time) / Math.pow(10,i) ) );
		}
		
		//truncate 
		
		return time;
	} 
	
}