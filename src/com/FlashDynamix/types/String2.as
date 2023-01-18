import com.FlashDynamix.types.Array2;
//
class com.FlashDynamix.types.String2 {
	public static function replace(str:String, remove:String, replace:String):String {
		return str.split(remove).join(replace);
	}
	public static function replaceAll(str:String, items:Array, replace:String):String {
		var nStr:String = str;
		for(var i=0; i<items.length; i++){
			nStr = String2.replace(nStr, items[i], replace);
		}
		return nStr;
	}
	public static function trimEnd(value:String, remove:String):String {
		//
		var nStr:String = value;
		var idx:Number = nStr.length-1;
		//
		while (nStr.substr(idx, 1) == remove) {
			nStr = nStr.slice(0, idx);
			idx--;
		}
		return nStr;
	}
	public static function trimStart(value:String, remove:String):String {
		//
		var nStr:String = value;
		var idx:Number = 0;
		//
		while (nStr.substr(idx, 1) == remove) {
			nStr = nStr.slice(idx+1);
			idx++;
		}
		return nStr;
	}
	public static function contains(str:String, has:String):Boolean{
		return (str.indexOf(str)!=-1)
	}
	public static function count(str:String, of:String):Number{
		return str.split(of).length
	}
	public static function splitOn(str:String, split:Array):Array{
		var sl:String = split[int(0)]
		var items:Array = str.split(sl);
		items = Array2.removeEmpty(Array2.addBetween(items, sl), "");
		//
		for(var i=1; i<split.length; i++){
			sl = split[i];
			for(var j=0; j<items.length; j++){
				var a:Array = items[j].split(sl);
				if(a.length>1){
					items.splice(j, 1);
					a = Array2.removeEmpty(Array2.addBetween(a, sl), "");
					items = Array2.insertAt(j, items, a);
					j+=a.length-1;
				}
			}
		}
		return items
	}
}
