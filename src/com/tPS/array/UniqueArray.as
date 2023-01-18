/**
* Uniquearray
* @author tPS
* @version 1
*/

class com.tPS.array.UniqueArray{
	
	static public function isNotInArray($val:Object,$arr:Array):Boolean{
		var ret:Boolean = true;
		var i:Number = $arr.length;
		while(--i > -1){
			if($arr[i] == $val){
				ret = false;
				break;
			}
		}
		return ret;
	}
	
}