import net.manaca.lang.exception.Exception;

/**
 * 不存在的元素警告
 * @author Wersling
 * @version 1.0, 2006-1-11
 */
class net.manaca.lang.exception.NoSuchElementException extends Exception {
	
	public function NoSuchElementException(message : String, thrower : Object, args : Array) {
		super(message, thrower, args);
	}

}