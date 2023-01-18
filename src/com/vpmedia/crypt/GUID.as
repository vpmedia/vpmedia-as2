/**
* Creates a new genuine unique identifier string.
* @authors Mika Palmu
* @version 1.0
*/

import com.vpmedia.crypt.SHA1;

class com.vpmedia.crypt.GUID {

	/**
	* Variables
	* @exclude
	*/
	private static var counter:Number = 0;

	/**
	* Creates a new Genuine Unique IDentifier. :)
	*/
	public static function create():String {
		var id1:Number = new Date().getTime();
		var id2:Number = Math.random()*Number.MAX_VALUE;
		var id3:String = System.capabilities.serverString;
		return SHA1.calculate(id1+id3+id2+counter++);
	}

}