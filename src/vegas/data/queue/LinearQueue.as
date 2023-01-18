/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is Vegas Framework.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <vegas@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2007
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

// TODO [2006-01-05] add toSource method et implement ISerializable in AbstractCollection class
// TODO [2006-01-12] Vérifier le constructeur de AbstractCollection ! utilise super ?

import vegas.core.ICloneable;
import vegas.data.Collection;
import vegas.data.collections.AbstractCollection;
import vegas.data.Queue;

/**
 * LinearQueue stores values in a 'first-in, first-out' manner.
 * <p><b>Example :</b></p>
 * import vegas.data.queue.LinearQueue ;
 * 
 * var q:LinearQueue = new LinearQueue(["item0", "item1"])  ;
 * trace ("queue size : " + q.size()) ;
 * trace ("enqueue item2 : " + q.enqueue ("item2")) ;
 * trace ("enqueue item3 : " + q.enqueue ("item3")) ;
 * trace ("enqueue item4 : " + q.enqueue ("item4")) ;
 * 
 * trace ("------- element") ;
 * trace ("element : " + q.element()) ;
 * trace ("peek : " + q.peek()) ;
 * 
 * trace ("------- dequeue") ;
 * trace ("dequeue : " + q.dequeue()) ;
 * 
 * trace ("------- iterator") ;
 * var it = q.iterator() ;
 * while (it.hasNext()) 
 * {
 *     trace (it.next()) ;
 * }
 * 
 * trace ("queue size : " + q.size() ) ;
 * trace ("queue toSource : " + q.toSource()) ;
 * }
 * @author eKameleon
 */
class vegas.data.queue.LinearQueue extends AbstractCollection implements Collection, ICloneable, Queue 
{

	/**
	 * Creates a new LinearQueue instance.
	 */
	public function LinearQueue( ar:Array ) 
	{
		_a = (ar.length > 0) ? [].concat(ar) : [] ;
	}

	/**
	 * Returns a shallow copy of this object.
	 * @return a shallow copy of this object.
	 */	
	public function clone() 
	{
		return new LinearQueue(_a) ;
	}

	/**
	 * Retrieves and removes the head of this queue.
	 * @return {@core true} if the head of this queue is removed.
	 */
	public function dequeue():Boolean 
	{
		return poll() != null  ;
	}
	
	/**
	 * Retrieves, but does not remove, the head of this queue.
	 * @return {@core true} if the head reference of this queue.
	 */
	public function element() 
	{
		return _a[0] ;
	}

	/**
	 * Inserts the specified element into this queue, if possible.
	 * @return {@code true} if the element is inserted in the queue.
	 */
	public function enqueue(o):Boolean 
	{
		if (o == undefined) return false ;
		_a.push(o) ;
		return true ;
	}

	/**
	 * Retrieves, but does not remove, the head of this queue, returning null if this queue is empty.
	 * @return {@core null} if the queue is empty else the head of the queue.
	 */
	public function peek() 
	{
		if (isEmpty()) 
		{
			return null ;
		}
		return _a[0] ;
	}

	/**
	 * Retrieves and removes the head of this queue.
	 * @return the head of the queue and removes this reference in the queue.
	 */
	public function poll() 
	{
		if (isEmpty()) 
		{
			return null ;
		}
		return _a.shift() ;
	}	

}