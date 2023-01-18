
/* ------- 	MapIterator

	Name : MapIterator
	Package : eka.src.map
	Version : 1.0.0
	Date :  2005-04-24
	Author : ekameleon
	URL : http://www.ekameleon.net
	Mail : contact@ekameleon.net

	THANKS : AS2Lib
	
----------  */

import eka.src.map.* ;
import eka.src.util.* ;
import eka.src.array.* ;

class eka.src.map.MapIterator implements Iterator {

	// ----o Author Properties

	public static var className:String = "MapIterator" ;
	public static var classPackage:String = "eka.src.map" ;
	public static var version:String = "1.0.0";
	public static var author:String = "ekameleon";
	public static var link:String = "http://www.ekameleon.net" ;
	
	// ----o Construtor
	
	public function MapIterator (m:Map) {
		_m = m ;
		_i = new ArrayIterator(m.getKeys()) ;
	}
	
	// ----o Public Methods
	
	public function hasNext(Void):Boolean {
		return _i.hasNext() ;
	}
	
	public function next(Void) {
		_k = _i.next() ;
		return _m.get(_k)
		
	}
	
	public function remove(Void):Void {
		_i.remove() ;
		_m.remove(_k) ;
	}

	// ----o Private Properties
	
	private var _m:Map ; 
	private var _i:ArrayIterator ; 
	private var _k ; // current key
	
}
