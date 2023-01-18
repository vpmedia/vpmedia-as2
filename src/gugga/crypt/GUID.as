/**
* Creates a new genuine unique identifier string.
* @authors Mika Palmu
* @version 1.0
*/
class gugga.crypt.GUID {

	/**
	* Variables
	* @exclude
	*/
	private static var counter:Number = 0;

	/**
	* Creates a new Genuine Unique IDentifier. :)
	*/
	public static function create():String {
		var date:Date = new Date();
		var id1:Number = date.getTime();
		var id2:Number = Math.random()*Number.MAX_VALUE;
		var id3:String = System.capabilities.serverString;
		
		/**
		 * FIXME: To be returned original version of GUID(with SHA1)
		 * and add new class which will generate more "lite" random key
		 * to use in PreconditionsManager
		 */
		 
		counter++;
		return id1 + "_" + id2 + "_" + counter + "_" + id3;
		//return SHA1.calculate(id1+id3+id2+counter++);
	}

}