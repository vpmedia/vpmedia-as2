import net.manaca.lang.exception.Exception;

/**
 * 该异常由 Stack 类中的方法抛出，以表明堆栈为空
 * @author Wersling
 * @version 1.0, 2006-1-11
 */
class net.manaca.data.list.EmptyStackException extends Exception {
	
	public function EmptyStackException(message : String, thrower : Object, args : Array) {
		super(message, thrower, args);
	}

}