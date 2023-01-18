/**
* David's handy Array utility methods
* 
* You can never have enough deep copy implementations
* 
* @author David Knape
*/

class com.bumpslide.util.ArrayUtil {

	/**
	* Checks for the existence of a value in an array
	* 
	* concept borrowed from php's in_array function
	* 
	* @param	needle
	* @param	haystack
	*/
	static function in_array(needle, haystack:Array) {
		for(var n in haystack) {
			if(haystack[n] == needle) return true;
		}
		return false;
	}

	/**
	* Shuffles (modifies original) array 
	* 
	* for card games and such :)
	* 
	* @param a array to shuffle
	*/
	static function shuffle(a:Array) {
		var i = a.length;
		while (i) {
			var p = random(i);
			var t = a[--i];
			a[i] = a[p];
			a[p] = t;
		}
	}

	/**
	* Array search utility
	*  
	* Soes something like...
	* SELECT * FROM arrayOfObjects WHERE propToSearch = valueToFind
	*  
	* Note: If you are using this, you might be better off with a 
	* lookup table or XPath.
	* 
	* @param	arrayOfObjects
	* @param	propToSearch string name of property to query
	* @param	valueToFind 
	*/
	static function findObject(arrayOfObjects:Array, propToSearch:String, valueToFind) {
		for(var o in arrayOfObjects) {
			if(arrayOfObjects[o][propToSearch] == valueToFind) {
				return arrayOfObjects[o];
			}
		}
		return undefined;
	}
	
	/**
	* Recursively copies (deep copies) an array or an object
	* 
	* There are no recursion limit checks here.  
	* Use at your own risk.
	* 
	* ObjecUtil.clone is an alias of this method.
	* 
	* @param	obj
	*/
	static function dCopy(obj) {
		var newObj;		
		if(obj instanceof Array) {
			newObj = [];			
			for(var i=0; i<obj.length; ++i) {
				newObj[i] = (typeof(obj[i])=='object') ? dCopy( obj[i] ) : obj[i];
			}			
		} else if (obj instanceof Date) {
			var d:Date = new Date();
			d.setTime( obj.getTime() );
			return d;
		} else {
			newObj = {};
			for(var n in obj) {				
				newObj[n] = (typeof(obj[n])=='object') ? dCopy( obj[n] ) : obj[n];
			}		
		}
		return newObj;
	}
	
	
	/**
	 * Returns the index of first occurance of the given {@code object} within
	 * the passed-in {@code array}.
	 * 
	 * <p>The content of the {@code array} is searched through by iterating through the
	 * array. This method returns the first occurence of the passed-in {@code object}
	 * within the {@code array}. If the object could not be found {@code -1} will be
	 * returned.
	 * 
	 * Blatantly stolen from AS2LIB 
	 * 
	 * @param array the array to search through
	 * @param object the object to return the position of
	 * @return the position of the {@code object} within the {@code array} or {@code -1}
	 */
	public static function indexOf(array:Array, object):Number{
		for (var i:Number=0; i < array.length; i++) {
			if (array[i] === object) {
				return i;
			}
		}
		return -1;
	}
	
	/**
	 * Returns the index of the last occurance of the given {@code object} within
	 * the passed-in {@code array}.
	 * 
	 * The content of the {@code array} is searched through by iterating through the
	 * array. This method returns the last occurence of the passed-in {@code object}
	 * within the {@code array}. If the object could not be found {@code -1} will be
	 * returned.
	 * 
	 * Blatantly stolen from AS2LIB 
	 * 
	 * @param array the array to search through
	 * @param object the object to return the position of
	 * @return the position of the {@code object} within the {@code array} or {@code -1}
	 */
	public static function lastIndexOf(array:Array, object):Number{
	    var i:Number = array.length;
		while (--i-(-1)) {
			if (array[i] === object) {
				return i;
			}
		}
		return -1;
	}
	
	
	/**
	* Returns sum of values in an array
	* @param	a
	*/
	public static function sum(a:Array) {
		var n = 0;
		for(var i in a) n+=a[i];
		return n;
	}
	
	/**
	* returns mean of values in an array
	* @param	a
	*/
	public static function average(a:Array) {
		return sum(a)/a.length;
	}
	
	/**
	* pass each element of an array to a function sequentially
	* 
	* @param	a
	* @param	func
	*/
	public static function each( a:Array, func:Function ) {
		var len=a.length;
		for(var n=0; n<len; ++n) func.call( null, a[n] );
	}
	
	
}