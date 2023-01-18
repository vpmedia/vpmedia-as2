
/* ------- Queue [Interface]

	Name : Queue
	Package : eka.src.queue
	Version : 1.0.0
	Date :  2005-04-24
	Author : ekameleon
	URL : http://www.ekameleon.net
	Mail : contact@ekameleon.net

	Description : File d'attente, on ajoute en queue de la liste et on enlève en tête.

	TODOLIST :
	
		CircularQueue
		PriorityQueue
		
----------  */

import eka.src.util.* ;

interface eka.src.queue.Queue {

	function element(Void) ;
	
	function enqueue(o):Boolean ;
	
	function dequeue(Void) ;

	function iterator(Void):Iterator ;
	
	function peek(Void) ;
	
	function poll(Void) ;

}
