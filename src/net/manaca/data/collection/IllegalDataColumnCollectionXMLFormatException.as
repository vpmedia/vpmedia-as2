import net.manaca.lang.exception.Exception;

/**
 * "传入DataColumnCollection.Add()方法中的操作不符合要求
 * @author Wersling
 * @version 1.0, 2005-12-30
 */
class net.manaca.data.collection.IllegalDataColumnCollectionXMLFormatException extends Exception {
	
	public function IllegalDataColumnCollectionXMLFormatException(message : String, thrower : Object, args : Array) {
		super("传入DataColumnCollection.Add()方法中的操作不符合要求", thrower, args);
	}

}