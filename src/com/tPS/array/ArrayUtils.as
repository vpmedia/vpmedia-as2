/**
 * Array utilities
 * 
 * @author tPS
 * @version 1
 */
 
class com.tPS.array.ArrayUtils {
	
	static public function getIndex($element:Object, $array:Array) : Number {
		var index:Number = -1;
		var i:Number = $array.length;
		while(--i > -1) {
			if($array[i] == $element){
				index = i;
				break;
			}
		}
		return index;
	}
	
	static public function getMinMax($array:Array) : Array {
		var sorted:Array = $array.sort(Array.NUMERIC);
		return [sorted[0], sorted[sorted.length-1]];
	}
}