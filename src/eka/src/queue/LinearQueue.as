
/* ------- 	LinearQueue

	Name : LinearQueue
	Package : eka.src.queue
	Version : 1.0.0
	Date :  2005-04-24
	Author : ekameleon
	URL : http://www.ekameleon.net
	Mail : contact@ekameleon.net

	THANKS : AS2Lib
	
----------  */

import eka.src.util.* ;
import eka.src.array.* ;
import eka.src.queue.* ;

class eka.src.queue.LinearQueue implements Queue {

	// ----o Author Properties

	public static var className:String = "LinearQueue" ;
	public static var classPackage:String = "eka.src.queue" ;
	public static var version:String = "1.0.0";
	public static var author:String = "ekameleon";
	public static var link:String = "http://www.ekameleon.net" ;

	// ----o Constructor
	
	public function LinearQueue(Void) {
		_a = new Array ;
	}

	// ----o Public Methods

	public function element(Void) {
		return _a[0] ;
	}

	public function enqueue(o):Boolean {
		if (o == undefined) return false ;
		_a.push(o) ;
		return true ;
	}
	
	public function dequeue(Void) {
		if (isEmpty) return ;
		_a.shift() ;
	}

	public function iterator(Void):Iterator {
		return new ArrayIterator(_a) ;
	}

	public function peek(Void) {
		if (isEmpty()) return ;
		return _a[0] ;
	}

	public function poll(Void) {
		if (isEmpty()) return null ;
		return _a.shift() ;
	}	

	public function isEmpty(Void):Boolean {
		return (_a.length < 1)
	}

	public function size(Void):Number {
		return _a.length ;
	}

	public function toString(Void):String { 
		return new QueueStringifier().execute(this) ;
	}

	// ----o Private Properties
	
	private var _a:Array ;
	
}
