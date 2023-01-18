
/* ----------  AbstractCollection

	Name : AbstractCollection
	Package : eka.src.collections
	Version : 1.0.0.0
	Date : 2005-04-25
	Author : ekameleon
	URL : http://www.ekameleon.net
	Mail : contact@ekameleon.net


	METHODS

		clear()
	
		contains(o)
	
		containsAll(c:Collection)
	
		get(id)
	
		insert(o)
	
		insertAll(c:Collection)
	
		isEmpty()
	
		iterator()
	
		remove()
	
		removeAll(c:Collection)
	
		retainAll(c:Collection)
	
		size()
	
		toArray()
	
		toString()
	
----------  */

import eka.src.util.* ;
import eka.src.array.* ;
import eka.src.collections.* ;

class eka.src.collections.AbstractCollection implements Collection {
	
	// ----o Author Properties

	public static var className:String = "AbstractCollection" ;
	public static var classPackage:String = "eka.src.collections" ;
	public static var version:String = "1.0.0.0";
	public static var author:String = "ekameleon";
	public static var link:String = "http://www.ekameleon.net" ;
	
	// ----o Constructor

	private function AbstractCollection() {
		_a = new Array ;
	}
	
	// ----o Public Methods

	public function clear(Void):Void { _a.splice(0) }
	
	public function contains(o):Boolean { 
		return _indexOf(o) >- 1  ;
	}

	public function containsAll(c:Collection):Boolean {
		var it:Iterator = c.iterator() ;
		while(it.hasNext()) {
			if ( ! contains(it.next()) ) return false ;
		}
		return true ;
	}
	
	public function get(id:Number) { 
		return _a[id] ;
	}

	public function insert(o):Boolean {
		if (o == undefined) return false ;
		_a.push(o);
		return true ;
	}

	public function insertAll(c:Collection):Boolean {
		if (c.size() > 0) {
			var it:Iterator = c.iterator() ;
			while(it.hasNext()) insert(it.next()) ;
			return true ;
		} else {
			return false ;
		}
	}

	public function isEmpty(Void):Boolean { return _a.length == 0 }

	public function iterator(Void):Iterator { return new ArrayIterator(_a) }

	public function remove(o):Boolean {
		var it:Iterator = iterator() ;
		if (o == null) {
			while(it.hasNext()) {
				if (it.next() == null) {
					it.remove() ;
					return true ;
				}
			}
		} else {
			while (it.hasNext()) {
				if (o == it.next() ) {
					it.remove() ;
					return true ;
				}
			}
		}
		return false ;
	}

	public function removeAll(c:Collection):Boolean {
		var b = false ;
		var it:Iterator = iterator() ;
		while (it.hasNext()) {
			if ( c.contains(it.next()) ) {
				it.remove() ;
				b = true ;
			}
		}
		return b ;
	}

	public function retainAll(c:Collection):Boolean {
		var b:Boolean = false ;
		var it:Iterator = iterator() ;
		while(it.hasNext()) {
			if ( ! c.contains(it.next()) ) {
				it.remove() ;
				b = true ;
			}
		}
		return b ;
	}

	public function size(Void):Number { return _a.length }

	public function toArray(Void):Array { return _a.concat() }

	public function toString(Void):String {
		return new CollectionStringifier().execute(this) ;
	}

	// ----o Private Properties
	
	private var _a:Array ;

	// ----o Private Methods
	
	private function _indexOf(o):Number {
		var l:Number = _a.length ;
		for (var i:Number = 0 ; i<l ; i++) if (_a[i] == o) return i ;
		return -1 ; 
	}

}
