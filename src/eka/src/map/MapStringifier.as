
/* ------- 	MapStringifier

	Name : MapStringifier
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

class eka.src.map.MapStringifier implements Stringifier {

	// ----o Author Properties

	public static var className:String = "MapStringifier" ;
	public static var classPackage:String = "eka.src.map" ;
	public static var version:String = "1.0.0";
	public static var author:String = "ekameleon";
	public static var link:String = "http://www.ekameleon.net" ;

	// ----o Public Methods

	public function execute(o):String {
		var m:Map = Map(o);
		var r:String = "{ ";
		var vIterator:Iterator = new ArrayIterator(m.getValues());
		var kIterator:Iterator = new ArrayIterator(m.getKeys())
		while (kIterator.hasNext()) {
			r += kIterator.next().toString() + ":" + vIterator.next().toString();
			if (kIterator.hasNext()) r += " , ";
		}
		r += " }";
		return r ;
	}
	
}
