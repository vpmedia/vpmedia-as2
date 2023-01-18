/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is Neo Library.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <contact@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2005
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

/* ------- 	TypedQueue

	AUTHOR

		Name : TypedQueue
		Package : neo.data.collections
		Version : 1.0.0.0
		Date :  2006-02-09
		Author : ekameleon
		URL : http://www.ekameleon.net
		Mail : contact@ekameleon.net

	CONSTRUCTOR
	
		var ta:TypedQueue = new TypedQueue( type:Function , queue:Queue) 

	METHOD SUMMARY
	
		- clear() : clear the queue object
		
		- dequeue() : removes the head of this queue and return true if removes.
		
		- enqueue(o) : Inserts the specified element into this queue, if possible and return true.
		
		- getElements():Array
		
		- getIterator():Iterator
		
		- isEmpty():Boolean
		
		- getType() : return the type of the TypedQueue
		
		- peek() : Retrieves, but does not remove, the head of this queue, returning null if this queue is empty.
		
		- setType(type:Function) : set the type and clear TypedArray
		
		- toString():String

	INHERIT
	
		AbstractTypeable

	IMPLEMENTS 

		Iterable, Typeable, Validator


	SEE ALSO
	
		Iterator

----------  */

import com.bourre.data.collections.Queue;
import com.bourre.data.iterator.Iterable;
import com.bourre.data.iterator.Iterator;

import neo.util.AbstractTypeable;

class neo.data.collections.TypedQueue extends AbstractTypeable implements Iterable {

	// ----o Construtor
	
	public function TypedQueue(type:Function, queue:Queue) {
		super(type) ;
		if (!queue) throw new Error ("IllegalArgumentError :: Argument 'queue' must not be 'null' or 'undefined'.") ;
		_queue = queue ;
		var it:Iterator = _queue.getIterator() ;
		while (it.hasNext()) {
			validate(it.next()) ;

		}
		
	}
	
	// ----o Public Methods	

	public function clear():Void {
		_queue.clear() ;
	}

	public function dequeue() {
		return _queue.dequeue() ;
	}
	
	public function enqueue(o):Void {
		validate(o) ;
		_queue.enqueue(o) ;  
	} 


	public function getElements():Array {
		return _queue.getElements() ;
	}

	public function getIterator():Iterator {
		return _queue.getIterator() ;
	}

	public function isEmpty():Boolean {
		return _queue.isEmpty() ;
	}

	public function peek() {
		return _queue.peek() ;
	}
	
	public function setType( type:Function ):Void {
		super.setType(type) ;
		_queue.clear() ;
	}

	public function size():Number {
		return _queue.getElements().length ;
	}

	// -----o Private Properties
	
	private var _queue:Queue ;

}