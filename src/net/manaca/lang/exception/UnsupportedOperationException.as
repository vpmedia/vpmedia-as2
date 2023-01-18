import net.manaca.lang.exception.Exception;

/**
 * 不支持的操作异常
 * @author Wersling
 * @version 1.0, 2006-1-11
 */
class net.manaca.lang.exception.UnsupportedOperationException extends Exception {
	
	public function UnsupportedOperationException(message : String, thrower : Object, args : Array) {
		super(message, thrower, args);
	}

}