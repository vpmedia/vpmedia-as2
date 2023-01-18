import net.manaca.lang.exception.Exception;

/**
 * 
 * @author Wersling
 * @version 1.0, 2005-11-25
 */
class net.manaca.lang.exception.MissingImplementFunctionException extends Exception {
	
	public function MissingImplementFunctionException(message : String, thrower : Object, args : Array) {
		super(message, thrower, args);
	}

}