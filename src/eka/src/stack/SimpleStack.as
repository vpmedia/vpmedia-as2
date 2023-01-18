
/* ------- 	SimpleStack

	Name : SimpleStack
	Package : eka.src.stack
	Version : 1.0.0
	Date :  2005-04-24
	Author : ekameleon
	URL : http://www.ekameleon.net
	Mail : contact@ekameleon.net

	THANKS : AS2Lib
	
----------  */

import eka.src.util.* ;
import eka.src.array.* ;
import eka.src.stack.* ;

class eka.src.stack.SimpleStack implements Stack {

	// ----o Author Properties

	public static var className:String = "SimpleStack" ;
	public static var classPackage:String = "eka.src.stack" ;
	public static var version:String = "1.0.0";
	public static var author:String = "ekameleon";
	public static var link:String = "http://www.ekameleon.net" ;

	// ----o Construtor
	
	public function SimpleStack(Void) {
		_values = new Array ;
	}
	
	// ----o Public Methods

	public function toString(Void):String {
		return new StackStringifier().execute(this) ;
	}

	public function push(o):Void {
		_values.push(o) ;
	}
	
	public function pop(Void) {
		if (isEmpty()) return ;
		else return _values.pop() ;
	}

	public function peek(Void) {
		return _values[_values.length -1] ;
	}

	public function iterator(Void):Iterator {
		var aReverse:Array = _values.slice() ;
		aReverse.reverse() ;
		return (new ProtectedIterator(new ArrayIterator(aReverse))) ;
	}

	public function isEmpty(Void):Boolean {
		return _values.length < 1 ;
	}
	
	// ----o Private Properties
	
	private var _values:Array;
	
}
