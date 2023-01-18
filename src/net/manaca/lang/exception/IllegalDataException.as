import net.manaca.lang.exception.Exception;

/**
 * 
 * @author Wersling
 * @version 1.0, 2005-12-3
 */
class net.manaca.lang.exception.IllegalDataException extends Exception {
	/*
	 * 构造函数
	 * @param 无
	 */
	public function IllegalDataException(message:String, thrower:Object, args:Array) {
		super(message, thrower, args);
	}
}