
/* ------- StackStringifier

	Name : StackStringifier
	Package : eka.src.stack
	Version : 1.0.0
	Date :  2005-04-24
	Author : ekameleon
	URL : http://www.ekameleon.net
	Mail : contact@ekameleon.net

	THANKS : AS2Lib
	
----------  */

import eka.src.stack.* ;
import eka.src.util.* ;

class eka.src.stack.StackStringifier implements Stringifier {

	// ----o Author Properties

	public static var className:String = "StackStringifier" ;
	public static var classPackage:String = "eka.src.stack" ;
	public static var version:String = "1.0.0";
	public static var author:String = "ekameleon";
	public static var link:String = "http://www.ekameleon.net" ;

	// ----o Public Methods

	public function execute(o):String {
		var s:Stack = Stack(o);
		var r:String = "{ ";
		var i:Iterator = s.iterator() ;
		while (i.hasNext()) {
			r += i.next().toString() ;
			if (i.hasNext()) r += " , ";
		}
		r += " }";
		return r ;
	}
	
}
