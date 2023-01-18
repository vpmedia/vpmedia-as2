class com.FlashDynamix.types.Object2 {
	public static function isEmpty(obj:Object):Boolean {
		for (var item in obj) {
			return false;
		}
		return true;
	}
	public static function copyNew(obj:Object):Object{
		var o:Object = new Object();
		for(var item in obj){
			o[item] = obj[item]
		}
		return o;
	}
}
