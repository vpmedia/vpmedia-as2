class com.FlashDynamix.types.Number2 {
	public static function places(num:Number, p:Number):Number {
		var numStr:String = num.toString();
		var idx:Number = numStr.indexOf(".");
		if(idx == -1){
			return num;
		}
		var whole:String = numStr.substring(0, idx);
		var decimal:String = numStr.substring(idx+1).substr(0, p);
		return parseFloat(whole+"."+decimal);
	}
	public static function difference(num1:Number, num2:Number):Number {
		return (Math.abs(num1-num2))
	}
	public static function within(num:Number, start:Number, end:Number):Boolean{
		return (num>=start && num<=end); 
	}
	public static function valid(val:Number):Boolean {
		return (!isNaN(val-1));
	}
	public static function round(num:Number, places:Number){
		var n:Number = Math.pow(10, places);
		return  Math.round(n*parseFloat(num.toString()))/n
	}
}
