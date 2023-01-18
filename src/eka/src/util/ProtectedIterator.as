
import eka.src.util.* ;
import eka.src.exception.* ;

class eka.src.util.ProtectedIterator implements Iterator {

	// ----o Author Properties

	public static var className:String = "ProtectedIterator" ;
	public static var classPackage:String = "eka.src.util" ;
	public static var version:String = "1.0.0";
	public static var author:String = "ekameleon";
	public static var link:String = "http://www.ekameleon.net" ;
	
	// ----o Construtor
	
	public function ProtectedIterator (i:Iterator) {
		_i = i ;
	}
	
	// ----o Public Methods
	
	public function hasNext(Void):Boolean {
		return _i.hasNext() ;
	}
	
	public function next(Void) {
		return _i.next() ;
		
	}
	
	public function remove(Void):Void {
		throw new UnsupportedOperationException ;
	}
	
	public function reset(Void):Void {
		throw new UnsupportedOperationException ;
	}
	
	public function seek(n:Number):Void {
		throw new UnsupportedOperationException ;
	}
	
	// ----o Private Properties
	
	private var _i:Iterator ;
	
}
