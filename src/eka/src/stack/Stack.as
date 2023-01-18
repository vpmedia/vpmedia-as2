
/* ------- Stack [Interface]

	Name : Stack
	Package : eka.src.stack
	Version : 1.0.0
	Date :  2005-04-24
	Author : ekameleon
	URL : http://www.ekameleon.net
	Mail : contact@ekameleon.net

	TODOLIST :
	
		AS2Unit >> TypedStack

	THANKS : AS2Unit

----------  */

import eka.src.util.* ;

interface eka.src.stack.Stack {

	function push(o):Void ;
	
	function pop(Void) ;

	function peek(Void) ;

	function iterator(Void):Iterator ;

	function isEmpty(Void):Boolean ;
	
}
