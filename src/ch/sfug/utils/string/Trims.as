/**
 * @author Marcel
 */

class ch.sfug.utils.string.Trims
{
	private function Trims() {};

	
	public static function rtrim(str:String):String {
		var i:Number = str.length;
		while(i--)
		if(str.charCodeAt(i) > 32){
			return substring(str, 0, i + 1);
		}
		
		return "";
	}
	 
	public static function ltrim(str:String):String {
		 var i:Number = -1; 
		 var l:Number = str.length;
		 while(i++ < l)
		 if(str.charCodeAt(i) > 32) {
			 return str.substring(i);
		 }
		 return "";
	}
	 
	public static function trim(str:String):String {
		 return rtrim(ltrim(str));
	}
	 	
}