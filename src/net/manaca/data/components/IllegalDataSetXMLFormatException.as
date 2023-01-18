import net.manaca.lang.exception.Exception;

/**
 * DataSet的xml格式错误
 * @author Wersling
 * @version 1.0, 2005-11-29
 */
class net.manaca.data.components.IllegalDataSetXMLFormatException extends Exception {
	
	public function IllegalDataSetXMLFormatException(message : String, thrower : Object, args : Array) {
		super(message, thrower, args);
	}

}