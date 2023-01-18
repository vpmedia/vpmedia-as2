
/* ------- 	Map [Interface]

	Name : Map
	Package : eka.src.map
	Version : 1.0.0
	Date :  2005-04-24
	Author : ekameleon
	URL : http://www.ekameleon.net
	Mail : contact@ekameleon.net

	TODOLIST : 
		AS2Unit >> TypedMap
		AS2Unit >> PrimitiveTypeMap
		AS2Unit >> PriorityMap

----------  */

import eka.src.util.* ;

interface eka.src.map.Map {

	function containsKey(key):Boolean ;
	
	function containsValue( value ):Boolean ;

	function getKeys(Void):Array ;

	function getValues(Void):Array ;

	function get(key) ;

	function put(key, value) ;
	
	function putAll(m:Map):Void ;

	function remove(key) ;
	
	function clear(Void):Void ;
	
	function iterator(Void):Iterator ;

	function isEmpty(Void):Boolean ;
	
	function size(Void):Number ;
	
}
