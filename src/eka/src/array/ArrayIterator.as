
/* ------- 	ArrayIterator

	Name : ArrayIterator
	Package : eka.src.array
	Version : 1.0.0

	Date :  2005-04-24
	Author : ekameleon
	URL : http://www.ekameleon.net
	Mail : contact@ekameleon.net

	THANKS : AS2Lib
	
----------  */

import eka.src.util.* ;

class eka.src.array.ArrayIterator implements Iterator {

	// ----o Author Properties

	public static var className:String = "ArrayIterator" ;
	public static var classPackage:String = "eka.src.array" ;
	public static var version:String = "1.0.0";
	public static var author:String = "ekameleon";
	public static var link:String = "http://www.ekameleon.net" ;

	// ----o Construtor
	
	public function ArrayIterator(a:Array) {
		_a = a ;
		_k = -1 ;
	}
	
	// ----o Public Methods	
	
	public function hasNext(Void):Boolean {
		return (_k < _a.length - 1);
	}
	
	public function next(Void) {
		return _a[++_k] ;
	}
	
	public function remove(Void):Void {
		_a.splice(_k--, 1);
	}
	
	public function seek(n:Number):Void {
		if (n<-1) n = -1 ;
		else if (n>_a.length) n = _a.length ;
		_k = n ;
	}
	
	public function reset(Void):Void {
		_k = -1 ;
	}
		
	public function toString(Void):String {
		return "[ArrayIterator]" ;
	}
	
	// -----o Private Properties
	
	private var _a:Array ; // current array
	private var _k:Number ; // current key

}
