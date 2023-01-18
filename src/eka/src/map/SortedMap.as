
/* ------- 	SortedMap [Interface]

	Name : SortedMap
	Package : eka.src.map
	Version : 1.0.0
	Date :  2005-04-25
	Author : ekameleon
	URL : http://www.ekameleon.net
	Mail : contact@ekameleon.net

----------  */

import eka.src.map.* :
import eka.src.util.* :

interface eka.src.map.SortedMap extends Map {

	function comparator():Comparator ;

	function firstKey(Void):Entry ;
	
	function headMap(to:Entry):SortedMap ;
	
	function lastKey(Void):Entry ;
	
	function subMap(from:Entry, to:Entry):SortedMap ;
	
	function tailMap(from:Entry):SortedMap ;
	
}
