import net.manaca.lang.exception.Exception;

/**
 * 缺少必要的环境信息
 * @author Wersling
 * @version 1.0, 2006-1-18
 */
class net.manaca.globalization.NoConstructObjectException extends Exception {
	
	public function NoConstructObjectException(message : String, thrower : Object, args : Array) {
		super(message, thrower, args);
	}

}