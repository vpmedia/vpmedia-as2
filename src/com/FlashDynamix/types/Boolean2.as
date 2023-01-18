class com.FlashDynamix.types.Boolean2 extends Boolean {
	public static function parse(str:String):Boolean {
		str = str.toString();
		if (str.toLowerCase() == "true" || str == "1") {
			return true;
		} else if (str.toLowerCase() == "false" || str == "0") {
			return false;
		}
	}
}
