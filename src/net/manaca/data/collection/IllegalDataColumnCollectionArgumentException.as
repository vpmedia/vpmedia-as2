import net.manaca.lang.exception.Exception;

/**
 * 在执行DataColumnCollection方法中，传入参数错误时抛出此异常
 * @author Wersling
 * @version 1.0, 2005-12-31
 */
class net.manaca.data.collection.IllegalDataColumnCollectionArgumentException extends Exception {
	
	public function IllegalDataColumnCollectionArgumentException(message : String, thrower : Object, args : Array) {
		super(message, thrower, args);
	}

}