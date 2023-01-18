
/* ---------- 	AbstractIterator

	Name : AbstractIterator
	Package : eka.src.collections
	Version : 1.0.0
	Date :  2005-04-17
	Author : ekameleon
	URL : http://www.ekameleon.net
	Mail : contact@ekameleon.net

	
	METHODS
		
		hasNext() 
			Renvoi "true" si l'on peut incrémenter l'Iterator
		
		next () 
			Renvoi un objet équivalent au prochain élément dans la liste. 
			Renoi null si il n'y a pas d'item à la prochaine itération.
			
			
		
----------  */

import eka.src.util.* ;
import eka.src.collections.* ;

class eka.src.collections.AbstractIterator implements Iterator {

	// ----o Author Properties

	public static var className:String = "AbstractIterator" ;
	public static var classPackage:String = "eka.src.collections" ;
	public static var version:String = "1.0.0";
	public static var author:String = "ekameleon";
	public static var link:String = "http://www.ekameleon.net" ;

	// ----o Construtor
	
	public function AbstractIterator (co:Collection) {
		_c = co ;
		_k = 0 ;
	}
	
	// ----o Public Methods

	public function hasNext(Void):Boolean {
		return _k < _c.size() ;
	}	

	public function next(Void) {
		_o = _c.get(_k++) ;
		return _o ;
	}	
	
	public function remove(Void):Void {
		if (_o != undefined) {
			_c.remove(_o) ;
			_k -- ;
			delete _o ;
		}
	}

	public function reset(Void):Void {
		_k = 0 ;
	}
	
	public function seek(n:Number):Void {
		if (n<0) n = 0 ;
		else if (n>_c.size()) n = _c.size() ;
		_k = n ;
	}
		
	public function toString(Void):String {
		return "[AbstractIterator]" ;
	}

	// ----o Private Properties
	
	private var _c:Collection ; // Collection
	private var _k:Number ; // current key
	private var _o ; // save next object 

}
