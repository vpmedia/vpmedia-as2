
/* ------- Collection [Interface]

	Name : Collection
	Package : eka.src.collections
	Version : 1.0.0
	Date :  2005-04-24
	Author : ekameleon
	URL : http://www.ekameleon.net
	Mail : contact@ekameleon.net

----------  */

import eka.src.util.* ;
import eka.src.collections.* ;

interface eka.src.collections.Collection {

	function clear(Void):Void ;

	function contains(o):Boolean ;
	
	function containsAll(c:Collection):Boolean ;

	function get(id:Number) ;

	function insert(o):Boolean ;
	
	function insertAll(c:Collection):Boolean ;

	function isEmpty(Void):Boolean ;

	function iterator(Void):Iterator ;

	function remove(o):Boolean ;
	
	function removeAll(c:Collection):Boolean ;

	function retainAll(c:Collection):Boolean ;

	function size(Void):Number ;

	function toArray(Void):Array ;

}
