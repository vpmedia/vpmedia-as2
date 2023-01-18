
/* ------- 	Iterator [Interface]

	Name : Iterator
	Package : eka.src.util
	Version : 1.0.0
	Date :  2005-04-24
	Author : ekameleon
	URL : http://www.ekameleon.net
	Mail : contact@ekameleon.net

----------  */

interface eka.src.util.Iterator {
	
	function hasNext(Void):Boolean ;
	
	function next(Void) ;
	
	function remove(Void):Void ;

	function seek(n:Number):Void ;
	
	function reset(Void):Void ;
	
}

