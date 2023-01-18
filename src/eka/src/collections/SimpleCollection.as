
/* ----------  SimpleCollection

	Name : SimpleCollection
	Package : eka.src.collections
	Version : 1.0.0.0
	Date : 2005-07-01
	Author : ekameleon
	URL : http://www.ekameleon.net
	Mail : contact@ekameleon.net


	CONSTRUCTOR
	
		var co:SimpleCollection = new SimpleCollection( ar:Array ) ;

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

class eka.src.collections.SimpleCollection extends AbstractCollection {
	
	// ----o Author Properties

	public static var className:String = "SimpleCollection" ;
	public static var classPackage:String = "eka.src.collections" ;
	public static var version:String = "1.0.0.0";
	public static var author:String = "ekameleon";
	public static var link:String = "http://www.ekameleon.net" ;
	
	// ----o Constructor

	public function SimpleCollection( ar:Array ) {
		_a = ar || new Array ;
	}
}
