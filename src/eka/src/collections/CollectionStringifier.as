
/* ------- 	CollectionStringifier

	Name : CollectionStringifier
	Package : eka.src.collections
	Version : 1.0.0
	Date :  2005-04-24
	Author : ekameleon
	URL : http://www.ekameleon.net
	Mail : contact@ekameleon.net

	THANKS : AS2Lib
	
----------  */

import eka.src.util.* ;
import eka.src.array.* ;
import eka.src.collections.* ;


class eka.src.collections.CollectionStringifier implements Stringifier {

	// ----o Author Properties

	public static var className:String = "CollectionStringifier" ;
	public static var classPackage:String = "eka.src.collections" ;
	public static var version:String = "1.0.0";
	public static var author:String = "ekameleon";
	public static var link:String = "http://www.ekameleon.net" ;

	// ----o Public Methods

	public function execute(o):String {
		var c:Collection = Collection(o);
		var r:String = "{ ";
		var it:Iterator = c.iterator() ;
		while (it.hasNext()) {
			r += it.next().toString() ;
			if (it.hasNext()) r += " , ";
		}
		r += " }";
		return r ;
	}
	
}
